#encoding: utf-8
require 'watir-webdriver'
require './spec/public_function' 

describe 'Create Category On Edit Post Page' do
	before :all do
		puts 'start browser'
		@b = Watir::Browser.new :chrome
		@password = @user_name = 'admin'
	end

	before :each do
		login(@b, @user_name, @password)
	end

	it 'should create category successfully' do
		parent = "parent#{Time.now.to_s}"
		child = "child#{Time.now.to_s}"

		begin
			add_category_on_edit_post_page(@b, parent)
			parent_label = @b.label(text: parent)

			parent_label.wait_until_present
			parent_label.should be_exist
			parent_label.checkbox().set?.should be_true

			#add_category_on_edit_post_page(@b, child, /^parent.+/)
			add_category_on_edit_post_page(@b, child, parent)
			@b.refresh

			parent_label.parent().ul(class: 'children').label.text.should eql(child)
		ensure
			delete_all_categories(@b)
		end
	end

	after :all do
		@b.close
	end
end
