require "test_helper"

class ApplicationTest < ActiveSupport::TestCase
  test "should not save application without name" do
    application = Application.new
    assert_not application.save, "Saved the application without a name"
  end

  test "should save article with name" do
    application = Application.new
    application.name = 'test1'
    assert application.save, "Saved the application with a name"
  end
end
