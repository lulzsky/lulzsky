class MessagesController < ApplicationController
	  layout 'application'
  def show


  	        @usragent = 'Mozilla/5.0 (Windows NT 5.1; rv:27.0) Gecko/20100101 Firefox/27.0'
          c = Curl::Easy.new
          c.url = ("http://corruption is f*cking bad/students/home/index_new.php")
          c.headers["User-Agent"] = @usragent
            c.verbose = true
            c.enable_cookies = true
          c.perform
          @verification_code = c.body_str.scan(/(?<=strong\> )[0-9]{4}/)[0]
          @oasis_time = c.body_str.scan(/[0-9][0-9]:[0-9][0-9]:[0-9][0-9]/)[0]
          c.url = ("http://corruption is f*cking bad/students/system/system_login.php")
          c.http_post(Curl::PostField.content('inputUname2', session[:oasusr]),
                Curl::PostField.content('inputUname', session[:oaspwd]),
                Curl::PostField.content('inputPassword', session[:oaspwd]),
                Curl::PostField.content('vc', @verification_code),
                Curl::PostField.content('btlogin', 'LogIn'))
          c.perform

          c.url = ("http://corruption is f*cking bad/students/home/main.php")
          c.perform

          if params[:id].to_i <= session[:msgid].size
          c.url = ("http://corruption is f*cking bad/students/home/read_message.php?msgid="+session[:msgid][params[:id].to_i.-1].join)
          c.perform
  		  @test = c.body_str.scan(/\+1"><strong>(.*?)<\/strong>/).join.html_safe
  		  else
  		  redirect_to '/messages'
  		  end

  end

end
