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
 ,DataModul, dsdAction, Vcl.Menus;

type
  TGuideMovementForm = class(TForm)
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
    InvNumber: TcxGridDBColumn;
    InvNumberOrder: TcxGridDBColumn;
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
    cbPrintPreview: TCheckBox;
    InvNumber_parent: TcxGridDBColumn;
    OperDate_parent: TcxGridDBColumn;
    InvNumber_TransportGoods: TcxGridDBColumn;
    OperDate_TransportGoods: TcxGridDBColumn;
    bbViewMI: TSpeedButton;
    FormParams: TdsdFormParams;
    actViewMI: TdsdInsertUpdateAction;
    InvNumberPartner_Tax: TcxGridDBColumn;
    OperDate_Tax: TcxGridDBColumn;
    MovementDescNumber: TcxGridDBColumn;
    bbEDI_Invoice: TSpeedButton;
    bbEDI_Ordspr: TSpeedButton;
    bbEDI_Desadv: TSpeedButton;
    EdiOrdspr: TcxGridDBColumn;
    EdiInvoice: TcxGridDBColumn;
    EdiDesadv: TcxGridDBColumn;
    bbSale_Order_all: TSpeedButton;
    bbSale_Order_diff: TSpeedButton;
    InvNumber_Transport: TcxGridDBColumn;
    OperDate_Transport: TcxGridDBColumn;
    CarName: TcxGridDBColumn;
    RouteName: TcxGridDBColumn;
    PersonalDriverName: TcxGridDBColumn;
    StartRunPlan: TcxGridDBColumn;
    bbPrint_diff: TSpeedButton;
    InvNumber_Reestr: TcxGridDBColumn;
    OperDate_Reestr: TcxGridDBColumn;
    ReestrKindName: TcxGridDBColumn;
    bbPrint_ReestrKind: TSpeedButton;
    PopupMenu: TPopupMenu;
    miRefresh: TMenuItem;
    miChangeMember: TMenuItem;
    actChangeMember: TAction;
    cbPrintPackGross: TCheckBox;
    bbSale_Order_diffTax: TSpeedButton;
    bbPrintStickerTermo: TSpeedButton;
    PersonalCode5: TcxGridDBColumn;
    PersonalName5: TcxGridDBColumn;
    PositionName5: TcxGridDBColumn;
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
    procedure cbPrintTransportClick(Sender: TObject);
    procedure cbPrintQualityClick(Sender: TObject);
    procedure cbPrintTaxClick(Sender: TObject);
    procedure cbPrintPackClick(Sender: TObject);
    procedure cbPrintSpecClick(Sender: TObject);
    procedure cbPrintAccountClick(Sender: TObject);
    procedure cbPrintMovementClick(Sender: TObject);
    procedure bbEDI_InvoiceClick(Sender: TObject);
    procedure bbEDI_OrdsprClick(Sender: TObject);
    procedure bbEDI_DesadvClick(Sender: TObject);
    procedure bbSale_Order_allClick(Sender: TObject);
    procedure bbSale_Order_diffClick(Sender: TObject);
    procedure bbPrint_diffClick(Sender: TObject);
    procedure bbPrint_ReestrKindClick(Sender: TObject);
    procedure actChangeMemberExecute(Sender: TObject);
    procedure bbSale_Order_diffTaxClick(Sender: TObject);
    procedure bbPrintStickerTermoClick(Sender: TObject);
  private
    fStartWrite:Boolean;

    ParamsMovement_local: TParams;
    isChoice_local:Boolean;

    procedure myCheckPrintMovement;
    procedure myCheckPrintTransport;
    procedure myCheckPrintQuality;
    procedure myCheckPrintTax;
    procedure myCheckPrintAccount;
    procedure myCheckPrintPack;
    procedure myCheckPrintSpec;

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
uses dmMainScale,UtilScale,UtilPrint,Main,DialogMovementDesc;
{------------------------------------------------------------------------------}
function TGuideMovementForm.Execute(var execParamsMovement:TParams;isChoice:Boolean): boolean;
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

     //��� ������ ������� ��� ������
     cbPrintMovement.Checked:=false;
     cbPrintTransport.Checked:=false;
     cbPrintQuality.Checked:=false;
     cbPrintTax.Checked:=false;
     cbPrintAccount.Checked:=false;
     cbPrintPack.Checked:=false;
     cbPrintPackGross.Checked:=false;
     cbPrintSpec.Checked:=false;
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
procedure TGuideMovementForm.myCheckPrintMovement;
begin
     if cbPrintMovement.Checked
     then
         if (CDS.RecordCount=0)or(isChoice_local=true)
         then cbPrintMovement.Checked:=false;
