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
  NSArray *eventList = nil;

  do{
    daysToGoAhead += 1;
    NSDate *today = [NSDate date];

    NSDateComponents *comp = [[[NSDateComponents alloc] init] autorelease];
    [comp setDay:daysToGoAhead];
    NSCalendar *cal = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];

    NSDate *future = [cal dateByAddingComponents:comp toDate:today options:0];

    EKEventStore *eventStore = [[EKEventStore alloc] init];
    NSPredicate *p = [eventStore predicateForEventsWithStartDate:today endDate:future calendars:nil];
    NSArray *eventList = [eventStore eventsMatchingPredicate:p];
    eventListSize = [eventList count];
    NSLog(@"%d", eventListSize);
    NSString *eventListSizeAsNSString = [NSString stringWithFormat: @"%d", eventListSize];
    NSLog(@"%@", eventListSizeAsNSString);
    NSString *eventListAsNSString = [NSString stringWithFormat: @"%@", eventList];


  } while (![eventListAsNSString isEqualToString: nil]);

  NSString *eventListSizeAsNSString = [NSString stringWithFormat: @"%d", eventListSize];
  NSString *s = [NSString stringWithFormat: @"%@", eventList];

  NSString *str = [NSString stringWithFormat: @"%@ %@", eventListSizeAsNSString, s];
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"hello"
    message:str
    delegate:self
    cancelButtonTitle:@"Done"
    otherButtonTitles:nil];
  [alert show];

  if (eventListSize <= 0 || eventList == nil) return nil;

  UIAlertView *alerter = [[UIAlertView alloc] initWithTitle:@"hello"
    message:@"Not Nil"
    delegate:self
    cancelButtonTitle:@"Done"
    otherButtonTitles:nil];
  [alerter show];
  return eventList[eventListSize - 1];
}

%end
