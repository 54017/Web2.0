if Meteor.isClient
	Template['homework'].onRendered !->
		$ '#home' .on 'click', !->
			Session .set "page" 0
		$ '#settings' .on 'click', !->
			Session .set "page" 2
		$ '#sidebarBt' .on 'click', !->
			$ '.sidebar.menu' .sidebar 'toggle'
		$ 'body' .removeClass 'pushable'
		$ '#task' .val(Session.get("taskId"))
		$ '.backBt' .on 'click', !->
			Session .set "page" 1
		$ '#signout' .on 'click', !->
			Meteor .logout (err) !->
				if err
					alert "error occured"
				else
					$ 'body' .removeClass 'pushable'
		$ '.grade' .blur !->
			homeworkId = $ @ .attr 'name'
			grade = $ @ .text!
			$ @ .val "xxx"
			Homeworks .update {_id: homeworkId},
				{$set: {
					grade: grade
					}
				}

	Template['homework'].helpers {
		isTeacher: ->
			Meteor .user! .profile.role is "Teacher"
		isStudent: ->
			Meteor .user! .profile.role is "Student"
		submissions: ->
			taskId = Session .get "taskId"
			Homeworks .find({task:  taskId}) .fetch!
		download: (homework)->
			taskId = Session .get "taskId"
			if Meteor .user! .profile .role is "Teacher"
				return true
			submission = Homeworks .find-one {task: taskId, student: Meteor .userId!}
			if submission is undefined
				return false
			homework._id is submission._id 
		timeOut: ->
			taskId = Session .get "taskId"
			Meteor .call 'timeout', taskId, (error, result) !->
				Session .set "timeOut", result
			return Session .get "timeOut"
		getUrl: (homework) ->
			Files .find-one({_id: homework.file}).url()
	}

	Template['homework'].events {
		'change #file': (event, template) ->
			taskId = $ '#task' .val!
			file = $ '#file' .get 0 .files[0]
			fileObj = Files .insert file, (err, fileObj) ->
				if err
					console.log  err
				homework = Homeworks .find-one {task: taskId, student: Meteor .userId!}
				if homework is undefined
					Homeworks .insert {
						title: fileObj.name!
						student: Meteor.userId!
						file: fileObj._id
						task: taskId
					}
				else
					Homeworks .update {_id: homework._id},
						{$set:{
							title: fileObj.name!
							file: fileObj._id
							}
						}
			return
	}