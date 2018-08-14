#import <EventKit/EventKit.h>
//#import "Tweak.h"
@interface SBUILegibilityLabel : UIView
@property (nonatomic, copy) NSString *string;
@end

@interface NCNotificationListSectionRevealHintView : UIView
@property (nonatomic, retain) SBUILegibilityLabel * revealHintTitle;
-(void) _updateHintTitle;
-(EKEvent *) getNewestCalendarEvent;
@end

%hook NCNotificationListSectionRevealHintView

- (void) _updateHintTitle {
  %orig;
  EKEvent *newestEvent = [self getNewestCalendarEvent];
  if (newestEvent != nil){
    NSString *eventTitle = newestEvent.title;
    self.revealHintTitle.string = eventTitle;
  }
  else {
    self.revealHintTitle.string = @"I was unable to grab the newest event within your bounds, it may not exist.";
  }
}


%new -(EKEvent *) getNewestCalendarEvent { //returns true if permission granted!
  NSDate *today = [NSDate date];
  NSDate *todayNextYear = [NSDate dateWithTimeInterval:(365*24*60*60) sinceDate:[NSDate date]];
  EKEventStore *eventStore = [[EKEventStore alloc] init];
  NSPredicate *p = [eventStore predicateForEventsWithStartDate:today endDate:todayNextYear calendars:nil];
  NSArray *eventList = [eventStore eventsMatchingPredicate:p];
  int eventListSize = [eventList count];

  if (eventListSize <= 0) return nil;
  return eventList[eventListSize - 1];
}

%end
