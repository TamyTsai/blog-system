# $ rails g model Comment user:references story:references content:text deleted_at:datetime:index

class Comment < ApplicationRecord
  belongs_to :user
  # 動態長出兩方法：user、user=
  belongs_to :story
end


