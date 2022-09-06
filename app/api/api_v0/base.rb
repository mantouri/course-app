# api/api_v0/base.rb 放置 api_v0 的通用設定
module ApiV0
  class Base < Grape::API



    use ApiV0::Auth::Middleware
    include ApiV0::ExceptionHandlers
    helpers ::ApiV0::Helpers

    version 'v0', using: :path # api/v0/


    mount Ping # api/v0/ping
    mount Posts
    # 一般來說我們不會希望 private API 接口被任意調用，尤其是內部溝通的 API，又或是要區別哪一個使用者所進行的身份驗證。
    # 多半會使用自定義的 header 比方說 X-Api-Secret-Key 在請求時請發起方帶上正確的 token
    # before do
    #   unless request.headers["X-Api-Secret-Key"] == "secret"
    #     error! "forbidden", 403
    #   end
    # end

    # 這個要擺在最下面，才會吃掉所有的 mount @@
    add_swagger_documentation(
      mount_path: 'swagger_doc',
      hide_format: true,
      hide_documentation_path: true
    )
  end
end