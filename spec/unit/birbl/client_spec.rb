require 'birbl'

describe Birbl::Client do
  let(:response) { stub('Response', body: '{"data": "{\"id\":1}"}') }
  let(:error_response) { stub('Response', body: '{"error_type": "badrequest"}') }

  context 'without initialization' do
    context '.instance' do
      it 'raises an error' do
        expect {
          Birbl::Client.instance
        }.to raise_error(RuntimeError, /No instance/)
      end
    end

    context '.instance?' do
      it 'is false' do
        expect(Birbl::Client.instance?).to be_false
      end
    end

    context '.new' do
      it 'takes one parameter' do
        expect {
          Birbl::Client.new
        }.to raise_error(ArgumentError, /\(0 for 1\)/)
      end
    end
  end

  context 'with initialization' do
    subject { Birbl::Client.new('the_key') }

    before do
      subject # create it
    end

    context '.instance' do
      it 'returns the instance' do
        expect(Birbl::Client.instance).to be(subject)
      end
    end

    context '.instance?' do
      it 'is true' do
        expect(Birbl::Client.instance?).to be_true
      end
    end

    context 'attributes' do
      [
        [:use_sandbox, false],
        [:base_url,    'https://api.birbl.com'],
        [:dev_url,     'https://dev-api.birbl.com'],
        [:timeout,     10],
      ].each do |attribute, value|
        it "it has accessors for #{attribute}" do
          setter = "#{attribute}=".intern

          subject.send(setter, 'foo')

          expect(subject.send(attribute)).to eq('foo')
        end

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

    context '#get' do
      before do
        RestClient.stub(get: response)
      end

      it 'proxies to RestClient' do
        RestClient.should_receive(:get).
          with('https://api.birbl.com/partners', BIRBL_KEY: 'the_key').
          and_return(response)

        subject.get('partners')
      end

      it 'returns the parsed data' do
        expect(subject.get('partners')).to eq({'id' => 1})
      end

      it 'fails on error responses' do
        RestClient.stub(get: error_response)

        expect {
          subject.get('partners')
        }.to raise_error(RuntimeError, /badrequest/)
      end
    end

    context '#post' do
      before do
        RestClient.stub(:post).
          with(
            'https://api.birbl.com/partners',
            'data=[]',
            BIRBL_KEY: 'the_key'
          ).
          and_return(response)
      end

      it 'proxies to RestClient' do
        RestClient.should_receive(:post).
          with(
            'https://api.birbl.com/partners',
            'data=[]',
            BIRBL_KEY: 'the_key'
          ).
          and_return(response)

        subject.post('partners')
      end

      it 'parses the response payload' do
        expect(subject.post('partners')).to be_a(Hash)
      end

      it 'returns a HashWithIndifferentAccess' do
        result = subject.post('partners')

        expect(result['id']).to eq(1)
        expect(result[:id]).to eq(1)
      end
    end
  end
end

