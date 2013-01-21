require 'birbl'

activity_url = 'partners/1/activities'
dummy_data = {
  'partner_id'            => 1,
  'id'                    => 10,
  'name'                  => 'Dummy activity',
  'description'           => 'Activity desription',
  'base_price'            => 1000,
  'minimum_price'         => 100,
  'maximum_capacity'      => 10,
  'minimum_participants'  => 1,

  # optional
  'variation_limit'       => 4,
  'cost_per_participant'  => 100,
  'fixed_costs'           => 300
}

post_data = dummy_data.clone
post_data.delete('partner_id')
post_data.delete('id')


describe Birbl::Activity do
  let(:partner) { stub('Partner', attributes: {'id' => 1}) }

  before do
    Birbl::Action.new('the_key')
    Birbl::Action.instance.stub(:get).with("#{ activity_url }/10").and_return(dummy_data)
    Birbl::Action.instance.stub(:post).with(activity_url, post_data).and_return(true)
    Birbl::Action.instance.stub(:put).with("#{ activity_url }/10", post_data).and_return(true)
    Birbl::Action.instance.stub(:delete).with("#{ activity_url }/10").and_return(true)
  end

  context 'initialization' do
    subject { Birbl::Activity.new({}, partner) }

    it 'creates an empty array for occurances' do
      expect(subject.instance_variable_get(:@occasions)).to eq([])
    end
  end

  context 'usage' do
    context 'without an instance' do
      it 'deletes an activity' do
        expect { Birbl::Activity.delete(10, partner) }.not_to raise_error
      end

      it 'finds an activity' do
        expect(Birbl::Activity.find(10, partner)).to be_a_kind_of(Birbl::Activity)
      end

      it 'creates an activity' do
        expect(Birbl::Activity.create(post_data, partner)).to be_a_kind_of(Birbl::Activity)
      end
    end

    context 'with an instance' do
      subject { Birbl::Activity.find(10, partner) }

      it 'updates an instance' do
        expect { subject.update }.not_to raise_error
      end

      it 'gets a property' do
        expect(subject.attributes['name']).to eq(dummy_data['name'])
      end

      it 'changes a property' do
        expect { subject.attributes['description'] = 'A new description' }.not_to raise_error
      end

    end
  end
end
