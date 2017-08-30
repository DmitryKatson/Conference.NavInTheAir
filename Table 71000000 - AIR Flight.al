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
              ItemNo : Code[20];
            begin
                ItemNo := AIRFunctions.ChooseFromAirplanesList("Aircraft Type");
                If ItemNo <> '' then
                   VALIDATE("Aircraft Item No.",ItemNo);
            end;
            

        }
        
        field(10; "Aircraft Type";Code[20])
        {
            CaptionML = ENU = 'Aircraft type';

        }
        field(11;"Departure Date"; Text[30])
        {
            CaptionML = ENU = 'Actual departure date';

        }
        field(12;"Departure Time";Text[30])
        {
            CaptionML = ENU = 'Actual departure time';

        }
        field(13;"Arrival Date"; Text[30])
        {
            CaptionML = ENU = 'Actual arrival date';

        }
        field(14;"Arrival Time";Text[30])
        {
            CaptionML = ENU = 'Actual arrival date';

        }
        field(15;"Destination";Code[20])
        {
            CaptionML = ENU = 'Destination airport';
            TableRelation = "AIR Airport"."Airport Code";
            
        }

        field(17;Status;Option)
        {
            OptionMembers = "Did not take off","In the air","Landed";
            OptionCaptionML = ENU = 'Did not take off,In the air,Landed';
        }

        field(26;"Passangers number"; Integer)
        {
            CaptionML = ENU = 'Passangers number';

        }
        field(20;"Flight ID";Text[50])
        {
            CaptionML = ENU = 'Flight ID';
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
            Transferfields(Schedule,false);
            //Departure := Schedule.Departure;
            //Destination := Schedule.Destination;
            //"Aircraft Type" := Schedule."Aircraft Type";
            "Aircraft Item No." := AIRFunctions.GetAirplaneItemNoFromAirplaneType("Aircraft Type");
            //Status := Schedule.Status;
        end;     
    end;

}
