if Meteor.isClient
	Template['home'].onRendered !->
		$ '#datetimepicker' .datetimepicker!
		$ '#works' .on 'click', !->
			Session .set "page" 1
		$ '#settings' .on 'click', !->
			Session .set "page" 2
		$ '#sidebarBt' .on 'click', !->
			$ '.sidebar.menu' .sidebar 'toggle'
		$ '#home' .on 'click', !->
			Session .set "page" 0
		$ '#signout' .on 'click', !->
			Meteor .logout (err) !->
				if err
					alert "error occured"
				else
					$ 'body' .removeClass 'pushable'
		$ '#submitBt' .on 'click', !->
			title = $ 'input[name=title]' .val!
			description = $ 'textarea[name=description]' .val!
			deadline = $ 'input[name=deadline]' .val!
			Meteor .call 'addTask', title, description, deadline
			$ 'input[name=title]' .val ""
			$ 'textarea[name=description]' .val ""
			$ 'input[name=deadline]' .val ""
			$ '.success.message' .css 'display', 'block'
		$ '.close.icon' .on 'click', !->
			$ '.success.message' .css 'display', 'none'