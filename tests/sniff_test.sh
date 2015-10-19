echo running tests for ruby
UUID=$(cat /proc/sys/kernel/random/uuid)

pass "unable to start the $VERSION container" docker run --privileged=true -d --name $UUID nanobox/build-ruby sleep 365d

defer docker kill $UUID

pass "unable to create code folder" docker exec $UUID mkdir -p /opt/code

fail "Detected something when there shouldn't be anything" docker exec $UUID bash -c "cd /opt/engines/ruby/bin; ./sniff /opt/code"

pass "Failed to inject ruby file" docker exec $UUID touch /opt/code/index.ruby

pass "Failed to detect PHP" docker exec $UUID bash -c "cd /opt/engines/ruby/bin; ./sniff /opt/code"