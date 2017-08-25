codeunit 71000001 "AIR Notifications"
{
    trigger OnRun();
    begin
    end;
    
    var


    [EventSubscriber(ObjectType::Page, 1518, 'OnInitializingNotificationWithDefaultState', '', false, false)]
    LOCAL PROCEDURE OnInitializingNotificationWithDefaultState();
    var
        MyNotifications : Record 1518;
        NameTxt : TextConst ENU='Nav In the Air App not setuped';
        DescriptionTxt : TextConst ENU='Show notification when App is not setuped';
        AIRFunctions: Codeunit "AIR Functions";
    begin
        MyNotifications.InsertDefault(AIRFunctions.GetNotificationGUID,
        NameTxt,
        DescriptionTxt,
        TRUE);
    end;
    
    procedure ShowNotificationWhenAIRappIsNotSetupedCorrectly();
    var
        MyNotifications : Record "My Notifications";
        MyNotification: Notification;
        AIRFunctions: Codeunit "AIR Functions";
    begin
        If NOT MyNotifications.IsEnabled(AIRFunctions.GetNotificationGUID) THEN
           EXIT;

        WITH MyNotification DO BEGIN
          Id := AIRFunctions.GetNotificationGUID;
          Message := 'Nav In The Air App is not setuped. Do you want to setup it now?';
          Scope := NotificationScope::LocalScope;
          AddAction('Yes', CODEUNIT::"AIR Notifications Actions", 'RunAIRSetup');
          AddAction('Do not show again', Codeunit::"AIR Notifications Actions", 'HideNotification');
          Send;
        END;

    end;
}