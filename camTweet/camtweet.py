#!/usr/bin/env python
import sys
import os
import glob
import pygame
import pygame.camera
import time

from pygame.locals import *
from twython import Twython

# Play Sound
pygame.init()
pygame.mixer.music.load("beep.wav")
pygame.mixer.music.play()
time.sleep(1)

# Twitter API Auth Keys
# - Create App, Set Permissions to RW, Generate API Keys
CONSUMER_KEY = '#'
CONSUMER_SECRET = '#'
ACCESS_KEY = '#'
ACCESS_SECRET = '#'
api = Twython(CONSUMER_KEY,CONSUMER_SECRET,ACCESS_KEY,ACCESS_SECRET) 

# Tweet Mugshot
newest = max(glob.iglob('/tmp/motion/*.jpg'), key=os.path.getctime)   # Return lvatest JPG
photo = open(newest,'rb')                                             # Open it
api.update_status_with_media(media=photo, status='Motion Detected. ') # Tweet it

