class Brek < ApplicationRecord
  validates :message, presence: true

  belongs_to :user
end
