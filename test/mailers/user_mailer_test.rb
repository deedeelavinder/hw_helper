require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test 'new_problem' do
    user = users(:one)
    problem = problems(:one)
    problem.user = user
    problem.save
    mail = UserMailer.new_problem(problem.id)
    assert_equal 'Your problem was added to Homework Helper', mail.subject
    assert_equal [user.email], mail.to
    assert_equal ['no-reply@hw_helper.com'], mail.from
  end

  test 'new_note' do
    user = users(:one)
    note = notes(:one)
    problem = problems(:one)
    note.user = user
    note.problem = problem
    note.save
    mail = UserMailer.new_note(note.id)
    assert_equal 'A note was added to your problem in Homework Helper', mail.subject
    assert_equal [user.email], mail.to
    assert_equal ['no-reply@hw_helper.com'], mail.from
  end
end
