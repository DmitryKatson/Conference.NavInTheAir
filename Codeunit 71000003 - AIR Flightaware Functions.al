codeunit 71000003 "Air Flightaware functions"
{
    trigger OnRun();
    begin
    end;
    
    var

    procedure GetDepartures(FromAirport:Code[20]);
    var
    begin
       GetDeparturesFromFlightAwareInXML3Format(FromAirport); 
    end;

    local procedure GetDeparturesFromFlightAwareInXML3Format(FromAirport :Code[20]);
    var
        Arguments : Record "AIR WebService Argument";
    begin
        InitArguments(Arguments,STRSUBSTNO('AirportBoards?airport_code=%1&type=departures&howMany=100',FromAirport));//change request here
        IF not CallWebService(Arguments) then
           EXIT;
        SaveResultInAirportDepartureTable(Arguments);
    end;

    local procedure InitArguments(var Arguments: Record "AIR WebService Argument" temporary; APIRequest: Text);
    var
    begin
       WITH Arguments DO begin
           URL        := STRSUBSTNO('%1%2',GetBaseURL,APIRequest);
           //Message(STRSUBSTNO('https://%1:%2@%3%4',GetUserName,GetAPIKey,GetBaseURL,APIRequest));
           RestMethod := RestMethod::get;
           UserName := GetUserName;
           Password := GetAPIKey;
       end; 
    end;

    local procedure GetBaseURL(): Text;
    var
    begin
       EXIT('https://flightxml.flightaware.com/json/FlightXML3/'); 
    end;

    local procedure GetUserName(): Text;
    var
    begin
       EXIT('dkatson'); //change for setup
    end;

    local procedure GetAPIKey(): Text;
    var
    begin
      EXIT('f7217091a2bdc7fda21686a1f157afa9a11e6d01'); //change for setup
    end;


    local procedure CallWebService(var Arguments: Record "AIR WebService Argument" temporary) Success : Boolean
    var
        WebService: codeunit "AIR WebService Call Functions";
    begin
        Success := WebService.CallWebService(Arguments);
    end;


    local procedure SaveResultInAirportDepartureTable(var Arguments: Record "AIR WebService Argument" temporary)
    var
        Schedule : Record "AIR Schedule";
        WebService : Codeunit "AIR WebService Call Functions";
        JsonArray :JsonArray;
        JsonToken: JsonToken;
        JsonObject: JsonObject;
        i : Integer;
        ResponseInTextFormat :Text;

    begin
        ResponseInTextFormat := Arguments.GetResponseContentAsText;
        
        HandleResponseForJsonArrayFormat(ResponseInTextFormat);
        //Message(ResponseInTextFormat);


        Schedule.DeleteAll;

        If not JsonArray.ReadFrom(ResponseInTextFormat) then
          error('Invalid response, expected an JSON array as root object');
       
        For i:= 0 to JsonArray.Count - 1 do
        begin 
            JsonArray.Get(i,JsonToken);
            JsonObject := JsonToken.AsObject;

            WITH Schedule do begin
                //WebService.GetJsonToken(JsonObject,'country_code').AsValue.AsText; //if field
                //WebService.SelectJsonToken(JsonObject,'$.user.login').AsValue.AsText; //if nested structure

                INIT;
                "Flight Number" := WebService.GetJsonToken(JsonObject,'ident').AsValue.AsText;
                Departure       := WebService.SelectJsonToken(JsonObject,'$.origin.alternate_ident').AsValue.AsText;
                Destination     := WebService.SelectJsonToken(JsonObject,'$.destination.alternate_ident').AsValue.AsText;
                "Departure Date" := WebService.SelectJsonToken(JsonObject,'$.filed_departure_time.date').AsValue.AsText;
                "Departure Time" := WebService.SelectJsonToken(JsonObject,'$.filed_departure_time.time').AsValue.AsText;
                "Arrival Date"   := WebService.SelectJsonToken(JsonObject,'$.filed_arrival_time.date').AsValue.AsText;;
                "Arrival Time"   := WebService.SelectJsonToken(JsonObject,'$.filed_arrival_time.time').AsValue.AsText;;
                "Aircraft Type" := WebService.GetJsonToken(JsonObject,'aircrafttype').AsValue.AsText;
                "Progress %"   := WebService.GetJsonToken(JsonObject,'progress_percent').AsValue.AsDecimal;
                //"Distance filled" := WebService.GetJsonToken(JsonObject,'distance_filed').AsValue.AsDecimal;
                Status         := GetStatus();
                INSERT;
            end;
        end;
        
    end;

    local procedure HandleResponseForJsonArrayFormat(var Response:Text);
    var
       CopyFrom : Integer;
       CopyTo   : Integer;
       Lenght   : Integer;
    begin
        Lenght := StrLen(Response);
        CopyFrom := GetStartPositionOfJsonArray(Response);
        CopyTo   := GetLastPositionOfJsonArray(Response);
        Response := CopyStr(Response,CopyFrom,Lenght - CopyFrom - 2);
    end;

    local procedure GetStartPositionOfJsonArray(Response:Text):Integer;
    var
    begin
       EXIT(STRPOS(Response,'[')); 
    end;

    local procedure GetLastPositionOfJsonArray(Response:Text):Integer;
    var
    begin
       EXIT(STRPOS(Response,']')); 
    end;

}