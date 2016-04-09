if Meteor .isServer
	Meteor .publish 'tasks', ->
		Tasks .find!
	Meteor .publish 'homeworks', ->
		Homeworks .find!
	Meteor .publish 'images', ->
		Images .find! 
	Meteor .publish 'files', ->
		Files .find! 
	Meteor .publish 'allUserData', ->
		if !this.userId
			console.log "not authorized"
			throw new Meteor .Error "not authorized"
		Meteor .users .find {}, {fields: {profile: 1, emails: 1}}
	Meteor .methods {
		addTask: (title, description, deadline) !->
			if !Meteor .userId!
				throw new Meteor .Error "not authorized"
			Tasks .insert {
				title: title
				description: description
				deadline: deadline
				publisher: Meteor .userId!
			}
		modifyTask: (id, title, description, deadline) !->
			if !Meteor .userId!
				throw new Meteor .Error "not authorized"
			Tasks .update {_id: id},
				{$set: {title: title, description: description, deadline: deadline}}
		deleteTask: (id) !->
			if !Meteor .userId!
				throw new Meteor .Error "not authorized"
			Tasks.remove {_id: id}
		getTasks: ->
			if !Meteor .userId!
				throw new Meteor .Error "not authorized"
			Tasks .find! .fetch!
		timeout: (id) ->
			if !Meteor .userId!
				throw new Meteor .Error "not authorized"
			date = new Date!
			day = ("0" + date.getDate!) .slice -2
			month = ("0" + (date.getMonth! + 1)) .slice -2
			str = date.getFullYear! + '/' + month + '/' + day + " " + date.toTimeString()
			Tasks .find-one {_id: id} .deadline < str
		updateSettings: (firstName, lastName, email, introduction) ->
			Meteor .users .update {_id: Meteor.userId!},
				{$set: {
					"profile.firstname": firstName, 
					"profile.lastname": lastName,
					"emails.0.address": email,
					"profile.introduction": introduction
					}
				}
		} 