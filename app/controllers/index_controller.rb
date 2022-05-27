class IndexController < ApplicationController
  def home
    @users = UserPresenter.new(0)
  end
end