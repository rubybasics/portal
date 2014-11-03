require 'rails_helper'
require 'jsl/identity/test'

RSpec.describe SiteController, type: :controller do
  let(:user_repository) { Jsl::Identity::Mock::UserRepository.new }

  before do
    user_repository.will_find(Jsl::Identity::ResourceNotFound.new(Jsl::Identity::Mock::User, 'some-url'))
    controller.with_user_repository user_repository
  end

  specify 'root doesn\'t require login, renders some kind of success message' do
    response = get :root
    expect(response).to be_success
  end
end
