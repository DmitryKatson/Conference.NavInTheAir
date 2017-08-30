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
                    CaptionML = ENU = 'Departure';
                    Editable = false;
                    field("Departure Date";"Departure Date")
                    {
                        ApplicationArea = All;
                        Importance = Additional;
                    }
                    field("Departure Time";"Departure Time")
                    {
                        ApplicationArea = All;
                        Importance = Additional;
                        //ShowCaption = false;
                    }
                }
                group(ArrivalDates)
                {
                    Visible = IsLanded; 
                    CaptionML = ENU = 'Arrival';
                    Editable = false;
                    field("Actual Arrival Date";"Arrival Date")
                    {
                        ApplicationArea = All;
                        Importance = Additional;
                    }
                    field("Actual Arrival Time";"Arrival Time")
                    {
                        ApplicationArea = All;
                        Importance = Additional;
                        //ShowCaption = false;
                    }
                }

            }
        }
    }

    actions
    {
        area(processing)
        {
            action(UpdateStatus)
            {
                CaptionML = ENU = 'Update';
                ToolTipML = ENU = 'Update status from Flightaware service';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                Image = Refresh;

                trigger OnAction();
                var
                  FlightawareFunctions : Codeunit "AIR Flightaware Functions";
                begin
                    FlightawareFunctions.GetFlightStatus("Flight Number");
                    CurrPage.Update;
                end;
            }
            action(ShowFlight)
            {
                CaptionML = ENU = 'Show Flight';
                ToolTipML = ENU = 'Show this flight in Flightaware service';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                Image = LinkWeb;

                trigger OnAction();
                var
                  FlightawareFunctions : Codeunit "AIR Flightaware Functions";
                begin
                    FlightawareFunctions.ShowFlight("Flight Number");
                    CurrPage.Update;
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