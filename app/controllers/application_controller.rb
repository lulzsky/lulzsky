class ApplicationController < ActionController::Base
  # protect_from_forgery with: :exception
  layout 'application'

  def home
        session[:pg] = 0
  	    unless session[:signed_in] == true
  		  redirect_to '/login'
  		  end
          
  end


  def about
        unless session[:signed_in] == true
        redirect_to '/login'
        end         
  end

  def messages
        session[:pg] = 2
        unless session[:signed_in] == true
        redirect_to '/login'
        end
  end

  def calendar
        session[:pg] = 1
        unless session[:signed_in] == true
        redirect_to '/login'
    end
  end

    def status
        session[:pg] = 7
        unless session[:signed_in] == true
        redirect_to '/login'
    end
  end

  def push
       render layout: false
          user = User.find_by(oasid: "5180490")
          @usragent = 'Mozilla/5.0 (Windows NT 5.1; rv:27.0) Gecko/20100101 Firefox/27.0'
          c = Curl::Easy.new
          c.url = ("http://(*school) doesn't care about tech people/students/home/index_new.php")
          c.headers["User-Agent"] = @usragent
          c.verbose = true
          c.enable_cookies = true
          c.perform
          @verification_code = c.body_str.scan(/(?<=strong\> )[0-9]{4}/)[0]
          @oasis_time = c.body_str.scan(/[0-9][0-9]:[0-9][0-9]:[0-9][0-9]/)[0]
          c.url = ("http://(*school) doesn't care about tech people/students/system/system_login.php")
          c.http_post(Curl::PostField.content('inputUname2', user.oasid),
                Curl::PostField.content('inputUname', user.oaspw),
                Curl::PostField.content('inputPassword', user.oaspw),
                Curl::PostField.content('vc', @verification_code),
                Curl::PostField.content('btlogin', 'LogIn'))
          c.perform
          c.url = ("http://(*school) doesn't care about tech people/students/home/main.php")
          c.perform
          @temptopic = Array.new
          @msgtopic = c.body_str.scan(/left=100 ' \)">(.*?)<\/a>/)
          @msgid = c.body_str.scan(/gid=(.*?)'/m)
          @newid = user.newmsgid
          gmail = Gmail.connect("notificationslulzsky@gmail.com", "dealwithitBY")
          user.update(newmsgid: @msgid[0].join)
                if @msgid[0].join > @newid
                (0..@msgtopic.size-1).each do |i| 
                  if @msgid[i].join.to_i > @newid.to_i
                      @temptopic << @msgtopic[i]
                      @temptopic << "\n"
                      tester = @msgtopic[i]
                      c.url = ("http://(*school) doesn't care about tech people/students/home/read_message.php?msgid="+@msgid[i].join)
                      c.perform
                      contenttest = c.body_str.scan(/\+1"><strong>(.*?)<\/strong>/).join.html_safe
                      email = gmail.compose do 
                        to user.email
                        subject tester
                        html_part do
                          body contenttest
                        end
                      end
                    email.deliver!
                  end
                end
                end
          gmail.logout
          c.url = ("http://(*school) doesn't care about tech people/students/system/system_logout.php")
          c.perform
  end


    def payments
        session[:pg] = 6
        unless session[:signed_in] == true
        redirect_to '/login'
        end

      @usragent = 'Mozilla/5.0 (Windows NT 5.1; rv:27.0) Gecko/20100101 Firefox/27.0'
          c = Curl::Easy.new
          c.url = ("http://(*school) doesn't care about tech people/students/home/index_new.php")
          c.headers["User-Agent"] = @usragent
            c.verbose = true
            c.enable_cookies = true
          c.perform
          @verification_code = c.body_str.scan(/(?<=strong\> )[0-9]{4}/)[0]
          @oasis_time = c.body_str.scan(/[0-9][0-9]:[0-9][0-9]:[0-9][0-9]/)[0]
          c.url = ("http://(*school) doesn't care about tech people/students/system/system_login.php")
          c.http_post(Curl::PostField.content('inputUname2', session[:oasusr]),
                Curl::PostField.content('inputUname', session[:oaspwd]),
                Curl::PostField.content('inputPassword', session[:oaspwd]),
                Curl::PostField.content('vc', @verification_code),
                Curl::PostField.content('btlogin', 'LogIn'))
          c.perform

          c.url = ("http://(*school) doesn't care about tech people/students/profile/registration.php")
          c.perform

          c.url = ("http://(*school) doesn't care about tech people/students/system/system_logout.php")
          c.perform
  end

    def cr
        session[:pg] = 4
        unless session[:signed_in] == true
        redirect_to '/login'


    end
  end

    def ar
        session[:pg] = 5
        unless session[:signed_in] == true
        redirect_to '/login'
    end
  end


def tos
      session[:oasusr] = params[:oasusr]
      session[:oaspwd] = params[:oaspwd]
   

      if User.exists?(oasid: session[:oasusr])
              redirect_to '/auth'
      
    else
     render layout: false
   end
end

  def login
        render layout: false
        session[:authfail] = 0
  end      


  def auth

  		if session[:oasusr] && session[:oaspwd]
          @usragent = 'Mozilla/5.0 (Windows NT 5.1; rv:27.0) Gecko/20100101 Firefox/27.0'
          c = Curl::Easy.new
          c.url = ("http://(*school) doesn't care about tech people/students/home/index_new.php")
          c.headers["User-Agent"] = @usragent
          c.verbose = true
          c.enable_cookies = true
          c.perform
          @verification_code = c.body_str.scan(/(?<=strong\> )[0-9]{4}/)[0]
          @oasis_time = c.body_str.scan(/[0-9][0-9]:[0-9][0-9]:[0-9][0-9]/)[0]
          c.url = ("http://(*school) doesn't care about tech people/students/system/system_login.php")
          c.http_post(Curl::PostField.content('inputUname2', session[:oasusr] ),
                Curl::PostField.content('inputUname', session[:oaspwd]),
                Curl::PostField.content('inputPassword', session[:oaspwd]),
                Curl::PostField.content('vc', @verification_code),
                Curl::PostField.content('btlogin', 'LogIn'))
          c.perform

          c.url = ("http://(*school) doesn't care about tech people/students/home/main.php")
          c.perform


          if c.body_str.size > 2000 
              # create and update user db
              user = User.create(oasid: session[:oasusr], oaspw: session[:oaspwd], fbuid: @number, maindump: c.body_str.encode("UTF-8", invalid: :replace, undef: :replace, replace: "?"))
              user = User.find_by(oasid: session[:oasusr])
              user.update(maindump: c.body_str.encode("UTF-8", invalid: :replace, undef: :replace, replace: "?"))

              #set session
          		session[:signed_in] = true
              session[:usrdata] = c.body_str.scan(/<b>(.*?)<\/b>/) 
              user.update(name:  session[:usrdata][1].join)
              user.update(last:  session[:usrdata][2].join)
              @newmsg =0
              #retrieve message topics
              session[:msgtopic] = c.body_str.scan(/left=100 ' \)">(.*?)<\/a>/)
              #retrieve message id
              session[:msgid] = c.body_str.scan(/gid=(.*?)'/m)

              session[:troll] = c.body_str.scan(/ICCS/m)
              #retrieve message dates & read status

              user.update(newmsgid: session[:msgid][0].join)
              @temp = user.maindump.html_safe.scan(/bgcolor=(.*?)myForm/m)
              @arr =Array.new
              @arr2 = Array.new
              @temp.each { |x| 
              @arr << x.inspect.scan(/[0-9][0-9]\/[0-9][0-9]\/[0-9][0-9][0-9][0-9]/)
              @arr2 << x.inspect.scan(/#[a-zA-Z]{6}/)
              }

              (1..session[:msgtopic].size-1).each do |i| 
                if @arr2[i][0] == '#EFDAEC'
                  @newmsg = @newmsg+1
                end
                  session[:msgnew] = @newmsg
                end
              session[:msgtime] = @arr
              session[:msgread] = @arr2

              #retrieve class schedules
              c.url = ("http://(*school) doesn't care about tech people/students/profile/scheduletable.php")
              c.perform
              # retrieve class id from system
              session[:classes] = c.body_str.scan(/value="(.*?)"/)
              # retrieve class name
              session[:cname] = c.body_str.scan(/[0-9]{3}&nbsp;\r\n\t\t\t\t\t\t\t\t\t\t(.*?)&nbsp;/m)

              session[:csched] = Array.new

              ccount = 0
            
              #retrieve class contents
              session[:classes].each { |x| 

              c.http_post(Curl::PostField.content('subject', x.join))
              c.perform
              session[:csched][ccount] = c.body_str.html_safe.scan(/<td align="center"> <strong>(.*?)<\/tr>/m)
              ccount = ccount + 1
              }
             
              @sc_dates = Array.new
              @sc_times = Array.new
              @sc_onsc = Array.new
              @sc_room = Array.new

              session[:calcolor] = ['9b59b6','e74c3c','3498db','1abc9c','f39c12','F5AEEB','CDF5AE','AEF5F5','F72354']

              (0..session[:csched].size-1).each do |i| 
                  @sc_dates[i] = Array.new
                  @sc_times[i] = Array.new
                  @sc_onsc[i] = Array.new
                  @sc_room[i] = Array.new
              end

              (0..session[:csched].size-1).each do |i| 
              session[:csched][i].each { |x| 
                  @sc_dates[i]  << x.inspect.scan(/[0-9][0-9]\/[0-9][0-9]\/[0-9][0-9][0-9][0-9]/)
                  @sc_times[i] << x.inspect.scan(/[0-9][0-9]:[0-9][0-9]/)
                  @sc_onsc[i]  << x.inspect.html_safe.scan(/ON SCHEDULE/)
                  @sc_room[i] << x.inspect.html_safe.scan(/<strong> \\r\\n(.*?)<\/strong><\/td>/m)
              }
              end

              # output class schedule to JSON
              @timetemp = Array.new
              time = Time.now
              @sc_output = Array.new
              @sc_output << "["
              session[:today] = Array.new
              (0..@sc_dates.size-1).each do |i| 
                    (0..@sc_dates[i].size-1).each do |j| 
                    # check today classes
                    if @sc_dates[i][j][0] == time.strftime("%d/%m/%Y")
                    session[:today] << {
                    :class => session[:cname][i].join,
                    :room => @sc_room[i][j],
                    :start => @sc_times[i][j][0][0,5],
                    :end => @sc_times[i][j][1][0,5]
                    }
                    end 


                      if @sc_onsc[i][j]
                      
                      @sc_output << "{
                                 \"title\": \""+session[:cname][i].join+"\",
                                 \"start\": \""+@sc_dates[i][j][0][6,4]+"-"+@sc_dates[i][j][0][3,2]+"-"+@sc_dates[i][j][0][0,2]+" "+@sc_times[i][j][0][0,2]+":"+@sc_times[i][j][0][3,2]+"\",
                                 \"end\": \""+@sc_dates[i][j][0][6,4]+"-"+@sc_dates[i][j][0][3,2]+"-"+@sc_dates[i][j][0][0,2]+" "+@sc_times[i][j][1][0,2]+":"+@sc_times[i][j][1][3,2]+"\",
                                 \"allDay\": false,
                                 \"color\": \"#"+session[:calcolor][i]+"\"
                                 },"      
                      end
                  end
              end

    

              @sc_output << "]"
    
              user.schedule = @sc_output.join
              user.save
              @extemp = Array.new
              session[:exams] = Array.new

              c.url = ("http://(*school) doesn't care about tech people/students/profile/finalexamlist.php")
              c.perform

              @extemp = c.body_str.scan(/bgcolor="#FFCCCC">(.*?)<td align="left"/m)



              
              session[:exams] = @extemp
              


              # disconnect with OASIS
              c.url = ("http://(*school) doesn't care about tech people/students/system/system_logout.php")
              c.perform
          		redirect_to '/home'

            elsif c.body_str.size < 2000 && c.body_str.size > 300  
            
              # bad password
              session[:authfail] = 1
              redirect_to '/login'
            else
              # still logged in
              session[:authfail] = 2
              redirect_to '/login'
  		    end

      end
  end


  def ratings
        session[:pg] = 8
        unless session[:signed_in] == true
        redirect_to '/login'
    end
  end

  def index
    redirect_to 'home'
  end


  def logout
  	session[:signed_in] = false
    session.destroy
  	redirect_to '/login'
  end

end