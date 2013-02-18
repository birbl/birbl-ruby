require 'spec_helper'

describe Birbl::Activity do
  let(:client) { stub('Birbl::Client') }
  let(:partner) { stub('Birbl::Partner') }
  let(:date_range) { "20140101T153000Z/20140101T173000Z"}
  let(:partner_attributes) do
    {
      'id'                    => 1,
      'name'                  => 'Dummy partner'
    }
  end
  let(:activity_attributes) do
    {
      'partner_id'            => 1,
      'id'                    => 1,
      'name'                  => 'Dummy activity',
      'description'           => 'Activity description',
      'base_price'            => 1000,
      'minimum_price'         => 100,
      'maximum_capacity'      => 10,
      'minimum_participants'  => 1,

      # optional
      'variation_limit'       => 4,
      'cost_per_participant'  => 100,
      'fixed_costs'           => 300
    }
  end
  let(:unsaved_occasion_attributes) do
    {
      'begins'          => '20140101T153000Z',
      'ends'            => '20140101T173000Z',
      'available_from'  => '20140101T153000Z',
      'available_to'    => '20140101T173000Z'
    }
  end
  let(:occasion_attributes) { unsaved_occasion_attributes.merge('id' => 123, 'activity_id' => 1) }

  subject { Birbl::Activity.new(activity_attributes) }

  before do
    Birbl::Client.stub(:instance => client)
    client.stub(:get).with('partners/1').and_return(partner_attributes)
    client.stub(:get).with('partners/1/activities/1').and_return(activity_attributes)

    partner.stub(:id)
    partner.stub(:path).and_return('partners/1')
    subject.partner = partner
  end

  context '#occasions' do
    before do
      client.stub(:get).with('partners/1/activities/1/occasions').
        and_return([occasion_attributes])
    end

    it 'queries the client' do
      client.should_receive(:get).with('partners/1/activities/1/occasions').
        and_return([occasion_attributes])

      subject.occasions
    end

    it 'returns occasions' do
      occasions = subject.occasions

      expect(occasions).to be_a(Array)
      expect(occasions.size).to eq(1)
      expect(occasions[0]).to be_a(Birbl::Occasion)
    end
  end

  context '#occasion' do
    before do
      client.stub(:get).with('partners/1/activities/1/occasions/10').
        and_return(occasion_attributes)
    end

    it 'queries the client' do
      client.should_receive(:get).with('partners/1/activities/1/occasions/10').
        and_return(occasion_attributes)

      subject.occasion(10)
    end

    it 'loads a single occasion' do
      expect(subject.occasion(10)).to be_a_kind_of(Birbl::Occasion)
    end

    it 'adds a single occasion' do
      client.should_receive(:post).with('partners/1/activities/1/occasions', [date_range]).
        and_return([occasion_attributes])

      subject.add_occasions(date_range)
    end
  end

end
