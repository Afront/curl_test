# TODO: Write documentation for `CurlTest`
module CurlTest
  VERSION = "0.1.0"

  def self.get_usage
    "Usage: curl_test host count size port"
  end

  # TODO: Put your code here

  abort get_usage unless ARGV.size == 4

  puts ARGV
  host, count, size, port = ARGV
  i = count.to_i - 1
  while i > 0
    spawn do
      command = %Q{ curl http://#{host}:#{port}/#{size}_test.html -w "%{time_connect},%{time_total},%{speed_download},%{http_code},%{size_download},%{url_effective}\n" -o /dev/null -s >> myResults.csv | bash}
      args = ["-c"]
      args << command

      Process.run("sh", args)

      sleep 0.1.seconds
    end
    i -= 1
  end

  Fiber.yield
  sleep 10.seconds
end
