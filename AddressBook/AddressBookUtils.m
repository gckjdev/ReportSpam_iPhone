//
//  AddressBookUtils.m
//  three20test
//
//  Created by qqn_pipi on 10-3-19.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import "AddressBookUtils.h"

@implementation PPContact

@synthesize person;
@synthesize personId;
@synthesize name;

- (id)initWithPerson:(ABRecordRef)personValue personId:(ABRecordID)personIdValue
{
	if (self = [super init]){
		self.person = personValue;
		self.personId = personIdValue;
		self.name = [AddressBookUtils getFullName:personValue];
	}
	
	return self;
}

- (NSString*)stringForGroup
{
	return [AddressBookUtils getFullName:person];
}

- (void)dealloc
{
	[name release];
	[super dealloc];
}

@end

@implementation PPGroup

@synthesize group;
@synthesize groupId;
@synthesize name;

- (id)initWithGroup:(ABRecordRef)groupVal groupId:(ABRecordID)groupIdVal name:(NSString*)nameVal
{
	if (self = [super init]){
		self.group = groupVal;
		self.groupId = groupIdVal;
		self.name = nameVal;
	}
	
	return self;
}

- (void)dealloc
{
	[name release];
	[super dealloc];
}

@end


@implementation AddressBookUtils

+ (NSString*)getPersonNameByPhone:(NSString*)phone addressBook:(ABAddressBookRef)addressBook
{
	ABRecordRef personRef = [AddressBookUtils getPersonByPhone:phone addressBook:addressBook];
	if (personRef == NULL){
		return @"";
	}
	else {
		return [AddressBookUtils getFullName:personRef];
	}

}

