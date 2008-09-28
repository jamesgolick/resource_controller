namespace :db do
  task :abort_if_pending_migrations => ['db:drop', 'db:migrate']
end