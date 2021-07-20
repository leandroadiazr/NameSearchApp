public struct DomainSearchProductResponse: Codable {
    public struct PriceInfo: Codable {
        public let currentPriceDisplay: String
        public let listPriceDisplay: String
        public let promoLength: Int

        enum CodingKeys: String, CodingKey {
            case currentPriceDisplay = "CurrentPriceDisplay"
            case listPriceDisplay = "ListPriceDisplay"
            case promoLength = "PromoRegLengthFlag"
        }

        public init(currentPriceDisplay: String, listPriceDisplay: String, promoLength: Int) {
            self.currentPriceDisplay = currentPriceDisplay
            self.listPriceDisplay = listPriceDisplay
            self.promoLength = promoLength
        }
    }
    public struct Content: Codable {
        public let header: String?
        public let messages: String?
        public let phases: [String]?
        public let subHeader: String?
        public let tld: String?

        enum CodingKeys: String, CodingKey {
            case header = "Header"
            case messages = "Messages"
            case phases = "Phases"
            case subHeader = "SubHeader"
            case tld = "TLD"
        }

        public init(header: String?, messages: String?, phases: [String]?, subHeader: String?, tld: String?) {
            self.header = header
            self.messages = messages
            self.phases = phases
            self.subHeader = subHeader
            self.tld = tld
        }
    }

    public let priceInfo: PriceInfo
    public let content: Content?
    public let productId: Int

    enum CodingKeys: String, CodingKey {
        case priceInfo = "PriceInfo"
        case content = "Content"
        case productId = "ProductId"
    }

    public init(priceInfo: PriceInfo, content: Content?, productId: Int) {
        self.priceInfo = priceInfo
        self.content = content
        self.productId = productId
    }
}
public struct DomainSearchRecommendedResponse: Codable {
    public struct RecommendedDomain: Codable {
        public let fqdn: String
        public let tld: String
        public let tierId: Int
        public let isPremium: Bool
        public let productId: Int
        public let inventory: String

        enum CodingKeys: String, CodingKey {
            case fqdn = "Fqdn"
            case productId = "ProductId"
            case tld = "Extension"
            case tierId = "TierId"
            case isPremium = "IsPremiumTier"
            case inventory = "Inventory"
        }

        public init(fqdn: String, tld: String, tierId: Int, isPremium: Bool, productId: Int, inventory: String) {
            self.fqdn = fqdn
            self.tld = tld
            self.tierId = tierId
            self.isPremium = isPremium
            self.productId = productId
            self.inventory = inventory
        }
    }

    public let products: [DomainSearchProductResponse]
    public let domains: [RecommendedDomain]

    enum CodingKeys: String, CodingKey {
        case products = "Products"
        case domains = "RecommendedDomains"
    }

    public init(products: [DomainSearchProductResponse], domains: [RecommendedDomain]) {
        self.products = products
        self.domains = domains
    }
}
public struct DomainSearchExactMatchResponse: Codable {
    public struct ExactMatch: Codable {
        public let fqdn: String
        public let tld: String
        public let tierId: Int
        public let isAvailable: Bool
        public let isPremium: Bool
        public let productId: Int

        enum CodingKeys: String, CodingKey {
            case fqdn = "Fqdn"
            case productId = "ProductId"
            case tld = "Extension"
            case tierId = "TierId"
            case isPremium = "IsPremiumTier"
            case isAvailable = "IsAvailable"
        }

        public init(fqdn: String, tld: String, tierId: Int, isAvailable: Bool, isPremium: Bool, productId: Int) {
            self.fqdn = fqdn
            self.tld = tld
            self.tierId = tierId
            self.isAvailable = isAvailable
            self.isPremium = isPremium
            self.productId = productId
        }
    }

    public let products: [DomainSearchProductResponse]
    public let domain: ExactMatch

    enum CodingKeys: String, CodingKey {
        case products = "Products"
        case domain = "ExactMatchDomain"
    }

    public init(products: [DomainSearchProductResponse], domain: ExactMatch) {
        self.products = products
        self.domain = domain
    }
}
