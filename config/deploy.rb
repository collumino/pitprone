lock '3.0.1'

set :application, 'pitprone'
set :repo_url, 'git@github.com:collumino/pitprone.git'

set :deploy_to, '/var/www/webroot/ROOT'
set :scm, :git
set :format, :pretty
set :log_level, :debug
set :pty, true

set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')
set :linked_dirs, %w{ public/pitprone }

set :keep_releases, 5

namespace :deploy do
  desc 'Creating symlink'
  task :symlink do
      # on roles(:app) do
      #     execute :rm, "-rf /var/www/webroot/ROOT"
      #     execute :ln, "-s /var/www/webroot/current /var/www/webroot/ROOT"
      # end
  end

  desc 'Restart nginx and create symlink'
  task :restart do
    on roles(:app, :web) do
      execute '/opt/repo/bin/control restart'
    end
  end
  before :restart, :symlink
end

after 'deploy:publishing', 'deploy:restart'
