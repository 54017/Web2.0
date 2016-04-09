if Meteor.isClient
	Template['works'].onRendered !->
		$ document .on 'click', '.viewSub', !->
			taskId = $ @ .attr 'name'
			Session .set "page" 3
			Session .set "taskId" taskId
		$ '.deleteBt' .on 'click', !->
			id = $ @ .attr 'id'
			Meteor .call 'deleteTask', id 
		$ '.modifyBt' .on 'click', !->
			id = $ @ .attr 'id'
			title = $ @ .parent! .siblings! .eq 0 .text!
			description = $ @ .parent! .siblings! .eq 2 .find 'p' .text!
			deadline = $ @ .parent! .siblings! .eq 1 .find 'span' .eq 1 .text!
			Meteor .call 'modifyTask', id, title, description, deadline
		$ '#works' .on 'click', !->
			Session .set "page" 1
		$ '#home' .on 'click', !->
			Session .set "page" 0
		$ '#settings' .on 'click', !->
			Session .set "page" 2
		$ '#sidebarBt' .on 'click', !->
			$ '.sidebar.menu' .sidebar 'toggle'
		$ '.backBt' .on 'click', !->
			Session .set 'page' 0
		$ 'body' .removeClass 'pushable'
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

	Template['works'].helpers {
		isTeacher: ->
			Meteor .user! .profile.role is "Teacher"
		getTasks: ->
			if Meteor.user!.profile.role is "Student"
				teacherId = Session .get "teacherId"
				Tasks .find({publisher:  teacherId}) .fetch!
			else
				Tasks .find({publisher:  Meteor.userId!}) .fetch!
	}