table 71000002 "AIR Airport"
{

    fields
    {
        field(1;"Airport Code";Code [20])
        {
        }
        field(10;"City";Code [20])
        {
        }
        field(11;"Country";Code [20])
        {
        }


    }

    keys
    {
        key(PK;"Airport Code")
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

}