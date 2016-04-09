if Meteor.isClient
	Template['teacher'].onCreated !->
		Session .setDefault "page" 0
	
	Template['teacher'].helpers {
		isTeacher: ->
			Meteor .user!.profile.role is "Teacher"
		post: ->
			index = Session .get "page"
			return index is 0
		grade: ->
			index = Session .get "page"
			return index is 1
		userInfo: ->
			index = Session .get "page"
			return index is 2
		submissions: ->
			index = Session .get "page"
			return index is 3
	}	