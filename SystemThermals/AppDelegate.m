//
//  AppDelegate.m
//  SystemThermals
//
//  Created by Apollo SOFTWARE on 2/1/21.
//

#import "AppDelegate.h"
#import "M1Wrapper.h"

@interface AppDelegate ()


@end

@implementation AppDelegate


- (NSColor *) get_temp_colour
{
    NSColor *tempColour = [NSColor textColor];
    float t = [self get_cpu_temp];
    
    if (t < TJ_MID)
    {
        tempColour = [NSColor greenColor];
    }
    if (t >= TJ_WARN1)
    {
        tempColour = [NSColor yellowColor];
    }
    if (t >= TJ_WARN2)
    {
        tempColour = [NSColor orangeColor];
    }

    if (t >= TJ_WARN3 || t >= TJ_MAX)
    {
        tempColour = [NSColor redColor];
    }
    return tempColour;
}

- (NSString *) get_cpu_temperature
{
    M1Wrapper *m1smc = [M1Wrapper sharedWrapper];
    return [m1smc get_temp_values];
}

- (float) get_cpu_temp
{
    M1Wrapper *m1smc = [M1Wrapper sharedWrapper];
    return [m1smc get_temp_float];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [NSApp setActivationPolicy: NSApplicationActivationPolicyProhibited];
    _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    
    // The text that will be shown in the menu bar
    [self update_temp];
    
    [self performSelector:@selector(mainthread_dotask) withObject:nil afterDelay:DELAY_T];
    
}

- (void) mainthread_dotask
{
    [self update_temp];
    [self performSelector:@selector(mainthread_dotask) withObject:nil afterDelay:DELAY_T];
}

int t_UNIT = NONE;

- (float) get_temp_var {

    if (t_UNIT == KELV)
        return [self get_cpu_temp] + 273.15f;
    if (t_UNIT == FAREN)
        return ([self get_cpu_temp] * 9.0f/5.0f) + 32.0f;
    return [self get_cpu_temp];
}

- (NSString *) get_temp_label {

    if (t_UNIT == KELV)
        return @"K";
    if (t_UNIT == FAREN)
        return @"F";
    if (t_UNIT == NONE)
        return @"";
    return @"C";
}

- (void) update_temp
{
    NSDictionary *titleAttributes = [NSDictionary dictionaryWithObject:[self get_temp_colour] forKey:NSForegroundColorAttributeName];

    NSAttributedString* colouredTitle = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.1f°%@",[self get_temp_var],[self get_temp_label]] attributes:titleAttributes];

    _statusItem.button.attributedTitle = colouredTitle;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
