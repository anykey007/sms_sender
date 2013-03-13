class Client < ActiveRecord::Base
  attr_accessible :account_balance, :advance_payment, :is_wholesale_customer, :name, :phone, :city, :total_amount_of_purchases, :remote_id

  self.per_page = 20

  has_many :messages, :as => :messageble
  has_and_belongs_to_many :groups, :uniq => true  

  scope :wholesale_customers, where(:is_wholesale_customer=>1)
  scope :retail_customers, where(:is_wholesale_customer=>0)

  def wholesale_customer?
    is_wholesale_customer
  end

  def retail_customer?
    !wholesale_customer?
  end


  after_create do
    if self.wholesale_customer?
      self.groups<<Group.find(1)
    else
      self.groups<<Group.find(2)
    end
  end

end
