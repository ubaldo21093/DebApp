require 'rails_helper'

RSpec.describe "portfolios/show", type: :view do
  before(:each) do
    assign(:portfolio, Portfolio.create!(
      preferred_email: "Preferred Email",
      active: false,
      summary: "MyText",
      skills: "MyText",
      student: nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Preferred Email/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(//)
  end
end
