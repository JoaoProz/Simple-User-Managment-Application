# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }

    it { should validate_presence_of(:country) }

    it { should allow_value('user@example.com').for(:email) }
    it { should allow_value('user+name@example.co.uk').for(:email) }
    it { should_not allow_value('invalid_email').for(:email) }

    it { should validate_uniqueness_of(:email).case_insensitive }
  end
end
