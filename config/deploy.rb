# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'my_app_name'
set :repo_url, 'https://github.com/serggend/empty_app.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/#{user}/#{application}"
# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5
before "deploy:assets:precompile", "config_symlink"


namespace :deploy do
  sh 'unicorn -D -c /home/empty_app/my_app_name/current/config/unicorn.rb'
end

task :setup do
  sh "mkdir -p /home/empty_app/my_app_name/tmp"
  sh "mkdir -p /home/empty_app/my_app_name/shared"
  sh "chown -R empty_app:empty_app /home/empty_app/my_app_name/"
  sh "chmod -R 755 /home/empty_app/my_app_name/"
  sh "cp /home/empty_app/empty/config/database.yml #{deploy_to}/shared/database.yml"
end

task :config_symlink do
  sh "ln -nfs #{deploy_to}/shared/database.yml #{release_path}/config/database.yml"
end
