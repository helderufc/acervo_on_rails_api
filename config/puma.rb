require "etc"

threads_count = ENV.fetch("RAILS_MAX_THREADS", 8)
threads threads_count, threads_count

port ENV.fetch("PORT", 3000)

# auto = um worker por núcleo físico disponível
workers ENV.fetch("WEB_CONCURRENCY", Etc.nprocessors)

# Carrega a app no processo master antes de forkar — workers herdam via CoW
preload_app!

# Reconecta o banco em cada worker após o fork
on_worker_boot do
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end

# Roda GC antes de forkar para reduzir fragmentação de memória nos workers
nakayoshi_fork if respond_to?(:nakayoshi_fork)

# Direciona novas requisições para o worker com menos threads ocupadas
wait_for_less_busy_worker if respond_to?(:wait_for_less_busy_worker)

plugin :tmp_restart
plugin :solid_queue if ENV["SOLID_QUEUE_IN_PUMA"]
pidfile ENV["PIDFILE"] if ENV["PIDFILE"]
