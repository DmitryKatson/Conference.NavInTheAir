page 71000004 "AIR Airports List"
{
    PageType = List;
    SourceTable = "AIR Airport";
    CaptionML = ENU = 'Airports List';
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Airport Code";"Airport Code")
                {
                    ApplicationArea  = All;
                }
                field(City;City)
                {
                    ApplicationArea  = All;
                }

                field(Country;Country)
                {
                    ApplicationArea  = All;
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
            action(GetAirports)
            {
                CaptionML = ENU = 'Update';
                ToolTipML = ENU = 'Update airports from Flightaware service';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                Image = UpdateXML;

                trigger OnAction();
                var
                  AIRFlightawareFunctions : Codeunit "Air Flightaware functions";
                begin
                    AIRFlightawareFunctions.GetAirports();
                    CurrPage.Update;
                end;
            }
        }
    }
}