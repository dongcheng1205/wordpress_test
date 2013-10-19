#encoding: utf-8
require 'watir-webdriver'
require './spec/public_function' 

describe 'Create Post' do
	before :all do
		puts 'start browser'
		@b = Watir::Browser.new :chrome
		# 如何在watir里面使用原生的webdriver
		#@b.wd == Selenium::WebDriver.for(:chrome)
		@password = @user_name = 'admin'
	end

	before :each do
		login(@b, @user_name, @password)
	end

	it 'should login successfully' do
		# String#include
		@b.title.should include('仪表盘')
		@b.link(:href, 'http://localhost/wordpress/wp-admin/profile.php').text.should include(@user_name)
	end

	it 'should create post successfully' do
		post_title = "my post created at #{Time.now.to_s}"
		content = 'this is my post'

		create_post(@b, post_title, content)
		@b.div(:id, 'message').text.should include('文章已发布')
	end

	it 'should create post successfully and verify post list page' do
		post_title = "my post created at #{Time.now.to_s}"
		content = 'this is my post'

		create_post(@b, post_title, content)

		# 跳转到文章列表页面
		goto_list_page(@b)
		@b.table(:class, 'wp-list-table')[2][1].text.should eql(post_title)
	end

	it 'should move all posts to garbige' do
		post_title = "my post created at #{Time.now.to_s}"
		content = 'this is my post'
		create_post(@b, post_title, content)

		# 跳转到文章列表页面
		delete_all_posts(@b)
		@b.table(:class, 'wp-list-table').rows.size.should eql(3)
	end

	it 'edit post successfully' do
		# 创建一篇文章
		post_title = 'my post'
		content = 'this is post'
		create_post(@b, post_title, content)

		# 查找这篇文章
		title_after_edit = 'after edit'
		goto_list_page(@b)
		@b.link(:text, post_title).click

		# 修改这篇文章
		@b.text_field(:id, 'title').set title_after_edit
		@b.button(:id, 'publish').click

		# 查找这篇文章
		goto_list_page(@b)
		# 断言	
		begin
			# should 和 should_not
			@b.link(:text, title_after_edit).should be_exist # link.exist? is true
			@b.link(:text, title_after_edit).exist?.should be_true
		ensure
			delete_all_posts(@b)		
		end

		# cleanup
	end

	after :all do
		@b.close
	end
end
