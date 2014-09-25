//
//  DetailsViewController.h
//  SqliteSample
//
//  Created by paradigm creatives on 9/22/14.
//  Copyright (c) 2014 Paradigm Creatives. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "Student.h"

@protocol rootprotocol <NSObject>
@required

-(void)callfirstview:(Student *)obj;



@end

@interface DetailsViewController : UIViewController
{
    id deleagate;
sqlite3 *dataBase;
  
     int c;
}


@property(nonatomic,weak)id <rootprotocol>deleagate;


-(NSString*)getDbFileFromProject;
-(NSString*)getDbFileFromDocumentDirectory;
-(void)CopyDbFiles;

@end
