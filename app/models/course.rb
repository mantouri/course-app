# frozen_string_literal: true

class Course < ApplicationRecord
  validates :title, presence: true
end
