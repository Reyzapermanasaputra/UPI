class UsersController < ApplicationController
  autocomplete :user, :name, :full => true
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, except: [:show, :update]
  load_and_authorize_resource except: [:show, :following, :followers]
  # GET /users
  # GET /users.json
  def index
    if params[:search]
      @users = User.search(params[:search]).order('created_at DESC')
    else
      @user = User.all
    end
  end

  def search_user
    @users = User.search(params[:search]).order('created_at DESC')
    user = @users.map{|x| x.id}
    puts '*' * 50
    puts user
    puts '*' * 50
    @user = User.find(user)
    redirect_to user_url(@user)
  end

  def add_room
    @user = User.find(params[:id])
    @classrooms = Classroom.where(:id=> params[:adding_class])
    @user.classrooms.destroy_all
    @user.classrooms << @classrooms
    redirect_to action: "show"
  end

  # GET /users/1
  # GET /users/1.json
  def show
      @user = User.find(params[:id])
      @room = @user.classrooms
      @microposts = @user.microposts.order('created_at DESC')
      @joined_on = @user.created_at.to_formatted_s(:short)
      if @user.current_sign_in_at
        @last_login = @user.current_sign_in_at.to_formatted_s(:short)
      else
        @last_login = "never"
      end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    @user = User.find(params[:id])
    @classrooms = Classroom.where(:id => params[:adding_class])
    @user.classrooms.destroy_all
    @user.classrooms << @classrooms

    if user_params[:password].blank?
    user_params.delete(:password)
    user_params.delete(:password_confirmation)
  end

  successfully_updated = if needs_password?(@user, user_params)
                           @user.update(user_params)
                         else
                           @user.update_without_password(user_params)
                         end
    respond_to do |format|
      if successfully_updated
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def following
    @title = "Following"
    @user = User.find_by_id(params[:id])
    @users = @user.followed_users
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find_by_id(params[:id])
    @users = @user.followers
    render 'show_follow'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :role_id, :photo, :identity, :phone, :address)
    end
  protected
    def needs_password?(user, params)
      params[:password].present?
    end
end
