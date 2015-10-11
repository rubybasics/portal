require 'jsl/identity/test'
require 'pp'

class DevelopmentController < ApplicationController
  skip_before_filter :require_login
  skip_before_filter :require_invitation_or_admin

  before_action do
    not_found! unless Rails.env.development?
  end

  def admin
    user_repository = Jsl::Identity::Mock::UserRepository.new
    user = Jsl::Identity::Mock::User.new.will_have_is_admin(true).will_have_name('Lovisa')
    session[:user_id] = user.id
    user_repository.will_find(user)
    Deject.register(:user_repository) { user_repository }
    redirect_to admin_path
  end

  def show_env
    render text: env.pretty_inspect
  end

  def show_session
    render text: session.to_hash.pretty_inspect
  end

  def show_user
    render text: current_user.inspect
  end

  def reset
    reset_session
    cookies.clear
    render text: 'Session and cookies should be clear'
  end

  def pry
    # response.stream.write 'Go to your server, a pry session awaits!'
    require 'pry'
    binding.pry
    # response.stream.write 'Pry sesion complete'
    render text: 'Pry Session Complete'
  end
end
