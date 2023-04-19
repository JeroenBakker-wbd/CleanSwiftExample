//
//  APIWorker.swift
//  CleanSwiftExample
//
//  Created by Jeroen Bakker on 18/04/2023.
//

import Apollo
import ApolloAPI
import Foundation

protocol APIWorkerable {
    func fetch<Query: GraphQLQuery>(
        query: Query,
        cachePolicy: CachePolicy,
        contextIdentifier: UUID?,
        queue: DispatchQueue
    ) async throws -> Query.Data
}

enum APIWorkerError: Error {
    case general(message: String)
    case graphql(errors: [GraphQLError])
}

extension APIWorkerable {
    
    func fetch<Query: GraphQLQuery>(
        query: Query,
        cachePolicy: CachePolicy = CachePolicy.returnCacheDataElseFetch,
        contextIdentifier: UUID? = nil,
        queue: DispatchQueue = DispatchQueue.global(qos: .background)
    ) async throws -> Query.Data {
        try await self.fetch(query: query, cachePolicy: cachePolicy, contextIdentifier: contextIdentifier, queue: queue)
    }
}

struct APIWorker: APIWorkerable {
    
    private let client = ApolloClient(url: URL(string: "https://swapi-graphql.netlify.app/.netlify/functions/index")!)
    
    func fetch<Query: GraphQLQuery>(
        query: Query,
        cachePolicy: CachePolicy,
        contextIdentifier: UUID?,
        queue: DispatchQueue
    ) async throws -> Query.Data {
        try await withUnsafeThrowingContinuation({ continuation in
            client.fetch(
                query: query,
                cachePolicy: cachePolicy,
                contextIdentifier: contextIdentifier,
                queue: queue
            ) { result in
                switch result {
                case .success(let response):
                    if let data = response.data {
                        continuation.resume(returning: data)
                    } else if let graphQLErrors = response.errors, !graphQLErrors.isEmpty {
                        continuation.resume(throwing: APIWorkerError.graphql(errors: graphQLErrors))
                    } else {
                        continuation.resume(throwing: APIWorkerError.general(message: "Something went wrong with the result"))
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        })
    }
}
