	//
	//  ElasticView2.m
	//  ElasticView
	//
	//  Created by Artem Sherbachuk on 1/12/16.
	//  Copyright © 2016 Artem Sherbachuk. All rights reserved.
	//

#import "ASStretchView.h"

@interface UIView (Frame)
- (CGFloat)getWidth;
- (CGFloat)getHeight;
- (CGFloat)getMidX;
- (CGFloat)getMidY;
@end


@interface ASStretchView ()
{
	CAShapeLayer *_elasticShape;
	CADisplayLink *_displayLink;
	
		//controll views
	UIView *_topControlPointView;
	UIView *_leftControlPointView;
	UIView *_bottomControlPointView;
	UIView *_rightControlPointView;
	
	CGRect _initialRect;
}
@end

@implementation ASStretchView

- (void)prepareForInterfaceBuilder
{
	[self p_configureView];
	[self p_addElasticShape];
	[self p_addControllView];
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self p_defaultValues];
	}
	return self;
}
- (void)p_defaultValues
{
	_interactionEnable = false;
	_layerColor = [UIColor redColor];
	_pushIn = false;
	_forceOfTouch = 20.0;
	_durationAnimation = 0.7;
	_springAnimation = 0.2;
	_velocityAnimation = 10.2;
	_debugMode = true;
	
	_touchReaction = false;
	_UpReaction = false;
	_DownReaction = false;
	_LeftReaction = false;
	_RightReaction = false;
	
	_shadowColor = [UIColor blackColor];
	_shadowX = 0;
	_shadowY = 5;
	_shadowOpacity = 0.8;
	_shadowRadius = 1.0;
}


#pragma mark - awakeFromNib
- (void)awakeFromNib
{
	[self p_configureView];
	[self p_addElasticShape];
	[self p_addControllView];
	[self p_addDisplayLink];
}
- (void)p_configureView
{
	self.userInteractionEnabled = _interactionEnable;
	self.backgroundColor = [UIColor clearColor];
	self.clipsToBounds = false;
	
	self.layer.shadowColor = _shadowColor.CGColor;
	self.layer.shadowOffset = CGSizeMake(_shadowX, _shadowY);
	self.layer.shadowOpacity = _shadowOpacity;
	self.layer.shadowRadius = _shadowRadius;
	
	_initialRect = self.frame;
}
- (void)p_addElasticShape
{
	_elasticShape = [CAShapeLayer layer];
	_elasticShape.frame = self.bounds;
	_elasticShape.fillColor = _layerColor.CGColor;
	_elasticShape.path = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
	
	[self.layer insertSublayer:_elasticShape atIndex:0];
}
- (void)p_addControllView
{
	_topControlPointView = [UIView new];
	_bottomControlPointView = [UIView new];
	_leftControlPointView = [UIView new];
	_rightControlPointView = [UIView new];
	NSArray *container = @[_topControlPointView, _leftControlPointView,
						   _bottomControlPointView, _rightControlPointView];
	for (UIView *controllView in container) {
		controllView.frame = CGRectMake(0, 0, 10, 10);
		controllView.backgroundColor = _debugMode == true ? [UIColor redColor] : [UIColor clearColor];
		[self addSubview:controllView];
	}
	
	[self p_setupControllPointViewsInitialPositions];
}
- (void)p_setupControllPointViewsInitialPositions
{
	_topControlPointView.center = CGPointMake([self getMidX], 0);
	_bottomControlPointView.center = CGPointMake([self getMidX], [self getHeight]);
	_leftControlPointView.center = CGPointMake(0, [self getMidY]);
	_rightControlPointView.center = CGPointMake([self getWidth], [self getMidY]);
}
- (void)p_addDisplayLink
{
	_displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(p_updateDisplayLink:)];
	[_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}
- (void)p_updateDisplayLink:(CADisplayLink *)displayLink
{
	_elasticShape.path = [self p_rectPath].CGPath;
}
- (UIBezierPath *)p_rectPath
{
	UIBezierPath *path = [UIBezierPath bezierPath];
	
	CGPoint topPoint = [_topControlPointView.layer.presentationLayer position];
	CGPoint bottomPoint = [_bottomControlPointView.layer.presentationLayer position];
	CGPoint leftPoint = [_leftControlPointView.layer.presentationLayer position];
	CGPoint rightPoint = [_rightControlPointView.layer.presentationLayer position];
	
	CGFloat width = self.frame.size.width;
	CGFloat height = self.frame.size.height;
	
	
	[path moveToPoint:CGPointMake(0, 0)];
	[path addQuadCurveToPoint:CGPointMake(width, 0) controlPoint:topPoint];
	[path addQuadCurveToPoint:CGPointMake(width, height) controlPoint:rightPoint];
	[path addQuadCurveToPoint:CGPointMake(0, height) controlPoint:bottomPoint];
	[path addQuadCurveToPoint:CGPointMake(0, 0) controlPoint:leftPoint];
	
	
	
	return path;
}


