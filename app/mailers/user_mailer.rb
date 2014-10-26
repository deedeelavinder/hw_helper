class UserMailer < ActionMailer::Base
  default from: "no-reply@hw_helper.com"

  def new_problem(problem_id)
    @problem = Problem.find(problem_id)
    create_mail(@problem.user, "Your problem was added to Homework Helper")
  end

  def new_note(note_id)
    @note = Note.find(note_id)
    @problem = @note.problem
    create_mail(@note.user, "A note was added to your problem on Homework Helper")
  end


  private

  def create_mail(user, msg)
    @user = user
    @greeting = "Hello #{@user.name}"
    mail to: @user.email, subject: msg
  end

end
