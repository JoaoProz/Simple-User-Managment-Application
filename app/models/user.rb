# frozen_string_literal: true

# User model
class User < ApplicationRecord
  validates :name, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: { case_sensitive: false }
  validates :country, presence: true
end
