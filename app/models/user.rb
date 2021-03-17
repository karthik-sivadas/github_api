# frozen_string_literal: true
class User < ApplicationRecord
  has_many :repositories

  validates :name, :github_id, presence: true
end
