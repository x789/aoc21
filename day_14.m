// Advent of Code 2021, Day 14: Extended Polymerization
// (c) 2022 TillW

#import <Foundation/Foundation.h>

@protocol PuzzleSolver
-(long)solveForTemplate:(NSString*)template numberOfSteps:(int)numberOfSteps;
-(id)initWithRules:(NSDictionary<NSString*, NSString*>*)rules;
@end

// -- Naiive solver for puzzle #1 --
@interface PolymerElement : NSObject
@property unichar type;
@property (strong) PolymerElement* next;
-(id)initWithType:(char)type;
@end

@interface NaiiveSolver : NSObject <PuzzleSolver> {
    @private NSDictionary<NSString*, NSString*>* rules;
    @private NSMutableDictionary<NSString*, NSNumber*>* counters;
}
@end
// ----

// -- Optimized solver for puzzle #2 --
@interface Polymer : NSObject {
@private NSMutableDictionary<NSString*, NSNumber*>* ingredients;
@private NSString* usedTemplate;
}
-(void)addPair:(NSString*)pair times:(NSNumber*)times;
-(NSDictionary<NSString*, NSNumber*>*)getIngredients;
-(long)getDifferenceBetweenMostAndLeastUsedElements;
-(id)initFromTemplate:(NSString*)template;
-(NSString*)getUsedTemplate;
@end

@interface OptimizedSolver : NSObject <PuzzleSolver> {
    @private NSDictionary<NSString*, NSArray<NSString*>*>* rules;
}
@end
// ----

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        id content = [[NSString alloc]initWithContentsOfFile:@"/path/to/input_14.txt" encoding:NSUTF8StringEncoding error:nil];
        id lines = [content componentsSeparatedByString:@"\n"];
        id rules = [[NSMutableDictionary<NSString*, NSString*> alloc] init];
        for (int i = 2; i < [lines count]; i++) {
            id parts = [lines[i] componentsSeparatedByString:@" -> "];
            rules[parts[0]] = parts[1];
        }
        id solver = [[OptimizedSolver alloc] initWithRules:rules];
        long solution = [solver solveForTemplate:lines[0] numberOfSteps:40];
        NSLog(@"Solution: %ld", solution);
    }
    return 0;
}

// -- Naiive solver for puzzle #1 --
@implementation PolymerElement
-(id)initWithType:(char)type {
    self.type = type;
    self.next = nil;
    return self;
}
@end

@implementation NaiiveSolver
-(id)initWithRules:(NSDictionary<NSString*, NSString*>*)baseRules {
    rules = [baseRules copy];
    counters = [[NSMutableDictionary<NSString*, NSNumber*> alloc] init];
    return self;
}

-(long)solveForTemplate:(NSString*)template numberOfSteps:(int)numberOfSteps {
    id root = [self createPolymerFrom:template];
    for (int step = 1; step <= numberOfSteps; step++) {
        [self doStep:root ];
    }
    return [self calculateResult];
}

-(PolymerElement*)createNewElementFor:(NSString*)pair {
    PolymerElement* result = nil;
    if (rules[pair]) {
        char type = [rules[pair] characterAtIndex:0];
        result = [[PolymerElement alloc] initWithType:type];
    }
    return result;
}

-(void)updateCountersBasedOn:(PolymerElement*)element {
    id type = [NSString stringWithFormat:@"%c", element.type];
    id actualCount = counters[type];
    if (actualCount) {
        counters[type] = [NSNumber numberWithInt:[actualCount intValue] + 1];
    } else {
        counters[type] = @1;
    }
}

-(int)calculateResult {
    id numbers = [counters allValues];
    id max = [numbers valueForKeyPath:@"@max.self"];
    id min = [numbers valueForKeyPath:@"@min.self"];
    return [max intValue] - [min intValue];
}

-(void)doStep:(PolymerElement*)root {
    for(PolymerElement* current = root; current.next != nil; current = current.next) {
        unichar tmp[2] = { current.type, current.next.type };
        id pair = [NSString stringWithCharacters:tmp length:2];
        id newElement = [self createNewElementFor:pair];
        if (newElement) {
            [newElement setNext:current.next];
            [current setNext:newElement];
            current = newElement;
            [self updateCountersBasedOn:newElement];
        }
    }
}

