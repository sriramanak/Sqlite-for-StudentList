//
//  UpdateViewController.m
//  SqliteSample
//
//  Created by paradigm creatives on 9/23/14.
//  Copyright (c) 2014 Paradigm Creatives. All rights reserved.
//

#import "UpdateViewController.h"
#import <sqlite3.h>
#import "StudentTableViewController.h"

@interface UpdateViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txt4;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UITextField *txt1;
@property (weak, nonatomic) IBOutlet UITextField *txt2;
- (IBAction)EditClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txt3;
@end

@implementation UpdateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  // NSLog(@"age----%d",_obj.age);
    
    int myInteger = _obj.age;
    NSString* age = [NSString stringWithFormat:@"%i", myInteger];
    _txt1.text=_obj.name;
    _txt2.text=age;
    _txt3.text=_obj.section;
    _txt4.text=_obj.sid;
    
    _txt1.userInteractionEnabled=NO;
    _txt2.userInteractionEnabled=NO;
    _txt3.userInteractionEnabled=NO;
    _txt4.userInteractionEnabled=NO;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(NSString*)getDbFileFromDocumentDirectory
{
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *dbPath = [arr objectAtIndex:0];
    dbPath = [dbPath stringByAppendingPathComponent:@"StudentDb.sqlite"];
    return dbPath;
}

- (IBAction)EditClicked:(id)sender {
    
    [_editButton setTitle:@"Done" forState:UIControlStateNormal];
    _txt1.userInteractionEnabled=YES;
    _txt2.userInteractionEnabled=YES;
    _txt3.userInteractionEnabled=YES;
    
    NSString *age=_txt2.text;
    int ag=[age intValue];
    NSString *dbFilePath =[self getDbFileFromDocumentDirectory];
    const char *dbUtfString = [dbFilePath UTF8String];
    if (sqlite3_open(dbUtfString, &dataBase)==SQLITE_OK)
    {
    
    NSString *insertQuery = [NSString stringWithFormat:@"update StudentTable set Stu_name='%@', Stu_section='%@', Stu_age=%d where Stu_id='%@'",_txt1.text,_txt3.text,ag,_txt4.text];
    const char *qry = [insertQuery UTF8String];
    sqlite3_stmt *statment;
    if (sqlite3_prepare(dataBase, qry, -1, &statment, NULL)==SQLITE_OK )
    {
        if (sqlite3_step(statment)==SQLITE_DONE)
        {
            NSLog(@"updated Scussessfully");
            
        }
        else{
            NSAssert1(0, @"Error Description", sqlite3_errmsg(dataBase));
        }
    }
    sqlite3_finalize(statment);
    
sqlite3_close(dataBase);
    }
    
}
@end
