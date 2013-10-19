#encoding: utf-8
require 'watir-webdriver'
require './spec/public_function'

describe 'Delete Post' do
	before :all do
		puts 'start browser'
		@b = Watir::Browser.new :chrome
		@password = @user_name = 'admin'
	end

	before :each do
		login(@b, @user_name, @password)
	end
=begin
	it 'should login successfully' do
		# String#include
		@b.title.should include('仪表盘')
		@b.link(:href, 'http://localhost/wordpress/wp-admin/profile.php').text.should include(@user_name)
	end
=end
	it 'should delete post successfully' do
		# delete by title
		post_title = "my post to delete"
		content = 'this is my post'

		# 创建post
		create_post(@b, post_title, content)
		delete_post_by_title(@b, post_title)

		# 断言
		begin
			@b.link(:text, post_title).should_not exist
			@b.link(:text, post_title).exists?.should be_false
		ensure
			delete_all_posts(@b)
		end

	end

	after :all do
		@b.close
		#@b.wd.quit
	end
end
