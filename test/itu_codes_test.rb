require 'test_helper'

lambda do
  # test calling code is valid
  american  =    "1"
  newyorker = "1212"
  canadian  = "1250"
  samoan    = "1684"
  russian   =    "7"
  alien     = "alksjlkknm"

  assert ItuCodes.valid_code?(american), :== => true
  assert ItuCodes.valid_code?(russian), :== => true

  assert ItuCodes.valid_code?(newyorker), :!= => true     # 1212 is not a country code!
  assert ItuCodes.valid_code?(canadian), :!= => true
  assert ItuCodes.valid_code?(samoan), :!= => true
  assert ItuCodes.valid_code?(alien), :!= => true
end.call

lambda do
  # test parse full number into correct calling codes
  american  =    "1"
  newyorker = "1212"
  russian   =    "7"
  italian   =   "39"
  alien     = "alksjlkknm"

  assert american,
    :== => ItuCodes.parse_code(american),
    :== => ItuCodes.parse_code(newyorker)

  assert russian,
    :!= => ItuCodes.parse_code(newyorker),
    :!= => ItuCodes.parse_code(alien)

  assert italian,
    :== => ItuCodes.parse_code(italian)

  assert alien, :!= => ItuCodes.parse_code(alien)

  assert nil, :== => ItuCodes.parse_code(alien)
end.call

lambda do
  # test compatriot phone numbers should be detected
  american  =    "1"
  newyorker = "1212"
  anguilan  = "1264"
  angeleno  = "1818"
  russian   =    "7"
  alien     = "alksjlkknm"

  assert ItuCodes.compatriots?(newyorker, angeleno), :== => true
  assert ItuCodes.compatriots?(newyorker, american), :== => true

  assert ItuCodes.compatriots?(newyorker, russian), :!= => true
  assert ItuCodes.compatriots?(american, russian), :!= => true
  assert ItuCodes.compatriots?(newyorker, anguilan), :!= => true

  assert ItuCodes.compatriots?(american, alien), :!= => true
  assert ItuCodes.compatriots?(alien, alien), :!= => true

  assert ItuCodes.compatriots?('822', '811'), :!= => true
  assert ItuCodes.compatriots?('1984', '1985'), :== => true
end.call

lambda do
  # test should deal gracefully with North America
  assert ItuCodes.find_by_itu_code('1684'), :== => "American Samoa"
  assert ItuCodes.find_by_itu_code('1250'), :== => "Canada"
  assert ItuCodes.find_by_itu_code('1818'), :== => "United States of America"

  assert ItuCodes.find_by_itu_code('1'), :include? => "United States of America"
  assert ItuCodes.find_by_itu_code('1'), :include? => "Canada"
  assert ItuCodes.find_by_itu_code('1'), :include? => "American Samoa"
end.call

lambda do
  # test should detect american numbers
  american  = "1"
  newyorker = "1212"
  n2        = "121232"
  canadian  = "1250"
  samoan    = "1684"
  russian   = "7"

  assert ItuCodes,
    :american? => american,
    :american? => newyorker,
    :american? => n2

  assert ItuCodes.american?(canadian), :!= => true
  assert ItuCodes.american?(samoan), :!= => true
  assert ItuCodes.american?(russian), :!= => true
end.call

lambda do
  # test should convert from ISO 3166 code to ITU code
  assert ItuCodes.iso2itu('US'), :== => '1'
  assert ItuCodes.iso2itu('CA'), :== => '1'
  assert ItuCodes.iso2itu('not_an_iso_code'), :== => nil
  assert ItuCodes.iso2itu('MX'), :== => '52'
end.call

lambda do
  # data should be up to date
  assert ItuCodes.find_by_itu_code('382'), :== => 'Montenegro (Republic of)'
  assert ItuCodes.iso2itu('ME'), :== => '382'
end.call

lambda do
  north_american_iso_codes = %w(
    AS AI AG BS BB BM VG CA KY DM DO GD GU JM MS MP PR KN LC VC SX TT TC US VI
  )

  # convert from ITU code to ISO 3166-1 alpha-2 code
  assert ItuCodes.itu2iso('1'), :== => north_american_iso_codes
  assert ItuCodes.itu2iso('280'), :== => nil
  assert ItuCodes.itu2iso('52'), :== => 'MX'
  assert ItuCodes.itu2iso('7'), :== => ['KZ', 'RU']
end.call