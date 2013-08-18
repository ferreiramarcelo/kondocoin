class Voucher < ActiveRecord::Base
  #attr_protected :state
  # TODO: Use params(strong_parameters) to restrict access.
  
  before_save { code.downcase! }

  validates :code, 
    presence: true,
    uniqueness: { case_sensitive: false},
    format: {
      :with => /\A[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}\z/,
      :message => "Voucher has invalid code format"
    }

  validates :wallet, 
    presence: false,
    format: {
      :with => /\A[13n][1-9A-Za-z][^OIl]{20,40}\z/,
      :message => "Voucher has invalid wallet address format"
    },
    :allow_blank => true

  validates :eurovalue, 
    presence: true,
    :numericality => {
      :greater_than => 0.0,
      :message => "Voucher value must be greater than zero"
    }

  validates :payout_value, 
    presence: false,
    :numericality => {
      :greater_than_or_equal_to => 0.0,
      :message => "Payout value must be non-negative than zero",
      :allow_nil => true
    }

  # See https://github.com/pluginaweek/state_machine for state machine
  # documentation.
  state_machine :initial => :new do
    event :hardcopy do
      transition :new => :active
    end
    event :redeem do
      transition :active => :redeemed
    end
    event :payout do
      transition :redeemed => :completed
    end
  end

end

