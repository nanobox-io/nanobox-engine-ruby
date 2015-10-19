echo running tests for ruby
UUID=$(cat /proc/sys/kernel/random/uuid)

pass "unable to start the $VERSION container" docker run --privileged=true -d --name $UUID nanobox/build-ruby sleep 365d

defer docker kill $UUID

pass "unable to create code folder" docker exec $UUID mkdir -p /opt/code

fail "Detected something when there shouldn't be anything" docker exec $UUID bash -c "cd /opt/engines/ruby/bin; ./sniff /opt/code"

pass "Failed to create code directory" docker exec $UUID mkdir -p /opt/code

pass "Failed to create Gemfile" docker exec $UUID bash -c "echo -e \"source 'https://rubygems.org'\n\ngem 'sinatra'\ngem 'puma'\" > /opt/code/Gemfile"

pass "Failed to detect Ruby" docker exec $UUID bash -c "cd /opt/engines/ruby/bin; ./sniff /opt/code"