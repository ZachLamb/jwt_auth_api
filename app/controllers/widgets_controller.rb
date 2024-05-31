class WidgetsController < ApplicationController
  before_action :authorize_request

  def index
    @widgets = Widget.all
    render json: @widgets.select(:id, :name), status: :ok
  end

  private

  def authorize_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      decoded = JWT.decode(header, 'your_secret_key')[0]
      @current_user = User.find(decoded['user_id'])
    rescue ActiveRecord::RecordNotFound, JWT::DecodeError
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
end
