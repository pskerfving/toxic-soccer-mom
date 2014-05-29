class PaymentsController < ApplicationController

  before_filter :cleared_required, :only => [:new, :destroy]
  before_filter :admin_required, :only => [:index, :destroy, :show]

  # GET /payments
  # GET /payments.json
  def index
    @payments = Payment.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @payments }
    end
  end

  # GET /payments/1
  # GET /payments/1.json
  def show
    @payment = Payment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @payment }
    end
  end

  # GET /payments/new
  # GET /payments/new.json
  def new

    if Payment.where(:user_id => current_user.id).length > 0

      redirect_to current_user, notice: 'You already paid. Enjoy it!'

    else
    
      @payment = Payment.new

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @payment }
      end
    end
  end

  # POST /payments
  # POST /payments.json
  def create
    # The session has been lost, so we need to reset the user id.
    session[:user_id] = params[:user_id]

    @payment = Payment.new
    @payment.paymill_token = params[:paymillToken]
    @payment.user = current_user

#    payment = Paymill::Payment.create(token: @payment.paymill_token)
#    @payment.paymill_payment_id = payment.id

    transaction = Paymill::Transaction.create(amount: '15000', currency: 'SEK', description: "Customer: #{current_user.id}", token: @payment.paymill_token)
    @payment.paymill_payment_id = transaction.id

    # Tag the user as eligable to place bets.
    user = User.find(current_user)
    user.wine = true
    user.save

    respond_to do |format|
      if @payment.save
        format.html { redirect_to :root, notice: 'Your payment has been ordered with our payment supplier (Paymill).' }
        format.json { render json: @payment, status: :created, location: @payment }
      else
        format.html { render action: "new" }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payments/1
  # DELETE /payments/1.json
  def destroy
    @payment = Payment.find(params[:id])
    @payment.destroy

    respond_to do |format|
      format.html { redirect_to payments_url }
      format.json { head :no_content }
    end
  end
end
