require 'birbl'

describe Birbl::Resource do

  before do
    dummy_data = {'placeholder' => 'some data'}

    Birbl::Action.new('the_key')
    Birbl::Action.instance.stub(:get).with('resource/1').and_return(dummy_data)
    Birbl::Action.instance.stub(:post).with('resource/1', dummy_data).and_return(true)
    Birbl::Action.instance.stub(:put).with('resource/1', dummy_data).and_return(true)
    Birbl::Action.instance.stub(:delete).with('resource/1').and_return(true)

    Birbl::Action.instance.stub(:get).with('resource/2').and_return({'placeholder' => 'instance 2'})
  end

  context 'initialization' do
    context 'without an id' do
      subject { Birbl::Resource.new }

      it 'creates an empty instance' do
        subject # create it
        expect(subject.instance_variable_get(:@data)).to be_empty
      end
    end

    context 'with data and no id' do
      init_data = {'placeholder' => 'init data'}
      subject { Birbl::Resource.new(nil, init_data) }

      it 'loads an instance' do
        expect(subject.instance_variable_get(:@data)).to eq(init_data)
      end
    end

    context 'with data and an id' do
      init_data = {'newfield' => 'arbitrary data'}
      subject { Birbl::Resource.new(1, init_data) }

      it 'loads an instance' do
        expect(subject.property('newfield')).to eq('arbitrary data')
        expect(subject.property('placeholder')).to eq('some data')
      end
    end

    context 'with data containing an id' do
      init_data = {'id' => 2, 'extra' => 'arbitrary extra'}
      subject { Birbl::Resource.new(nil, init_data) }

      it 'loads an instance' do
        expect(subject.property('extra')).to eq('arbitrary extra')
        expect(subject.property('placeholder')).to eq('instance 2')
      end
    end

    context 'with only an id' do
      subject { Birbl::Resource.new(1) }

      it 'loads an instance' do
        expect(subject.instance_variable_get(:@data)).to eq({'placeholder' => 'some data'})
      end
    end
  end

  context 'usage' do
    context 'without an id' do
      subject { Birbl::Resource.new }

      it 'deletes an instance' do
        expect { subject.delete(1) }.not_to raise_error
      end

      it 'loads an instance' do
        subject.load(1)
        expect(subject.property('placeholder')).to eq('some data')
      end
    end

    context 'with an id' do
      subject { Birbl::Resource.new(1) }

      it 'gets a property' do
        expect(subject.property('placeholder')).to eq('some data')
      end

      it 'changes a property' do
        expect(subject.property('placeholder', 'new data')).to eq('new data')
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

      it 'drops extra fields before sending data to the API' do
        subject.property('foo', 'bar')
        expect { subject.update }.not_to raise_error
      end
    end
  end
end
