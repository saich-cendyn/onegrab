require "application_system_test_case"

class CoursesTest < ApplicationSystemTestCase
  setup do
    @course = courses(:one)
  end

  test "visiting the index" do
    visit courses_url
    assert_selector "h1", text: "Courses"
  end

  test "should create course" do
    visit courses_url
    click_on "New course"

    fill_in "Category", with: @course.category_id
    fill_in "Description", with: @course.description
    fill_in "Duration minutes", with: @course.duration_minutes
    fill_in "Level", with: @course.level
    fill_in "Price", with: @course.price
    check "Published" if @course.published
    fill_in "Published at", with: @course.published_at
    fill_in "Short description", with: @course.short_description
    fill_in "Thumbnail url", with: @course.thumbnail_url
    fill_in "Title", with: @course.title
    click_on "Create Course"

    assert_text "Course was successfully created"
    click_on "Back"
  end

  test "should update Course" do
    visit course_url(@course)
    click_on "Edit this course", match: :first

    fill_in "Category", with: @course.category_id
    fill_in "Description", with: @course.description
    fill_in "Duration minutes", with: @course.duration_minutes
    fill_in "Level", with: @course.level
    fill_in "Price", with: @course.price
    check "Published" if @course.published
    fill_in "Published at", with: @course.published_at.to_s
    fill_in "Short description", with: @course.short_description
    fill_in "Thumbnail url", with: @course.thumbnail_url
    fill_in "Title", with: @course.title
    click_on "Update Course"

    assert_text "Course was successfully updated"
    click_on "Back"
  end

  test "should destroy Course" do
    visit course_url(@course)
    accept_confirm { click_on "Destroy this course", match: :first }

    assert_text "Course was successfully destroyed"
  end
end
