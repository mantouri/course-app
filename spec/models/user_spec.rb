# frozen_string_literal: true

RSpec.describe User do
  it { is_expected.to have_many(:courses) }
end
