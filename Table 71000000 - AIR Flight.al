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
        field(9;  "Aircraft Item No.";Code[20])
        {
            TableRelation = Item."No." Where (Type = const(Inventory));
            CaptionML = ENU = 'Aircraft Item No.';

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

}
