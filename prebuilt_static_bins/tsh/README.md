## Behavior/configuration

This was built to listen on port 9999. If you want to change that, see the last note. It doesn't require any arguments and will not emit any output. It will silently background.

## Changing the hardcoded secret without needing to rebuild

If you use these binaries "stock" then in theory anyone can access your instance of tshd due to the fact that the secret is embedded in the binary. To deal with this problem, use [https://github.com/mzpqnxow/embedded-toolkit/blob/master/src/tsh/splice_secret.sh](splice_secret.sh) to change the passphrase. Unfortunately, this script isn't exactly user-friendly. In a nutshell, all it does is replace a 'default' password in the tsh and tshd binaries with a new password. The password must not contain NULL bytes, and the new password must/will be the same length as the default password. The default password these were built with is 'DEFAULTDEFAULTDEFAULTDEFAULTDEF\0'

## These aren't signed, I don't trust them

Well, even if I signed them, you don't know who I am, and I'm not going to a key-signing party any time soon. Use at your own risk.

## Backdoor bounty

If you can prove that these were backdoored by me (i.e. that they don't behave as the source code does in such a way that allows unauthorized access to the tshd system or client) then i will award you $10mm USD

## Changing default cb ip or listening port

Yeah, well, sorry, you're stuck with the port unless you have the (not all that difficult) skill of finding the hardcoded integer (or immediate in the asm instruction, objdump -d is your friend) and replacing it yourself. I'll give you a script for that if you want..
