namespace :run do
  desc 'running mail tasks'
  task :mail_tasks => [:environment] do
    puts "  INFO - #{Time.now.strftime('%F %T')} running mail tasks"
    MailTask.run
  end
end