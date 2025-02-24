try:
    import requests
    import json
    from robot.libraries.BuiltIn import BuiltIn
    from robot.libraries.BuiltIn import _Misc
    import robot.api.logger as logger
    from robot.api.deco import library, keyword
    ROBOT = False
except Exception:
    ROBOT = False


@library
class Upload_app_on_BS:

    @keyword('Get Appcenter ids')
    def Get_AppCenter_ID(self, app, org, api_token):
        global id_value
        # global short_version

        BASE_URL = "https://api.appcenter.ms"
        endpoint = f'/v0.1/apps/{org}/{app}/releases'

        url = f"{BASE_URL}{endpoint}"
        headers = {
            "X-API-Token": api_token,
            "accept": "application/json"
        }
        params = {
            "published_only": "true",
            "scope": "tester"
        }

        response = requests.get(url, headers=headers, params=params)
        print(f"Status Code: {response.status_code}")
        if response.status_code == 200:
            data = json.loads(response.text)
            # Sort the list of dictionaries based on the 'id' parameter
            sorted_data = sorted(data, key=lambda x: x['id'], reverse=True)
            json_response = sorted_data[0]
            id_value = json_response.get("id")
            short_version = json_response.get("short_version")
            print("Parsed JSON Response:")
            print(json_response)
            print("\nValue of 'id':", id_value)
            print("\nValue of 'short_version':", short_version)
        else:
            print(f"Request failed with status code {response.status_code}")
            print("Response Content:")
            print(response.text)

        return id_value

    @keyword('Get Appcenter APP URL')
    def Get_AppCenter_URL(self, app, org, api_token, id):
        BASE_URL = "https://install.appcenter.ms"
        endpoint = f'/api/v0.1/apps/{org}/{app}/releases/{id}'

        url = f"{BASE_URL}{endpoint}"
        headers = {
            "X-API-Token": api_token,
            "accept": "application/json"
        }
        params = {
            "is_install_page": "true"
        }

        response = requests.get(url, headers=headers, params=params)
        print(f"Status Code: {response.status_code}")
        if response.status_code == 200:
            json_response = response.json()
            install_url = json_response.get("download_url")
            print("Parsed JSON Response:")
            print(json_response)
            print("\nValue of 'install_url':", install_url)
            print(install_url)

        else:
            print(f"Request failed with status code {response.status_code}")
            print("Response Content:")
            print(response.text)

        return install_url

    @keyword('Upload App on BS')
    def Upload_APP_BS(self, install_url, username, password):
        BASE_URL = "https://api-cloud.browserstack.com/app-automate"
        endpoint = "/upload"

        url = f"{BASE_URL}{endpoint}"
        auth = requests.auth.HTTPBasicAuth(username, password)
        files = {
            "url": install_url
        }
        response = requests.post(url, auth=auth, data=files)
        print(f"Status Code: {response.status_code}")
        print("Response Content:")
        print(response.text)
        if response.status_code == 200:
            json_response = response.json()
            app_url = json_response.get("app_url")
            print("Parsed JSON Response:")
            print(json_response)
            print("\nValue of 'app_url':", app_url)
            print(app_url)

        else:
            print(f"Request failed with status code {response.status_code}")
            print("Response Content:")
            print(response.text)

        return app_url

