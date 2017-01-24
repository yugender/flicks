//
//  ViewController.m
//  flicks
//
//  Created by  Yugender Boini on 1/23/17.
//  Copyright © 2017 sample. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import "MovieModel.h"
#import "MovieDetailViewController.h"
#import "MovieCollectionViewCell.h"
#import "constants.h"
#import "ImageLoader.h"
#import "MBProgressHUD.h"

const int LIST_VIEW_INDEX = 0;
const int GRID_VIEW_INDEX = 1;

@interface MoviesViewController () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UIView *errorView;
@property (weak, nonatomic) IBOutlet UITableView *moviesView;

@property (nonatomic, strong) NSArray<MovieModel *> *movies;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UISegmentedControl *layoutControl;
@property (nonatomic, strong) UIRefreshControl* tableRefreshControl;
@property (nonatomic, strong) UIRefreshControl* collectionRefreshControl;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;
@property (strong, nonatomic) NSString *endpoint;

@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // add segment control for switching layout
    [self addLayoutSegmentControl];
    
    // update the movie list api endpoint
    [self updateMovieListEndpoint];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    // add movies collection view
    [self addMoviesCollectionView];
    
    self.moviesView.dataSource = self;
    self.moviesView.delegate = self;
    
    // set up the refresh controls
    [self addRefreshControls];
    
    // set up the search bar
    [self addSearchBar];
    
    [self fetchMovies:nil];
}

- (void) addLayoutSegmentControl {
    UISegmentedControl *layoutSegmentControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:[UIImage imageNamed:@"list_view"],[UIImage imageNamed:@"grid_view"],nil]];
    [layoutSegmentControl sizeToFit];
    [layoutSegmentControl setSelectedSegmentIndex:LIST_VIEW_INDEX];
    [layoutSegmentControl addTarget:self action:@selector(updateLayout:) forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:layoutSegmentControl];
    [self.navigationItem setLeftBarButtonItem:barButtonItem];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.layoutControl = layoutSegmentControl;
}

- (void) updateMovieListEndpoint {
    if (self.movieListType == MovieListTypeNowPlaying) {
        self.endpoint = @"now_playing";
    } else {
        self.endpoint = @"top_rated";
    }
}

- (void) addSearchBar {
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.delegate = self;
    self.searchBar.barStyle = UIBarStyleBlack;
    self.searchBar.tintColor = [UIColor whiteColor];
    [[UITextField appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTextColor:[UIColor whiteColor]];
    self.navigationItem.titleView = self.searchBar;
}

- (void) addRefreshControls {
    self.tableRefreshControl = [[UIRefreshControl alloc] init];
    self.tableRefreshControl.tintColor = [UIColor whiteColor];
    [self.tableRefreshControl addTarget:self action:@selector(fetchMovies:) forControlEvents:UIControlEventValueChanged];
    [self.moviesView insertSubview:self.tableRefreshControl atIndex:0];
    
    self.collectionRefreshControl = [[UIRefreshControl alloc] init];
    self.collectionRefreshControl.tintColor = [UIColor whiteColor];
    [self.collectionRefreshControl addTarget:self action:@selector(fetchMovies:) forControlEvents:UIControlEventValueChanged];
    [self.collectionView insertSubview:self.collectionRefreshControl atIndex:0];
}

- (void) addMoviesCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat screenWidth = CGRectGetWidth(self.view.bounds);
    CGFloat itemHeight = 150;
    CGFloat itemWidth = screenWidth / 3;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [collectionView registerClass:[MovieCollectionViewCell class] forCellWithReuseIdentifier:@"MovieCollectionViewCell"];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:collectionView];
    collectionView.hidden = YES;
    self.collectionView = collectionView;
}

