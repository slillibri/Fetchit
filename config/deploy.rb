set :application, "Fetchit"
set :repository,  "git://github.com/slillibri/Fetchit.git"

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
set :deploy_to, "/var/www"
set :use_sudo, true

role :web, "96.126.103.159"                          # Your HTTP server, Apache/etc
role :app, "96.126.103.159"                          # This may be the same as your `Web` server
role :db,  "96.126.103.159", :primary => true # This is where Rails migrations will run

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :deploy do
	## fix the start/stop/restart to work with unicorn_rails
	task :stop do; end
	task :start do; end
	task :restart do; end
end
# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end
