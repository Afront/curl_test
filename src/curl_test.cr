# TODO: Write documentation for `CurlTest`
module CurlTest
  VERSION  = "0.1.0"
  DATA     = "1" * 1000
  DATA_URL = "#{DATA}&other_data=#{DATA}&another_data=#{DATA}&data1=#{DATA}&data0=#{DATA}&data2=#{DATA}&data3=#{DATA}"

  def self.get_usage
    "Usage: curl_test host count size port"
  end

  # TODO: Put your code here

  # abort get_usage unless ARGV.size == 4

  # puts ARGV
  # host, count, size, port = ARGV

  def self.run_curl(name : String, url : String, mode = name)
    100.times do |i|
      spawn do
        command = %Q{ curl --data "#{DATA_URL}" --#{mode.strip} #{url.strip}/post -w "%{time_connect},%{time_total},%{speed_download},%{http_code},%{size_download}\n" -o /dev/null -s >> #{name.strip}.csv | bash}
        args = ["-c"]

        Process.run("sh", args << command)

        sleep 0.1.seconds
      end
    end

    Fiber.yield
    sleep 0.1.seconds
  end

  run_curl("http3", "https://quic.aiortc.org/httpbin")
  run_curl("http2-prior-knowledge-aiortc", "https://quic.aiortc.org/httpbin", "http2-prior-knowledge")
  run_curl("http2-aiortc", "https://quic.aiortc.org/httpbin", "http2")
  run_curl("http1.1-aiortc", "https://quic.aiortc.org/httpbin", "http1.1")
  run_curl("http1.0-aiortc", "https://quic.aiortc.org/httpbin", "http1.0")
  run_curl("http0.9-aiortc", "https://quic.aiortc.org/httpbin", "http0.9")

  run_curl("http2-prior-knowledge", "https://httpbin.org")
  run_curl("http2", "https://httpbin.org")
  run_curl("http1.1", "https://httpbin.org")
  run_curl("http1.0", "https://httpbin.org")
  run_curl("http0.9", "https://httpbin.org")
end
