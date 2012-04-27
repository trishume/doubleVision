# DoubleVision

I recently was shown trick by a friend where an image was posted on a website 
that displayed one thing in the thumbnail and another in the lightbox.
http://funnyjunk.com/channel/ponytime/rainbow+dash/llhuDyy/15#15

I set out to create a program that generates these images and this is what I came up with.

The output images look like this:

![Sample Image](http://f.cl.ly/items/2u1W1J0m2z3N0T0B3K0y/out.png)

Try downloading it to your computer and then viewing it. Cool eh?

## How it works
The PNG specification contains a metadata attribute that allows you to specify the gamma to render the image with. The thing is, not all renderers support this.

If an image is created with normal pixels spaced out around a grid of very light-colored pixels.
The light colored pixels are actually the pixels of the second image reverse-mapped through a gamma function. 
However, they are so light they look white.

When the image is displayed with a very low gamma (I use 0.023). 
The normal pixels become almost black and the light pixels become the colors of the second image.

Example:
![Difference example](https://img.skitch.com/20120427-tjwy5f1gf2xhr9jkfkqi3wxxku.png)

## Why?
By taking of advantage of this, we can create png files that display a different picture if the renderer supports the gamma attribute.

Things that do not support the gamma attribute:

- Thumbnail renderers (Facebook, etc...)
- Apple png rendering
- Windows png rendering

Things that **do** support the gamma attribute:

- Firefox (uses libpng wich supports the attribute)
- Google Chrome

This can lead to interesting combos. 
For example: 

- linking the image on facebook can show one image as a thumbnail but a completely different one when the link is clicked.
- A picture that detects the user's browser. (Chrome/Firefox or Safari)
- A picture that displays one thing in the browser and a different thing when downloaded to the user's (victim's) computer.

## Installation

Add this line to your application's Gemfile:

    gem 'doubleVision'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install doubleVision

## Usage

Next, run the program like this:

	doubleVision withgamma.png withoutgamma.png out.png

obviously replacing the filenames with your own.

It will combine the images into one image (out.png) that will display
withgamma.png when viewed with gamma support (e.g. in Firefox) 
and withoutgamma.png when displayed without gamma support (e.g. As a thumbnail)

##FAQ

- Why are the images so dark? - 
	The images have to be darkened so that they do not show up in the other image. 
	One image is also full of black pixels which make it look dark.
- Are you a wizard?
	Sadly, no. But programmers are almost the same thing.

*Disclaimer: Frequently Asked Questions are not necessarily frequently asked, nor are they always questions.*

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
