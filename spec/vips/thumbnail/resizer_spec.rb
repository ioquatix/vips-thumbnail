
RSpec.describe Vips::Thumbnail::Resizer do
	let(:sample_path) {File.expand_path('IMG_8537.jpg', __dir__)}
	subject{described_class.new(sample_path)}
	
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
