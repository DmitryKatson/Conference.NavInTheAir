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

    procedure GetFlightStatus(FlightNo:Code[20]);
    begin
       GetFlightStatusFromFlightAwareInXML3Format(FlightNo);         
    end;

    local procedure GetFlightStatusFromFlightAwareInXML3Format(FlightNo :Code[20]);
    var
        Arguments : Record "AIR WebService Argument";
    begin
        InitArguments(Arguments,STRSUBSTNO('FlightInfoStatus?ident=%1',FlightNo));//change request here
        IF not CallWebService(Arguments) then
           EXIT;
        SaveResultInFlightTable(Arguments);
    end;

    procedure ShowFlight(FlightNo :Code[20]);
    begin
        Hyperlink(STRSUBSTNO('https://ru.flightaware.com/live/flight/%1',FlightNo));
    end;

    procedure ShowCurrentFlightsForAirplaneType(AirplaneType:Code[20]);
    begin
        Hyperlink(STRSUBSTNO('https://ru.flightaware.com/live/aircrafttype/%1',AirplaneType));
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

                if JsonObject.GET('ident',JsonToken) THEN begin
                    INIT;
                    "Flight Number"  := WebService.GetJsonValueAsText(JsonObject,'ident');
                    Departure        := WebService.SelectJsonValueAsText(JsonObject,'$.origin.alternate_ident');
                    Destination      := WebService.SelectJsonValueAsText(JsonObject,'$.destination.alternate_ident');
                    "Departure Date" := WebService.SelectJsonValueAsText(JsonObject,'$.filed_departure_time.date');
                    "Departure Time" := WebService.SelectJsonValueAsText(JsonObject,'$.filed_departure_time.time');
                    "Arrival Date"   := WebService.SelectJsonValueAsText(JsonObject,'$.filed_arrival_time.date');
                    "Arrival Time"   := WebService.SelectJsonValueAsText(JsonObject,'$.filed_arrival_time.time');
                    "Aircraft Type"  := WebService.GetJsonValueAsText(JsonObject,'aircrafttype');
                    "Progress %"     := WebService.GetJsonValueAsDecimal(JsonObject,'progress_percent');
                    "Distance"       := WebService.GetJsonValueAsDecimal(JsonObject,'distance_filed');
                    "Destination City":= WebService.SelectJsonValueAsText(JsonObject,'$.destination.city');
                    "Flight ID"      := WebService.GetJsonValueAsText(JsonObject,'faFlightID');
                    Status         := GetStatus();
                    INSERT;
                end;
            end;
        end;
        
    end;

    local procedure SaveResultInFlightTable(var Arguments: Record "AIR WebService Argument" temporary)
    var
        Flight : Record "AIR Flight";
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

        If not JsonArray.ReadFrom(ResponseInTextFormat) then
          error('Invalid response, expected an JSON array as root object');
       
        For i:= 0 to JsonArray.Count - 1 do
        begin 
            JsonArray.Get(i,JsonToken);
            JsonObject := JsonToken.AsObject;

            WITH Flight do
                //WebService.GetJsonToken(JsonObject,'country_code').AsValue.AsText; //if field
                //WebService.SelectJsonToken(JsonObject,'$.user.login').AsValue.AsText; //if nested structure
                if JsonObject.GET('ident',JsonToken) THEN
                    If GET(WebService.GetJsonValueAsText(JsonObject,'ident')) And
                       ("Flight ID" = WebService.GetJsonValueAsText(JsonObject,'faFlightID')) then
                    begin
                      Schedule."Progress %" := WebService.GetJsonValueAsDecimal(JsonObject,'progress_percent');
                      Status                := Schedule.GetStatus();
                      Modify;
                      exit;
                    end;
        end;
        
    end;


    local procedure HandleResponseForJsonArrayFormat(var Response:Text);
    var
       CopyFrom : Integer;
       CopyTo   : Integer;
    begin
        CopyFrom := GetStartPositionOfJsonArray(Response);
        CopyTo   := GetLastPositionOfJsonArray(Response);
        IF CopyTo > CopyFrom then
           Response := CopyStr(Response,CopyFrom,CopyTo-CopyFrom + 1);
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