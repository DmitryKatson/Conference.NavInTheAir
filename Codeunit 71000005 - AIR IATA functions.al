codeunit 71000005 "AIR IATA Functions"
{
    trigger OnRun();
    begin
    end;
    
    var

    procedure GetAirports();
    var
    begin
       GetAirportsFromIATACodes(); 
    end;

    local procedure GetAirportsFromIATACodes();
    var
        Arguments : Record "AIR WebService Argument";
    begin
        InitArguments(Arguments,'airports');
        IF not CallWebService(Arguments) then
           EXIT;
        SaveResultInAirportTable(Arguments);
    end;

    local procedure InitArguments(var Arguments: Record "AIR WebService Argument" temporary; APIRequest: Text);
    var
    begin
       WITH Arguments DO begin
           URL        := STRSUBSTNO('%1%2?api_key=%3',GetBaseURL,APIRequest,GetAPIKey);
           RestMethod := RestMethod::get;
       end; 
    end;

    local procedure CallWebService(var Arguments: Record "AIR WebService Argument" temporary) Success : Boolean
    var
        WebService: codeunit "AIR WebService Call Functions";
    begin
        Success := WebService.CallWebService(Arguments);
    end;

    local procedure GetBaseURL(): Text;
    var
    begin
       EXIT('https://iatacodes.org/api/v6/'); 
    end;

    local procedure GetAPIKey(): Text;
    var
    begin
      EXIT('aa7c0f06-2054-4aa0-871d-0e60dead2492'); //change for setup
    end;

    local procedure SaveResultInAirportTable(var Arguments: Record "AIR WebService Argument" temporary)
    var
        Airport : Record "AIR Airport";
        WebService : Codeunit "AIR WebService Call Functions";
        JsonArray :JsonArray;
        JsonToken: JsonToken;
        JsonObject: JsonObject;
        i : Integer;
        ResponseInTextFormat :Text;
    begin

        Airport.DeleteAll;

        ResponseInTextFormat := Arguments.GetResponseContentAsText;

        HandleResponseForJsonArrayFormat(ResponseInTextFormat);

        If not JsonArray.ReadFrom(ResponseInTextFormat) then
          error('Invalid response, expected an JSON array as root object');
       
        For i:= 0 to JsonArray.Count - 1 do
        begin 
            JsonArray.Get(i,JsonToken);
            JsonObject := JsonToken.AsObject;

            WITH Airport do begin
                INIT;
                "Airport Code" := WebService.GetJsonValueAsText(JsonObject,'code');
                Name           := WebService.GetJsonValueAsText(JsonObject,'name');
                //City           := WebService.GetJsonToken(JsonObject,'city').AsValue.AsText;
                //Country        := WebService.GetJsonToken(JsonObject,'country_code').AsValue.AsText;
                                  //SelectJsonToken(JsonObject,'$.user.login').AsValue.AsText; //if nested structure
                INSERT;
            end;
        end;
        
    end;

    local procedure HandleResponseForJsonArrayFormat(var Response:Text);
    var
    begin
        Response := CopyStr(Response,GetStartPositionOfJsonArray(Response),STRLEN(Response)-GetStartPositionOfJsonArray(Response));
    end;

    local procedure GetStartPositionOfJsonArray(Response:Text):Integer;
    var
    begin
       EXIT(STRPOS(Response,'"response":') + 11); 
    end;


}