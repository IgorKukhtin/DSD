unit GuidePartner;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, DBTables, StdCtrls, ExtCtrls, Grids, DBGrids, Buttons,
  Datasnap.DBClient, dsdDB, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore,
  dxSkinsDefaultPainters, cxTextEdit, cxCurrencyEdit, cxStyles,
  dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage, cxDBData,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxClasses, cxGridCustomView, cxGrid,dsdAddOn, Vcl.ActnList,
  dsdAction
 ,UtilScale,DataModul;

type
  TGuidePartnerForm = class(TForm)
    GridPanel: TPanel;
    ParamsPanel: TPanel;
    DS: TDataSource;
    ButtonPanel: TPanel;
    bbExit: TSpeedButton;
    bbRefresh: TSpeedButton;
    bbChoice: TSpeedButton;
    spSelect: TdsdStoredProc;
    CDS: TClientDataSet;
    gbPartnerCode: TGroupBox;
    EditPartnerCode: TEdit;
    gbPartnerName: TGroupBox;
    EditPartnerName: TEdit;
    cxDBGrid: TcxGrid;
    cxDBGridDBTableView: TcxGridDBTableView;
    cxDBGridLevel: TcxGridLevel;
    PartnerCode: TcxGridDBColumn;
    PartnerName: TcxGridDBColumn;
    PaidKindName: TcxGridDBColumn;
    ContractCode: TcxGridDBColumn;
    ContractNumber: TcxGridDBColumn;
    ContractTagName: TcxGridDBColumn;
    ChangePercent: TcxGridDBColumn;
    ChangePercentAmount: TcxGridDBColumn;
    InfoMoneyCode: TcxGridDBColumn;
    InfoMoneyName: TcxGridDBColumn;
    DBViewAddOn: TdsdDBViewAddOn;
    ActionList: TActionList;
    actRefresh: TAction;
    actChoice: TAction;
    actExit: TAction;
    isMovement: TcxGridDBColumn;
    isAccount: TcxGridDBColumn;
    isTransport: TcxGridDBColumn;
    isQuality: TcxGridDBColumn;
    isPack: TcxGridDBColumn;
    isSpec: TcxGridDBColumn;
    isTax: TcxGridDBColumn;
    bb: TSpeedButton;
    ItemName: TcxGridDBColumn;
    CountMovement: TcxGridDBColumn;
    CountAccount: TcxGridDBColumn;
    CountTransport: TcxGridDBColumn;
    CountQuality: TcxGridDBColumn;
    CountPack: TcxGridDBColumn;
    CountSpec: TcxGridDBColumn;
    CountTax: TcxGridDBColumn;
    procedure FormCreate(Sender: TObject);
    procedure EditPartnerNameEnter(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditPartnerCodeKeyPress(Sender: TObject; var Key: Char);
    procedure EditPartnerCodeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditPartnerNameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditPartnerCodeChange(Sender: TObject);
    procedure EditPartnerNameChange(Sender: TObject);
    procedure EditPartnerCodeEnter(Sender: TObject);
    procedure CDSFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure EditPartnerNameKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);
    procedure actRefreshExecute(Sender: TObject);
    procedure actChoiceExecute(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure bbClick(Sender: TObject);
  private
    fEnterPartnerCode:Boolean;
    fEnterPartnerName:Boolean;

    ParamsMovement_local: TParams;

    procedure CancelCxFilter;
    function Checked: boolean;
  public
    function Execute(var execParamsMovement:TParams): boolean;
  end;

var
  GuidePartnerForm: TGuidePartnerForm;

implementation

{$R *.dfm}

 uses dmMainScale;
{------------------------------------------------------------------------------}
function TGuidePartnerForm.Execute(var execParamsMovement:TParams): boolean;
begin
     CopyValuesParamsFrom(execParamsMovement,ParamsMovement_local);

     if ParamsMovement_local.ParamByName('calcPartnerCode').AsInteger<>0
     then EditPartnerCode.Text:=IntToStr(ParamsMovement_local.ParamByName('calcPartnerCode').AsInteger)
     else EditPartnerCode.Text:='';
     EditPartnerName.Text:='';

     CancelCxFilter;
     {if  (ParamsMovement_local.ParamByName('MovementDescId').AsInteger = zc_Movement_Income)
       or(ParamsMovement_local.ParamByName('MovementDescId').AsInteger = zc_Movement_ReturnOut)
       or(ParamsMovement_local.ParamByName('MovementDescId').AsInteger = zc_Movement_Sale)
       or(ParamsMovement_local.ParamByName('MovementDescId').AsInteger = zc_Movement_ReturnIn)
     then CDS.Filter:='InfoMoneyId='+ParamsMovement_local.ParamByName('InfoMoneyId').AsString
                    + ' and ObjectDescId='+IntToStr(zc_Object_Partner)}
     if  (ParamsMovement_local.ParamByName('MovementDescId').AsInteger = zc_Movement_Income)
       or(ParamsMovement_local.ParamByName('MovementDescId').AsInteger = zc_Movement_ReturnOut)
     then CDS.Filter:='MovementDescId='+IntToStr(zc_Movement_Income)
                    + ' and ObjectDescId='+IntToStr(zc_Object_Partner)
     else
     if  (ParamsMovement_local.ParamByName('MovementDescId').AsInteger = zc_Movement_Sale)
       or(ParamsMovement_local.ParamByName('MovementDescId').AsInteger = zc_Movement_ReturnIn)
       or(ParamsMovement_local.ParamByName('MovementDescId').AsInteger = zc_Movement_Inventory)
     then CDS.Filter:='MovementDescId='+IntToStr(zc_Movement_Sale)
                    + ' and ObjectDescId='+IntToStr(zc_Object_Partner)
     else if (ParamsMovement_local.ParamByName('MovementDescId').AsInteger = zc_Movement_Loss)
          //then CDS.Filter:='ObjectDescId='+IntToStr(zc_Object_Member) + ' or ObjectDescId='+IntToStr(zc_Object_Car) + ' or ObjectDescId='+IntToStr(zc_Object_ArticleLoss)
          then CDS.Filter:='MovementDescId='+IntToStr(zc_Movement_Loss)
          else if (ParamsMovement_local.ParamByName('MovementDescId').AsInteger = zc_Movement_Send)
               //then CDS.Filter:='ObjectDescId='+IntToStr(zc_Object_Member) + ' or ObjectDescId='+IntToStr(zc_Object_Car) + ' or ObjectDescId='+IntToStr(zc_Object_ArticleLoss)
               then CDS.Filter:='MovementDescId='+IntToStr(zc_Movement_Send)
               else if (ParamsMovement_local.ParamByName('MovementDescId').AsInteger = zc_Movement_SendOnPrice)
                    then CDS.Filter:='ObjectDescId='+IntToStr(zc_Object_Unit)
               else CDS.Filter:='1=0';


     if ParamsMovement_local.ParamByName('calcPartnerCode').AsInteger<>0
     then begin ActiveControl:=EditPartnerCode;fEnterPartnerCode:=true;EditPartnerCode.SelectAll;end
     else begin ActiveControl:=EditPartnerName;fEnterPartnerCode:=false;end;
     fEnterPartnerName:=false;

     CDS.Filtered:=false;
     CDS.Filtered:=true;

     if ParamsMovement_local.ParamByName('calcPartnerId').AsInteger<>0
     then CDS.Locate('PartnerId',ParamsMovement_local.ParamByName('calcPartnerId').AsString,[]);

     Application.ProcessMessages;
     Application.ProcessMessages;
     Application.ProcessMessages;

     result:=ShowModal=mrOk;
     if result then
       if ParamsMovement_local.ParamByName('MovementDescId').AsInteger = zc_Movement_Inventory
       then begin
                 execParamsMovement.ParamByName('calcPartnerId').AsInteger:= ParamsMovement_local.ParamByName('calcPartnerId').AsInteger;
                 execParamsMovement.ParamByName('ContractId').AsInteger   := ParamsMovement_local.ParamByName('ContractId').AsInteger;
            end
       else CopyValuesParamsFrom(ParamsMovement_local,execParamsMovement);
end;
{------------------------------------------------------------------------------}
procedure TGuidePartnerForm.CancelCxFilter;
begin
     if cxDBGridDBTableView.DataController.Filter.Active
     then begin cxDBGridDBTableView.DataController.Filter.Clear;cxDBGridDBTableView.DataController.Filter.Active:=false;end
end;
{------------------------------------------------------------------------------}
procedure TGuidePartnerForm.FormKeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
begin
    if Key=13
    then
        if (ActiveControl=cxDBGrid)and(CDS.RecordCount>0)
        then actChoiceExecute(Self)
        else begin
                  if (CDS.RecordCount=1)
                  then actChoiceExecute(Self)
                  else if (ActiveControl=EditPartnerCode)
                       then ActiveControl:=EditPartnerName
                       else if (ActiveControl=EditPartnerName)
                            then ActiveControl:=EditPartnerCode;
        end;
    //
    if (Key=27) then
      if cxDBGridDBTableView.DataController.Filter.Active
      then CancelCxFilter
      else actExitExecute(Self);
end;
{------------------------------------------------------------------------------}
procedure TGuidePartnerForm.bbClick(Sender: TObject);
begin
     if CDS.FieldByName('PartnerId').AsInteger = 0 then
     begin
          ShowMessage('Ошибка.Контрагент не выбран.');
          exit;
     end;
     //
     with CDS do
     begin
         if cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('isMovement').Index].Focused = TRUE then
         begin
            Edit;
            if FieldByName('isMovement').AsBoolean = true
            then FieldByName('CountMovement').AsInteger:= 0
            else FieldByName('CountMovement').AsInteger:= 1;
            FieldByName('isMovement').AsBoolean:=not FieldByName('isMovement').AsBoolean;
            Post;
         end
         else
         if cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('isAccount').Index].Focused = TRUE then
         begin
            Edit;
            if FieldByName('isAccount').AsBoolean = true
            then FieldByName('CountAccount').AsInteger:= 0
            else FieldByName('CountAccount').AsInteger:= 1;
            FieldByName('isAccount').AsBoolean:=not FieldByName('isAccount').AsBoolean;
            Post;
         end
         else
         if cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('isTransport').Index].Focused = TRUE then
         begin
            Edit;
            if FieldByName('isTransport').AsBoolean = true
            then FieldByName('CountTransport').AsInteger:= 0
            else FieldByName('CountTransport').AsInteger:= 1;
            FieldByName('isTransport').AsBoolean:=not FieldByName('isTransport').AsBoolean;
            Post;
         end
         else
         if cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('isQuality').Index].Focused = TRUE then
         begin
            Edit;
            if FieldByName('isQuality').AsBoolean = true
            then FieldByName('CountQuality').AsInteger:= 0
            else FieldByName('CountQuality').AsInteger:= 1;
            FieldByName('isQuality').AsBoolean:=not FieldByName('isQuality').AsBoolean;
            Post;
         end
         else
         if cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('isPack').Index].Focused = TRUE then
         begin
            Edit;
            if FieldByName('isPack').AsBoolean = true
            then FieldByName('CountPack').AsInteger:= 0
            else FieldByName('CountPack').AsInteger:= 1;
            FieldByName('isPack').AsBoolean:=not FieldByName('isPack').AsBoolean;
            Post;
         end
         else
         if cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('isSpec').Index].Focused = TRUE then
         begin
            Edit;
            if FieldByName('isSpec').AsBoolean = true
            then FieldByName('CountSpec').AsInteger:= 0
            else FieldByName('CountSpec').AsInteger:= 1;
            FieldByName('isSpec').AsBoolean:=not FieldByName('isSpec').AsBoolean;
            Post;
         end
         else
         if cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('isTax').Index].Focused = TRUE then
         begin
            Edit;
            if FieldByName('isTax').AsBoolean = true
            then FieldByName('CountTax').AsInteger:= 0
            else FieldByName('CountTax').AsInteger:= 1;
            FieldByName('isTax').AsBoolean:=not FieldByName('isTax').AsBoolean;
            Post;
         end
         else begin
                    ShowMessage('Ошибка.'+#10+#13+'Для изменения необходимо установить курсор в нужную колонку');
                    exit;
         end;
         //
         DMMainScaleForm.gpUpdate_Scale_Partner_print(FieldByName('PartnerId').AsInteger
                                                     ,FieldByName('isMovement').AsBoolean
                                                     ,FieldByName('isAccount').AsBoolean
                                                     ,FieldByName('isTransport').AsBoolean
                                                     ,FieldByName('isQuality').AsBoolean
                                                     ,FieldByName('isPack').AsBoolean
                                                     ,FieldByName('isSpec').AsBoolean
                                                     ,FieldByName('isTax').AsBoolean
                                                     ,FieldByName('CountMovement').AsInteger
                                                     ,FieldByName('CountAccount').AsInteger
                                                     ,FieldByName('CountTransport').AsInteger
                                                     ,FieldByName('CountQuality').AsInteger
                                                     ,FieldByName('CountPack').AsInteger
                                                     ,FieldByName('CountSpec').AsInteger
                                                     ,FieldByName('CountTax').AsInteger);
     end;
end;
{------------------------------------------------------------------------------}
procedure TGuidePartnerForm.CDSFilterRecord(DataSet: TDataSet;var Accept: Boolean);
begin
     //
     if (fEnterPartnerCode)and(trim(EditPartnerCode.Text)<>'')and(trim(EditPartnerCode.Text)<>'0')
     then
       if  (EditPartnerCode.Text=DataSet.FieldByName('PartnerCode').AsString)
       then Accept:=true else Accept:=false;
     //
     //
     if (fEnterPartnerName)and(trim(EditPartnerName.Text)<>'')
     then
       if  (pos(AnsiUpperCase(EditPartnerName.Text),AnsiUpperCase(DataSet.FieldByName('PartnerName').AsString))>0)
       then Accept:=true else Accept:=false;

end;
{------------------------------------------------------------------------------}
function TGuidePartnerForm.Checked: boolean; //Проверка корректного ввода в Edit
begin
     Result:=(CDS.RecordCount>0);
     //
     if not Result
     then ActiveControl:=EditPartnerName
     else with ParamsMovement_local do
          begin
               ParamByName('calcPartnerId').AsInteger:= CDS.FieldByName('PartnerId').AsInteger;
               ParamByName('calcPartnerCode').AsInteger:= CDS.FieldByName('PartnerCode').AsInteger;
               ParamByName('calcPartnerName').asString:= CDS.FieldByName('PartnerName').asString;
               ParamByName('ChangePercent').asFloat:= CDS.FieldByName('ChangePercent').asFloat;
               ParamByName('ChangePercentAmount').asFloat:= CDS.FieldByName('ChangePercentAmount').asFloat;

               ParamByName('isEdiOrdspr').asBoolean:= CDS.FieldByName('isEdiOrdspr').asBoolean;
               ParamByName('isEdiInvoice').asBoolean:= CDS.FieldByName('isEdiInvoice').asBoolean;
               ParamByName('isEdiDesadv').asBoolean:= CDS.FieldByName('isEdiDesadv').asBoolean;

               ParamByName('isMovement').asBoolean:= CDS.FieldByName('isMovement').asBoolean;
               ParamByName('isAccount').asBoolean:= CDS.FieldByName('isAccount').asBoolean;
               ParamByName('isTransport').asBoolean:= CDS.FieldByName('isTransport').asBoolean;
               ParamByName('isQuality').asBoolean:= CDS.FieldByName('isQuality').asBoolean;
               ParamByName('isPack').asBoolean:= CDS.FieldByName('isPack').asBoolean;
               ParamByName('isSpec').asBoolean:= CDS.FieldByName('isSpec').asBoolean;
               ParamByName('isTax').asBoolean:= CDS.FieldByName('isTax').asBoolean;

               ParamByName('CountMovement').asInteger:= CDS.FieldByName('CountMovement').asInteger;
               ParamByName('CountAccount').asInteger:= CDS.FieldByName('CountAccount').asInteger;
               ParamByName('CountTransport').asInteger:= CDS.FieldByName('CountTransport').asInteger;
               ParamByName('CountQuality').asInteger:= CDS.FieldByName('CountQuality').asInteger;
               ParamByName('CountPack').asInteger:= CDS.FieldByName('CountPack').asInteger;
               ParamByName('CountSpec').asInteger:= CDS.FieldByName('CountSpec').asInteger;
               ParamByName('CountTax').asInteger:= CDS.FieldByName('CountTax').asInteger;

               ParamByName('PaidKindId').AsInteger:= CDS.FieldByName('PaidKindId').asInteger;
               ParamByName('PaidKindName').asString:= CDS.FieldByName('PaidKindName').asString;

               ParamByName('ContractId').AsInteger    := CDS.FieldByName('ContractId').asInteger;
               ParamByName('ContractCode').AsInteger  := CDS.FieldByName('ContractCode').asInteger;
               ParamByName('ContractNumber').asString := CDS.FieldByName('ContractNumber').asString;
               ParamByName('ContractTagName').asString:= CDS.FieldByName('ContractTagName').asString;

               // доопределяются остальные параметры
               Result:=DMMainScaleForm.gpGet_Scale_PartnerParams(ParamsMovement_local);
          end;
end;
{------------------------------------------------------------------------------}
procedure TGuidePartnerForm.EditPartnerCodeChange(Sender: TObject);
begin
     if fEnterPartnerCode then
       with CDS do begin
           //***Filtered:=false;
           //***if trim(EditPartnerCode.Text)<>'' then begin Filtered:=false;Filtered:=true;end;
           Filtered:=false;
           Filtered:=true;
       end;
end;
{------------------------------------------------------------------------------}
procedure TGuidePartnerForm.EditPartnerCodeEnter(Sender: TObject);
begin TEdit(Sender).SelectAll;
      EditPartnerName.Text:='';
      //if CDS.Filtered then CDS.Filtered:=false;
end;
{------------------------------------------------------------------------------}
procedure TGuidePartnerForm.EditPartnerCodeKeyDown(Sender: TObject;var Key: Word; Shift: TShiftState);
begin
     if(Key<>32)and(Key<>27)and(Key<>13)then
     begin
          fEnterPartnerCode:=true;
          fEnterPartnerName:=false;
          EditPartnerName.Text:='';
     end
end;
{------------------------------------------------------------------------------}
procedure TGuidePartnerForm.EditPartnerCodeKeyPress(Sender: TObject;var Key: Char);
begin if(Key=' ')or(Key='+')then Key:=#0;end;
{------------------------------------------------------------------------------}
procedure TGuidePartnerForm.EditPartnerNameChange(Sender: TObject);
begin
     if fEnterPartnerName then
       with CDS do begin
           //***Filtered:=false;
           //***if trim(EditPartnerName.Text)<>'' then begin Filtered:=false;Filtered:=true;end;
           Filtered:=false;
           Filtered:=true;
       end;
end;
{------------------------------------------------------------------------------}
procedure TGuidePartnerForm.EditPartnerNameEnter(Sender: TObject);
begin
  TEdit(Sender).SelectAll;
  EditPartnerCode.Text:='';
  //if CDS.Filtered then CDS.Filtered:=false;
end;
{------------------------------------------------------------------------------}
procedure TGuidePartnerForm.EditPartnerNameKeyDown(Sender: TObject;var Key: Word; Shift: TShiftState);
begin
     if(Key<>27)and(Key<>13)then
     begin
          fEnterPartnerCode:=false;
          fEnterPartnerName:=true;
          EditPartnerCode.Text:='';
     end
end;
{------------------------------------------------------------------------------}
procedure TGuidePartnerForm.EditPartnerNameKeyPress(Sender: TObject; var Key: Char);
begin if(Key='+')then Key:=#0;end;
{------------------------------------------------------------------------------}
procedure TGuidePartnerForm.actRefreshExecute(Sender: TObject);
var PartnerId:String;
begin
    with spSelect do begin
        PartnerId:= DataSet.FieldByName('PartnerId').AsString;
        Execute;
        if PartnerId <> '' then
          DataSet.Locate('PartnerId',PartnerId,[loCaseInsensitive]);
    end;
end;
{------------------------------------------------------------------------------}
procedure TGuidePartnerForm.actChoiceExecute(Sender: TObject);
begin
     if Checked then ModalResult:=mrOK;
end;
{------------------------------------------------------------------------------}
procedure TGuidePartnerForm.actExitExecute(Sender: TObject);
begin
     Close;
end;
{------------------------------------------------------------------------------}
procedure TGuidePartnerForm.FormCreate(Sender: TObject);
begin
  Create_ParamsMovement(ParamsMovement_local);

  with spSelect do
  begin
       StoredProcName:='gpSelect_Scale_Partner';
       Params.AddParam('inIsGoodsComplete', ftBoolean, ptInput, SettingMain.isGoodsComplete);
       Params.AddParam('inBranchCode', ftInteger, ptInput, SettingMain.BranchCode);
       OutputType:=otDataSet;
       Execute;
  end;

end;
{------------------------------------------------------------------------------}
procedure TGuidePartnerForm.FormDestroy(Sender: TObject);
begin
  ParamsMovement_local.Free;
end;
{------------------------------------------------------------------------------}
end.

