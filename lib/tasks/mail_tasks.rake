namespace :run do
  desc 'running mail tasks'
  task :mail_tasks => [:environment] do
    MailTask.run
  end
end