#!/usr/bin/env ruby
STDOUT.sync = true

STDOUT.sync = true

# Read STDIN (Format: "from_commit to_commit branch_name")
from, to, branch = ARGF.read.split " "

unless branch =~ /master$/
  puts "Received branch #{branch}, not deploying."
  exit
end

repository_name = File.basename(File.expand_path("."))

deploy_to_dir = File.expand_path('./.deploy')
Dir.mkdir(deploy_to_dir) unless Dir.exist?(deploy_to_dir)

%x(GIT_WORK_TREE="#{deploy_to_dir}" git checkout -f master)

Dir.chdir(deploy_to_dir)

kontena_yaml = [
  "kontena-build.yml",
  "kontena.#{repository_name}.yml",
  "kontena.yml"
].find { |yaml| File.exist?("./#{yaml}") }

puts "Using file #{kontena_yaml} to build."
build_was_successful = system('kontena', 'app', 'build', '-f', kontena_yaml)

unless build_was_successful
  # TODO: Reset repository HEAD to previous successfull push
  puts "Error when building application. Aborting push."
  exit -1
end
