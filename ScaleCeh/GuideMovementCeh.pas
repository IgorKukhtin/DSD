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
 ,DataModul, dsdAction;

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
    Status: TcxGridDBColumn;
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
uses dmMainScaleCeh,dmMainScale,UtilScale,UtilPrint,MainCeh,DialogMovementDesc;
{------------------------------------------------------------------------------}
function TGuideMovementCehForm.Execute(var execParamsMovement:TParams;isChoice:Boolean): boolean;
begin
     CopyValuesParamsFrom(execParamsMovement,ParamsMovement_local);

     // ���� ����� ��� ������
     {if isChoice = TRUE
     then // ���� ����� ��������� � �� ����, ����� ��������� ����� �� ����
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

     //��� ������ �������� ��� ������
     cbPrintMovement.Checked:=(isChoice_local=false);
     //� �������� ��������
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
function TGuideMovementCehForm.Checked: boolean; //�������� ����������� ����� � Edit
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
         ShowMessage('������.�������� �� ������.');
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
       OutputType:=otDataSet;
  end;
end;
{------------------------------------------------------------------------------}
procedure TGuideMovementCehForm.FormDestroy(Sender: TObject);
begin
  ParamsMovement_local.Free;
end;
{------------------------------------------------------------------------------}
procedure TGuideMovementCehForm.bbPrintClick(Sender: TObject);
begin
     //
     myCheckPrintMovement;
     //
     if    not(cbPrintMovement.Checked)
     then begin
               ShowMessage('������.�� ������ ������� ������.');
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
end;
{------------------------------------------------------------------------------}
end.
