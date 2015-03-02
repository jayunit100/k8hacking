package main
/*
Copyright 2014 Google Inc. All rights reserved.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

//package main

import (
    "encoding/json"
    "net/http"
    "os"
    "strings"

    "github.com/codegangsta/negroni"
    "github.com/gorilla/mux"
    "github.com/xyproto/simpleredis"
)

func main() {

    var connection = os.Getenv("REDIS_MASTER_SERVICE_HOST")+":"+os.Getenv("REDIS_MASTER_SERVICE_PORT");

    if connection == ":" {
        print("If in kube, this is a failure: Missing env variable REDIS_MASTER_SERVICE_HOST");
        connection="192.168.59.103:6379";
    } else {
        connection = os.Getenv("REDIS_MASTER_SERVICE_HOST") + ":" + os.Getenv("REDIS_MASTER_SERVICE_PORT");
    }

    println("connectin to " + connection)
    /**
    *  Create a connection pool.  ?The pool pointer will otherwise
    *  not be of any use.?https://gist.github.com/jayunit100/1d00e6d343056401ef00
    */
    pool = simpleredis.NewConnectionPoolHost(connection)

    defer pool.Close()

    r := mux.NewRouter()

    /**
    * Define a REST path.
    *  - The parameters (key) can be accessed via mux.Vars.
    *  - The Methods (GET) will be bound to a handler function.
    */
    r.Path("/info").Methods("GET").HandlerFunc(InfoHandler)
    r.Path("/lrange/{key}").Methods("GET").HandlerFunc(ListRangeHandler)
    r.Path("/rpush/{key}/{value}").Methods("GET").HandlerFunc(ListPushHandler)
    r.Path("/llen").Methods("GET").HandlerFunc(LLENHandler)
    r.PathPrefix("/").Handler(http.FileServer(http.Dir("./")))
    r.Path("/env").Methods("GET").HandlerFunc(EnvHandler)

    list := simpleredis.NewList(pool, "guestbook")
    HandleError(nil, list.Add("jayunit100"))
    HandleError(nil, list.Add("tstclaire"))
    HandleError(nil, list.Add("rsquared"))

    n := negroni.Classic()
    n.UseHandler(r)
    n.Run(":3000")
    println("done")

}

/**
* the Pool will be populated on startup,
* it will be an instance of a connection pool.
* Hence, we reference its address rather than copying.
*/
var pool *simpleredis.ConnectionPool

/**
*  REST
*  input: key
*
*  Writes  all members to JSON.
*/
func ListRangeHandler(rw http.ResponseWriter, req *http.Request) {
    println("ListRangeHandler")

    key := mux.Vars(req)["key"]

    list := simpleredis.NewList(pool, key)

    //members := HandleError(list.GetAll()).([]string)
    members := HandleError(list.GetLastN(4)).([]string)

    print(members)
    membersJSON := HandleError(json.MarshalIndent(members, "", "  ")).([]byte)

    print("RETURN MEMBERS = "+string(membersJSON))
    rw.Write(membersJSON)
}

func LLENHandler(rw http.ResponseWriter, req *http.Request) {
    println("LLEN HANDLER")

    infoL := HandleError(pool.Get(0).Do("LLEN","guestbook")).(int64)
    lengthJSON := HandleError(json.MarshalIndent(infoL, "", "  ")).([]byte)

    print("RETURN LEN = "+string(lengthJSON))
    rw.Write(lengthJSON)

}

func ListPushHandler(rw http.ResponseWriter, req *http.Request) {
    println("ListPushHandler")

    /**
    *  Expect a key and value as input.
    *
    */
    key := mux.Vars(req)["key"]
    value := mux.Vars(req)["value"]

    println("New list " + key + " " + value)
    list := simpleredis.NewList(pool, key)
    HandleError(nil, list.Add(value))
    ListRangeHandler(rw, req)
}

func InfoHandler(rw http.ResponseWriter, req *http.Request) {
    println("InfoHandler")

    info := HandleError(pool.Get(0).Do("INFO")).([]byte)
    rw.Write(info)
}

func EnvHandler(rw http.ResponseWriter, req *http.Request) {
    println("EnvHandler")

    environment := make(map[string]string)
    for _, item := range os.Environ() {
        splits := strings.Split(item, "=")
        key := splits[0]
        val := strings.Join(splits[1:], "=")
        environment[key] = val
    }

    envJSON := HandleError(json.MarshalIndent(environment, "", "  ")).([]byte)
    rw.Write(envJSON)
}

func HandleError(result interface{}, err error) (r interface{}) {
    if err != nil {
        print("ERROR :  " + err.Error())
        //panic(err)
    }
    return result
}