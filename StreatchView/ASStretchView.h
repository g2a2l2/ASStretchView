//
//  ElasticView2.h
//  ElasticView
//
//  Created by Artem Sherbachuk on 1/12/16.
//  Copyright © 2016 Artem Sherbachuk. All rights reserved.
//

#import <UIKit/UIKit.h>


IB_DESIGNABLE
@interface ASStretchView : UIView


/**
 *  Enable/Disable SpringView build in gesture
 */
@property(nonatomic, assign) IBInspectable BOOL interactionEnable;

/**
 *  Background color of stretching layer
 */
@property(nonatomic, strong) IBInspectable UIColor *layerColor;

/**
 *  On touch view push inside or outside view borders.
 */
@property(nonatomic, assign) IBInspectable BOOL pushIn;

/**
 *  the force with which crushed view on touch. Defaul value is 20.0
 */
@property(nonatomic, assign) IBInspectable CGFloat forceOfTouch;


@property(nonatomic, assign) IBInspectable CGFloat durationAnimation;
@property(nonatomic, assign) IBInspectable CGFloat springAnimation;
@property(nonatomic, assign) IBInspectable CGFloat velocityAnimation;

@property(nonatomic, assign) IBInspectable BOOL debugMode;

@property(nonatomic, assign) IBInspectable BOOL touchReaction;// Animate on touchesBegan.
@property(nonatomic, assign) IBInspectable BOOL UpReaction;//The direction of stretching on touchesMoved
@property(nonatomic, assign) IBInspectable BOOL DownReaction;//The direction of stretching on touchesMoved
@property(nonatomic, assign) IBInspectable BOOL LeftReaction;//The direction of stretching on touchesMoved
@property(nonatomic, assign) IBInspectable BOOL RightReaction;//The direction of stretching on touchesMoved

/**
 *  Configure shadow
 */
@property(nonatomic, strong) IBInspectable UIColor *shadowColor;
@property(nonatomic, assign) IBInspectable CGFloat shadowX;
@property(nonatomic, assign) IBInspectable CGFloat shadowY;
@property(nonatomic, assign) IBInspectable CGFloat shadowOpacity;
@property(nonatomic, assign) IBInspectable CGFloat shadowRadius;


/**
 *  Stretching top side.
 */
@property(nonatomic, assign) CGPoint topControlPoint;

/**
 *  Stretching left side.
 */
@property(nonatomic, assign) CGPoint leftControlPoint;

/**
 *  Stretching bottom side.
 */
@property(nonatomic, assign) CGPoint bottomControlPoint;

/**
 *  Stretching right side.
 */
@property(nonatomic, assign) CGPoint rightControlPoint;

/**
 *  Back to normal state.
 */
- (void)refreshWithAnimation;

/**
 *  Return frame value and position to the same as in storyboard.
 */
- (void)returnInitialFrameWithAnimation;
@end