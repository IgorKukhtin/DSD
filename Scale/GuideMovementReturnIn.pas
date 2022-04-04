unit GuideMovementReturnIn;

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
  dxSkinXmas2008Blue;

type
  TGuideMovementReturnInForm = class(TForm)
    GridPanel: TPanel;
    ParamsPanel: TPanel;
    DS: TDataSource;
    ButtonPanel: TPanel;
    ButtonExit: TSpeedButton;
    bbRefresh: TSpeedButton;
    bbChoice: TSpeedButton;
    spSelect: TdsdStoredProc;
    CDS: TClientDataSet;
    gbInvNumber: TGroupBox;
    EditInvNumber: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    deStart: TcxDateEdit;
    deEnd: TcxDateEdit;
    cxDBGrid: TcxGrid;
    cxDBGridDBTableView: TcxGridDBTableView;
    Status: TcxGridDBColumn;
    OperDate: TcxGridDBColumn;
    InvNumber: TcxGridDBColumn;
    cxDBGridLevel: TcxGridLevel;
    DBViewAddOn: TdsdDBViewAddOn;
    ActionList: TActionList;
    actRefresh: TAction;
    actChoice: TAction;
    actExit: TAction;
    FormParams: TdsdFormParams;
    cbAll: TCheckBox;
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
    procedure cbAllClick(Sender: TObject);
  private
    fStartWrite:Boolean;

    ParamsMovement_local: TParams;

    procedure CancelCxFilter;
    function Checked: boolean;
    procedure RefreshDataSet;
  public
    function Execute(var execParamsMovement:TParams;isChoice:Boolean): boolean;
  end;

var
  GuideMovementReturnInForm: TGuideMovementReturnInForm;

implementation
{$R *.dfm}
uses dmMainScale,UtilScale,UtilPrint,Main,DialogMovementDesc;
{------------------------------------------------------------------------------}
function TGuideMovementReturnInForm.Execute(var execParamsMovement:TParams;isChoice:Boolean): boolean;
begin
     CopyValuesParamsFrom(execParamsMovement,ParamsMovement_local);

     // если вызов для выбора
     {if isChoice = TRUE
     then // если нужен следующий и он один, тогда открывать форму не надо
          if TRUE = DMMainScaleForm.gpGet_Scale_Movement(ParamsMovement_local,FALSE,TRUE)//isLast=FALSE,isNext=TRUE
          then begin CopyValuesParamsFrom(ParamsMovement_local,execParamsMovement);exit;end;}

     EditInvNumber.Text:='';

     CancelCxFilter;
     RefreshDataSet;
     CDS.Filtered:=false;

     if ParamsMovement_local.ParamByName('MovementId_reReturnIn').AsInteger<>0
     then CDS.Locate('Id',ParamsMovement_local.ParamByName('MovementId_reReturnIn').AsString,[]);

     ActiveControl:=EditInvNumber;

     Application.ProcessMessages;
     Application.ProcessMessages;
     Application.ProcessMessages;

     result:=ShowModal=mrOk;
     if result then
     begin
          CopyValuesParamsFrom(ParamsMovement_local,execParamsMovement);
     end;
end;
{------------------------------------------------------------------------------}
procedure TGuideMovementReturnInForm.RefreshDataSet;
var StartDate,EndDate:TDateTime;
begin
     StartDate:=StrToDate(deStart.Text);
     EndDate:=StrToDate(deEnd.Text);

     with spSelect do
     begin
          ParamByName('inStartDate').Value:=StartDate;
          ParamByName('inEndDate').Value:=EndDate;
          ParamByName('inBranchCode').Value:=SettingMain.BranchCode;
          ParamByName('inPartnerId').Value:=ParamsMovement_local.ParamByName('ToId').AsInteger;
          ParamByName('inContractId').Value:=ParamsMovement_local.ParamByName('ContractId').AsInteger;
          ParamByName('inUnitId').Value:=ParamsMovement_local.ParamByName('FromId').AsInteger;
          Execute;
     end;
end;
{------------------------------------------------------------------------------}
procedure TGuideMovementReturnInForm.cbAllClick(Sender: TObject);
begin
     RefreshDataSet;
end;
{------------------------------------------------------------------------------}
procedure TGuideMovementReturnInForm.CancelCxFilter;
begin
     if cxDBGridDBTableView.DataController.Filter.Active
     then begin cxDBGridDBTableView.DataController.Filter.Clear;cxDBGridDBTableView.DataController.Filter.Active:=false;end
