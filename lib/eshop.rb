require 'active_support/core_ext/array/grouping'
require 'active_support/core_ext/hash/slice'
require 'httparty'

require_relative 'eshop/countries'
require_relative 'eshop/games'
require_relative 'eshop/prices'

module Eshop
  # Nintendo split countries this way. So yes, africa and oceania are in europe...
  REGIONS = {
    asia: %w[AE AZ CY HK IN JP KR MY SA SG TR TW],
    europe: %w[
      AD AL AT AU BA BE BG BW CH CZ DE DJ DK EE ER ES FI FR GB GG GI GR HR HU IE IM IS IT JE LI LS
      LT LU LV MC ME MK ML MR MT MZ NA NE NL NO NZ PL PT RO RS RU SD SE SI SK SM SO SZ TD VA ZA ZM
      ZW
    ],
    americas: %w[
      AG AI AR AW BB BM BO BR BS BZ CA CL CO CR DM DO EC GD GF GP GT GY HN HT JM KN KY LC MQ MS MX
      NI PA PE PY SR SV TC TT US UY VC VE VG VI
    ],
  }.freeze
end
