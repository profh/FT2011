namespace :db do
  desc "Erase and fill database"
  # creating a rake task within db namespace called 'populate'
  # executing 'rake db:populate' will cause this script to run
  task :populate => :environment do
    # Need two gems to make this work: faker & populator
    # Docs at: http://populator.rubyforge.org/
    require 'populator'
    # Docs at: http://faker.rubyforge.org/rdoc/
    require 'faker'
    
    # STEP 0: clear any old data in the db
    [Announcement, Checkpoint, CheckpointOrganization, CheckpointUser, Event, EventMeasurement, EventOrganization, Location, Measurement, MeasurementCategory, Organization, OrganizationType, OrganizationUser, Question, QuestionOption, Registration, Response, ResponseOption, Snapshot, User].each(&:delete_all)
    
    u = User.new
    u.username = "profh"
    u.email = "profh@cmu.edu"
    u.password = "supersecret"
    u.password_confirmation = "supersecret"
    u.role = "system_admin"
    u.first_name = "Larry"
    u.last_name = "Heimann"
    u.suffix = nil
    u.active = true
    u.level = 50
    u.race = "White or Caucasian"
    u.gender = "Male"
    u.birthday = 46.years.ago
    u.membership_level = 50
    u.street = "5000 Forbes Avenue"
    u.street_2 = "224A Porter Hall"
    u.city = "Pittsburgh"
    u.state = "PA"
    u.zip = "15213"
    u.phone = "4122688211"
    if u.save!
      puts "profh added"
    else
      puts "admin profh not added"
    end
    
    # STEP 1: add two default admin (Paul Hindes & Bill Stein)
    User.populate 1 do |u|
      u.username = "phindes"
      u.email = "phindes@familytyes.org"
      # password is 'secret'
      # u.perishable_token = "042b7931ce767f4d53184852fcd9edee704bb10eb1930c211d20e8f0ee076c470ce42a5f64fa02439111c09b444061883b81d542edb2b671aeffadab8b5dbd2b"
      # u.persistence_token = "d5ddba13ed4408ea2b0a12ab18ed2d2eda086279736bdc121ca726a11f1e4b99217d9c534c2cc4ebb22729349c8c5fdbe1529e1f2c3c5859c62ef4dd9feea25c"
      # u.crypted_password = "3d16c326648cccafe3d4b4cb024475c381dda92f430dfedf6f933e1f61203bacb6bae2437849bdb43b06be335e23790e4aa03902b3c28c3bbbbe27d501e521f3"
      # u.password_salt = "n6z_wtpWoIsHgQb5IcFd"
      u.password_hash = "$2a$10$F62Nx0dpLdijYKPD/WXn9OkNsOsPXzQmCHpVV39bHawJ2IzzVGCaa"
      u.password_salt = "$2a$10$F62Nx0dpLdijYKPD/WXn9O"
      u.role = "system_admin"
      u.first_name = "Paul"
      u.last_name = "Hindes"
      u.suffix = nil
      u.active = true
      u.level = 50
      u.race = "White or Caucasian"
      u.gender = "Male"
      u.birthday = 65.years.ago
      u.membership_level = 50
      u.street = "5000 Forbes Avenue"
      u.street_2 = "100B Porter Hall"
      u.city = "Pittsburgh"
      u.state = "PA"
      u.zip = "15213"
      u.phone = "7243489428"
    end		
    
    User.populate 1 do |u|
      u.username = "wstein"
      u.email = "wstein@familytyes.org"
      # password is 'secret'
      # u.perishable_token = "042b7931ce767f4d53184852fcd9edee704bb10eb1930c211d20e8f0ee076c470ce42a5f64fa02439111c09b444061883b81d542edb2b671aeffadab8b5dbd2b"
      # u.persistence_token = "d5ddba13ed4408ea2b0a12ab18ed2d2eda086279736bdc121ca726a11f1e4b99217d9c534c2cc4ebb22729349c8c5fdbe1529e1f2c3c5859c62ef4dd9feea25c"
      # u.crypted_password = "3d16c326648cccafe3d4b4cb024475c381dda92f430dfedf6f933e1f61203bacb6bae2437849bdb43b06be335e23790e4aa03902b3c28c3bbbbe27d501e521f3"
      # u.password_salt = "n6z_wtpWoIsHgQb5IcFd"
      u.password_hash = "$2a$10$F62Nx0dpLdijYKPD/WXn9OkNsOsPXzQmCHpVV39bHawJ2IzzVGCaa"
      u.password_salt = "$2a$10$F62Nx0dpLdijYKPD/WXn9O"
      u.role = "system_admin"
      u.first_name = "Bill"
      u.last_name = "Stein"
      u.suffix = nil
      u.active = true
      u.level = 50
      u.race = "White or Caucasian"
      u.gender = "Male"
      u.birthday = 65.years.ago
      u.membership_level = 50
      u.street = "5000 Forbes Avenue"
      u.street_2 = "100B Porter Hall"
      u.city = "Pittsburgh"
      u.state = "PA"
      u.zip = "15213"
      u.phone = "4129798652"
    end
    
    
    # STEP 2: add measurement categories and associated measures    
    measures = {"Physical Activity" => ["Hiking", "Swimming", "Lifting", "Building"],
                "Leadership" => ["Vision", "Confidence", "Role Model", "Flexibility", "Positive Attitude", "Communication"],
                "Env Awareness" => ["Conservation", "Aquatic Life", "Stream Management"],
                "Fishing Skills" => ["Basic Casting", "Intermediate Casting", "Advanced Casting", "Basic Fly Tying", "Advanced Fly Tying", "Basic Knots", "Advanced Knots"],
                "Academics" => ["PA Biology Standards", "PA Physics Standards", "PA Chemistry Standards", "PA Earth Science Standards"]
    }
      
    measures.sort_by{|k,v| k}.each do |mcat, measures|
      # create the category
      measure_category = MeasurementCategory.new
      measure_category.title = mcat
      measure_category.save!
      
      # create the measures in each category
      measures.sort.each do |name|
        measure = Measurement.new
        measure.name = name
        measure.description = "It's all related to #{name.downcase}."
        measure.active = true
        measure.measurement_category_id = measure_category.id
        measure.save!
      end
    end
    
    # STEP 3: add questions to basic knots measurements
    knots_measure = Measurement.where("name = 'Basic Knots'").limit(1).first
    
     mc_questions = {
       "What knot would you use to secure a fly to the tippet?" => [["Square knot", 0], ["Clinch knot", 5], ["Surgeon's loop", 2], ["Barrel knot", 0], ["Bowline knot", 0], ["Nail knot", 0]],
       "What knot would you use to attach the leader to the fly line?" => [["Square knot", 0], ["Clinch knot", 0], ["Surgeon's loop", 0], ["Barrel knot", 3], ["Bowline knot", 0], ["Nail knot", 5]],
       "To tie a good clinch knot, how many times should you twist the tag end round the standing part of the line?" => [["Just one time", 0], ["Two twists", 0], ["Three twists", 1], ["Four twists", 3], ["Five twists", 5], ["None - trick question", 0]]
     }
     ms_selections = {
       "Which of the following knots can you tie with assistance?" => [["Square knot", 1], ["Clinch knot", 1], ["Surgeon's loop", 1], ["Barrel knot", 1], ["Nail knot", 1]],
       "Which of the following knots can you tie by yourself?" => [["Square knot", 3], ["Clinch knot", 3], ["Surgeon's loop", 3], ["Barrel knot", 3], ["Nail knot", 3]]
     }
     
     mc_questions.each do |question, options|
       mc_question = Question.new 
       mc_question.content = question
       mc_question.question_type = 2
       mc_question.measurement_id = knots_measure.id
       mc_question.active = true
       mc_question.save!
       
       options.each do |option|
         q_option = QuestionOption.new
         q_option.question_id = mc_question.id
         q_option.content = option[0]
         q_option.points = option[1]
         q_option.save!
       end
     end
     
     ms_selections.each do |question, options|
       ms_selection = Question.new 
       ms_selection.content = question
       ms_selection.question_type = 3
       ms_selection.measurement_id = knots_measure.id
       ms_selection.active = true
       ms_selection.save!
       
       options.each do |option|
         q_option = QuestionOption.new
         q_option.question_id = ms_selection.id
         q_option.content = option[0]
         q_option.points = option[1]
         q_option.save!
       end
     end
     
     # STEP 4: add questions to leadership measurements
     vision_measure = Measurement.where(["name = ?", "Vision"]).limit(1).first
     role_model_measure = Measurement.where(["name = ?", "Role Model"]).limit(1).first
     
       # Add a vision short answer question
       vq = Question.new
       vq.content = "Explain why vision is so important for a successful leader."
       vq.question_type = 1
       vq.measurement_id = vision_measure.id
       vq.active = true
       vq.completion_score = 4
       vq.save!
       
       # Add a series of role model questions
       questions = ["Rate yourself as a role model in fishing", "Rate yourself as a role model in teaching", "Rate yourself as a role model in encouraging"]
       options = {"I excel in this area" => 4, "I am above average in this area" => 3, "I am average in this area" => 2, "I need to improve in this area" => 1}
       
       questions.each do |question|
         rm = Question.new
         rm.content = question
         rm.question_type = 2
         rm.measurement_id = role_model_measure.id
         rm.active = true
         rm.save!
         options.sort_by{|k,v| v}.reverse.each do |option, points|
           q_option = QuestionOption.new
           q_option.question_id = rm.id
           q_option.content = option
           q_option.points = points
           q_option.save!
         end
       end
       
       rm_sa = Question.new
       rm_sa.content = "What helps you be a good role model to others?"
       rm_sa.question_type = 1
       rm_sa.measurement_id = role_model_measure.id
       rm_sa.active = true
       rm_sa.completion_score = 4
       rm_sa.save!
         
    # STEP 5: add some locations
    locations = {"Baldwin HS" => ["4653 Clairton Blvd","Pittsburgh","15236"],
                "Carnegie Mellon" => ["5000 Forbes Ave","Pittsburgh","15213"],
                "McConnells Mill" => ["McConnells Mill State Park", "Portersville", "16051"],  
                "Neshannock Creek" => ["250 Main Street","Volant","16156"], 
                "Rolling Green" => ["2426 Pennsylvania 136","Eighty Four","15330"], 
                "Sarah Heinz House" => ["1 Heinz Street","Pittsburgh","15212"],
                "St. Paul's Church" => ["Park Lane","Zelienople","16063"]
    }
    locations.sort_by{|k,v| k}.each do |name, address|
      location = Location.new
      location.name = name
      location.street = address[0]
      location.street_2 = nil
      location.city = address[1]
      location.state = "PA"
      location.zip = address[2]
      location.description = "FT Location"
      location.active = true
      location.save!
      sleep(3)  # necessary because of limits imposed by Google on free accounts
    end
    
    # STEP 6: add some organizational types
    org_types = %w[Church Club Non-Profit Scouts School]
    org_types.sort.each do |name|
      org_type = OrganizationType.new
      org_type.name = name
      org_type.description = "A type of organization that works with Family Tyes"
      org_type.active = true
      org_type.save!
    end
    
    # STEP 7: add some organizations
    school_type = OrganizationType.where(['name = ?', "School"]).limit(1).first.id
    scouts_type = OrganizationType.where(['name = ?', "Scouts"]).limit(1).first.id
    club_type = OrganizationType.where(['name = ?', "Club"]).limit(1).first.id
    nonprofit_type = OrganizationType.where(['name = ?', "Non-Profit"]).limit(1).first.id
    cmu_location = Location.where(['name = ?', "Carnegie Mellon"]).limit(1).first.id
    baldwin_location = Location.where(['name = ?', "Baldwin HS"]).limit(1).first.id
    shh_location = Location.where(['name = ?', "Sarah Heinz House"]).limit(1).first.id
    zeli_location = Location.where(['city = ?', "Zelienople"]).limit(1).first.id
    
    organizations = {
      "Carnegie Mellon Fishing" => [cmu_location,school_type],
      "Sarah Heinz House Fishing" => [shh_location,nonprofit_type],
      "Baldwin Schools" => [baldwin_location,school_type],
      "Boy Scout Troop 64" => [cmu_location,scouts_type],
      "Zelienople Fishing" => [zeli_location,club_type]
    }
    organizations.sort_by{|k,v| k}.each do |name, info|
      org = Organization.new
      org.name = name
      org.location_id = info[0]
      org.organization_type_id = info[1]
      org.active = true
      org.save!
    end
    
    # STEP 8: add 1 or 2 organizational leaders per organization
    
    organization_ids = Organization.all.map{|o| o.id}
    organization_ids.each do |oid|
      # create one or two new users to serve as organizational admins
      User.populate 1..2 do |u|
        # determine gender and first name
        u.gender = ["Male", "Female"]
        if u.gender == "Female"
          u.first_name = %w[Anne Cindy Jeria Sharon Kathy Betsy Beth Deb Valerie Jane Diane Elizabeth Karen Mary Nancy Nicole Angie Ann Amy Samantha Patrica]
        else
          u.first_name = %w[Larry Carl Tim Tom Evan Charles John Kevin Joseph Christopher Conrad Blake Greg David Peter Jacob Stafford Ari Ashton Arvind Daniel Lyle Kyle Michael Mitchell Douglas]
        end
        u.last_name = Faker::Name.last_name
        u.username = "#{u.first_name.downcase}.#{u.last_name.downcase}"
        u.email = "#{u.first_name.downcase}.#{u.last_name.downcase}@familytyes.org"
        # password is 'secret'
        # u.perishable_token = "042b7931ce767f4d53184852fcd9edee704bb10eb1930c211d20e8f0ee076c470ce42a5f64fa02439111c09b444061883b81d542edb2b671aeffadab8b5dbd2b"
        # u.persistence_token = "d5ddba13ed4408ea2b0a12ab18ed2d2eda086279736bdc121ca726a11f1e4b99217d9c534c2cc4ebb22729349c8c5fdbe1529e1f2c3c5859c62ef4dd9feea25c"
        # u.crypted_password = "3d16c326648cccafe3d4b4cb024475c381dda92f430dfedf6f933e1f61203bacb6bae2437849bdb43b06be335e23790e4aa03902b3c28c3bbbbe27d501e521f3"
        # u.password_salt = "n6z_wtpWoIsHgQb5IcFd"
        u.password_hash = "$2a$10$F62Nx0dpLdijYKPD/WXn9OkNsOsPXzQmCHpVV39bHawJ2IzzVGCaa"
        u.password_salt = "$2a$10$F62Nx0dpLdijYKPD/WXn9O"
        u.role = "organization_admin"
        u.suffix = nil
        u.active = true
        u.level = 30
        u.race = [ "White or Caucasian","White or Caucasian","White or Caucasian", "Black or African American","Black or African American", "Asian or Pacific Islander", "Latino, Hispanic, or Spanish Origin", "American Indian" ]
        u.birthday = 60.years.ago..25.years.ago
        u.membership_level = 30
        u.street = Faker::Address.street_address
        u.street_2 = nil
        u.city = Faker::Address.city
        u.state = "PA"
        u.zip = ["15213", "15212", "15090", "15237", "15236", "16063", "15330", "16156", "16501"]
        u.phone = rand(10 ** 10).to_s.rjust(10,'0')
        # associate new user with organization as a leader
        OrganizationUser.populate 1 do |ou|
          ou.organization_id = oid
          ou.user_id = u.id
          ou.start_date = 2.years.ago..3.months.ago
          ou.end_date = nil
          ou.head = true
        end  
      end
      
      # STEP 9: add some students and assign to organizations
      # create between 15 to 100 students for each organization
      User.populate 15..100 do |u|
        # determine gender and first name
        u.gender = ["Male", "Female"]
        if u.gender == "Female"
          u.first_name = %w[Anne Cindy Jeria Sharon Kathy Betsy Beth Deb Valerie Jane Diane Elizabeth Karen Mary Nancy Nicole Angie Ann Amy Samantha Patrica]
        else
          u.first_name = %w[Larry Carl Tim Tom Evan Charles John Kevin Joseph Christopher Conrad Blake Greg David Peter Jacob Stafford Ari Ashton Arvind Daniel Lyle Kyle Michael Mitchell Douglas]
        end
        u.last_name = Faker::Name.last_name
        u.username = "#{u.first_name.downcase}.#{u.last_name.downcase}"
        u.email = "#{u.first_name.downcase}.#{u.last_name.downcase}@familytyes.org"
        # password is 'secret'
        # u.perishable_token = "042b7931ce767f4d53184852fcd9edee704bb10eb1930c211d20e8f0ee076c470ce42a5f64fa02439111c09b444061883b81d542edb2b671aeffadab8b5dbd2b"
        # u.persistence_token = "d5ddba13ed4408ea2b0a12ab18ed2d2eda086279736bdc121ca726a11f1e4b99217d9c534c2cc4ebb22729349c8c5fdbe1529e1f2c3c5859c62ef4dd9feea25c"
        # u.crypted_password = "3d16c326648cccafe3d4b4cb024475c381dda92f430dfedf6f933e1f61203bacb6bae2437849bdb43b06be335e23790e4aa03902b3c28c3bbbbe27d501e521f3"
        # u.password_salt = "n6z_wtpWoIsHgQb5IcFd"
        u.password_hash = "$2a$10$F62Nx0dpLdijYKPD/WXn9OkNsOsPXzQmCHpVV39bHawJ2IzzVGCaa"
        u.password_salt = "$2a$10$F62Nx0dpLdijYKPD/WXn9O"
        u.role = "participant"
        u.suffix = nil
        u.active = true
        u.level = 10
        u.race = [ "White or Caucasian","White or Caucasian","White or Caucasian","White or Caucasian", "Black or African American","Black or African American","Black or African American", "Asian or Pacific Islander", "Latino, Hispanic, or Spanish Origin", "American Indian" ]
        u.birthday = 17.years.ago..8.years.ago
        u.membership_level = 10
        u.street = Faker::Address.street_address
        u.street_2 = nil
        u.city = Faker::Address.city
        u.state = "PA"
        u.zip = ["15213", "15212", "15090", "15237", "15236", "16063", "15330", "16156", "16501"]
        u.phone = rand(10 ** 10).to_s.rjust(10,'0')
        # associate new user with organization as a participant
        OrganizationUser.populate 1 do |ou|
          ou.organization_id = oid
          ou.user_id = u.id
          ou.start_date = 2.years.ago..3.months.ago
          ou.end_date = nil
          ou.head = false
        end  
      end
    end
    
    # STEP 10: add some event types
    e_types = ["Class", "Fishing", "Other"]
    e_types.sort.each do |name|
      event_type = EventType.new
      event_type.name = name
      event_type.description = "Engaging in #{name.downcase} activities"
      event_type.save!  
    end
    
    # STEP 11: add some past events
    fishing_locations = Location.where(['name = ? OR name = ? OR name = ?', "McConnells Mill", "Neshannock Creek", "Rolling Green"]).map{|loc| loc.id}
    class_locations = Location.where(['name != ? AND name != ? AND name != ?', "McConnells Mill", "Neshannock Creek", "Rolling Green"]).map{|loc| loc.id}
    measure_casting = Measurement.where(['name = ? OR name = ?', "Basic Casting", "Intermediate Casting"]).map{|c| c.id}
    measure_physical = Measurement.where(['name = ? OR name = ?', "Hiking", "Lifting"]).map{|p| p.id}
    organization_ids = Organization.all.map{|o| o.id}
    fishing_event_type_id = EventType.where(['name = ?', "Fishing"]).first.id
    class_event_type_id = EventType.where(['name = ?', "Class"]).first.id
    
    # make fishing events first
    Event.populate 18 do |event|
      event.location_id = fishing_locations
      event.name = "Fishing Trip to #{Location.find(event.location_id).name}"
      event.description = "A fishing trip for Family Tyes students that will be a great learning opportunity and tremendous fun for all who attend."
      event.cost = [0.00, 0.00, 5.00]
      event.permission_required = true
      event.max_participants = 200
      event.event_type_id = fishing_event_type_id
      event.start_date = 6.months.ago..2.weeks.ago
      event.end_date = event.start_date + 14400
      # add some measures to this event
      EventMeasurement.populate 1 do |em1|
        em1.event_id = event.id
        em1.measurement_id = measure_casting
      end
      EventMeasurement.populate 1 do |em2|
        em2.event_id = event.id
        em2.measurement_id = measure_physical
      end
      # add an organization assigned to this event
      EventOrganization.populate 1 do |eo1|
        eo1.organization_id = organization_ids
        eo1.event_id = event.id
      end
    end
    
    # now make some class events
    Event.populate 18 do |event|
      event.location_id = class_locations
      # is this a knots class or a casting class?
      is_role_model = rand(2)
      if 1 == 1 #is_role_model.zero?
        EventMeasurement.populate 1 do |em1|
          em1.event_id = event.id
          em1.measurement_id = role_model_measure.id
          event.name = "Class on how to be a better role model for others"
        end
      else
        EventMeasurement.populate 1 do |em1|
          em1.event_id = event.id
          em1.measurement_id = knots_measure.id
          event.name = "Class covering basic fly fishing knots"
        end
      end
      event.description = "An informative and helpful class that will help young fishermen expand their skill set"
      event.cost = 0.00
      event.permission_required = false
      event.max_participants = 200
      event.event_type_id = class_event_type_id
      event.start_date = 6.months.ago..2.weeks.ago
      event.end_date = event.start_date + 7200

      # add an organization assigned to this event 
      EventOrganization.populate 1 do |eo1|
        eo1.organization_id = organization_ids
        eo1.event_id = event.id
      end
    end
    
    # STEP 12: add some registrations to the past events
    past_events = Event.where(['start_date < ?', Time.now])
    past_events.each do |event|
      members = event.organizations.first.users
      members.each do |member|
        unless rand(5).zero?
          reg = Registration.new
          reg.user_id = member.id
          reg.event_id = event.id
          reg.permission_form_received = true
          reg.amount_paid = event.cost
          reg.save!
        end
      end
    end
    
    # STEP 13: add some future events
    # make fishing events first
    Event.populate 2 do |event|
      event.location_id = fishing_locations
      event.name = "Fishing Trip to #{Location.find(event.location_id).name}"
      event.description = "A fishing trip for Family Tyes students that will be a great learning opportunity and tremendous fun for all who attend."
      event.cost = [0.00, 0.00, 5.00]
      event.permission_required = true
      event.max_participants = 200
      event.event_type_id = fishing_event_type_id
      event.start_date = 1.week.from_now..3.weeks.from_now
      event.end_date = event.start_date + 14400
      # add some measures to this event
      EventMeasurement.populate 1 do |em1|
        em1.event_id = event.id
        em1.measurement_id = measure_casting
      end
      EventMeasurement.populate 1 do |em2|
        em2.event_id = event.id
        em2.measurement_id = measure_physical
      end
      # add an organization assigned to this event
      EventOrganization.populate 1 do |eo1|
        eo1.organization_id = organization_ids
        eo1.event_id = event.id
      end
    end
    
    # now make some class events
    Event.populate 2 do |event|
      event.location_id = class_locations
      # is this a knots class or a casting class?
      is_casting = rand(2)
      if is_casting.zero?
        EventMeasurement.populate 1 do |em1|
          em1.event_id = event.id
          em1.measurement_id = measure_casting
          event.name = "Class covering #{Measurement.find(em1.measurement_id).name.downcase}"
        end
      else
        EventMeasurement.populate 1 do |em1|
          em1.event_id = event.id
          em1.measurement_id = knots_measure.id
          event.name = "Class covering #{Measurement.find(em1.measurement_id).name.downcase}"
        end
      end
      event.description = "An informative and helpful class that will help young fishermen expand their skill set"
      event.cost = 0.00
      event.permission_required = false
      event.max_participants = 200
      event.event_type_id = class_event_type_id
      event.start_date = 1.week.from_now..3.weeks.from_now
      event.end_date = event.start_date + 7200

      # add an organization assigned to this event 
      EventOrganization.populate 1 do |eo1|
        eo1.organization_id = organization_ids
        eo1.event_id = event.id
      end
    end
    future_events = Event.where(['start_date > ?', Time.now])
    future_events.each do |event|
      members = event.organizations.first.users
      members.each do |member|
        if rand(5).zero?
          reg = Registration.new
          reg.user_id = member.id
          reg.event_id = event.id
          reg.permission_form_received = true
          reg.amount_paid = event.cost
          reg.save!
        end
      end
    end
    
    # STEP 13: add past checkpoints and assign to organizations
    # checkpoint 0 (6 weeks ago)
    Checkpoint.populate 1 do |cp|
      cp.due_on = 6.weeks.ago
      cp.distributed = true
      cp.name = "Checkpoint due #{cp.due_on.strftime("%b %d")}"
      CheckpointOrganization.populate 1 do |cpo|
        cpo.checkpoint_id = cp.id
        cpo.organization_id = Organization.joins(:event_organizations => :event).where(['start_date < ? AND event_type_id = ?', 6.weeks.ago, class_event_type_id]).map{|o| o.id}.uniq!
      end
    end
    # checkpoint 1 (5 weeks ago)
    Checkpoint.populate 1 do |cp|
      cp.due_on = 5.weeks.ago
      cp.distributed = true
      cp.name = "Checkpoint due #{cp.due_on.strftime("%b %d")}"
      CheckpointOrganization.populate 1 do |cpo|
        cpo.checkpoint_id = cp.id
        cpo.organization_id = Organization.joins(:event_organizations => :event).where(['start_date < ? AND event_type_id = ?', 5.weeks.ago, class_event_type_id]).map{|o| o.id}.uniq!
      end
    end
    # checkpoint 2 (4 weeks ago)
    Checkpoint.populate 1 do |cp|
      cp.due_on = 4.weeks.ago
      cp.distributed = true
      cp.name = "Checkpoint due #{cp.due_on.strftime("%b %d")}"
      CheckpointOrganization.populate 1 do |cpo|
        cpo.checkpoint_id = cp.id
        cpo.organization_id = Organization.joins(:event_organizations => :event).where(['start_date < ? AND event_type_id = ?', 4.weeks.ago, class_event_type_id]).map{|o| o.id}.uniq!
      end
    end
    # checkpoint 3 (3 weeks ago)
    Checkpoint.populate 1 do |cp|
      cp.due_on = 3.weeks.ago
      cp.distributed = true
      cp.name = "Checkpoint due #{cp.due_on.strftime("%b %d")}"
      CheckpointOrganization.populate 1 do |cpo|
        cpo.checkpoint_id = cp.id
        cpo.organization_id = Organization.joins(:event_organizations => :event).where(['start_date < ? AND event_type_id = ?', 3.weeks.ago, class_event_type_id]).map{|o| o.id}.uniq!
      end
    end
    # checkpoint 4 (2 weeks ago)
    Checkpoint.populate 1 do |cp|
      cp.due_on = 2.weeks.ago
      cp.distributed = true
      cp.name = "Checkpoint due #{cp.due_on.strftime("%b %d")}"
      CheckpointOrganization.populate 1 do |cpo|
        cpo.checkpoint_id = cp.id
        cpo.organization_id = Organization.joins(:event_organizations => :event).where(['start_date < ? AND event_type_id = ?', 2.weeks.ago, class_event_type_id]).map{|o| o.id}.uniq!
      end
    end
    # checkpoint 5 (1 week ago)
    Checkpoint.populate 1 do |cp|
      cp.due_on = 1.week.ago
      cp.distributed = true
      cp.name = "Checkpoint due #{cp.due_on.strftime("%b %d")}"
      CheckpointOrganization.populate 1 do |cpo|
        cpo.checkpoint_id = cp.id
        cpo.organization_id = Organization.joins(:event_organizations => :event).where(['start_date < ? AND event_type_id = ?', 1.week.ago, class_event_type_id]).map{|o| o.id}.uniq!
      end
    end
    # connect to participants (this will be a pain)
    all_checkpoints = Checkpoint.all
    all_checkpoints.each do |chkpt|     
      chkpt.organizations.first.users.each do |user|
        # first create the checkpoint user
        cpu = CheckpointUser.new
        cpu.user_id = user.id
        cpu.checkpoint_id = chkpt.id
        cpu.score = 1
        cpu.save!
        # get the events for this user since last time
        user_events = user.events.map{|e| e if e.event_type_id == class_event_type_id}.compact!
        
        unless user_events.nil? || user_events.empty?
          # get the measures associated with these events
          cp_measures = Array.new
          user_events.each do |ue|
            ue.measurements.each do |measure|
              cp_measures << measure unless cp_measures.include? measure
            end
          end
          # for each measure answer the questions associated with the measure
          cp_score = 0
          cp_measures.each do |cpm|
            if cpm.name == "Basic Knots"
              # need to fill out responses for knots
              knots_questions = Question.where(['measurement_id = ?', knots_measure.id])
              knots_questions.each do |kq|
                kq_options = kq.question_options.map{|k| k.id}
                # create the response
                r = Response.new
                r.question_id = kq.id
                r.user_id = user.id
                r.checkpoint_user_id = cpu.id
                r.save!
                  # create the response options
                  if kq.question_type == 2 # multiple choice
                    ro = ResponseOption.new
                    ro.response_id = r.id
                    ro.question_option_id = kq_options.sample
                    ro.save!
                  else # has to be multiple select; always choose first and last options
                    ro1 = ResponseOption.new
                    ro1.response_id = r.id
                    ro1.question_option_id = kq_options.first
                    ro1.save!
                    ro2 = ResponseOption.new
                    ro2.response_id = r.id
                    ro2.question_option_id = kq_options.last
                    ro2.save!
                  end                
              end
            elsif cpm.name == "Role Model"
              # need to fill out responses for role model
              rmodel_questions = Question.where(['measurement_id = ?', role_model_measure.id])
              rmodel_questions.each do |rmq|
                rmq_options = rmq.question_options.map{|rm| rm.id}
                # create the response
                r = Response.new
                r.question_id = rmq.id
                r.user_id = user.id
                r.checkpoint_user_id = cpu.id
                  # create the response options for the multiple choice
                  if rmq.question_type == 2
                    ro = ResponseOption.new
                    ro.response_id = r.id
                    ro.question_option_id = rmq_options.sample
                    ro.save!
                  end
                
              end
            
            else
              pts = 0
            end
            cp_score = 0
          end
          # now edit the cpu score (CHANGED, score should just be one)
          # cpu.update_attribute(:score, cp_score)
        end
      end
    end
    
    # STEP 13A: Fix response_values so they are a string of options where a    
    Response.all.each do |r|
      qtype = r.question.question_type
      if qtype == 2 
        ro_str = r.response_options.first.question_option_id
      elsif qtype == 3
        ro_str = r.response_options.map{|ro| ro.question_option_id}.join(",")       
      else
        ro_str = "_"
      end
      r.response_value = ro_str
      r.save!
    end
    
    # STEP 14: Add snapshot data
    # get all the measurement_category_ids
    mc_ids = MeasurementCategory.all.map{|mc| mc.id}
    
    # create two new hashes we need to store info temporarily
    earned = Hash.new
    possible = Hash.new
    
    # get all the responses and convert to scores
    cp_users = CheckpointUser.all
    cp_users.each do |cpu|
      user_id = cpu.user_id
      checkpoint_id = cpu.checkpoint_id
      puts "User #{user_id} :: CP #{checkpoint_id} :: CPU #{cpu.id}"
      responses = cpu.responses
      puts "Measurement Categories for CPU"
      responses.each do |response|
        mc_id = response.question.measurement.measurement_category.id   
        puts "#{mc_id}"
        # testing: puts "#{mc_id} :: #{response.id}" 
        # get points earned and add to hash
        pts_earned = response.points_earned ||= 0
        if earned.has_key? mc_id
          earned[mc_id] += pts_earned
        else
          earned[mc_id] = pts_earned
        end
        # get points possible and add to hash
        pts_possible = response.points_total ||= 0
        if possible.has_key? mc_id
          possible[mc_id] += pts_possible
        else
          possible[mc_id] = pts_possible
        end
      end
      # now create the snapshots
      mc_ids.each do |mc_id|
        if earned.keys.include? mc_id 
          snap = Snapshot.new
          # set the object's values
          snap.percent_score = earned[mc_id].to_f/possible[mc_id]
          snap.user_id = user_id
          snap.checkpoint_id = checkpoint_id
          snap.measurement_category_id = mc_id
          # save this snapshot
          snap.save!
          puts "-----------"
        end
      end
    end
    
    
    
    # STEP 15: add two announcements from admin
    announcements = {
        "Welcome to the Family Tyes Demo" => "This demo was created to demonstrate the functionality of the new Family Tyes Assessment System. If you want to explore the system as an administrator, contact Paul Hindes (phindes@familytyes.org) or Bill Stein (wstein@familytyes.org) for credentials to access the site.",
        "All Data Here is Fictitious" => "All data here is randomly generated to protect Family Tyes' members' identities, but structured in a way to appear realistic for new users.  There may be some inconsistencies in the particular data either from random generation or other users playing with the system.  If there are problems, please let someone know and we can regenerate a new set of data."
      }
    announcements.sort_by{|k,v| k}.reverse.each do |title, body|
      announce = Announcement.new
      announce.title = title
      announce.body = body
      announce.expires_on = 6.months.from_now.to_date
      announce.level = 10
      announce.user_id = User.where(['role = ?', "system_admin"]).limit(1).first.id
      announce.save!
    end
    
    # STEP 15: add some announcements from an organizational leader
    
    
	end
end