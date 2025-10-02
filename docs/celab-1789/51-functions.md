# Functions

A function is a stateless code snippet that performs tasks as it is invoked by HTTP requests. With IBM Code Engine functions, you can run your business logic in a scalable and serverless way. IBM Code Engine functions provide an optimized runtime environment to support low latency and rapid scale-out scenarios. Your function code can be written in a managed runtime that includes specific Node.js or Python versions.

## Create a function

1. Go to the list of projects at https://cloud.ibm.com/containers/serverless/projects
1. Select the project you created previously.
1. Select **Functions** in the navigation menu.
1. Click **Create** in the table.
1. Set the **Name** to `<your-username>-fn`. As example `celab-123-fn`.
   ![](images/51-create-function.png ':size=750')

The form is filled with default values that will be perfect to try out Functions.

Let's review them.

Under **Code**:
* the **Runtime image** is set to **Node.js 20**. Functions include Node and Python managed runtimes.
* the **Code bundle options** is set to **Edit inline code** making it very handy for quick tests.
  * Review the code in the editor. It is a simple Node.js function that will return the environment variables defined in the function runtime together with the function arguments.
  * There are other options available such as the ability to point to a source code repository or to a pre-built code bundle.

**Resources & scaling**, **Domain mappings** and **Optional settings** are similar to what you have observed for *Applications*.

Finally click **Create**.

## Test the function

1. Wait for the function to be **Ready**.
1. Click on **Test function**.
1. Click on **Send request**.
1. The function is invoked and returns its results.
   ![](images/51-test-function.png ':size=750')


## Deploy a change

You can change the function code on the fly from the text editor.

1. Click the editor and change `main.js` as below to replace the response body with a single property:
   ```javascript
   function main(args) {
     const body = {
       hello: "world" // replace the body with a single property
     };

     console.log(`Return body: ${JSON.stringify(body, null, 2)}`);

     return {
       statusCode: 200,
       headers: { 
         'Content-Type': 'application/json', 
       },
       body,
     };
   }

   module.exports.main = main;
   ```
1. Click **Deploy**.
1. Use **Test function** and **Send request** again to confirm the new attribute is returned.
   ![](images/51-verify-update.png ':size=750')

?> You just deployed your first function and deployed a new version in no time!

⇨ [Continue to Build from source](55-build-from-source.md)