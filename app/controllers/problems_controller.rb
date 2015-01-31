class ProblemsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :update]
  before_action :set_problem, only: [:show, :update]

  def index
    @problems = Problem.order(created_at: :desc).page params[:page]
  end

  def new
    @problem = Problem.new
  end

  def create
    @problem = current_user.problems.build(problem_params)

    if @problem.save
      redirect_to @problem, success: 'Your problem has been posted.'
    else
      render :new
    end
  end

  def update
    return unless problem_params[:resolved] == 'true'
    @problem.resolved = true
    @problem.save
    redirect_to problems_path
  end

  def show
    @notes = @problem.notes
    @note = Note.new
  end

  private

  def set_problem
    @problem = Problem.find(params[:id])
  end

  def problem_params
    params.require(:problem).permit(:description, :history, :resolved)
  end
end
