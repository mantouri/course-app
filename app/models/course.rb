# frozen_string_literal: true

class Course < ApplicationRecord
  belongs_to :user
  validates :title, presence: true
end
