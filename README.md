# VOYAGER

From the Stars We Came, and to The Stars We Return
Voyager is a short educational playground that I designed and developed for the WWDC2018 scholarship. Made in memory of Stephen Hawking, one of the greatest minds of our time. May he rest in peace.

## Overview

Voyager implements two key apple technologies, CoreML and Scenekit. Scenekit is used to render live scenes such as Voyager 1 floating in space and also the 3 planets Voyager 1 Visited. CoreML was used to develop Karl, a fictatious Ai with odd sentiments to HAL 9000. Karl is also available as a standalone playground on my github.

### KARL - Kepler. Absolute. Relative. Logic.
KARL stands for Kepler. Absolute. Relative. Logic.
Way smarter than a human and oddly sarcastic, Karl has been developed to pilot Voyager 3 autonomously. 
Beyond that he can detect and express emotion. Recently a NASA intern exposed KARL to an 
episode of Star Wars as a joke, unfortunately he now occasionally jokes about taking over the Galaxy. 
Let’s just hope he isn’t serious.
KARL gets his own section because he threathened to unleash skynet if I didn't.

## Getting Started

Ensure you are running the latest version of xcode, open the playground file and click on the assistant editor to see the live view. Note that Voyager runs in a ipad sized liveView so do open the playground in fullscreen.  I do not own an ipad, as such all testing was limited to the simulator in the liveview in xcode.

### Testing individual scenes

First comment out :
```
PlaygroundPage.current.liveView = IntroVC
```
which lies at the very bottom of the main playground file.

After which you can uncomment the line which shows the scene you want such as :
```
//PlaygroundPage.current.liveView = KarlVC
```
and this becomes
```
PlaygroundPage.current.liveView = KarlVC
```

## Running

Run the playground, view the live view using the assistant editor.

## Built With

* [CoreML](https://developer.apple.com/documentation/coreml) - Apples framework for importing Machine Learning Models
* [SentimentPolarity](https://coreml.store/sentimentpolarity) - Open Source MLModel for detecting sentiments from text
* [Scenekit](https://developer.apple.com/documentation/scenekit) - Apples framework for generating 3D scenes

## Contributing

Currently not officially accepting pull requests as this is a personal project. However feel free to send one and I may approve it.

## Authors

* **Dalton Prescott** - *Sole Developer* - [My Website](http://daltonprescott.com/)

## License

This project will be licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details when it is available.

## Acknowledgments

* Vadym Markov for Sentiment Polarity
* Hat tip to anyone who's code was used ( Looking at you Stack Overflow )
* Nasa for the 3D Models and inspiration and planet textures

## Inspiration

* Stephen Hawking
* Carl Sagan
* Nasa
* SpaceX
