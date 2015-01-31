class NotesController < ApplicationController
  before_action :authenticate_user!

  def create
    @problem = Problem.find(params[:problem_id])
    @notes = @problem.notes
    @note = @problem.notes.build(note_params)
    @note.user = current_user

    respond_to do |format|
      format.js do
        if @note.save_and_notify
          render :create, status: :created
        else
          render nothing: true, status: :bad_request
        end
      end
        format.html do
          if @note.save_and_notify
            redirect_to @note
          else
            render 'problems/show'
          end
        end
      end
    end

  private

  def note_params
    params.require(:note).permit(:text, :problem_id)
  end

end
