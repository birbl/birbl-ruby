require 'spec_helper'

describe Birbl::Partner do
  let(:partner_data) { {'name' => 'A Hotel'} }
  let(:partner_response) { {'data' => partner_data} }
  let(:action) do
    stub(
      'Birbl::Client',
      :get => partner_response,
      :post => partner_response,
    )
  end

  before do
    Birbl::Client.stub(:instance => action)
  end

  context '.create' do
    it 'sends data' do
      action.should_receive(:post).
        with('/partners', partner_data).
        and_return(partner_response)

      Birbl::Partner.create(partner_data)
    end

    it 'returns a Partner' do
      partner = Birbl::Partner.create(partner_data)

      expect(partner).to be_a(Birbl::Partner)
    end
  end

  context '.find' do
    it 'queries' do
      action.should_receive(:get).
        with('/partners/1').
        and_return(partner_response)

      Birbl::Partner.find(1)
    end

    it 'returns a Partner' do
      partner = Birbl::Partner.find(1)

      expect(partner).to be_a(Birbl::Partner)
    end
  end

  context 'validations' do
    it 'validates name' do
      partner = Birbl::Partner.new({})

      partner.valid?

      expect(partner.errors[:name]).to include("can't be blank")
    end
  end

  context '#save' do
    it 'sends data' do
    end

    it 'confirms the save'
  end

  context '#delete' do
    it 'sends a delete request'
  end
end
