class CreateMyMails < ActiveRecord::Migration[5.1]
  def change
    create_table :my_mails do |t|
      t.string :title
      t.text :content
      t.jsonb :to_emails, :default => []
      t.string :status
      t.bigint :author_id

      t.timestamps null: false
    end
  end
end
