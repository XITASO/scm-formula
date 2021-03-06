require "serverspec"

set :backend, :exec

describe service("scm-server") do
  it { should be_enabled }
  it { should be_running }
end

describe port("8080") do
  it { should be_listening }
end

describe port("8009") do
  it { should be_listening }
end

describe command("curl -L localhost:8080") do
  its(:stdout) { should match /SCM-Server/ }
end
