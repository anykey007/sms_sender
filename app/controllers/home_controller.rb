class HomeController < ApplicationController
  def index

  end

  def balance
    @balance, @sms_count = SMS.get_balance
  end
end
