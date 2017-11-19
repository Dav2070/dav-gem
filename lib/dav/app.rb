module Dav
   class App
      attr_accessor :name, :description, :published, :id
      
      def initialize(attributes)
         @name = attributes["name"]
         @description = attributes["description"]
         @published = attributes["description"]
         @id = attributes["id"]
      end
      
      def self.create(user, name, desc)
         create_app_url = Dav::API_URL + 'apps/app?name=' + name + '&desc=' + desc
         json = send_http_request(create_app_url, user.jwt, "POST")
         app = App.new(json)
      end
      
      def self.get(user, id)
         get_app_url = Dav::API_URL + 'apps/app/' + id.to_s
         json = send_http_request(get_app_url, user.jwt, "GET")
         app = App.new(json)
      end
      
      def log_event(auth, name)
         create_event_url = Dav::API_URL + 'analytics/event?name=' + name + '&app_id=' + @id.to_s
         json = send_http_request(create_event_url, create_auth_token(auth), "POST")
         event = Event.new(json)
      end
   end
end