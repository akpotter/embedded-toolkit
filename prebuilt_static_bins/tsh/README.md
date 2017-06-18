## Changing the hardcoded secret without needing to rebuild

If you use these binaries "stock" then in theory anyone can access your instance of tshd due to the fact that the secret is embedded in the binary. To deal with this problem, use [https://github.com/mzpqnxow/embedded-toolkit/blob/master/src/tsh/splice_secret.sh](splice_secret.sh) to change the passphrase

## These aren't signed, I don't trust them

Well, even if I signed them, you don't know who I am, and I'm not going to a key-signing party any time soon. Use at your own risk.

## Backdoor bounty

If you can prove that these were backdoored by me (i.e. that they don't behave as the source code does in such a way that allows unauthorized access to the tshd system or client) then i will award you $10mm USD

