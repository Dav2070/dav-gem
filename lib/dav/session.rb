module Dav
	class Session
		attr_accessor :id, :user_id, :app_id, :exp

		def initialize(attributes)
			@id = attributes["id"]
			@user_id = attributes["user_id"]
			@app_id = attributes["app_id"]
			@exp = attributes["exp"]
		end

		def self.create(auth_token, email, password, api_key, app_id)
			url = $api_url + "auth/session"
			result = send_http_request(
				url, 
				"POST", 
				{"Authorization" => auth_token, "Content-Type" => "application/json"},
				{"email" => email, "password" => password, "api_key" => api_key, "app_id" => app_id}
			)
			
			if result["code"] == 201
				Session.new(JSON.parse(result["body"]))
			else
				raise_error(JSON.parse(result["body"]))
			end
		end
	end
end