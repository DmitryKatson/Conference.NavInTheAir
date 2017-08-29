table 71000003 "AIR Schedule"
{

    CaptionML = ENU = 'Schedule';
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
        }
        
        field(10; "Aircraft Type";text[20])
        {
            CaptionML = ENU = 'Aircraft type';

        }
        field(11;"Departure Date"; text[30])
        {
            CaptionML = ENU = 'Departure date';

        }
        field(12;"Departure Time";Text[30])
        {
            CaptionML = ENU = 'Departure time';

        }
        field(13;"Arrival Date"; Text[30])
        {
            CaptionML = ENU = 'Arrival date';

        }
        field(14;"Arrival Time";Text[30])
        {
            CaptionML = ENU = 'Arrival date';

        }
        field(15;"Destination";Code[20])
        {
            CaptionML = ENU = 'Destination airport';
            TableRelation = "AIR Airport"."Airport Code";
            
        }

        field(16;"Progress %"; Decimal)
        {
            CaptionML = ENU = 'Progress %';
        }

        field(17;Status;Option)
        {
            OptionMembers = "Did not take off","In the air","Landed";
            OptionCaptionML = ENU = 'Did not take off,In the air,Landed';
        }

        field(18;"Distance filled";Decimal)
        {
            CaptionML = ENU = 'Distance filled';
        }


    }

    keys
    {
        key(PK;"Flight Number")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown;"Flight Number",Departure,Destination,"Aircraft Type",
                            "Departure Date","Departure Time",
                            "Arrival Date","Arrival Time",
                            "Progress %",Status) 
        {

        }
    }

    procedure GetStatus() :Integer;
    var
    begin
       If "Progress %" = 0 then
          EXIT(Status::"Did not take off"); 
       If "Progress %" = 100 then
          EXIT(Status::Landed); 
       EXIT(Status::"In the air");
    end;
    
}