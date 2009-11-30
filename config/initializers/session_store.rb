# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_insanely_session',
  :secret      => 'a3b1789b0e483202f064bbf0cb1c345f9d65ea857ef8ee153f868b1f5213f5eed008be40b0f63cba57aac2599e4809ce1076ba1262464b38d568f20089d564f7'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
