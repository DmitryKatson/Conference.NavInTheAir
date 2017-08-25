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

    end;
}