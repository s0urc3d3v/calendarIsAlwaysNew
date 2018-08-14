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


%new -(EKEvent *) getNewestCalendarEvent {
  int daysToGoAhead = -1;
  int eventListSize = 0;
  NSArray *eventList;

  do{
    daysToGoAhead += 1;
    NSDate *today = [NSDate date];

    NSDateComponents *comp = [[[NSDateComponents alloc] init] autorelease];
    [comp setDay:daysToGoAhead];
    NSCalendar *cal = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];

    NSDate *future = [cal dateByAddingComponents:comp toDate:today options:0];

    EKEventStore *eventStore = [[EKEventStore alloc] init];
    NSPredicate *p = [eventStore predicateForEventsWithStartDate:today endDate:future calendars:nil];
    eventList = [eventStore eventsMatchingPredicate:p];
    eventListSize = [eventList count];
    NSLog(@"%d", eventListSize);
    NSString *eventListSizeAsNSString = [NSString stringWithFormat: @"%d", daysToGoAhead];
    NSLog(@"%@", eventListSizeAsNSString);

  } while (eventListSize <= 0 && daysToGoAhead < 5);

  if (eventList == nil) return nil;
  return eventList[0];
}

%end
