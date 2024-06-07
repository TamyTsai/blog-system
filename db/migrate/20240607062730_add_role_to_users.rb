# $ rails g migration add_role_to_users

class AddRoleToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :role, :integer, default: 0
    # 在 users資料表 增加 資料型態為整數 的 role欄位，該欄位預設值為0 
  end
end


# $ rails db:migrate
# == 20240607062730 AddRoleToUsers: migrating ===================================
# -- add_column(:users, :role, :integer, {:default=>0})
#    -> 0.0026s
# == 20240607062730 AddRoleToUsers: migrated (0.0027s) ==========================