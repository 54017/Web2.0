if Meteor.isClient
	initPage = !->
		$ ".dropdown" .dropdown!

		$ document .on 'focus', '#usernameDiv', !->
			$ @ .removeClass "error"

		$ document .on 'focus', '#passwordDiv', !->
			$ @ .removeClass "error"

		$ ".student" .on 'click' !->
			$ @ .removeClass 'positive'
			$ @ .addClass 'positive'
			$ ".teacher" .removeClass 'positive'

		$ ".teacher" .on 'click' !->
			$ @ .removeClass 'positive'
			$ @ .addClass 'positive'
			$ ".student" .removeClass 'positive'   

		$ ".male" .on 'click' !->
			$ @ .removeClass 'positive'
			$ @ .addClass 'positive'
			$ ".female" .removeClass 'positive'   

		$ ".female" .on 'click' !->
			$ @ .removeClass 'positive'
			$ @ .addClass 'positive'
			$ ".male" .removeClass 'positive'

		$ 'input' .focus !->
			$ '#passwordDiv' .removeClass 'error'
			$ '#usernameDiv' .removeClass 'error'

		$ '#usernameDiv input' .on 'focus' !->
			$ '#passwordDiv' .removeClass 'error'
			$ '#usernameDiv' .removeClass 'error'

	Template['account'].onCreated !->
		Session .setDefault "login" 1
		Session .setDefault "signup" 0
	
	Template['account'].helpers {
		isLog: ->
			temp = Session .get "login"
		isSign: ->
			temp = Session .get "signup"
	}

	Template['account'].onRendered !->
		initPage!
	
	Template['account'].events {
		'click #ifLog': !->
			Session.set "login" (Session.get("login") + 1)%2
			Session.set "signup" (Session.get("signup") + 1)%2
			set-timeout !-> initPage!
			, 0
		'submit #loginForm': (e,t) ->
			e .preventDefault!
			username = $ 'input[name=username]' .val!
			password = $  'input[name=password]' .val!
			Meteor .loginWithPassword username, password, (err) !->
				if err
					$ '#usernameDiv' .addClass "error"
					$ '#passwordDiv' .addClass "error"
			return false
		'submit #signupForm': (e,t) ->
			e .preventDefault!
			username = $ 'input[name=username]' .val!
			password = $  'input[name=password]' .val!
			email = $  'input[name=email]' .val! + $ ".text" .text!
			gender = $ ".positive" .eq 1 .text!
			role = $ ".positive" .eq 0 .text!
			firstname =  $  'input[name=firstname]' .val!
			lastname =  $  'input[name=lastname]' .val!
			Accounts .createUser {
				username: username,
				password: password, 
				email: email, 
				profile: {
					firstname: firstname,
					lastname: lastname,
					gender: gender,
					role: role
					introduction: "No profile yet"
				}
				}, (err) !->
				if err
					alert "error occured"
			return false
		}
