codeunit 71000000 "AIR Functions"
{
    trigger OnRun();
    begin
    end;
    
    var

    procedure GetNotificationGUID(): Text;
    begin
        EXIT('50f37db2-5dc0-414b-ba49-53916c44764f')
    end;

    procedure CheckIfAIRAppIsProperlySetuped() : Boolean;
    var 
        AIRSetup : Record "AIR Setup";
        AIRNotification: Codeunit "AIR Notifications";
    begin
        WITH AIRSetup do
           IF Not Get OR ("Airplane Category" = '') OR ("Airplane Type Attribute" = '') then
           Begin
             AIRNotification.ShowNotificationWhenAIRappIsNotSetupedCorrectly();      
           EXIT(false);
           end;
        EXIT(true);
    end;

    procedure ShowAirplanesList();
    var
        AIRSetup : Record "AIR Setup";
        AirplaneCategory: Code [20];
        Item: Record Item;
    begin
        AirplaneCategory := AIRSetup.GetAirPlaneCategory();
        IF AirplaneCategory = '' THEN 
            EXIT;
        Item.SETRANGE("Item Category Code",AirplaneCategory);
        PAGE.RUN(PAGE::"Item List",Item);
    end;

    procedure ChooseFromAirplanesList(): Code [20];
    var
        AIRSetup : Record "AIR Setup";
        AirplaneCategory: Code [20];
        Item: Record Item;
    begin
        AirplaneCategory := AIRSetup.GetAirPlaneCategory();
        IF AirplaneCategory = '' THEN 
            EXIT;
        Item.SETRANGE("Item Category Code",AirplaneCategory);
        if PAGE.RUNMODAL(PAGE::"Item List",Item) = "Action"::LookupOK then
           EXIT(Item."No.");
    end;


    procedure GetAirplaneItemNoFromAirplaneType(AirplaneType : Text) : code[20];
    var
        item : record Item;
    begin
        //find item
        EXIT('');
    end;
}