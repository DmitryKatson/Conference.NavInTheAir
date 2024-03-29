pageextension 50000 "AIR Item Card Ext." extends "Item Card"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        addbefore(Warehouse) 
        {
            action(ShowLiveFlights)
            {
                ApplicationArea = ALL;
                CaptionML = ENU = 'Live Flights';
                ToolTipML = ENU = 'Show live flight of current airplane type';
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                Image = Map;
                PromotedOnly = false;
                
                trigger OnAction(); 
                var
                   AIRFlightawareFunctions: Codeunit "Air Flightaware functions";
                   AIRFunctions : Codeunit "AIR Functions";
                   AirPlaneType : Code[20];
                begin
                    AirPlaneType := AIRFunctions.GetAirPlaneTypeValueNameFromItemNo("No.");
                    if AirPlaneType <> '' then
                       AIRFlightawareFunctions.ShowCurrentFlightsForAirplaneType(AirPlaneType)
                    else
                       Message('Fill Model for Airplane in Item attributes');
                end;

            }
        }
    }
    
    var
}