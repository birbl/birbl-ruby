require 'spec_helper'

class TestResource < Birbl::Resource
    def initialize(attributes = {}, parent = nil)
      @children = []
      super attributes, parent
    end

  def self.attribute_names
    super + [:foo]
  end

  define_attributes
end

class Birbl::Child < Birbl::Resource
  def self.attribute_names
    super + [:foo, :testresource_id]
  end

  def path
    "test_resources/#{ testresource_id }/children/#{ id }"
  end

  def post_path
    "test_resources/#{ testresource_id }/children"
  end

  define_attributes
end

describe Birbl::Resource do
  let(:unsaved_attributes) { HashWithIndifferentAccess.new(:foo => 'bar') }
  let(:saved_attributes) { unsaved_attributes.merge(:id => 123) }
  let(:client) do
    stub(
      'Birbl::Client',
      :post => saved_attributes,
      :delete => true,
    )
  end
  let(:unsaved_resource) { TestResource.new(unsaved_attributes) }
  let(:saved_resource) { TestResource.new(saved_attributes) }

  before { Birbl::Client.stub(:instance => client) }

  context 'attributes' do
    context '.attribute_names' do
      it 'is a list' do
        expect(TestResource.attribute_names).to be_a(Array)
      end

      it 'has :id by default' do
        expect(TestResource.attribute_names).to include(:id)
      end

      it "adds derived class's attributes" do
        expect(TestResource.attribute_names).to include(:foo)
      end
    end
  end

  context 'urls' do
    context '.collection_path' do
      it 'uses ActiveModel' do
        expect(TestResource.collection_path).to eq('test_resources')
      end
    end
  end

  context 'class CRUD methods' do
    context '.create' do
      it 'succeeds' do
        expect(TestResource.create(unsaved_attributes)).to be_true
      end

      it 'fails for unknown attributes' do
        expect {
          TestResource.new(unsaved_attributes.merge('bad' => 'x'))
        }.to raise_error(NoMethodError, /undefined method.*?bad=/)
      end

      it 'posts via the client' do
        client.should_receive(:post).with('test_resources', unsaved_attributes.symbolize_keys)

        TestResource.create(unsaved_attributes)
      end

      it 'returns the saved resource' do
        resource = TestResource.create(unsaved_attributes)

        expect(resource).to be_a(TestResource)
      end
    end

    context '.find' do
      before { client.stub(:get).with('test_resources/123').and_return(saved_attributes) }

      it 'queries via the client' do
        client.should_receive(:get).with('test_resources/123').and_return(saved_attributes)

        TestResource.find(123)
      end

      it 'returns the resource' do
        expect(TestResource.find(123)).to be_a(TestResource)
      end
    end

    context '.all' do
      before { client.stub(:get).with('test_resources').and_return([saved_attributes]) }

      it 'queries via the client' do
        client.should_receive(:get).with('test_resources').and_return([saved_attributes])

        TestResource.all
      end

      it 'returns all resources' do
        all = TestResource.all

        expect(all).to be_a(Array)
        expect(all.size).to eq(1)
        expect(all[0]).to be_a(TestResource)
      end
    end

    context '.delete' do
      it 'succeeds' do
        expect(TestResource.delete(1)).to be_true
      end

      it 'deletes via the client' do
        client.should_receive(:delete).with('test_resources/1')

        TestResource.delete(1)
      end
    end
  end

  context '.new' do
    it 'fails for unknown attributes' do
      expect {
        TestResource.new(unsaved_attributes.merge('bad' => 'x'))
      }.to raise_error(NoMethodError, /undefined method.*?bad=/)
    end

    it 'sets attributes' do
      resource = TestResource.new(unsaved_attributes)

      expect(resource.foo).to eq('bar')
    end
  end

  context '#children' do
    let(:child_data) { HashWithIndifferentAccess.new(:foo => 'bar') }

    it 'adds a single child' do
      client.should_receive(:post).with('test_resources/123/children', child_data.merge(:testresource_id => 123).symbolize_keys)

      saved_resource.add_child('child', child_data)
    end

    it 'loads children' do
      client.should_receive(:get).with('test_resources/123/children').and_return([child_data])

      saved_resource.children('children')
    end
  end

  context '#path' do
    it 'adds the id' do
      expect(saved_resource.path).to eq('test_resources/123')
    end
  end

  context '#save' do
    context 'new resource' do
      it 'posts via the client' do
        client.should_receive(:post).with('test_resources', unsaved_attributes.symbolize_keys)

        unsaved_resource.save
      end

      it 'saves the new id' do
        unsaved_resource.save

        expect(unsaved_resource.id).to eq(123)
      end
    end

    context 'existing resource' do
      it 'puts via the client' do
        client.should_receive(:put).with('test_resources/123', saved_attributes.symbolize_keys)

        saved_resource.save
      end
    end
  end
end
