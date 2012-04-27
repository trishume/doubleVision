require "doubleVision/version"

require "chunky_png"

# Manipulates PNG gamma metadata to create images that
# display differently when rendered in different clients.
#
# Can be used to create images that display differently as
# thumbnails than when they are clicked on sites like facebook.
module DoubleVision
  # turns a color component from 0-255 into a new color for the firefox image
  def DoubleVision.trans(num,options)
    scaled = num*options[:fade1] + options[:shift]
    (((scaled/255.0)**(options[:gamma]))*255.0).floor
  end

  # Takes to ChunkyPNG::Image and returns the chunkypng datastream
  # of an image that displays img1 when rendered with gamma support
  # and img2 without it.
  # 
  # Will throw an ArgumentError if the images do not have the same dimensions.
  #
  # Options is a hash containing various parameters
  # [:gamma] is the gamma value to use. This should be a very low value.
  # [:fade1] is the amount to fade the first image. Default is 220/255.0
  # [:fade2] is the amount to fade the second image. Default is 210/255.0
  # [:shift] is the amount to shift up the colours of the second image. Default is 10.
  # The fade and shift parameters are required to properly segment the colors so the algorithm works.
  def DoubleVision.createImage(img1,img2,options = {})
    options[:gamma] ||= 0.023
    options[:fade1] ||= 220/255.0
    options[:fade2] ||= 210/255.0
    options[:shift] ||= 10

    if img1.dimension != img2.dimension
      raise ArgumentError, "Image sizes must have the same dimensions."
    end

    out = ChunkyPNG::Image.new(img1.dimension.width*2, img1.dimension.height*2,ChunkyPNG::Color::BLACK)

    out.dimension.width.times do |x|
      out.dimension.height.times do |y|
        if x % 2 == 0 && y % 2 == 0
          col = img1[x/2,y/2]
          r = trans(ChunkyPNG::Color.r(col),options)
          g = trans(ChunkyPNG::Color.g(col),options)
          b = trans(ChunkyPNG::Color.b(col),options)
          out[x,y] = ChunkyPNG::Color.rgb(r,g,b)
        else
          col = img2[x/2,y/2]
          r = (ChunkyPNG::Color.r(col) * options[:fade2]).round
          g = (ChunkyPNG::Color.g(col) * options[:fade2]).round
          b = (ChunkyPNG::Color.b(col) * options[:fade2]).round
          out[x,y] = ChunkyPNG::Color.rgb(r,g,b)
        end
      end
    end

    pngGamma = (options[:gamma]*100000).to_i
    # turn the integer into a 4 byte big-endian unsigned int byte string
    bytestr = [pngGamma].pack("L>") 
    # The chunk is named gAMA because the PNG spec is weird
    chunk = ChunkyPNG::Chunk::Generic.new("gAMA",bytestr)
    ds = out.to_datastream
    ds.other_chunks << chunk
    ds
  end

  # Creates a magic image from two png files of the same size.
  # Takes two filenames and saves the result in outFile.
  #
  # Will throw an ArgumentError if the images do not have the same dimensions.
  def DoubleVision.createImageFiles(file1,file2,outFile,options = {})
    img1 = ChunkyPNG::Image.from_file(file1)
    img2 = ChunkyPNG::Image.from_file(file2)
    out = createImage(img1,img2,options)
    out.save(outFile)
  end
end
