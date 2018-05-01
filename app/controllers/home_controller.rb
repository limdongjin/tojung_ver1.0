class HomeController < ApplicationController
  def index
    if params[:order] != nil
      print(params[:order])
	end
	  
	if !(current_vuser.blank?)
      if   # current_vuser.real_name == nil or
		   # current_vuser.address == nil or
		   current_vuser.phone_number == nil or
		   # current_vuser.real_name == "" or
		   current_vuser.phone_number == ""
		   #current_vuser.address == ""
		 redirect_to(edit_vuser_registration_path)
		 return
	  end
    end
	if params[:order] == "hot"
      @proposes = Vpropose.all.order("-funded_money")
	elsif params[:order] == "new"
	  @proposes = Vpropose.all.order("-created_at")
	elsif params[:order] == "voting"
	  @proposes = Vpropose.where(:status => "매칭진행중")
	elsif params[:order] == "deadl"
     @proposes = Vpropose.where("status like ?", "%펀딩%").order("created_at")
	else
      @proposes = Vpropose.all
	end 
	@proposes.each do |propose|
	    if propose.deadlines == nil
           next
		end
		if propose.deadlines - Time.now <= 0
	    	lll =  [ "펀딩진행중", "펀딩 마감 하루전", "펀딩 마감 이틀전" ]
			lll.each do |l|
				if l == propose.status
					propose.status = "매칭진행중"
				end
			end

		elsif propose.deadlines - Time.now <= (60*60*24)
			propose.status = "펀딩 마감 하루전"
		elsif propose.deadlines - Time.now <= (60*60*24)*2
			propose.status = "펀딩 마감 이틀전"
		end
		propose.save
	  end

  end

  def about
  end

  def mypage
    if (current_vuser.blank?) == true
	   redirect_to '/'
	   return
	end
	@user = current_vuser
	@transactions = Vtransaction.where(user_id: @user.id)
	@proposes=Vpropose.where(user_id: @user.id)
	@pack_dict = { }
	@prod_dict = { }
	@transactions.each do |tran|
		@pack_dict[tran.id] = Vpackage.find(tran.package_id)
		@prod_dict[tran.id] = Vproduct.find(tran.product_id)
	end
	# @prodcut = Vproduct.find(@transaction.product_id)
	# @package = Vpackage.find(@.pro
  end
end
