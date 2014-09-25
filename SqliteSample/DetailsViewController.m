//
//  DetailsViewController.m
//  SqliteSample
//
//  Created by paradigm creatives on 9/22/14.
//  Copyright (c) 2014 Paradigm Creatives. All rights reserved.
//

#import "DetailsViewController.h"
#import "Student.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txt1;
@property (weak, nonatomic) IBOutlet UITextField *text3;
@property (strong, nonatomic) IBOutlet UIButton *button;

- (IBAction)clicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UITextField *text2;
@end

@implementation DetailsViewController{

 NSString *timestamp;
}

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
 
    
  //  [self getStudentsDetails];

    
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
-(NSString*)getDbFileFromProject
{
    NSString *sqliteFilePath = [[NSBundle mainBundle] bundlePath];
    sqliteFilePath = [sqliteFilePath stringByAppendingPathComponent:@"StudentDb.sqlite"];
    return sqliteFilePath;
}
-(NSString*)getDbFileFromDocumentDirectory
{
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *dbPath = [arr objectAtIndex:0];
    dbPath = [dbPath stringByAppendingPathComponent:@"StudentDb.sqlite"];
    return dbPath;
}
-(void)CopyDbFiles
{
    NSString *appDbPath = [self getDbFileFromProject];
    NSString *documentDbPath = [self getDbFileFromDocumentDirectory];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:documentDbPath])
    {
        BOOL isSucess = [fileManager copyItemAtPath:appDbPath toPath:documentDbPath error:nil];
        if (isSucess) {
            
            NSLog(@"Copied Sucess");
            
    }
        else{
            NSLog(@"Copied Failure");
        }
}
}


-(void)insert:(Student*)studentObj{
    NSString *dbFilePath =[self getDbFileFromDocumentDirectory];
    const char *dbUtfString = [dbFilePath UTF8String];
    if (sqlite3_open(dbUtfString, &dataBase)==SQLITE_OK)
    {
       NSString *name = studentObj.name;
       NSString *section = studentObj.section;
       int age = studentObj.age;
        
        
        c=0;
        
        NSString *dbFilePath =[self getDbFileFromDocumentDirectory];
        const char *dbUtfString = [dbFilePath UTF8String];
        if (sqlite3_open(dbUtfString, &dataBase)==SQLITE_OK)
        {
            NSString *selectQuery = [NSString stringWithFormat:@"Select count(*) from  StudentTable"];
            const char *queryUtf8 = [selectQuery UTF8String];
            sqlite3_stmt *statment2;
            if (sqlite3_prepare(dataBase, queryUtf8, -1, &statment2, NULL)==SQLITE_OK )
            {
                while (sqlite3_step(statment2)==SQLITE_ROW)
                {
               
                            c = sqlite3_column_int(statment2, 0);
                    
                    }
                    
                
                }
        }
        c++;
        NSLog(@"-----%d",c);
        NSLog(@"%@,%d,%@,%d",name,age,section,c);
        
        
        NSLog(@"Time stamp%@",timestamp);
        
        NSString *insertQuery = [NSString stringWithFormat:@"Insert Into StudentTable Values('%@','%@',%d,%d,'%@')",name,timestamp,c,age,section];
        const char *queryUtf8 = [insertQuery UTF8String];
        sqlite3_stmt *statment;
        if (sqlite3_prepare(dataBase, queryUtf8, -1, &statment, NULL)==SQLITE_OK )
        {
            if (sqlite3_step(statment)==SQLITE_DONE)
            {
                NSLog(@"Inserted Scussessfully");
            }
            else{
                NSAssert1(0, @"Error Description", sqlite3_errmsg(dataBase));
            }
        }
        sqlite3_finalize(statment);
        
    }
    sqlite3_close(dataBase);
    NSLog(@"ccccccc");
    
}

- (IBAction)clicked:(id)sender {
    
    timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000];
    Student *stu_obj=[[Student alloc]init];
    stu_obj.name=_txt1.text;;
    stu_obj.section=_text3.text;
    stu_obj.age=[_text2.text intValue];
    stu_obj.sid=timestamp;
   // NSLog(@" new age: %d",stu_obj.age);
    stu_obj.no=c;
    
    
    //NSLog(@"aaaaaaa------%@ %d %@ %@ %d",stu_obj.name,stu_obj.age,stu_obj.section,stu_obj.sid,stu_obj.no);
    
    [self CopyDbFiles];
    
    [self insert:stu_obj];
    [self.text2 resignFirstResponder];
    [self.deleagate callfirstview:stu_obj];
    [self.navigationController popViewControllerAnimated:YES];

}
@end