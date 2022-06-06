# frozen_string_literal: true

RSpec.describe 'Home' do
  scenario 'has navbar element' do #scenario == it
    visit root_url

    expect(page).to have_css 'nav.navbar'
  end

  scenario "user views error page" do
    visit "/404"

    expect(page).to have_text("The page you were looking for doesn't exist")
  end
end
