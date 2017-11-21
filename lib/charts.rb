class Charts
  attr_accessor :coords, :kind

  def initialize(**options)
    @coords = options[:coords]
    @kind = options[:kind]
  end

  def build
    [{ name: kind.class.to_s.demodulize, data: coords },
     { name: "#{kind.class.to_s.demodulize} approx coordinates", data: run_process}]#, { name: 'point', data: { y => 25 } }]
  end

  private

  def run_process
    kind.process.approx_y
  end
end