page 71000001 "AIR Flight List"
{
    PageType = List;
    SourceTable = "AIR Flight";
    CardPageId = "AIR Flight Card";
    CaptionML = ENU = 'Flights';
    PromotedActionCategoriesML = ENU = 'New,Process,Navigate';

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
                field("Aircraft Item No.";"Aircraft Item No.")
                {
                    ApplicationArea = All;
                }
                field(Destination;Destination)
                {
                    ApplicationArea = All;
                }
                field("Passangers number";"Passangers number")
                {
                    ApplicationArea = All;
                }
                field(Status;Status)
                {
                    ApplicationArea = All;
                }
                field("Actual Departure Date";"Actual Departure Date")
                {
                    ApplicationArea = All;
                }
                field("Actual Departure Time";"Actual Departure Time")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
        }
    }

    actions
    {
        area(processing)
        {            
            action(Setup)
            {
                Image = Setup;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                PromotedCategory = Report;
                RunObject = page "AIR Setup";  
                ApplicationArea = All;              
            }
        }
    }
}