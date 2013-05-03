###
# This is the Birbl API implementation in Ruby.
#

module Birbl
  require 'active_model'
  require 'active_support/inflector'
  require 'active_support/core_ext/hash/indifferent_access'
  require 'birbl/date_parser'
  require 'birbl/client'
  require 'birbl/resource'
  require 'birbl/partner'
  require 'birbl/partner_review'
  require 'birbl/partner_award'
  require 'birbl/partner_press'
  require 'birbl/activity'
  require 'birbl/occasion'
  require 'birbl/price_point'
  require 'birbl/reservation'
  require 'birbl/participation'
  require 'birbl/user'
  require 'birbl/address'
end
