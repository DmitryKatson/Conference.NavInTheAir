codeunit 71000002 "AIR Notifications Actions"
{
    trigger OnRun();
    begin
    end;
    
    var

    procedure RunAIRSetup(VAR MyNotification : Notification);
    begin
        PAGE.Run(PAGE::"AIR Setup");
    end;

    procedure HideNotification(VAR MyNotification : Notification);
    var
      MyNotifications : Record "My Notifications";
      NotificationID : Guid;
    begin
      WITH MyNotifications DO BEGIN  
         LOCKTABLE;
         NotificationID := MyNotification.ID;
         IF GET(USERID, NotificationID) THEN BEGIN
            Enabled := FALSE;
            MODIFY;
         END;
       END;  
    end;
}