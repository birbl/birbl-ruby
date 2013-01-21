require 'birbl'

describe Birbl::Action do
  context 'without initialization' do
    context '.instance' do
      it 'raises an error'
    end

    context '.new' do
      it 'takes one parameter'
    end
  end

  context 'with initialization' do
    subject { Birbl::Action.new('the_key') }

    context '.instance' do
      it 'returns the instance' do
        subject # create it
        expect(Birbl::Action.instance).to be(subject)
      end
    end

    context 'attributes' do
      [
        [:use_sandbox, false],
        [:base_url,    'https://api.birbl.com'],
        [:dev_url,     'https://dev-api.birbl.com'],
        [:timeout,     10],
      ].each do |attribute, value|
        it "has accessors for #{attribute}"
        example "#{attribute} defaults to #{value}" do
          expect(subject.send(attribute)).to eq(value)
        end
      end
    end

    context '.url' do
      context 'when not sandboxed' do
        it 'returns production URL' do
          expect(subject.url).to eq('https://api.birbl.com')
        end
      end

      context 'when sandboxed' do
        it 'returns staging URL' do
          subject.use_sandbox = true

          expect(subject.url).to eq('https://dev-api.birbl.com')
        end
      end
    end

    context '.get' do
      before do
        good_response = mock('response')
        good_response.stub(:body).and_return(JSON.generate({
          data: [{
            name:  "Dummy Partner",
            email: "partner@example.com"
          }]
        }))

        error_response = mock('response')
        error_response.stub(:body).and_return(JSON.generate({
          data: [],
          error_type: 'Dummy error',
          error_message: 'Dummy error message'
        }))

        RestClient.stub(:get).with('https://api.birbl.com/partners', :BIRBL_KEY => 'the_key').and_return(good_response, error_response)
      end

      it 'proxies to foobar' do
        RestClient.should_receive(:get).with('https://api.birbl.com/partners', :BIRBL_KEY => 'the_key')
      end

      it 'returns parsed JSON data' do
        expect(subject.get('partners')).to eq([{"name" => "Dummy Partner", "email" => "partner@example.com"}])
      end

      it 'fails on error responses' do
        expect(subject.get('partners')).to raise_error
      end
    end
  end
end
