# BetSwift

Swift wrapper for [Betfair API-NG](http://docs.developer.betfair.com/docs/display/1smk3cen4v3lu3yomq5qye0ni). Currently only market streaming is supported.

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

Once you have a token you can connect the stream. You will need to pass the config, and a `Queue` where the events will added to be processed.

```swift
var queue = Queue<BetSwift.Event>()

typealias StreamType = BetSwift.Stream<ChangeMessage<MarketChange>>

func connect(sessionToken: String) {
  do {
    let authentication = Authentication(id: 1,
                                        appKey: "appkey",
                                        session: sessionToken)
    let config = StreamType.Config(endpoint: "stream-api-integration.betfair.com",
                                   certPath: "path/to/pem_file_or.p12",
                                   password: "cert_password",
                                   authentication: authentication)
    let stream = StreamType(config: config,
                            queue: queue,
                            handler: stateChanged)
    try stream.start()
  } catch {
    print(error)
  }
}
```

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

func stateChanged(state: StreamType.State,
                  stream: StreamType) {
  if state == .connected {
    try! stream.send(.marketSubscription(marketSubscription))
  }
}
```

You should then have events on the queue which can be processed. You may want to do this on a separate `DispatchQueue`/thread:


```swift
let processQueue = DispatchQueue(label: "betswift.queue.process")

func process(queue: Queue<BetSwift.Event>) {
  while true {
    if !queue.isEmpty {
      let event = queue.pop()
      switch event {
      case .change(let change):
        print(change)
      case .error:
        print("error")
      }
    }
  }
}

processQueue.async { process(queue: queue) }
```

## Todo

- Price cache
- Order stream
- Betting operations
- Performance test
