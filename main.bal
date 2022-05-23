// Introduce your solution here.

import ballerina/http;
import ballerina/io;

import ballerina/random;
configurable int port = 8085;

string orderIdString="test";


map<string> orderStatus = {
        orderIdString: " "
    };

type PostCom record {
    string username;
    Items[] order_items;
};

type PostCom2 record {
    Items[] order_items;
};
type Items record {
    string item;
    int quantity; 
};




type Response record{
    string order_id;
    int total;
};

type getOrderID record{
    string order_id;
    string status;
};

const int butter_Cake = 15;
const int chocolate_Cake = 20;
const int tres_leches = 25;


service http:Service / on new http:Listener(port) {


    resource function get menu()
            returns http:Ok|http:BadRequest {
      
            json menu = {"Butter Cake": 15, "Chocolate Cake": 20, "Tres Leches": 25};
            http:Ok ok = {body: menu};
            return ok;
    }

        resource function get 'order/[string orderId]()
            returns http:Ok|http:NotFound   {
            getOrderID resp =  {order_id: "", status: ""};
            if(orderStatus[orderId]!= ())
            {
                resp.order_id = orderId;
                resp.status = <string> orderStatus[orderId];
                http:Ok ok = {body: resp};
                return ok;
            }
    
            http:NotFound bad = {body: "not found"};
            return bad;
            
    }

 resource function post 'order(@http:Payload PostCom postCom ) returns
       http:Created|http:BadRequest
        
        {
        
      
        http:BadRequest err = {body: "invalid request"};

        if (postCom.username=="" || postCom.order_items.length()==0){
       return err;}

        
       
        int randomInteger =0;
        int total = 0;
        Response response = { order_id:"", total: 0};
        do {
	        randomInteger = check random:createIntInRange(1, 100);
        } on fail var e {
        	io:println(e);
        }

             foreach int i in 0..<postCom.order_items.length()
        {
          
 
        }
        foreach int i in 0..<postCom.order_items.length()
        {
            if(postCom.order_items[i].item=="Butter Cake")
            {
                if(postCom.order_items[i].quantity<0){
                return err;}
                total = total + postCom.order_items[i].quantity * butter_Cake;
            }
            else if(postCom.order_items[i].item=="Chocolate Cake")
            {
                if(postCom.order_items[i].quantity<0){
                return err;}
                total = total + postCom.order_items[i].quantity * chocolate_Cake;
            }
            else if(postCom.order_items[i].item=="Tres Leches")
            {
                if(postCom.order_items[i].quantity<0){
                return err;}               
                total = total + postCom.order_items[i].quantity * tres_leches;
            }

            else{
                
                return err;
            }
            
        }
        string order_id = randomInteger.toString();
        response.order_id = order_id;
        response.total = total;
        
        orderStatus[order_id] = "pending";
        http:Created created = {body: response};
        return created;
    
    }

        resource function put 'order/[string orderId](@http:Payload PostCom2 postCom2)
            returns http:Ok|http:NotFound|http:BadRequest|http:Forbidden  {
            http:BadRequest err = {body: "invalid request"};
            http:NotFound  bad = {body: "Not found"};
            http:Forbidden forbid = {body: "Forbidden"};
            int total = 0;
            if(orderStatus[orderId]!= () && orderStatus[orderId]== "pending")
            {

                     foreach int i in 0..<postCom2.order_items.length()
        {
            if(postCom2.order_items[i].item=="Butter Cake")
            {
                if(postCom2.order_items[i].quantity<0){
                return err;}
                total = total + postCom2.order_items[i].quantity * butter_Cake;
            }
            else if(postCom2.order_items[i].item=="Chocolate Cake")
            {
                if(postCom2.order_items[i].quantity<0){
                return err;}
                total = total + postCom2.order_items[i].quantity * chocolate_Cake;
            }
            else if(postCom2.order_items[i].item=="Tres Leches")
            {
                if(postCom2.order_items[i].quantity<0){
                return err;}               
                total = total + postCom2.order_items[i].quantity * tres_leches;
            }

            else{
                
                return err;
            }
            
        }

        Response response = { order_id:"", total: 0};  
        response.order_id = orderId;
        response.total = total;
        
        orderStatus[orderId] = "pending";
        http:Ok ok = {body: response};
        return ok;
                
            }
            else if (orderStatus[orderId]!= "pending"){
                return forbid;
            }

            else{
                
            return bad;
            }


            
     
    }

resource function delete 'order/[string orderId]()
returns http:Ok|http:NotFound|http:Forbidden
{
         
            http:NotFound  notfound = {body: "Not found"};
            http:Forbidden forbid = {body: "Forbidden"};
            http:Ok ok = {body: "removal success"};
            string temp = "ok";
            if(orderStatus[orderId]!= () && orderStatus[orderId]== "pending")
            {
                temp = orderStatus.remove(orderId);
                return ok;
            }
            else if (orderStatus[orderId]!= "pending"){
                return forbid;
            }
            else{
                io:println(temp);
                return notfound;
            }

}


}

    