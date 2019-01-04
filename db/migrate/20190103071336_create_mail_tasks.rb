class CreateMailTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :mail_tasks do |t|
      t.references :my_mail
      t.string :to_email
      t.string :status
      t.integer :retry_limit
      
      t.timestamps null: false
    end
  end
end
