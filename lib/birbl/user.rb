module Birbl
  class User < Birbl::Resource
  
    def self.attribute_names
      super + [:username, :email, :active, :partner_id]
    end

    define_attributes

    validates_presence_of :username
    validates_presence_of :email
    validates_presence_of :active

    def has_admin_rights?
      if @partner_id 
        return true 
      else 
        return false 
      end
    end

    def active?
       @active
    end

  end
end
