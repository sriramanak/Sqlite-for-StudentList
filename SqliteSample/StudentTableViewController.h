//
//  StudentTableViewController.h
//  SqliteSample
//
//  Created by paradigm creatives on 9/22/14.
//  Copyright (c) 2014 Paradigm Creatives. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailsViewController.h"
#import <sqlite3.h>
@interface StudentTableViewController : UITableViewController<rootprotocol,UIAlertViewDelegate>
{
    sqlite3 *dataBase;
    
}
@property(nonatomic,strong) NSIndexPath *indexPathToBeDeleted;

-(NSString*)getDbFileFromProject;
-(void)CopyDbFiles;
-(void)deleteRow;


@end
