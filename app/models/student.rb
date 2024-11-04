class Student < ApplicationRecord
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    devise :database_authenticatable, :registerable,
            :recoverable, :rememberable, :validatable

    #using active storage to have one profile picture assoicated
    has_one_attached :profile_picture, dependent: :purge_later 

    #has one relationship and destroy portfolio if student deleted
    #https://guides.rubyonrails.org/v7.1/association_basics.html
    has_one :portfolio, dependent: :destroy

    #after student created create and link portfolio
    after_create :create_portfolio
    #allow editing of portfolio information in form
    accepts_nested_attributes_for :portfolio
    
    #Allowed Majors - this is hardcoded for learning 
    # If you wanted an admin for example to update this informatin
    #and not a developer This could be in a scaffolded table
    VALID_MAJORS = ["Computer Engineering BS", "Computer Information Systems BS", "Computer Science BS", "Cybersecurity Major", "Data Science and Machine Learning Major"]

    #validations
    validates :major, inclusion: { in: VALID_MAJORS, message: "%{value} is not a valid major" }
    validates :first_name, :last_name, :major, presence: true
    validate :acceptable_image
    validate :email_format


    private

    #create portfolio when student created
    #https://guides.rubyonrails.org/v7.1/association_basics.html
    def create_portfolio
        #link portfolio to id of student
        Portfolio.create!(student: self, active: false)
    end

    #validate that email is an msudenver email format
    def email_format
        unless email =~ /\A[\w+\-.]+@msudenver\.edu\z/i
            errors.add(:email, "must be an @msudenver.edu email address")
        end
    end


    def acceptable_image
        return unless profile_picture.attached?

        unless profile_picture.blob.byte_size <= 1.megabyte
            errors.add(:profile_picture, "is too big")
        end

        acceptable_types = ["image/jpeg", "image/png"]
        unless acceptable_types.include?(profile_picture.content_type)
            errors.add(:profile_picture, "must be a JPEG or PNG")
        end

    end

end
