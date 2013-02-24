//
// Created by dpostigo on 9/26/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "ToonInfoCell.h"
#import "Toon.h"
#import "UIView+Toons.h"
#import "StarRatingView.h"
#import "UIImage+Addons.h"

@implementation ToonInfoCell {
}

@synthesize toonObject;
@synthesize statsView;
@synthesize likesLabel;
@synthesize emailLabel;
@synthesize padding;


- (void) dealloc {
    [toonObject release];
    [statsView release];
    [likesLabel release];
    [emailLabel release];
    [super dealloc];
}



- (id) initWithStyle: (UITableViewCellStyle) style reuseIdentifier: (NSString *) reuseIdentifier toon: (Toon *) aToon {
    self = [super initWithStyle: style reuseIdentifier: reuseIdentifier];
    if (self) {

        toonObject = [aToon retain];

        padding = 10;


        [self formatTextLabel: self.textLabel string: toonObject.descriptionText];
        self.textLabel.text = toonObject.descriptionText;
        self.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        self.textLabel.numberOfLines = 0;
        self.textLabel.font = [UIFont systemFontOfSize: 12.0];

        CGSize size = [toonObject.descriptionText sizeWithFont: self.textLabel.font constrainedToSize: CGSizeMake(self.width, 20000.0f) lineBreakMode: UILineBreakModeWordWrap];
        CGFloat infoHeight = size.height + 60;
        self.textLabel.width = self.width - 10;
        [self.textLabel sizeToFit];
        self.height = infoHeight;
        self.backgroundView = [[[UIView alloc] initWithFrame: CGRectZero] autorelease];


        [self createStatsView];
        [self.contentView addSubview: self.statsView];
        [self.contentView addSubview: self.textLabel];

        self.textLabel.top = statsView.height + 25;


    }

    return self;
}

- (void) createStatsView {

    self.statsView = [[[UIView alloc] init] autorelease];

    StarRatingView *ratingView = [[[StarRatingView alloc] init] autorelease];
    ratingView.rating = (float) toonObject.rating;
    [statsView addSubview: ratingView];
    ratingView.left = 12;

    UILabel *viewsLabel = [[[UILabel alloc] initWithFrame: CGRectMake(0, 0, 10, 10)] autorelease];
    viewsLabel.textAlignment = UITextAlignmentLeft;
    viewsLabel.text = [NSString stringWithFormat: @"%@ views", toonObject.viewCountString];
    viewsLabel.textColor = [UIColor whiteColor];
    viewsLabel.backgroundColor = [UIColor clearColor];
    viewsLabel.font = [UIFont boldSystemFontOfSize: 11.0];
    [viewsLabel sizeToFit];
    [statsView addSubview: viewsLabel];

    viewsLabel.left = ratingView.left + ratingView.width + padding;
    viewsLabel.centerY = ratingView.height / 2;


    UIImage *image = [[UIImage newImageFromResource: @"thumbsup-icon.png"] autorelease];
    UIImageView *likesIcon = [[[UIImageView alloc] initWithImage: image] autorelease];
    self.likesLabel = [self labelFromLabel: viewsLabel];
    likesLabel.text = [NSString stringWithFormat: @"%d", toonObject.likeCount];
    [likesLabel sizeToFit];

    likesIcon.left = viewsLabel.left + viewsLabel.width + padding;
    likesLabel.left = likesIcon.left + likesIcon.width + padding / 2;
    likesIcon.top = -2;
    statsView.width = self.width;
    statsView.height = ratingView.height + 20;

    [statsView addSubview: likesIcon];
    [statsView addSubview: likesLabel];



    [self createEmailStats];

}

- (void) createEmailStats {

    if (toonObject.emailCount > 0) {

        UIImageView *emailIcon = [[[UIImageView alloc] initWithImage: [[UIImage newImageFromResource: @"email_count_icon.png"] autorelease]] autorelease];

        self.emailLabel = [self labelFromLabel: likesLabel];
        emailLabel.text = [NSString stringWithFormat: @"%d", toonObject.emailCount];
        [emailLabel sizeToFit];

        emailIcon.left = likesLabel.left + likesLabel.width + padding * 1.5;
        emailLabel.left = emailIcon.left + emailIcon.width + padding / 2;
        emailIcon.centerY = emailLabel.centerY;

        [statsView addSubview: emailIcon];
        [statsView addSubview: emailLabel];
    }

}



@end