+ (ABRecordRef)getPersonByName:(NSString*)name addressBook:(ABAddressBookRef)addressBook
{
	if (name == nil || [name length] <= 0 || addressBook == NULL)
		return NULL;
    
	NSArray* people = (NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
	ABRecordRef retPersonRef = NULL;
	
	for (NSObject* person in people){
		ABRecordRef personRef = (ABRecordRef)person;
		
        NSString* fullName = [AddressBookUtils getFullName:personRef];
        if ([name isEqualToString:fullName]){
            // found
			retPersonRef = person;
			break;
		}
	}
	
	[people release];	
	return retPersonRef;
}


+ (ABRecordRef)getPersonByPhone:(NSString*)phone addressBook:(ABAddressBookRef)addressBook
{
	if (phone == nil || [phone length] <= 0 || addressBook == NULL)
		return NULL;
			
	NSArray* people = (NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
	ABRecordRef retPersonRef = NULL;
	
	BOOL found = NO;
	for (NSObject* person in people){
		ABRecordRef personRef = (ABRecordRef)person;
		
		NSArray* phonesOfPerson = [AddressBookUtils getPhones:personRef];
		for (NSString* phoneOfPerson in phonesOfPerson){
			// performance is so so, can be improved if needed
			if ([phone isEqualToString:phoneOfPerson] == YES){
				found = YES;
				break;
			}
			else 
			{
				phoneOfPerson = [phoneOfPerson stringByReplacingOccurrencesOfString:@"(" withString:@""];
				phoneOfPerson = [phoneOfPerson stringByReplacingOccurrencesOfString:@")" withString:@""];
				phoneOfPerson = [phoneOfPerson stringByReplacingOccurrencesOfString:@"-" withString:@""];
				phoneOfPerson = [phoneOfPerson stringByReplacingOccurrencesOfString:@" " withString:@""];
				phoneOfPerson = [phoneOfPerson stringByReplacingOccurrencesOfString:@"+" withString:@""];
				if ([phone isEqualToString:phoneOfPerson] == YES){
					found = YES;
					break;
				}
			}

		}
		
		if (found){
			retPersonRef = person;
			break;
		}
	}
	
	[people release];
	
	return retPersonRef;
}



// return label, but remove prefix and suffix in "_$!<Mobile>!$_"
+ (NSString *)getPhoneLabel:(ABMultiValueRef)phones index:(int)index
{
	NSString* origLabel = (NSString *)ABMultiValueCopyLabelAtIndex(phones, index);	
	
	NSString* localizedLabel = (NSString *)ABAddressBookCopyLocalizedLabel((CFStringRef)origLabel);
	
	NSString* finalLabel = [NSString stringWithString:localizedLabel];
	
	finalLabel = [finalLabel stringByReplacingOccurrencesOfString:@"_$!<" withString:@""];
	finalLabel = [finalLabel stringByReplacingOccurrencesOfString:@">!$_" withString:@""];	
	
	[localizedLabel release];
	[origLabel release];
	
	return finalLabel;
}

+ (NSString*)getPhoneLabel:(ABRecordRef)person phone:(NSString*)phone
{
	BOOL found = NO;
	NSString* returnLabel = [NSString stringWithString:@""];
	
	ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);	
	if (phones){
		int count = ABMultiValueGetCount(phones);
		for (CFIndex i = 0; i < count; i++) {
			NSString *phoneLabel       = (NSString *)ABMultiValueCopyLabelAtIndex(phones, i);
			NSString *phoneNumber      = (NSString *)ABMultiValueCopyValueAtIndex(phones, i);

			if (phoneNumber != nil && [phoneNumber isEqualToString:phone]){
				// found
				found = YES;				
			}			
			
			if (found){
				NSString* localizedLabel = (NSString *)ABAddressBookCopyLocalizedLabel((CFStringRef)phoneLabel);			
				returnLabel = [NSString stringWithString:localizedLabel];
				
				returnLabel = [returnLabel stringByReplacingOccurrencesOfString:@"_$!<" withString:@""];
				returnLabel = [returnLabel stringByReplacingOccurrencesOfString:@">!$_" withString:@""];	
				
				[localizedLabel release];
			}

			[phoneLabel release];
			[phoneNumber release];
			
			if (found){
				break;
			}
		}
	}
	CFRelease(phones);
	
	return returnLabel;
	
}

+ (NSDate*)copyModificationDate:(ABRecordRef)person
{
	NSDate* date = (NSDate *)ABRecordCopyValue(person, kABPersonModificationDateProperty);
	
//	NSLog(@"latest date is %@", date);
	
	return date;
}

+ (NSString *)getFullName:(ABAddressBookRef)addressBook personId:(int)personId
{
	ABRecordRef personRef = ABAddressBookGetPersonWithRecordID(addressBook, personId);
	if (!personRef)
		return nil;
	else {
		return [AddressBookUtils getFullName:personRef];
	}

}

+ (NSString *)getFullName:(ABRecordRef)person
{

	/*
	NSString* countryCode = [LocaleUtils getCountryCode];
	if (countryCode != nil && ( [countryCode isEqualToString:@"CN"] == YES || 
							   [countryCode isEqualToString:@"TW"] == YES ||
							   [countryCode isEqualToString:@"KR"] == YES ||
							   [countryCode isEqualToString:@"JP"] == YES))								   
	{
	}
	else{
	}
	*/
		
	
	CFStringRef name = ABRecordCopyCompositeName(person);
	if (name == NULL){
		return [NSString stringWithString:@""];
	}
	
	NSString* ret = [NSString stringWithString:(NSString*)name];
	
	CFRelease(name);
	
	return ret;
	
	/*
	NSString* firstName = (NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
	NSString* lastName  = (NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
	NSString* orgName = (NSString *)ABRecordCopyValue(person, kABPersonOrganizationProperty);
	
	BOOL useOrgName = NO;
	
	if (firstName == nil && lastName == nil)
		useOrgName = YES;
	
	if (firstName == nil)
		firstName = @"";
	
	if (lastName == nil)
		lastName = @"";		
	
	NSString* fullName;
	
	if (useOrgName == NO){
		if ([[LocaleUtils getCountryCode] isEqualToString:@"CN"] == YES){
			if ([lastName length] > 0){
				fullName = [NSString stringWithFormat:@"%@ %@", lastName, firstName];	
			}
			else {
				fullName = [NSString stringWithString:firstName];
			}

		}
		else {
			if ([firstName length] > 0){
				fullName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];	
			}
			else {
				fullName = [NSString stringWithString:lastName];
			}

		}	
	}
	else {
		
		if (orgName == nil)
			orgName = @"";
		
		fullName = [NSString stringWithFormat:@"%@", orgName];
	}
	
	[firstName release];
	[lastName release];
	[orgName release];
	 
	
	return fullName;
	 */ 
}

+ (NSArray *)getPhonesWithAddressBook:(ABRecordID)personId addressBook:(ABAddressBookRef)addressBook
{
	ABRecordRef person = ABAddressBookGetPersonWithRecordID(addressBook, personId);
	if (person){
		return [AddressBookUtils getPhones:person];
	}
	else {
		return nil;
	}
}

// get the first phone number to display

+ (BOOL)hasPhones:(ABRecordRef)person
{
	NSArray* phones = [AddressBookUtils getPhones:person];
	if (phones != nil && [phones count] > 0){
		return YES;
	}
	else {
		return NO;
	}

}

+ (BOOL)hasEmails:(ABRecordRef)person
{
	NSArray* emails = [AddressBookUtils getEmails:person];
	if (emails != nil && [emails count] > 0){
		return YES;
	}
	else {
		return NO;
	}
	
}

+ (BOOL)hasMobiles:(ABRecordRef)person
{
	BOOL ret = NO;
	
	ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);	
	if (phones){
		int count = ABMultiValueGetCount(phones);
		for (CFIndex i = 0; i < count; i++) {
			NSString *phoneLabel       = (NSString *)ABMultiValueCopyLabelAtIndex(phones, i);
//			NSString *phoneNumber      = (NSString *)ABMultiValueCopyValueAtIndex(phones, i);
			
//			NSLog(@"phone label (%@), number (%@)", phoneLabel, phoneNumber);
			
//			[phoneList addObject:phoneNumber];

			if ([phoneLabel isEqualToString:@"_$!<Mobile>!$_"] ||
				[phoneLabel isEqualToString:@"iPhone"] )
			{
				ret = YES;
			}
			
			[phoneLabel release];
			
			if (ret){
				break;
			}
		}
	}
	CFRelease(phones);
	
	return ret;
	
}

