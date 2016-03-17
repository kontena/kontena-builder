#!/usr/bin/env ruby

# Read STDIN (Format: "from_commit to_commit branch_name")
from, to, branch = ARGF.read.split " "

if (branch =~ /master$/) == nil
    puts "Received branch #{branch}, not deploying."
    exit
end

deploy_to_dir = File.expand_path('./.deploy')
unless Dir.exist?(deploy_to_dir)
  Dir.mkdir(deploy_to_dir)
end
%x(GIT_WORK_TREE="#{deploy_to_dir}" git checkout -f master)

Dir.chdir(deploy_to_dir)
if File.exist?('./kontena-build.yml')
  exec 'kontena', 'app', 'build', '-f', 'kontena-build.yml'
else
  exec 'kontena', 'app', 'build'
end
