package com.google.kubernetes.apiv3.core;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by jayunit100 on 3/4/15.
 */
public class TemplateSpec {

    Container[] containers;
    public TemplateSpec(Container... co){
        containers=co;
    }
}
