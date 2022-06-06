# frozen_string_literal: true

# 不需要 require 'rails_helper' 是因為在 .rspec 檔案中已加入了
# describe 的部份有：type: :controller，這個叫做 RSpec metadata。
# RSpec 看到這個就知道這是 Controller Spec。而只要測試的位置放對了 spec/controllers/<controller names>_spec.rb，在 spec/rails_helper.rb 有一行配置：
# config.infer_spec_type_from_file_location!
# 會自動幫我們的測試加上正確的 metadata（type: :controller）。所以可以把這個拿掉

RSpec.describe CoursesController do
  describe 'GET index' do # 通常建議在 Controller 寫的 Test 命名法是以 HTTP verb + action_name 的方式命名
    it 'assigns @courses' do # 測試的黃金原則：One assertion per test，也就是一個測試一次只測一件事。
      course1 = create(:course)
      course2 = create(:course)
      get :index
      expect(assigns[:courses]).to eq([course1, course2]) # assigns 到 @courses 這個變數
    end

    it 'render template' do # 什麼時候建議要拆開 Test？通常是在你發現自己 test 的敘述裡面有了 and 這個字，這時候就有必要拆開 test 了。
      course1 = create(:course)
      course2 = create(:course)
      get :index
      expect(response).to render_template('index') # expect(x) == 值用小括號
    end
  end

  describe 'GET show' do
    it 'assigns @course' do
      course = create(:course)

      get :show, params: { id: course.id }

      expect(assigns[:course]).to eq(course)
    end

    it 'render template' do
      course = create(:course)

      get :show, params: { id: course.id }

      expect(response).to render_template('show')
    end
  end

  describe 'GET new' do
    context 'when user login' do
      let(:user) { create(:user) } # same as @_user ||= create(:user)
      let(:course) { build(:course) }
      before do
        sign_in user
        get :new
      end
      it 'assign @course' do
        expect(assigns(:course)).to be_a_new(Course)
      end

      it 'render template' do
        expect(response).to render_template('new')
      end
    end

    context 'when user not login' do
      it 'redirect_to new_user_session_path' do
        get :new
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'POST create' do
    let(:user) { create(:user) }
    before { sign_in user }

    context "when course doesn't have title" do
      it "doesn't create a record" do
        expect do
          post :create, params: { course: { description: 'bar' } }
        end.to change { Course.count }.by(0)
      end

      it 'render new template' do
        post :create, params: { course: { description: 'bar' } }

        expect(response).to render_template('new')
      end
    end

    context 'when course has title' do
      it 'create a new course record' do
        course = build(:course)

        expect do
          post :create, params: { course: attributes_for(:course) }
        end.to change { Course.count }.by(1)
      end

      it 'redirects to courses_path' do
        course = build(:course)

        post :create, params: { course: attributes_for(:course) }

        expect(response).to redirect_to courses_path
      end

      it 'creates a course for user' do
        course = build(:course)

        post :create, params: { course: attributes_for(:course) }

        expect(Course.last.user).to eq(user)
      end
    end
  end

  describe 'GET edit' do
    let(:author) { create(:user) }
    let(:not_author) { create(:user) }

    context 'signed in as author' do
      before { sign_in author }

      it 'assign course' do
        course = create(:course, user: author)
        get :edit, params: { id: course.id }
        expect(assigns[:course]).to eq(course)
      end

      it 'render template' do
        course = create(:course, user: author)
        get :edit, params: { id: course.id }
        expect(response).to render_template('edit')
      end
    end

    context 'signed in not as author' do
      before { sign_in not_author }
      it 'raises an error' do
        course = create(:course, user: author)
        expect do
          get :edit, params: { id: course.id }
        end.to raise_error ActiveRecord::RecordNotFound # expect 方法用 { xxx }
      end
    end
  end

  describe 'PUT update' do
    let(:author) { create(:user) }
    let(:not_author) { create(:user) }
    context "sign in as author" do
      before { sign_in author }
      context "when course has title" do
        it "assigns @course" do
          course = create(:course, user: author)
          put :update, params: { id: course.id, course: { title: "Title", description: "Description" } }
          expect(assigns[:course]).to eq(course)
        end

        it 'changes value' do
          course = create(:course, user: author)
          put :update, params: { id: course.id, course: { title: "Title", description: "Description" } }
          expect(assigns[:course].title).to eq("Title")
          expect(assigns[:course].description).to eq("Description")
        end

        it 'redirects to course_path' do
          course = create(:course, user: author)
          put :update, params: { id: course.id, course: { title: "Title", description: "Description" } }
          expect(response).to redirect_to course_path(course)
        end
      end

      context "when course doesn't have title " do
        it "doesn't update a record " do
          course = create(:course, user: author)
          put :update, params: { id: course.id, course: { title: "", description: "Description" } }
          expect(course.description).not_to eq("Description")
        end
  
        it 'renders edit template' do
          course = create(:course, user: author)
          put :update, params: { id: course.id, course: { title: "", description: "Description" } }
          expect(response).to render_template("edit")
        end
      end
    end

    context "sign in not as author" do
      before { sign_in not_author }
      it "raises an error" do

        course = create(:course, user: author)
        expect do
          put :update, params: { id: course.id, course: { title: "", description: "Description" } }
        end.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe 'DELETE destroy' do
    let(:author) { create(:user) }
    let(:not_author) { create(:user) }

    context "when sign in as author" do
      before { sign_in author }

      it 'assigns @course' do
        course = create(:course, user: author)
        delete :destroy, params: { id: course.id }
        expect(assigns[:course]).to eq(course)
      end
  
      it 'deletes a record' do
        course = create(:course, user: author)
        expect { delete :destroy, params: { id: course.id } }.to change { Course.count }.by(-1)
      end
  
      it 'redirects to courses_path' do
        course = create(:course, user: author)
        delete :destroy, params: { id: course.id }
        expect(response).to redirect_to courses_path
      end
    end

    context "when sign in not as author" do
      before { sign_in not_author }
      it "raises an error" do
        course = create(:course, user: author)
        expect do
          delete :destroy, params: { id: course.id }
        end.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
