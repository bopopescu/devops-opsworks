default['rawiron']['services'] = {}


default['rawiron']['define']['service_groups'] = {

'standard' => {
	'user' => 'default', 
	'facebook' => 'default', 
	'friends' => 'default', 
	'gamestate' => 'default',
	'staticdata' => 'default',

	'gifts' => false,
},

'friends_server' => {
	'friends' => 'nosql', 
},

}



default['rawiron']['define']['services'] = {

'user' => {
	'game_user'  => {
		'default' => 'sql',
		'nosql'  =>'game_core.services.user.UserNosqlService',
		'sql'  => 'game_core.services.user.UserService'
	},

	'unregistered' => {
		'default' => 'sql',
		'nosql' => 'game_core.services.user.UnregisteredNosqlService',
		'sql' => 'game_core.services.user.UnregisteredUserService'
	},

	'session' => {
		'default' => 'sql',
		'nosql' => 'game_core.services.session.SessionNosqlService',
		'sql' => 'game_core.services.session.SessionService',
		'restful' => nil
	},

	'authentication' => {
		'default' => 'sql',
		'nosql' => 'game_core.services.authentication.AuthenticationNosqlService',
		'sql' => 'game_core.services.authentication.AuthenticationService',
	},
},


'gifts' => {
	'default' => 'sql',
	'nosql' => nil,
	'sql' => nil,
	'restful' => nil,
},

'staticdata' => {
	'default' => 'sql',
	'nosql' => nil,
	'sql' => nil,
	'restful' => nil,
},


'facebook' => {
	'user' => {
		'default' => 'sql',
		'sql' => 'game_core.services.facebook.FacebookService',
		'nosql' => 'game_core.services.facebook.FacebookNosqlService',
		'restful' => nil,
	},

	'graph' => {
		'default' => 'restful',
		'sql' => nil,
		'nosql' => nil,
		'restful' => {'plugin' => nil, 'url' => "Fakebook-<instance>.elb.amazonaws.com"},
	},
},


'gamestate' => {
	'default' => 'sql',
	'nosql' => 'game_core.services.persistence.NosqlPersistenceService',
	'sql' => 'game_core.services.persistence.DbPersistenceService'
},


'friends' => {
	'default' => 'restful',
	'sql' => 'game_core.services.friends.LocalFriendService',
	'nosql' => 'game_core.services.friends.FriendsNosqlService',
	'restful' => {
		'plugin' => 'game_core.services.friends.FriendService',
		'url' => "FriendsDev-<instance>.elb.amazonaws.com",
	}
},

}