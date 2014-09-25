//
//  StudentTableViewController.m
//  SqliteSample
//
//  Created by paradigm creatives on 9/22/14.
//  Copyright (c) 2014 Paradigm Creatives. All rights reserved.
//

#import "StudentTableViewController.h"
#import "UpdateViewController.h"
@interface StudentTableViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *button1;

@end

@implementation StudentTableViewController;
NSMutableArray *obj_array;
NSString *idval;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self CopyDbFiles];
    
    self.title=@"Student Info";
    obj_array=[[NSMutableArray alloc]init];
   [self firstView];
    
    
               
}
-(NSString*)getDbFileFromDocumentDirectory
{
        NSArray *arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString  *dbPath = [arr objectAtIndex:0];
    dbPath = [dbPath stringByAppendingPathComponent:@"StudentDb.sqlite"];
    return dbPath;
}
-(void) firstView
{
   
   NSString *dbFilePath =[self getDbFileFromDocumentDirectory];
    NSLog(@"-----%@",dbFilePath);
    
    const char *dbUtfString = [dbFilePath UTF8String];
   
    if (sqlite3_open(dbUtfString, &dataBase)==SQLITE_OK)
    {
        NSString *selectQuery = [NSString stringWithFormat:@"select * from  StudentTable"];
        const char *queryUtf8 = [selectQuery UTF8String];
        sqlite3_stmt *stmt;
        if (sqlite3_prepare(dataBase, queryUtf8, -1, &stmt, NULL)==SQLITE_OK )
        {
            while (sqlite3_step(stmt)==SQLITE_ROW)
            {
                
                Student *studentObj = [[Student alloc] init];
                studentObj.name=[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(stmt, 0)];
                studentObj.sid=[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(stmt, 1)];
                studentObj.no=(int) sqlite3_column_text(stmt, 2);
                studentObj.age=(int) sqlite3_column_text(stmt, 3);
                studentObj.section=[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(stmt, 4)];
                
                NSLog(@"student data----%@",studentObj);
                
                [obj_array addObject:studentObj];
                NSLog(@"objecta rray---%@",obj_array);
                
            }
        }
        
        
        sqlite3_finalize(stmt);
    }
    sqlite3_close(dataBase);
    
    [self.tableView reloadData];
  
}


-(void)callfirstview:(Student *)sobj
{
    [obj_array addObject:sobj];
    [self.tableView reloadData];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [obj_array count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"studentcell" forIndexPath:indexPath];
    Student *studentRecored = [obj_array objectAtIndex:indexPath.row];
    
   cell.textLabel.text=studentRecored.name;
     cell.detailTextLabel.text=studentRecored.sid;
    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        self.indexPathToBeDeleted = indexPath;
        
        Student *tempObject=[obj_array objectAtIndex:indexPath.row];
        idval=tempObject.sid;
        

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                        message:@"Are you sure?"
                                                       delegate:self
                                              cancelButtonTitle:@"NO"
                                              otherButtonTitles:@"YES", nil];
        [alert show];
        

    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // This method is invoked in response to the user's action. The altert view is about to disappear (or has been disappeard already - I am not sure)
    
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"NO"])
    {
        NSLog(@"Nothing to do here");
    }
    else if([title isEqualToString:@"YES"])
    {
        NSLog(@"Delete the cell");
        
        [obj_array removeObjectAtIndex:[self.indexPathToBeDeleted row]];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:self.indexPathToBeDeleted] withRowAnimation:UITableViewRowAnimationFade];
        [self deleteRow];
        
        
    }
}

-(void)deleteRow
{
    NSString *dbFilePath =[self getDbFileFromDocumentDirectory];
    const char *dbUtfString = [dbFilePath UTF8String];
    if (sqlite3_open(dbUtfString, &dataBase)==SQLITE_OK)
    {
        NSString *selectQuery = [NSString stringWithFormat:@"delete from StudentTable where Stu_id=%@",idval];
        const char *queryUtf8 = [selectQuery UTF8String];
        sqlite3_stmt *statment;
        if (sqlite3_prepare(dataBase, queryUtf8, -1, &statment, NULL)==SQLITE_OK )
        {
            if(sqlite3_step(statment) == SQLITE_DONE){
                NSLog(@"deleted");
            }
        }
        sqlite3_finalize(statment);
    }
    sqlite3_close(dataBase);
    
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier]isEqualToString:@"to2"]) {
        DetailsViewController *mSegue = [segue destinationViewController];
        mSegue.deleagate=self;
    }
   else if ([[segue identifier]isEqualToString:@"pushData"]) {
        UpdateViewController *mSegue = [segue destinationViewController];
       NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];

       // mSegue.deleagate=self;
       mSegue.obj=[obj_array objectAtIndex:indexPath.row];
       
   }

}
-(NSString*)getDbFileFromProject
{
    NSString *sqliteFilePath = [[NSBundle mainBundle] bundlePath];
    sqliteFilePath = [sqliteFilePath stringByAppendingPathComponent:@"StudentDb.sqlite"];
    return sqliteFilePath;
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



@end
