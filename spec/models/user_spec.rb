require 'rails_helper'

RSpec.describe User, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  before :each do
  	@user = FactoryGirl.create(:user)
  end

  it('should generate an auth_token') do
  	expect(@user.token).to exist?
  end
end
