#!/bin/bash
#
# splice_secret.sh (C) 2016 copyright@mzpqnxow.com under GPLv2
# -- please see LICENSE/LICENSE.md for more details on GPLv2
#
# This is a utility meant to be used on statically linked binaries for which
# there is not a toolchain readily available. Because the passphrase by design
# is hardcoded into the server, this tool just does an overengineered replace
# of the secret without requiring a user to break out the entire toolchain
# and recompile the tshd binary. The tool also remains as it originally was in
# that it does not allow one to specify parameters on the commandline of the
# server. This is intentional and philosophical choice. It has its benefits
# and its drawbacks
#
# If your system is really stupid, you can fix the PATH or fix individual
# binary locations. There are no dependencies here that can really be considered
# third party, it uses entirely standard UNIX shell utilities, for portability.
# The side effect is that it gets a little ugly for something that is essentially
# a glorified sed
#
# The point of this script is to hack a passphrase into a prebuilt tsh/tshd
# binaries that have already been built, and are not easy to rebuild
#
# Ideally, one would have one tsh/tshd for every architecture, ABI, endianness,
# OS, OS version, etc. statically linked with some libc such as musl libc that
# allows static linking without breaking nsswitch.conf based lookups.. Each of
# these "golden" copies would have some default password, and it would be left
# in tsh.h. These "golden" copies would not ever actually be used, but would
# server as the template for this tool
#
# Before deploying and using tshd/tsh, you would use this tool to splice a new
# password into the binary, without using any tools that could be a problem
# with obscure CPU architectures. This could be done much more simply in a
# language such as Python, but the aim was to be more portable and rely only
# on standard shell utilities, regardless of how ugly things got
#
# For this to work, you will need the following:
#
# 1- A "golden" build of tsh/tshd for the architecture you intend to run tshd on
# 2- The original tsh.h file for these two "golden" build files, or the ability
#    to recreate it (you need the `secret` from tsh.h and it needs to be in the
#    format that I have changed it to- a fixed size character array, initialized
#    at compile time
# 3- The standard shell utilities listed below:
#   - chmod, dd, xxd, mktemp, wc, cut, cat, grep, rm, date, cp, dirname
#
# To use the tool, you would have the "golden" builds named "tsh" and "tshd"
# already built along with the tsh.h header. You would then simply run:
#
# ./splice_password.sh <some_new_password_to_use>
#
# This should go through the steps of splicing in your new password to both tsh
# and tshd so they can be used without needing to be compiled again. For x86
# and other commodity architectures, this isn't very useful because recompiling
# is trivial and quick. However, for those architectures which require custom
# toolchains and musl libc for basic things like gethostbyname() etc. to work
# correctly, this is a nice timesaver if you would like to have tshd deployed
# on more than one machine and don't want to use the same password, especially
# across different security domains / levels of trust/privilege
#
# Another much easier approach would have been to leave the `secret` symbol in
# at build-time, and use that to identify the `secret` byte, and then strip the
# symbols after, but that has the disadvantage of requiring an a toolchain for
# for the target platform
#
# In case you're not getting it, This is really meant for use on obscure embedded
# devices where you can't rely on standard versions of glibc, uClibc or any other
# libc and you want to use musl libc statically linked executables
#
# I'm sorry that this is poorly written. If you use it as described, you should
# not encounter any problems but if things break, you're on your own.
#
# YMMV
#
# I'll take pull requests but a lot of this cruft was done for specific reasons
#
PATH=/bin:/usr/bin:/usr/sbin:/sbin:/usr/local/bin:/opt/bin
CHMOD="$(which chmod)"
DD="$(which dd)"
MKTEMP="$(which mktemp)"
WC="$(which wc)"
CUT="$(which cut)"
CAT="$(which cat)"
GREP="$(which grep)"
RM="$(which rm)"
DATE="$(which date)"
CP="$(which cp)"
DIRNAME="$(which dirname)"

NEW=$($DATE +%Y%m%d-%H%m%S)

TSH=tsh
TSHD=tshd

TSH_NEW="$TSH.$NEW"
TSHD_NEW="$TSHD.$NEW"
NEW_NOTES="README.$NEW"
TSH_HEADER="tsh.h"

ZERO=/dev/zero

$CHMOD 700 .
umask 022

function fatal() {
    echo "FATAL: $1"
    exit $2
}

function prereq() {
    echo '[+] Checking for basic system tools ...'
    for TOOL in $CHMOD $DD $MKTEMP $WC $CUT $CAT $GREP $RM $DATE $CP $DIRNAME
    do
        [[ -x "$TOOL" ]] || fatal "$TOOL is not found in your PATH" 42
    done
    echo '  [*] Done'
    echo '[+] Checking for prebuilt tsh/tshd and tsh header with secret ...'
    for tsh_file in $TSH $TSHD $TSH_H
    do
        [[ -e $TSH ]] || fatal 'tsh must already be built'
    done
    echo '  [*] Done'
}

