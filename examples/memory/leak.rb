#!/usr/bin/env ruby

require 'vips'
require 'objspace'

repeat = 100

def rss
	`ps -o rss= -p #{$$}`.chomp.to_i/1024
end

# Doesn't seem to have any affect:
Vips.cache_set_max(0)
Vips.cache_set_max_mem(0)

GC.start
puts "RSS at startup with gems loaded: %d MB" % [rss]

close = true if ARGV.delete('--close')
nullify = true if ARGV.delete('--nullify')
gc_each = true if ARGV.delete('--gc-each')

if ARGV.empty?
	# A 4MiB JPEG, which decompresses to a 32MiB pixel buffer.
	ARGV << "../../spec/vips/thumbnail/IMG_8537.jpg"
end

repeat.times do |i|
	ARGV.each do |filename|
		img = Vips::Image.new_from_file filename, :access => :sequential
		img.write_to_file 'test.jpg', :Q => 50
		
		# Try various permutations of these:
		img.close if close
		img = nil if nullify
		GC.start if gc_each
		
		print "\rIteration: %-8d RSS: %6d MB File: %-32s".freeze % [i+1, rss, filename]
	end
end
puts

GC.start
puts "RSS at exit: %d MB" % [rss]
