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

require "vips/thumbnail"

RSpec.describe Vips::Thumbnail::Resizer do
	let(:sample_path) {File.expand_path('IMG_8537.jpg', __dir__)}
	subject{described_class.new(sample_path)}
	
	describe '#load' do
		let(:sample_path) {File.expand_path('IMG_8537-rotated.jpg', __dir__)}
		
		it "autorotates the image" do
			expect(subject.input_image.size).to be == [2448, 3264]
			output_image = subject.resize_to_fill([400, 400])
			
			# output_image.write_to_file("resized.jpg")
		end
	end
	
	describe '#close' do
		it "frees associated resources" do
			expect(subject.input_image).to_not be_nil
			subject.close
		end
	end
	
	describe '#resize_to_fill' do
		it "should load image with correct size" do
			expect(subject.input_image).to_not be_nil
			expect(subject.input_image.size).to be == [3264, 2448]
		end
		
		it "won't make the image bigger" do
			output_image = subject.resize_to_fill([8000, 6000])
			expect(output_image).to be_nil
		end
		
		it "can resize the image proportionally" do
			output_image = subject.resize_to_fill([800, 600])
			expect(output_image.size).to be == [800, 600]
		end
		
		it "can resize the image by cropping vertically" do
			output_image = subject.resize_to_fill([600, 600])
			expect(output_image.size).to be == [600, 600]
		end
		
		it "can resize the image by cropping horizontally" do
			output_image = subject.resize_to_fill([600, 800])
			expect(output_image.size).to be == [600, 800]
		end
	end
	
	describe '#resize_to_fit' do
		it "won't make the image bigger" do
			output_image = subject.resize_to_fit([8000, 6000])
			expect(output_image).to be_nil
		end
		
		it "can resize the image to fit" do
			output_image = subject.resize_to_fit([800, 800])
			expect(output_image.size).to be == [800, 600]
		end
		
		it "preserves aspect ratio" do
			output_image = subject.resize_to_fit([800, 800])
			
			input_aspect_ratio = subject.input_aspect_ratio
			output_aspect_ratio = Rational(output_image.width, output_image.height)
			
			expect(output_aspect_ratio).to be_within(0.01).of(input_aspect_ratio)
		end
	end
end
