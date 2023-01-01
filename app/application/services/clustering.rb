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
          Success(input.merge(db_hash:))
        end
      rescue StandardError
        Failure('Something wrong in DB')
      end

      def call_kmeans_main(input)
        db_hash = input[:db_hash]
        df_info = df_transformer(db_hash['info_db'], 'info')
        df_store = df_transformer(db_hash['store_db'], 'store')
        df = df_info.inner_join(df_store, on: { id: :info_id })
        k_means_runner(@citi, df)
        Success(input.merge(citi: @citi))
      rescue StandardError
        Failure('Something wrong in k_means_runner')
      end

      def read_cluster_output(input)
        sleep 1
        fh = JSON.parse(File.read(("app/domain/clustering/temp/#{input[:citi]}_clustering_out.json")))
        delete_clustering_files("app/domain/clustering/temp")
        fh_result = json_to_hash_array(fh)
        cluster_result = CafeMap::Cluster::ClusterMapper.new(fh_result).load_several
        CafeMap::Response::ClusterList.new(cluster_result)
          .then { |list| Response::ApiResult.new(status: :ok, message: list) }
          .then { |result| Success(result) }
      rescue StandardError
        Failure(Response::ApiResult.new(status: :internal_error, message: DB_ERR))
      end

      def get_db(input)
        infos_data = CafeMap::CafeNomad::InfoMapper.new(App.config.CAFE_TOKEN).load_several
        @citi = infos_data.select { |filter| filter.address.include? input[:city] }.sample.city
        info_from_db = CafeMap::Database::InfoOrm.where(city: @citi).all
        store_from_db = CafeMap::Database::InfoOrm.where(city: @citi).map { |x| x.store[0] }
        { 'info_db' => info_from_db, 'store_db' => store_from_db }
      rescue StandardError => e
        raise "Could not find that city on CafeNomad #{e}"
      end

      def json_to_hash_array(fh)
        return_array = []
        fh.each do |key1, _value1|
          if key1 == 'id'
            fh[key1].each do |_key2, value2|
              temp = {}
              temp[key1] = value2
              return_array.append(temp)
            end
          else
            return_array.each_with_index do |element, index|
              element[key1] = fh[key1][index.to_s]
            end
          end
        end
        return_array
      end

      def delete_clustering_files(folder, deleted_names = ["clustering_out.json", "clustering_input.txt"])
        deleted_names.each do |name|
          file_pattern = /.*#{name}/
          file_paths = Dir.glob(File.join(folder, "*"))
          file_paths.select! { |file_path| file_path.match?(file_pattern) }
          file_paths.each { |file_path| File.delete(file_path) }
        end
      end
    end
  end
end
