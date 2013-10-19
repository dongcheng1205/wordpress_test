#encoding: utf-8

def login(browser, user_name, password)
	login_url = 'http://localhost/wordpress/wp-login.php'
	browser.goto login_url
	browser.text_field(:id, 'user_login').set user_name
	browser.text_field(:id, 'user_pass').set password
	browser.button(:id, 'wp-submit').click
end

def goto_list_page(browser)
	list_url = 'http://localhost/wordpress/wp-admin/edit.php'
	browser.goto list_url
end

def create_post(browser, post_title, content)
	create_post_url = 'http://localhost/wordpress/wp-admin/post-new.php'
	browser.goto create_post_url	
	browser.text_field(:name, 'post_title').when_present.set post_title
	script = "document.getElementById('content_ifr').contentWindow.document.body.innerHTML='#{content}'"
	browser.wd.execute_script(script)
	browser.button(:name, 'publish').when_present.click
end

def delete_all_posts(browser)
	list_url = 'http://localhost/wordpress/wp-admin/edit.php'
	browser.goto list_url
	browser.checkbox(:id, 'cb-select-all-1').set true	
	browser.select(:name, 'action').options.last.click
	browser.button(:id, 'doaction').click
end

def delete_post_by_title(browser, title)
	# 寻找post
	goto_list_page(browser)
	browser.link(:text, title).hover

	# 删除post
	browser.link(class: 'submitdelete').when_present.click
end
