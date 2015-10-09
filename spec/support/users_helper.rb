require 'jsl/identity/test'

module UsersHelper
  extend self

  def user_for(overrides)
    Jsl::Identity::Mock::User.factory(overrides)
  end

  def im_an_admin!
    login_as default_admin
  end

  def default_admin
    @default_admin ||= user_for name: 'Lovisa', is_admin: true
  end

  def login_as(user)
    allow_any_instance_of(ApplicationController)
      .to receive(:current_user)
      .and_return( user)
  end
end
