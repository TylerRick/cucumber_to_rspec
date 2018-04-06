# frozen_string_literal: true

# Copied from cucumber-3.1.0/lib/cucumber/core_ext/string.rb
# Can't rely on that version of indent being the one available however, because if activesupport is loaded, it will overwrite that version with its own, which will raise an error if passed a negative argument:
#   negative argument (ArgumentError)
#   gems/activesupport-4.2.10/lib/active_support/core_ext/string/indent.rb:8:in `*'
# Refinements allow us to control *which* monkey patch is the one used by a particular
# file/module/etc.

module StringIndent
  refine String do
    def indent(n)
      if n >= 0
        gsub(/^/, ' ' * n)
      else
        gsub(/^ {0,#{-n}}/, '')
      end
    end
  end
end
