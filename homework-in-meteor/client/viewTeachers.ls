if Meteor.isClient
	InitialPage = !->
		$ '.special.cards .image' .dimmer {
			on: 'hover'
		}
		$ document .on 'click', '.follow', !->
			teacherId = $ @ .attr 'name'
			Meteor .users .update {_id: Meteor.userId!},
				{$push: {
					"profile.teachers": teacherId
					}
				}
		$ document .on 'click', '.unfollow', !->
			teacherId = $ @ .attr 'name'
			Meteor .users .update {_id: Meteor.userId!},
				{$pull: {
					"profile.teachers": teacherId
					}
				}
		$ document .on 'click', '.viewTasks', !->
			teacherId = $ @ .attr 'name'
			Session .set 'teacherId', teacherId
			Session .set "page" 1


	Template['viewTeachers'].onRendered !->
		set-timeout InitialPage, 1000
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
	Template['viewTeachers'].helpers {
		teachers: ->
			Meteor .users .find({"profile.role": "Teacher"})
		imageFound: (teacher) ->
			image = Meteor .users .find-one {_id: teacher._id}, {fields: {"profile.image": 1}}
			image.profile.image != undefined
		getEmail: (teacher) ->
			email = Meteor .users .find-one {_id: teacher._id}, {fields: {"emails": 1}}
			email.emails[0].address
		isFollowed: (teacher) ->
			(Meteor .users .find-one {_id: Meteor.userId!, "profile.teachers": teacher._id}) isnt undefined
		getImage: (id)->
			image = Images .find-one({_id: id});
			image.url!
	}