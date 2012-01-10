//
//  ContactManager.m
//  ReportGarbageSMS
//
//  Created by haodong qiu on 12年1月7日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import "ContactManager.h"
#import "Contact.h"
#import "AddressBookUtils.h"


@implementation ContactManager

- (void)addContact:(Contact *)contact;
{
    ABAddressBookRef addressbookRef = ABAddressBookCreate();
    CFErrorRef error = NULL;
    
    ABRecordRef person = [AddressBookUtils getPersonByName:contact.person addressBook:addressbookRef];
    
    BOOL newPerson = NO;
    if (person == NULL){
        // not found, create new record
        person = ABPersonCreate(); 
        newPerson = YES;
        
        ABRecordSetValue(person, kABPersonFirstNameProperty, contact.person, &error);
        if (error != NULL){
            // fail
            CFRelease(person);
            CFRelease(addressbookRef);                
            return;
        }
        
        ABAddressBookAddRecord(addressbookRef, person, &error);        
        if (error != NULL){
            // fail
            CFRelease(person);
            CFRelease(addressbookRef);                
            return;
        }
    }
    
    // add phone
    [AddressBookUtils addPhone:person phone:contact.phone label:contact.phoneLabel];        
    
    // save address book
    ABAddressBookSave(addressbookRef, &error);
    if (error != NULL){
        // fail
    }
    
    if (newPerson) {
        CFRelease(person);
    }
    
    CFRelease(addressbookRef);
}

- (void)deleteContact:(Contact *)contact
{
    ABAddressBookRef addressbookRef = ABAddressBookCreate();
    CFErrorRef error = NULL;
    
    ABRecordRef person = [AddressBookUtils getPersonByName:contact.person addressBook:addressbookRef];
    if (person == NULL){
        CFRelease(addressbookRef);                
        return;
    }
    
    [AddressBookUtils removePhone:person phone:contact.phone];
    
    if (error != NULL){
        // fail
    }
    ABAddressBookSave(addressbookRef, &error);
    CFRelease(addressbookRef);
}

- (NSArray *)getAllPhoneAndLabel:(NSString *)personValue
{
    ABAddressBookRef addressbookRef = ABAddressBookCreate();
    
    ABRecordRef person = [AddressBookUtils getPersonByName:personValue addressBook:addressbookRef];
    
    CFErrorRef error = NULL;
    BOOL newPerson = NO;
    if (person == NULL){
        // not found, create new record
        person = ABPersonCreate(); 
        newPerson = YES;
        
        ABRecordSetValue(person, kABPersonFirstNameProperty, personValue, &error);
        if (error != NULL){
            // fail
            CFRelease(person);
            CFRelease(addressbookRef);                
            return nil;
        }
        
        ABAddressBookAddRecord(addressbookRef, person, &error);        
        if (error != NULL){
            // fail
            CFRelease(person);
            CFRelease(addressbookRef);                
            return nil;
        }
    }
    
	NSMutableArray* phoneList = [[[NSMutableArray alloc] init] autorelease];
	
	ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);	
	if (phones){
		int count = ABMultiValueGetCount(phones);
		for (CFIndex i = 0; i < count; i++) {
			NSString *phoneLabel       = (NSString *)ABMultiValueCopyLabelAtIndex(phones, i);
			NSString *phoneNumber      = (NSString *)ABMultiValueCopyValueAtIndex(phones, i);
			
            Contact *contact = [[Contact alloc] initWithPerson:personValue PhoneLabel:phoneLabel phone:phoneNumber];
            [phoneLabel release];
			[phoneNumber release];
            
            [phoneList addObject:contact];
            
            [contact release];
		}
	}
    
    if (newPerson) {
        CFRelease(person);
    }
	CFRelease(phones);
    CFRelease(addressbookRef);
    
	return phoneList;
}

@end