+ (NSString *)getFirstMobilePhone:(ABRecordRef)person
{
	NSString* mobile = nil;
	NSString* iPhone = nil;
	NSString* main = nil;
	
	ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);	
	if (phones){
		int count = ABMultiValueGetCount(phones);
		for (CFIndex i = 0; i < count; i++) {
			NSString *phoneLabel       = (NSString *)ABMultiValueCopyLabelAtIndex(phones, i);
			NSString *phoneNumber      = (NSString *)ABMultiValueCopyValueAtIndex(phones, i);
			
//			NSLog(@"phone label (%@), number (%@)", phoneLabel, phoneNumber);
			
			if ([phoneLabel isEqualToString:@"_$!<Mobile>!$_"])
			{
				mobile = [NSString stringWithString:phoneNumber];
			}			
			else if ([phoneLabel isEqualToString:@"iPhone"]){
				iPhone = [NSString stringWithString:phoneNumber];				
			}
			else if ([phoneLabel isEqualToString:@"_$!<Main>!$_"]){
				main = [NSString stringWithString:phoneNumber];
			}
			
			[phoneLabel release];
			[phoneNumber release];
		}
	}
	CFRelease(phones);
	
	if (iPhone != nil && [iPhone length] > 0)
		return iPhone;
	
	if (mobile != nil && [mobile length] > 0)
		return mobile;

	if (main != nil && [main length] > 0)
		return main;
	
	return nil;
}

+ (NSArray *)getMobilePhones:(ABRecordRef)person
{
	NSMutableArray* phoneList = [[[NSMutableArray alloc] init] autorelease];
	
	ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);	
	if (phones){
		int count = ABMultiValueGetCount(phones);
		for (CFIndex i = 0; i < count; i++) {
			NSString *phoneLabel       = (NSString *)ABMultiValueCopyLabelAtIndex(phones, i);
			NSString *phoneNumber      = (NSString *)ABMultiValueCopyValueAtIndex(phones, i);
			
//			NSLog(@"phone label (%@), number (%@)", phoneLabel, phoneNumber);

			if ([phoneLabel isEqualToString:@"_$!<Mobile>!$_"] ||
				[phoneLabel isEqualToString:@"iPhone"] )
			{
				// it's mobile, then add the objects
				[phoneList addObject:phoneNumber];
			}			
			
			[phoneLabel release];
			[phoneNumber release];
		}
	}
	CFRelease(phones);
	
	return phoneList;
}


