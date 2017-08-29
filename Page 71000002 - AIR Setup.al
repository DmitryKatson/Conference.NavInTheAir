page 71000002 "AIR Setup"
{
    PageType = Card;
    SourceTable = "AIR Setup";
    InsertAllowed = false;
    DeleteAllowed = false;
    CaptionML = ENU = 'Nav In The Air Setup';

    layout
    {
        area(content)
        {
            group(GroupName)
            {
                CaptionML = ENU = '';
                field("Airplane Category";"Airplane Category")
                {
                    ApplicationArea = All;
                }
                field("Airplane Type Attribute";"Airplane Type Attribute")
                {
                    ApplicationArea = All;
                }                
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(Airports)
            {
                RunObject = page "AIR Airports List";
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = CodesList;
                ApplicationArea = All;
            }
            action(Airplanes)
            {
                Image = Components;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                PromotedCategory = Report;
                ApplicationArea = All; 

                trigger OnAction();
                var
                    AIRFunctions : Codeunit "AIR Functions";
                begin
                    AIRFunctions.ShowAirplanesList();
                end;
            }

        }
    }
    
    var
    trigger OnOpenPage();
    var
    begin
        RESET;
        IF NOT GET THEN BEGIN
            INIT;
            INSERT;
        END;     
    end;
}