# Vips::Thumbnail

An easy to use thumbnail resizer. It's based on libvips so it's [faster than everything else](http://www.vips.ecs.soton.ac.uk/index.php?title=Speed_and_Memory_Use).

[![Build Status](https://travis-ci.com/ioquatix/vips-thumbnail.svg?branch=master)](https://travis-ci.com/ioquatix/vips-thumbnail)
[![Code Climate](https://codeclimate.com/github/ioquatix/vips-thumbnail.svg)](https://codeclimate.com/github/ioquatix/vips-thumbnail)
[![Coverage Status](https://coveralls.io/repos/ioquatix/vips-thumbnail/badge.svg)](https://coveralls.io/r/ioquatix/vips-thumbnail)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'vips-thumbnail'
```

And then execute:

	$ bundle

Or install it yourself as:

	$ gem install vips-thumbnail

### Minimum Version

`libvips` has some [integer truncation issues](https://github.com/jcupitt/ruby-vips/issues/82) in versions < 8.4, so you *must* use a release >= 8.4 otherwise you may experience problems with `resize_to_fill`.

## Usage

It's super easy:

```ruby
resizer = Vips::Thumbnail::Resizer.new(input_path)
if image = resizer.resize_to_fit([800, 600])
	image.write_to_file(output_path)
else
	# The source image wasn't big enough:
	symlink(input_path, output_path)
end
```

There are two main methods, `#resize_to_fit` which preserves aspect ratio, and `#resize_to_fill` which resizes and crops to fit the desired size if needed.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

Released under the MIT license.

Copyright, 2017, by [Samuel G. D. Williams](http://www.codeotaku.com/samuel-williams).

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
