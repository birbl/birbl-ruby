require 'birbl'

describe Birbl::Activity do

  before do
    dummy_data = {'name' => 'Dummy partner', 'email' => 'partner@example.com', 'website' => 'www.example.com'}

    Birbl::Action.new('the_key')
    Birbl::Action.instance.stub(:get).with('partners/1').and_return(dummy_data)
    Birbl::Action.instance.stub(:post).with('partners/1', dummy_data).and_return(true)
    Birbl::Action.instance.stub(:put).with('partners/1', dummy_data).and_return(true)
    Birbl::Action.instance.stub(:delete).with('partners/1').and_return(true)
  end

  context 'initialization' do
    it 'creates an empty array for activities' do
      expect(subject.instance_variable_get(:@activities)).to eq([])
    end
  end

  context 'usage' do
    context 'without an id' do
      subject { Birbl::Partner.new }

      it 'deletes an instance' do
        expect { subject.delete(1) }.not_to raise_error
      end

      it 'loads an instance' do
        subject.load(1)
        expect(subject.property('name')).to eq('Dummy partner')
      end
    end

    context 'with an id' do
      subject { Birbl::Partner.new(1) }

      it 'gets a property' do
        expect(subject.property('email')).to eq('partner@example.com')
      end

      it 'changes a property' do
        expect(subject.property('website', 'www.example2.com')).to eq('www.example2.com')
      end

      it 'creates a good instance data on the API' do
        expect { subject.create }.not_to raise_error
      end

      # how to stub out the subject.has_valid_data? function to force it to return false before
      # running this test?
      it 'raises error when creating bad instance data on the API' do
        expect { subject.create }.to raise_error
      end

      it 'updates good instance data to the API' do
        expect { subject.update }.not_to raise_error
      end

      # how to stub out the subject.has_valid_data? function to force it to return false before
      # running this test?
      it 'raises error when updating bad instance data to the API' do
        expect { subject.update }.to raise_error
      end

      it 'deletes an instance from the API' do
        expect { subject.delete }.not_to raise_error
      end
    end
  end
end
