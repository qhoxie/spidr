module Spidr
  #
  # The {Events} module adds methods to {Agent} for registering
  # callbacks which will receive URLs, links, headers and pages, when
  # they are visited.
  #
  module Events
    def initialize(options={})
      super(options)

      @every_url_blocks = []
      @every_failed_url_blocks = []
      @urls_like_blocks = Hash.new { |hash,key| hash[key] = [] }

      @every_page_blocks = []
      @every_link_blocks = []
    end

    #
    # Pass each URL from each page visited to the given block.
    #
    # @yield [url]
    #   The block will be passed every URL from every page visited.
    #
    # @yieldparam [URI::HTTP] url
    #   Each URL from each page visited.
    #
    def every_url(&block)
      @every_url_blocks << block
      return self
    end

    #
    # Pass each URL that could not be requested to the given block.
    #
    # @yield [url]
    #   The block will be passed every URL that could not be requested.
    #
    # @yieldparam [URI::HTTP] url
    #   A failed URL.
    #
    def every_failed_url(&block)
      @every_failed_url_blocks << block
      return self
    end

    #
    # Pass every URL that the agent visits, and matches a given pattern,
    # to a given block.
    #
    # @param [Regexp, String] pattern
    #   The pattern to match URLs with.
    #
    # @yield [url]
    #   The block will be passed every URL that matches the given pattern.
    #
    # @yieldparam [URI::HTTP] url
    #   A matching URL.
    #
    def urls_like(pattern,&block)
      @urls_like_blocks[pattern] << block
      return self
    end

    #
    # Pass the headers from every response the agent receives to a given
    # block.
    #
    # @yield [headers]
    #   The block will be passed the headers of every response.
    #
    # @yieldparam [Hash] headers
    #   The headers from a response.
    #
    def all_headers(&block)
      every_page { |page| block.call(page.headers) }
    end

    #
    # Pass every page that the agent visits to a given block.
    #
    # @yield [page]
    #   The block will be passed every page visited.
    #
    # @yieldparam [Page] page
    #   A visited page.
    #
    def every_page(&block)
      @every_page_blocks << block
      return self
    end

    #
    # Pass every OK page that the agent visits to a given block.
    #
    # @yield [page]
    #   The block will be passed every OK page visited.
    #
    # @yieldparam [Page] page
    #   A visited page.
    #
    def every_ok_page(&block)
      every_page do |page|
        block.call(page) if (block && page.ok?)
      end
    end

    #
    # Pass every Redirect page that the agent visits to a given block.
    #
    # @yield [page]
    #   The block will be passed every Redirect page visited.
    #
    # @yieldparam [Page] page
    #   A visited page.
    #
    def every_redirect_page(&block)
      every_page do |page|
        block.call(page) if (block && page.redirect?)
      end
    end

    #
    # Pass every Timeout page that the agent visits to a given block.
    #
    # @yield [page]
    #   The block will be passed every Timeout page visited.
    #
    # @yieldparam [Page] page
    #   A visited page.
    #
    def every_timedout_page(&block)
      every_page do |page|
        block.call(page) if (block && page.timedout?)
      end
    end

    #
    # Pass every Bad Request page that the agent visits to a given block.
    #
    # @yield [page]
    #   The block will be passed every Bad Request page visited.
    #
    # @yieldparam [Page] page
    #   A visited page.
    #
    def every_bad_request_page(&block)
      every_page do |page|
        block.call(page) if (block && page.bad_request?)
      end
    end

    #
    # Pass every Unauthorized page that the agent visits to a given block.
    #
    # @yield [page]
    #   The block will be passed every Unauthorized page visited.
    #
    # @yieldparam [Page] page
    #   A visited page.
    #
    def every_unauthorized_page(&block)
      every_page do |page|
        block.call(page) if (block && page.unauthorized?)
      end
    end

    #
    # Pass every Forbidden page that the agent visits to a given block.
    #
    # @yield [page]
    #   The block will be passed every Forbidden page visited.
    #
    # @yieldparam [Page] page
    #   A visited page.
    #
    def every_forbidden_page(&block)
      every_page do |page|
        block.call(page) if (block && page.forbidden?)
      end
    end

    #
    # Pass every Missing page that the agent visits to a given block.
    #
    # @yield [page]
    #   The block will be passed every Missing page visited.
    #
    # @yieldparam [Page] page
    #   A visited page.
    #
    def every_missing_page(&block)
      every_page do |page|
        block.call(page) if (block && page.missing?)
      end
    end

    #
    # Pass every Internal Server Error page that the agent visits to a
    # given block.
    #
    # @yield [page]
    #   The block will be passed every Internal Server Error page visited.
    #
    # @yieldparam [Page] page
    #   A visited page.
    #
    def every_internal_server_error_page(&block)
      every_page do |page|
        block.call(page) if (block && page.had_internal_server_error?)
      end
    end

    #
    # Pass every Plain Text page that the agent visits to a given block.
    #
    # @yield [page]
    #   The block will be passed every Plain Text page visited.
    #
    # @yieldparam [Page] page
    #   A visited page.
    #
    def every_txt_page(&block)
      every_page do |page|
        block.call(page) if (block && page.txt?)
      end
    end

    #
    # Pass every HTML page that the agent visits to a given block.
    #
    # @yield [page]
    #   The block will be passed every HTML page visited.
    #
    # @yieldparam [Page] page
    #   A visited page.
    #
    def every_html_page(&block)
      every_page do |page|
        block.call(page) if (block && page.html?)
      end
    end

    #
    # Pass every XML page that the agent visits to a given block.
    #
    # @yield [page]
    #   The block will be passed every XML page visited.
    #
    # @yieldparam [Page] page
    #   A visited page.
    #
    def every_xml_page(&block)
      every_page do |page|
        block.call(page) if (block && page.xml?)
      end
    end

    #
    # Pass every XML Stylesheet (XSL) page that the agent visits to a
    # given block.
    #
    # @yield [page]
    #   The block will be passed every XML Stylesheet (XSL) page visited.
    #
    # @yieldparam [Page] page
    #   A visited page.
    #
    def every_xsl_page(&block)
      every_page do |page|
        block.call(page) if (block && page.xsl?)
      end
    end

    #
    # Pass every HTML or XML document that the agent parses to a given
    # block.
    #
    # @yield [doc]
    #   The block will be passed every HTML or XML document parsed.
    #
    # @yieldparam [Nokogiri::HTML::Document, Nokogiri::XML::Document] doc
    #   A parsed HTML or XML document.
    #
    # @see http://nokogiri.rubyforge.org/nokogiri/Nokogiri/XML/Document.html
    # @see http://nokogiri.rubyforge.org/nokogiri/Nokogiri/HTML/Document.html
    #
    def every_doc(&block)
      every_page do |page|
        if block
          if (doc = page.doc)
            block.call(doc)
          end
        end
      end
    end

    #
    # Pass every HTML document that the agent parses to a given block.
    #
    # @yield [doc]
    #   The block will be passed every HTML document parsed.
    #
    # @yieldparam [Nokogiri::HTML::Document] doc
    #   A parsed HTML document.
    #
    # @see http://nokogiri.rubyforge.org/nokogiri/Nokogiri/HTML/Document.html
    #
    def every_html_doc(&block)
      every_page do |page|
        if (block && page.html?)
          if (doc = page.doc)
            block.call(doc)
          end
        end
      end
    end

    #
    # Pass every XML document that the agent parses to a given block.
    #
    # @yield [doc]
    #   The block will be passed every XML document parsed.
    #
    # @yieldparam [Nokogiri::XML::Document] doc
    #   A parsed XML document.
    #
    # @see http://nokogiri.rubyforge.org/nokogiri/Nokogiri/XML/Document.html
    #
    def every_xml_doc(&block)
      every_page do |page|
        if (block && page.xml?)
          if (doc = page.doc)
            block.call(doc)
          end
        end
      end
    end

    #
    # Pass every XML Stylesheet (XSL) that the agent parses to a given
    # block.
    #
    # @yield [doc]
    #   The block will be passed every XSL Stylesheet (XSL) parsed.
    #
    # @yieldparam [Nokogiri::XML::Document] doc
    #   A parsed XML document.
    #
    # @see http://nokogiri.rubyforge.org/nokogiri/Nokogiri/XML/Document.html
    #
    def every_xsl_doc(&block)
      every_page do |page|
        if (block && page.xsl?)
          if (doc = page.doc)
            block.call(doc)
          end
        end
      end
    end

    #
    # Pass every RSS document that the agent parses to a given block.
    #
    # @yield [doc]
    #   The block will be passed every RSS document parsed.
    #
    # @yieldparam [Nokogiri::XML::Document] doc
    #   A parsed XML document.
    #
    # @see http://nokogiri.rubyforge.org/nokogiri/Nokogiri/XML/Document.html
    #
    def every_rss_doc(&block)
      every_page do |page|
        if (block && page.rss?)
          if (doc = page.doc)
            block.call(doc)
          end
        end
      end
    end

    #
    # Pass every Atom document that the agent parses to a given block.
    #
    # @yield [doc]
    #   The block will be passed every Atom document parsed.
    #
    # @yieldparam [Nokogiri::XML::Document] doc
    #   A parsed XML document.
    #
    # @see http://nokogiri.rubyforge.org/nokogiri/Nokogiri/XML/Document.html
    #
    def every_atom_doc(&block)
      every_page do |page|
        if (block && page.atom?)
          if (doc = page.doc)
            block.call(doc)
          end
        end
      end
    end

    #
    # Pass every JavaScript page that the agent visits to a given block.
    #
    # @yield [page]
    #   The block will be passed every JavaScript page visited.
    #
    # @yieldparam [Page] page
    #   A visited page.
    #
    def every_javascript_page(&block)
      every_page do |page|
        block.call(page) if (block && page.javascript?)
      end
    end

    #
    # Pass every CSS page that the agent visits to a given block.
    #
    # @yield [page]
    #   The block will be passed every CSS page visited.
    #
    # @yieldparam [Page] page
    #   A visited page.
    #
    def every_css_page(&block)
      every_page do |page|
        block.call(page) if (block && page.css?)
      end
    end

    #
    # Pass every RSS feed that the agent visits to a given block.
    #
    # @yield [feed]
    #   The block will be passed every RSS feed visited.
    #
    # @yieldparam [Page] feed
    #   A visited page.
    #
    def every_rss_page(&block)
      every_page do |page|
        block.call(page) if (block && page.rss?)
      end
    end

    #
    # Pass every Atom feed that the agent visits to a given block.
    #
    # @yield [feed]
    #   The block will be passed every Atom feed visited.
    #
    # @yieldparam [Page] feed
    #   A visited page.
    #
    def every_atom_page(&block)
      every_page do |page|
        block.call(page) if (block && page.atom?)
      end
    end

    #
    # Pass every MS Word page that the agent visits to a given block.
    #
    # @yield [page]
    #   The block will be passed every MS Word page visited.
    #
    # @yieldparam [Page] page
    #   A visited page.
    #
    def every_ms_word_page(&block)
      every_page do |page|
        block.call(page) if (block && page.ms_word?)
      end
    end

    #
    # Pass every PDF page that the agent visits to a given block.
    #
    # @yield [page]
    #   The block will be passed every PDF page visited.
    #
    # @yieldparam [Page] page
    #   A visited page.
    #
    def every_pdf_page(&block)
      every_page do |page|
        block.call(page) if (block && page.pdf?)
      end
    end

    #
    # Pass every ZIP page that the agent visits to a given block.
    #
    # @yield [page]
    #   The block will be passed every ZIP page visited.
    #
    # @yieldparam [Page] page
    #   A visited page.
    #
    def every_zip_page(&block)
      every_page do |page|
        block.call(page) if (block && page.zip?)
      end
    end

    #
    # Passes every origin and destination URI of each link to a given
    # block.
    #
    # @yield [origin,dest]
    #   The block will be passed every origin and destination URI of
    #   each link.
    #
    # @yieldparam [URI::HTTP] origin
    #   The URI that a link originated from.
    #
    # @yieldparam [URI::HTTP] dest
    #   The destination URI of a link.
    #
    def every_link(&block)
      @every_link_blocks << block
      return self
    end
  end
end
