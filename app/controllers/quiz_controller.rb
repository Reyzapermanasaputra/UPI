class QuizController < ApplicationController
  def index
    @topic = Topic.find(params[:id])
    @question = @topic.questions.new
  end

  def start
    @topic = Topic.find(params[:id])
    @question = @topic.questions.all
    all = @question.map {|x| x.id}

    session[:total]   = all.count
    total = session[:total].to_i
    session[:questions] = all.sort[0..(total - 1)]
    session[:current] = 0
    session[:correct] = 0
    session[:total] = total
	 redirect_to :action => "question"
  end

  def question
	 @current = session[:current]
	 @total   = session[:total]

	 if @current >= @total.to_i
	  redirect_to :action => "end"
	  return
	 end

	 @question = Question.find(session[:questions][@current])
	 @choices = @question.choices.sort_by{rand}

	 session[:question] = @question
	 session[:choices] = @choices
  end

  def answer
	 @current = session[:current]
	 @total   = session[:total]

	 choiceid = params[:choice]

	 @question = session[:question]
	 @choices  = session[:choices]

	 @choice = choiceid ? Choice.find(choiceid) : nil
	 if @choice and @choice.correct
		@correct = true
		session[:correct] += 1
	 else
		@correct = false
	 end

         session[:current] += 1
  end

  def end
	 @correct = session[:correct]
	 @total   = session[:total]

	 @score = @correct * 100 / @total
  end
end
