# GetVarnishMetrics

A little tool for quering a certain (tiny) subset of varnishstats and provide these metrics in several output formats.

## Usage

* Usage: ./get_varnish_metrics.rb --output [ text | json | xml | yaml ] [--instance INSTANCE]
  + -i, --instance instance          The varnish instance to be queried
  + -o, --output output              The Output format. Available formats are: text, json, xml, yaml
  + -h, --help                       Displays Help

## Varnish

This tool has been developed on varnish 4.1.0 installed with brew on Mac OS-X 10.11.3.

All system calls to `varnishstats`, `varnishadmin` and their subsequent output parsing follow varnish version 4.1.0 on Mac OSX 10.11.3.
The regex-matcher keywords in class VarnishMetrics might differ in other varnish versions and respective adaptions might be required in the read_ methods.

## License

Copyright (c) 2016 by Christian Buggle

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
