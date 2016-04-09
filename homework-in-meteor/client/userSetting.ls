if Meteor.isClient
	Template['userSetting'].onRendered !->
		$ ".dropdown" .dropdown!
		$ '#works' .on 'click', !->
			Session .set "page" 1
		$ '#home' .on 'click', !->
			Session .set "page" 0
		$ '#settings' .on 'click', !->
			Session .set "page" 2
		$ '#sidebarBt' .on 'click', !->
			$ '.sidebar.menu' .sidebar 'toggle'
		$ '#signout' .on 'click', !->
			Meteor .logout (err) !->
				if err
					alert "error occured"
				else
					$ 'body' .removeClass 'pushable'
		$ '#updateBt' .on 'click', !->
			firstName = $ 'input[name=firstName]' .val!
			lastName = $ 'input[name=lastName]' .val!
			introduction = $ 'textarea[name=introduction]' .val!
			email = $  'input[name=email]' .val! + $ ".text" .text!
			Meteor .call 'updateSettings', firstName, lastName, email, introduction
			$ '.success.message' .css 'display', 'block'
		$ ->
			email = Meteor .user! .emails[0] .address
			index = email .indexOf '@'
			$ 'input[name="email"]' .val (email .substr 0 index)
			$ '.active.selected' .removeClass 'active selected'
			item = email .substr index
			$ ("div[name='" + item + "'']") .addClass 'active selected'
			$ 'div.text' .text item

	Template['userSetting'].helpers {
		getTasks: ->
			Tasks .find({publisher:  Meteor.userId!}) .fetch!
		timeOut: (item) ->
			Meteor .call 'timeout', item._id, (error, result) !->
				Session .set item._id, result
			return Session .get item._id
		image: ->
			Meteor .users .find-one {_id: Meteor.userId!},
				{fields: {"profile.image": 1}}
		imageFound: ->
			image = Meteor .users .find-one {_id: Meteor.userId!}, {fields: {"profile.image": 1}}
			image.profile.image != undefined
		isTeacher: ->
			Meteor.user!.profile.role is "Teacher"
		getImage: (id)->
			image = Images .find-one({_id: id});
			image.url!
	}

	Template['userSetting'].events {
		'change #file': (event, template) ->
			file = $ '#file' .get 0 .files[0]
			fileObj = Images .insert file
			Meteor .users .update {_id: Meteor.userId!},
				{$set:{
					"profile.image": fileObj._id
					}
				}
	}