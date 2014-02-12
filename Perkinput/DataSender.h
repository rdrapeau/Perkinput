//
//  DataSender.h
//  DigiTaps
//
//  Sends data within JSON format to the server
//

#import <Foundation/Foundation.h>

#import "ASIFormDataRequest.h"
#import "Reachability.h"

@interface DataSender : NSObject
{
  @private
  Reachability *reachability;
  NSManagedObjectContext *manageContext;
}

- (BOOL)sendData:(NSDictionary *)data toURL:(NSURL *)url andReceived:(NSString **)response;

@end
