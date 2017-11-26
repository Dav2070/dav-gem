module Dav
   class App
      attr_accessor :name, :description, :published, :id
      
      def initialize(attributes)
         @id = attributes["id"]
         @name = attributes["name"]
         @description = attributes["description"]
         @published = attributes["published"]
      end
      
      def self.create(jwt, name, desc)
         url = Dav::API_URL + 'apps/app?name=' + name + '&desc=' + desc
         result = send_http_request(url, "POST", {"Authorization" => jwt}, nil)
         if result["code"] == 201
            app = App.new(JSON.parse result["body"])
         else
            raise_error(JSON.parse result["body"])
         end
      end
      
      def self.get(jwt, id)
         url = Dav::API_URL + "apps/app/#{id}"
         result = send_http_request(url, "GET", {"Authorization" => jwt}, nil)
         if result["code"] == 200
            app = App.new(JSON.parse result["body"])
         else
            raise_error(JSON.parse result["body"])
         end
      end
      
      def update(jwt, properties)
         url = Dav::API_URL + "apps/app/#{@id}"
         result = send_http_request(url, "PUT", {"Authorization" => jwt, "Content-Type" => "application/json"}, properties)
         if result["code"] == 200
            @name = JSON.parse(result["body"])["name"]
            @description = JSON.parse(result["body"])["description"]
         else
            raise_error(JSON.parse result["body"])
         end
      end
      
      def delete(jwt)
         url = Dav::API_URL + "apps/app/#{@id}"
         result = send_http_request(url, "DELETE", {"Authorization" => jwt}, nil)
         if result["code"] == 200
            JSON.parse(result["body"])
         else
            raise_error(JSON.parse result["body"])
         end
      end
      
      def log_event(auth, name)
         url = Dav::API_URL + "analytics/event?name=#{name}&app_id=#{@id}"
         result = send_http_request(url, "POST", {"Authorization" => create_auth_token(auth)}, nil)
         if result["code"] == 201
            event = Event.new(JSON.parse result["body"])
         else
            raise_error(JSON.parse(result["body"]))
         end
      end
   end
end