require 'spec_helper'

describe Birbl::Partner do
  let(:client) { stub('Birbl::Client') }
  let(:partner_attributes) do
    {
      'id'      => 1,
      'name'    => 'Dummy partner',
      'email'   => 'partner@example.com',
      'website' => 'www.example.com'
    }
  end
  let(:activity_attributes) do
    {
      'id'   => 10,
      'name' => 'Activity',
    }
  end
  let(:unsaved_activity_attributes) do
    {
      'name' => 'Activity',
    }
  end

  subject { Birbl::Partner.new(partner_attributes) }

  before do
    Birbl::Client.stub(:instance => client)
    client.stub(:get).with('partners/1').and_return(partner_attributes)
  end

  context '#activities' do
    before do
      client.stub(:get).with('partners/1/activities').
        and_return([activity_attributes])
    end

    it 'queries the client' do
      client.should_receive(:get).with('partners/1/activities').
        and_return([activity_attributes])

      subject.activities
    end

    it 'returns activities' do
      activities = subject.activities

      expect(activities).to be_a(Array)
      expect(activities.size).to eq(1)
      expect(activities[0]).to be_a(Birbl::Activity)
    end
  end

  context '#activity' do
    before do
      client.stub(:get).with('partners/1/activities/10').
        and_return(activity_attributes)
    end

    it 'queries the client' do
      client.should_receive(:get).with('partners/1/activities/10').
        and_return(activity_attributes)

      subject.activity(10)
    end

    it 'loads a single activity' do
      expect(subject.activity(10)).to be_a_kind_of(Birbl::Activity)
    end

    it 'adds a single activity' do
      client.should_receive(:post).with('partners/1/activities', unsaved_activity_attributes.merge(:partner_id => 1).symbolize_keys).
        and_return(activity_attributes)

        subject.add_activity(unsaved_activity_attributes)
    end
  end
end
