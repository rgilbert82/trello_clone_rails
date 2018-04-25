class Admin::PaymentsController < Admin::AdminsController
  def index
    @payments = Payment.all
  end
end
