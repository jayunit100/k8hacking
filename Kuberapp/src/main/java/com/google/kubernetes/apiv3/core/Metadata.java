package com.google.kubernetes.apiv3.core;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by jayunit100 on 3/4/15.
 */
public class Metadata {

        public Labels labels;
        public Map<String, Object> additionalProperties = new HashMap<String, Object>();

        /**
         *
         * @return
         * The labels
         */
        public Labels getLabels() {
            return labels;
        }

        /**
         *
         * @param labels
         * The labels
         */
        public void setLabels(Labels labels) {
            this.labels = labels;
        }

        public Map<String, Object> getAdditionalProperties() {
            return this.additionalProperties;
        }

        public void setAdditionalProperty(String name, Object value) {
            this.additionalProperties.put(name, value);
        }
}
