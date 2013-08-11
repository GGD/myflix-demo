class UserSignup

  attr_reader :error_message, :session

  def initialize(user)
    @user = user
  end

  def sign_up(stripe_token, invitation_token)
    if @user.valid?
      charge = charge_credit_card(stripe_token)
      if charge.successful?
        @user.save
        handle_invitation(invitation_token)
        AppMailer.send_welcome_email(@user).deliver
        @session = @user.id
        @status = :success
        self
      else
        @status = :failed
        @error_message = charge.error_message
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

  def handle_invitation(invitation_token)
    if invitation_token.present?
      invitation = Invitation.where(token: invitation_token).first
      @user.follow(invitation.inviter)
      invitation.inviter.follow(@user)
      invitation.update_column(:token, nil)
    end
  end

  def charge_credit_card(stripe_token)
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']
    StripeWrapper::Charge.create(
      :amount => 999,
      :card => stripe_token,
      :description => "Sign up charge for #{@user.email}"
    )
  end
end