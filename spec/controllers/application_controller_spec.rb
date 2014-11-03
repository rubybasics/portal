require 'rails_helper'
require 'jsl/identity/test'

RSpec.describe ApplicationController, type: :controller do
  controller ApplicationController do
    def index
      render text: current_user.name
    end
  end

  let(:username)        { 'THE USERS NAME' }
  let(:user)            { Jsl::Identity::Mock::User.factory name: username }
  let(:user_repository) { Jsl::Identity::Mock::UserRepository.new }

  before do
    user_repository.will_find(user)
    controller.with_user_repository user_repository
  end

  specify "Users must exist" do
    user_repository.will_have_login_url('http://example.com/login/path')
                   .will_find(Jsl::Identity::ResourceNotFound.new(user.class, 'some-url'))
    get :index
    expect(response).to be_a_redirect
    expect(response.location).to eq 'http://example.com/login/path'
  end

  specify "Users must be invited" do
    user.is_not_invited!
    get :index
    expect(response).to be_forbidden
    expect(response.body).to_not include username

    user.is_invited!
    get :index
    expect(response).to be_ok
    expect(response.body).to include username
  end

  specify 'Admin do not need to be invited' do
    user.is_not_invited!.is_admin = true
    get :index
    expect(response).to be_ok
    expect(response.body).to include username
  end
end
