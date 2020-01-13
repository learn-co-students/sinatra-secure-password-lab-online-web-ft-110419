class Createusers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |c|
      c.string :username
      c.string :password_digest
    end
  end
end
# Note that even though our database has a column called password_digest, 
# we still access the attribute of password. 
# This is given to us by has_secure_password
