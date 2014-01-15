require 'spec_helper'

describe Arachni::Browser::Javascript do

    before( :all ) do
        @url = Arachni::Utilities.normalize_url( web_server_url_for( :javascript ) )
    end

    before( :each ) do
        @browser = Arachni::Browser.new
        @javascript = @browser.javascript
    end

    after( :each ) do
        Arachni::Options.reset
        Arachni::Framework.reset
        @browser.shutdown
    end

    #describe '#log_sink_stub' do
    #    it 'returns JS code that calls JS\'s log_sink()' do
    #        @javascript.log_sink_stub.should == "_#{@javascript.token}.log_sink()"
    #
    #        @browser.load "#{@url}/debugging_data?input=#{@javascript.log_sink_stub}"
    #        @browser.watir.form.submit
    #        @javascript.sink.should be_any
    #        @javascript.sink.first[:data].should be_empty
    #    end
    #
    #    context 'when an argument is passed' do
    #        it 'converts it to JSON' do
    #            [1, true].each do |arg|
    #                @browser.load "#{@url}/debugging_data?input=#{@javascript.log_sink_stub( arg )}"
    #                @browser.watir.form.submit
    #                @javascript.sink.first[:data].should == [arg]
    #            end
    #        end
    #    end
    #end

    describe '#taint' do
        context 'when tainted data pass through' do
            #context 'global methods' do
            #    it 'logs it' do
            #        @javascript.taint = @browser.generate_token
            #        @browser.load "#{@url}/data_trace/global-functions?taint=#{@javascript.taint}"
            #
            #        pages = @browser.flush_page_snapshots_with_sinks
            #
            #        pages.size.should == 1
            #        page = pages.first
            #
            #        page.dom.sink.size.should == 1
            #
            #        entry = page.dom.sink[0]
            #        entry[:data][0]['object'].should == 'DOMWindow'
            #        entry[:data][0]['function'].should == 'process'
            #        entry[:data][0]['source'].should start_with 'function process'
            #        entry[:data][0]['arguments'].should == [
            #            {
            #                'my_data' => 'blah',
            #                'input'   => @javascript.taint
            #            }
            #        ]
            #        entry[:data][0]['tainted'].should == @javascript.taint
            #        entry[:data][0]['taint'].should == @javascript.taint
            #        page.body.split("\n")[entry[:trace][0][:line]].should include 'process('
            #    end
            #end
            #
            #context 'XMLHttpRequest' do
            #    context '.open' do
            #        it 'logs it' do
            #            @javascript.taint = @browser.generate_token
            #            @browser.load "#{@url}/data_trace/XMLHttpRequest.open?taint=#{@javascript.taint}"
            #
            #            pages = @browser.flush_page_snapshots_with_sinks
            #
            #            pages.size.should == 1
            #            page = pages.first
            #
            #            page.dom.sink.size.should == 1
            #
            #            entry = page.dom.sink[0]
            #            entry[:data][0]['object'].should == 'XMLHttpRequestPrototype'
            #            entry[:data][0]['function'].should == 'open'
            #            entry[:data][0]['arguments'].should == [
            #                'GET', "/?taint=#{@javascript.taint}", true
            #            ]
            #            entry[:data][0]['tainted'].should == "/?taint=#{@javascript.taint}"
            #            entry[:data][0]['taint'].should == @javascript.taint
            #
            #            trace = entry[:trace][0]
            #            page.body.split("\n")[trace[:line]].should include 'open('
            #            trace[:url].should == page.url
            #        end
            #    end
            #
            #    context '.send' do
            #        it 'logs it' do
            #            @javascript.taint = @browser.generate_token
            #            @browser.load "#{@url}/data_trace/XMLHttpRequest.send?taint=#{@javascript.taint}"
            #
            #            pages = @browser.flush_page_snapshots_with_sinks
            #
            #            pages.size.should == 1
            #            page = pages.first
            #
            #            page.dom.sink.size.should == 1
            #
            #            entry = page.dom.sink[0]
            #            entry[:data][0]['object'].should == 'XMLHttpRequestPrototype'
            #            entry[:data][0]['function'].should == 'send'
            #            entry[:data][0]['arguments'].should == [ "taint=#{@javascript.taint}" ]
            #            entry[:data][0]['tainted'].should == "taint=#{@javascript.taint}"
            #            entry[:data][0]['taint'].should == @javascript.taint
            #
            #            trace = entry[:trace][0]
            #            page.body.split("\n")[trace[:line]].should include 'send('
            #            trace[:url].should == page.url
            #        end
            #    end
            #
            #    context '.setRequestHeader' do
            #        it 'logs it' do
            #            @javascript.taint = @browser.generate_token
            #            @browser.load "#{@url}/data_trace/XMLHttpRequest.setRequestHeader?taint=#{@javascript.taint}"
            #
            #            pages = @browser.flush_page_snapshots_with_sinks
            #
            #            pages.size.should == 1
            #            page = pages.first
            #
            #            page.dom.sink.size.should == 1
            #
            #            entry = page.dom.sink[0]
            #            entry[:data][0]['object'].should == 'XMLHttpRequestPrototype'
            #            entry[:data][0]['function'].should == 'setRequestHeader'
            #            entry[:data][0]['arguments'].should == [ 'X-My-Header', "stuff-#{@javascript.taint}" ]
            #            entry[:data][0]['tainted'].should == "stuff-#{@javascript.taint}"
            #            entry[:data][0]['taint'].should == @javascript.taint
            #
            #            trace = entry[:trace][0]
            #            page.body.split("\n")[trace[:line]].should include 'setRequestHeader('
            #            trace[:url].should == page.url
            #        end
            #    end
            #end

            context 'AngularJS' do
                context '.http' do
                    it 'logs it' do
                        @javascript.taint = @browser.generate_token
                        @browser.load "#{@url}/data_trace/AngularJS.$http?taint=#{@javascript.taint}"

                        puts @browser.source_with_line_numbers
                        #ap @javascript.debugging_data

                        pages = @browser.flush_page_snapshots_with_sinks

                        pages.size.should == 1
                        page = pages.first

                        ap page.dom.sink

                        page.dom.sink.size.should == 2

                        entry = page.dom.sink[1]
                        entry[:data][0]['object'].should == 'angular'
                        entry[:data][0]['function'].should == '$http'
                        entry[:data][0]['arguments'].should == ["Stuff #{@javascript.taint}"]
                        entry[:data][0]['tainted'].should == "Stuff #{@javascript.taint}"
                        entry[:data][0]['taint'].should == @javascript.taint

                        trace = entry[:trace][0]
                        page.body.split("\n")[trace[:line]-1].should include '$http('
                        trace[:url].should == page.url
                    end
                end

                #context 'jqLite' do
                    #context '.html' do
                    #    it 'logs it' do
                    #        @javascript.taint = @browser.generate_token
                    #        @browser.load "#{@url}/data_trace/AngularJS/jqLite.html?taint=#{@javascript.taint}"
                    #
                    #        pages = @browser.flush_page_snapshots_with_sinks
                    #
                    #        pages.size.should == 1
                    #        page = pages.first
                    #
                    #        page.dom.sink.size.should == 2
                    #
                    #        entry = page.dom.sink[1]
                    #        entry[:data][0]['object'].should == 'angular.element'
                    #        entry[:data][0]['function'].should == 'html'
                    #        entry[:data][0]['arguments'].should == ["Stuff #{@javascript.taint}"]
                    #        entry[:data][0]['tainted'].should == "Stuff #{@javascript.taint}"
                    #        entry[:data][0]['taint'].should == @javascript.taint
                    #
                    #        trace = entry[:trace][0]
                    #        page.body.split("\n")[trace[:line]-1].should include 'html('
                    #        trace[:url].should == page.url
                    #    end
                    #end
                    #
                    #context '.text' do
                    #    it 'logs it' do
                    #        @javascript.taint = @browser.generate_token
                    #        @browser.load "#{@url}/data_trace/AngularJS/jqLite.text?taint=#{@javascript.taint}"
                    #
                    #        pages = @browser.flush_page_snapshots_with_sinks
                    #
                    #        pages.size.should == 1
                    #        page = pages.first
                    #
                    #        page.dom.sink.size.should == 2
                    #
                    #        entry = page.dom.sink[1]
                    #        entry[:data][0]['object'].should == 'angular.element'
                    #        entry[:data][0]['function'].should == 'text'
                    #        entry[:data][0]['arguments'].should == ["Stuff #{@javascript.taint}"]
                    #        entry[:data][0]['tainted'].should == "Stuff #{@javascript.taint}"
                    #        entry[:data][0]['taint'].should == @javascript.taint
                    #
                    #        trace = entry[:trace][0]
                    #        page.body.split("\n")[trace[:line]-1].should include 'text('
                    #        trace[:url].should == page.url
                    #    end
                    #end
                    #
                    #context '.append' do
                    #    it 'logs it' do
                    #        @javascript.taint = @browser.generate_token
                    #        @browser.load "#{@url}/data_trace/AngularJS/jqLite.append?taint=#{@javascript.taint}"
                    #
                    #        pages = @browser.flush_page_snapshots_with_sinks
                    #
                    #        pages.size.should == 1
                    #        page = pages.first
                    #
                    #        page.dom.sink.size.should == 2
                    #
                    #        entry = page.dom.sink[1]
                    #        entry[:data][0]['object'].should == 'angular.element'
                    #        entry[:data][0]['function'].should == 'append'
                    #        entry[:data][0]['arguments'].should == ["Stuff #{@javascript.taint}"]
                    #        entry[:data][0]['tainted'].should == "Stuff #{@javascript.taint}"
                    #        entry[:data][0]['taint'].should == @javascript.taint
                    #
                    #        trace = entry[:trace][0]
                    #        page.body.split("\n")[trace[:line]].should include 'append('
                    #        trace[:url].should == page.url
                    #    end
                    #end
                    #
                    #context '.prepend' do
                    #    it 'logs it' do
                    #        @javascript.taint = @browser.generate_token
                    #        @browser.load "#{@url}/data_trace/AngularJS/jqLite.prepend?taint=#{@javascript.taint}"
                    #
                    #        pages = @browser.flush_page_snapshots_with_sinks
                    #
                    #        pages.size.should == 1
                    #        page = pages.first
                    #
                    #        page.dom.sink.size.should == 2
                    #
                    #        entry = page.dom.sink[1]
                    #        entry[:data][0]['object'].should == 'angular.element'
                    #        entry[:data][0]['function'].should == 'prepend'
                    #        entry[:data][0]['arguments'].should == ["Stuff #{@javascript.taint}"]
                    #        entry[:data][0]['tainted'].should == "Stuff #{@javascript.taint}"
                    #        entry[:data][0]['taint'].should == @javascript.taint
                    #
                    #        trace = entry[:trace][0]
                    #        page.body.split("\n")[trace[:line]].should include 'prepend('
                    #        trace[:url].should == page.url
                    #    end
                    #end
                    #
                    #context '.prop' do
                    #    it 'logs it' do
                    #        @javascript.taint = @browser.generate_token
                    #        @browser.load "#{@url}/data_trace/AngularJS/jqLite.prop?taint=#{@javascript.taint}"
                    #
                    #        pages = @browser.flush_page_snapshots_with_sinks
                    #
                    #        pages.size.should == 1
                    #        page = pages.first
                    #
                    #        page.dom.sink.size.should == 2
                    #
                    #        entry = page.dom.sink[1]
                    #        entry[:data][0]['object'].should == 'angular.element'
                    #        entry[:data][0]['function'].should == 'prop'
                    #        entry[:data][0]['arguments'].should == [ 'stuff', "Stuff #{@javascript.taint}"]
                    #        entry[:data][0]['tainted'].should == "Stuff #{@javascript.taint}"
                    #        entry[:data][0]['taint'].should == @javascript.taint
                    #
                    #        trace = entry[:trace][0]
                    #        page.body.split("\n")[trace[:line]].should include 'prop('
                    #        trace[:url].should == page.url
                    #    end
                    #end
                    #
                    #context '.replaceWith' do
                    #    it 'logs it' do
                    #        @javascript.taint = @browser.generate_token
                    #        @browser.load "#{@url}/data_trace/AngularJS/jqLite.replaceWith?taint=#{@javascript.taint}"
                    #
                    #        pages = @browser.flush_page_snapshots_with_sinks
                    #
                    #        pages.size.should == 1
                    #        page = pages.first
                    #
                    #        page.dom.sink.size.should == 2
                    #
                    #        entry = page.dom.sink[1]
                    #        entry[:data][0]['object'].should == 'angular.element'
                    #        entry[:data][0]['function'].should == 'replaceWith'
                    #        entry[:data][0]['arguments'].should == [ "Stuff #{@javascript.taint}"]
                    #        entry[:data][0]['tainted'].should == "Stuff #{@javascript.taint}"
                    #        entry[:data][0]['taint'].should == @javascript.taint
                    #
                    #        trace = entry[:trace][0]
                    #        page.body.split("\n")[trace[:line]-1].should include 'replaceWith('
                    #        trace[:url].should == page.url
                    #    end
                    #end
                    #
                    #context '.val' do
                    #    it 'logs it' do
                    #        @javascript.taint = @browser.generate_token
                    #        @browser.load "#{@url}/data_trace/AngularJS/jqLite.val?taint=#{@javascript.taint}"
                    #
                    #        pages = @browser.flush_page_snapshots_with_sinks
                    #
                    #        pages.size.should == 1
                    #        page = pages.first
                    #
                    #        page.dom.sink.size.should == 2
                    #
                    #        entry = page.dom.sink[1]
                    #        entry[:data][0]['object'].should == 'angular.element'
                    #        entry[:data][0]['function'].should == 'val'
                    #        entry[:data][0]['arguments'].should == [ "Stuff #{@javascript.taint}"]
                    #        entry[:data][0]['tainted'].should == "Stuff #{@javascript.taint}"
                    #        entry[:data][0]['taint'].should == @javascript.taint
                    #
                    #        trace = entry[:trace][0]
                    #        page.body.split("\n")[trace[:line]].should include 'val('
                    #        trace[:url].should == page.url
                    #    end
                    #end
                #end
            end

            #context 'jQuery' do
            #    context '.ajax' do
            #        it 'logs it' do
            #            @javascript.taint = @browser.generate_token
            #            @browser.load "#{@url}/data_trace/jQuery.ajax?taint=#{@javascript.taint}"
            #
            #            pages = @browser.flush_page_snapshots_with_sinks
            #
            #            pages.size.should == 1
            #            page = pages.first
            #
            #            page.dom.sink.size.should == 2
            #
            #            entry = page.dom.sink[0]
            #            entry[:data][0]['object'].should == 'jQuery'
            #            entry[:data][0]['function'].should == 'ajax'
            #            entry[:data][0]['arguments'].should == [
            #                {
            #                    'url'  => '/',
            #                    'data' => {
            #                        'stuff' => "mystuff #{@javascript.taint}"
            #                    }
            #                }
            #            ]
            #            entry[:data][0]['tainted'].should == "mystuff #{@javascript.taint}"
            #            entry[:data][0]['taint'].should == @javascript.taint
            #
            #            trace = entry[:trace][0]
            #            page.body.split("\n")[trace[:line]].should include 'ajax('
            #            trace[:url].should == page.url
            #        end
            #    end
            #
            #    context '.get' do
            #        it 'logs it' do
            #            @javascript.taint = @browser.generate_token
            #            @browser.load "#{@url}/data_trace/jQuery.get?taint=#{@javascript.taint}"
            #
            #            pages = @browser.flush_page_snapshots_with_sinks
            #
            #            pages.size.should == 1
            #            page = pages.first
            #
            #            page.dom.sink.size.should == 3
            #
            #            entry = page.dom.sink[0]
            #            entry[:data][0]['object'].should == 'jQuery'
            #            entry[:data][0]['function'].should == 'get'
            #            entry[:data][0]['arguments'].should == [
            #                '/',
            #                { 'stuff' => "mystuff #{@javascript.taint}" }
            #            ]
            #            entry[:data][0]['tainted'].should == "mystuff #{@javascript.taint}"
            #            entry[:data][0]['taint'].should == @javascript.taint
            #
            #            trace = entry[:trace][0]
            #            page.body.split("\n")[trace[:line]].should include 'get('
            #            trace[:url].should == page.url
            #        end
            #    end
            #
            #    context '.post' do
            #        it 'logs it' do
            #            @javascript.taint = @browser.generate_token
            #            @browser.load "#{@url}/data_trace/jQuery.post?taint=#{@javascript.taint}"
            #
            #            pages = @browser.flush_page_snapshots_with_sinks
            #
            #            pages.size.should == 1
            #            page = pages.first
            #
            #            page.dom.sink.size.should == 3
            #
            #            entry = page.dom.sink[0]
            #            entry[:data][0]['object'].should == 'jQuery'
            #            entry[:data][0]['function'].should == 'post'
            #            entry[:data][0]['arguments'].should == [ "/#{@javascript.taint}" ]
            #            entry[:data][0]['tainted'].should == "/#{@javascript.taint}"
            #            entry[:data][0]['taint'].should == @javascript.taint
            #
            #            trace = entry[:trace][0]
            #            page.body.split("\n")[trace[:line]].should include 'post('
            #            trace[:url].should == page.url
            #        end
            #    end
            #
            #    context '.load' do
            #        it 'logs it' do
            #            @javascript.taint = @browser.generate_token
            #            @browser.load "#{@url}/data_trace/jQuery.load?taint=#{@javascript.taint}"
            #
            #            pages = @browser.flush_page_snapshots_with_sinks
            #
            #            pages.size.should == 1
            #            page = pages.first
            #
            #            page.dom.sink.size.should == 3
            #
            #            entry = page.dom.sink[0]
            #            entry[:data][0]['object'].should == 'jQuery'
            #            entry[:data][0]['function'].should == 'load'
            #            entry[:data][0]['arguments'].should == [ "/#{@javascript.taint}" ]
            #            entry[:data][0]['tainted'].should == "/#{@javascript.taint}"
            #            entry[:data][0]['taint'].should == @javascript.taint
            #
            #            trace = entry[:trace][0]
            #            page.body.split("\n")[trace[:line]].should include 'load('
            #            trace[:url].should == page.url
            #        end
            #    end
            #
            #    context '.html' do
            #        it 'logs it' do
            #            @javascript.taint = @browser.generate_token
            #            @browser.load "#{@url}/data_trace/jQuery.html?taint=#{@javascript.taint}"
            #
            #            pages = @browser.flush_page_snapshots_with_sinks
            #
            #            pages.size.should == 1
            #            page = pages.first
            #
            #            page.dom.sink.size.should == 1
            #
            #            entry = page.dom.sink[0]
            #            entry[:data][0]['object'].should == 'jQuery'
            #            entry[:data][0]['function'].should == 'html'
            #            entry[:data][0]['arguments'].should == ["Stuff #{@javascript.taint}"]
            #            entry[:data][0]['tainted'].should == "Stuff #{@javascript.taint}"
            #            entry[:data][0]['taint'].should == @javascript.taint
            #
            #            trace = entry[:trace][0]
            #            page.body.split("\n")[trace[:line]-1].should include 'html('
            #            trace[:url].should == page.url
            #        end
            #    end
            #
            #    context '.text' do
            #        it 'logs it' do
            #            @javascript.taint = @browser.generate_token
            #            @browser.load "#{@url}/data_trace/jQuery.text?taint=#{@javascript.taint}"
            #
            #            pages = @browser.flush_page_snapshots_with_sinks
            #
            #            pages.size.should == 1
            #            page = pages.first
            #
            #            page.dom.sink.size.should == 2
            #
            #            entry = page.dom.sink[0]
            #            entry[:data][0]['object'].should == 'jQuery'
            #            entry[:data][0]['function'].should == 'text'
            #            entry[:data][0]['arguments'].should == ["Stuff #{@javascript.taint}"]
            #            entry[:data][0]['tainted'].should == "Stuff #{@javascript.taint}"
            #            entry[:data][0]['taint'].should == @javascript.taint
            #
            #            trace = entry[:trace][0]
            #            page.body.split("\n")[trace[:line]-1].should include 'text('
            #            trace[:url].should == page.url
            #        end
            #    end
            #
            #    context '.append' do
            #        it 'logs it' do
            #            @javascript.taint = @browser.generate_token
            #            @browser.load "#{@url}/data_trace/jQuery.append?taint=#{@javascript.taint}"
            #
            #            pages = @browser.flush_page_snapshots_with_sinks
            #
            #            pages.size.should == 1
            #            page = pages.first
            #
            #            page.dom.sink.size.should == 2
            #
            #            entry = page.dom.sink[0]
            #            entry[:data][0]['object'].should == 'jQuery'
            #            entry[:data][0]['function'].should == 'append'
            #            entry[:data][0]['arguments'].should == ["Stuff #{@javascript.taint}"]
            #            entry[:data][0]['tainted'].should == "Stuff #{@javascript.taint}"
            #            entry[:data][0]['taint'].should == @javascript.taint
            #
            #            trace = entry[:trace][0]
            #            page.body.split("\n")[trace[:line]].should include 'append('
            #            trace[:url].should == page.url
            #        end
            #    end
            #
            #    context '.prepend' do
            #        it 'logs it' do
            #            @javascript.taint = @browser.generate_token
            #            @browser.load "#{@url}/data_trace/jQuery.prepend?taint=#{@javascript.taint}"
            #
            #            pages = @browser.flush_page_snapshots_with_sinks
            #
            #            pages.size.should == 1
            #            page = pages.first
            #
            #            page.dom.sink.size.should == 2
            #
            #            entry = page.dom.sink[0]
            #            entry[:data][0]['object'].should == 'jQuery'
            #            entry[:data][0]['function'].should == 'prepend'
            #            entry[:data][0]['arguments'].should == ["Stuff #{@javascript.taint}"]
            #            entry[:data][0]['tainted'].should == "Stuff #{@javascript.taint}"
            #            entry[:data][0]['taint'].should == @javascript.taint
            #
            #            trace = entry[:trace][0]
            #            page.body.split("\n")[trace[:line]].should include 'prepend('
            #            trace[:url].should == page.url
            #        end
            #    end
            #
            #    context '.before' do
            #        it 'logs it' do
            #            @javascript.taint = @browser.generate_token
            #            @browser.load "#{@url}/data_trace/jQuery.before?taint=#{@javascript.taint}"
            #
            #            pages = @browser.flush_page_snapshots_with_sinks
            #
            #            pages.size.should == 1
            #            page = pages.first
            #
            #            page.dom.sink.size.should == 2
            #
            #            entry = page.dom.sink[0]
            #            entry[:data][0]['object'].should == 'jQuery'
            #            entry[:data][0]['function'].should == 'before'
            #            entry[:data][0]['arguments'].should == ["Stuff #{@javascript.taint}"]
            #            entry[:data][0]['tainted'].should == "Stuff #{@javascript.taint}"
            #            entry[:data][0]['taint'].should == @javascript.taint
            #
            #            trace = entry[:trace][0]
            #            page.body.split("\n")[trace[:line]].should include 'before('
            #            trace[:url].should == page.url
            #        end
            #    end
            #
            #    context '.prop' do
            #        it 'logs it' do
            #            @javascript.taint = @browser.generate_token
            #            @browser.load "#{@url}/data_trace/jQuery.prop?taint=#{@javascript.taint}"
            #
            #            pages = @browser.flush_page_snapshots_with_sinks
            #
            #            pages.size.should == 1
            #            page = pages.first
            #
            #            page.dom.sink.size.should == 1
            #
            #            entry = page.dom.sink[0]
            #            entry[:data][0]['object'].should == 'jQuery'
            #            entry[:data][0]['function'].should == 'prop'
            #            entry[:data][0]['arguments'].should == [ 'stuff', "Stuff #{@javascript.taint}"]
            #            entry[:data][0]['tainted'].should == "Stuff #{@javascript.taint}"
            #            entry[:data][0]['taint'].should == @javascript.taint
            #
            #            trace = entry[:trace][0]
            #            page.body.split("\n")[trace[:line]].should include 'prop('
            #            trace[:url].should == page.url
            #        end
            #    end
            #
            #    context '.replaceWith' do
            #        it 'logs it' do
            #            @javascript.taint = @browser.generate_token
            #            @browser.load "#{@url}/data_trace/jQuery.replaceWith?taint=#{@javascript.taint}"
            #
            #            pages = @browser.flush_page_snapshots_with_sinks
            #
            #            pages.size.should == 1
            #            page = pages.first
            #
            #            page.dom.sink.size.should == 2
            #
            #            entry = page.dom.sink[0]
            #            entry[:data][0]['object'].should == 'jQuery'
            #            entry[:data][0]['function'].should == 'replaceWith'
            #            entry[:data][0]['arguments'].should == [ "Stuff #{@javascript.taint}"]
            #            entry[:data][0]['tainted'].should == "Stuff #{@javascript.taint}"
            #            entry[:data][0]['taint'].should == @javascript.taint
            #
            #            trace = entry[:trace][0]
            #            page.body.split("\n")[trace[:line]-1].should include 'replaceWith('
            #            trace[:url].should == page.url
            #        end
            #    end
            #
            #    context '.val' do
            #        it 'logs it' do
            #            @javascript.taint = @browser.generate_token
            #            @browser.load "#{@url}/data_trace/jQuery.val?taint=#{@javascript.taint}"
            #
            #            pages = @browser.flush_page_snapshots_with_sinks
            #
            #            pages.size.should == 1
            #            page = pages.first
            #
            #            page.dom.sink.size.should == 1
            #
            #            entry = page.dom.sink[0]
            #            entry[:data][0]['object'].should == 'jQuery'
            #            entry[:data][0]['function'].should == 'val'
            #            entry[:data][0]['arguments'].should == [ "Stuff #{@javascript.taint}"]
            #            entry[:data][0]['tainted'].should == "Stuff #{@javascript.taint}"
            #            entry[:data][0]['taint'].should == @javascript.taint
            #
            #            trace = entry[:trace][0]
            #            page.body.split("\n")[trace[:line]].should include 'val('
            #            trace[:url].should == page.url
            #        end
            #    end
            #end
            #
            #context 'String' do
            #    context '.replace' do
            #        it 'logs it' do
            #            @javascript.taint = @browser.generate_token
            #            @browser.load "#{@url}/data_trace/String.replace?taint=#{@javascript.taint}"
            #
            #            pages = @browser.flush_page_snapshots_with_sinks
            #
            #            pages.size.should == 1
            #            page = pages.first
            #
            #            page.dom.sink.size.should == 1
            #
            #            entry = page.dom.sink[0]
            #            entry[:data][0]['object'].should == 'String'
            #            entry[:data][0]['function'].should == 'replace'
            #            entry[:data][0]['source'].should start_with 'function replace'
            #            entry[:data][0]['arguments'].should == [
            #                'my', @javascript.taint
            #            ]
            #            entry[:data][0]['tainted'].should == @javascript.taint
            #            entry[:data][0]['taint'].should == @javascript.taint
            #
            #            trace = entry[:trace][0]
            #            page.body.split("\n")[trace[:line]].should include 'replace('
            #            trace[:url].should == page.url
            #        end
            #    end
            #
            #    context '.concat' do
            #        it 'logs it' do
            #            @javascript.taint = @browser.generate_token
            #            @browser.load "#{@url}/data_trace/String.concat?taint=#{@javascript.taint}"
            #
            #            pages = @browser.flush_page_snapshots_with_sinks
            #
            #            pages.size.should == 1
            #            page = pages.first
            #
            #            page.dom.sink.size.should == 1
            #
            #            entry = page.dom.sink[0]
            #            entry[:data][0]['object'].should == 'String'
            #            entry[:data][0]['function'].should == 'concat'
            #            entry[:data][0]['source'].should start_with 'function concat'
            #            entry[:data][0]['arguments'].should == [ "stuff #{@javascript.taint}" ]
            #            entry[:data][0]['tainted'].should == "stuff #{@javascript.taint}"
            #            entry[:data][0]['taint'].should == @javascript.taint
            #
            #            trace = entry[:trace][0]
            #            page.body.split("\n")[trace[:line]].should include 'concat('
            #            trace[:url].should == page.url
            #        end
            #    end
            #end
            #
            #context 'HTMLElement' do
            #    context '.insertAdjacentHTML' do
            #        it 'logs it' do
            #            @javascript.taint = @browser.generate_token
            #            @browser.load "#{@url}/data_trace/HTMLElement.insertAdjacentHTML?taint=#{@javascript.taint}"
            #
            #            pages = @browser.flush_page_snapshots_with_sinks
            #
            #            pages.size.should == 1
            #            page = pages.first
            #
            #            page.dom.sink.size.should == 1
            #
            #            entry = page.dom.sink[0]
            #            entry[:data][0]['object'].should == 'HTMLElementPrototype'
            #            entry[:data][0]['function'].should == 'insertAdjacentHTML'
            #            entry[:data][0]['source'].should start_with 'function insertAdjacentHTML'
            #            entry[:data][0]['arguments'].should == [
            #                'AfterBegin', "stuff #{@javascript.taint} more stuff"
            #            ]
            #            entry[:data][0]['tainted'].should == "stuff #{@javascript.taint} more stuff"
            #            entry[:data][0]['taint'].should == @javascript.taint
            #
            #            trace = entry[:trace][0]
            #            page.body.split("\n")[trace[:line]].should include 'insertAdjacentHTML('
            #            trace[:url].should == page.url
            #        end
            #    end
            #end
            #
            #context 'Element' do
            #    context '.setAttribute' do
            #        it 'logs it' do
            #            @javascript.taint = @browser.generate_token
            #            @browser.load "#{@url}/data_trace/Element.setAttribute?taint=#{@javascript.taint}"
            #
            #            pages = @browser.flush_page_snapshots_with_sinks
            #
            #            pages.size.should == 1
            #            page = pages.first
            #
            #            page.dom.sink.size.should == 1
            #
            #            entry = page.dom.sink[0]
            #            entry[:data][0]['object'].should == 'ElementPrototype'
            #            entry[:data][0]['function'].should == 'setAttribute'
            #            entry[:data][0]['source'].should start_with 'function setAttribute'
            #            entry[:data][0]['arguments'].should == [
            #                'my-attribute', "stuff #{@javascript.taint} more stuff"
            #            ]
            #            entry[:data][0]['tainted'].should == "stuff #{@javascript.taint} more stuff"
            #            entry[:data][0]['taint'].should == @javascript.taint
            #
            #            trace = entry[:trace][0]
            #            page.body.split("\n")[trace[:line]].should include 'setAttribute('
            #            trace[:url].should == page.url
            #        end
            #    end
            #end
            #
            #context 'Document' do
            #    context '.createTextNode' do
            #        it 'logs it' do
            #            @javascript.taint = @browser.generate_token
            #            @browser.load "#{@url}/data_trace/Document.createTextNode?taint=#{@javascript.taint}"
            #
            #            pages = @browser.flush_page_snapshots_with_sinks
            #
            #            pages.size.should == 1
            #            page = pages.first
            #
            #            page.dom.sink.size.should == 1
            #
            #            entry = page.dom.sink[0]
            #            entry[:data][0]['object'].should == 'DocumentPrototype'
            #            entry[:data][0]['function'].should == 'createTextNode'
            #            entry[:data][0]['source'].should start_with 'function createTextNode'
            #            entry[:data][0]['arguments'].should == [ "node #{@javascript.taint}" ]
            #            entry[:data][0]['tainted'].should == "node #{@javascript.taint}"
            #            entry[:data][0]['taint'].should == @javascript.taint
            #
            #            trace = entry[:trace][0]
            #            page.body.split("\n")[trace[:line]].should include 'document.createTextNode('
            #            trace[:url].should == page.url
            #        end
            #    end
            #end
            #
            #context 'CharacterData' do
            #    context '.insertData' do
            #        it 'logs it' do
            #            @javascript.taint = @browser.generate_token
            #            @browser.load "#{@url}/data_trace/CharacterData.insertData?taint=#{@javascript.taint}"
            #
            #            pages = @browser.flush_page_snapshots_with_sinks
            #
            #            pages.size.should == 1
            #            page = pages.first
            #
            #            page.dom.sink.size.should == 1
            #
            #            entry = page.dom.sink[0]
            #            entry[:data][0]['object'].should == 'CharacterDataPrototype'
            #            entry[:data][0]['function'].should == 'insertData'
            #            entry[:data][0]['source'].should start_with 'function insertData'
            #            entry[:data][0]['arguments'].should == [ "Stuff #{@javascript.taint}" ]
            #            entry[:data][0]['tainted'].should == "Stuff #{@javascript.taint}"
            #            entry[:data][0]['taint'].should == @javascript.taint
            #
            #            trace = entry[:trace][0]
            #            page.body.split("\n")[trace[:line]].should include 'insertData('
            #            trace[:url].should == page.url
            #        end
            #    end
            #
            #    context '.appendData' do
            #        it 'logs it' do
            #            @javascript.taint = @browser.generate_token
            #            @browser.load "#{@url}/data_trace/CharacterData.appendData?taint=#{@javascript.taint}"
            #
            #            pages = @browser.flush_page_snapshots_with_sinks
            #
            #            pages.size.should == 1
            #            page = pages.first
            #
            #            page.dom.sink.size.should == 1
            #
            #            entry = page.dom.sink[0]
            #            entry[:data][0]['object'].should == 'CharacterDataPrototype'
            #            entry[:data][0]['function'].should == 'appendData'
            #            entry[:data][0]['source'].should start_with 'function appendData'
            #            entry[:data][0]['arguments'].should == [ "Stuff #{@javascript.taint}" ]
            #            entry[:data][0]['tainted'].should == "Stuff #{@javascript.taint}"
            #            entry[:data][0]['taint'].should == @javascript.taint
            #
            #            trace = entry[:trace][0]
            #            page.body.split("\n")[trace[:line]].should include 'appendData('
            #            trace[:url].should == page.url
            #        end
            #    end
            #
            #    context '.replaceData' do
            #        it 'logs it' do
            #            @javascript.taint = @browser.generate_token
            #            @browser.load "#{@url}/data_trace/CharacterData.replaceData?taint=#{@javascript.taint}"
            #
            #            pages = @browser.flush_page_snapshots_with_sinks
            #
            #            pages.size.should == 1
            #            page = pages.first
            #
            #            page.dom.sink.size.should == 1
            #
            #            entry = page.dom.sink[0]
            #            entry[:data][0]['object'].should == 'CharacterDataPrototype'
            #            entry[:data][0]['function'].should == 'replaceData'
            #            entry[:data][0]['source'].should start_with 'function replaceData'
            #            entry[:data][0]['arguments'].should == [ 0, 0, "Stuff #{@javascript.taint}" ]
            #            entry[:data][0]['tainted'].should == "Stuff #{@javascript.taint}"
            #            entry[:data][0]['taint'].should == @javascript.taint
            #
            #            trace = entry[:trace][0]
            #            page.body.split("\n")[trace[:line]].should include 'replaceData('
            #            trace[:url].should == page.url
            #        end
            #    end
            #end
            #
            #context 'Text' do
            #    context '.replaceWholeText' do
            #        it 'logs it' do
            #            @javascript.taint = @browser.generate_token
            #            @browser.load "#{@url}/data_trace/Text.replaceWholeText?taint=#{@javascript.taint}"
            #
            #            pages = @browser.flush_page_snapshots_with_sinks
            #
            #            pages.size.should == 1
            #            page = pages.first
            #
            #            page.dom.sink.size.should == 1
            #
            #            entry = page.dom.sink[0]
            #            entry[:data][0]['object'].should == 'TextPrototype'
            #            entry[:data][0]['function'].should == 'replaceWholeText'
            #            entry[:data][0]['source'].should start_with 'function replaceWholeText'
            #            entry[:data][0]['arguments'].should == [ "Stuff #{@javascript.taint}" ]
            #            entry[:data][0]['tainted'].should == "Stuff #{@javascript.taint}"
            #            entry[:data][0]['taint'].should == @javascript.taint
            #
            #            trace = entry[:trace][0]
            #            page.body.split("\n")[trace[:line]].should include 'replaceWholeText('
            #            trace[:url].should == page.url
            #        end
            #    end
            #end
            #
            #context 'HTMLDocument' do
            #    context '.write' do
            #        it 'logs it' do
            #            @javascript.taint = @browser.generate_token
            #            @browser.load "#{@url}/data_trace/HTMLDocument.write?taint=#{@javascript.taint}"
            #
            #            pages = @browser.flush_page_snapshots_with_sinks
            #
            #            pages.size.should == 1
            #            page = pages.first
            #
            #            page.dom.sink.size.should == 1
            #
            #            entry = page.dom.sink[0]
            #            entry[:data][0]['object'].should == 'HTMLDocumentPrototype'
            #            entry[:data][0]['function'].should == 'write'
            #            entry[:data][0]['source'].should start_with 'function write'
            #            entry[:data][0]['arguments'].should == [
            #                "Stuff here blah #{@javascript.taint} more stuff nlahblah..."
            #            ]
            #            entry[:data][0]['tainted'].should ==
            #                "Stuff here blah #{@javascript.taint} more stuff nlahblah..."
            #            entry[:data][0]['taint'].should == @javascript.taint
            #
            #            trace = entry[:trace][0]
            #            page.body.split("\n")[trace[:line]].should include 'document.write('
            #            trace[:url].should == page.url
            #        end
            #    end
            #
            #    context '.writeln' do
            #        it 'logs it' do
            #            @javascript.taint = @browser.generate_token
            #            @browser.load "#{@url}/data_trace/HTMLDocument.writeln?taint=#{@javascript.taint}"
            #
            #            pages = @browser.flush_page_snapshots_with_sinks
            #
            #            pages.size.should == 1
            #            page = pages.first
            #
            #            page.dom.sink.size.should == 1
            #
            #            entry = page.dom.sink[0]
            #            entry[:data][0]['object'].should == 'HTMLDocumentPrototype'
            #            entry[:data][0]['function'].should == 'writeln'
            #            entry[:data][0]['source'].should start_with 'function writeln'
            #            entry[:data][0]['arguments'].should == [
            #                "Stuff here blah #{@javascript.taint} more stuff nlahblah..."
            #            ]
            #            entry[:data][0]['tainted'].should ==
            #                "Stuff here blah #{@javascript.taint} more stuff nlahblah..."
            #            entry[:data][0]['taint'].should == @javascript.taint
            #
            #            trace = entry[:trace][0]
            #            page.body.split("\n")[trace[:line]].should include 'document.writeln('
            #            trace[:url].should == page.url
            #        end
            #    end
            #end
        end
    end

    #describe '#timeouts' do
    #    it 'keeps track of setTimeout() timers' do
    #        @browser.load( @url + 'timeout-tracker' )
    #
    #        @javascript.timeouts.should == [
    #            [
    #                "function (name, value) {\n            document.cookie = name + \"=post-\" + value;\n        }",
    #                1000, 'timeout1', 1000
    #            ],
    #            [
    #                "function (name, value) {\n            document.cookie = name + \"=post-\" + value;\n        }",
    #                1500, 'timeout2', 1500
    #            ],
    #            [
    #                "function (name, value) {\n            document.cookie = name + \"=post-\" + value;\n        }",
    #                2000, 'timeout3', 2000
    #            ]
    #        ]
    #
    #        @browser.load_delay.should == 2000
    #        @browser.cookies.size.should == 4
    #        @browser.cookies.map { |c| c.to_s }.sort.should == [
    #            'timeout3=post-2000',
    #            'timeout2=post-1500',
    #            'timeout1=post-1000',
    #            'timeout=pre'
    #        ].sort
    #    end
    #end
    #
    #describe '#intervals' do
    #    it 'keeps track of setInterval() timers' do
    #        @browser.load( @url + 'interval-tracker' )
    #        @browser.javascript.intervals.should == [
    #            [
    #                "function (name, value) {\n            document.cookie = name + \"=post-\" + value;\n        }",
    #                2000, 'timeout1', 2000
    #            ]
    #        ]
    #
    #        sleep 2
    #        @browser.cookies.size.should == 2
    #        @browser.cookies.map { |c| c.to_s }.sort.should == [
    #            'timeout1=post-2000',
    #            'timeout=pre'
    #        ].sort
    #    end
    #end
    #
    #describe '#debugging_data' do
    #    it 'returns debugging information' do
    #        @browser.load "#{@url}/debugging_data?input=_#{@javascript.token}.debug(1)"
    #        @browser.watir.form.submit
    #        debugging_data = @javascript.debugging_data
    #
    #        first_entry = debugging_data.first
    #        debugging_data.should == [first_entry]
    #
    #        first_entry[:data].should == [1]
    #        first_entry[:trace].size.should == 2
    #
    #        first_entry[:trace][0][:function].should == 'onClick'
    #        first_entry[:trace][0][:source].should start_with 'function onClick'
    #        @browser.source.split("\n")[first_entry[:trace][0][:line]].should include 'debug(1)'
    #        first_entry[:trace][0][:arguments].should == %w(some-arg arguments-arg here-arg)
    #
    #        first_entry[:trace][1][:function].should == 'onsubmit'
    #        first_entry[:trace][1][:source].should start_with 'function onsubmit'
    #        @browser.source.split("\n")[first_entry[:trace][1][:line]].should include 'onClick('
    #        first_entry[:trace][1][:arguments].size.should == 1
    #
    #        event = first_entry[:trace][1][:arguments].first
    #
    #        form = "<form id=\"my_form\" onsubmit=\"onClick('some-arg', 'arguments-arg', 'here-arg'); return false;\">\n        </form>"
    #        event['target'].should == form
    #        event['srcElement'].should == form
    #        event['type'].should == 'submit'
    #    end
    #end
    #
    #describe '#sink' do
    #    it 'returns sink data' do
    #        @browser.load "#{@url}/debugging_data?input=#{@javascript.log_sink_stub(1)}"
    #        @browser.watir.form.submit
    #        sink_data = @javascript.sink
    #
    #        first_entry = sink_data.first
    #        sink_data.should == [first_entry]
    #
    #        first_entry[:data].should == [1]
    #        first_entry[:trace].size.should == 2
    #
    #        first_entry[:trace][0][:function].should  == 'onClick'
    #        first_entry[:trace][0][:source].should start_with 'function onClick'
    #        @browser.source.split("\n")[first_entry[:trace][0][:line]].should include 'log_sink(1)'
    #        first_entry[:trace][0][:arguments].should == %w(some-arg arguments-arg here-arg)
    #
    #        first_entry[:trace][1][:function].should == 'onsubmit'
    #        first_entry[:trace][1][:source].should start_with 'function onsubmit'
    #        @browser.source.split("\n")[first_entry[:trace][1][:line]].should include 'onsubmit'
    #        first_entry[:trace][1][:arguments].size.should == 1
    #
    #        event = first_entry[:trace][1][:arguments].first
    #
    #        form = "<form id=\"my_form\" onsubmit=\"onClick('some-arg', 'arguments-arg', 'here-arg'); return false;\">\n        </form>"
    #        event['target'].should == form
    #        event['srcElement'].should == form
    #        event['type'].should == 'submit'
    #    end
    #end
    #
    #describe '#flush_sink' do
    #    it 'returns sink data' do
    #        @browser.load "#{@url}/debugging_data?input=#{@javascript.log_sink_stub(1)}"
    #        @browser.watir.form.submit
    #        sink_data = @javascript.flush_sink
    #
    #        first_entry = sink_data.first
    #        sink_data.should == [first_entry]
    #
    #        first_entry[:data].should == [1]
    #        first_entry[:trace].size.should == 2
    #
    #        first_entry[:trace][0][:function].should == 'onClick'
    #        first_entry[:trace][0][:source].should start_with 'function onClick'
    #        @browser.source.split("\n")[first_entry[:trace][0][:line]].should include 'log_sink(1)'
    #        first_entry[:trace][0][:arguments].should == %w(some-arg arguments-arg here-arg)
    #
    #        first_entry[:trace][1][:function].should == 'onsubmit'
    #        first_entry[:trace][1][:source].should start_with 'function onsubmit'
    #        @browser.source.split("\n")[first_entry[:trace][1][:line]].should include 'onsubmit'
    #        first_entry[:trace][1][:arguments].size.should == 1
    #
    #        event = first_entry[:trace][1][:arguments].first
    #
    #        form = "<form id=\"my_form\" onsubmit=\"onClick('some-arg', 'arguments-arg', 'here-arg'); return false;\">\n        </form>"
    #        event['target'].should == form
    #        event['srcElement'].should == form
    #        event['type'].should == 'submit'
    #    end
    #
    #    it 'empties the sink' do
    #        @browser.load "#{@url}/debugging_data?input=#{@javascript.log_sink_stub}"
    #        @browser.watir.form.submit
    #        @javascript.flush_sink
    #        @javascript.sink.should be_empty
    #    end
    #end
    #
    #describe '#run' do
    #    it 'executes the given script under the browser\'s context' do
    #        @browser.load @url
    #        Nokogiri::HTML(@browser.source).to_s.should ==
    #            Nokogiri::HTML(@javascript.run( 'return document.documentElement.innerHTML' ) ).to_s
    #    end
    #end

end
