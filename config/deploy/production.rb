set :stage, :production
set :rails_env, 'production'
set :branch, 'master'
set :normalize_asset_timestamps, %{public/images public/javascripts public/stylesheets}
set :bundle_without, %w{development test}.join(' ')
set :ssh_options, { port: 3022 }

server 'gate.appengine.flow.ch', user: '21470-2514', roles: %w{web app db}
