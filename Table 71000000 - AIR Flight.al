// Welcome to your new AL extension.
// Remember that object names and IDs should be unique across all extensions.
// AL snippets start with t*, like tpageext - give them a try and happy coding!

//here will be new table

table 71000000 "AIR Flight"
{
    CaptionML = ENU = 'Flight';
    DataCaptionFields = "Flight Number","Aircraft Type";

    fields
    {
        field(1;"Flight Number";Code[20])
        {
            CaptionML = ENU = 'Flight number';
        }
        field(8;"Departure";Code[20])
        {
            CaptionML = ENU = 'Departure airport';
            TableRelation = "AIR Airport"."Airport Code";
        }

        field(9;  "Aircraft Item No.";Code[20])
        {
            //TableRelation = Item."No." Where (Type = const(Inventory));
            
            CaptionML = ENU = 'Aircraft Item No.';
            trigger OnLookup();
            var
              AIRFunctions: Codeunit "AIR Functions";
            begin
                "Aircraft Item No." := AIRFunctions.ChooseFromAirplanesList();
            end;
            

        }
        
        field(10; "Aircraft Type";Code[20])
        {
            CaptionML = ENU = 'Aircraft type';

        }
        field(11;"Actual Departure Date"; Date)
        {
            CaptionML = ENU = 'Actual departure date';

        }
        field(12;"Actual Departure Time";Time)
        {
            CaptionML = ENU = 'Actual departure time';

        }
        field(13;"Actual Arrival Date"; Date)
        {
            CaptionML = ENU = 'Actual arrival date';

        }
        field(14;"Actual Arrival Time";Time)
        {
            CaptionML = ENU = 'Actual arrival date';

        }
        field(15;"Destination";Code[20])
        {
            CaptionML = ENU = 'Destination airport';
            TableRelation = "AIR Airport"."Airport Code";
            
        }

        field(16;"Passangers number"; Integer)
        {
            CaptionML = ENU = 'Passangers number';

        }
        field(17;Status;Option)
        {
            OptionMembers = "Did not take off","In the air","Landed";
            OptionCaptionML = ENU = 'Did not take off,In the air,Landed';
        }


    }

    keys
    {
        key(PK;"Flight Number")
        {
            Clustered = true;
        }
    }
    
    var
        myInt : Integer;

    trigger OnInsert();
    begin
    end;

    trigger OnModify();
    begin
    end;

    trigger OnDelete();
    begin
    end;

    trigger OnRename();
    begin
    end;

    procedure FillFieldsFromFlightNo(Flight: code [20];var AirFlight: Record "AIR Flight");
    var
      Schedule : Record "AIR Schedule";
      AIRFunctions : Codeunit "AIR Functions";
    begin
      if Schedule.Get(Flight) THEN
        WITH AirFlight do 
        begin
            Departure := Schedule.Departure;
            Destination := Schedule.Destination;
            "Aircraft Item No." := AIRFunctions.GetAirplaneItemNoFromAirplaneType("Aircraft Type");
            Status := Status;
        end;     
    end;

}
