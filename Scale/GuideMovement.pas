unit GuideMovement;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, DBTables, StdCtrls, ExtCtrls, Grids, DBGrids, Buttons,
  Datasnap.DBClient, dsdDB, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore,
  dxSkinsDefaultPainters, cxTextEdit, cxCurrencyEdit, Vcl.ComCtrls, dxCore,
  cxDateUtils, cxMaskEdit, cxDropDownEdit, cxCalendar, cxStyles,
  dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage, cxDBData,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridLevel,
  cxClasses, cxGridCustomView, cxGrid, cxImageComboBox, dsdAddOn, Vcl.ActnList
 ,DataModul;

type
  TGuideMovementForm = class(TForm)
    GridPanel: TPanel;
    ParamsPanel: TPanel;
    DataSource: TDataSource;
    ButtonPanel: TPanel;
    ButtonExit: TSpeedButton;
    bbRefresh: TSpeedButton;
    bbChoice: TSpeedButton;
    spSelect: TdsdStoredProc;
    CDS: TClientDataSet;
    gbPartnerCode: TGroupBox;
    EditInvNumber: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    deStart: TcxDateEdit;
    deEnd: TcxDateEdit;
    DS: TDataSource;
    cxDBGrid: TcxGrid;
    cxDBGridDBTableView: TcxGridDBTableView;
    Status: TcxGridDBColumn;
    MovementDescName: TcxGridDBColumn;
    OperDate: TcxGridDBColumn;
    WeighingNumber: TcxGridDBColumn;
    PartionGoods: TcxGridDBColumn;
    InvNumber: TcxGridDBColumn;
    InvNumberOrder: TcxGridDBColumn;
    InvNumberTransport: TcxGridDBColumn;
    StartWeighing: TcxGridDBColumn;
    EndWeighing: TcxGridDBColumn;
    FromName: TcxGridDBColumn;
    ToName: TcxGridDBColumn;
    UserName: TcxGridDBColumn;
    PaidKindName: TcxGridDBColumn;
    TotalCount: TcxGridDBColumn;
    TotalCountTare: TcxGridDBColumn;
    TotalSumm: TcxGridDBColumn;
    ChangePercent: TcxGridDBColumn;
    ContractName: TcxGridDBColumn;
    ContractTagName: TcxGridDBColumn;
    InfoMoneyCode: TcxGridDBColumn;
    InfoMoneyName: TcxGridDBColumn;
    cxDBGridLevel: TcxGridLevel;
    DBViewAddOn: TdsdDBViewAddOn;
    ActionList: TActionList;
    actRefresh: TAction;
    actChoice: TAction;
    actExit: TAction;
    bbChangeMember: TSpeedButton;
    PersonalName1: TcxGridDBColumn;
    PersonalName2: TcxGridDBColumn;
    PersonalName3: TcxGridDBColumn;
    PersonalName4: TcxGridDBColumn;
    PersonalCode1: TcxGridDBColumn;
    PersonalCode2: TcxGridDBColumn;
    PersonalCode3: TcxGridDBColumn;
    PersonalCode4: TcxGridDBColumn;
    PositionName1: TcxGridDBColumn;
    PositionName2: TcxGridDBColumn;
    PositionName3: TcxGridDBColumn;
    PositionName4: TcxGridDBColumn;
    bbPrint: TSpeedButton;
    cbPrintMovement: TCheckBox;
    cbPrintTransport: TCheckBox;
    cbPrintQuality: TCheckBox;
    cbPrintAccount: TCheckBox;
    cbPrintPack: TCheckBox;
    cbPrintSpec: TCheckBox;
    cbPrintTax: TCheckBox;
    CheckBox8: TCheckBox;
    InvNumber_parent: TcxGridDBColumn;
    OperDate_parent: TcxGridDBColumn;
    InvNumber_TransportGoods: TcxGridDBColumn;
    OperDate_TransportGoods: TcxGridDBColumn;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CDSFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure EditInvNumberChange(Sender: TObject);
    procedure actRefreshExecute(Sender: TObject);
    procedure actChoiceExecute(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure deStartPropertiesChange(Sender: TObject);
    procedure deEndPropertiesChange(Sender: TObject);
    procedure bbChangeMemberClick(Sender: TObject);
    procedure bbPrintClick(Sender: TObject);
  private
    fStartWrite:Boolean;

    ParamsMovement_local: TParams;
    isChoice_local:Boolean;

    procedure CancelCxFilter;
    function Checked: boolean;
    procedure RefreshDataSet;
  public
    function Execute(var execParamsMovement:TParams;isChoice:Boolean): boolean;
  end;

var
  GuideMovementForm: TGuideMovementForm;

implementation

{$R *.dfm}

 uses dmMainScale,UtilScale,UtilPrint,Main;
{------------------------------------------------------------------------------}
function TGuideMovementForm.Execute(var execParamsMovement:TParams;isChoice:Boolean): boolean;
begin
     CopyValuesParamsFrom(execParamsMovement,ParamsMovement_local);

     // если вызов для выбора
     {if isChoice = TRUE
     then // если нужен следующий и он один, тогда открывать форму не надо
          if TRUE = DMMainScaleForm.gpGet_Scale_Movement(ParamsMovement_local,FALSE,TRUE)//isLast=FALSE,isNext=TRUE
          then begin CopyValuesParamsFrom(ParamsMovement_local,execParamsMovement);exit;end;}

     isChoice_local:=(isChoice);
     bbChoice.Enabled:=(isChoice_local) or (UserId_begin=5);

     EditInvNumber.Text:='';

     fStartWrite:=true;
     deStart.Text:=DateToStr(ParamsMovement_local.ParamByName('OperDate').AsDateTime);
     deEnd.Text:=DateToStr(ParamsMovement_local.ParamByName('OperDate').AsDateTime);
     fStartWrite:=false;

     CancelCxFilter;
     RefreshDataSet;
     CDS.Filtered:=false;


     if ParamsMovement_local.ParamByName('MovementId').AsInteger<>0
     then CDS.Locate('Id',ParamsMovement_local.ParamByName('MovementId').AsString,[]);

     ActiveControl:=EditInvNumber;

     Application.ProcessMessages;
     Application.ProcessMessages;
     Application.ProcessMessages;

     result:=ShowModal=mrOk;
     if result then
     begin
          CopyValuesParamsFrom(ParamsMovement_local,execParamsMovement);
          gpInitialize_MovementDesc;
     end;
end;
{------------------------------------------------------------------------------}
procedure TGuideMovementForm.RefreshDataSet;
var StartDate,EndDate:TDateTime;
begin
     try StartDate:=StrToDate(deStart.Text); except if CDS.Active then StartDate:=spSelect.ParamByName('inStartDate').Value else StartDate:=ParamsMovement_local.ParamByName('OperDate').AsDateTime;deStart.Text:=DateToStr(StartDate);end;
     try EndDate:=StrToDate(deEnd.Text); except if CDS.Active then EndDate:=spSelect.ParamByName('inEndDate').Value else EndDate:=ParamsMovement_local.ParamByName('OperDate').AsDateTime;deEnd.Text:=DateToStr(EndDate);end;

     with spSelect do
     begin
          ParamByName('inStartDate').Value:=StartDate;
          ParamByName('inEndDate').Value:=EndDate;
          ParamByName('inIsComlete').Value:=not isChoice_local;
          Execute;
     end;
end;
{------------------------------------------------------------------------------}
procedure TGuideMovementForm.CancelCxFilter;
begin
     if cxDBGridDBTableView.DataController.Filter.Active
     then begin cxDBGridDBTableView.DataController.Filter.Clear;cxDBGridDBTableView.DataController.Filter.Active:=false;end
end;
{------------------------------------------------------------------------------}
procedure TGuideMovementForm.FormKeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
begin
    if Key=13
    then
        if ((ActiveControl=cxDBGrid)and(CDS.RecordCount>0))or(CDS.RecordCount=1)
        then actChoiceExecute(Self);
    //
    if (Key=27) then
      if cxDBGridDBTableView.DataController.Filter.Active
      then CancelCxFilter
      else actExitExecute(Self);
end;
{------------------------------------------------------------------------------}
procedure TGuideMovementForm.CDSFilterRecord(DataSet: TDataSet;var Accept: Boolean);
begin
     if (trim(EditInvNumber.Text)<>'')
     then
       if (pos(AnsiUpperCase(EditInvNumber.Text),AnsiUpperCase(DataSet.FieldByName('InvNumber').AsString))>0)
       then Accept:=true else Accept:=false;
end;
{------------------------------------------------------------------------------}
function TGuideMovementForm.Checked: boolean; //Проверка корректного ввода в Edit
begin
     Result:=(CDS.RecordCount>0)and(bbChoice.Enabled=TRUE)and(CDS.FieldByName('Id').AsInteger>0);
     if Result then
     begin
         ParamsMovement_local.ParamByName('MovementId').AsInteger:=CDS.FieldByName('Id').AsInteger;
         DMMainScaleForm.gpGet_Scale_Movement(ParamsMovement_local,FALSE,FALSE);//isLast=FALSE,isNext=FALSE
     end;
end;

{------------------------------------------------------------------------------}
procedure TGuideMovementForm.EditInvNumberChange(Sender: TObject);
begin
       with CDS do begin
           //***Filtered:=false;
           //***if trim(EditPartnerName.Text)<>'' then begin Filtered:=false;Filtered:=true;end;
           Filtered:=false;
           if trim(EditInvNumber.Text)<>'' then Filtered:=true;
       end;
end;
{------------------------------------------------------------------------------}
procedure TGuideMovementForm.deStartPropertiesChange(Sender: TObject);
var  Year, Month, Day, Hour, Min, Sec, MSec: Word;
begin
     if fStartWrite then exit;
     //
     try StrToDate(deStart.Text); except exit;end;
     DecodeDate(StrToDate(deStart.Text), Year, Month, Day);
     if (Year>2000)and(LengTh(deStart.Text)>=10) then RefreshDataSet;
end;
{------------------------------------------------------------------------------}
procedure TGuideMovementForm.deEndPropertiesChange(Sender: TObject);
var  Year, Month, Day, Hour, Min, Sec, MSec: Word;
begin
     if fStartWrite then exit;
     //
     try StrToDate(deEnd.Text); except exit;end;
     DecodeDate(StrToDate(deEnd.Text), Year, Month, Day);
     if (Year>2000)and(LengTh(deStart.Text)>=10) then RefreshDataSet;
end;
{------------------------------------------------------------------------------}
procedure TGuideMovementForm.actRefreshExecute(Sender: TObject);
var MovementId:String;
begin
     MovementId:= CDS.FieldByName('Id').AsString;
     RefreshDataSet;
     if MovementId <> '' then
        CDS.Locate('Id',MovementId,[loCaseInsensitive]);
end;
{------------------------------------------------------------------------------}
procedure TGuideMovementForm.bbChangeMemberClick(Sender: TObject);
var execParams:TParams;
begin
    Create_ParamsPersonalComplete(execParams);
    //
    if CDS.RecordCount=0 then
    begin
         ShowMessage('Ошибка.Документ не выбран.');
         exit;
    end;
    //
    execParams.ParamByName('PersonalId1').AsInteger:=CDS.FieldByName('PersonalId1').AsInteger;
    execParams.ParamByName('PersonalCode1').AsInteger:=CDS.FieldByName('PersonalCode1').AsInteger;
    execParams.ParamByName('PersonalName1').AsString:=CDS.FieldByName('PersonalName1').AsString;
    execParams.ParamByName('PositionId1').AsInteger:=CDS.FieldByName('PositionId1').AsInteger;
    execParams.ParamByName('PositionCode1').AsInteger:=CDS.FieldByName('PositionCode1').AsInteger;
    execParams.ParamByName('PositionName1').AsString:=CDS.FieldByName('PositionName1').AsString;
    //
    execParams.ParamByName('PersonalId2').AsInteger:=CDS.FieldByName('PersonalId2').AsInteger;
    execParams.ParamByName('PersonalCode2').AsInteger:=CDS.FieldByName('PersonalCode2').AsInteger;
    execParams.ParamByName('PersonalName2').AsString:=CDS.FieldByName('PersonalName2').AsString;
    execParams.ParamByName('PositionId2').AsInteger:=CDS.FieldByName('PositionId2').AsInteger;
    execParams.ParamByName('PositionCode2').AsInteger:=CDS.FieldByName('PositionCode2').AsInteger;
    execParams.ParamByName('PositionName2').AsString:=CDS.FieldByName('PositionName2').AsString;
    //
    execParams.ParamByName('PersonalId3').AsInteger:=CDS.FieldByName('PersonalId3').AsInteger;
    execParams.ParamByName('PersonalCode3').AsInteger:=CDS.FieldByName('PersonalCode3').AsInteger;
    execParams.ParamByName('PersonalName3').AsString:=CDS.FieldByName('PersonalName3').AsString;
    execParams.ParamByName('PositionId3').AsInteger:=CDS.FieldByName('PositionId3').AsInteger;
    execParams.ParamByName('PositionCode3').AsInteger:=CDS.FieldByName('PositionCode3').AsInteger;
    execParams.ParamByName('PositionName3').AsString:=CDS.FieldByName('PositionName3').AsString;
    //
    execParams.ParamByName('PersonalId4').AsInteger:=CDS.FieldByName('PersonalId4').AsInteger;
    execParams.ParamByName('PersonalCode4').AsInteger:=CDS.FieldByName('PersonalCode4').AsInteger;
    execParams.ParamByName('PersonalName4').AsString:=CDS.FieldByName('PersonalName4').AsString;
    execParams.ParamByName('PositionId4').AsInteger:=CDS.FieldByName('PositionId4').AsInteger;
    execParams.ParamByName('PositionCode4').AsInteger:=CDS.FieldByName('PositionCode4').AsInteger;
    execParams.ParamByName('PositionName4').AsString:=CDS.FieldByName('PositionName4').AsString;
    //
    execParams.ParamByName('MovementId').AsInteger:=CDS.FieldByName('Id').AsInteger;
    execParams.ParamByName('InvNumber').AsString:=CDS.FieldByName('InvNumber').AsString;
    execParams.ParamByName('OperDate').AsDateTime:=CDS.FieldByName('OperDate').AsDateTime;
    execParams.ParamByName('MovementDescId').AsInteger:=CDS.FieldByName('MovementDescId').AsInteger;
    execParams.ParamByName('FromName').AsString:=CDS.FieldByName('FromName').AsString;
    execParams.ParamByName('ToName').AsString:=CDS.FieldByName('ToName').AsString;
    //
    if MainForm.Save_Movement_PersonalComplete(execParams)
    then actRefreshExecute(Self);
    //
    execParams.Free;
end;
{------------------------------------------------------------------------------}
procedure TGuideMovementForm.actChoiceExecute(Sender: TObject);
begin
     if Checked then ModalResult:=mrOK;
end;
{------------------------------------------------------------------------------}
procedure TGuideMovementForm.actExitExecute(Sender: TObject);
begin
     Close;
end;
{------------------------------------------------------------------------------}
procedure TGuideMovementForm.FormCreate(Sender: TObject);
begin
  bbChangeMember.Visible:=GetArrayList_Value_byName(Default_Array,'isPersonalComplete') = AnsiUpperCase('TRUE');

  Create_ParamsMovement(ParamsMovement_local);

  with spSelect do
  begin
       StoredProcName:='gpSelect_Scale_Movement';
       Params.AddParam('inStartDate', ftDateTime, ptInput, 0);
       Params.AddParam('inEndDate', ftDateTime, ptInput,0);
       Params.AddParam('inIsComlete', ftBoolean, ptInput,FALSE);
       OutputType:=otDataSet;
  end;

end;
{------------------------------------------------------------------------------}
procedure TGuideMovementForm.FormDestroy(Sender: TObject);
begin
  ParamsMovement_local.Free;
end;
{------------------------------------------------------------------------------}
procedure TGuideMovementForm.bbPrintClick(Sender: TObject);
begin
     //
     if    not(cbPrintMovement.Checked)
       and not(cbPrintTax.Checked)
       and not(cbPrintAccount.Checked)
       and not(cbPrintPack.Checked)
       and not(cbPrintSpec.Checked)
       and not(cbPrintTransport.Checked)
       and not(cbPrintQuality.Checked)
     then begin
               ShowMessage('Ошибка.Не выбран вариант печати.');
               exit;
     end;

     //
     if cbPrintMovement.Checked
     then Print_Movemenet (CDS.FieldByName('MovementDescId').AsInteger
                         , CDS.FieldByName('MovementId_parent').AsInteger
                         , 1    // myPrintCount
                         , TRUE // isPreview
                          );
     //
     if cbPrintTax.Checked
     then Print_Tax (CDS.FieldByName('MovementDescId').AsInteger
                   , CDS.FieldByName('MovementId_parent').AsInteger
                   , 1    // myPrintCount
                   , TRUE // isPreview
                    );
     //
     if cbPrintAccount.Checked
     then Print_Account (CDS.FieldByName('MovementDescId').AsInteger
                       , CDS.FieldByName('MovementId_parent').AsInteger
                       , 1    // myPrintCount
                       , TRUE // isPreview
                        );
     //
     if cbPrintPack.Checked
     then Print_Pack (CDS.FieldByName('MovementDescId').AsInteger
                    , CDS.FieldByName('MovementId_parent').AsInteger// MovementId
                    , CDS.FieldByName('Id').AsInteger               // MovementId_by
                    , 1    // myPrintCount
                    , TRUE // isPreview
                     );
     //
     if cbPrintSpec.Checked
     then Print_Spec (CDS.FieldByName('MovementDescId').AsInteger
                    , CDS.FieldByName('MovementId_parent').AsInteger// MovementId
                    , CDS.FieldByName('Id').AsInteger               // MovementId_by
                    , 1    // myPrintCount
                    , TRUE // isPreview
                     );
     //
     if cbPrintTransport.Checked
     then Print_Transport (CDS.FieldByName('MovementDescId').AsInteger
                         , CDS.FieldByName('MovementId_TransportGoods').AsInteger // MovementId
                         , CDS.FieldByName('MovementId_parent').AsInteger         // MovementId_sale
                         , CDS.FieldByName('OperDate_parent').AsDateTime
                         , 1    // myPrintCount
                         , TRUE // isPreview
                          );
     //
     if cbPrintQuality.Checked
     then Print_Quality (CDS.FieldByName('MovementDescId').AsInteger
                       , CDS.FieldByName('MovementId_parent').AsInteger
                       , 1    // myPrintCount
                       , TRUE // isPreview
                        );
end;
{------------------------------------------------------------------------------}
end.