end;
{------------------------------------------------------------------------------}
procedure TGuideMovementForm.myCheckPrintTransport;
begin
     if cbPrintTransport.Checked
     then
         if ((CDS.FieldByName('MovementDescId').AsInteger<>zc_Movement_Sale)
          and(CDS.FieldByName('MovementDescId').AsInteger<>zc_Movement_SendOnPrice)
            )
          or(CDS.RecordCount=0)or(isChoice_local=true)
         then cbPrintTransport.Checked:=false;
end;
{------------------------------------------------------------------------------}
procedure TGuideMovementForm.myCheckPrintQuality;
begin
     if cbPrintQuality.Checked
     then
         if ((CDS.FieldByName('MovementDescId').AsInteger<>zc_Movement_Sale)
          and(CDS.FieldByName('MovementDescId').AsInteger<>zc_Movement_SendOnPrice)
            )
          or(CDS.RecordCount=0)or(isChoice_local=true)
         then cbPrintQuality.Checked:=false;
end;
{------------------------------------------------------------------------------}
procedure TGuideMovementForm.myCheckPrintTax;
begin
     if cbPrintTax.Checked
     then
         if  (CDS.FieldByName('MovementDescId').AsInteger<>zc_Movement_Sale)
          or (GetArrayList_Value_byName(Default_Array,'isTax') <> AnsiUpperCase('TRUE'))
          or (CDS.RecordCount=0)or(isChoice_local=true)
         then cbPrintTax.Checked:=false;
end;
{------------------------------------------------------------------------------}
procedure TGuideMovementForm.myCheckPrintAccount;
begin
     if cbPrintAccount.Checked
     then
         if  (CDS.FieldByName('MovementDescId').AsInteger<>zc_Movement_Sale)
          or (CDS.RecordCount=0)or(isChoice_local=true)
         then cbPrintAccount.Checked:=false;
end;
{------------------------------------------------------------------------------}
procedure TGuideMovementForm.myCheckPrintPack;
begin
     if cbPrintPack.Checked
     then
         if  ((CDS.FieldByName('MovementDescId').AsInteger<>zc_Movement_Sale) and (CDS.FieldByName('MovementDescId').AsInteger<>zc_Movement_SendOnPrice))
          or (CDS.RecordCount=0)//or(isChoice_local=true)
         then cbPrintPack.Checked:=false;
end;
{------------------------------------------------------------------------------}
procedure TGuideMovementForm.myCheckPrintSpec;
begin
     if cbPrintSpec.Checked
     then
         if  ((CDS.FieldByName('MovementDescId').AsInteger<>zc_Movement_Sale) and (CDS.FieldByName('MovementDescId').AsInteger<>zc_Movement_SendOnPrice))
          or (CDS.RecordCount=0)//or(isChoice_local=true)
         then cbPrintSpec.Checked:=false;
