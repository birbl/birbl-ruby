require 'spec_helper'

describe Birbl::Partner do
  context 'validations' do
    it 'validates name' do
      partner = Birbl::Partner.new({})

      partner.valid?

      expect(partner.errors[:name]).to include("can't be blank")
    end
  end
end

