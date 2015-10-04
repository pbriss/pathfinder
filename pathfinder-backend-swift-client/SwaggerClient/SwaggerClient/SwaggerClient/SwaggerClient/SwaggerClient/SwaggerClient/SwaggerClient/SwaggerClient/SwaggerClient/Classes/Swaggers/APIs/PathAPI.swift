//
// PathAPI.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Alamofire

extension SwaggerClientAPI {
    
    public class PathAPI: APIBase {
    
        /**
         
         Suggest a path with certain places based on rankings and user
         
         - GET /path/suggest
         - examples: [{contentType=application/json, example={
  "places" : {
    "name" : "aeiou"
  }
}}]

         - returns: RequestBuilder<Path> 
         */
        public class func pathSuggestGet() -> RequestBuilder<Path> {
            let path = "/path/suggest"
            let URLString = SwaggerClientAPI.basePath + path
            
            let nillableParameters: [String:AnyObject?] = [:]
            let parameters = APIHelper.rejectNil(nillableParameters)

            let requestBuilder: RequestBuilder<Path>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

            return requestBuilder.init(method: "GET", URLString: URLString, parameters: parameters, isBody: true)
        }
    
    }
}
