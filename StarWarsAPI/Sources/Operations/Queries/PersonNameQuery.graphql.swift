// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class PersonNameQuery: GraphQLQuery {
  public static let operationName: String = "PersonName"
  public static let document: ApolloAPI.DocumentType = .notPersisted(
    definition: .init(
      #"""
      query PersonName($personId: ID) {
        person(personID: $personId) {
          __typename
          name
        }
      }
      """#
    ))

  public var personId: GraphQLNullable<ID>

  public init(personId: GraphQLNullable<ID>) {
    self.personId = personId
  }

  public var __variables: Variables? { ["personId": personId] }

  public struct Data: StarWarsAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { StarWarsAPI.Objects.Root }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("person", Person?.self, arguments: ["personID": .variable("personId")]),
    ] }

    public var person: Person? { __data["person"] }

    /// Person
    ///
    /// Parent Type: `Person`
    public struct Person: StarWarsAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { StarWarsAPI.Objects.Person }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("name", String?.self),
      ] }

      /// The name of this person.
      public var name: String? { __data["name"] }
    }
  }
}
