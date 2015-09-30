class UnitsController < ApplicationController
  load_and_authorize_resource except: :create
  def index
   @topic = Topic.find(params[:topic_id])
   @units = @topic.units.order('id ASC').includes(:user)
  end

  def new
    @topic = Topic.find(params[:topic_id])
    @unit = @topic.units.build
    1.times { @unit.contents.build }
  end

  def show
    @topic = Topic.find(params[:topic_id])
    @unit = @topic.units.find(params[:id])
    @contents = @unit.contents.order("created_at ASC").page(params[:page]).per(1)
  end

  def edit
    @topic = Topic.find(params[:topic_id])
    @unit = @topic.units.find(params[:id])
  end

  def create
    topic = Topic.find(params[:topic_id])
    @unit = topic.units.create(params_unit)
    @unit.user_id = current_user.id
    authorize! :create, @unit
    if @unit.save
      redirect_to topic_units_url, :notice => "Succesfully updated"
    else
      render action "new"
    end
  end

  def update
    topic = Topic.find(params[:topic_id])
    @unit = topic.units.find(params[:id])
    if @unit.update_attributes(params_unit)
      redirect_to topic_units_url, :notice => "successfully updated"
    else
      render action "edit"
    end
  end

  def destroy
    post = Topic.find(params[:topic_id])
    @unit = post.units.find(params[:id])
    @unit.destroy
    redirect_to (topic_units_url), :notice => "Successfully deleted"
  end

  private
  def params_unit
    params.require(:unit).permit(:content, :contents_attributes => [:id, :title, :body, :_destroy])
  end
end