#pragma mark - touches
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
	[super touchesBegan:touches withEvent:event];
	
	if (_touchReaction) {
		[self p_animateOnTouchBegin];
	}
}
- (void)p_animateOnTouchBegin
{
	[UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:1.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		if (self.pushIn) {
			_topControlPointView.center = CGPointMake([self getMidX], + _forceOfTouch);
			
			_bottomControlPointView.center = CGPointMake([self getMidX],
														 [self getHeight] - _forceOfTouch);
			
			_leftControlPointView.center = CGPointMake(+ _forceOfTouch, [self getMidY]);
			
			_rightControlPointView.center = CGPointMake([self getWidth] - _forceOfTouch,
														[self getMidY]);
		} else {
			_topControlPointView.center = CGPointMake([self getMidX], - _forceOfTouch);
			
			_bottomControlPointView.center = CGPointMake([self getMidX],
														 [self getHeight] + _forceOfTouch);
			
			_leftControlPointView.center = CGPointMake(- _forceOfTouch, [self getMidY]);
			
			_rightControlPointView.center = CGPointMake([self getWidth] + _forceOfTouch,
														[self getMidY]);
		}
		
	} completion:^(BOOL finished) {}];
}



- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
	[super touchesEnded:touches withEvent:event];
	[self p_animateOnTouchEnded];
}
- (void)p_animateOnTouchEnded
{
	[UIView animateWithDuration:_durationAnimation delay:0
		 usingSpringWithDamping:_springAnimation initialSpringVelocity:_velocityAnimation
						options:UIViewAnimationOptionCurveEaseInOut animations:^{
							[self p_setupControllPointViewsInitialPositions];
						} completion:^(BOOL finished) { }];
}



- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
	[super touchesCancelled:touches withEvent:event];
	[self p_animateOnTouchEnded];
}



- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
	[super touchesMoved:touches withEvent:event];
	
	UITouch *touch = [touches anyObject];
	
	CGPoint location = [touch locationInView:self];
	
		//if move up
	if (_UpReaction) {
		if (location.y < 0) {
			_topControlPointView.center = location;
			return;
		}
	}
		//if move down
	if (_DownReaction) {
		if (location.y > [self getHeight]) {
			_bottomControlPointView.center = location;
			return;
		}
	}
		//if move right
	if (_RightReaction) {
		if (location.x > [self getWidth]) {
			_rightControlPointView.center = location;
			return;
		}
	}
		//if move left
	if (_LeftReaction) {
		if (location.x < 0) {
			_leftControlPointView.center = location;
			return;
		}
	}
	
}


- (void)layoutSubviews
{
	[self p_setupControllPointViewsInitialPositions];
}


	//Publick API

- (void)refreshWithAnimation
{
	[self p_animateOnTouchEnded];
}


- (void)returnInitialFrameWithAnimation
{
	self.frame = _initialRect;
	[self p_setupControllPointViewsInitialPositions];
}



- (void)setTopControlPoint:(CGPoint)topControlPoint
{
	_topControlPoint = topControlPoint;
	_topControlPointView.center = CGPointMake(_topControlPointView.center.x, topControlPoint.y);
}


- (void)setBottomControlPoint:(CGPoint)bottomControlPoint
{
	_bottomControlPoint = bottomControlPoint;
	_bottomControlPointView.center = CGPointMake(_bottomControlPointView.center.x, bottomControlPoint.y);
}


- (void)setLeftControlPoint:(CGPoint)leftControlPoint
{
	_leftControlPoint = leftControlPoint;
	_leftControlPointView.center = CGPointMake(leftControlPoint.x, _leftControlPointView.center.y);
}


- (void)setRightControlPoint:(CGPoint)rightControlPoint
{
	_rightControlPoint = rightControlPoint;
	_rightControlPointView.center = CGPointMake(rightControlPoint.x, _rightControlPointView.center.y);
}


	//dealloc
- (void)dealloc
{
	[_displayLink invalidate];
}
@end





@implementation UIView(Frame)

- (CGFloat)getWidth
{
	return self.bounds.size.width;
}

- (CGFloat)getHeight
{
	return self.bounds.size.height;
}

- (CGFloat)getMidX
{
	return self.bounds.size.width/2;
}

- (CGFloat)getMidY
{
	return self.bounds.size.height/2;
}

@end