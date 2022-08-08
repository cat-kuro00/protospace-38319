class PrototypesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :destroy]

  def index
    @prototypes = Prototype.all
  end

  def new
    @prototype=Prototype.new
  end

  def create
    if Prototype.create(prototype_params)
      redirect_to new_prototype_path
    else
      render :new
    end
  end

  def show
    @prototype = Prototype.find(params[:id])
    @user = User.find(params[:id])
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
  end

  def edit
    unless user_signed_in?
      redirect_to action: :index
    else
      @prototype = Prototype.find(params[:id])
    end
  end

  def update
    prototype = Prototype.find(params[:id])
    prototype.update(prototype_params)
    if prototype.save
      redirect_to prototype_path
    else
      render :edit
    end
  end

  def destroy
    prototype = Prototype.find(params[:id])
    prototype.destroy
    redirect_to root_path
  end

end

private

def prototype_params
  params.require(:prototype).permit(:title, :image, :catch_copy, :concept).merge(user_id: current_user.id)
end