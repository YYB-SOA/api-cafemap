web: bundle exec puma -t 5:5 -p ${PORT:-3000} -e ${RACK_ENV:-development}
worker: bundle exec shoryuken -r ./workers/cluster_worker.rb -C ./workers/shoryuken.yml
worker: python app/domain/clustering/algo/k_means.py