# Setup 
Check it out [here](https://www.youtube.com/watch?v=z_86auSeoAI)

#### You will need the following library for this to work:
- [PixelFlow](https://github.com/diwi/PixelFlow)

#### To run:
	- Play the file

#### What do I do:
    - More than one user the particle size will change and the color will continously change
    - 1 user the colour will change every 2 minutes
    - The closer the user is to the camera, the more collisions there will be
    - The further away the more control, particles will map more to the optical flow of the body
    - If no one is in frame it will go to a resting state 
        
    - To create the collisions that will bounce of your silhouette you will need to wait 2min to start that collision and your face will need to be closer to the camera

### Tutorials that helped me get through this sanely/not-so sanely:
	
#### Particle Systems
- [nature of code](http://natureofcode.com/book/chapter-4-particle-systems/)

#### Documentation for PixelFlow + Examples
- [PixelFlow documentation](http://thomasdiewald.com/processing/libraries/pixelflow/reference/index.html)
- [Examples Used] (https://github.com/diwi/PixelFlow/tree/master/examples/FlowFieldParticles)

