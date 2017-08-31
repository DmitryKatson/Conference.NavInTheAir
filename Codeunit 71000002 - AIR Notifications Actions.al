codeunit 71000002 "AIR Notifications Actions"
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
        if not Item.INSERT(true) then 
          exit;
        Page.Run(Page::"Item card",Item);

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