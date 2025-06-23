class EnquirySerializer
  include JSONAPI::Serializer
  attributes :id, :name, :email, :phone, :subject, :message
end
