require 'birbl'

describe Birbl do

  class DummyClass
  end

  before(:each) do
    @dummy = DummyClass.new
    @dummy.extend Birbl
  end

  describe Action do
    it "allows for setting the timeout value" do
      lambda {Birbl::Action.timeout = true}.should_not raise_error
    end

    it "uses a sandbox" do
      Birbl::Action.use_sandbox = true
      Birbl::Action.url.should == 'https://dev-api.birbl.com'
    end

    it "uses the live api" do
      Birbl::Action.use_sandbox = false
      Birbl::Action.url.should == 'https://api.birbl.com'
    end

    it "sets dev url" do
      lambda {Birbl::Action.dev_url = 'http://localhost:8080'}.should_not raise_error
    end

    it "sets live url" do
      lambda {Birbl::Action.base_url = 'http://localhost:8080'}.should_not raise_error
    end

    it "uses an api key" do
      lambda {Birbl::Action.api_key = '1234567890'}.should_not raise_error
    end

    it "GETs some data from the API" do
      lambda { Birbl::Action.get('partners') }.should_not raise_error
    end

    it "fails to GET some data from the API if the URI is wrong" do
      lambda { Birbl::Action.get('wrong') }.should raise_error
    end
  end
end
