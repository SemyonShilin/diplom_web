module Decision::Common
  class << self
    def calculate(coeff, y)
      array_for_d.map do |x|
        [x, formule(x, coeff)]
      end.bsearch { |x| x[1] >= y }[0]
    end

    private

    def array_for_d
      temp = []
      0.step(by: 0.001, to: 100) { |elem| temp << elem }
      temp
    end
  end
end