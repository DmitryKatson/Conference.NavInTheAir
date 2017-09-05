page 71000001 "AIR Flight List"
{
    PageType = List;
    SourceTable = "AIR Flight";
    CardPageId = "AIR Flight Card";
    CaptionML = ENU = 'Flights';
    PromotedActionCategoriesML = ENU = 'New,Process,Navigate';
    
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Flight Number";"Flight Number")
                {
                    ApplicationArea = All;
                }
                field("Aircraft Item No.";"Aircraft Item No.")
                {
                    ApplicationArea = All;
                }
                field(Destination;Destination)
                {
                    ApplicationArea = All;
                }
                field("Passangers number";"Passangers number")
                {
                    ApplicationArea = All;
                }
                field(Status;Status)
                {
                    ApplicationArea = All;
                }
                field("Actual Departure Date";"Departure Date")
                {
                    ApplicationArea = All;
                }
                field("Actual Departure Time";"Departure Time")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
        }
    }
    
    actions
    {
        area(Creation)
        {
            Action(CreateWizard)
            {
                Image = CreateWhseLoc;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                PromotedCategory = New;
                RunObject = Page "AIR Flight Register Wizard";
                ApplicationArea = All;
                CaptionML = ENU = 'New flight';
                ToolTipML = ENU = 'Register new flight with wizard';
            }
        }
        area(processing)
        {
            Action(Setup)
            {
                Image = Setup;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                PromotedCategory = Report;
                RunObject = Page "AIR Setup";
                ApplicationArea = All;
            }
            Action(Airplanes)
            {
                Image = Delivery;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                PromotedCategory = Report;
                ApplicationArea = All;
                
                trigger OnAction();
                var
                    AIRFunctions: Codeunit "AIR Functions";
                begin
                    AIRFunctions.ShowAirplanesList(true);
                end;
            }
            Action(ResetAll)
            {
                Image = Overdue;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                CaptionML = ENU = 'Clear all';
                ToolTipML = ENU = 'This will delete all setups and data related to NavInTheAir app, including related item cards.';
                Visible = IsAppProperlySetuped;

                trigger OnAction();
                var
                    AIRFunctions: Codeunit "AIR Functions";                    
                begin
                    if Confirm('Do you really want to delete all data from NavInTheAir app?',True) then
                    begin
                        AIRFunctions.ResetExtensionEnvironment;
                        Message('All data deleted');
                        CurrPage.Update;
                    end;
                end;
            }
        }
        
    }
    var
    IsAppProperlySetuped : Boolean;

    trigger OnOpenPage();
    var
        AIRFunctions: Codeunit "AIR Functions";    
    begin
        IsAppProperlySetuped := AIRFunctions.CheckIfAIRAppIsProperlySetuped(true);
    end;
}