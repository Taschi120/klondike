# Intro

This is an implementation of the famous Klondike solitaire / patience game, based on Godot 4.1.2.

I wrote this as a learning project for Godot in about a week and would like to share it so others
can use it as a jumping-off point for their own, similar solitaire games or as a point of reference.

The game is functional but could still use some polish and quality-of-life improvements - for 
example, picking up stacks of cards is sometimes glitchy - but I wanted to get this out before
Game Off 2023 starts (in 5 hours, 15 minutes at time of writing).

# Notes

I am not completely happy with this codebase for a couple of reasons, and would like to share
some of my thoughts.
	
* Game logic - a lot of the ruleset is hardcoded in the MainScreen scene, and the code there is
rather messy. My original intent was to encapsulate most of the rules in CardStack and its
subclasses but this didn't work out.

* Game state - the game's state is heavily tied into the scene tree, i.e. if the user clicks on
the Ace of Spades, in order to find out what stack that card is currently in, we look at the Card
instance's parent. This also means that just picking up a card with the cursor changes the game
state, as the card is moved to the Selection object. This caused a huge amount of glitches where
you could pick up one card, and then also pick up a second card directly below it, because the
second card was considered to be at the top of the stack at this point. I am not sure if it would
be better to have a set of data classes to contain the game's "logical state" and ruleset, and
loosely connect those data classes to the actual game nodes.

* Architecture - if I were to redo this entire project, I'd try to use the Command pattern, as
described in "Game Programming Patterns" by Robert Nystrom. This game does not currently have
an "Undo" feature, and frankly whith how much of a mess the game logic has already become, I don't
really feel like dealing with that.

* Choice of game - one final bit of wisdom: If you want to program a solitaire game, try picking
one that is actually consistently winnable because it will save you a ton of frustration while
playtesting!

# License

With the exception of third-party assets in the "assetpacks" folder, this project is licensed under the 
MIT License, see COPYING

# Third-party assets

Assets in the "assetpacks" folder are from third parties:

* Beholden Regular, Copyright (c) 2021, Amorphous <http://amorphic.space>
* Card Asset Pack created/distributed by natomarcacini, licensed under CC0
* Various assets by kenney, licensed under CC0
* Kaph font, licensed under SIL Open Font License:  Copyright © 2021-2022 GGBotNet (https://ggbot.net/fonts/), with Reserved Font Name "Kaph".

The full text of these licenses can be found in the README.txt and License.txt files in the assetpacks folder.

This game uses Godot Engine, available under the following license:

Copyright (c) 2014-present Godot Engine contributors. Copyright (c) 2007-2014 Juan Linietsky, Ariel Manzur.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
