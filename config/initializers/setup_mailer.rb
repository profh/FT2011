require "openssl" 
require "net/smtp" 
ActionMailer::Base.delivery_method = :smtp 
ActionMailer::Base.smtp_settings = { 
   :address => "smtp.gmail.com", 
   :port => 587, 
   :domain => "localhost", 
   :authentication => :plain, 
   :user_name => "famtyes.newuser",
   :password => "familytyes2010", 
   :enable_starttls_auto => true 
}