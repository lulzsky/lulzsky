class CalendarController < ApplicationController
  layout 'application'
  def getjson
  	   	unless session[:signed_in] == true
  		redirect_to '/login'
  		end
  		user = User.find_by(oasid: session[:oasusr])
 
  		if user.schedule.size > 2
  		user.schedule[user.schedule.size-2] = ""
		user.schedule[user.schedule.size-3] = ""
		end
  	   	render layout: false                 
  end
end
