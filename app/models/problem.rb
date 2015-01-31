class Problem < ActiveRecord::Base
  belongs_to :user

  delegate :name, :email, to: :user, prefix: true

  has_many :notes

  validates :description, presence: true
  validates :history, presence: true
  validates :user, presence: true

  paginates_per 5

  after_create :send_email

  def send_email
    UserMailer.new_problem(id).deliver
  end
end
