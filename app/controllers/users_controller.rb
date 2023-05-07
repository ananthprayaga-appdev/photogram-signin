class UsersController < ApplicationController
  def index
    @users = User.all.order({ :username => :asc })

    render({ :template => "users/index.html" })
  end

  def sign_up
    render({ :template => "users/signup.html.erb" })
  end

  def sign_in
    render({ :template => "users/signin.html.erb" })
  end

  def authenticate
    un = params.fetch("input_username")
    pw = params.fetch("input_password")

    user = User.where({ :username => un }).at(0)

    if user == nil
      redirect_to("/user_sign_in", { :alert => "No one around here with that name" })
    else
      if user.authenticate(pw)
        session.store(:user_id, user.id)
        redirect_to("/", { :notice => "Welcome back, " + user.username + "!" })
      else
        redirect_to("/user_sign_in", { :alert => "Nice try, sucker!" })
      end
    end
  end

  def sign_out
    reset_session
    redirect_to("/", { :notice => "See you later" })
  end

  def show
    the_username = params.fetch("the_username")
    @user = User.where({ :username => the_username }).at(0)

    render({ :template => "users/show.html.erb" })
  end

  def create
    user = User.new

    user.username = params.fetch("input_username")
    user.password = params.fetch("input_password")
    user.password_confirmation = params.fetch("input_password_confirmation")

    save_status = user.save

    if save_status == true
      session.store(:user_id, user.id)
      redirect_to("/users/#{user.username}", { :notice => "Welcome, " + user.username + " !" })
    else
      redirect_to("/user_sign_up", { :alert => user.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("the_user_id")
    user = User.where({ :id => the_id }).at(0)

    user.username = params.fetch("input_username")

    user.save

    redirect_to("/users/#{user.username}")
  end

  def destroy
    username = params.fetch("the_username")
    user = User.where({ :username => username }).at(0)

    user.destroy

    redirect_to("/users")
  end
end
