class UsersController < ApplicationController
  before_filter :require_user, only: [:show]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.valid?
      charge = charge_credit_card
      if charge.successful?
        @user.save
        handle_invitation
        AppMailer.send_welcome_email(@user).deliver
        session[:user_id] = @user.id
        redirect_to categories_path
      else
        flash[:error] = charge.error_message
        render :new
      end
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def new_with_invitation_token
    invitation = Invitation.where(token: params[:token]).first
    if invitation
      @user = User.new(email: invitation.recipient_email)
      @invitation_token = invitation.token
      render :new
    else
      redirect_to expired_token_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :full_name)
  end

  def handle_invitation
    if params[:invitation_token].present?
      invitation = Invitation.where(token: params[:invitation_token]).first
      @user.follow(invitation.inviter)
      invitation.inviter.follow(@user)
      invitation.update_column(:token, nil)
    end
  end

  def charge_credit_card
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']
    StripeWrapper::Charge.create(
      :amount => 999,
      :card => params[:stripeToken],
      :description => "Sign up charge for #{@user.email}"
    )
  end
end
