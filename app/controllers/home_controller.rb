class HomeController < ApplicationController
  def index
  	@upcoming_events = Event.upcoming	
		@announcements = Announcement.all
		@announcement = Announcement.all


		if current_user
		  # ---------------
		  @participants = User.participants
		  # @all_orgs = Organization.find(:all, :include => [{:users => [:responses, :checkpoint_users]}])



		  # ---------------
			@org_users = Set.new.to_a
			@org_ids = Set.new.to_a
			current_user.organizations.each {|o| @org_users += o.users}
			current_user.organizations.each do |org|
				@org_id = org.id
				@org_ids << org.id
			end

		@announcements_targeted = Set.new.to_a
		@org_ids.each do |orgid|
			@announcements_targeted += Announcement.targeted(orgid, current_user.level)
		end

			@user_org = current_user.org_ids
			@user_checkpoints = current_user.checkpoints
			@org_checkpoints = Set.new
			current_user.organizations.each do |o|
				@org_checkpoints += o.checkpoints
			end

			@new = @upcoming_events.reject do |e|
				reject = true
				current_user.organizations.each do |o|
					reject = false if e.organizations.include? o
				end
				reject
			end
		end

  	render :action => :home
  	
  end

  def home
    @upcoming_events = Event.upcoming	
		@announcements = Announcement.all
		@announcement = Announcement.all


		if current_user
		  # ---------------
		  @participants = User.participants
		  # @all_orgs = Organization.find(:all, :include => [{:users => [:responses, :checkpoint_users]}])



		  # ---------------
			@org_users = Set.new.to_a
			@org_ids = Set.new.to_a
			current_user.organizations.each {|o| @org_users += o.users}
			current_user.organizations.each do |org|
				@org_id = org.id
				@org_ids << org.id
			end

		@announcements_targeted = Set.new.to_a
		@org_ids.each do |orgid|
			@announcements_targeted += Announcement.targeted(orgid, current_user.level)
		end

			@user_org = current_user.org_ids
			@user_checkpoints = current_user.checkpoints
			@org_checkpoints = Set.new
			current_user.organizations.each do |o|
				@org_checkpoints += o.checkpoints
			end

			@new = @upcoming_events.reject do |e|
				reject = true
				current_user.organizations.each do |o|
					reject = false if e.organizations.include? o
				end
				reject
			end
		end
  	
  end

  def about
  end

  def faq
  end

  def privacy
  end

  def contact
  end

end
