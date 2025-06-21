class StudentSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :email, :phone, :address, :gender, :dob, :enrollment_date, :status, :parent_guardian_name, :emergency_contact, :progress_status

  attribute :image_url do |student|
    student.image_url
  end
end
