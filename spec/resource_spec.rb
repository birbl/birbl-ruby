require 'birbl'

dummy_data = {'dummy' => 'some data'}

describe Birbl::Resource do

  before do
    Birbl::Client.new('the_key')
    Birbl::Client.instance.stub(:get).with('resource/1').and_return(dummy_data)
    Birbl::Client.instance.stub(:post).with('resource', dummy_data).and_return(true)
    Birbl::Client.instance.stub(:put).with('resource/1', dummy_data).and_return(true)
    Birbl::Client.instance.stub(:delete).with('resource/1').and_return(true)
  end

  context 'usage' do
    context 'without an id' do

      it 'deletes an instance' do
        expect { Birbl::Resource.delete(1) }.not_to raise_error
      end

      it 'creates an instance' do
        expect { Birbl::Resource.create(dummy_data) }.not_to raise_error
      end

      it 'finds an instance' do
        expect { Birbl::Resource.find(1) }.not_to raise_error
      end
    end

    context 'with an id' do
      subject { Birbl::Resource.find(1) }

      it 'gets a property' do
        expect(subject.attributes['dummy']).to eq(dummy_data['dummy'])
      end

      it 'drops extra fields before sending data to the API' do
        subject.attributes['foo'] = 'bar'
        expect(Birbl::Resource.post_data(subject.attributes)['foo']).to eq(nil)
      end
    end
  end
end
