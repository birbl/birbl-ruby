require 'birbl'

describe Birbl do

  class DummyClass
  end

  before(:each) do
    @dummy = DummyClass.new
    @dummy.extend Birbl
  end

  describe Action do
    it "uses a sandbox" do
      Birbl::Action.use_sandbox = true
      Birbl::Action.url.should == 'https://dev-api.birbl.com'
    end

    it "uses the live api" do
      Birbl::Action.use_sandbox = false
      Birbl::Action.url.should == 'https://api.birbl.com'
    end

    it "sets dev url" do
      url = 'http://localhost:8080'
      Birbl::Action.dev_url = url
      Birbl::Action.dev_url.should == url
    end

    it "sets live url" do
      url = 'http://localhost:8080'
      Birbl::Action.base_url = url
      Birbl::Action.base_url.should == url
    end

    it "uses an api key" do
      key = '1234567890'

      Birbl::Action.key = key
      Birbl::Action.key.should == key
    end

    it "GET some data from the API" do
      Birbl::Action.get('partners').each { |partner|
        partner.should be_an_instance_of(Hash)
      }
    end

    it "POST some data to the API" do
      Birbl::Action.post('partners', [{:name => 'Test partner'}]).each { |partner|
        partner.should be_an_instance_of(Hash)
      }
    end

    it "PUT some data to the API" do
      Birbl::Action.put('partners', [{:name => 'Test partner'}]).each { |partner|
        partner.should be_an_instance_of(Hash)
      }
    end

    it "DELETE some data from the API" do
      Birbl::Action.delete('partners/1').should == true
    end
  end
end
