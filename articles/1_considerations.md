# Considerations for Unifying Synchronous & Asynchronous API Management

Author: Ricardo Gomez-Ulmke | June 2021

## Introduction

TODO:
- the problem, the ask
- the goal
- what is explained here
- what isn't

### Example Use Cases for Our Discussion

In order to ascertain what mix of APIs we want to offer to our internal and external developers, we need to baseline our understanding of where Evented APIs vs. RESTful APIs apply.

Which in turn requires us to understand events themselves. A good overview, general discussion about Event-Driven Architectures (EDA) and the concept of an Event Mesh is offered in [[3]](#[3]) and [[4]](#[4]).

In a nutshell:
- Transactions - such as creating a purchase order - are more suited for RESTful or request-reply APIs
- Updates - such as a process update for a purchase order - are more suited for Evented APIs

Let's have a detailed look at some use cases which I will refer to throughout this article.

#### Connected Assets

The company ``ConnectedAssetsCo`` sells things like HVACs, Elevators, Escalators or any other type of machinery that requires maintenance.
As part of their digital transformation, they offer streaming data from these assets & business process integration to their partners, for example maintenance companies.

**The set-up:**
- assets are equipped with sensors which generate telemetry data
- sensors are connected to a global event mesh which forwards raw telemetry data streams to their central control & analytics applications
- based on the raw telemetry data and output from their analytics applications ``ConnectedAssetsCo`` offers APIs for ``MaintenanceCo`` to improve MTTR (mean-time-to-repair) and uptime of the assets at lower operating costs

**Volumetrics & Data:**
- connected assets: a few thousands to a couple of millions
- asset installation: global
- asset telemetry data:
  - scheduled - e.g. diagnostics data | frequency: every hour, predictable | urgency: low priority
  - real-time - e.g. alarm/fault | frequency: very low, unpredictable | urgency: high priority
- partner network: 10s in every region | only 1 partner company contracted per asset

**Alarm & Fault Management:**

Based on the raw telemetry data, the analytics application detects an alarm or fault.

``MaintenanceCo``:
- receive alarm/fault from assets contracted to maintain
- send acknowledgement that alarm/fault has been received to ``ConnectedAssetsCo``
- schedule maintenance and/or take immediate action depending on type of alarm/fault
- carry out maintenance
- send workflow updates to ``ConnectedAssetsCo``
  - action taken
  - maintenance scheduled
  - maintenance carried out
  - ...
  - alarm/fault has been resolved

``ConnectedAssetsCo``:
- alarm/fault event is sent to the contracted ``MaintenaceCo`` only
  - every event must be delivered
  - every event must be acted upon
- keeps track of alarms/fault sent
- keeps track of status updates received from ``MaintenaceCo``
- monitors agreed SLAs and escalates if SLAs not met

#### Connected Vehicles

The automotive company ``ConnectedVehiclesCo`` has enabled their fleet to send diagnostics, consumption and failure/alarm data to internal analytics and process applications.
In order to further monetize the raw telemetry data, ``ConnectedVehiclesCo`` offers real-time vehicle events and historical data via a marketplace to partners such as
insurance companies, fleet management companies, breakdown services, charging network, maintenance companies, etc.

**The set-up:**
- vehicles are connected to a global event mesh
- in-vehicle collected data & events are sent to their central control & analytics applications
- based on this vehicle data & events, ``ConnectedVehiclesCo`` offers APIs for ``MaintenaceCo`` to improve their owner/driver's experience, reduce maintenance costs of the vehicle and increase 'on-the-road' time

**Volumetrics & Data:**
- connected vehicles: up to 10s of millions
- geography: global
- telemetry data:
  - scheduled - e.g. diagnostics, consumption data | frequency: every hour, predictable | urgency: low priority
  - real-time - e.g. alarm/fault/breakdown | frequency: very low, unpredictable | urgency: high priority
- partner network: 10s in every region | multiple partner companies contracted per vehicle

**Safety/Failure/Breakdown Management**

Based on the vehicle telemetry data, an analytics application detects a safety issue, a failure situation or a breakdown and generates specific maintenance and/or breakdown events for their partner network.

``MaintenaceCo``:
- receive satety/failure event for contracted vehicles
- arranges appointment with owner
- report status updates to ``ConnectedVehiclesCo``

``BreakdownCo``:
- receive breakdown event for contracted vehicles
- arranges recovery with owner/driver
- report status updates to ``ConnectedVehiclesCo``

``Owner``/``Driver``:
- receive copy of event sent to contracted partner company
- receive notification from contracted ``MaintenaceCo`` and ``BreakdownCo`` to arrange servicing / recovery

``InsuranceCo``
- receive notification of breakdown & failure events
- arranges paperwork with partner company and owner

``ConnectedVehiclesCo``
- determines situation: safety issue/failure/breakdown
- generates correct event and send to contracted partner only (``MaintenaceCo`` or ``BreakdownCo``)
  - every event must be delivered
  - status updates must be received
- send event to owner/driver
- receive status updates from ``MaintenaceCo``/``BreakdownCo``

**Consumption, Diagnostics & Drive Data Management**

``InsuranceCo``:
- request regular updates of historical consumption & drive data for contracted vehicles
- adjusts premiums for owner

``MaintenaceCo``:
- receive predictive maintenance events
- schedules servicing with owner

``ConnectedVehiclesCo``:
- generate predictive maintenance events
- provide historical data on request


#### Order Capture & Management

The company ``WidgetCo`` manufactures and sells widges via it's own E-commerce site as well as through their partner network ``PartnerCo`` to increase their reach.

**Volumetrics & Data:**
- partner network: 100s to many thousands
- geography: global
- orders:
  - transactional
  - unpredictable volumes with very high peaks
- order updates
  - for 1 specific order from 1 specific partner
  - real-time, generated by the order management processes
  - every update must be delivered

**Order Management:**

Both, their own E-Commerce platform as well as their integration with partners use the same backend order management system.

``PartnerCo``:
- submit order
- receive instant feedback of successful submission
- receive stream of order updates from the order management process
- every order update must be received

``WidgetCo``:
- receive order
- send successful acceptance of order or failure response
- send order management status updates for correct order to correct ``PartnerCo``
- every order update must be sent

#### Flight Status Updates

A provider of flight status updates ``FlightStatusCo`` offers a set of APIs for ``TravelCo``s to monitor their client's booked flights for status updates in order to provide their travellers
a superior digital 'concierge-style' experience.

Note that ``TravelCo`` itself may have a partner network to interact with - e.g. drivers, hotels, restaurants, venues, ... However, I will not explore this here further.

_Note: Let's assume for a minute travelling and flying at 'normal' levels._

**Volumetrics & Data:**
- ``FlightStatusCo`` monitors all flights from all airlines globally
  - potentially thousands to 10s of thousand updates per second in peak times - e.g. during a disruption
  - calculates if any change happened and generates a flight-status-change event
- flight data feeds: 100s to low thousands
- status updates to be delivered on a best effort basis
- interacts with 100s to thousands of ``TravelCo``s
- need to deliver status changes only to registered ``TravelCo``s
- flight registration by ``TravelCo``s changes frequently

``TravelCo``:
- register interest in particular flight to monitor
- receive changes for all registered flights in real-time
- query current, full set of flight information on an ad-hoc basis

``FlightStatusCo``:
- calculate flight-status-change events based on incoming feeds & current flight status
- send flight-status-change event for flight to all ``TravelCo``s which are currently registered for this flight
- respond to flight information queries


## Sync or Async API?

Based on the use case discussions above, we realize a few things:

Whenever the use case discusses `real-time notification` or `update`, or mentions `trigger` or `change`, this probably is a good candidate for providing an Async API.

In contrast, when the use case talks about `submission`, `transaction` or `retrieve`/`query`, this probably is a good candidate for providing a Sync API.

However, it also becomes clear, that most use cases actually require a mix of Sync AND Async APIs. Let's look at the ``Order Capture & Management`` use case:
- we identified the need to submit an order and recieve an ack / nack from the API - a candidate for a Sync API
- we also identified the need to send real-time order status updates - a candidate for Async API

Therefore, when we define our API Product which our developers in the partner companies should use, we really want to create one that contains both, Sync AND AsyncAPIs.

**What is the consequence of not using Async APIs for events?**

Let's look at the ``Flight Status Updates`` use case and we decided to provide only a Sync API:
Each ``TravelCo`` would request flight status' on a schedule. An intelligent one would make their schedule dynamic, 3 weeks before departure every day, 6 hours before departure every 30 mins, 3 hours before departure every 5 minutes and so on.

Now, let's assume that only in 10% of the requests the flight status has actually changed. That would mean 90% of calls to the Sync API have been wasted! A very expensive proposition, on both sides, the API provider as well as the API consumer.

In addition, we may have chosen the wrong interval for our query - and missed a last minute gate change. Not a great experience for the traveller.

In safety critical situations this is even more relevant. Say we are monitoring Vehicles for failure / crash events or Elevators for predictive failure events - it is paramount, our processes react instantly rather than in the next hour!

When designing Async APIs, the above use cases give us some indication of what we need to understand:

Firstly, we need to understand what the process needs of the consuming company/application are. What events do they need and what do we expect them to do with that event?

Once this is understood, we can design our events we want to expose in our Async API:
- type and payload
- frequency
- volume
- quality of service: at least once or at most once

We also need to understand where our consumers are physically located; no consumer app wants to make a connection to an API Gateway across the atlantic.

The parameters above have a direct impact on the costs of operating the AsyncAPI since they impact the number of Gatways and their capacity, both from a throughput as well as from a storage perspective.
If the required quality of service is `at least once`, i.e. every event must be delivered, our API Gateway must hold events in a queue until they have been delivered. And it is 1 queue per connected application.
When the consumer application operates well, the queue will always be empty. However, what if the consumer applications goes offline for a few hours or days? The queue fills up until capacity is reached.
At what point is it possible to timeout not delivered events? And should they be moved to a `dead letter store` for later retrieval when the consumer application is operational again?

BTW, the same problem presents itself when using a Sync API to query a queue. So, this is not a specific Async API problem, but rather a commonality both approaches should share.

Another aspect we need to understand is the distribution of the right events to the right consumers.
**Can the same event be of interest to many consumers?**

| In the ``Connected Vehicles`` use case we have identified that ``BreakdownCo``/``MaintenaceCo`` as well as ``InsuranceCo`` are interested in failure and breakdown events.
|
| For the ``Flight Status Updates`` use case it is even more clear. Many ``TravelCo``s may subscribe to receive the same status update for the same flight at the same time. However, that list is dynamic and changes often.







based on the use case discussion above, we realize that it is important to understand:
- for each event:
  - API Provider
    - understand volumes of incoming events, filtering & routing of outgoing events
    - urgency or time value of event, this might depend on situation
    - criticality of event: deliver at-least-once or at-most-once
  - API Consumer
    - understand what the consumer needs to do with an event
      - and provide the data and channels to support their needs

* candidates for Async
  - real-time notifications, high or very low volume
    - no need for polling, called when event happens that interests a sub-group of consumers
    - any event that happens - but we don't know when it might happen or if at all - and requires instant action when it happens
  - examples:
    - alarms, faults, exceptions, call-to-action like a purchase approval

* candidates for Sync
  - off-line analysis: get aggregated data
  - transactional: send order, get immediate response that receipt was ok

## Concepts

### AsyncAPI Management in Isolation

TODO: TODO: TODO: TODO: TODO: TODO: TODO:
show data sources attached to event mesh

<p align="center"><img src="./images/apim.1_considerations.async.png" height="800"/></p>
<p align="center"><i>Figure 1 - Async API Management</i></p>


### Unified API Management

<p align="center"><img src="./images/apim.1_considerations.unified.png" height="800"/></p>
<p align="center"><i>Figure 2 - Unified Sync & Async API Management</i></p>

### Details

## Conclusion

---
### References & Further Reading

<a name="[1]"/>[1] Ryan Grondal - [Why resources companies are looking to evented APIs](https://blogs.mulesoft.com/digital-transformation/business/resources-companies-evented-apis/)

<a name="[2]"/>[2] Dakshitha Ratnayake - [Event-driven APIs in Microservice Architectures](https://github.com/wso2/reference-architecture/blob/master/event-driven-api-architecture.md)

<a name="[3]"/>[3] Forrester - [Use Event-Driven Architecture In Your Quest For Modern Applications, April 9, 2021](https://protect-us.mimecast.com/s/SayMC2kr5DSMWqzf1cd4G?domain=reprints2.forrester.com)

<a name="[4]"/>[4] Forrester - Event-Driven Architecture And Design: Five Big Mistakes And Five Best Practices, November 10, 2020


---
