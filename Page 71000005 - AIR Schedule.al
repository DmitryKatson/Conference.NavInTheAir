page 71000005 "AIR Schedule"
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
                field(Status;Status)
                {
                    ApplicationArea = All;
                }
                field("Plan Departure Date";"Plan Departure Date")
                {
                    ApplicationArea = All;
                }
                field("Plan Departure Time";"Plan Departure Time")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

}