// Copyright (c) 2020 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/io;
import ballerina/test;

@test:Config {enable:true}
isolated function testGzipEncoding() {
    OrderManagementClient OrderMgtBlockingEp = new("http://localhost:9111");

    Order 'order = {id: "101", items: ["xyz", "abc"], destination: "LK", price:2300.00};
    map<string|string[]> headers = {};
    headers["grpc-encoding"] = "gzip";
    ContextOrder reqOrder = {content: 'order, headers: headers};
    string|error result = OrderMgtBlockingEp->addOrder(reqOrder);
    if (result is error) {
        test:assertFail(io:sprintf("gzip encoding failed: %s", result.message()));
    } else {
        test:assertEquals(result, "Order is added 101");
    }
}

public client class OrderManagementClient {

    *AbstractClientEndpoint;

    private Client grpcClient;

    public isolated function init(string url, ClientConfiguration? config = ()) {
        // initialize client endpoint.
        self.grpcClient = new(url, config);
        checkpanic self.grpcClient.initStub(self, ROOT_DESCRIPTOR_21, getDescriptorMap21());
    }

    isolated remote function addOrder(Order|ContextOrder req) returns (string|Error) {
        
        map<string|string[]> headers = {};
        Order message;
        if (req is ContextOrder) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("ecommerce.OrderManagement/addOrder", message, headers);
        [anydata, map<string|string[]>][result, _] = payload;
        return result.toString();
    }
    isolated remote function addOrderContext(Order|ContextOrder req) returns (ContextString|Error) {
        
        map<string|string[]> headers = {};
        Order message;
        if (req is ContextOrder) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("ecommerce.OrderManagement/addOrder", message, headers);
        [anydata, map<string|string[]>][result, respHeaders] = payload;
        return {content: result.toString(), headers: respHeaders};
    }

    isolated remote function getOrder(string|ContextString req) returns (Order|Error) {
        
        map<string|string[]> headers = {};
        string message;
        if (req is ContextString) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("ecommerce.OrderManagement/getOrder", message, headers);
        [anydata, map<string|string[]>][result, _] = payload;
        
        return <Order>result;
        
    }
    isolated remote function getOrderContext(string|ContextString req) returns (ContextOrder|Error) {
        
        map<string|string[]> headers = {};
        string message;
        if (req is ContextString) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("ecommerce.OrderManagement/getOrder", message, headers);
        [anydata, map<string|string[]>][result, respHeaders] = payload;
        
        return {content: <Order>result, headers: respHeaders};
    }

}
