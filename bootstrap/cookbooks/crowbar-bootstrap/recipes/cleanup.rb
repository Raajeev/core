[
 "/root/.ssh",
 "/home/crowbar/.ssh",
 "/var/cache/crowbar/rails-cache",
 "/var/log/crowbar",
 "/var/cache/yum",
 "/var/cache/apt/archives",
].each do |target|
  directory target do
    action :delete
    recursive true
  end
end

service "postgresql" do
  action :stop
end

["/etc/environment","/etc/yum.conf"].each do |f|
  next unless File.file?(f)
  bash "Clean proxies from #{f}" do
    code "grep -v proxy '#{f}' > '#{f}.cleaned'; rm '#{f}'; mv '#{f}.cleaned' '#{f}'"
  end
end

file "/etc/profile.d/proxy.sh" do
  action :delete
end

bash "Clean up history files" do
  code "find / -type f -name '.*history' -delete"
end
