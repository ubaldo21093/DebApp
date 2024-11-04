require 'rails_helper'

RSpec.describe "portfolios/edit", type: :view do
  let(:portfolio) {
    Portfolio.create!(
      preferred_email: "MyString",
      active: false,
      summary: "MyText",
      skills: "MyText",
      student: nil
    )
  }

  before(:each) do
    assign(:portfolio, portfolio)
  end

  it "renders the edit portfolio form" do
    render

    assert_select "form[action=?][method=?]", portfolio_path(portfolio), "post" do

      assert_select "input[name=?]", "portfolio[preferred_email]"

      assert_select "input[name=?]", "portfolio[active]"

      assert_select "textarea[name=?]", "portfolio[summary]"

      assert_select "textarea[name=?]", "portfolio[skills]"

      assert_select "input[name=?]", "portfolio[student_id]"
    end
  end
end
