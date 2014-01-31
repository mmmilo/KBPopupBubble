//
//  KBPopupBubbleView+Animations.m
//  KBPopupBubble
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without restriction,
//  including without limitation the rights to use, copy, modify, merge,
//  publish, distribute, sublicense, and/or sell copies of the Software,
//  and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
//  CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
//  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
//  SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
//  Created by Paul Sholtz on 4/8/13.
//

#import <QuartzCore/QuartzCore.h>

#import "KBPopupBubbleView+Animations.h"

@implementation KBPopupBubbleView (Animations)

#pragma mark -
#pragma mark Public Interface

//
// Add the view to the target view, using animations
//
+ (KBPopupAnimationBlock)slideInAnimationBlockWithDuration:(CGFloat)_duration
{
  KBPopupAnimationBlock block =
  ^(KBPopupBubbleView *bubble, CGFloat duration){
    __block CGRect originalFrame = bubble.frame;
    __block CGRect frame = bubble.frame;
    
    float amount = 10.0f;
    switch (bubble.side) {
      case kKBPopupPointerSideBottom:
        frame.origin.y -= amount;
        break;
      case kKBPopupPointerSideLeft:
        frame.origin.x += amount;
        break;
      case kKBPopupPointerSideRight:
        frame.origin.x -= amount;
        break;
      default:
      case kKBPopupPointerSideTop:
        frame.origin.y += amount;
        break;
    }
    
    bubble.frame = frame;
    bubble.alpha = 0.0f;
    
    [UIView animateWithDuration:duration animations:^{
      bubble.frame = originalFrame;
      bubble.alpha = 1.0f;
    }];
  };
  return block;
}

+ (KBPopupAnimationBlock)slideOutAnimationBlockWithDuration:(CGFloat)_duration
{
  KBPopupAnimationBlock block =
  ^(KBPopupBubbleView *bubble, CGFloat duration){
    __block CGRect frame = bubble.frame;
    __block CGRect originalFrame = bubble.frame;
    
    float amount = 10.0f;
    switch (bubble.side) {
      case kKBPopupPointerSideBottom:
        frame.origin.y -= amount;
        break;
      case kKBPopupPointerSideLeft:
        frame.origin.x += amount;
        break;
      case kKBPopupPointerSideRight:
        frame.origin.x -= amount;
        break;
      default:
      case kKBPopupPointerSideTop:
        frame.origin.y += amount;
        break;
    }
    
    [UIView animateWithDuration:duration animations:^{
      bubble.frame = frame;
      bubble.alpha = 0.0f;
    } completion:^(BOOL finished) {
      if (finished) {
        // restore the frame in case we need to re-use the bubble.
        bubble.frame = originalFrame;
        [bubble removeFromSuperview];
      }
    }];
  };
  return block;
}

#pragma mark -
#pragma mark Internal Methods
- (CAAnimation*)generatePopInAnimation {
    CAKeyframeAnimation *scale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scale.duration = self.animationDuration;
    scale.values = @[@0.5f, @1.2f, @0.85f, @1.0f];
    
    CABasicAnimation * fadeIn = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeIn.duration  = self.animationDuration * 0.4f;
    fadeIn.fromValue = @0.0f;
    fadeIn.toValue   = @1.0f;
    fadeIn.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    fadeIn.fillMode = kCAFillModeForwards;
    
    return [self generateAnimationGroup:[NSArray arrayWithObjects:scale, fadeIn, nil]];
}

- (CAAnimation*)generatePopOutAnimation {
    CAKeyframeAnimation *scale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scale.duration = self.animationDuration;
    scale.removedOnCompletion = NO;
    scale.values = @[@1.0f, @1.2f, @0.75f];
    
    CGFloat fraction = 0.4f;
    CABasicAnimation *fadeOut = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeOut.duration  = self.animationDuration * fraction;
    fadeOut.fromValue = @1.0f;
    fadeOut.toValue   = @0.0f;
    fadeOut.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    fadeOut.beginTime = self.animationDuration * (1.0f - fraction);
    fadeOut.fillMode = kCAFillModeForwards;
    
    CAAnimationGroup *group = [self generateAnimationGroup:[NSArray arrayWithObjects:scale, fadeOut, nil]];
    group.fillMode = kCAFillModeForwards;
    return group;
}

- (CAAnimationGroup*)generateAnimationGroup:(NSArray*)animations {
    CAAnimationGroup * group = [CAAnimationGroup animation];
    group.animations = animations;
    group.delegate = self;
    group.duration = self.animationDuration;
    group.removedOnCompletion = NO;
    
    return group;
}

@end
