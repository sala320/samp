module MakeUser
  
def makeuser
  @user = User.new(name: "Example user", email: "user@example.com", password: "foobar", password_confirmation: "foobar")
end

end
