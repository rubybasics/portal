module PortalSpecHelpers
  def today_is(date)
    date = Date.parse date unless Date.kind_of? Date
    allow(Date).to receive_messages today: date, current: date
  end
end

RSpec.configure do |config|
  config.include PortalSpecHelpers, type: :feature

  config.order = :random

  Kernel.srand config.seed

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect

    mocks.verify_partial_doubles = true
  end
end
