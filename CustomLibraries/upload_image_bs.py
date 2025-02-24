import requests
from robot.api.deco import library, keyword
from robot.libraries.BuiltIn import BuiltIn


@library
class upload_image_bs:

    @keyword("TEST Upload Image")
    def upload(self,path,BS_user,BS_accesskey):
        driver = BuiltIn().get_library_instance('AppiumLibrary')._current_application()
        # appium_library = BuiltIn().get_library_instance('AppiumLibrary')
        # driver = appium_library.driver
        imageimdialink = self.Get_BS_MediaLink(path,BS_user,BS_accesskey)
        print("Inside Test Upload")
        print(imageimdialink)
        print(
            'browserstack_executor: {"action":"cameraImageInjection", "arguments": {"imageUrl" : "' + imageimdialink + '"}}')
        driver.execute_script(
            'browserstack_executor: {"action":"cameraImageInjection", "arguments": {"imageUrl" : "' + imageimdialink + '"}}')
    # driver.execute_script('browserstack_executor: {"action":"cameraImageInjection", "arguments": {"imageUrl" : "media: // a24966857082cdedae3f75f016fa553ba4b6b18e"}}')

    @keyword('Get BS MediaLink')
    def Get_BS_MediaLink(self,path,BS_user,BS_accesskey):
        # path = "C:/Users/223744/Downloads/Screenshot_20231111_084418_Google Play Store.jpg"
        global field_value
        BASE_URL = "https://api-cloud.browserstack.com/app-automate"
        USERNAME = BS_user
        PASSWORD = BS_accesskey
        # Define the API endpoint
        endpoint = "/upload-media"
        url = f"{BASE_URL}{endpoint}"
        # Set up Basic Authentication
        auth = requests.auth.HTTPBasicAuth(USERNAME, PASSWORD)
        # Prepare form data
        # data = {"key1": "value1", "key2": "value2"}
        # Prepare files (replace with your actual file path)
        files = {"file": open(path, "rb")}
        # Make the request with Basic Auth and form data
        # response = requests.post(url, auth=auth, data=data, files=files)
        response = requests.post(url, auth=auth, files=files)
        # Print the response status code and content
        print(f"Status Code: {response.status_code}")
        print("Response Content:")
        print(response.text)
        # Check if the request was successful (status code 200)
        if response.status_code == 200:
            # Parse the JSON response
            json_response = response.json()
            # Access specific fields in the JSON response
            field_value = json_response.get("media_url")
            # Print the parsed JSON and specific field
            print("Parsed JSON Response:")
            print(json_response)
            print("\nValue of 'field_name':", field_value)
        else:
            print(f"Request failed with status code {response.status_code}")
            print("Response Content:")
            print(response.text)
        print(field_value)
        return field_value
