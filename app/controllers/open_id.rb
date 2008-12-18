class OpenId < Application
  before :ensure_authenticated, :with => %w[ Basic::OpenID ]

  def login
    # if the user is logged in, then redirect them to their profile
    redirect resource(session.user), :message => { :notice => 'You are now logged in' }
  end
end