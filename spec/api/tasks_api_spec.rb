require 'airborne'

describe 'sample spec' do 
	it 'should get the tasks by user' do
		get 'http://localhost:3000/api/tasks'
		expect_json_types({tasks: ["one", "two"]})
	end
end