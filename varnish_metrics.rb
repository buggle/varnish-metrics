# encoding: utf-8

require 'yaml'
require 'json'

class Hash
  def to_xml
    map do |k, v|
      text = Hash === v ? "\n#{v.to_xml}" : v
      "<%s>%s</%s>" % [k, text, k]
    end.join("\n")
  end

  def to_text
    map do |k, v|
      text = Hash === v ? "\n#{v.to_text}" : v
      "%s=%s" % [k, text]
    end.join("\n")
  end
end


class VarnishMetrics

  # class VarnishMetrics to query a certain (tiny) subset of varnishstats and provide these metrics in several output formats. Implemented on special request.
  # All system calls to `varnishstats`, `varnishadmin` and their subsequent output parsing follow varnish version 4.1.0 on Mac OSX 10.11.3.
  # The regex-matcher keywords might differ in other varnish versions and respective adaptions might be required in the read_ methods below.
  # cbuggle, 22.3.2016

  attr_accessor :cache_hit, :cache_miss, :bytes_available, :header_bytes, :body_bytes, :backend_health

  def dump_metrics instance: instance, output: output
    read_metrics instance: instance
    puts send( "to_#{output}".to_sym )
  end

  def to_text
    metrics.to_text
  end

  def to_json
    metrics.to_json
  end

  def to_xml
    # We might want to use Nokogiri, yet not in this prototype. cbuggle, 22.3.2016
    %(<?xml version=\"1.0\"?>
<varnish_metrics>
#{metrics.to_xml}
</varnish_metrics>)
  end

  def to_yaml
    metrics.to_yaml
  end

  private

  def metrics
    {
      'cache_filling' => cache_filling,
      'cachesize' => bytes_available,
      'cache_hit_rate' => cache_hit_rate,
      'backend_health_status' => backend_health_status
    }
  end

  def backend_health_status
    status = read_backend_health_list.collect do |backend_health_line|
      backend_status = backend_health_line.match(/^boot.(\S*)\s*probe\s*(.*)/)
      [backend_status[1], backend_status[2]]
    end.flatten
    Hash[*status]
  end

  def cache_hit_rate
    return 0 if (cache_hit + cache_miss) == 0
    cache_hit.to_f / (cache_hit + cache_miss)
  end

  def cache_filling
    header_bytes + body_bytes
  end

  def read_metrics instance: instance
    stats = read_varnishstats instance
    # Since we need only a very small subset of varnishstats I do the mapping by hand.
    # Once this grows some key/value iterating will become appropriate. cbuggle, 22.3.2016
    self.bytes_available = stats.match(/SMA.s0.g_space\s+(\d+)\s*/)[1].to_i
    self.cache_hit       = stats.match(/MAIN.cache_hit\s+(\d+)\s*/)[1].to_i
    self.cache_miss      = stats.match(/MAIN.cache_miss\s+(\d+)\s*/)[1].to_i
    self.header_bytes    = stats.match(/MAIN.s_resp_hdrbytes\s+(\d+)\s*/)[1].to_i
    self.body_bytes      = stats.match(/MAIN.s_resp_bodybytes\s+(\d+)\s*/)[1].to_i
  end

  def read_backend_health_list
    `varnishadm backend.list`.split(/\n/).drop(1)  # We drop the header line which carries no data.
  end

  def read_varnishstats instance=nil
    instance = " -n #{instance}" if instance
    `varnishstat -1#{instance}`
  end
end
