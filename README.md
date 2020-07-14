Original App Design Project - README Template
===

# Scan to Shop

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
[Scan to shop will be an app to scan barcodes from items you wish to lookup in the internet to see if a better deal is found.]

### App Evaluation
[Evaluation of your app across the following attributes]
- **Category:** Shopping
- **Mobile:** This app uses mobility as an advantage since most people have phones with a camera and internet. You could scan the item anywhere you can take your phone to.
- **Story:** Allow users to share great deals they found using the scan items to shop app.
- **Market:** Anyone that likes shopping online and wants to see if there is a better deal for what they are currently getting.
- **Habit:** User can compare as many items as they want as many times as they want. 
- **Scope:** Scan to shop will use the camera to scan bar codes and look for prices at online stores. 

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* User can create an account
* User can login/logout from account
* User can use the camera and scan a barcode
* User can see deals related to the item the barcode was scanned from
* User can see details of a particular deal
* User can go to the sellers website to buy the item

**Optional Nice-to-have Stories**

* Users can search other users
* Users can follow other users
* Users can recommend deals (like)
* Users can view a feed/timeline of recommended deals

### 2. Screen Archetypes

* Login/Register
   * User is able to create an account
   * User is able to login/logout from account
* Creation
   * User can use the camera and scan a barcode
* Stream
   * User can see deals related to the item the barcode was scanned from
* Details
   * User can see deals related to the item the barcode was scanned from

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* [fill out your first tab]
* [fill out your second tab]
* [fill out your third tab]

**Flow Navigation** (Screen to Screen)

* Login Screen
   * Creation
* Registration Screen
   * Creation
* Creation
   * Stream 
* Stream
   * Details
* Details
   * Seller website 

## Wireframes
<img src="https://github.com/joeyhernandez1/ScanToShop/blob/master/wireframe_scantoshop.png" width=600>

### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

## Schema 

### Models

#### Deal
| Property       | Type         |Description                                |
| ------------- |:-------------:| -----------------------------------------:|
| Seller Platform        | String        | Name of the seller for the particular deal|
| Image         | URL           | Image of the particular item.             |
| Description   | String        | Bried description of the item             |
| Name          | String        | Name of the item looking deals for        |
| Item URL      | URL           | URL to buy the item                       |
| Description   | String        | Bried description of the item             |

#### User
| Property       | Type         |Description                                |
| ------------- |:-------------:| -----------------------------------------:|
| Name          | String        | Full name of the user                     |
| Image         | URL           | Profile picture                           |
| Email         | String        | User email                                |
| Password      | String        | Password of the user's account            |
| Deal          | Array         | Array of deals saved by the user          |

#### Seller
| Property       | Type         |Description                                |
| ------------- |:-------------:| -----------------------------------------:|
| Name          | String        | Full name of the user                     |
| Image         | URL           | Profile picture                           |
| Email         | String        | User email                                |
| Password      | String        | Password of the user's account            |
| Deal          | Array         | Array of deals saved by the user          |

### Networking
- (Read/GET) Query all deals for the item scanned
