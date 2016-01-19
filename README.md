## ASStretchView
View that you can stretch. You can change class UIView to UIButton effortlessly if needed.
![](https://raw.githubusercontent.com/sherbachuk/ASStretchView/master/ezgif.com-optimize.gif)

##Settings
![](https://raw.githubusercontent.com/sherbachuk/ASStretchView/master/Screen%20Shot%202016-01-19%20at%206.32.59%20PM.png)

##Usage
Add ASStretchView file to your project. Drag on storyboard view and add class ASStretchView.

	- (void)returnInitialFrameWithAnimation;
if you move view or chage frame etc. you can return frame value and position to the same as in storyboard every time when you call this method.



	@property(nonatomic, assign) CGPoint topControlPoint;
	@property(nonatomic, assign) CGPoint leftControlPoint;
	@property(nonatomic, assign) CGPoint bottomControlPoint;
	@property(nonatomic, assign) CGPoint rightControlPoint;
Stretching sides directly. For example by parent container gesture. 



	- (void)refreshWithAnimation;
Back to normal state.







