class AuthController < ApplicationController
  skip_before_action :verify_authenticity_token

  before_action :authorize_request, only: [:validate_token, :refresh_token, :secure_data]


  def register
    @user = User.new(user_params)
    if @user.save
      token = encode_token({ user_id: @user.id })
      refresh_token = encode_refresh_token({ user_id: @user.id })
      render json: { token: token, refresh_token: refresh_token }, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    @user = User.find_by(email: params[:email])
    if @user&.authenticate(params[:password])
      token = encode_token({ user_id: @user.id })
      refresh_token = encode_refresh_token({ user_id: @user.id })
      render json: { token: token, refresh_token: refresh_token }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  def validate_token
    render plain: 'HTTP 200 OK', status: :ok
  end

  def refresh_token
    refresh_token = request.headers['Authorization']&.split(' ')&.last
    begin
      decoded = JWT.decode(refresh_token, 'your_secret_key')[0]
      @current_user = User.find(decoded['user_id'])
      new_token = encode_token({ user_id: @current_user.id })
      new_refresh_token = encode_refresh_token({ user_id: @current_user.id })
      render json: { token: new_token, refresh_token: new_refresh_token }, status: :ok
    rescue ActiveRecord::RecordNotFound, JWT::DecodeError
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  def secure_data
    render json: { data: 'This is secure data' }, status: :ok
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

  def user_params
    params.permit(:email, :password, :password_confirmation)
  end

  def encode_token(payload)
    JWT.encode(payload, 'your_secret_key', 'HS256')
  end

  def encode_refresh_token(payload)
    JWT.encode(payload, 'your_secret_key', 'HS256')
  end
end
