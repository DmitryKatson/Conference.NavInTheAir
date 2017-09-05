codeunit 71000000 "AIR Functions"
{
    trigger OnRun();
    begin
    end;
    
    var
    
    procedure GetNotificationGUID(): Text;
    begin
        exit('50f37db2-5dc0-414b-ba49-53916c44764f')
    end;
    
    procedure CheckIfAIRAppIsProperlySetuped(ShowNotification: Boolean) : Boolean;
    var
        AIRSetup: Record "AIR Setup";
        AIRNotification: Codeunit "AIR Notifications";
    begin
        with AIRSetup do
        if not Get or ("Airplane Category" = '') OR("Airplane Type Attribute" = '') then
            begin
                if ShowNotification then
                    AIRNotification.ShowNotificationWhenAIRappIsNotSetupedCorrectly();
                exit(false);
            end;
        exit(true);
    end;
    
    procedure ShowAirplanesList(ShowNotification: Boolean);
    var
        AIRSetup: Record "AIR Setup";
        Item: Record Item;
        AirplaneCategory: Code [20];
    begin
        AirplaneCategory := AIRSetup.GetAirPlaneCategory(ShowNotification);
        if AirplaneCategory = '' then
            exit;
        Item.SetRange("Item Category Code",AirplaneCategory);
        Page.Run(Page::"Item List",Item);
    end;
    
    procedure ChooseFromAirplanesList(AirplaneType : Text): Code [20];
    var
        AIRSetup: Record "AIR Setup";
        Item: Record Item;
        AirplaneCategory: Code [20];
    begin
        AirplaneCategory := AIRSetup.GetAirPlaneCategory(false);
        if AirplaneCategory = '' then
            exit;
        Item.SetRange("Item Category Code",AirplaneCategory);
        FilterItemsByAirplaneType(Item,AirplaneType);
        if Page.RunModal(Page::"Item List",Item) = "Action"::LookupOK then
            exit(Item."No.");
    end;
    
    
    local procedure FilterItemsByAirplaneType(var item : Record Item;AirplaneType : Text);
    var
        TempFilteredItem: Record Item temporary;
        TempFilterItemAttributesBuffer: Record "Filter Item Attributes Buffer" temporary;
        ItemAttributeManagement: Codeunit "Item Attribute Management";
        TypeHelper: Codeunit "Type Helper";
        ParameterCount: Integer;
        FilterText: Text;
    begin
        FillItemAttributesBufferFilter(AirplaneType,TempFilterItemAttributesBuffer);
        ItemAttributeManagement.FindItemsByAttributes(TempFilterItemAttributesBuffer,TempFilteredItem);
        FilterText := ItemAttributeManagement.GetItemNoFilterText(TempFilteredItem,ParameterCount);
        if ParameterCount < TypeHelper.GetMaxNumberOfParametersInSQLQuery - 100 then begin
            item.FILTERGROUP(0);
            item.MARKEDONLY(false);
            item.SetFilter("No.",FilterText);
        end;
    end;
    
    procedure GetAirplaneItemNoFromAirplaneType(AirplaneType : Text) : Code[20];
    var
        item: Record Item;
        TempFilteredItem: Record Item temporary;
        TempFilterItemAttributesBuffer: Record "Filter Item Attributes Buffer" temporary;
        ItemAttributeManagement: Codeunit "Item Attribute Management";
    begin
        FillItemAttributesBufferFilter(AirplaneType,TempFilterItemAttributesBuffer);
        ItemAttributeManagement.FindItemsByAttributes(TempFilterItemAttributesBuffer,TempFilteredItem);
        exit(GetItemNoFromItemsFilteredByAttributes(TempFilteredItem));
    end;
    
    procedure GetAirPlaneTypeValueNameFromItemNo(ItemNo: Code[20]):Text[250];
    var
        AIRSetup: Record "AIR Setup";
        ItemAttributeValue: Record "Item Attribute Value";
        ItemAttributeValueMapping: Record "Item Attribute Value Mapping";
    begin
        with ItemAttributeValueMapping do begin
            SetRange("Table ID",DATABASE::Item);
            SetRange("No.",ItemNo);
            SetRange("Item Attribute ID",GetItemAttributeIDFromName(AIRSetup.GetAirPlaneAttribute(false)));
            if FindFirst then
                if ItemAttributeValue.Get("Item Attribute ID","Item Attribute Value ID") then
                    exit(ItemAttributeValue.Value);;
        end;
    end;
    
    local procedure GetItemAttributeIDFromName(Name:Text):Integer;
    var
        ItemAttribute: Record "Item Attribute";
    begin
        ItemAttribute.SetFilter(Name,STRSUBSTNO('@%1',Name));
        if ItemAttribute.FindFirst then
            exit(ItemAttribute.ID);
    end;
    
    procedure FillItemAttributesBufferFilter(ValueFilter:Text; var TempFilterItemAttributesBuffer : Record "Filter Item Attributes Buffer" temporary);
    var
        AIRSetup: Record "AIR Setup";
        ItemAttributeManagement: Codeunit "Item Attribute Management";
    begin
        with TempFilterItemAttributesBuffer do
        begin
            INIT;
            VALIDATE(Attribute,AIRSetup.GetAirPlaneAttribute(false));
            VALIDATE(Value,ValueFilter);
            Insert;
        end;
    end;
    
    local procedure GetItemNoFromItemsFilteredByAttributes(var TempFilteredItem : Record Item temporary): Code[20];
    var
    begin
        if TempFilteredItem.COUNT = 1 then
            begin
                TempFilteredItem.FindFirst;
                exit(TempFilteredItem."No.");
            end;
        exit('');
        
    end;
    
    procedure ResetExtensionEnvironment();
    var
        AIRAirport: Record "AIR Airport";
        AIRFlight: Record "AIR Flight";
        AIRSchedule: Record "AIR Schedule";
        AIRSetup: Record "AIR Setup";
        Item: Record Item;
    begin
        AIRFlight.DeleteAll;
        AIRAirport.DeleteAll;
        AIRSchedule.DeleteAll;
        
        DeleteAirItems;
        DeleteAirCategory;
        DeleteAirAttribute;
        
        AIRSetup.DeleteAll;
    end;
    
    local procedure DeleteAirCategory();
    var
        AIRSetup: Record "AIR Setup";
        ItemCategory: Record "Item Category";
    begin
        if(AIRSetup.GetAirPlaneCategory(false) <> '') and ItemCategory.Get(AIRSetup.GetAirPlaneCategory(false)) then
            ItemCategory.Delete(true);
    end;
    
    local procedure DeleteAirAttribute();
    var
        AIRSetup: Record "AIR Setup";
        ItemAttribute: Record "Item Attribute";
    begin
        if(AIRSetup.GetAirPlaneAttribute(false) <> '') then begin
            ItemAttribute.Setrange(Name,AIRSetup.GetAirPlaneAttribute(false));
            ItemAttribute.DeleteAll(true);
        end;
    end;
    
    local procedure DeleteAirItems();
    var
        AirSetup: Record "AIR Setup";
        item: Record Item ;
    begin
        FilterItemsByAirplaneType(item,'*');
        item.DeleteAll(true);
        
        if AirSetup.GetAirPlaneCategory(false) <> '' then begin
            item.reset;
            item.SetRange("Item Category Code",AirSetup.GetAirPlaneCategory(false));
            item.DeleteAll(true);
        end;
    end;
    
}