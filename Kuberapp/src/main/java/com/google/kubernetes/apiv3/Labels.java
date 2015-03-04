package com.google.kubernetes.apiv3;

import java.util.HashMap;
import java.util.Map;
import javax.annotation.Generated;


/**
 * Created by jayunit100 on 3/4/15.
 */
public class Labels {

        public  String name;
        public Map<String, Object> additionalProperties = new HashMap<String, Object>();

        /**
         *
         * @return
         * The name
         */
        public String getName() {
            return name;
        }

        /**
         *
         * @param name
         * The name
         */
        public void setName(String name) {
            this.name = name;
        }

        public Map<String, Object> getAdditionalProperties() {
            return this.additionalProperties;
        }

        public void setAdditionalProperty(String name, Object value) {
            this.additionalProperties.put(name, value);
        }

}
