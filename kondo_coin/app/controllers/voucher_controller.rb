class VoucherController < ApplicationController

  #attr_accessor :btc_address, 
  #  :code1, :code2, :code3, :code4, :code5, :code6

  # claiming the bitcoins in here!
  def index

  end

  def redeem
    # TODO: Compose voucher code, search in DB.
    code = "#{params[:voucher][:code1]}-"
    code += "#{params[:voucher][:code2]}-"
    code += "#{params[:voucher][:code3]}-"
    code += "#{params[:voucher][:code4]}-"
    code += "#{params[:voucher][:code5]}-"
    code += "#{params[:voucher][:code6]}"
    voucher = Voucher.find_by_code(code);

    # store voucher id in session
    # see http://guides.rubyonrails.org/action_controller_overview.html#session
    
    if voucher 
      # Attempt to create payout 
      #flash[:success] = 'You ' 
      session[:current_voucher_id] = voucher.id;
      flash[:success] = session[:current_voucher_id]
      render 'payout'
    else
      flash[:error] = 'Invalid code.'
      render 'index'
    end
  end

  def payout
    if params[:voucher][:btc_address] =~ /^[13n][1-9A-Za-z][^OIl]{20,40}/
      # TODO: Transaction!
      reset_session
      render index
    else
      flash[:error] = 'Invalid wallet address - please enter a correct one.'
      render 'payout'
    end
  end

end
