require 'test_helper'

class ProblemsControllerTest < ActionController::TestCase
  def valid_problem_data
    { problem: { description: "How do I #{Faker::Hacker.verb} #{Faker::Hacker.noun}?",
                 history: Faker::Lorem.paragraph,
                 resolved: false } }
  end

  def invalid_problem_data
    { problem: { description: '',
                 history:  '',
                 resolved: false } }
  end

  def setup
    @user = User.create!(name: 'demodude',
                         email: 'guy@gmail.com',
                         password: '11111178',
                         password_confirmation: '11111178')
  end

  context 'GET problems#index' do
    setup { get :index }

    should render_template('index')
    should respond_with(:success)

    should 'load problems' do
      assert assigns[:problems], 'Should load problems'
    end
  end

  context 'GET problems#show' do
    setup { get :show, id: problems(:one) }

    should render_template('show')
    should respond_with(:success)

    should 'load problem' do
      assert_equal problems(:one), assigns[:problem]
    end
  end

  context 'GET problems#new' do
    context 'when not logged in' do
      setup { get :new }

      should 'redirect to login' do
        assert_redirected_to new_user_session_path
      end
    end

    context 'when logged in' do
      setup do
        sign_in @user
        get :new
      end

      should render_template('new')
      should respond_with(:success)

      should 'instantiate a problem object' do
        assert assigns[:problem], 'Should have a problem'
      end
    end
  end

  context 'POST problems#create' do
    context 'when not logged in' do
      setup { post :create, valid_problem_data }

      should 'redirect to login' do
        assert_redirected_to new_user_session_path
      end
    end

    context 'when logged in' do
      setup { sign_in @user }
      context 'with invalid data' do
        setup do
          post :create, invalid_problem_data
        end

        should render_template(:new)

        should 'instantiate an invalid problem object' do
          assert_invalid_model(:problem)
        end
      end

      context 'with valid data' do
        setup do
          post :create, valid_problem_data
        end

        should 'create a problem' do
          assert_saved_model(:problem)
        end

        should 'redirect to problem' do
          assert_redirected_to problem_path(assigns[:problem])
        end
      end
    end
  end
end
