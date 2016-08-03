Puppet::Parser::Functions::newfunction(:ip2target, :type => :rvalue) do |args|
  ips = args[0]
  port = args[1]
  result = Array.new([])
  ips.each do |val|
    result.push("#{val}:#{port}")
    #(result ||= []).push("#{val}:#{port}")
  end
  return result
end
