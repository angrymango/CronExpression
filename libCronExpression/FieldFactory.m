#import "FieldFactory.h"
#import "MinutesField.h"
#import "SecondsField.h"
#import "HoursField.h"
#import "DayOfMonthField.h"
#import "MonthField.h"
#import "DayOfWeekField.h"
#import "YearField.h"

@interface FieldFactory()
{
@private
    NSMutableArray *fields;
}
@end

@implementation FieldFactory

- (id)init
{
    self = [super init];
    if (self) {
        _calendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
        fields = [NSMutableArray arrayWithObjects:[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],nil];
    }
    
    return self;
}

-(void)resetFieldCache
{
    [fields enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[Field class]])
        {
            [((Field*)obj) resetCache];
        }
    }];
}

-(id<FieldInterface>)getField:(NSUInteger)position
{
    /*if (!isset($this->fields[$position])) {
        switch ($position) {
            case 0:
                $this->fields[$position] = new MinutesField();
            break;
            case 1:
                $this->fields[$position] = new HoursField();
            break;
            case 2:
                $this->fields[$position] = new DayOfMonthField();
            break;
            case 3:
                $this->fields[$position] = new MonthField();
            break;
            case 4:
                $this->fields[$position] = new DayOfWeekField();
            break;
            case 5:
                $this->fields[$position] = new YearField();
            break;
            default:
                throw new InvalidArgumentException(
                    $position . ' is not a valid position'
                );
        }
    }
     
     return $this->fields[$position];*/

    if(position >= [fields count])
    {
        int i = (int)position;
        [NSException raise:@"Invalid argument" format:@"%d is not a valid position", i];
    }
    id<FieldInterface> field = [fields objectAtIndex: position];
    if([fields objectAtIndex: position] == [NSNull null])
    {
        Field* f = nil;
        switch(position)
        {
            case 0:
                f = field = [[SecondsField alloc] init];
                break;
            case 1:
                f = field = [[MinutesField alloc] init];
                break;
            case 2:
                f = field = [[HoursField alloc] init];
                break;
            case 3:
                f = field = [[DayOfMonthField alloc] init];
                break;
            case 4:
                f = field = [[MonthField alloc] init];
                break;
            case 5:
                f = field = [[DayOfWeekField alloc] init];
                break;
            case 6:
                f = field = [[YearField alloc] init];
                break;
        }
        f.calendar = self.calendar;
        [fields insertObject:field atIndex:position];
    }
    return field;
}

-(void)dealloc
{
    [super dealloc];
//    [fields release];
}

@end
