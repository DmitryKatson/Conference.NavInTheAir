
page 71000003 "AIR Flight Register Wizard"
{
  CaptionML=ENU='Register new flight';
  PageType=NavigatePage;
  SourceTable="AIR Flight";
  SourceTableTemporary = true;
  
  layout
  {
    area(content)
    {
      group(TopBannerOnFirstStep)
      {
        Visible=TopBannerVisible AND NOT FinalStepVisible; 
        CaptionML = ENU = '';
        field(MediaResourcesStandard;MediaResourcesStandard."Media Reference")
        {
          ApplicationArea=All;
          Editable=false;
          ShowCaption=false;
        }
      }
      group(TopBannerOnFinishStep)
      {
        Visible=TopBannerVisible AND FinalStepVisible;
        CaptionML = ENU = '';
        
        field(MediaResourcesDone;MediaResourcesDone."Media Reference")
        {
          ApplicationArea=All;
          Editable=false;
          ShowCaption=false;
        }
      }
      group(Step1)
      {
        Visible=FirstStepVisible;
        group(Step1Welcome)
        {
          Visible=FirstStepVisible;
          CaptionML = ENU = 'Welcome to register New flight';
          InstructionalTextML = ENU = 'This wizard will help you to register new flight. After filling all fields, click Finish.';                  
        }
        group(Step1LetsGo)
        {  
           Visible=FirstStepVisible;
           CaptionML = ENU = 'Lets Go!';
           InstructionalTextML = ENU = 'Choose Next! Good Luck!';
        }
      }
      group(Step2)
      {
        Visible=SecondStepVisible;

        group(Step2Welcome)
        {
         CaptionML=ENU='Welcome to register New Flight';
         Visible=SecondStepVisible;
         group(Step2FillFields)
         {
          CaptionML = ENU = '';
          InstructionalTextML=ENU='Fill in the following fields';
          Visible=SecondStepVisible;

          field(Departure;Departure)
          {
             ApplicationArea=All;
             ShowMandatory = true;
            
            trigger OnValidate();
             var
               FlightAwareFunctions : codeunit "Air Flightaware functions";
             begin
               If Departure <> '' Then
                  FlightAwareFunctions.GetDepartures(Departure);
               SetFieldsEditable();
             end;
          }

          field(FlightNo;FlightNo)
          {
             ApplicationArea=All;
             CaptionML=ENU='Flight number';
             ShowMandatory = true;
             TableRelation = "AIR Schedule";
             Editable = FlightNoEditable;

             trigger OnValidate();
             var
             begin
               SetFieldsEditable();
               FillFieldsFromFlightNo(FlightNo,Rec);
               CurrPage.Update;
             end;
          }
          field("Aircraft Item No.";"Aircraft Item No.")
          {
            ApplicationArea=All;
            Editable = AircraftItemNoEditable;

          }
            
          field(Destination;Destination)
          {
            ApplicationArea=All;
            CaptionML=ENU='Destination';
            ShowMandatory = true;
            Editable = DestinationEditable;

          }
          field("Passangers number";"Passangers number")
          {
            ApplicationArea=All;
            CaptionML=ENU='Passangers number';
            ShowMandatory = true;
            Editable = PassangersEditable;
            BlankZero = true;
          }
         }

        }
        
      }
      group(StepFinal)
      {
        Visible=FinalStepVisible;
        group("That's it!")
        {
          CaptionML=ENU='That''s it!';
          InstructionalTextML=ENU='To view your new Flight, choose Finish.';
        }
      }
    }
  }

  actions
  {
    area(processing)
    {
      action(ActionBack)
      {
        ApplicationArea=Basic,Suite;
        CaptionML=ENU='Back';
        Enabled=BackActionEnabled;
        Image=PreviousRecord;
        InFooterBar=true;

        trigger OnAction();
        begin
          NextStep(TRUE);
        end;
      }
      action(ActionNext)
      {
        ApplicationArea=Basic,Suite;
        CaptionML=ENU='Next';
        Enabled=NextActionEnabled;
        Image=NextRecord;
        InFooterBar=true;

        trigger OnAction();
        begin
          NextStep(FALSE);
        end;
      }
      action(ActionFinish)
      {
        ApplicationArea=Basic,Suite;
        CaptionML=ENU='Finish';
        Enabled=FinishActionEnabled;
        Image=Approve;
        InFooterBar=true;

        trigger OnAction();
        begin
          FinishAction;
        end;
      }
    }
  }

  trigger OnInit();
  begin
    LoadTopBanners;
  end;

  trigger OnOpenPage();
  var 
  begin
    INSERT;

    Step := Step::Start;
    EnableControls;
  end;

  var
    MediaRepositoryStandard : Record 9400;
    MediaRepositoryDone : Record 9400;
    MediaResourcesStandard : Record 2000000182;
    MediaResourcesDone : Record 2000000182;
    Step : Option Start,Creation,Finish;
    TopBannerVisible : Boolean;
    FirstStepVisible : Boolean;
    SecondStepVisible : Boolean;
    FinalStepVisible : Boolean;
    FinishActionEnabled : Boolean;
    BackActionEnabled : Boolean;
    NextActionEnabled : Boolean;
    FlightNo : Code[20];
    SelectFlightNumberMsg: TextConst ENU = 'Fill Flight Number to Finish';
    FlightNoEditable : Boolean;
    AircraftItemNoEditable : Boolean;
    DestinationEditable : Boolean;
    PassangersEditable : Boolean;

  local procedure EnableControls();
  begin
//    IF Step = Step::Creation THEN
//      IF (NOT FromExistingProjectNo) AND (NOT FromExistingProjectYes) THEN BEGIN
//        MESSAGE(SelectYesNoMsg);
//       Step := Step - 1;
//        EXIT;
//      END;

    IF Step = Step::Finish THEN BEGIN
      If FlightNo = '' THEN BEGIN
        MESSAGE(SelectFlightNumberMsg);
        Step := Step - 1;
        EXIT;
      END;

//      IF "Customer No." = '' THEN BEGIN
//        MESSAGE(SelectCustomerNumberMsg);
//        Step := Step - 1;
//        EXIT;
//      END;
    END;

    ResetControls;

    CASE Step OF
      Step::Start:
        ShowStartStep;
      Step::Creation:
        ShowSecondStep;
      Step::Finish:
        ShowFinalStep;
    END;
  end;

  local procedure NextStep(Backwards : Boolean);
  begin
    IF Backwards THEN
      Step := Step - 1
    ELSE
      Step := Step + 1;

    EnableControls;
  end;

  local procedure FinishAction();
  var
    AIRFlight : Record "AIR Flight";
  begin
    SaveInDatabase(AIRFlight);

    PAGE.RUN(PAGE::"Air Flight Card",AIRFlight);
    CurrPage.CLOSE;
  end;

  local procedure SaveInDatabase(var AIRFlight : Record "AIR Flight")
  var  
  begin

    if FlightNo = '' then
       EXIT;
       
    AIRFlight.TransferFields(Rec);
    AIRFlight."Flight Number" := FlightNo;
    AIRFlight.INSERT(TRUE);
  end;

  local procedure ShowStartStep();
  begin
    FirstStepVisible := TRUE;
    FinishActionEnabled := FALSE;
    BackActionEnabled := FALSE;
  end;

  local procedure ShowSecondStep();
  begin
    SecondStepVisible := TRUE;
    FinishActionEnabled := FALSE;
  end;

  local procedure ShowFinalStep();
  var
  begin
    FinalStepVisible := TRUE;
    BackActionEnabled := FALSE;
    NextActionEnabled := FALSE;
  end;

  local procedure ResetControls();
  begin
    FinishActionEnabled := TRUE;
    BackActionEnabled := TRUE;
    NextActionEnabled := TRUE;

    FirstStepVisible := FALSE;
    SecondStepVisible := FALSE;
    FinalStepVisible := FALSE;
  end;

  local procedure LoadTopBanners();
  begin
    IF MediaRepositoryStandard.GET('AssistedSetup-NoText-400px.png',FORMAT(CURRENTCLIENTTYPE)) AND
       MediaRepositoryDone.GET('AssistedSetupDone-NoText-400px.png',FORMAT(CURRENTCLIENTTYPE))
    THEN
      IF MediaResourcesStandard.GET(MediaRepositoryStandard."Media Resources Ref") AND
         MediaResourcesDone.GET(MediaRepositoryDone."Media Resources Ref")
      THEN
        TopBannerVisible := MediaResourcesDone."Media Reference".HASVALUE;
  end;

  local procedure SetFieldsEditable();
  var
  begin
    FlightNoEditable := Departure <> '';
    AircraftItemNoEditable := FlightNo <> '';
    DestinationEditable := FlightNo <> '';
    PassangersEditable := FlightNo <> '';
  end;
}


