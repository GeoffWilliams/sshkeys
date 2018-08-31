# install SSH server and a known set of SSH keys for the host and root user
# so that we can populate keys with known secrets for testing
if [ -f /usr/bin/apt ] ; then
    apt update
fi
puppet resource package openssh-server ensure=present
mkdir -p /root/.ssh
cp /testcase/spec/mock/keys/root/id_rsa /root/.ssh
cp /testcase/spec/mock/keys/root/id_rsa.pub /root/.ssh
cp /testcase/spec/mock/keys/known_hosts /root/.ssh

chmod 0700 /root
chmod 0700 /root/.ssh
chmod 0600 /root/.ssh/id_rsa

cp /testcase/spec/mock/keys/host/* /etc/ssh/
chmod 0600 /etc/ssh/*_key

awk '/pam_nologin.so/ {$0 = "#" $0}{print}' /etc/pam.d/sshd > /etc/pam.d/sshd.tmp && \
    /bin/mv /etc/pam.d/sshd.tmp /etc/pam.d/sshd
systemctl restart sshd