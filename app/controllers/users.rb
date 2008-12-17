class Users < Application
  # before :ensure_authenticated, :exclude => [ :new, :create ]
  # provides :xml, :yaml, :js

  def index
    @users = User.all
    display @users
  end

  def show(id)
    @user = User.get(id)
    raise NotFound unless @user
    display @user
  end

  def new
    only_provides :html
    @user = User.new
    display @user
  end

  def edit(id)
    only_provides :html
    @user = User.get(id)
    raise NotFound unless @user
    display @user
  end

  def create(user)
    @user = User.new(user)
    if @user.save
      session.user = @user  # Automatically login user after creation.
      redirect resource(@user), 
        :message => {
          :success => "Registration was successful.",
          :notice => "You are now logged in."
        }
    else
      message[:error] = "Error while creating your account."
      render :new, :status => 422
    end
  end

  def update(id, user)
    @user = User.get(id)
    raise NotFound unless @user
    if @user.update_attributes(user)
       redirect resource(@user)
    else
      display @user, :edit
    end
  end

  def destroy(id)
    @user = User.get(id)
    raise NotFound unless @user
    if @user.destroy
      redirect resource(:users)
    else
      raise InternalServerError
    end
  end

end # Users
