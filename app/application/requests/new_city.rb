# frozen_string_literal: true

require 'dry-validation'

module CafeMap
  module Forms
    class NewCity < Dry::Validation::Contract
      good_city_ch = %w[台北 新北 基隆 宜蘭 新竹 桃園
                        苗栗 彰化 南投 雲林 台中 嘉義 台南 高雄
                        屏東 雲林 花蓮 台東 金門 馬祖]
      good_city_en = ['Hualien', 'Taipei', 'New Taipei', 'Keelung', 'Yilan', 'Hsinchu', 'Taoyuan', 'Taichung',
                      'Miaoli', 'Changhua', 'Nantou', 'Yunlin', 'Chiayi', 'Tainan', 'Kaohsiung', 'Pingtung',
                      'Penghu', 'Yunlin', 'Hualien', 'Taitung', 'Kinmen', 'Matsu']
      params do
        required(:city_name).filled(:string)
      end
      rule(:city_name) do
        unless good_city_ch.include?(value) | good_city_en.include?(value) | good_city_en.map(&:downcase).include?(value)
          key.failure('is an invalid city for CafeMap')
        end
      end
    end
  end
end