page 71000000 "AIR Flight Card"
{
    PageType = Card;
    SourceTable = "AIR Flight";
    CaptionML = ENU = 'Flight card';

    layout
    {
        area(content)
        {
            group(GroupName)
            {
                CaptionML = ENU = 'Flight info';
                field("Flight Number";"Flight Number")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Importance = Promoted;
                }
                field("Aircraft Item No.";"Aircraft Item No.")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Importance = Standard;
                }
                field(Destination;Destination)
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Importance = Promoted;
                }
                field("Passangers number";"Passangers number")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    Editable = false;
                }
                field(Status;Status)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    Editable = false;
                }
                group(DepartureDates)
                {
                    Visible = isInTheAirOrLanded; 
                    field("Actual Departure Date";"Actual Departure Date")
                    {
                        ApplicationArea = All;
                        Importance = Additional;
                    }
                    field("Actual Departure Time";"Actual Departure Time")
                    {
                        ApplicationArea = All;
                        Importance = Additional;
                        ShowCaption = false;
                    }
                }
                group(ArrivalDates)
                {
                    Visible = IsLanded; 
                    field("Actual Arrival Date";"Actual Arrival Date")
                    {
                        ApplicationArea = All;
                        Importance = Additional;
                    }
                    field("Actual Arrival Time";"Actual Arrival Time")
                    {
                        ApplicationArea = All;
                        Importance = Additional;
                        ShowCaption = false;
                    }
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
        IsLanded : Boolean;
        IsInTheAirOrLanded :Boolean;
    
    trigger OnAfterGetRecord();
    begin
        CheckCurrentStatus();
    end;

    local procedure CheckCurrentStatus();
    var
    begin
        IsLanded := Status in [Status::Landed];
        IsInTheAirOrLanded := (Status in [Status::"In the air",Status::Landed]);
    end;

    
}