-(PolymerElement*)createPolymerFrom:(NSString*)template {
    id root = [[PolymerElement alloc] initWithType:[template characterAtIndex:0]];
    id last = root;
    for (int i = 1; i < [template length]; i++) {
        id newMolecule = [[PolymerElement alloc] initWithType:[template characterAtIndex:i]];
        [last setNext:newMolecule];
        last = newMolecule;
        [self updateCountersBasedOn:newMolecule];
    }
    return root;
}
@end
// ----

// -- Optimized solver for puzzle #2 --
@implementation Polymer
-(id)initFromTemplate:(NSString*) template {
    ingredients = [[NSMutableDictionary<NSString*, NSNumber*> alloc] init];
    usedTemplate = template;
    return self;
}

-(NSString*)getUsedTemplate {
    return usedTemplate;
}

-(void)addPair:(NSString *)pair times:(NSNumber *)times {
    NSNumber* count = ingredients[pair];
    if (count) {
        count = @([count longValue] + [times longValue]);
    } else {
        count = times;
    }
    ingredients[pair] = count;
}

-(long)getDifferenceBetweenMostAndLeastUsedElements {
    id counters = [[NSMutableDictionary<NSString*, NSNumber*> alloc] init];
    [ingredients enumerateKeysAndObjectsUsingBlock:^(id pair, id times, BOOL* stop) {
        id element1 = [pair substringToIndex:1];
        [Polymer addCountOf:times forElement:element1 inDictionary:counters];
        id element2 = [pair substringFromIndex:1];
        [Polymer addCountOf:times forElement:element2 inDictionary:counters];
    }];
    
    __block long min = LONG_MAX;
    __block long max = 0;
    [counters enumerateKeysAndObjectsUsingBlock:^(id element, id count, BOOL* stop) {
        long correctedCount = 0;
        if (element == [usedTemplate substringToIndex:1] || element == [usedTemplate substringFromIndex:[usedTemplate length]-1]) {
            correctedCount = ([count longValue] + 1) / 2;
        } else {
            correctedCount = [count longValue] / 2;
        }
        if (correctedCount < min) min = correctedCount;
        if (correctedCount > max) max = correctedCount;
        
    }];
    return max - min;
}

+(void)addCountOf:(NSNumber*)count forElement:(NSString*)element inDictionary:(NSMutableDictionary<NSString*, NSNumber*>*)dict {
    NSNumber* value = dict[element];
    if (value) {
        value = @([value longValue] + [count longValue]);
    } else {
        value = count;
    }
    dict[element] = value;
}

-(NSDictionary<NSString*, NSNumber*>*)getIngredients {
    return [ingredients copy];
}
@end

@implementation OptimizedSolver
-(id)initWithRules:(NSDictionary<NSString*, NSString*>*)baseRules {
    id expandedRules = [[NSMutableDictionary<NSString*, NSArray<NSString*>*> alloc] init];
    [baseRules enumerateKeysAndObjectsUsingBlock:^(id pair, id value, BOOL* stop) {
        id resultingPair1 = [[pair substringToIndex:1] stringByAppendingString:baseRules[pair]];
        id resultingPair2 = [baseRules[pair] stringByAppendingString:[pair substringFromIndex:1]];
        expandedRules[pair] = [NSArray arrayWithObjects:resultingPair1, resultingPair2, nil];
    }];
    rules = [expandedRules copy];
    return self;
}

-(Polymer*)createPolymerFromTemplate:(NSString*)template {
    id polymer = [[Polymer alloc] initFromTemplate:template];
    for (int i = 0; i < [template length]-1; i++) {
        id pair = [template substringWithRange:NSMakeRange(i, 2)];
        [polymer addPair:pair times:@1];
    }
    return polymer;
}

-(Polymer*)doStep:(Polymer*)basePolymer {
    id polymer = [[Polymer alloc] initFromTemplate:[basePolymer getUsedTemplate]];
    [[basePolymer getIngredients] enumerateKeysAndObjectsUsingBlock:^(id pair, id times, BOOL* stop) {
        for (id newPair in rules[pair]) {
            [polymer addPair:newPair times:times];
        }
    }];
    return polymer;
}

-(long)solveForTemplate:(NSString*)template numberOfSteps:(int)numberOfSteps {
    id polymer = [self createPolymerFromTemplate:template];
    for (int step = 1; step <= numberOfSteps; step++) {
        polymer = [self doStep:polymer];
    }
    
    return [polymer getDifferenceBetweenMostAndLeastUsedElements];
}
@end
// ----
