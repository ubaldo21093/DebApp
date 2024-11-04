class StudentsController < ApplicationController
  # Student must be authenticated for edit, update, and destroy actions
  before_action :authenticate_student!, only: %i[ edit update destroy ]

    # Set the @student instance for actions like show, edit, update, destroy
  before_action :set_student, only: %i[show edit update destroy ]
  
  # Logged-in student can only modify their own profile
  before_action :correct_student, only: %i[ edit update destroy ]
  
  #before_action :find_student, only: [:show]

 # GET /students or /students.json
 def index

  # due to error Search Params: #<ActionController::Parameters {"major"=>""} permitted: false>
  #must permitt strong parameters for search so defined search_params
  @search_params = search_params_permitted 

  Rails.logger.info "Controller Search Params: #{@search_params.inspect}"

  #initialize to all students
  #@students = Student.all

 
  #discovered the above will always have the nested search params present
  # if search button clicked commit is "Search"
  #{"search"=>{"major"=>""}, "date_type"=>"", "expected_graduation_date"=>"", "commit"=>"Search"}

  #if show all button clicked commit is "Show All"
  #Parameters: {"search"=>{"major"=>""}, "date_type"=>"", "expected_graduation_date"=>"", "commit"=>"Show All"}
  if (params[:commit] == "Show All")
    Rails.logger.info  "show all"
    @students = Student.all
  #else check searc empty parameters {"search"=>{"major"=>""}, "date_type"=>"", "expected_graduation_date"=>"", "commit"=>"Search"}
  # https://dev.to/kateh/understanding-blank-present-empty-any-and-nil-in-ruby-and-rails-34b4
  elsif @search_params.values.all?(&:blank?)
    # All values are empty or nil
    Rails.logger.info  "All search parameters are empty"
    @students = Student.none
  else
    # At least one value is present so handle search in student model method
    Rails.logger.info  "There are search parameters provided"
    @students = filter_students(@search_params)
  end

   Rails.logger.info "Filtered Students: #{@students.inspect}"

 end


  # GET /students/1 or /students/1.json
  def show
    @student = Student.find(params[:id])
  end


  # GET /students/new
  def new
    @student = Student.new
  end

  # GET /students/1/edit
  def edit
    
  end

  # POST /students or /students.json
  def create
    @student = Student.new(student_params)

    respond_to do |format|
      if @student.save
        format.html { redirect_to student_url(@student), notice: "Student was successfully created." }
        format.json { render :show, status: :created, location: @student }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /students/1 or /students/1.json
  def update
    respond_to do |format|
      if @student.update(student_params)
        format.html { redirect_to student_url(@student), notice: "Student was successfully updated." }
        format.json { render :show, status: :ok, location: @student }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /students/1 or /students/1.json
  def destroy
    @student.destroy!

    respond_to do |format|
      format.html { redirect_to students_url, notice: "Student was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_student
    @student = Student.find(params[:id])
    Rails.logger.info "Students: #{@students.inspect}"
  end

    # Only allow the logged-in student to edit, update, or destroy their own profile
  def correct_student
    unless current_student == @student
      redirect_to root_path, alert: "You are not authorized to modify this profile."
    end
  end

  # Only allow a list of trusted parameters through.
  def student_params
    params.require(:student).permit(:first_name, :last_name, :major, :expected_graduation_date, 
      :profile_picture,
    portfolio_attributes: [:preferred_email, :active, :summary, :skills])
  end

  def search_params_permitted
    #params.require(:search).permit(:major, :expected_graduation_date, :date_type)
    params.fetch(:search, {}).permit(:major, :expected_graduation_date, :date_type)
  end

  def filter_students(search_params)
    Rails.logger.info "Controller Search Params in filter_students: #{search_params.inspect}"
    students = Student.all

    if search_params[:major].present?
      students = students.where(major: search_params[:major])
      Rails.logger.info "Filtered by major: #{search_params[:major]}"
    end

    if search_params[:date_type].present? && search_params[:expected_graduation_date].present?
      #date = Date.parse(search_params[:expected_graduation_date])
      date = search_params[:expected_graduation_date]
      Rails.logger.info "Parsed date: #{date}"

      if search_params[:date_type] == "before"
        students = students.where("expected_graduation_date < ?", date)
        Rails.logger.info "Filtered by date before: #{date}"
      elsif search_params[:date_type] == "after"
        students = students.where("expected_graduation_date > ?", date)
        Rails.logger.info "Filtered by date after: #{date}"
      end
    end

    students
  end



end
