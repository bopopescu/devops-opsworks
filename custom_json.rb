module Rawiron
    module CustomJson

    attr_accessor :gatling, :racing, :cards, :fighting

    @gatling = {
      :cloud => {:provider => 'vagrant'},
      :rawiron => {:app => 'gatling',
                  :app_domain => 'localhost'}, 
	    :deploy => {'gatling' => {
                  :scm => {
                    :scm_type => "s3",
                    :user => "<your-access>",  # access key
                    :password => "<your-secret>",  # secret key
                    :repository => "https://s3.amazonaws.com/<your-domain>/software/gatling-2.0.0-M3a-bundle.zip"}} 
                }}
                
    @racing = {
      :cloud => {:provider => 'vagrant'},
      :rawiron => {:app => 'carchase',
                  :app_domain => 'localhost',
                  :stack => { :db_servers => {:layer => "app", :engine => "sqlite"} },
                }, 
      :django => {:app => 'racing',
                  :settings => 'local_settings',
                  :databases => [
                        {:alias => "default",
                         :name => "carchase"}, 
                        {:alias => "static_game_data", 
                         :name => "carchasestatic"}],
                  },
      :deploy => {'carchase' => {
                  :scm => {
                    :scm_type => "svn",
                    :ssh_key => nil,
                    :user => "RawironOps",
                    :password => "<your-password>",
                    :repository => "https://xp-dev.com/svn/racing/trunk/server"
                  }},
                  'gatling' => {}} 
                }

    @cards = {
      :cloud => {:provider => 'vagrant'},
      :rawiron => {:app => 'cards',
                  :app_domain => 'localhost',
                  :stack => { :db_servers => {:layer => "app", :engine => "sqlite"} },
                }, 
      :django => {:app => 'cardgame',
                  :settings => 'local_settings',
                  :databases => [
                        {:alias => "default",
                         :name => "cards"},
                        {:alias => "gamedata",
                         :name => "cardsstatic"},
                        {:alias => "game",
                         :name => "cardsgame"}],                           
                  },
      :deploy => {'cards' => {
                  :scm => {
                    :scm_type => "svn",
                    :ssh_key => nil,
                    :user => "RawironOps",
                    :password => "<your-password>",
                    :repository => "https://xp-dev.com/svn/cards/trunk/server"
                  }},
                  'gatling' => {}} 
                }

    @fighting = {
      :cloud => {:provider => 'vagrant'},
      :rawiron => {:app => 'fighting',
                  :app_domain => 'localhost',
                  :stack => { :db_servers => {:layer => "app", :engine => "sqlite"} },
                }, 
      :django => {:app => 'fighting',
                  :settings => 'local_settings',
                  :databases => [
                        {:alias => "default",
                         :name => "fighting"},
                        {:alias => "static_game_data",
                         :name => "fightingstatic"}],                           
                  },
      :python => { :pypi_proxy => "http://<user>:<password>@<ip>:8080/simple/" },
      :deploy => {'fighting' => {
                  :scm => {
                    :scm_type => "svn",
                    :ssh_key => nil,
                    :user => "<your-user",
                    :password => "<your-password",
                    :repository => "https://xp-dev.com/svn/fighting/trunk/server"
                  }},
                  'gatling' => {}} 
                }
	end
end
