#!/usr/bin/python

# A utility that simulates drag-and-drop from one point on the screen to another
#
# Usage: clickdrag.py from_x from_y to_x to_y
# Source courtesy of The Internet

import sys
import time
from Quartz.CoreGraphics import *	# imports all of the top-level symbols in the module

def mouseEvent(type, posx, posy):
  theEvent = CGEventCreateMouseEvent(None, type, (posx,posy), kCGMouseButtonLeft)
  CGEventPost(kCGHIDEventTap, theEvent)
def mousemove(posx,posy):
  mouseEvent(kCGEventMouseMoved, posx,posy);
def mouseclickdn(posx,posy):
  mouseEvent(kCGEventLeftMouseDown, posx,posy);
def mouseclickup(posx,posy):
  mouseEvent(kCGEventLeftMouseUp, posx,posy);
def mousedrag(posx,posy):
  mouseEvent(kCGEventLeftMouseDragged, posx,posy);

ourEvent = CGEventCreate(None);	
currentpos=CGEventGetLocation(ourEvent);	# Save current mouse position
mouseclickdn(int(sys.argv[1]), int(sys.argv[2]));
mousedrag(int(sys.argv[3]), int(sys.argv[4]));
time.sleep(0.5);
mouseclickup(int(sys.argv[3]), int(sys.argv[4]));
time.sleep(1);
mousemove(int(currentpos.x),int(currentpos.y));	# Restore mouse position
