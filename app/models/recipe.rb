# class Recipe < ApplicationRecord
#   belongs_to :user
#   has_many :reviews
#   has_many :reviewers, through: :reviews, source: :user #自己命名
#   has_many :users, through: :reviews
# end

# has_many :objects_table, through: :join_association_table

# has_many :objects, through: :join_association, source: :join_association_table_foreign_key_to_objects_table
