## Welcome to PetStoreBook !

This application will run a web server which returns REDIS records for a petstore application.

It is meant to simulate and test high load on kubernetes or any other docker based system.

## Dependencies

This project depends on no other images or services, however, it is nicely complimented by 

jayunit100/BigPetStoreLoadGenerator (github) which is published to docker as jayunit100/bigpetstore-load-generator.

## Get started

Run the usual commands to create a docker image.

```
docker build -t jayunit100/k8petstore ./
docker run -t -i jayunit100/k8petstore 
```

Which should yield

```
jayunit100smacbookpro:k8petstore jayunit100$ docker run -i -t jayunit100/k8petstore
If in kube, this is a failure: Missing env variable REDIS_MASTER_SERVICE_HOSTconnectin to 192.168.59.103:6379
[negroni] listening on :3000
```

This should launch a container, which runs on port 3000.

## Questions

For questions about bigpetstore, and how the data is generated, ask on the apache bigtop mailing list.

Contact jay@apache.org directly. This is a brand new project and I'm currently building kubernetes recipes for it.
