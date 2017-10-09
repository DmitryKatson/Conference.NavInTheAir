codeunit 50002 "AIR Notifications Actions"
{
    trigger OnRun();
    begin
    end;
    
    var
    
    procedure RunAIRSetup(var MyNotification : Notification);
    begin
        Page.Run(Page::"AIR Setup");
    end;
    
    procedure RunCreateNewItemAndImportImage(var MyNotification : Notification);
    var
        Item: Record Item;
    begin
        Item.INIT;
        Item.Description := 'new arplane';
        Item."Base Unit of Measure" := 'PCS';
        if not Item.Insert(true) then
            exit;
        Page.Run(Page::"Item card",Item);
        
    end;
    
    procedure RunCreateAirplaneAttribute(var MyNotification : Notification);
    var
        AIRSetup: Record "AIR Setup";
    begin
        CreateAirplaneItemAttribute();
        AIRSetup.Get;
        AIRSetup."Airplane Type Attribute" := GetDefaultAirplaneItemAttributeName;
        AIRSetup.Modify;
    end;
    local procedure CheckIfItemAttributeExist(NameToCheck : Text[250]): Boolean;
    var
        ItemAttribute: Record "Item Attribute";
    begin
        ItemAttribute.SetRange(Name,NameToCheck);
        exit(NOT ItemAttribute.ISEMPTY);
    end;
    
    local procedure CreateAirplaneItemAttribute();
    var
        ItemAttribute: Record "Item Attribute";
    begin
        if CheckIfItemAttributeExist(GetDefaultAirplaneItemAttributeName) then
            exit;
        ItemAttribute.Init;
        ItemAttribute.VALIDATE(Name,GetDefaultAirplaneItemAttributeName);
        ItemAttribute.Insert(true);
    end;

    local procedure GetDefaultAirplaneItemAttributeName():Text[50];
    var
        
    begin
        Exit('Model');
    end;
    
    procedure HideNotification(var MyNotification : Notification);
    var
        MyNotifications: Record "My Notifications";
        NotificationID: Guid;
    begin
        with MyNotifications do begin
            LOCKTABLE;
            NotificationID := MyNotification.ID;
            if Get(UserId,NotificationID) then begin
                Enabled := false;
                Modify;
            end;
        end;
    end;
}