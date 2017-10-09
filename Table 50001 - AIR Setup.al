table 50001 "AIR Setup"
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
            TableRelation = "Item Attribute".Name;
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

    procedure GetAirPlaneCategory(ShowNotification: Boolean) : Code[20];
    var 
    AIRFunctions : Codeunit "AIR Functions";
    begin
        IF NOT AIRFunctions.CheckIfAIRAppIsProperlySetuped(ShowNotification) then
           exit;
        GET;   
        EXIT("Airplane Category");
    end;

    procedure GetAirPlaneAttribute(ShowNotification: Boolean) : Code[20];
    var 
    AIRFunctions : Codeunit "AIR Functions";
    begin
        IF NOT AIRFunctions.CheckIfAIRAppIsProperlySetuped(ShowNotification) then
           exit;
        GET;   
        EXIT("Airplane Type Attribute");
    end;

    procedure ShowNotificationWhenAIRCategoryDoesNotExist();
    var
        Notifications: Codeunit "AIR Notifications";
    begin
        If GetAirPlaneCategory(false) = '' then
           Notifications.ShowNotificationWhenAIRCategoryDoesNotExist();
    end;

    procedure ShowNotificationWhenAIRAttributeDoesNotExist();
    var
        Notifications: Codeunit "AIR Notifications";
    begin
        If GetAirPlaneAttribute(false) = '' then
           Notifications.ShowNotificationWhenAIRAttributeDoesNotExist();
    end;


}