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
        
        field(10; "Aircraft Type";Code[20])
        {
            CaptionML = ENU = 'Aircraft type';

        }
        field(11;"Plan Departure Date"; Date)
        {
            CaptionML = ENU = 'Actual departure date';

        }
        field(12;"Plan Departure Time";Time)
        {
            CaptionML = ENU = 'Actual departure time';

        }
        field(13;"Plan Arrival Date"; Date)
        {
            CaptionML = ENU = 'Actual arrival date';

        }
        field(14;"Plan Arrival Time";Time)
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


    }

    keys
    {
        key(PK;"Flight Number")
        {
            Clustered = true;
        }
    }
    
    var



}