function pad_null() {
    TMP_RAW_FILE='pass.raw'
    ARG_INSTRING="$1"
    SECRET_MAXLEN="$2"
    ARG_INSTRING_LEN=$(echo -n "$ARG_INSTRING" | $WC -c)
    if [ "$ARG_INSTRING_LEN" -gt "$SECRET_MAXLEN" ]; then
        fatal "FATAL: Password is too long, must be <= ${SECRET_MAXLEN} bytes !!" 42
    fi
    PAD_BYTES=$(echo $[$SECRET_MAXLEN-$ARG_INSTRING_LEN])
    WORKDIR=$($MKTEMP -p "$PWD" -d)
    pushd "$WORKDIR" 2>&1 >/dev/null
    echo -n "$ARG_INSTRING" > "$TMP_RAW_FILE"
    $DD status=none if="$ZERO" of="$TMP_RAW_FILE" count="$PAD_BYTES" bs=1 conv=notrunc oflag=append || fatal "dd failed in pad_null" 42
    popd 2>&1 >/dev/null
    echo "$WORKDIR/$TMP_RAW_FILE"
    return
}

function usage() {
    echo "Usage:"
    echo "  $0 <new password>"
}

function main() {
    if [ "$#" -ne 1 ]; then
        usage "$0"
    fi

    NEW_PASSWORD="$2"
    echo "[+] Splicing new password $NEW_PASSWORD into tsh/tshd binaries ..."

    # ORIGINAL_PASSWORD=$($CAT $TSH_HEADER | $GREP secret | $CUT -d '"' -f 2)
    # The builds in the embedded-toolkit repository used the following as the default secret
    ORIGINAL_PASSWORD='DEFAULTDEFAULTDEFAULTDEFAULTDEF'
    SECRET_MAXLEN=$(echo "$ORIGINAL_PASSWORD" | $WC -c | $CUT -d ' ' -f 1)
    SECRET_MAXLEN="$[$SECRET_MAXLEN-1]"
    echo "[+] Determined from tsh.h a maximum secret size of ${SECRET_MAXLEN} bytes ..."

    PADDED_PASSWORD_FILE=$(pad_null "$NEW_PASSWORD" "$SECRET_MAXLEN")
    echo "[+] Built a NULL padded buffer of $SECRET_MAXLEN bytes containing new password ..."

    ORIGINAL_PASSWORD="$($CAT $TSH_HEADER | $GREP 'secret' | $CUT -d '"' -f 2)"
    echo "[+] Grabbed the 'base' original password from the header file ..."

    echo "[+] Making sure base binaries $TSH and $TSHD were built from this tsh.h file ..."
    $GREP "$ORIGINAL_PASSWORD" $TSHD 2>&1 >/dev/null || fatal "password in $TSH_H does not match password in $TSHD binary. Cannote perform replacement" 42
    $GREP "$ORIGINAL_PASSWORD" $TSH 2>&1 >/dev/null || fatal "password in $TSH_H does not match password in $TSH binary. Cannot perform replacement" 42

    TSH_PASS_OFFSET=$($GREP --byte-offset --only-matching --text "$ORIGINAL_PASSWORD" $TSH) || fatal "$TSH_H does not seem to match $TSH binary ..." 42
    TSH_PASS_OFFSET=$(echo $TSH_PASS_OFFSET | $CUT -d ':' -f 1)  || fatal "Bad output when parsing grep output from $TSH" 42
    printf "[*] Successfully found secret @ file offset 0x%x in $TSH\n" "$TSH_PASS_OFFSET"
    echo "[+] Performing splice of new password into $TSH_NEW .."
    $CP $TSH $TSH_NEW
    $DD status=none if="$PADDED_PASSWORD_FILE" of="$TSH_NEW" bs=1 seek="$TSH_PASS_OFFSET" conv=notrunc || fatal "$DD failed in tsh new" 42
    echo "  [*] Done, created $TSH_NEW for deployment!"
    TSHD_PASS_OFFSET=$($GREP --byte-offset --only-matching --text "$ORIGINAL_PASSWORD" $TSHD) || fatal "$TSH_H does not seem to match $TSHD binary ..." 42
    TSHD_PASS_OFFSET=$(echo $TSHD_PASS_OFFSET | $CUT -d ':' -f 1) || fatal "Bad output when parsing grep output from $TSHD" 42
    printf "[*] Successfully found secret @ file offset 0x%x in $TSHD\n" "$TSHD_PASS_OFFSET"
    echo "[+] Performing splice of new password into $TSHD_NEW .."
    $CP $TSHD $TSHD_NEW
    $DD status=none if="$PADDED_PASSWORD_FILE" of="$TSHD_NEW" bs=1 seek="$TSHD_PASS_OFFSET" conv=notrunc || fatal "$DD failed in tshd new"
    echo "  [*] Done, created $TSHD_NEW for deployment"
    TMP_DIRECTORY=$($DIRNAME $PADDED_PASSWORD_FILE)
    $RM -I -rf "$TMP_DIRECTORY"
    echo "The default password has been changed to the new password on both tsh and tshd"
    echo "The password for $TSH_NEW/$TSHD_NEW is $NEW_PASSWORD" > $NEW_NOTES
    #echo "Please see $TSH_NEW / $TSHD_NEW / $NEW_NOTES"
    echo
    return
}

main $0 $1 $2
