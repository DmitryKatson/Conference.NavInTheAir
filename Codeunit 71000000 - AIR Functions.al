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
        TempFilterItemAttributesBuffer : Record "Filter Item Attributes Buffer" temporary;
        ItemAttributeManagement : Codeunit "Item Attribute Management";
        TempFilteredItem : Record Item temporary;
    begin
        FillItemAttributesBufferFilter(AirplaneType,TempFilterItemAttributesBuffer);
        ItemAttributeManagement.FindItemsByAttributes(TempFilterItemAttributesBuffer,TempFilteredItem);    
        EXIT(GetItemNoFromItemsFilteredByAttributes(TempFilteredItem));
    end;

    procedure FillItemAttributesBufferFilter(Value:Text; VAR TempFilterItemAttributesBuffer : Record "Filter Item Attributes Buffer" temporary);
    var
        ItemAttributeManagement : Codeunit "Item Attribute Management"; 
        AIRSetup : Record "AIR Setup";       
    begin
       WITH TempFilterItemAttributesBuffer do
       begin
         INIT;
         Attribute := AIRSetup.GetAirPlaneAttribute;
         Value    := Value;
         Insert;
       end; 
    end;

    local procedure GetItemNoFromItemsFilteredByAttributes(TempFilteredItem : Record Item temporary): Code[20];
    var
    begin
       IF TempFilteredItem.COUNT = 1 then
       begin
           TempFilteredItem.FindFirst;
           EXIT(TempFilteredItem."No.");
       end;
       EXIT(''); 
    
    end;
}