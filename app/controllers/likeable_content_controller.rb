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

  private

  def content_params
    params.require(:likeable_content).permit(:id, :title, :description)
  end

  def authorised_content(content)
    content.user_id == current_user.id
  end
end
