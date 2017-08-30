table 71000001 "AIR Setup"
{

    fields
    {
        field(1;Code;Code[20])
        {

        }
        field(10;"Airplane Category";Code[20])
        {
            TableRelation = "Item Category";
        }
        field(11;"Airplane Type Attribute";Code[20])
        {
            TableRelation = "Item Attribute".ID;
        }
    }

    keys
    {
        key(PK;Code)
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

    procedure GetAirPlaneCategory() : Code[20];
    var 
    AIRFunctions : Codeunit "AIR Functions";
    begin
        IF NOT AIRFunctions.CheckIfAIRAppIsProperlySetuped then
           exit;
        GET;   
        EXIT("Airplane Category");
    end;

    procedure GetAirPlaneAttribute() : Code[20];
    var 
    AIRFunctions : Codeunit "AIR Functions";
    begin
        IF NOT AIRFunctions.CheckIfAIRAppIsProperlySetuped then
           exit;
        GET;   
        EXIT("Airplane Type Attribute");
    end;


}