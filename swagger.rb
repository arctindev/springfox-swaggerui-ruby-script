#!/usr/bin/ruby

api_url = ARGV[0]
port = ARGV[1] || "4444"

def kill_script(missing_arg)
  puts "========================================================================\n"
  puts "\nError: #{missing_arg} is missing, run script with following format... \n\n"
  puts "ruby swagger.rb $(api_url)"
  puts "\n========================================================================\n"
  exit(1)
end

def exec_script(api_url, port)
  kill_running_docker_container = "docker rm -f $(docker container ls | grep  'swaggerapi/swagger-ui' | awk '{ print $1 }')"
  fetch_data_from_api = "curl #{api_url}/v3/api-docs > swagger/swagger.json "
  run_docker_image = "docker run -d -p #{port}:8080 -e SWAGGER_JSON=/mnt/swagger.json -v $(pwd)/swagger:/mnt swaggerapi/swagger-ui"

  container_not_found_log = "echo Container not found..."
  server_listen_log = "echo Open swagger docs on url: http://localhost:#{port}"

  exec("#{kill_running_docker_container} || #{container_not_found_log} && #{fetch_data_from_api} && #{run_docker_image} && #{server_listen_log}")
end

kill_script("api_url") unless api_url

exec_script(api_url, port)
