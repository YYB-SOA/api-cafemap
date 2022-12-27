# frozen_string_literal: true

# require_relative '../domain/clustering/runner/k_means_main'
require 'dry/transaction'
require 'json'

module CafeMap
  module Service
    # Transaction to store cafe data from CafeNomad API to database
    class Clustering
      include Dry::Transaction

      step :validate_city
      step :get_info_from_db
      step :call_kmeans_main
      step :read_cluster_output
      DB_ERR = 'There is something in database.'

      def validate_city(input)
        city_request = input[:city_request].call
        if city_request.success?
          Success(input.merge(city: city_request.value!))
        else
          Failure(city_request.failure)
        end
      end

      def get_info_from_db(input)
        if (db_hash = get_db(input))
          Success(input.merge(db_hash: db_hash))
        end
      rescue StandardError
        Failure("Something wrong in DB")
      end

      def call_kmeans_main(input)
        puts "13"
        db_hash = input[:db_hash]
        df_info = df_transformer(db_hash['info_db'], 'info')
        df_store = df_transformer(db_hash['store_db'], 'store')
        df = df_info.inner_join(df_store, on: { id: :info_id })
        k_means_runner(city, df)
      end

      def read_cluster_output(citi)
        sleep 3
        rawcluster_output = File.read(f("app/domain/clustering/temp/#{citi}_clustering_out.json"))
      end

      def get_db(input)
        infos_data = CafeMap::CafeNomad::InfoMapper.new(App.config.CAFE_TOKEN).load_several
        city = infos_data.select { |filter| filter.address.include? input[:city] }.shuffle[0].city
        puts city
        info_from_db = CafeMap::Database::InfoOrm.where(city: city)
        store_from_db = CafeMap::Database::InfoOrm.where(city: city).map { |x| x.store[0] }
        { 'info_db' => info_from_db, 'store_db' => store_from_db }
      rescue StandardError => e
        raise "Could not find that city on CafeNomad #{e}"
      end
    end
  end
end
