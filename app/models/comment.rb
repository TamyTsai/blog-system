# $ rails g model Comment user:references story:references content:text deleted_at:datetime:index

class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :story
end
