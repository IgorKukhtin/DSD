unit GuideMovementCeh;

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
 ,DataModul, dsdAction, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, dsdCommon;

type
  TGuideMovementCehForm = class(TForm)
    GridPanel: TPanel;
    ParamsPanel: TPanel;
    DS: TDataSource;
    ButtonPanel: TPanel;
    ButtonExit: TSpeedButton;
    bbRefresh: TSpeedButton;
    bbChoice: TSpeedButton;
    spSelect: TdsdStoredProc;
    CDS: TClientDataSet;
    gbInvNumber_parent: TGroupBox;
    EditInvNumber_parent: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    deStart: TcxDateEdit;
    deEnd: TcxDateEdit;
    cxDBGrid: TcxGrid;
    cxDBGridDBTableView: TcxGridDBTableView;
    StatusCode: TcxGridDBColumn;
    MovementDescName: TcxGridDBColumn;
    OperDate: TcxGridDBColumn;
    WeighingNumber: TcxGridDBColumn;
    PartionGoods: TcxGridDBColumn;
    InvNumber: TcxGridDBColumn;
    StartWeighing: TcxGridDBColumn;
    EndWeighing: TcxGridDBColumn;
    FromName: TcxGridDBColumn;
    ToName: TcxGridDBColumn;
    UserName: TcxGridDBColumn;
    TotalCount: TcxGridDBColumn;
    cxDBGridLevel: TcxGridLevel;
    DBViewAddOn: TdsdDBViewAddOn;
    ActionList: TActionList;
    actRefresh: TAction;
    actChoice: TAction;
    actExit: TAction;
    bbPrint: TSpeedButton;
    cbPrintMovement: TCheckBox;
    cbPrintTransport: TCheckBox;
    cbPrintPreview: TCheckBox;
    InvNumber_parent: TcxGridDBColumn;
    OperDate_parent: TcxGridDBColumn;
    bbViewMI: TSpeedButton;
    FormParams: TdsdFormParams;
    actViewMI: TdsdInsertUpdateAction;
    MovementDescNumber: TcxGridDBColumn;
    isProductionIn: TcxGridDBColumn;
    TotalCountTare: TcxGridDBColumn;
    DocumentKindName: TcxGridDBColumn;
    SubjectDocName: TcxGridDBColumn;
    Comment: TcxGridDBColumn;
    StatusCode_parent: TcxGridDBColumn;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    actComplete: TAction;
    actUnComplete: TAction;
    bbChangeOperDatePartner: TSpeedButton;
    actUpdateStatus: TAction;
    bbUpdateStatus: TSpeedButton;
    cbPrintPackGross: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CDSFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure EditInvNumber_parentChange(Sender: TObject);
    procedure actRefreshExecute(Sender: TObject);
    procedure actChoiceExecute(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure deStartPropertiesChange(Sender: TObject);
    procedure deEndPropertiesChange(Sender: TObject);
    procedure bbPrintClick(Sender: TObject);
    procedure bbViewMIClick(Sender: TObject);
    procedure cbPrintMovementClick(Sender: TObject);
    procedure actCompleteExecute(Sender: TObject);
    procedure actUnCompleteExecute(Sender: TObject);
    procedure bbChangeOperDatePartnerClick(Sender: TObject);
    procedure actUpdateStatusExecute(Sender: TObject);
  private
    fStartWrite:Boolean;

    ParamsMovement_local: TParams;
    isChoice_local:Boolean;

    procedure myCheckPrintMovement;

    procedure CancelCxFilter;
    function Checked: boolean;
    procedure RefreshDataSet;
  public
    function Execute(var execParamsMovement:TParams;isChoice:Boolean): boolean;
  end;

var
  GuideMovementCehForm: TGuideMovementCehForm;

implementation
{$R *.dfm}
uses dmMainScaleCeh,dmMainScale,UtilScale,UtilPrint,MainCeh,DialogMovementDesc,DialogDateValue;
{------------------------------------------------------------------------------}
function TGuideMovementCehForm.Execute(var execParamsMovement:TParams;isChoice:Boolean): boolean;
begin
     CopyValuesParamsFrom(execParamsMovement,ParamsMovement_local);

     // если вызов для выбора
     {if isChoice = TRUE
     then // если нужен следующий и он один, тогда открывать форму не надо
          if TRUE = DMMainScaleForm.gpGet_Scale_Movement(ParamsMovement_local,FALSE,TRUE)//isLast=FALSE,isNext=TRUE
          then begin CopyValuesParamsFrom(ParamsMovement_local,execParamsMovement);exit;end;}

     isChoice_local:=(isChoice);
     bbChoice.Enabled:=(isChoice_local) or (UserId_begin=5);

     EditInvNumber_parent.Text:='';

     fStartWrite:=true;
     deStart.Text:=DateToStr(ParamsMovement_local.ParamByName('OperDate').AsDateTime);
     deEnd.Text:=DateToStr(ParamsMovement_local.ParamByName('OperDate').AsDateTime);
     fStartWrite:=false;

     CancelCxFilter;
     RefreshDataSet;
     CDS.Filtered:=false;

     //для начала отмечаем всю печать
     cbPrintMovement.Checked:=(isChoice_local=false);
     //и отмечаем просмотр
     cbPrintPreview.Checked:=true;

     if ParamsMovement_local.ParamByName('MovementId').AsInteger<>0
     then CDS.Locate('Id',ParamsMovement_local.ParamByName('MovementId').AsString,[]);

     ActiveControl:=EditInvNumber_parent;

     Application.ProcessMessages;
     Application.ProcessMessages;
     Application.ProcessMessages;

     result:=ShowModal=mrOk;
     if result then
     begin
          CopyValuesParamsFrom(ParamsMovement_local,execParamsMovement);
          gpInitialize_MovementDesc;
          MainCehForm.InitializeGoodsKind(execParamsMovement.ParamByName('GoodsKindWeighingGroupId').AsInteger);
     end;
end;
{------------------------------------------------------------------------------}
procedure TGuideMovementCehForm.RefreshDataSet;
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
procedure TGuideMovementCehForm.CancelCxFilter;
begin
     if cxDBGridDBTableView.DataController.Filter.Active
     then begin cxDBGridDBTableView.DataController.Filter.Clear;cxDBGridDBTableView.DataController.Filter.Active:=false;end
end;
{------------------------------------------------------------------------------}
procedure TGuideMovementCehForm.myCheckPrintMovement;
begin
     if cbPrintMovement.Checked
     then
         if (CDS.RecordCount=0)or(isChoice_local=true)
         then cbPrintMovement.Checked:=false;
end;
{------------------------------------------------------------------------------}
procedure TGuideMovementCehForm.cbPrintMovementClick(Sender: TObject);
begin myCheckPrintMovement;end;
{------------------------------------------------------------------------------}
procedure TGuideMovementCehForm.FormKeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
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
procedure TGuideMovementCehForm.CDSFilterRecord(DataSet: TDataSet;var Accept: Boolean);
begin
     if (trim(EditInvNumber_parent.Text)<>'')
     then
       if (pos(AnsiUpperCase(EditInvNumber_parent.Text),AnsiUpperCase(DataSet.FieldByName('InvNumber_parent').AsString))>0)
       then Accept:=true else Accept:=false;
end;
{------------------------------------------------------------------------------}
function TGuideMovementCehForm.Checked: boolean; //Проверка корректного ввода в Edit
begin
     Result:=(CDS.RecordCount>0)and(bbChoice.Enabled=TRUE)and(CDS.FieldByName('Id').AsInteger>0);
     if Result then
     begin
         ParamsMovement_local.ParamByName('MovementId').AsInteger:=CDS.FieldByName('Id').AsInteger;
         DMMainScaleCehForm.gpGet_ScaleCeh_Movement(ParamsMovement_local,FALSE,FALSE);//isLast=FALSE,isNext=FALSE
     end;
end;

{------------------------------------------------------------------------------}
procedure TGuideMovementCehForm.EditInvNumber_parentChange(Sender: TObject);
begin
       with CDS do begin
           //***Filtered:=false;
           //***if trim(EditPartnerName.Text)<>'' then begin Filtered:=false;Filtered:=true;end;
           Filtered:=false;
           if trim(EditInvNumber_parent.Text)<>'' then Filtered:=true;
       end;
end;
{------------------------------------------------------------------------------}
procedure TGuideMovementCehForm.deStartPropertiesChange(Sender: TObject);
var  Year, Month, Day, Hour, Min, Sec, MSec: Word;
begin
     if fStartWrite then exit;
     //
     try StrToDate(deStart.Text); except exit;end;
     DecodeDate(StrToDate(deStart.Text), Year, Month, Day);
     if (Year>2000)and(LengTh(deStart.Text)>=10) then RefreshDataSet;
end;
{------------------------------------------------------------------------------}
procedure TGuideMovementCehForm.deEndPropertiesChange(Sender: TObject);
var  Year, Month, Day, Hour, Min, Sec, MSec: Word;
begin
     if fStartWrite then exit;
     //
     try StrToDate(deEnd.Text); except exit;end;
     DecodeDate(StrToDate(deEnd.Text), Year, Month, Day);
     if (Year>2000)and(LengTh(deStart.Text)>=10) then RefreshDataSet;
end;
{------------------------------------------------------------------------------}
procedure TGuideMovementCehForm.actRefreshExecute(Sender: TObject);
var MovementId:String;
begin
     MovementId:= CDS.FieldByName('Id').AsString;
     RefreshDataSet;
     if MovementId <> '' then
        CDS.Locate('Id',MovementId,[loCaseInsensitive]);
end;
{------------------------------------------------------------------------------}
procedure TGuideMovementCehForm.bbViewMIClick(Sender: TObject);
begin
    if CDS.FieldByName('Id').AsInteger = 0 then
    begin
         ShowMessage('Ошибка.Документ не выбран.');
         exit;
    end;
    //
    FormParams.ParamByName('Id').Value := CDS.FieldByName('Id').AsInteger;
    actViewMI.Execute;
end;
{------------------------------------------------------------------------------}
procedure TGuideMovementCehForm.actChoiceExecute(Sender: TObject);
begin
     if Checked then ModalResult:=mrOK;
end;
{------------------------------------------------------------------------------}
procedure TGuideMovementCehForm.actCompleteExecute(Sender: TObject);
var execParams:TParams;
    MovementId:String;
begin
     MovementId:= CDS.FieldByName('Id').AsString;
     //
     execParams:=nil;
     ParamAddValue(execParams,'MovementId',ftInteger,CDS.FieldByName('MovementId_parent').AsInteger);
     ParamAddValue(execParams,'StatusId',ftInteger,zc_Enum_Status_Complete);
     //
     DMMainScaleCehForm.gpUpdate_ScaleCeh_Movement_Status(execParams);
     //
     execParams.Free;
     //
     RefreshDataSet;
     if MovementId <> '' then
        CDS.Locate('Id',MovementId,[loCaseInsensitive]);
end;
{------------------------------------------------------------------------------}
procedure TGuideMovementCehForm.actUnCompleteExecute(Sender: TObject);
var execParams:TParams;
    MovementId:String;
begin
     MovementId:= CDS.FieldByName('Id').AsString;
     //
     execParams:=nil;
     ParamAddValue(execParams,'MovementId',ftInteger,CDS.FieldByName('MovementId_parent').AsInteger);
     ParamAddValue(execParams,'StatusId',ftInteger,zc_Enum_Status_UnComplete);
     //
     DMMainScaleCehForm.gpUpdate_ScaleCeh_Movement_Status(execParams);
     //
     execParams.Free;
     //
     RefreshDataSet;
     if MovementId <> '' then
        CDS.Locate('Id',MovementId,[loCaseInsensitive]);
end;
{------------------------------------------------------------------------------}
procedure TGuideMovementCehForm.actUpdateStatusExecute(Sender: TObject);
begin
     if MessageDlg('Действительно Провести документ <Инвентаризация>?',mtConfirmation,mbYesNoCancel,0) <> 6
     then exit;
     //
     if DMMainScaleCehForm.gpUpdate_Scale_Movement_Status_2(CDS.FieldByName('MovementId_parent').AsInteger) = true
     then actRefreshExecute(Self);
end;
{------------------------------------------------------------------------------}
procedure TGuideMovementCehForm.actExitExecute(Sender: TObject);
begin
     Close;
end;
{------------------------------------------------------------------------------}
procedure TGuideMovementCehForm.FormCreate(Sender: TObject);
begin
  Create_ParamsMovement(ParamsMovement_local);

  with spSelect do
  begin
       StoredProcName:='gpSelect_Scale_MovementCeh';
       Params.AddParam('inStartDate', ftDateTime, ptInput, 0);
       Params.AddParam('inEndDate', ftDateTime, ptInput,0);
       Params.AddParam('inIsComlete', ftBoolean, ptInput,FALSE);
       Params.AddParam('inBranchCode', ftInteger, ptInput,SettingMain.BranchCode);
       OutputType:=otDataSet;
  end;
end;
{------------------------------------------------------------------------------}
procedure TGuideMovementCehForm.FormDestroy(Sender: TObject);
begin
  ParamsMovement_local.Free;
end;
{------------------------------------------------------------------------------}
procedure TGuideMovementCehForm.bbChangeOperDatePartnerClick(Sender: TObject);
var execParams:TParams;
begin
    execParams:=nil;
    ParamAddValue(execParams,'inMovementId',ftInteger,CDS.FieldByName('MovementId_parent').AsInteger);
    ParamAddValue(execParams,'inDescCode',ftString,'Movement.OperDate');
    //
    if CDS.RecordCount=0 then
    begin
         ShowMessage('Ошибка.Документ не выбран.');
         exit;
    end;
    //
    if CDS.FieldByName('MovementDescId').AsInteger <> zc_Movement_Send then
    begin
         ShowMessage('Ошибка.Изменение даты возможно только для перемещения.');
         exit;
    end;
    //
    if CDS.FieldByName('MovementId_parent').AsInteger = 0 then
    begin
         ShowMessage('Ошибка.Документ <Перемещение> не сохранен.');
         exit;
    end;
    //
    with DialogDateValueForm do
    begin
          LabelDateValue.Caption:='ДАТА документа';
          ActiveControl:=DateValueEdit;
          DateValueEdit.Text:=DateToStr(CDS.FieldByName('OperDate_parent').AsDateTime);
          isPartionGoodsDate:=false;
          if not Execute then begin exit;end;
     end;
    //
    try ParamAddValue(execParams,'inValueData',ftDateTime,StrToDate(DialogDateValueForm.DateValueEdit.Text));
    except
        ShowMessage('Ошибка.Неправильное значение даты.');
    end;
    //
    //
    if DMMainScaleCehForm.gpUpdate_Scale_MovementDate(execParams)
    then actRefreshExecute(Self);
    //
    execParams.Free;
end;
{------------------------------------------------------------------------------}
procedure TGuideMovementCehForm.bbPrintClick(Sender: TObject);
begin
     //
     myCheckPrintMovement;
     //
     if    not(cbPrintMovement.Checked)
       and not(cbPrintPackGross.Checked)
     then begin
               ShowMessage('Ошибка.Не выбран вариант печати.');
               exit;
     end;

     //
     if cbPrintMovement.Checked
     then Print_Movement (CDS.FieldByName('MovementDescId').AsInteger
                        , CDS.FieldByName('MovementId_parent').AsInteger
                        , CDS.FieldByName('Id').AsInteger               // MovementId_by
                        , 1    // myPrintCount
                        , TRUE // isPreview
                        , FALSE // DialogMovementDescForm.Get_isSendOnPriceIn(CDS.FieldByName('MovementDescNumber').AsInteger)
                         );
     //
     if cbPrintPackGross.Checked
     then Print_PackGross_Send (CDS.FieldByName('MovementDescId').AsInteger
                              , CDS.FieldByName('MovementId_parent').AsInteger
                              , CDS.FieldByName('Id').AsInteger               // MovementId_by
                              , 1    // myPrintCount
                              , TRUE // isPreview
                               );
end;
{------------------------------------------------------------------------------}
end.
