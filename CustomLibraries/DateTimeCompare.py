from datetime import datetime



try:
    from robot.libraries.BuiltIn import BuiltIn
    from robot.api.deco import library, keyword

    ROBOT = False
except Exception:
    ROBOT = False


class DateTimeCompare:

    @keyword("Date Compare")
    def datecompare(self, owbdatetime, omnedatetime):
        owbdate = owbdatetime
        if owbdate.find('/') < 0:
            owbdatearr = owbdate.split(" ")
            months = dict(Jan=1, Feb=2, Mar=3, Apr=4, May=5, Jun=6, Jul=7, Aug=8, Sep=9, Oct=10, Nov=11, Dec=12)
            mon = months[owbdatearr[1]]
            owbtimearr = owbdatearr[3].split(":")
            print(owbdatearr[2])
            print(int(mon))
            print(owbdatearr[0])
            print(owbtimearr[0])
            print(owbtimearr[1])
            comparison_datetime = datetime(int(owbdatearr[2]), int(mon), int(owbdatearr[0]), int(owbtimearr[0]),
                                           int(owbtimearr[1]), 0)
        else:
            owbdatearr = owbdate.split(" ")
            print(owbdatearr)
            owbdate=owbdatearr[0].split("/")
            print(owbdate)
            owbtime=owbdatearr[1].split(":")
            print(owbtime)
            # months = dict(Jan=1, Feb=2, Mar=3, Apr=4, May=5, Jun=6, Jul=7, Aug=8, Sep=9, Oct=10, Nov=11, Dec=12)
            mon = owbdate[1]
            year=owbdate[0]
            day=owbdate[2]
            owbtimearr = owbdatearr[1].split(":")
            comparison_datetime = datetime(int(year), int(mon), int(day), int(owbtime[0]),
                                           int(owbtime[1]), 0)

        # datetime.now()# Create another date-time for comparison
        print(comparison_datetime)
        sysdatetime = omnedatetime
        sysdatetimearr = sysdatetime.split(" ")
        sysdatearr = sysdatetimearr[0].split("-")
        systimearr = sysdatetimearr[1].split(":")
        current_datetime = datetime(int(sysdatearr[0]), int(sysdatearr[1]), int(sysdatearr[2]), int(systimearr[0]),
                                    int(systimearr[1]), int(0))
        print(current_datetime)
        # comparison_datetime = datetime.now()
        # datetime(2024, 1, 19, 12, 0, 0))  # Replace with your desired date and time# Compare the two date-time values
        if current_datetime > comparison_datetime:
            print("Current date and time is greater than the comparison date and time.")
            return "false"
        else:
            print("Current date and time is not greater than the comparison date and time.")
            return "true"

