package com.salesforce.analytics;
import static spark.Spark.get;
import static spark.SparkBase.port;
import static spark.SparkBase.staticFileLocation;

import java.util.HashMap;
import java.util.Map;

import spark.ModelAndView;
import spark.template.freemarker.FreeMarkerEngine;

public class Main {

  public static void main(String[] args) 
  {

    port(Integer.valueOf(System.getenv("PORT")));
    staticFileLocation("/public");
    
    get("/", (request, response) -> {
        Map<String, Object> attributes = new HashMap<>();
        attributes.put("message", "Hello World!");

        return new ModelAndView(attributes, "index.ftl");
    }, new FreeMarkerEngine());
    

    get("/amazing", (request, response) -> {
    	String temp = "SOME_CONFIG = " + System.getenv("SOME_CONFIG") + "    SOME_OTHER_CONFIG = " + System.getenv("SOME_OTHER_CONFIG");
    	
    	Map<String, Object> attributes = new HashMap<>();
    	attributes.put("message", temp);

        return new ModelAndView(attributes, "amazing.ftl");
    }, new FreeMarkerEngine());
  }

}
