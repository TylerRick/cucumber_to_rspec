require 'cucumber/formatter/pretty'
require 'method_source'
require 'cucumber_to_rspec/core_ext/string'
using StringIndent

module Cucumber
  class StepMatch

    def source
      loc = [location.file, location.line]
      MethodSource.source_helper(loc)
    end

    def to_rspec
      var_assign_from_args(source) + "\n" +
      source.lines[1..-2].join().indent(-2)
    end

    # Prints `local = value` for each arg in the step def
    def var_assign_from_args(source)
      matches = source.match(/do \|(.*)\|/)
      return '' unless matches
      matches[1].scan(/\w+/).map.with_index { |var_name, i|
        arg = step_arguments[i]
        # TODO: Handle tables
        type = arg.instance_variable_get(:@parameter_type).type rescue (STDOUT.p $!; nil)
        value = args[i]
        value =
          case type
          when 'int', 'float'
            value
          else
            value.inspect
          end
        "#{var_name} = #{value}"
      }.join("\n")
    end
  end
end

module CucumberToRspec
  class Formatter < ::Cucumber::Formatter::Pretty

      # Override Cucumber::Formatter::Console

      def format_step(keyword, step_match, status, source_indent)
        lines = []

        comment = if source_indent
                    "# #{step_match.location}".indent(source_indent)
                  else
                    ''
                  end


        lines << "# #{keyword} #{step_match.format_args} #{comment}"

        if step_match.respond_to?(:to_rspec)
          lines << step_match.to_rspec
        end

        lines.join("\n")
      end

      # Override/extend Cucumber::Formatter::Pretty

      def before_features(_features)
        #print_profile_information

        # TODO: Make this configurable
        @io.puts "require 'rails_helper'"
        @io.puts
      end

      def after_features(features)
        #print_summary(features)
        @io.puts "end".indent(0)
      end

      #def before_feature(_feature)

      #def comment_line(comment_line)

      #def after_tags(_tags)

      #def tag_name(tag_name)

      def feature_name(keyword, name)
        @io.puts("describe \"#{keyword}: #{name}\" do")
        @io.puts
        @io.flush
      end

      def before_feature_element(_feature_element)
        super
      end

      def after_background(_background)
        line = "end".indent(@scenario_indent)
        @io.puts(line)
        super
      end

      #def background_name(keyword, name, file_colon_line, source_indent)

      #def before_examples_array(_examples_array)

      #def examples_name(keyword, name)

      #def before_outline_table(outline_table)

      #def after_outline_table(_outline_table)

      def scenario_name(keyword, name, file_colon_line, source_indent)
        print_feature_element_name(keyword, name, file_colon_line, source_indent)
        @scenario_indent += 2
        @io.puts "it do".indent(@scenario_indent)
      end

      def after_feature_element(_feature_element)
        @io.puts "end".indent(@scenario_indent)  # it do
        @scenario_indent -= 2
        @io.puts "end  # #{_feature_element.name}".indent(@scenario_indent)
        super
      end


      #def before_step(step)

      #def before_step_result(_keyword, _step_match, _multiline_arg, status, exception, _source_indent, background, _file_colon_line)

      #def step_name(keyword, step_match, status, source_indent, _background, _file_colon_line)

      #def doc_string(string)

      #def before_multiline_arg(multiline_arg)

      #def after_multiline_arg(_multiline_arg)

      #def before_table_row(_table_row)

      #def after_table_row(table_row)

      #def after_table_cell(_cell)

      #def table_cell_value(value, status)

      def after_test_step(test_step, result)
        #@io.puts "#{test_step.to_s}   #{test_step.location.to_s}"
        collect_snippet_data(test_step, result)
      end

    private

      def print_feature_element_name(keyword, name, file_colon_line, source_indent)
        @io.puts if @scenario_indent == 6
        names = name.empty? ? [name] : name.split("\n")

        if @options[:source]
          line_comment = "# #{file_colon_line}".indent(@scenario_indent)
          @io.puts line_comment
        end

        ruby_keyword =
          if keyword == 'Background'
            'before'
          else
            'describe'
          end
        line = "#{ruby_keyword} \"#{keyword}: #{names[0]}\" do".indent(@scenario_indent)
        @io.puts(line)

        # What is this for? Scenario outlines?
        #names[1..-1].each {|s| @io.puts s.to_s}

        @io.flush
      end

  end
end

