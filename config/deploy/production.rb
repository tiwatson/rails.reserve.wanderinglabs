set :stage, :production
server "192.34.56.219", user: "deploy", roles: %w{app db web}
role :app, %w{deploy@192.34.56.219}
role :web, %w{deploy@192.34.56.219}
role :db,  %w{deploy@192.34.56.219}

# role :resque_worker, %w{deploy@192.34.56.219}
# role :resque_scheduler, %w{deploy@192.34.56.219}

# set :workers, { "scrape" => 1 }
