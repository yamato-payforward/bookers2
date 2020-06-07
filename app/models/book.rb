class Book < ApplicationRecord
  belongs_to :user
  validates :title, presence: true
  validates :body, length: { minimum: 1,maximum: 200 }, presence: { message: 'error,enter your opinion 1 to 200 characters' }
end
