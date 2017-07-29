class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :premium, :premium_until
end
