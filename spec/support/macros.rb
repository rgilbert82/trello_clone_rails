def set_current_user(user=nil)
  session[:user_id] = (user || Fabricate(:user)).id
end

def set_current_admin(admin=nil)
  session[:user_id] = (admin || Fabricate(:admin)).id
end

def login(a_user=nil)
  user = a_user || Fabricate(:user)
  visit login_path
  fill_in "Email", with: user.email
  fill_in "Password", with: user.password
  # click_button "Sign in"
  find("input[type='submit']").click
end

def logout
  visit logout_path
end

def fill_in_valid_card
  fill_in "Credit Card Number", with: "4242424242424242"
  fill_in "Security Code", with: "123"
  select "7 - July", from: "date_month"
  select "2021", from: "date_year"
end

def fill_in_invalid_card
  fill_in "Credit Card Number", with: "4000000000000069"
  fill_in "Security Code", with: "123"
  select "7 - July", from: "date_month"
  select "2021", from: "date_year"
end
