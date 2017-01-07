class DashboardController < ApplicationController
  before_action :authenticate_user!
  def index
    @content = current_user.likeable_contents
  end
end
