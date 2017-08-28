codeunit 71000003 "Air Flightaware functions"
{
    trigger OnRun();
    begin
    end;
    
    var

    procedure GetAirports();
    var
    begin
       GetAirportsFromFlightAwareInXML3Format(); 
    end;

    local procedure GetAirportsFromFlightAwareInXML3Format();
    var
        Arguments : Record "AIR WebService Argument";
    begin
        InitArguments(Arguments,'AirportInfo?airport_code=KIAH');//change request here
        IF not CallWebService(Arguments) then
           EXIT;
        SaveResultInAirportTable(Arguments);
    end;

    local procedure InitArguments(var Arguments: Record "AIR WebService Argument" temporary; APIRequest: Text);
    var
    begin
       WITH Arguments DO begin
           //URL := STRSUBSTNO('https://%1:%2@%3%4',GetUserName,GetAPIKey,GetBaseURL,APIRequest);
           URL        := STRSUBSTNO('%1%2',GetBaseURL,APIRequest);
           RestMethod := RestMethod::get;
           UserName := GetUserName;
           Password := GetAPIKey;
       end; 
    end;

    local procedure CallWebService(var Arguments: Record "AIR WebService Argument" temporary) Success : Boolean
    var
        WebService: codeunit "AIR WebService Call Functions";
    begin
        Success := WebService.CallWebService(Arguments);
    end;

    local procedure SaveResultInAirportTable(var Arguments: Record "AIR WebService Argument" temporary)
    var
        Airport : Record "AIR Airport";
        WebService : Codeunit "AIR WebService Call Functions";
        JsonArray :JsonArray;
        JsonToken: JsonToken;
        JsonObject: JsonObject;
        i : Integer;
    begin
        //Message(Arguments.GetResponseContentAsText);

        Airport.DeleteAll;

        If not JsonArray.ReadFrom(Arguments.GetResponseContentAsText) then
          error('Invalid response, expected an JSON array as root object');
       
        For i:= 0 to JsonArray.Count - 1 do
        begin 
            JsonArray.Get(i,JsonToken);
            JsonObject := JsonToken.AsObject;

            WITH Airport do begin
                INIT;
                "Airport Code" := JsonToken.AsValue.AsCode;
                City           := WebService.GetJsonToken(JsonObject,'city').AsValue.AsText;
                Country        := WebService.GetJsonToken(JsonObject,'country_code').AsValue.AsText;
                                  //SelectJsonToken(JsonObject,'$.user.login').AsValue.AsText; //if nested structure
                INSERT;
            end;
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
}