+ (NSArray *)getPhones:(ABRecordRef)person
{
	NSMutableArray* phoneList = [[[NSMutableArray alloc] init] autorelease];
	
	ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);	
	if (phones){
		int count = ABMultiValueGetCount(phones);
		for (CFIndex i = 0; i < count; i++) {
			NSString *phoneLabel       = (NSString *)ABMultiValueCopyLabelAtIndex(phones, i);
			NSString *phoneNumber      = (NSString *)ABMultiValueCopyValueAtIndex(phones, i);
			
			//NSLog(@"phone label (%@), number (%@)", phoneLabel, phoneNumber);
			
			[phoneList addObject:phoneNumber];
			
			[phoneLabel release];
			[phoneNumber release];
		}
	}
	CFRelease(phones);

	return phoneList;
	
	
}

+ (NSArray *)getAllLabelAndPhone:(ABRecordRef)person
{
	NSMutableArray* phoneList = [[[NSMutableArray alloc] init] autorelease];
	
	ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);	
	if (phones){
		int count = ABMultiValueGetCount(phones);
		for (CFIndex i = 0; i < count; i++) {
			NSString *phoneLabel       = (NSString *)ABMultiValueCopyLabelAtIndex(phones, i);
			NSString *phoneNumber      = (NSString *)ABMultiValueCopyValueAtIndex(phones, i);
			
			//NSLog(@"phone label (%@), number (%@)", phoneLabel, phoneNumber);
			
            [phoneList addObject:phoneLabel];
			[phoneList addObject:phoneNumber];
			
			[phoneLabel release];
			[phoneNumber release];
		}
	}
	CFRelease(phones);
    
	return phoneList;
}


+ (NSString*)getPhoneWithPerson:(ABRecordRef)person identifier:(ABMultiValueIdentifier)identifier property:(ABPropertyID)property
{
	NSString* retPhone = nil;
	ABMultiValueRef phones = ABRecordCopyValue(person, property);	

	if (phones){
		CFIndex index = ABMultiValueGetIndexForIdentifier(phones, identifier);
		NSString* phone = (NSString*)ABMultiValueCopyValueAtIndex(phones, index);
		retPhone = [NSString stringWithString:phone];		
		[phone release];		
	}

	CFRelease(phones);	

	return retPhone;
}

+ (NSArray *)getEmailsWithAddressBook:(ABRecordID)personId addressBook:(ABAddressBookRef)addressBook
{
	ABRecordRef person = ABAddressBookGetPersonWithRecordID(addressBook, personId);
	if (person){
		return [AddressBookUtils getEmails:person];
	}
	else {
		return nil;
	}
}

+ (NSString *)getFirstEmail:(ABRecordRef)person
{
	NSArray* emailArr = [AddressBookUtils getEmails:person];
	if (emailArr != nil && [emailArr count] > 0)
		return [emailArr objectAtIndex:0];
	else
		return nil;
}

// can be refactored to the same implementation later
+ (NSArray *)getEmails:(ABRecordRef)person
{
	NSMutableArray* emailList = [[[NSMutableArray alloc] init] autorelease];
	
	ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);	
	if (emails){
		for (CFIndex i = 0; i < ABMultiValueGetCount(emails); i++) {
			NSString *label       = (NSString *)ABMultiValueCopyLabelAtIndex(emails, i);
			NSString *value      = (NSString *)ABMultiValueCopyValueAtIndex(emails, i);
			
//			NSLog(@"email label (%@), number (%@)", label, value);
			
			[emailList addObject:value];
			
			[label release];
			[value release];
		}
	}
	CFRelease(emails);
	
	return emailList;
}

+ (UIImage*)getImageByPerson:(ABRecordRef)person
{
	UIImage* image = nil;
	
	if (ABPersonHasImageData(person)){
		
//		NSData* data = (NSData *)ABPersonCopyImageData(person);

		NSData* data = (NSData *)ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatOriginalSize);		
		image = [UIImage imageWithData:data];		
		[data release];
	}
	
	return image;	
}


