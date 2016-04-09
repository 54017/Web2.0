if Meteor.isClient

	Template['student'].onCreated !->
		Meteor .subscribe "allUserData"
		Session .setDefault "page" 0
	
	Template['student'].helpers {
		isStudent: ->
			Meteor .user!.profile.role is "Student"
		viewTeacher: ->
			index = Session .get "page"
			return index is 0
		userInfo: ->
			index = Session .get "page"
			return index is 2
		viewTasks: ->
			index =Session .get "page"
			return index is 1
		submissions: ->
			index = Session .get "page"
			return index is 3
	}	