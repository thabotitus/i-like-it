class Api::ApiController < ApplicationController
  before_action :authenticate_token
  protect_from_forgery with: :null_session


  def total_likes
    begin
      user = User.find_by_api_token(params[:api_token])
      content = LikeableContent.find_by_identifier(params[:identifier])

      render_not_found unless user_owns_content?(content, user)

      total_likes_count = content.likes.count
      render json: {total_likes: total_likes_count}, status: 200
    rescue
      render_not_found
    end
  end

  def create_like
    begin
      user = User.find_by_api_token(params[:api_token])
      content = LikeableContent.find_by_identifier(params[:identifier])

      render_not_found unless user_owns_content?(content, user)

      content.likes.create
      total_likes_count = content.likes.count

      render json: {total_likes: total_likes_count}, status: 200
    rescue
      render_not_found
    end
  end

  private

  def render_not_found
    render json: {error: 'Invalid Request Data'}, status: 404
  end

  def valid_user?(api_token)
    return true if User.find_by_api_token(params[:api_token])
  end

  def authenticate_token
    render_not_found unless valid_user?(params[:api_token])
  end

  def user_owns_content?(content, user)
    content.user_id == user.id
  end
end