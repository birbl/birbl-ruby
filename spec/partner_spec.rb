require 'birbl'

dummy_data = {
  'id'      => 1,
  'name'    => 'Dummy partner',
  'email'   => 'partner@example.com',
  'website' => 'www.example.com'
}
post_data = dummy_data.clone
post_data.delete('id')

describe Birbl::Partner do

  before do
    Birbl::Action.new('the_key')
    Birbl::Action.instance.stub(:get).with('partners/1').and_return(dummy_data)
    Birbl::Action.instance.stub(:post).with('partners', post_data).and_return(true)
    Birbl::Action.instance.stub(:put).with('partners/1', post_data).and_return(true)
    Birbl::Action.instance.stub(:delete).with('partners/1').and_return(true)

    activity_data = [{'id' => 10, 'name' => 'Dummy activity'}]
    Birbl::Action.instance.stub(:get).with('partners/1/activities').and_return(activity_data)
    Birbl::Action.instance.stub(:get).with('partners/1/activities/10').and_return(activity_data[0])
    Birbl::Action.instance.stub(:post).with('partners/1/activities', activity_data).and_return(true)
  end

  context 'initialization' do
    it 'creates an empty array for activities' do
      expect(subject.instance_variable_get(:@activities)).to eq([])
    end
  end

  context 'usage' do
    context 'without an instance' do
      it 'deletes a partner' do
        expect { Birbl::Partner.delete(1) }.not_to raise_error
      end

      it 'finds a partner' do
        expect(Birbl::Partner.find(1)).to be_a_kind_of(Birbl::Partner)
      end

      it 'creates a partner' do
        expect(Birbl::Partner.create(post_data)).to be_a_kind_of(Birbl::Partner)
      end
    end

    context 'with an instance' do
      subject { Birbl::Partner.find(1) }

      it 'updates an instance' do
        expect { subject.update }.not_to raise_error
      end

      it 'gets a property' do
        expect(subject.attributes['email']).to eq(dummy_data['email'])
      end

      it 'changes a property' do
        expect { subject.attributes['website'] = 'www.example2.com' }.not_to raise_error
      end

    end
  end

  context 'activities' do
    subject { Birbl::Partner.find(1) }

    it 'loads all existing activities' do
      expect(subject.activities).to be_a_kind_of(Array)
    end

    it 'loads a single activity' do
      expect(subject.activity(10)).to be_a_kind_of(Birbl::Activity)
    end
  end
end
