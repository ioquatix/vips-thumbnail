#!/usr/bin/env ruby

require 'vips'
require 'objspace'

repeat = 100

def rss
	`ps -o rss= -p #{$$}`.chomp.to_i/1024
end

# Doesn't seem to have any affect:
Vips.cache_set_max(0)

GC.start
puts "RSS at startup with gems loaded: %d MB" % [rss]

module GC
	extend FFI::Library
	ffi_lib FFI::CURRENT_PROCESS
	
	attach_function :rb_gc_adjust_memory_usage, [:ssize_t], :void
end

if ARGV.empty?
	# A 4MiB JPEG, which decompresses to a 32MiB pixel buffer.
	ARGV << "../../spec/vips/thumbnail/IMG_8537.jpg"
end

def acquire(img)
	GC.rb_gc_adjust_memory_usage(36*1024*1024)
	ObjectSpace.define_finalizer(img, self.method(:release))
end

def release
	GC.rb_gc_adjust_memory_usage(-36*1024*1024)
end

repeat.times do |i|
	ARGV.each do |filename|
		img = Vips::Image.new_from_file filename, :access => :sequential
		acquire(img)
		
		img.write_to_file 'test.jpg', :Q => 50
		img.close # Doesn't seem to have any effect.
		
		print "\rIteration: %-8d RSS: %6d MB File: %-32s".freeze % [i+1, rss, filename]
	end
end

puts
puts "RSS at exit: %d MB" % [rss]
