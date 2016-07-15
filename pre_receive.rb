#!/usr/bin/env ruby

$stdout.sync = true

# Read STDIN (Format: "old_rev new_rev branch_name")
old_rev, new_rev, branch_name = ARGF.read.split(" ")

unless branch_name =~ /master$/ #
  puts "Received branch: #{branch_name}, skipping Kontena build."
  exit
end

repository_name = File.basename(File.expand_path("."))
deploy_to_dir = File.expand_path('./.deploy')
Dir.mkdir(deploy_to_dir) unless Dir.exist?(deploy_to_dir)

%x(GIT_WORK_TREE="#{deploy_to_dir}" git checkout -f #{new_rev} > '/dev/null' 2>&1)
Dir.chdir(deploy_to_dir)

kontena_yaml = [
  "kontena-build.yml",
  "kontena.#{repository_name}.yml",
  "kontena.yml"
].find { |yaml| File.exist?("./#{yaml}") }

abort("Could not detect kontena.yml file. Aborting push.") unless kontena_yaml

puts "Using file #{kontena_yaml} to build."

if system('kontena', 'app', 'build', '-f', kontena_yaml)
  puts "Successfully built #{kontena_yaml}."
else
  abort("Error when building application. Aborting push.")
end
