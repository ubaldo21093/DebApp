require 'rails_helper'

RSpec.describe "portfolios/index", type: :view do
  before(:each) do
    assign(:portfolios, [
      Portfolio.create!(
        preferred_email: "Preferred Email",
        active: false,
        summary: "MyText",
        skills: "MyText",
        student: nil
      ),
      Portfolio.create!(
        preferred_email: "Preferred Email",
        active: false,
        summary: "MyText",
        skills: "MyText",
        student: nil
      )
    ])
  end

  it "renders a list of portfolios" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Preferred Email".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
  end
end
