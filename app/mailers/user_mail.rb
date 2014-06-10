class UserMail < ActionMailer::Base
  default from: "from@example.com"

   def test(user)
    @user = user
    mail(:to =>  user.email, :subject =>  "Welcome to My Awesome Site")
  end
end
