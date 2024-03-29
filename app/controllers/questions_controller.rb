class QuestionsController < ApplicationController
  
  before_filter :login_required


  def index
    @questions = Question.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @questions }
    end
  end


  def show
    @question = Question.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @question }
    end
  end


  def new
	@measurement = Measurement.find(params[:id])
	@questions = Question.get_questions(params[:id])
	@questions_count = Question.get_questions(params[:id]).count

   # respond_to do |format|
   #   format.html # new.html.erb
   #   format.xml  { render :xml => @question }
   # end
  end


  def newset
    @question = Question.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @question }
    end
  end


  def edit
    @question = Question.find(params[:id])
  end


  def create
	# get measurement_id
	@measurement_id = params[:measurement_id]

	# clear currently stored questions in database	
	# retrieve all questions for this measurements from db				
	@current_questions = Question.get_questions(@measurement_id) 
	@current_questions_count = Question.get_questions(@measurement_id).count 
	@i = 0
	# delete all questions and all associated question options
	while(@i < @current_questions_count)	
		@current_question_id = @current_questions[@i]['id']
		@question_to_destroy = Question.find(@current_question_id)
		@current_options = QuestionOption.get_options(@current_question_id)
		@current_options_count = QuestionOption.get_options(@current_question_id).count
		@j = 0
		while(@j < @current_options_count)
			@current_option_id = @current_options[@j]['id']
			@option_to_destroy = QuestionOption.find(@current_option_id)
			@option_to_destroy.destroy
			@j += 1
		end

		@question_to_destroy.destroy
		@i += 1
	end

	# get last question_id value
	@qn_count = Question.last_id.count
	if(@qn_count == 0)
		@last_id = 1
	else
		@query = Question.last_id
		@last_id = @query[0]['id']
	end

	# save questions
	@question_count = 0
	# delimited string containing info about questions to be saved generated by frontend jQuery
	@param_string = params[:question_list]
	@param_arr = @param_string.split(/;/)

		@param_arr.each do |qn|
			# new question object to be saved
			@new_question = Question.new

			# split param_string up question by question, name-value pair by name-value pair
			@name_value_pairs = qn.split(/&/)
			@name_value_pairs.each do |name_value_pair|
				@name_value = name_value_pair.split(/[=]/)
				if(@name_value[0] == 'id')
					# set id of this new question
					@question_count += 1
					@new_question.id = @last_id.to_i + @question_count

				elsif(@name_value[0] == 'type')
					# set question_type of this new question
					@new_question.question_type = @name_value[1]

				elsif(@name_value[0] == 'question')
					# set content (the question) of this new question
					@new_question.content = @name_value[1]

				elsif(@name_value[0] == 'completion_score')
					# set content (completion_score) of this new question
					@new_question.completion_score = @name_value[1]					

				elsif(@name_value[0] == 'max_length')
					# get max length for text fields
					@max_length = @name_value[1]

				elsif(@name_value[0] == 'choices')
					# get choices array for this new question
					build_choices = Array.new
					count = 0
					first_split = @name_value[1].split(/,/)
					first_split.each do |w|
            if !w.match(/^\s\w/)
              build_choices << w
              count += 1
            else
              revised = build_choices.last + ',' + w
              build_choices[count-1] = revised
            end
          end
          @choices = build_choices
          # @choices = @name_value[1].split(/,/)

				elsif(@name_value[0] == 'points')
					# get points array for this new question
					@points = @name_value[1].split(/,/)

				elsif(@name_value[0] == 'scale1description')
					# get scale desription
					@scale1description = @name_value[1]

				elsif(@name_value[0] == 'scale10description')
					# get scale desription
					@scale10description = @name_value[1]			
				end
			end

			# set measurement_id of this new question
			@new_question.measurement_id = @measurement_id

			# save new question object
			@new_question.save

			# check if question is Multiple Choice or Multiple Select
			if(@new_question.question_type == 2 || @new_question.question_type == 3)
				@option_id = 1
				@options_count = QuestionOption.last_id.count
				if(@options_count == 0)
					@last_option_id = 1
				else
					@options_query = QuestionOption.last_id
					@last_option_id = @options_query[0]['id']
				end

				# add options to question_options table
				@choice_counter = 0
				@choices.each do |choice|				
					@new_question_option = QuestionOption.new
					@new_question_option.id = @last_option_id.to_i + @option_id
					@new_question_option.question_id = @new_question.id
					@new_question_option.content = choice
					@new_question_option.points = @points[@choice_counter]
					@new_question_option.save
					@option_id = @option_id + 1
					@choice_counter += 1
				end
			end

			# check if question is Scale
			if(@new_question.question_type == 4)
				@options_query = QuestionOption.last_id
				@last_option_id = 1
				if(@options_query[0] != nil)
					@last_option_id = @options_query[0]['id']
				end

				# add scale1description to question_options table
				@question_option_1 = QuestionOption.new
				@question_option_1.id = @last_option_id.to_i + 1
				@question_option_1.question_id = @new_question.id
				@question_option_1.content = @scale1description		
				@question_option_1.points = 0 # TODO: change when point system is being implemented
				@question_option_1.save	

				# add scale1description to question_options table
				@question_option_2 = QuestionOption.new
				@question_option_2.id = @last_option_id.to_i + 2
				@question_option_2.question_id = @new_question.id
				@question_option_2.content = @scale10description
				@question_option_2.points = 0 # TODO: change when point system is being implemented
				@question_option_2.save			
			end
		end

    redirect_to('/questions/new/'+@measurement_id, :notice => 'Questions have been successfully saved.')

  # @question = Question.new(params[:question]) 
  # 
  # respond_to do |format|
  #   if @question.save
  #      format.html { redirect_to(@question, :notice => 'Question was successfully created.') }
  #      format.xml  { render :xml => @question, :status => :created, :location => @question }
  #   else
  #      format.html { render :action => "new" }
  #      format.xml  { render :xml => @question.errors, :status => :unprocessable_entity }
  #    end
  #  end
  end


  def update
    @question = Question.find(params[:id])

    respond_to do |format|
      if @question.update_attributes(params[:question])
        format.html { redirect_to(@question, :notice => 'Question was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @question.errors, :status => :unprocessable_entity }
      end
    end
  end


  def destroy
    @question = Question.find(params[:id])
    @question.destroy

    respond_to do |format|
      format.html { redirect_to(questions_url) }
      format.xml  { head :ok }
    end
  end
end
