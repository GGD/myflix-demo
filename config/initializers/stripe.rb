Stripe.api_key = ENV['STRIPE_SECRET_KEY']

StripeEvent.setup do
  subscribe 'charge.succeeded' do |event|
    user = User.where(stripe_customer_token: event.data.object.customer).first
    raw_parameters = { user_id: user.try(:id), amount: event.data.object.amount, reference_id: event.data.object.id }
    parameters = ActionController::Parameters.new(raw_parameters)
    Payment.create(payment_params(parameters))
  end

  subscribe 'charge.failed' do |event|
    user = User.where(stripe_customer_token: event.data.object.customer).first
    user.deactivate!
  end
end

private

def payment_params(params)
  params.permit(:user_id, :amount, :reference_id)
end
