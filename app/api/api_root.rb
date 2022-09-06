# 為所有的 API endpoint 掛載入口點，可設置全局通用屬性
class ApiRoot < Grape::API
  PREFIX = '/api'.freeze

  format :json # 一般來說我們傳遞資料的格式都會用 json，如果沒有設定就會用 xml，所以這邊要設定 format 為 json



  mount ApiV0::Base
end