sh /testcase/spec/acceptance/setup.sh

mkdir -p /home/ingrid/.ssh/
echo "stale content" > /home/ingrid/.ssh/id_rsa
echo "stale content" > /home/ingrid/.ssh/id_rsa.pub
echo "stale content" > /home/ingrid/.ssh/known_hosts

mkdir -p /home/james/.ssh/
echo "preserve content" > /home/james/.ssh/id_rsa
echo "preserve content" > /home/james/.ssh/id_rsa.pub
echo "preserve content" > /home/james/.ssh/known_hosts