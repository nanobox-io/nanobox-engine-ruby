echo running tests for ruby
UUID=$(cat /proc/sys/kernel/random/uuid)

pass "unable to start the $VERSION container" docker run --privileged=true -d --name $UUID nanobox/build-ruby sleep 365d

defer docker kill $UUID

pass "create db dir for pkgsrc" docker exec $UUID mkdir -p /data/var/db

pass "create dir for environment variables" docker exec $UUID mkdir -p /data/etc/env.d 

pass "Failed to update pkgsrc" docker exec $UUID /data/bin/pkgin up -y

pass "Failed to create code directory" docker exec $UUID mkdir -p /opt/code

pass "Failed to create Gemfile" docker exec $UUID bash -c "echo -e \"source 'https://rubygems.org'\n\ngem 'sinatra'\ngem 'puma'\" > /opt/code/Gemfile"

pass "Failed to run prepare script" docker exec $UUID bash -c "cd /opt/engines/ruby/bin; PATH=/data/sbin:/data/bin:\$PATH ./prepare '$(payload default-prepare)'"