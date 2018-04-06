# Cucumber to Rspec converter

Inspired by [transpec](https://github.com/yujinakayama/transpec), this tool lets you convert your cucumber tests into plain Ruby/RSpec tests that use Capybara directly.

Perhaps you've had enough of Cucumber and just want to write all your tests the same way (including
end-to-end/feature/browser/acceptance tests) and be able to use the same testing framework to run
*all* of your tests.

[turnip](https://github.com/jnicklas/turnip) also gives you that, but in a different way. If you
just want to write your tests using plain Ruby and don't want to bother writing tests in Gherkin
with step definitios to translate from Gherkin to Ruby, then you should convert any existing
Cucumber tests to RSpec and just use RSpec!

## Status

This tool is beta software, and is not feature complete.

For now, this tool it just includes a formatter that emits RSpec code as its output.

Eventually, it would be nice to actually automatically save that output in the right file
(`features/thing.feature` -> `spec/feature/thing_spec.rb`).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cucumber_to_rspec'
```

## Usage

```
cucumber features/thing.feature:33:53 --format CucumberToRspec::Formatter --out spec/features/thing_spec.rb
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/TylerRick/cucumber_to_rspec.

## See also:

- [transpec](https://github.com/yujinakayama/transpec) — Convert your RSpec tests from older RSpec syntax to newer or different RSpec syntax variants
- [turnip](https://github.com/jnicklas/turnip) —  It allows you to write tests in Gherkin and run them through your RSpec environment. Basically you can write cucumber features in RSpec.
