# Card Making Utilities.

|                              |                                              |
|:-----------------------------|:---------------------------------------------|
| `simple_crop.py`             | Utility script to crop MGCFill bleed edge.   |
| `crop_filesystem_monitor.py` | Monitors filesystem for images to crop.      |
| `page_creator.py`            | Simple downscale and format for borderless printing 3x3 on Letter sized paper. I wanted the lanczos decimation filter instead of whatever MTGProxyPrinter was doing. This makes sure there is nothing dumb losing resolution between the image and the print.   |

The matlab directory has a bunch of stuff I hacked together for filtering/layout. I have a flow that exports the scripts out to python using the matlab runtime. It's terrible, but they are there for reference.

### Stuff I think is cool

This app does a good job and I like PySide. I ended up not needing 95% of it. I basically just use it to create a list of files and send that to a script to do the actual formatting. It has a full flow from deck list to print using Scryfall/MTGArt. I prefer the high resolution of the MPCFill images. This app abstracts them as "custom images" 

https://chiselapp.com/user/luziferius/repository/MTGProxyPrinter/index


The Silhouette Card Maker repo. Currently integrating this with my matlab/python->photoshop flow.

https://github.com/Alan-Cha/silhouette-card-maker

