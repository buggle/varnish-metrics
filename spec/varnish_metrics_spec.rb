require 'spec_helper'

describe VarnishMetrics do

  SUPPORTED_OUTPUT_FORMATS = ["json", "text", "yaml", "xml"]

  def expected_output_for format
    File.open( File.join( __dir__, 'expectations', "dumped_metrics.#{format}"),'r').read #.strip
  end

  let(:varnish_metrics){ described_class.new }

  let(:varnishadmin_fixture) { File.open( File.join( __dir__, 'fixtures', 'varnishadm_backend.list.txt')).read }
  let(:varnishstat_fixture)  { File.open( File.join( __dir__, 'fixtures', 'varnishstat-1.txt')).read }

  before :each do
    allow( varnish_metrics ).to receive(:`).with("varnishstat -1").and_return varnishstat_fixture
    allow( varnish_metrics ).to receive(:`).with("varnishadm backend.list").and_return varnishadmin_fixture
  end

  context "outputs" do
    SUPPORTED_OUTPUT_FORMATS.each do |format|
      it "#{format}" do
        expect( expected_output_for(format) ).to_not be_nil # assert there is an actual output to test against (no accidentally empty file).
         expect {
           varnish_metrics.dump_metrics(instance: nil, output: format)
         }.to output( expected_output_for(format) ).to_stdout
       end
    end
  end

  it "respects instance" do
    expect( varnish_metrics ).to receive(:`).with("varnishstat -1 -n 127.0.0.1").and_return varnishstat_fixture

    varnish_metrics.dump_metrics(instance: "127.0.0.1", output: "json")
  end
end
