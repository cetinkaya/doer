# Ahmet Cetinkaya, 2024

require "glimmer-dsl-libui"
require_relative 'doer'

class Calculator
  include Glimmer
  attr_accessor :left_text, :right_text
  def initialize
    @doer = Doer.new(1, 0.1)
    window {
      horizontal_box {
        multiline_entry {
          text <=> [self, :left_text]
          on_changed do
            @doer.task do
              Glimmer::LibUI.queue_main do
                self.right_text = @left_text.split("\n").map do |line|
                  result = ""
                  begin
                    result = eval(line).to_s
                  rescue Exception
                  end
                  result
                end.join("\n")
              end
            end
          end
        }
        vertical_separator {
          stretchy false
        }
        multiline_entry {
          text <=> [self, :right_text]
        }
      }
    }.show
  end
end

Calculator.new
