page 50005 "AIR Schedule"
{
    PageType = List;
    SourceTable = "AIR Schedule";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Flight Number";"Flight Number")
                {
                    ApplicationArea = All;
                }
                field(Destination;Destination)
                {
                    ApplicationArea = All;
                }
                field("Departure Date";"Departure Date")
                {
                    ApplicationArea = All;
                }
                field("Departure Time";"Departure Time")
                {
                    ApplicationArea = All;
                }

                field("Arrival Date";"Arrival Date")
                {
                    ApplicationArea = All;
                }
                field("Arrival Time";"Arrival Time")
                {
                    ApplicationArea = All;
                }
                field(Status;Status)
                {
                    ApplicationArea = All;
                }

                field("Progress %";"Progress %")
                {
                    ApplicationArea = All;
                }
                field("Distance";"Distance")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

}