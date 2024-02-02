# frozen_string_literal: true

# spec/controllers/users_controller_spec.rb

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end

    it 'returns a JSON response with all users' do
      user = create(:user)
      get :index
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq([JSON.parse(user.to_json)])
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      user = create(:user)
      get :show, params: { id: user.to_param }
      expect(response).to be_successful
    end

    it 'returns a JSON response with the user' do
      user = create(:user)
      get :show, params: { id: user.to_param }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq(JSON.parse(user.to_json))
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new user' do
        expect do
          post :create, params: { user: attributes_for(:user) }
        end.to change(User, :count).by(1)
      end

      it 'returns a JSON response with the new user and status :created' do
        post :create, params: { user: attributes_for(:user) }
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).to eq(JSON.parse(User.last.to_json))
      end
    end

    context 'with invalid parameters' do
      it 'returns a JSON response with errors and status :unprocessable_entity' do
        correct_hash = { 'name' => '', 'email' => '', 'country' => '' }
        post :create, params: { user: { name: nil, email: nil, country: nil } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to_not eq(correct_hash)
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid parameters' do
      it 'updates the requested user' do
        user = create(:user)
        new_attributes = attributes_for(:user, name: 'Updated Name')
        patch :update, params: { id: user.to_param, user: new_attributes }
        user.reload
        expect(user.name).to eq('Updated Name')
      end

      it 'returns a JSON response with the updated user' do
        user = create(:user)
        new_attributes = attributes_for(:user, name: 'Updated Name')
        patch :update, params: { id: user.to_param, user: new_attributes }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq(JSON.parse(user.reload.to_json))
      end
    end

    context 'with invalid parameters' do
      it 'returns a JSON response with errors and status :unprocessable_entity' do
        correct_hash = { 'name' => '', 'email' => '', 'country' => '' }
        user = create(:user)
        patch :update, params: { id: user.to_param, user: { name: nil, email: nil, country: nil } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to_not eq(correct_hash)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested user' do
      user = create(:user)
      expect do
        delete :destroy, params: { id: user.to_param }
      end.to change(User, :count).by(-1)
    end
  end
end
