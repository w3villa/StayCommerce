# API_CONFIG = YAML.load_file(Rails.root.join('config', 'api_config.yml'))[Rails.env]

Rails.configuration.stripe = {
  publishable_key: API_CONFIG['stripe_publishable_key'],
  secret_key: API_CONFIG['stripe_secret_key']
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
