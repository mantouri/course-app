# helpers 放置常用的 helper，像是處理分頁、驗證用戶等等
module ApiV0
  module Helpers

    def authenticate!
      current_user or raise AuthorizationError
    end

    def current_user
      @current_user ||= env["api_v0.user"]
    end
  end
end