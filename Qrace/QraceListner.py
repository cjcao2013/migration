ROBOT_LISTENER_API_VERSION = 2


def start_suite(name, attrs):
    print("SUITE STARTED!!!")


def start_test(name, attrs):
    print("TEST STARTED!!!")


def end_test(name, attrs):
    print("TEST ENDED!!!")
    if attrs['status'] == 'PASS':
        print("TEST PASSED!!!")


def end_suite(name, attrs):
    print("SUITE ENDED!!!")


def close():
    print("SUITE CLOSED!!!")
