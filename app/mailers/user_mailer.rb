class UserMailer < ActionMailer::Base
  
  default :from => "famtyes.newuser@gmail.com"
  
  def registration_confirmation(user, password)
    @user => user
    @password => password
    mail(:to => user.email, :subject => "Family Tyes -- Account Created")
  end
  
  def leader_event(user, event)
    mails = []
    User.admins.each do |admin| 
      mails << admin.email 
    end
    recipients = mails.join(", ")
    @user => user
    @event => event
    mail(:to => recipients, :subject => "Family Tyes -- An event has been created")
  end

end
