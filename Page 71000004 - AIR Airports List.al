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
                field(Name;Name)
                {
                    ApplicationArea = All;
                }
                field(City;City)
                {
                    //ApplicationArea  = All;
                }

                field(Country;Country)
                {
                    //ApplicationArea  = All;
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
                ToolTipML = ENU = 'Update airports from IATA service';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                Image = UpdateXML;

                trigger OnAction();
                var
                  IATAFunctions : Codeunit "AIR IATA Functions";
                begin
                    IATAFunctions.GetAirports();
                    CurrPage.Update;
                end;
            }
        }
    }
}