+ (UIImage*)getThumbnailImage:(ABRecordRef)person
{
	NSData* data = (NSData*)ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail);
	UIImage* image = [[[UIImage alloc] initWithData:data] autorelease];
	[data release];
	return image;
}

+ (BOOL)removePhone:(ABRecordRef)person phone:(NSString*)phone
{
    ABMultiValueRef multi = ABRecordCopyValue(person, kABPersonPhoneProperty);
    
    ABMutableMultiValueRef mutablemulti = ABMultiValueCreateMutableCopy(multi);
    
	CFErrorRef anError = NULL;
	
	// The multivalue identifier of the new value isn't used in this example,
	// multivalueIdentifier is just for illustration purposes.  Real-world
	// code can use this identifier to do additional work with this value.
    
    CFIndex index = ABMultiValueGetFirstIndexOfValue(multi, (CFStringRef)phone);
    
   	if (!ABMultiValueRemoveValueAndLabelAtIndex(mutablemulti, index)){
        CFRelease(multi);
		CFRelease(mutablemulti);
		return NO;
	}
    
	if (!ABRecordSetValue(person, kABPersonPhoneProperty, mutablemulti, &anError)){
		CFRelease(multi);
        CFRelease(mutablemulti);
		return NO;
	}
    
    CFRelease(multi);
	CFRelease(mutablemulti);
	return YES;
}

+ (BOOL)addPhone:(ABRecordRef)person phone:(NSString*)phone label:(NSString*)label
{
    ABMultiValueRef multi = ABRecordCopyValue(person, kABPersonPhoneProperty);
    
    ABMutableMultiValueRef mutablemulti = ABMultiValueCreateMutableCopy(multi);
    
	CFErrorRef anError = NULL;
    
	// The multivalue identifier of the new value isn't used in this example,
	// multivalueIdentifier is just for illustration purposes.  Real-world
	// code can use this identifier to do additional work with this value.
    
    
    //查找在此联系人下是否已经有这个号码
    CFIndex index = ABMultiValueGetFirstIndexOfValue(multi, (CFStringRef)phone);
    
    //已经有这个号码则修改
    if (index>=0)
    {
        if (!ABMultiValueReplaceLabelAtIndex(mutablemulti, (CFStringRef)label, index)){
            CFRelease(multi);
            CFRelease(mutablemulti);
            return NO;
        }
    }
    else
    {
        ABMultiValueIdentifier multivalueIdentifier;
        
        if (!ABMultiValueAddValueAndLabel(mutablemulti, (CFStringRef)phone, (CFStringRef)label, &multivalueIdentifier)){
            CFRelease(multi);
            CFRelease(mutablemulti);
            return NO;
        }
    }
	
    
	if (!ABRecordSetValue(person, kABPersonPhoneProperty, mutablemulti, &anError)){
		CFRelease(multi);
        CFRelease(mutablemulti);
		return NO;
	}
    
    CFRelease(multi);
	CFRelease(mutablemulti);
	return YES;
}


+ (BOOL)addPhone:(ABRecordRef)person phone:(NSString*)phone
{
	ABMutableMultiValueRef multi = ABMultiValueCreateMutable(kABMultiStringPropertyType);
	
	CFErrorRef anError = NULL;
	
	// The multivalue identifier of the new value isn't used in this example,
	// multivalueIdentifier is just for illustration purposes.  Real-world
	// code can use this identifier to do additional work with this value.
	ABMultiValueIdentifier multivalueIdentifier;
	
	if (!ABMultiValueAddValueAndLabel(multi, (CFStringRef)phone, kABPersonPhoneMainLabel, &multivalueIdentifier)){
		CFRelease(multi);
		return NO;
	}
		
	if (!ABRecordSetValue(person, kABPersonPhoneProperty, multi, &anError)){
		CFRelease(multi);
		return NO;
	}

	CFRelease(multi);
	return YES;
}

