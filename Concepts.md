# Concepts & Conventions

## Naming, Roles & Verbs

* **API == Aync API Spec**
  - is modelled for the consumer of the **API**, NOT the producer
* **Developer** or **Consumer**
  - developer in consuming organization
* **Developer Portal**
  - external facing portal where consumption **Developers**
    - find **API Products**
    - register themselves
    - create **APPs** from 1 or many **API Products**
    - view/download **APIs** contained in provisioned **APPs**
* **API Service Developer**
  - developer in exposing organization who creates a service that is exposed as an **API**
* **API Team**
  - team in exposing organization who
    - receive **APIs** from **API Service Developers**
    - combine 1 or many **APIs** into **API Products**
    - publish **API Products** to the **Developer Portal**
    - manages **Permissions**
      - per **API Product**
      - per **APP** for a specific **Developer**
    - approves **APPs** for **Developers**
 * **Environment**
   - a physical, deployed API gateway broker with certain capabilities & capacity
     - protocols - the protocols supported

## Workflow Details

_Note: **APIs** are defined with the **view of the consumer**, NOT the producer._

### Example: Elevator Alarms are published for Regional Maintenance Companies.

* **API Service Developer**
  - writes an **API Service** that
    - publishes guaranteed messages - alarms may not be lost and must arrive at least once
    - publishes them with highest priority - alarms should overtake any other messages for the **consumer/developer**
    - therefor chooses to implement the service using protocol SMF for publishing alarms - which supports those features
    - chooses dynamic topics that include _region_ and _elevator-id_ in the topic - so that these can be set in permissions for each **consumer/developer**
    - chooses to only use payload to convey information - no SMF proprietary features, so that protocol translation works 1:1 and the **API** can be consumed using a wide variety of protocols
  - writes an alarm **Async API Spec** with:
    - a channel with paramters
    - add a full list of channel parameter values (enums) that the service will publish on and can be used for permissioning
      - example: region = ['fr', 'de', 'us-east', 'us-west']
    - but also chooses NOT to put a full list of _elevator-ids_ into the **API** - as new ones are added too frequently
    - a publish section - denoting that the **consumer/developer** will receive messages and therefor needs to create a subscriber
    - **a bindings section that**
      - contains a list of protocols that make sense to be used by the **consumer/developer** - protocol translation is seamless from SMF to these protocols
        - (choosing a protocol other than one listed here may or may not result in a different service experience)
      - always includes a version number - e.g. mqtt 3.1.1 is a different protocol than mqtt 5
      - _**note: bindings are hints for the API Team rather than interpreted or deployed configuration**_
  - sends **API** over to the **API Team**

* **API Team**
  - creates a new **API Product** which contains the **API** alarm
  - looks at the **Environments** available - to see which protocols they support
    - chooses 1 or many **Environments** the **API Product** should be available on
  - assigns protocols - based on the protocols supported by the **Environments** chosen
    - for example:
      - the binding hints that _mqtt 3.1.1_ is supported by the **API Service**
      - sees that at least 1 **Environment** supports:
        - _mqtt 3.1.1_, _secure-mqtt 3.1.1_, _ws-mqtt 3.1.1_, _wss-mqtt 3.1.1_
      - chooses all availabe mqtt based protocols for the **API Product**
  - chooses to enforce manual approval of any **Developer** **APP**
    - since no **Developer** should have access to ALL alarms from ALL elevators, but only the ones they have contracted to maintain
* **Developer**
  - creates their **APP** with **API Product**=alarm
  - waits for approval
* **API Team**
  - sees the request for approval
  - checks **Developers** identity and which maintenance organization they belong to
  - assigns permissions:
    - e.g. _region_='us-east' only and _elevator_ids_=['1', '2', '3', '4']
  - approves the **APP**
    - at this stage the **APP** is provisioned on the **Environment(s)**
* **Developer**
  - retrieves details for the **APP**
    - connection strings and credentials per protocol per **Environment**
  - sees the permissions
    - a list of topics they are allowed to subscribe to
  - downloads **Async API Spec** for alarms
  - develops their app ...





---