end;
{------------------------------------------------------------------------------}
procedure TGuideMovementReturnInForm.FormKeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
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
procedure TGuideMovementReturnInForm.CDSFilterRecord(DataSet: TDataSet;var Accept: Boolean);
begin
     if (trim(EditInvNumber.Text)<>'')
     then
       if (pos(AnsiUpperCase(EditInvNumber.Text),AnsiUpperCase(DataSet.FieldByName('InvNumber').AsString))>0)
       then Accept:=true else Accept:=false;
end;
{------------------------------------------------------------------------------}
function TGuideMovementReturnInForm.Checked: boolean; //Проверка корректного ввода в Edit
begin
     Result:=(CDS.RecordCount>0)and(CDS.FieldByName('Id').AsInteger>0);
     if Result then
     begin
         ParamsMovement_local.ParamByName('MovementId_reReturnIn').AsInteger:=CDS.FieldByName('Id').AsInteger;
         ParamsMovement_local.ParamByName('InvNumber_reReturnIn').AsString:=CDS.FieldByName('InvNumber').AsString;
         ParamsMovement_local.ParamByName('OperDate_reReturnIn').AsString:=CDS.FieldByName('OperDate').AsString;
     end;
end;

{------------------------------------------------------------------------------}
procedure TGuideMovementReturnInForm.EditInvNumberChange(Sender: TObject);
begin
       with CDS do begin
           //***Filtered:=false;
           //***if trim(EditPartnerName.Text)<>'' then begin Filtered:=false;Filtered:=true;end;
           Filtered:=false;
           if trim(EditInvNumber.Text)<>'' then Filtered:=true;
       end;
end;
{------------------------------------------------------------------------------}
procedure TGuideMovementReturnInForm.deStartPropertiesChange(Sender: TObject);
var  Year, Month, Day, Hour, Min, Sec, MSec: Word;
begin
     if fStartWrite then exit;
     //
     try StrToDate(deStart.Text); except exit;end;
     DecodeDate(StrToDate(deStart.Text), Year, Month, Day);
     if (Year>2000)and(LengTh(deStart.Text)>=10) then RefreshDataSet;
end;
{------------------------------------------------------------------------------}
procedure TGuideMovementReturnInForm.deEndPropertiesChange(Sender: TObject);
var  Year, Month, Day, Hour, Min, Sec, MSec: Word;
begin
     if fStartWrite then exit;
     //
     try StrToDate(deEnd.Text); except exit;end;
     DecodeDate(StrToDate(deEnd.Text), Year, Month, Day);
     if (Year>2000)and(LengTh(deStart.Text)>=10) then RefreshDataSet;
end;
{------------------------------------------------------------------------------}
procedure TGuideMovementReturnInForm.actRefreshExecute(Sender: TObject);
var MovementId:String;
begin
     MovementId:= CDS.FieldByName('Id').AsString;
     RefreshDataSet;
     if MovementId <> '' then
        CDS.Locate('Id',MovementId,[loCaseInsensitive]);
end;
{------------------------------------------------------------------------------}
procedure TGuideMovementReturnInForm.actChoiceExecute(Sender: TObject);
begin
     if Checked then ModalResult:=mrOK;
end;
{------------------------------------------------------------------------------}
procedure TGuideMovementReturnInForm.actExitExecute(Sender: TObject);
begin
     Close;
end;
{------------------------------------------------------------------------------}
procedure TGuideMovementReturnInForm.FormCreate(Sender: TObject);
begin
  Create_ParamsMovement(ParamsMovement_local);

  fStartWrite:=true;
  deStart.Text:=DateToStr(Date - 7);
  deEnd.Text:=DateToStr(Date);
  fStartWrite:=false;

  with spSelect do
  begin
       StoredProcName:='gpSelect_Scale_MovementReReturnIn';
       Params.AddParam('inStartDate', ftDateTime, ptInput, 0);
       Params.AddParam('inEndDate', ftDateTime, ptInput,0);
       Params.AddParam('inBranchCode', ftInteger, ptInput,0);
       Params.AddParam('inPartnerId', ftInteger, ptInput,0);
       Params.AddParam('inContractId', ftInteger, ptInput,0);
       Params.AddParam('inUnitId', ftInteger, ptInput,0);
       OutputType:=otDataSet;
  end;

end;
{------------------------------------------------------------------------------}
procedure TGuideMovementReturnInForm.FormDestroy(Sender: TObject);
begin
  ParamsMovement_local.Free;
end;
{------------------------------------------------------------------------------}
end.
