# BetSwift

Swift wrapper for [Betfair API-NG](http://docs.developer.betfair.com/docs/display/1smk3cen4v3lu3yomq5qye0ni). Currently only market streaming is supported.

It is built on top of [Swift NIO](https://github.com/apple/swift-nio)

This is untested in production. Using this as-is would be a bad idea. Memory consumption especially needs to be tested.

## Installation

Only Swift 4 is supported.

Due to a change needed upstream in [Kitura-Net](https://github.com/IBM-Swift/Kitura-net/pull/215) you can only reference `master` in a Swift package manifest:

```swift
.package(url: "https://github.com/foulkesjohn/BetSwift.git", .branch("master"))
```

## Usage

You will need your Betfair cert in PEM format to run on linux. For mac you will need both pem and p12.

First you will need to get a session token:

```swift
let sessionParams = SessionFetchParams(username: "username",
                                       password: "password",
                                       appKey: "appkey",
                                       certPath: "path/to/cert_file.pem",
                                       certPassword: "cert_password")

SessionToken.fetch(params: sessionParams) {
  sessionToken in
  if let sessionToken = sessionToken {
    connect(sessionToken: sessionToken)
  } else {
    print("no session token")
  }
}
```

Once you have a token you can connect the stream. You will need to create a handler which sends the authentication `Op`. Once connected you can send a subscription.

Once the stream has connected you can send the subscription:

```swift
let marketFilter = MarketFilter(marketIds: nil,
                                bspMarket: nil,
                                bettingTypes: nil,
                                eventTypeIds: ["7", "1"],
                                turnInPlayEnabled: nil,
                                marketTypes: ["WIN"],
                                venues: nil,
                                countryCodes: ["GB"])
let marketDataFilter = MarketDataFilter(fields: ["EX_BEST_OFFERS",
                                                 "EX_MARKET_DEF",
                                                 "EX_LTP"],
                                        ladderLevels: 3)

let marketSubscription = MarketSubscription(id: 1,
                                            marketFilter: marketFilter,
                                            marketDataFilter: marketDataFilter)

let op = Op.marketSubscription(marketSubscription)
ctx.writeAndFlush(wrapOutboundOut(op), promise: nil)
```

You should then have events on the queue which can be processed. You may want to do this on a separate `DispatchQueue`/thread:

## Todo

- Price cache
- Order stream
- Betting operations
- Performance test
