// Change the lock screen dim timer after pressing the home button
// Created by EvilPenguin (James Emrich)
// Date: 9/06/2011
// 
// Copyright (c) 2011 James Emrich
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#define listenToNotification$withCallBack(notification, callback); 	\
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), \
	NULL, \
	(CFNotificationCallback)&callback, \
	CFSTR(notification), \
	NULL, \
	CFNotificationSuspensionBehaviorHold);

static NSMutableDictionary *dictionary;

static void updateTimerSettings() {
	if (dictionary) {
		[dictionary release]; 
		dictionary = nil;
	}
	dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.understruction.updateTimerSettings.plist"];
}

@interface SBAwayController 
	- (void)restartDimTimer:(float)fp8;
@end

%hook SBAwayController
- (void)restartDimTimer:(float)fp8 {
	int timer = [dictionary objectForKey:@"LockScreenTimer"] ? [[dictionary objectForKey:@"LockScreenTimer"] intValue] : 8;
	NSLog(@"LockScreenDimChanger Timer: %i|%f", timer, fp8);
	%orig(timer);
}
%end

%ctor {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	%init;
	listenToNotification$withCallBack("com.understruction.updateTimerSettings", updateTimerSettings);
	updateTimerSettings();
	[pool release];
}