# ArcaneDepths


i have this snippet from an svg:
```svg
<image href="wall.png" x="10" y="20" height="200" width="200" />
```

and i want to be able to set x1, y1, x2, y2 instead of x, y, width, height.
to do this i thought we could use the transform attribute of the image to
somehow emulate this.

```svg
    transform="rotate(-10 50 100)
               translate(-36 45.5)
               skewX(40)
               scale(1 0.5)">
```

is it possible to define an arbitrary polygon [(x1, y1) (x2, y2)] by using the definition of a box x, y, width, height and the transformations translate, skew, scale and rotate?


if i can define a polygon by x, y, width, height and use the transformations translate, skewX, skewY, scale and rotate, is it possible to make a function that will take any x1, y1, x2, y2 coordinates and give me the x, y, width height and transformations for that shape?