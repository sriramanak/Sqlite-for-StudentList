//
//  UpdateViewController.h
//  SqliteSample
//
//  Created by paradigm creatives on 9/23/14.
//  Copyright (c) 2014 Paradigm Creatives. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <sqlite3.h>
#import "Student.h"

@interface UpdateViewController : UIViewController<UIAlertViewDelegate>
{
    sqlite3 *dataBase;
}
@property(nonatomic,strong)  Student *obj;
@end
