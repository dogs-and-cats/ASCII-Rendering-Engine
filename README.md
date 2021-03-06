# ASCII-Rendering-Engine
A "rendering" engine that "renders" shapes using ASCII.

### How does this work?

It uses orthographic projection to take an array of 3D points and project them onto a 2D screen. 
Smaller Z values are associated with smaller characters, such as "-" while higher Z values are associated with bigger characters such as "@". 

This can be used to create the effect of "depth" 

### A simple donut: 
![https://i.imgur.com/ByCkUR9.png](https://i.imgur.com/ByCkUR9.png)
