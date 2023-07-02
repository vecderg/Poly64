# Poly64
 64-bit Fantasy Console

Hi! This is my first public Github page, and my first fantasy console. This will be a lot of firsts for me.

Fantasy consoles are really cool to me, and I've been enjoying my look into PICO-8, TIC-80, and others! However, I noticed a distinct lack of 3D fantasy consoles. Voxatron is not quite what I'm looking for, and I did find one other console, but it doesn't have a dev environment yet (https://github.com/DavidColson/Polybox).

The Poly64 will be a fantasy console built in Godot that can create 2D and polygon-based 3D games. It will most likely use a simplified version of GDScript, and cartridges should be able to be shared with a single text file that contains all the data.

In terms of limitations, there will be a few major ones. Textures can only go up to 32x32 pixels with a 64 color palette, and models can only be made up of the primitive shapes that come in-engine. I plan to have some form of token/performance restrictions, but these will still be relatively loose to hopefully encourage larger/more complex games than the 8-bit era fantasy console games.

The Poly64 will also take more of a Godot approach rather than a PICO-8 approach to development. The console will be a bit bulkier since it'll come with more functions to hopefully avoid re-inventing the wheel, and will prioritize quicker development time over having control of every single bit. 

# Why open source?

The Poly64's development is limited largely by my own knowledge and abilities. My goal is to get all of the basic functions working by myself, but it will be very unoptimized and will most likely miss a lot of QoL features since creating a fantasy console isn't quite within my area of expertise. I'm hoping to prove it as a working concept so that people get interested and work on it too! Even outside that, I want to make a console that encourages development, inside and out. I want people to be able to make games in the Poly64 that they feel confident in selling.

# Why Godot?

Godot is my favorite game engine! It's also generally lightweight, and the language is very easy for people to learn. It supports 2D and 3D, so I can easily use those functions for the Poly64. I would also like the console to be able to export to multiple platforms, and that's built into Godot! 

# What is the fantasy console like?

The Poly64's limitations and aesthetics are largely based on a hybrid of the PS1 and Nintendo 64. I like to imagine it as a handheld console, though its focus on 3D would put it around the GBA/DS era. I did sketch a mockup of the console but it looks rather bulky, like an N64 controller with a screen in the middle and the cartridge inserted at the top.

# List of Finished Features

- The main menu is essentially finished. It features an intro sequence, a scrollable menu that works with keyboard or mouse, and multiple menus that you can click on. There's also a neat cube that rotates depending on the hovered option! Not all menus exist yet.
- SYSTEM - Saving and loading files works! Extra work will need to be done to include later additions (models, audio), but you can currently save whatever work you have in Code and Textures
- CODE - You can type code! Due to Godot's features, you can use normal text features like copy/paste and undo/redo. There is also a counter for the line/column you're hovering over. Scrollbars will also appear if you have a large amount of text.
- TEXTURE - You can create textures of multiple sizes and draw on them with multiple colors! There are sliders for zooming and panning, and you can switch between textures that you've worked on. There is also a brush size slider, but functionality was removed for being buggy.

# To-do list

- SYSTEM - I plan to have in-engine documentation. I also need a solution for saving/loading not working in HTML exports.
- CODE - I need a parser and error handling system. Possibly syntax highlighting as well?
- TEXTURE - Brush size needs working. If possible, functions like fill tool. Must decide on all 64 colors for the palette. Need to figure out how to turn the texture data into images that models can use.
- MODEL - Implementation.
- AUDIO - Implementation.
- RUN - Implementation. Also needs a separate mode for exported versions of Poly64 games where it runs the data automatically.

# some initial documentation stuff

Will hopefully write more documentation when I can work on this again, but here's some stuff that will be important off the top of my head.
- Console is the base node/scene. It has a lot of helpful functions and management stuff.
- Poly64.gd is a script I made for static functions. It isn't amazing and Console will probably be used for the actual stuff. I may continue to use Poly64.gd just for easy access to stuff in-engine, e.g. if someone types print() it'll be parsed as Poly64.print()
- loadCartridge() will be in every window's code where it will replace its current data with whatever file is chosen in System/Load
- formatData() will basically turn the data into plaintext that can be put into a cartridge

## TEXTURES

- Texture window is made up of multiple parts. There's the DrawCanvas which is the panel in the center, and a scrollable VBox of texture thumbnails on the right.
- When creating a new canvas, createTexture() is run, which is a nightmare function that just makes a GridContainer with a bunch of ColorRects that also have Buttons. Before buttons are added, the ColorRect array is duplicated over to the thumbnail area so that those don't have buttons on them.
- Thumbnail colors are updated to match the canvas' colors in _process()
- Every color in the palette is assigned an ID based on their position in the array. When the data is formatted, every texture is just an array of color IDs. When the data is loaded, it takes those color IDs and turns them into actual color data before assigning them to the ColorRects.



