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

    procedure ChooseFromAirplanesList(AirplaneType : Text): Code [20];
    var
        AIRSetup : Record "AIR Setup";
        AirplaneCategory: Code [20];
        Item: Record Item;
    begin
        AirplaneCategory := AIRSetup.GetAirPlaneCategory();
        IF AirplaneCategory = '' THEN 
            EXIT;
        Item.SETRANGE("Item Category Code",AirplaneCategory);
        FilterItemsByAirplaneType(Item,AirplaneType);
        if PAGE.RUNMODAL(PAGE::"Item List",Item) = "Action"::LookupOK then
           EXIT(Item."No.");
    end;


    local procedure FilterItemsByAirplaneType(var item : record Item;AirplaneType : Text);
    var
        TempFilterItemAttributesBuffer : Record "Filter Item Attributes Buffer" temporary;
        ItemAttributeManagement : Codeunit "Item Attribute Management";
        TempFilteredItem : Record Item temporary;
        FilterText : Text;
        ParameterCount : Integer;
        TypeHelper: Codeunit "Type Helper";
    begin
        FillItemAttributesBufferFilter(AirplaneType,TempFilterItemAttributesBuffer);
        ItemAttributeManagement.FindItemsByAttributes(TempFilterItemAttributesBuffer,TempFilteredItem);    
        FilterText := ItemAttributeManagement.GetItemNoFilterText(TempFilteredItem,ParameterCount);
        IF ParameterCount < TypeHelper.GetMaxNumberOfParametersInSQLQuery - 100 THEN BEGIN
            item.FILTERGROUP(0);
            item.MARKEDONLY(FALSE);
            item.SETFILTER("No.",FilterText);
        END;
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

    procedure GetAirPlaneTypeValueNameFromItemNo(ItemNo: Code[20]):text[250];
    var
        ItemAttributeValueMapping: Record "Item Attribute Value Mapping";
        ItemAttributeValue :Record "Item Attribute Value";
        AIRSetup: Record "AIR Setup";
    begin
        with ItemAttributeValueMapping do begin 
          SETRANGE("Table ID",DATABASE::Item);
          SETRANGE("No.",ItemNo);
          SetRange("Item Attribute ID",GetItemAttributeIDFromName(AIRSetup.GetAirPlaneAttribute));
          IF FINDFIRST then
            if ItemAttributeValue.GET("Item Attribute ID","Item Attribute Value ID") then
               ItemAttributeValue.CalcFields("Attribute Name");
        end;  
        exit(ItemAttributeValue."Attribute Name");   
    end;

    local procedure GetItemAttributeIDFromName(Name:Text):Integer;
    var
      ItemAttribute :Record "Item Attribute";
    begin
        ItemAttribute.SetRange(Name,Name);
        if ItemAttribute.FindFirst then
         exit(ItemAttribute.ID);
    end;

    procedure FillItemAttributesBufferFilter(ValueFilter:Text; VAR TempFilterItemAttributesBuffer : Record "Filter Item Attributes Buffer" temporary);
    var
        ItemAttributeManagement : Codeunit "Item Attribute Management"; 
        AIRSetup : Record "AIR Setup";       
    begin
       WITH TempFilterItemAttributesBuffer do
       begin
         INIT;
         VALIDATE(Attribute,AIRSetup.GetAirPlaneAttribute);
         VALIDATE(Value,ValueFilter);
         Insert;
       end; 
    end;

    local procedure GetItemNoFromItemsFilteredByAttributes(var TempFilteredItem : Record Item temporary): Code[20];
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