codeunit 50001 "AIR Notifications"
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

    procedure ShowNotificationWhenAIRCategoryDoesNotExist();
    var
        MyNotifications : Record "My Notifications";
        MyNotification: Notification;
        AIRFunctions: Codeunit "AIR Functions";
    begin
        WITH MyNotification DO BEGIN
          Id := 'd2adc7d7-7f36-47d2-8de9-593f30ba8367';
          Message := 'Don''t have air category? Create it using new Cognitive service Image Analizer.';
          Scope := NotificationScope::LocalScope;
          AddAction('Create', CODEUNIT::"AIR Notifications Actions", 'RunCreateNewItemAndImportImage');
          Send;
        END;

    end;


    procedure ShowNotificationWhenAIRAttributeDoesNotExist();
    var
        MyNotifications : Record "My Notifications";
        MyNotification: Notification;
        AIRFunctions: Codeunit "AIR Functions";
    begin
        WITH MyNotification DO BEGIN
          Id := '4eb8ef57-bf95-4d07-ba95-f9253daf8f94';
          Message := 'Don''t have air attribute?';
          Scope := NotificationScope::LocalScope;
          AddAction('Create', CODEUNIT::"AIR Notifications Actions", 'RunCreateAirplaneAttribute');
          Send;
        END;

    end;

}