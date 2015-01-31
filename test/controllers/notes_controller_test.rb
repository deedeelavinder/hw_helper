require 'test_helper'

class NotesControllerTest < ActionController::TestCase
  def invalid_note_data
    { text: '' }
  end

  def valid_note_data
    { text: Faker::Hacker.say_something_smart }
  end

  def setup
    @user = User.create!(name: 'demodude',
                         email: 'guy@gmail.com',
                         password: '11111178',
                         password_confirmation: '11111178')
  end

  context 'POST notes#create' do
    context 'when not logged in' do
      setup { post :create, problem_id: problems(:one).id, note: {} }

      should 'redirect to login' do
        assert_redirected_to new_user_session_path
      end
    end

    context 'when logged in' do
      setup { sign_in @user }
      context 'with invalid data' do
        setup do
          post :create, { problem_id: problems(:one).id,
                          note: invalid_note_data },
               signed_in_session
        end

        should render_template('problems/show')

        should 'instantiate an invalid note object' do
          assert_invalid_model(:note)
        end
      end

      context 'with valid data' do
        setup do
          post :create, { problem_id: problems(:one).id,
                          note: valid_note_data },
               signed_in_session
        end

        should 'create an note' do
          assert_saved_model(:note)
        end

        should 'redirect to problem' do
          assert_redirected_to problems(:one)
        end
      end
    end
  end
end