end;
{------------------------------------------------------------------------------}
procedure TGuideMovementForm.cbPrintMovementClick(Sender: TObject);
begin myCheckPrintMovement;end;
{------------------------------------------------------------------------------}
procedure TGuideMovementForm.cbPrintTransportClick(Sender: TObject);
begin myCheckPrintTransport;end;
{------------------------------------------------------------------------------}
procedure TGuideMovementForm.cbPrintQualityClick(Sender: TObject);
begin myCheckPrintQuality;end;
{------------------------------------------------------------------------------}
procedure TGuideMovementForm.cbPrintTaxClick(Sender: TObject);
begin myCheckPrintTax;end;
{------------------------------------------------------------------------------}
procedure TGuideMovementForm.cbPrintAccountClick(Sender: TObject);
begin myCheckPrintAccount;end;
{------------------------------------------------------------------------------}
procedure TGuideMovementForm.cbPrintPackClick(Sender: TObject);
begin myCheckPrintPack;end;
{------------------------------------------------------------------------------}
procedure TGuideMovementForm.cbPrintSpecClick(Sender: TObject);
begin myCheckPrintSpec;end;
{------------------------------------------------------------------------------}
procedure TGuideMovementForm.FormKeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
begin
     if Key = VK_F8 then bbSale_Order_allClick(Self);
     if Key = VK_F9 then bbSale_Order_diffTaxClick(Self);

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
     if (trim(EditInvNumber_parent.Text)<>'')
     then
       if (pos(AnsiUpperCase(EditInvNumber_parent.Text),AnsiUpperCase(DataSet.FieldByName('InvNumber_parent').AsString))>0)
       then Accept:=true else Accept:=false;
end;
{------------------------------------------------------------------------------}
function TGuideMovementForm.Checked: boolean; //�������� ����������� ����� � Edit
begin
     Result:=(CDS.RecordCount>0)and(bbChoice.Enabled=TRUE)and(CDS.FieldByName('Id').AsInteger>0);
     if Result then
     begin
         ParamsMovement_local.ParamByName('MovementId').AsInteger:=CDS.FieldByName('Id').AsInteger;
         DMMainScaleForm.gpGet_Scale_Movement(ParamsMovement_local,FALSE,FALSE);//isLast=FALSE,isNext=FALSE
     end;
end;

