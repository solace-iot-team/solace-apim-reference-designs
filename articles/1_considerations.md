# Considerations for Unifying Synchronous & Asynchronous API Management

Author: Ricardo Gomez-Ulmke | June 2021


## TODO

- Sync or request/response APIs: REST, gRPC, GraphQL
- Async:
  - using webhooks via HTTP (server originating)
  - using 'proper' messaging protocols
  - Server-Sent Events (GET streams/order-updates): connection stays open and event will come in until closed (client originating)
  - websockets: plain text, soap, application protocol on top
  - GraphQL Subscriptions: client initiated streaming
  - gRPC Client & Server Streaming
- Why Event API Services?
  - separate internal from external events
    - internal: a lot of detail
    - external: abstracted, adapted to consumer workflow needs

## Introduction

TODO:
- the problem, the ask
- the goal
- what is explained here
- what isn't
- target audience

### Example Use Cases for Our Discussion

In order to ascertain what mix of APIs we want to offer to our internal and external developers, we need to baseline our understanding of where Evented APIs vs. RESTful APIs apply.

Which in turn requires us to understand events themselves. A good overview, general discussion about Event-Driven Architectures (EDA) and the concept of an Event Mesh is offered in [[3]](#[3]) and [[4]](#[4]).

In a nutshell:
- Transactions - such as creating a purchase order - are more suited for RESTful or request-reply APIs
- Historical queries - such as queries of past purchase orders - are more suited for RESTful or request-reply APIs
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

Let's look at the ``Flight Status Updates`` use case and how the interaction would change if we decided to provide only a Sync API:

>Each ``TravelCo`` would request flight status' on a schedule. An intelligent one would make their schedule dynamic, 3 weeks before departure every day, 6 hours before departure every 30 mins, 3 hours before departure every 5 minutes and so on.
>
>Now, let's assume that only in 10% of the requests the flight status has actually changed. That would mean 90% of calls to the Sync API have been wasted! A very expensive proposition, on both sides, the API provider as well as the API consumer.

In addition, we may have chosen the wrong interval for our query - and missed a last minute gate change. Not a great experience for the traveller.

In safety critical situations this is even more relevant. Say, we are monitoring Vehicles for failure / crash events or Elevators for predictive failure events - it is paramount that our processes react instantly rather than in the next hour!

**Designing Async APIs**

When designing Async APIs, the above use cases give us some indication of what we need to understand.

Firstly, we need to understand what the process needs of the consuming company/application are. What events do they need and what do we expect them to do with these events?

Once this is understood, we can design our events we want to expose in our Async API by looking at the following parameters:
- type and payload
- frequency
- volume
- quality of service: at least once or at most once

We also need to understand where our consumers are physically located; no consumer app wants to make a connection to an API Gateway across the atlantic.

The parameters above have a direct impact on the costs of operating the AsyncAPI since they impact the number of Gatways and their capacity requirements,
both from a throughput as well as from a storage perspective.
If the required quality of service is `at least once`, i.e. every event must be delivered, our API Gateway must hold events in a queue until they have been delivered. And it is 1 queue per connected application.
When the consumer application operates well, the queue will always be empty. However, what if the consumer application goes offline for a few hours or days? The queue fills up until capacity is reached.
At what point is it possible to timeout not delivered events? And should they be moved to a `dead letter store` or `replay store` for later retrieval/scheduled event replay when the consumer application is operational again? And how do we tell the consumer application on connect that they need to _catch up_, e.g. by requesting a replay of missed events or by querying a dead letter store before starting to consume new real-time events?

BTW, the same problem presents itself when using a Sync API to query a queue. So, this is not a specific Async API problem, but rather a commonality both approaches should share.

Another aspect we need to understand is the distribution of the right events to the right consumers.

**Can the same event be of interest to many consumers?**

&nbsp; In the ``Connected Vehicles`` use case we have identified that ``BreakdownCo``/``MaintenaceCo`` as well as ``InsuranceCo`` are interested in failure and breakdown events.

&nbsp; For the ``Flight Status Updates`` use case it is even more obvious. Many ``TravelCo``s may subscribe to receive the same status update for the same flight at the same time. However, that list is dynamic and changes often.

Which means, our Async API Gateway must be able to cope with:
- dynamic subscriptions for each application
- provide a 1-many _fan-out_
- keep track of which connections has received which event and which not, combined with re-delivery or re-tries in case of an error

The next sections discuss how to handle _catch-up_ using a variety of caching & replay patterns, and errors and exceptions, both at the infrastructure level as well as the application level.

### Last Value Cache

The _Last Value Cache_ pattern provides a mechanism for a consumer application to retrieve the last event that was sent by the API provider in the case of a temporary disconnect.

The consumer application can then use this last value to update their representation of an object before continuing to process the new update events.

_Note that this pattern only works if the API provider service sends update events that represent the complete object and not just incremental change events._

Let's look at the ``Flight Status Update`` use case:
- the event always contains the entire status of the flight
- the consumer application re-connects after a down-period
- the consumer application first receives the last value, then starts receiving new update events

This pattern requires the Gateway to always _remember_ the last event for every flight, regardless if it is currently subscribed to by any consumer application or not.

### Replay Cache or Event Sourcing

The _Replay Cache_ and _Event Sourcing_ patterns allow a consumer application to retrieve a complete sequence of missed events on demand.

This is useful when the events represent incremental or partial updates of an object only, or if the consumer application feeds a business process that is designed to receive update events in order to move forward.

In this pattern, the consumer application is required to keep track of at least the last event-id successfully processed so it can request a replay from that event-id onwards.

Let's look at the ``Order Capture & Management`` use case:
- every order update must be received in sequence by the consumer application
- the consumer application processes order update events and remembers the last event-id received
- the consumer application disconnects
- on re-connect, the consumer application requests the replay of all order update events starting from the last received event-id and processes these
- only now the consumer application start receiving new real-time update events

This pattern requires the Gateway to store all order update events for every order for a defined amount of time in the replay cache before moving the entire sequence to a historical data store - for example, after the order has been successfully fulfilled.

### Async Error Channel

One crucial difference between Sync APIs and Async APIs is that in the Async world there is no standard mechanism for feedback.

Let's look at the ``Order Capture`` use case, using a simple _schema validation policy_:
- we have defined the schema for the order submit event and have a policy service that checks submitted order against that schema
- the consumer application submits an order that does not conform to the policy

Going back to the ``Order Capture & Management`` use case description we understand that order submission is _transactional_ and not actually _event-driven_.
Which means, we offer _order submit_ as a RESTful API and in the response we tell the consumer application about the error. Straight forward!

Now, let's drill down into the use case further and consider payment for the order. Payment requires further checks including call-outs to 3rd party payment systems which in turn may call-out to identity verification systems. Until a payment is fully processed and settled, a long-running process is started that may take a few days.

From our use case analysis we know that order status updates, including order processing or payment failures, are sent asynchronously.

Which in turn means, that order processing errors must be part of the Async API we design for our ``PartnerCo``s.

### Auditing
Auditing is a common requirement between Sync & Async APIs. We want to be able to store transactions as well as events received from / sent to consumer applications.

This is a service at the infrastructure level, part of the API Gateway, rather than part of the application system. The additional requirement for supporting an Async Gateway is a service that _listens_ to events passing through the Async Gateway and captures them in the Audit data store.

### Async API Protocols
The first emerging protocols supported by the traditional API Management systems are based on WebSockets and gRPC.
While these offer asynchronous methods, they are not very well suited for a loosely-coupled, EDA implementation.

**_Note: You do not want to tightly-couple the internal Async API Event Services with the externally offered Async APIs._**

Instead, EDA is based on the notion of a _Message or Event Broker_ that de-couples producers of events from consumers of events.

There are some key differences between writing consumer applications using an event-driven protocol vs. a RESTful HTTP protocol.
An event-driven consumer application has to:
- create and maintain a connection to the API Gateway and therefore manage it's connection lifecycle
  - open the connection
  - re-connect on _connection-lost_ events
- using a subscribe channel:
  - send subscription(s) to channel topics to the API Gateway and provide a callback function to handle incoming events
    - be aware of the connection status and manage _send subscription_ errors when no connection available
  - process incoming events in sequence
  - confirm successful processing of events to the API Gateway
- using a publish channel:
  - send a publish event to the API Gateway with a fully qualified topic (see below)
    - be aware of the connection status and manage _publish_ errors when no connection available
  - receive confirmation from the API Gateway that the event was received
    - retry on error
    - be aware of the connection status and manage _publish confirmation_ timeouts when no connection available

This is a very different communication concept and requires the application developer to craft the code asynchronously from the get-go.

The above proposition can be daunting for developers who have not yet had much exposure to evented APIs and interacting with _Message Brokers_.

Fortunately, there are many open source async protocols with implementations in most programming languages that take away a lot of the hand-crafting described above.

It is therefore important to offer the Async APIs through a variety of protocols to maximize reach and adoption. Here are some suitable and widely supported protocols:

- MQTT
  - supported via tcp but also over web sockets
  - light-weight, supports the basic quality-of-services of _at least once_ and _at most once_. In addition, it supports the notion of a _last value cache_ via the _retain_ flag.
- JMS
  - not a protocol as such, but an API definition
  - more powerful and feature-rich than MQTT, supports queuing as well as properties such as _time-to-live_
- AMQP
  - an alternative to JMS, enterprise-grade messaging protocol

And, of course, there is the well known HTTP/S. Using HTTP is a simple and quick alternative where developers do not have to care about managing the connection life-cycle.
The mapping of events to HTTP/S calls is as follows:
- publish:
  - send an HTTP request (e.g. a POST or PUT) including the topic and payload to the API Gateway
- subscribe:
  - provide the API Gateway with a webhook & and a list of topic subscription
  - the API Gateway makes a call (e.g. a POST or PUT) to the webhook whenever it receives an event that matches the subscription topic

### API Event Services
API Event Services are the services or applications within the organization that offer 1 or many evented services. These services can then be combined to into Async API Products by the API Management System.

Firstly, let's recap a key concept of EDA, that of loose-coupling of producers and consumers by the intermediary of a _Message or Event Broker_.
Let's use the use case ``Connected Vehicles`` to illustrate:
- we have raw vehicle telemetry data incoming into the Event Mesh - this raw telemetry data typically is not the data we want to expose via APIs to our ``MaintenanceCo``.
- instead, we have ``API Event Services`` that:
  - consume the raw telemetry data
  - aggregate, calculate, transform it into the desired API data
  - publish it to the API Gateway

And, if we have adopted a micro-service architecture, we do not have 1 such API Event Service but rather multiple, each serving a specific API data stream:
- the ``Alarm API Event Service``
- the ``Fault API Event Service``
- the ``Predictive Maintenance API Event Service``
- and so on.

Furthermore, we may have different teams in different locations operating these API Event Services, e.g. 1 in Europe and others in the US or Asia.

**_Note: There is only a loose relationship between the Async API Product published in the Developer Portal and the internal services providing the event interfaces for that API Product._**

However, each API Event Service defines at least two parameters:
- the channel / topic namespace it publishes on and subscribes to
- the event payload schema for each event

In addition, it may define:
- the time-to-live of an event published
- the quality of service an event is published with and subscribed to
- the priority of an event published

Which means, in order to publish an API Product for ``ConnectedVehiclesCo`` that includes ``Safety/Failure/Breakdown`` APIs, we define an AsyncAPI specification that includes the **reverse of the interfaces** the API Event Services provide:
- ``Alarm API Event Service`` publishes alarms ==> AsyncAPI speficiation defines a channel with a ``subscribe`` operation
- ``Alarm/Failure Workflow Status Update API Event Service`` subscribes to status updates ==> AsyncAPI specification defines a channel with a ``publish`` operation

Let's go one level deeper for the above example to highlight the loose coupling and power of using EDA concepts:
- when the ``Alarm API Event Service`` publishes and alarm it generates also a unique ``alarmId``
- the ``Alarm/Failure Workflow Status Update API Event Service`` also subscribes to the alarm, extracts the ``alarmId`` and starts subscribing to incoming status updates for that ``alarmId``
  - this allows the service to monitor expected status updates against actual status updates and to correlate incoming status updates with outstanding alarms

**_We now have re-used the alarm event within our organization based on a micro-service approach within our EDA architecture._**

### Async Channel Topics & Permissioning

Designing Topic Namespaces is one of the key activities when defining your EDA strategy.

Topics are the fundamental concept in your EDA for publishing events, routing of events through the Event Mesh, and subscribing to events.
The Namespace design together with Wildcards in topics make it possible to create a dynamic and flexible distribution and delivery of events throughout the Event Mesh.

A few basics:
- Applications publish on a complete topic, i.e. the publishing topic must not have wildcards in it.
- It is the producer of an event that defines the actual, run-time topic.
- It is common practice that a producer of events includes Ids or Keys in the topic at run-time - e.g. a Vehicle may include it's VIN in the topic, an IOT device may include it's device Id in the topic, a workflow may include it's workflow ID in the topic, ...

**_Note: It is important that your Event Mesh does NOT require for every single topic to be defined & configured upfront but supports dynamic topics created by publishers at run-time._**

Let's go back to our use case of ``ConnectedVehiclesCo``. Here is an example of a topic namespace definition including run-time parameters for our Async APIs that offer update events:

``api/vehicle/ConnectedVehiclesCo/{region-id}/{vehicle-make}/{vehicle-model}/{vehicle-vin}/{event-type}``

with:
- ``api/vehicle/ConnectedVehiclesCo`` - a standardized topic prefix
- ``region-id`` - the region the vehicle is operated in
- ``vehicle-make`` - the make of the vehicle
- ``vehicle-model`` - the model of the vehicle
- ``vehicle-vin`` - the VIN
- ``event-type`` - the type of event, e.g. safety, failure, consumption

The ``API Event Service`` defines the actual topic at run-time. This also means, the raw telemetry data the ``API Event Service`` receives must include the data points for the run-time topic parameters.

Using the above topic schema, with and without wildcards, our consumer application is now able to subscribe to very specific or very broad updates:

- a subscription to ``api/vehicle/ConnectedVehiclesCo/fr/make-1/model-2/abc123/safety`` will only receive safety events for 1 particular vehicle
- a subscription to ``api/vehicle/ConnectedVehiclesCo/fr/make-1/model-2/*/safety`` will receive safety events for all vehicles of make-1, model-2 operated in France
- a subscription to ``api/vehicle/ConnectedVehiclesCo/fr/>`` will receive all events for all vehicles operated in France

Now, in reality, a particular ``MaintenanceCo`` or ``BreakdownCo`` will only be granted access to a subset of all the vehicles and perhaps a subset of the events per vehicle.

This requires us to introduce a permissioning mechanism:

For example, ``ConnectedVehiclesCo`` has contracted with ``ItalianBreakdownCo`` in Italy for recovery services in their Italian market.
Therefore, a developer application from ``ItalianBreakdownCo`` should only be able to subscribe to a subset of the entire topic set:
- ``region-id`` == ``it``
- ``event-type`` == ``failure``

The resulting topic set the ``ItalianBreakdownCo`` has access to is now: ``api/vehicle/ConnectedVehiclesCo/it/*/*/*/failure``.

Whereas a ``MaintenaceCo`` contracted for Germany & Italy could be granted access to:
- ``api/vehicle/ConnectedVehiclesCo/it/*/*/*/failure``
- ``api/vehicle/ConnectedVehiclesCo/it/*/*/*/safety``
- ``api/vehicle/ConnectedVehiclesCo/it/*/*/*/maintenance``
- ``api/vehicle/ConnectedVehiclesCo/de/*/*/*/failure``
- ``api/vehicle/ConnectedVehiclesCo/de/*/*/*/safety``
- ``api/vehicle/ConnectedVehiclesCo/de/*/*/*/maintenance``

Managing these restrictions efficiently requires the following:
- the ``API Event Service`` defines the possible, global set of values or patterns for each topic parameter
  - for example, a global service would define a list of regions, ["it", "fr", "de", "us-east", "us-west", ...]
- when publishing the API Product, we want to be able to either publish the entire possible list of values or restrict it. But, of course, we cannot add to it.
- when approving a specific developer app for a specific ``PartnerCo`` we must be able to further restrict the values for each parameter before approving it.

The AsyncAPI Specification already provides the mechanism to document topic parameters, so for every step we can keep the resulting Specification up to date.

When a consumer application makes a subscription to a topic, we also have to check that this application is actually allowed to subscribe to the topic (pattern), and it not, disallow the subscription.

Looking at the permissioning mechanisms described above, it becomes clear that this is a feature that should be immplemented in the API Gateway infrastructure, rather than in separate services specific to an API. We want to avoid any additional coupling of ``API Event Services`` with the actual provisioned API and keep these services as lean as possible.
Also, the permissioning example above shows that approval and setting of permissions is depending on the agreements with our ``PartnerCo``s. The approval workflow for a developer application should probably be integrated with ``ConnectedVehiclesCo``'s contract management system, so the API Management system should provide hooks or call-outs to invoke 3rd party systems.

## Architectural Concepts

- TODO: rate limiting for publish APIs - DDOS attack - how to?
- TODO: handle slow consumers - queues
- TODO: plans:
  - connections,
  - queue size
  - number of assets, orders, vehicles, flights - this is not the same as subscriptions
  - replay depth
  - quality of service for updates? probably not, use case requires it or not

### AsyncAPI Management in Isolation

==> should they appear on both diagrams?

- TODO: show data sources attached to event mesh
- TODO: show last-value-cache service
- TODO: show replay cache service
- TODO: show historical data store
- TODO: show error handling
- TODO: show conversion of HTTP request to publish event and event to HTTP POST

<p align="center"><img src="./images/apim.1_considerations.async.png" height="800"/></p>
<p align="center"><i>Figure 1 - Async API Management</i></p>


### API Management Infrastructure Services

TODO: should this be a separate picture - with all the services identified above?

### Unified API Management

- TODO: Sync GW must be able to convert a RESTful request to using a request-reply API for the API Event Service ==> keep the EDA structure clean

WSO2 EDA presentation:
- TODO: table of key differences
- TODO: table of what can be re-used
  - OAuth2: scopes ==> topics permissions ==> say that above, not all about ACLs



<p align="center"><img src="./images/apim.1_considerations.unified.png" height="800"/></p>
<p align="center"><i>Figure 2 - Unified Sync & Async API Management</i></p>

### Details

## Conclusion

- transactional, historical v. updates/changes ==> mix APIs in one product

- **_Note: You do not want to tightly-couple the internal Async API Event Services with the externally offered Async APIs._**
- **_Note: There is only a loose relationship between the Async API Product published in the Developer Portal and the internal services providing the event interfaces for that API Product._**
- **_We now have re-used the alarm event within our organization based on a micro-service approach within our EDA architecture._**
- **_Note: It is important that your Event Mesh does NOT require for every single topic to be defined & configured upfront but supports dynamic topics created by publishers at run-time._**
- **Permissioning**
- **API Management system should provide hooks or call-outs to invoke 3rd party systems.**



---
### References & Further Reading

<a name="[1]"/>[1] Ryan Grondal - [Why resources companies are looking to evented APIs](https://blogs.mulesoft.com/digital-transformation/business/resources-companies-evented-apis/)

<a name="[2]"/>[2] Dakshitha Ratnayake - [Event-driven APIs in Microservice Architectures](https://github.com/wso2/reference-architecture/blob/master/event-driven-api-architecture.md)

<a name="[3]"/>[3] Forrester - [Use Event-Driven Architecture In Your Quest For Modern Applications, April 9, 2021](https://protect-us.mimecast.com/s/SayMC2kr5DSMWqzf1cd4G?domain=reprints2.forrester.com)

<a name="[4]"/>[4] Forrester - Event-Driven Architecture And Design: Five Big Mistakes And Five Best Practices, November 10, 2020


---
