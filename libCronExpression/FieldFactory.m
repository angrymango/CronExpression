#import "FieldFactory.h"
#import "MinutesField.h"
#import "HoursField.h"
#import "DayOfMonthField.h"
#import "MonthField.h"
#import "DayOfWeekField.h"
#import "YearField.h"

@implementation FieldFactory

- (id)init
{
    self = [super init];
    if (self) {
        fields = [NSMutableArray arrayWithObjects:[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],nil];
    }
    
    return self;
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
        [NSException raise:@"Invalid argument" format:@"%d is not a valid position", position];
    }
    
    if([fields objectAtIndex: position] == [NSNull null])
    {
        switch(position)
        {
            case 0:
                [fields insertObject:[[MinutesField alloc] init] atIndex:position];
                break;
            case 1:
                [fields insertObject:[[HoursField alloc] init] atIndex:position];
                break;
            case 2:
                [fields insertObject:[[DayOfMonthField alloc] init] atIndex:position];
                break;
            case 3:
                [fields insertObject:[[MonthField alloc] init] atIndex:position];
                break;
            case 4:
                [fields insertObject:[[DayOfWeekField alloc] init] atIndex:position];
                break;
            case 5:
                [fields insertObject:[[YearField alloc] init] atIndex:position];
                break;
        }
    }
    
    return [fields objectAtIndex: position];
}

-(void)dealloc
{
    [super dealloc];
    [fields release];
}

@end
