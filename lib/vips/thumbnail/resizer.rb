# Copyright, 2017, by Samuel G. D. Williams. <http://www.codeotaku.com>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

require 'vips'

module Vips
	module Thumbnail
		class Resizer
			def initialize(input_path, **options)
				@input_path = input_path
				@options = options
				@input_image = nil
			end
			
			attr :input_path
			attr :options
			
			def flush!
				@input_image = nil
			end
			
			def input_image
				unless @input_image
					image = Vips::Image.new_from_file(@input_path, **@options)
					@input_image = image.autorot
				end
				
				return @input_image
			end
			
			def input_aspect_ratio
				Rational(input_image.width, input_image.height)
			end
			
			# Resize the image to completely fill the desired size, if possible.
			# @return [Vips::Image] if the image could be resized, otherwise `nil`.
			def resize_to_fill(output_size)
				width, height = *output_size
				
				# We can only fill and crop if the input image is BIGGER in at least one dimension than the desired output size:
				if input_image.width > width or input_image.height > height
					return fill_and_crop(input_image, width, height)
				end
			end
			
			# Resize the image to fit within the given bounds, preserving aspect ratio.
			# @return [Vips::Image] if the image could be resized, otherwise `nil`.
			def resize_to_fit(output_size)
				width, height = *output_size
				
				# We can only fit if the input image is BIGGER in at least one dimension than the desired output size:
				if input_image.width > width or input_image.height > height
					return fit(input_image, width, height)
				end
			end
			
			private
			
			def fit(image, width, height)
				x_scale = Rational(width, image.width)
				y_scale = Rational(height, image.height)
				
				scale = [x_scale, y_scale].min
				
				if scale < 1.0
					return image.resize(scale)
				end
			end
			
			def fill_and_crop(image, width, height)
				x_scale = Rational(width, image.width)
				y_scale = Rational(height, image.height)
				
				scale = [x_scale, y_scale].max
				# puts "scale #{scale}"
				
				if scale < 1.0
					image = image.resize(scale)
				elsif scale > 1.0
					# Just crop it.. no scale.
					width = image.width if x_scale > 1.0
					height = image.height if y_scale > 1.0
				end
				
				# If you hit these errors, it means you are using an older version of vips (< 8.4) which has an integer truncation bug.
				# https://github.com/jcupitt/ruby-vips/issues/82
				if image.height < height
					raise ArgumentError.new("Image resized smaller than crop! Scaled height #{image.height} < #{height}.")
				end
				
				if image.width < width
					raise ArgumentError.new("Image resized smaller than crop! Scaled width #{image.width} < #{width}.")
				end
				
				return crop(image, width, height)
			end
			
			def crop(image, width, height)
				left = (image.width - width) / 2.0
				top = (image.height - height) / 2.0
				
				# puts "image.width #{image.width} image.height: #{image.height}"
				# puts "Left: #{left} Top: #{top} X: #{width} Y: #{height}"
				image = image.extract_area(left, top, width, height)
				
				# puts "image.width #{image.width} image.height: #{image.height}"
				
				return image
			end
		end
	end
end
