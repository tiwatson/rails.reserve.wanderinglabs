PayPal::SDK.configure(
  mode: Rails.env.production? ? 'live' : 'sandbox',
  client_id: 'AaoKUckTip-ExcrlptmKarrQpOek0xDorQqEs9I9VyYoM1ozhNsPa8QZmgp_UEitynINt1Wt4ncWtYeU',
  client_secret: 'EMCR08BAUwHMuvahmJq8Yu74C3yoa0NwXyHmeTWqKBr5zZMj_KDg5eP-IfBF1EyzOlIeCmW4izPCJwIZ',
  ssl_options: {}
)
