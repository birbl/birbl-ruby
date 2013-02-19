module Birbl
  class User < Birbl::Resource
  
    def self.attribute_names
      super + [
        :username, 
        :email, 
        :active, 
        :partner_id
        ]
    end

    define_attributes

    validates_presence_of :username
    validates_presence_of :email
    validates_presence_of :active
   
   
    def active?
       @active
    end

  end
end
