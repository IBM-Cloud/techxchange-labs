# Service bindings

Service bindings provide applications and jobs access to IBM Cloud services. 

## Let’s bind a service to your project

1. Go to the list of projects at https://cloud.ibm.com/codeengine/projects
1. Select the project you created previously.
1. Click **Service bindings**.
1. Click **Create**.
   1. Under **IBM Cloud service instance**, select the _Cloud Object Storage_ instance.
   1. For **Bind to**, select your _Hello World_ application.
   1. Set **Role** to **Writer**.
   ![](images/40-create-binding.png ':size=400')
1. Click **Add**.
   ![](images/40-binding-created.png ':size=400')

?> **Well done!** You have created a service binding between your Code Engine application and IBM Cloud Object Storage.

When you bind a service instance to an app or job, Code Engine uses a service access secret to store the credential of the specified IBM Cloud service instance. This type of secret is the key mechanism in a service binding that connects the IBM Cloud service instance to a particular Code Engine app or job. Code Engine creates and manages this secret for you.

Binding a service instance to a Code Engine application or job automatically adds credentials for a service instance to the environment variables of the container for your application or the job.

## View the credentials in the application

1. Click **Applications** to go to your Code Engine applications.
1. Click **Open URL** to open your specific application in a browser.

The output of your application now displays the credentials to access the *Cloud Object Storage* instance as environment variables in the application. For this example, the environment variables are named in the format `CLOUD_OBJECT_STORAGE_`.

   ![](images/40-credentials.png ':size=400')

?> You might need to refresh the page a few times before the application reflects the changes.

Code Engine provides environment variables for accessing service instances that are bound to your Code Engine workload with both the `CE_SERVICES` and `PREFIX` methods.

* The `CE_SERVICES` environment variable is a single environment variable that contains all service binding information as a JSON object.
* Code Engine also creates multiple environment variables for your service binding, which are based on the variables in the service credential for your service instance. To distinguish these multiple environment variables for your service binding, you can use a PREFIX such that these environment variables use the same prefix. If you do not specify a custom prefix, Code Engine automatically generates a prefix.

The `hello world` example only displays the credentials. In a real application, in your source code, you will typically use the credentials to access the target service through its API. You would initialize the API (or SDK) with values from the environment variables created by Code Engine.

?> If you look at the application dashboard for your specific application, you will see that Code Engine created a new revision of the application when the binding was created. The new configuration revision is expected because you changed the configuration of this application to add the binding.<br/><br/>
![](images/40-new-revision.png ':size=400')

⇨ [Continue to Logging and monitoring](50-logging-and-monitoring.md)