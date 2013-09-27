# -*- encoding: utf-8 -*-

require 'erb'

module Coco
  
  # I format the index.html
  # @todo document
  class HtmlIndexFormatter < Formatter
    
    def initialize raw_coverages, uncovered
      super(raw_coverages, uncovered)
      @context = nil
      @template = Template.open File.join($COCO_PATH,'template/index.erb')
      @lines = []
      build_lines_for_context
      build_stats_for_context
    end
    
    def format
      @context = IndexContext.new Helpers.index_title, @lines, @uncovered
      @template.result(@context.get_binding)
    end
    
    private
    
    def build_lines_for_context
      @raw_coverages.each do |filename, coverage| 
        filename = File.expand_path(filename)
        percentage = CoverageStat.coverage_percent(coverage)
        @lines << [percentage, filename, Helpers.rb2html(filename)]
      end
      @lines.sort!
    end

    def build_stats_for_context
      @total_files = @uncovered.count + @lines.count  
      @total_coverage = @lines.inject(0) {|total, line| total + line.first }
      @average_coverage = @total_files > 0 ? @total_coverage / @total_files : 0
    end
  end

end
