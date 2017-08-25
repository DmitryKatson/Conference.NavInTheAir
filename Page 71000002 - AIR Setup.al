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
        area(processing)
        {
            action(ActionName)
            {
                trigger OnAction();
                begin
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