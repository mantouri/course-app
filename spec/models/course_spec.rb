# frozen_string_literal: true

RSpec.describe Course do
  # init will create subject == described_class.new
  it { should validate_presence_of(:title) } # is_expected.to == should == expect(subject).to
  it { is_expected.to belong_to(:user) }
end
