# frozen_string_literal: true

class IndexController < ApplicationController
  def home
    @users = UserPresenter.new(0)
  end
end
