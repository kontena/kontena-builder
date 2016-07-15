#!/usr/bin/env ruby
command = ENV['SSH_ORIGINAL_COMMAND']
abort unless command

# check the supplied command contains a valid git action
valid_actions = ['git-receive-pack', 'git-upload-pack']
action = command.split[0]
abort unless valid_actions.include?(action)

if match = command.match(/^git-\w+-pack\s'([\w|-]+)'$/)
  repo_name = match[1]
else
  abort('invalid repo name')
end

unless Dir.exist?("./#{repo_name}")
  %x(git init --bare #{repo_name})
end

pre_receive_path = "./#{repo_name}/hooks/pre-receive"
File.write(pre_receive_path, File.read('pre-receive'))
File.chmod(0755, pre_receive_path)

exec 'git', 'shell', '-c', command
