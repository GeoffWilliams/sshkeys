sh /testcase/spec/acceptance/setup.sh
puppet resource user eve ensure=present
mkdir /home/eve/.ssh -p
touch /home/eve/.ssh/id_rsa
touch /home/eve/.ssh/id_rsa.pub
touch /home/eve/.ssh/zoe@localhost
touch /home/eve/.ssh/zoe@localhost.pub
