class Payment < ActiveRecord::Base
  belongs_to :loan

  validates :loan, presence: true
  validate :under_remaining_amount

  def under_remaining_amount
    if loan &&
       amount > loan.remaining_amount
      errors.add(:amount, 'over remaining amount')
    end
  end
end
