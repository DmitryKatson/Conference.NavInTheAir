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
            action(CreateWizard)
            {
                Image = CreateWhseLoc;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                PromotedCategory = New;
                RunObject = page "AIR Flight Register Wizard";  
                ApplicationArea = All;   
                CaptionML = ENU = 'New flight'; 
                ToolTipML = ENU = 'Register new flight with wizard';          
            }
        }
        area(processing)
        {            
            action(Setup)
            {
                Image = Setup;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                PromotedCategory = Report;
                RunObject = page "AIR Setup";  
                ApplicationArea = All;              
            }
            action(Airplanes)
            {
                Image = Delivery;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                PromotedCategory = Report;
                ApplicationArea = All; 

                trigger OnAction();
                var
                    AIRFunctions : Codeunit "AIR Functions";
                begin
                    AIRFunctions.ShowAirplanesList(true);
                end;
            }
        }
    
    }
    trigger OnOpenPage();
    var
        AIRFunctions: Codeunit "AIR Functions";

    begin
      IF NOT AIRFunctions.CheckIfAIRAppIsProperlySetuped(true) Then 
         EXIT;

    end;
}