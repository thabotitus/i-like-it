class LikeableContentController < ApplicationController
  before_action :authenticate_user!

  def new
    @content = LikeableContent.new
  end

  def show
    @content = LikeableContent.find(params[:id])

    unless authorised_content(@content)
      @content = nil
      flash[:error] = 'Page Does Not Exist'
      redirect_to dashboard_index_path
    end
  end

  def create
    content = current_user.likeable_contents.create(content_params)

    if content.save
      flash[:success] = 'Content Saved'
      redirect_to likeable_content_path(content)
    else
      flash.now[:error] = 'Content Not Saved'
      render :new
    end
  end

  def update
    content = LikeableContent.find(params[:id])

    unless authorised_content(content)
      content = nil
      flash[:error] = 'Content Does Not Exist'
      redirect_to dashboard_index_path and return
    end

    if content.update_attributes(content_params)
      flash[:success] = 'Content Updated'
      redirect_to likeable_content_path(content)
    else
      flash[:error] = 'Content Not Updated'
      render :edit
    end
  end

  private

  def content_params
    params.require(:likeable_content).permit(:id, :title, :description)
  end

  def authorised_content(content)
    content.user_id == current_user.id
  end
end
