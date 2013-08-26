class UserSignup

  attr_reader :error_message, :session

  def initialize(user)
    @user = user
  end

  def sign_up(stripe_token, invitation_token)
    if @user.valid?
      subscription = handle_subscription(stripe_token)
      if subscription.successful?
        @user.stripe_customer_token = subscription.id
        @user.save
        handle_invitation(invitation_token)
        AppMailer.send_welcome_email(@user).deliver
        @session = @user.id
        @status = :success
        self
      else
        @status = :failed
        @error_message = subscription.error_message
        self
      end
    else
      @status = :failed
      self
    end
  end

  def successful?
    @status == :success
  end

private

  def handle_subscription(stripe_token)
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']
    StripeWrapper::Subscribe.create(
      :card => stripe_token,
      :email => @user.email,
      :description => "Subscribe for #{@user.email}"
    )
  end

  def handle_invitation(invitation_token)
    if invitation_token.present?
      invitation = Invitation.where(token: invitation_token).first
      @user.follow(invitation.inviter)
      invitation.inviter.follow(@user)
      invitation.update_column(:token, nil)
    end
  end
end