{------------------------------------------------------------------------------}
procedure TGuideMovementForm.EditInvNumber_parentChange(Sender: TObject);
begin
       with CDS do begin
           //***Filtered:=false;
           //***if trim(EditPartnerName.Text)<>'' then begin Filtered:=false;Filtered:=true;end;
           Filtered:=false;
           if trim(EditInvNumber_parent.Text)<>'' then Filtered:=true;
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
procedure TGuideMovementForm.actChangeMemberExecute(Sender: TObject);
var execParams:TParams;
begin
    Create_ParamsPersonalComplete(execParams);
    //
    if CDS.RecordCount=0 then
    begin
         ShowMessage('������.�������� �� ������.');
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
    execParams.ParamByName('PersonalId5').AsInteger:=CDS.FieldByName('PersonalId5').AsInteger;
    execParams.ParamByName('PersonalCode5').AsInteger:=CDS.FieldByName('PersonalCode5').AsInteger;
    execParams.ParamByName('PersonalName5').AsString:=CDS.FieldByName('PersonalName5').AsString;
    execParams.ParamByName('PositionId5').AsInteger:=CDS.FieldByName('PositionId5').AsInteger;
    execParams.ParamByName('PositionCode5').AsInteger:=CDS.FieldByName('PositionCode5').AsInteger;
    execParams.ParamByName('PositionName5').AsString:=CDS.FieldByName('PositionName5').AsString;
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
procedure TGuideMovementForm.bbViewMIClick(Sender: TObject);
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
  bbChangeMember.Enabled:=GetArrayList_Value_byName(Default_Array,'isPersonalComplete') = AnsiUpperCase('TRUE');

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
     myCheckPrintMovement;
     myCheckPrintTransport;
     myCheckPrintQuality;
     myCheckPrintTax;
     myCheckPrintAccount;
     myCheckPrintPack;
     myCheckPrintSpec;
     //
     if    not(cbPrintMovement.Checked)
       and not(cbPrintTax.Checked)
       and not(cbPrintAccount.Checked)
       and not(cbPrintPack.Checked)
       and not(cbPrintPackGross.Checked)
       and not(cbPrintSpec.Checked)
       and not(cbPrintTransport.Checked)
       and not(cbPrintQuality.Checked)
     then begin
               ShowMessage('������.�� ������ ������� ������.');
               exit;
     end;

     //
     if cbPrintMovement.Checked
     then Print_Movement (CDS.FieldByName('MovementDescId').AsInteger
                        , CDS.FieldByName('MovementId_parent').AsInteger// MovementId
                        , CDS.FieldByName('Id').AsInteger               // MovementId_by
                        , 1    // myPrintCount
                        , TRUE // isPreview
                        , DialogMovementDescForm.Get_isSendOnPriceIn(CDS.FieldByName('MovementDescNumber').AsInteger)
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
     if cbPrintPackGross.Checked
     then Print_PackGross (CDS.FieldByName('MovementDescId').AsInteger
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
procedure TGuideMovementForm.bbPrint_diffClick(Sender: TObject);
begin
     Print_MovementDiff (CDS.FieldByName('MovementDescId').AsInteger
                       //, CDS.FieldByName('Id').AsInteger               // MovementId
                       , CDS.FieldByName('MovementId_parent').AsInteger  // MovementId
                        );
end;
{------------------------------------------------------------------------------}
procedure TGuideMovementForm.bbPrint_ReestrKindClick(Sender: TObject);
begin
     Print_MovementReestrKind (CDS.FieldByName('MovementId_Reestr').AsInteger);
end;
{------------------------------------------------------------------------------}
procedure TGuideMovementForm.bbSale_Order_allClick(Sender: TObject);
begin
     with CDS do Print_Sale_Order(CDS.FieldByName('MovementId_Order').AsInteger,FieldByName('Id').AsInteger,FALSE,FALSE);
end;
{------------------------------------------------------------------------------}
procedure TGuideMovementForm.bbSale_Order_diffClick(Sender: TObject);
begin
     with CDS do Print_Sale_Order(CDS.FieldByName('MovementId_Order').AsInteger,FieldByName('Id').AsInteger,TRUE,FALSE);
end;
{------------------------------------------------------------------------------}
procedure TGuideMovementForm.bbSale_Order_diffTaxClick(Sender: TObject);
begin
     with CDS do Print_Sale_Order(CDS.FieldByName('MovementId_Order').AsInteger,FieldByName('Id').AsInteger,FALSE,TRUE);
end;
{------------------------------------------------------------------------------}
procedure TGuideMovementForm.bbPrintStickerTermoClick(Sender: TObject);
begin
     with CDS do Print_StickerTermo(CDS.FieldByName('MovementDescId').AsInteger, CDS.FieldByName('MovementId_parent').AsInteger,TRUE);
end;
{------------------------------------------------------------------------------}
procedure TGuideMovementForm.bbEDI_DesadvClick(Sender: TObject);
begin
     if MessageDlg('EDI <����������� - Desadv>.'+#10+#13+'������������� ���������?',mtConfirmation,mbYesNoCancel,0) <> 6
     then exit;
     //
     SendEDI_Desadv (CDS.FieldByName('MovementId_parent').AsInteger);
end;
{------------------------------------------------------------------------------}
procedure TGuideMovementForm.bbEDI_InvoiceClick(Sender: TObject);
begin
     if MessageDlg('EDI <���� - Invoice>.'+#10+#13+'������������� ���������?',mtConfirmation,mbYesNoCancel,0) <> 6
     then exit;
     //
     SendEDI_Invoice (CDS.FieldByName('MovementId_parent').AsInteger);
end;
{------------------------------------------------------------------------------}
procedure TGuideMovementForm.bbEDI_OrdsprClick(Sender: TObject);
begin
     if MessageDlg('EDI <������������� - Ordspr>.'+#10+#13+'������������� ���������?',mtConfirmation,mbYesNoCancel,0) <> 6
     then exit;
     //
     SendEDI_Ordspr (CDS.FieldByName('MovementId_parent').AsInteger);
end;
{------------------------------------------------------------------------------}
end.
