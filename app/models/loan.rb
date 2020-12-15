class Loan < ActiveRecord::Base
  has_many :payments

  def total_paid
    payments.sum(&:amount)
  end

  def remaining_amount
    funded_amount - total_paid
  end

  # add calculated methods to json output
  def as_json(opts = {})
    opts ||= {} # prevent call on nil
    super(opts.merge({:methods => [
      :total_paid, 
      :remaining_amount]
    }))
  end
end
