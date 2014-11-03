class SiteController < ApplicationController
  skip_before_filter :require_login
  skip_before_filter :require_invitation_or_admin

  def root
    render text: 'Coming soon (hopefully :)'
  end
end