- (void) fetchMovies: (UIRefreshControl *)refreshControl {
    // Prepare the UI
    NSString *query = self.searchBar.text;
    UIView *currentView = [self getCurrentView];
    if (refreshControl == nil && query.length == 0) {
        [MBProgressHUD showHUDAddedTo:currentView animated:YES];
    }
    
    NSString *urlString;
    if (query.length > 1) {
        urlString = [NSString stringWithFormat:MOVIE_SEARCH_API_URL, query, API_KEY];
    } else {
        urlString = [NSString stringWithFormat:MOVIE_LIST_API_URL, self.endpoint, API_KEY];
    }
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                  delegate:nil
                             delegateQueue:[NSOperationQueue mainQueue]];
    if (self.dataTask != nil) {
        [self.dataTask cancel];
    }
    
    self.dataTask = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData * _Nullable data,
                                                                NSURLResponse * _Nullable response,
                                                                NSError * _Nullable error) {
                                                if (!error) {
                                                    NSError *jsonError = nil;
                                                    NSDictionary *responseDictionary =
                                                    [NSJSONSerialization JSONObjectWithData:data
                                                                                    options:kNilOptions
                                                                                      error:&jsonError];
                                                    NSArray *results = responseDictionary[@"results"];
                                                    NSMutableArray *models = [NSMutableArray array];
                                                    for (NSDictionary *result in results) {
                                                        MovieModel *model = [[MovieModel alloc] initWithDictionary:result];
                                                        [models addObject:model];
                                                    }
                                                    self.movies = models;
                                                    [self.moviesView reloadData];
                                                    [self.collectionView reloadData];
                                                    self.errorView.hidden = YES;
                                                } else {
                                                    if (error.code != -999) { // -999 is "cancelled"
                                                        self.errorView.hidden = NO;
                                                    } else {
                                                        self.errorView.hidden = YES;
                                                    }
                                                    NSLog(@"An error occurred: %@", error.description);
                                                }
                                                if (refreshControl != nil) {
                                                    [refreshControl endRefreshing];
                                                } else {
                                                    [MBProgressHUD hideHUDForView:currentView animated:YES];
                                                }
                                                self.dataTask = nil;
                                            }];
    [self.dataTask resume];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieCell *movieCell = [tableView dequeueReusableCellWithIdentifier:@"movieCell"];
    MovieModel *model = [self.movies objectAtIndex:indexPath.row];
    [movieCell.titleLabel setText: model.title];
    [movieCell.overviewLabel setText: model.overview];
    NSString *urlString = [NSString stringWithFormat:POSTER_MEDIUM_SIZE_URL, model.posterPath];
    [ImageLoader loadImage:movieCell.posterImage fromURL:[NSURL URLWithString:urlString]];

    return movieCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MovieDetailViewController *movieDetailViewController = [segue destinationViewController];
    NSIndexPath *indexPath;
    if(self.layoutControl.selectedSegmentIndex == LIST_VIEW_INDEX) {
        indexPath = [self.moviesView indexPathForCell:sender];
    } else if (self.layoutControl.selectedSegmentIndex == GRID_VIEW_INDEX) {
        indexPath = [self.collectionView indexPathForCell:sender];
    }
    movieDetailViewController.movie = [self.movies objectAtIndex:indexPath.row];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.movies.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MovieCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCollectionViewCell" forIndexPath:indexPath];
    MovieModel *model = [self.movies objectAtIndex:indexPath.row];
    cell.model = model;
    [cell reloadData];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"movieDetailsSegue" sender:[collectionView cellForItemAtIndexPath:indexPath]];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.collectionView.frame = self.view.bounds;
}

- (void) updateLayout:(UISegmentedControl *) sender {
    if(sender.selectedSegmentIndex == LIST_VIEW_INDEX) {
        [self.moviesView reloadData];
        self.collectionView.hidden = YES;
        self.moviesView.hidden = NO;
    } else if (sender.selectedSegmentIndex == GRID_VIEW_INDEX) {
        [self.collectionView reloadData];
        self.moviesView.hidden = YES;
        self.collectionView.hidden = NO;
    }
}

- (UIScrollView *) getCurrentView {
    int index = (int) self.layoutControl.selectedSegmentIndex;
    if (index == LIST_VIEW_INDEX) {
        return self.moviesView;
    } else if (index == GRID_VIEW_INDEX) {
        return self.collectionView;
    }
    return nil;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    UIScrollView *currentView = [self getCurrentView];
    [currentView setContentOffset:CGPointMake(0, -currentView.contentInset.top) animated:NO];
    [self fetchMovies:nil];
}

@end
