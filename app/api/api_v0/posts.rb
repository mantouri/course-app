module ApiV0
  class Posts < Grape::API
    before { authenticate! }

    desc "Get all your posts"
    get "/posts" do
      posts = current_user.posts
      present posts, with: ApiV0::Entities::Post
    end

    desc "Get your post"
    params do
      requires :id, type: String, desc: 'Post ID.'
    end
    get "/posts/:id" do
      post = current_user.posts.find_by(id: params[:id])

      present post, with: ApiV0::Entities::Post
    end

    desc "Create new post"
    params do
      requires :title, type: String
      requires :context, type: String
    end
    post "/posts" do
      # 這邊會用 declared 去濾 params 是因為這時候的設計 access_key 是放在 params 裡面，如果跟著帶進# 來會噴 error，因為 Post 這個 model 裡面並沒有 access_key 這個欄位會造成錯誤。
      post = current_user.posts.new(declared(params, include_missing: false).except(:access_key))

      if post.save
        present post, with: ApiV0::Entities::Post
      else
        raise StandardError, $!
      end
    end

    # 因為 grape 不見得能直接使用 rails strong param，通常帶進來的參數不會像是 form 送出去的會包很多層 hash
    # rails request => { posts: { title: "Hi", context: "Man" } }
    # rails controller can use => params.required(:posts).permit(:title, :context)
    # 但通常 API 送進來的都是單層的
    # api request => { title: "Hi", context: "Man" }
    # 這裡才會用 grape 提供的 declared 去做處理 declared(params, include_missing:....)
  end
end