require 'rails_helper'

RSpec.describe "portfolios/new", type: :view do
  before(:each) do
    assign(:portfolio, Portfolio.new(
      preferred_email: "MyString",
      active: false,
      summary: "MyText",
      skills: "MyText",
      student: nil
    ))
  end

  it "renders new portfolio form" do
    render

    assert_select "form[action=?][method=?]", portfolios_path, "post" do

      assert_select "input[name=?]", "portfolio[preferred_email]"

      assert_select "input[name=?]", "portfolio[active]"

      assert_select "textarea[name=?]", "portfolio[summary]"

      assert_select "textarea[name=?]", "portfolio[skills]"

      assert_select "input[name=?]", "portfolio[student_id]"
    end
  end
end