+ (BOOL)addAddress:(ABRecordRef)person street:(NSString*)street
{
	ABMutableMultiValueRef address = ABMultiValueCreateMutable(kABDictionaryPropertyType);
	
	static int  homeLableValueCount = 5;
	
	// Set up keys and values for the dictionary.
	CFStringRef keys[homeLableValueCount];
	CFStringRef values[homeLableValueCount];
	keys[0]      = kABPersonAddressStreetKey;
	keys[1]      = kABPersonAddressCityKey;
	keys[2]      = kABPersonAddressStateKey;
	keys[3]      = kABPersonAddressZIPKey;
	keys[4]      = kABPersonAddressCountryKey;
	values[0]    = (CFStringRef)street;
	values[1]    = CFSTR("");
	values[2]    = CFSTR("");
	values[3]    = CFSTR("");
	values[4]    = CFSTR("");
	
	CFDictionaryRef aDict = CFDictionaryCreate(
											   kCFAllocatorDefault,
											   (void *)keys,
											   (void *)values,
											   homeLableValueCount,
											   &kCFCopyStringDictionaryKeyCallBacks,
											   &kCFTypeDictionaryValueCallBacks
											   );
	
	// Add the street address to the person record.
	ABMultiValueIdentifier identifier;
	
	BOOL result = ABMultiValueAddValueAndLabel(address, aDict, kABHomeLabel, &identifier);	

	CFErrorRef error = NULL;
	result = ABRecordSetValue(person, kABPersonAddressProperty, address, &error);
	
	CFRelease(aDict);	
	CFRelease(address);	
	
	return result;
}

+ (BOOL)addImage:(ABRecordRef)person image:(UIImage*)image
{
	CFErrorRef error = NULL;
	
	// remove old image data firstly
	ABPersonRemoveImageData(person, NULL);
	
	// add new image data
	BOOL result = ABPersonSetImageData (
							   person,
							   (CFDataRef)UIImagePNGRepresentation(image),
							   &error
							   );	
	
//	CFRelease(error);
	
	return result;
}

//+ (NSMutableArray *)queryContact:(NSString*)searchText addressBook:(ABAddressBookRef)addressBook
//{
//	NSArray* allPeople;
//	NSArray* sortedAllPeople;
//	
//	if (searchText != nil && [searchText length] > 0){		
//		allPeople = (NSArray*)ABAddressBookCopyPeopleWithName(addressBook, (CFStringRef)searchText);					
//	}
//	else {		
//		allPeople = (NSArray*)ABAddressBookCopyArrayOfAllPeople(addressBook);		
//	}
//	
//	if (allPeople == nil)
//		return nil;
//	
//	ABPersonSortOrdering sortOrdering = kABPersonSortByLastName;						
//	sortedAllPeople = [allPeople sortedArrayUsingFunction:ABPersonComparePeopleByName context:(void*)sortOrdering];
//	
//	if (sortedAllPeople == nil){
//		[allPeople release];
//		return nil;
//	}
//	
//	NSMutableArray* list = [[[NSMutableArray alloc] init] autorelease];			
//	for (NSObject* obj in sortedAllPeople){	
//		ABRecordRef person = (ABRecordRef)obj;
//		PPContact* contact = [[PPContact alloc] initWithPerson:person personId:ABRecordGetRecordID(person)];
//		[list addObject:contact];	
//		[contact release];
//	}	
//	
//	[allPeople release];	
//	return list;
//}


//+ (NSMutableArray *)queryAllContact:(ABAddressBookRef)addressBook
//{
//	return [AddressBookUtils queryContact:nil addressBook:addressBook];
//}


+ (BOOL)isPersonNew:(ABRecordRef)person lastCheckDate:(NSDate*)lastCheckDate
{
	if (person != NULL){
		NSDate* createDate = (NSDate*) ABRecordCopyValue( person, kABPersonCreationDateProperty );
		BOOL ret = [lastCheckDate timeIntervalSinceDate:createDate] < 0;
		[createDate release];
		return ret;
	}
	
	return NO;
}

+ (BOOL)isPersonModify:(ABRecordRef)person lastCheckDate:(NSDate*)lastCheckDate
{
	if (person != NULL){
		NSDate* modifyDate = (NSDate*) ABRecordCopyValue( person, kABPersonModificationDateProperty );
		BOOL ret = [lastCheckDate timeIntervalSinceDate:modifyDate] < 0;
		[modifyDate release];
		return ret;
	}
	
	return NO;	
}

@end
