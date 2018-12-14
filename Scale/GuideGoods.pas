unit GuideGoods;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, DBTables, StdCtrls, ExtCtrls, Grids, DBGrids, Buttons,
  Datasnap.DBClient, dsdDB, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore,
  dxSkinsDefaultPainters, cxTextEdit, cxCurrencyEdit,cxStyles,
  dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage, cxDBData,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxClasses, cxGridCustomView, cxGrid, dsdAddOn, Vcl.ActnList, dsdAction
 ,UtilScale,DataModul;

type
  TGuideGoodsForm = class(TForm)
    GridPanel: TPanel;
    ParamsPanel: TPanel;
    infoPanelTare: TPanel;
    rgTareWeight: TRadioGroup;
    infoPanelPriceList: TPanel;
    rgPriceList: TRadioGroup;
    PanelTare: TPanel;
    gbTareCount: TGroupBox;
    EditTareCount: TEdit;
    gbTareWeightCode: TGroupBox;
    EditTareWeightCode: TEdit;
    gbPriceListCode: TGroupBox;
    EditPriceListCode: TEdit;
    DS: TDataSource;
    infoPanelGoods: TPanel;
    gbGoodsName: TGroupBox;
    EditGoodsName: TEdit;
    gbGoodsCode: TGroupBox;
    EditGoodsCode: TEdit;
    gbGoodsWieghtValue: TGroupBox;
    PanelGoodsWieghtValue: TPanel;
    infoPanelChangePercentAmount: TPanel;
    rgChangePercentAmount: TRadioGroup;
    gbChangePercentAmountCode: TGroupBox;
    EditChangePercentAmountCode: TEdit;
    ButtonPanel: TPanel;
    bbExit: TSpeedButton;
    bbRefresh: TSpeedButton;
    bbSave: TSpeedButton;
    infoPanelGoodsKind: TPanel;
    rgGoodsKind: TRadioGroup;
    gbGoodsKindCode: TGroupBox;
    EditGoodsKindCode: TEdit;
    gbTareWeightEnter: TGroupBox;
    EditTareWeightEnter: TEdit;
    spSelect: TdsdStoredProc;
    CDS: TClientDataSet;
    gbWeightValue: TGroupBox;
    EditWeightValue: TcxCurrencyEdit;
    cxDBGrid: TcxGrid;
    cxDBGridDBTableView: TcxGridDBTableView;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    GoodsKindName: TcxGridDBColumn;
    MeasureName: TcxGridDBColumn;
    Price: TcxGridDBColumn;
    Price_Return: TcxGridDBColumn;
    Amount_OrderWeight: TcxGridDBColumn;
    Amount_WeighingWeight: TcxGridDBColumn;
    Amount_diffWeight: TcxGridDBColumn;
    GoodsGroupNameFull: TcxGridDBColumn;
    cxDBGridLevel: TcxGridLevel;
    DBViewAddOn: TdsdDBViewAddOn;
    Color_calc: TcxGridDBColumn;
    ActionList: TActionList;
    actRefresh: TAction;
    actChoice: TAction;
    actExit: TAction;
    actSave: TAction;
    Amount_Order: TcxGridDBColumn;
    Amount_Weighing: TcxGridDBColumn;
    Amount_diff: TcxGridDBColumn;
    isPromo: TcxGridDBColumn;
    GoodsKindName_max: TcxGridDBColumn;
    GoodsKindId_list: TcxGridDBColumn;
    gbPrice: TGroupBox;
    EditPrice: TcxCurrencyEdit;
    procedure FormCreate(Sender: TObject);
    procedure EditGoodsNameEnter(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditGoodsCodeKeyPress(Sender: TObject; var Key: Char);
    procedure EditGoodsCodeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditGoodsNameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditGoodsCodeExit(Sender: TObject);
    procedure EditGoodsNameExit(Sender: TObject);
    procedure EditGoodsCodeChange(Sender: TObject);
    procedure EditGoodsNameChange(Sender: TObject);
    procedure EditTareCountKeyPress(Sender: TObject; var Key: Char);
    procedure EditTareCountExit(Sender: TObject);
    procedure EditTareWeightCodeKeyPress(Sender: TObject; var Key: Char);
    procedure EditTareWeightCodeExit(Sender: TObject);
    procedure EditChangePercentAmountCodeKeyPress(Sender: TObject; var Key: Char);
    procedure EditChangePercentAmountCodeExit(Sender: TObject);
    procedure EditTareWeightCodeChange(Sender: TObject);
    procedure EditChangePercentAmountCodeChange(Sender: TObject);
    procedure EditPriceListCodeKeyPress(Sender: TObject; var Key: Char);
    procedure EditPriceListCodeExit(Sender: TObject);
    procedure EditPriceListCodeChange(Sender: TObject);
    procedure rgTareWeightClick(Sender: TObject);
    procedure rgChangePercentAmountClick(Sender: TObject);
    procedure rgPriceListClick(Sender: TObject);
    procedure EditGoodsCodeEnter(Sender: TObject);
    procedure EditTareCountEnter(Sender: TObject);
    procedure rgGoodsKindClick(Sender: TObject);
    procedure EditGoodsKindCodeChange(Sender: TObject);
    procedure EditGoodsKindCodeExit(Sender: TObject);
    procedure EditGoodsKindCodeKeyPress(Sender: TObject; var Key: Char);
    procedure EditTareWeightEnterExit(Sender: TObject);
    procedure CDSFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure EditGoodsNameKeyPress(Sender: TObject; var Key: Char);
    procedure DSDataChange(Sender: TObject; Field: TField);
    procedure FormDestroy(Sender: TObject);
    procedure EditWeightValueExit(Sender: TObject);
    procedure EditWeightValueKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure actRefreshExecute(Sender: TObject);
    procedure actChoiceExecute(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure actSaveExecute(Sender: TObject);
    procedure gbWeightValueClick(Sender: TObject);
    procedure EditPriceKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    fCloseOK : Boolean;
    fModeSave : Boolean;
    fStartWrite : Boolean;
    fEnterGoodsCode:Boolean;
    fEnterGoodsName:Boolean;
    fEnterGoodsKindCode:Boolean;

    GoodsCode_FilterValue:String;
    GoodsName_FilterValue:String;

    procedure CancelCxFilter;
    function Checked: boolean;
    procedure InitializeGoodsKind(GoodsKindWeighingGroupId:Integer);
    procedure InitializePriceList(execParams:TParams);
  public
    //GoodsWeight:Double;
    function Execute (execParamsMovement : TParams; isModeSave : Boolean) : Boolean;
  end;

var
  GuideGoodsForm: TGuideGoodsForm;

implementation
{$R *.dfm}
uses dmMainScale, Main, DialogWeight, DialogStringValue;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.CancelCxFilter;
begin
     if cxDBGridDBTableView.DataController.Filter.Active
     then begin cxDBGridDBTableView.DataController.Filter.Clear;cxDBGridDBTableView.DataController.Filter.Active:=false;end
end;
{------------------------------------------------------------------------------}
function TGuideGoodsForm.Execute (execParamsMovement : TParams; isModeSave : Boolean) : Boolean;
begin
     fModeSave:= isModeSave;
     fCloseOK:=false;

     fEnterGoodsCode:=false;
     fEnterGoodsName:=false;
     fEnterGoodsKindCode:=false;

     gbPrice.Visible:=(GetArrayList_Value_byName(Default_Array,'isEnterPrice') = AnsiUpperCase('TRUE'))
                  and (execParamsMovement.ParamByName('MovementDescId').AsInteger = zc_Movement_Income);
     if (SettingMain.BranchCode >= 301) and (SettingMain.BranchCode <= 310) then EditWeightValue.Properties.DecimalPlaces:= 4;

     CancelCxFilter;
     fStartWrite:=true;

     if execParamsMovement.ParamByName('OrderExternalId').AsInteger<>0 then
     with spSelect do
     begin
       Self.Caption:='��������� ��������� �� ��������� '+execParamsMovement.ParamByName('OrderExternalName_master').asString;
       if isModeSave = FALSE then Self.Caption:= '��� ����������: ' + Self.Caption;
       Params.ParamByName('inOrderExternalId').Value:= execParamsMovement.ParamByName('OrderExternalId').AsInteger;
       Params.ParamByName('inMovementId').Value     := execParamsMovement.ParamByName('MovementId').AsInteger;
       Params.ParamByName('inGoodsCode').Value      := 0;
       Params.ParamByName('inGoodsName').Value      := '';
       Execute;
     end
     else
     if execParamsMovement.ParamByName('MovementDescId').AsInteger = zc_Movement_ReturnIn then
     with spSelect do
     begin
       Self.Caption:='��������� ��������� ��� ���������� <('+execParamsMovement.ParamByName('FromCode').asString + ')' + execParamsMovement.ParamByName('FromName').asString + '>';
       if isModeSave = FALSE then Self.Caption:= '��� ����������' + Self.Caption;
       Params.ParamByName('inOrderExternalId').Value:= -1 * execParamsMovement.ParamByName('ContractId').AsInteger;
       Params.ParamByName('inMovementId').Value     := -1 * execParamsMovement.ParamByName('FromId').AsInteger;
       Params.ParamByName('inGoodsCode').Value      := 0;
       Params.ParamByName('inGoodsName').Value      := '';
       Execute;
     end
     else
     if (execParamsMovement.ParamByName('MovementDescId').AsInteger = zc_Movement_Income)
     and(SettingMain.BranchCode >= 301) and (SettingMain.BranchCode <= 310)
     then
     with spSelect do
     begin
       Self.Caption:='��������� ��������� ��� ���������� <('+execParamsMovement.ParamByName('FromCode').asString + ')' + execParamsMovement.ParamByName('FromName').asString + '>';
       if isModeSave = FALSE then Self.Caption:= '��� ����������' + Self.Caption;
       Params.ParamByName('inOrderExternalId').Value:= -1 * execParamsMovement.ParamByName('ContractId').AsInteger;
       Params.ParamByName('inMovementId').Value     := -1 * execParamsMovement.ParamByName('FromId').AsInteger;
       Params.ParamByName('inGoodsCode').Value      := 0;
       Params.ParamByName('inGoodsName').Value      := '';
       Execute;
     end
     else
     if (execParamsMovement.ParamByName('MovementDescId').AsInteger = zc_Movement_Send)
     and(SettingMain.BranchCode >= 301) and (SettingMain.BranchCode <= 310)
     then
     with spSelect do
     begin
       Self.Caption:='��������� ��������� �� ������ �� <('+execParamsMovement.ParamByName('FromCode').asString + ')' + execParamsMovement.ParamByName('FromName').asString + '>';
       if isModeSave = FALSE then Self.Caption:= '��� ����������' + Self.Caption;
       Params.ParamByName('inOrderExternalId').Value:= 0;
       Params.ParamByName('inMovementId').Value     := 0;
       Params.ParamByName('inGoodsCode').Value      := 0;
       Params.ParamByName('inGoodsName').Value      := '';
       Execute;
     end
     else if isModeSave = FALSE then Self.Caption:= '��� ���������� - ��������� ���������'
     else Self.Caption:= '��������� ���������';
     ;

  // �������� ��� � ����� - �������� ��� ����� ���������
  PanelGoodsWieghtValue.Caption:=FloatToStr(ParamsMI.ParamByName('RealWeight_Get').AsFloat);

  InitializeGoodsKind(ParamsMovement.ParamByName('GoodsKindWeighingGroupId').AsInteger);
  InitializePriceList(ParamsMovement);

  cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('GoodsKindName').Index].Visible:= rgGoodsKind.Items.Count > 1; // (execParamsMovement.ParamByName('MovementDescId').AsInteger = zc_Movement_ReturnIn)or(execParamsMovement.ParamByName('OrderExternalId').AsInteger<>0);
  cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('GoodsKindName_max').Index].VisibleForCustomization:= (rgGoodsKind.Items.Count > 1) and (execParamsMovement.ParamByName('OrderExternalId').AsInteger = 0);
  cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('GoodsKindId_list').Index].VisibleForCustomization:= (rgGoodsKind.Items.Count > 1) and (execParamsMovement.ParamByName('OrderExternalId').AsInteger = 0);

  if (SettingMain.BranchCode >= 301) and (SettingMain.BranchCode <= 310) then
  begin
       cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('isPromo').Index].Visible:= false;
       cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('Price').Index].Visible:= false;
       cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('Price_Return').Index].Visible:= false;
       cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('Amount_OrderWeight').Index].Caption:= '������ (���-��)';
       cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('Amount_diffWeight').Index].Caption:= '������� (���-��)';
       if execParamsMovement.ParamByName('MovementDescId').AsInteger = zc_Movement_Income then
       begin
           cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('Amount_Weighing').Index].Caption:= '������';
           cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('Amount_WeighingWeight').Index].Caption:= '������ (���-��)';
       end
       else begin
           cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('Amount_Weighing').Index].Caption:= '������';
           cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('Amount_WeighingWeight').Index].Caption:= '������ (���-��)';
       end;
  end;

  if ParamsMI.ParamByName('GoodsId').AsInteger<>0
  then begin
            CDS.Filter:='GoodsId = '+ParamsMI.ParamByName('GoodsId').AsString;
            if (execParamsMovement.ParamByName('OrderExternalId').asInteger<>0)
               and (rgGoodsKind.Items.Count>1)
            then CDS.Filter:= CDS.Filter +' and GoodsKindId = '+IntToStr(ParamsMI.ParamByName('GoodsKindId').AsInteger)
                                         //+'   or GoodsKindId = 0)'
                                         ;

            CDS.Filtered:=false;
            CDS.Filtered:=true;

            EditGoodsCode.Text:=ParamsMI.ParamByName('GoodsCode').AsString;
            EditGoodsName.Text:='';
            EditTareWeightEnter.Text:='';

            EditWeightValue.Text:='0';
            EditPrice.Text:='0';

            if (CDS.RecordCount=1)
             and((CDS.FieldByName('MeasureId').AsInteger <> zc_Measure_Kg) 
              or ((SettingMain.BranchCode >= 301) and (SettingMain.BranchCode <= 310))
                )
            then EditTareCount.Text:= '0'
            else EditTareCount.Text:= GetArrayList_Value_byName(Default_Array,'TareCount');

            EditTareWeightCode.Text:= IntToStr(TareWeight_Array[GetArrayList_Index_byNumber(TareWeight_Array,StrToInt(GetArrayList_Value_byName(Default_Array,'TareWeightNumber')))].Code);
            EditChangePercentAmountCode.Text:= IntToStr(ChangePercentAmount_Array[GetArrayList_Index_byValue(ChangePercentAmount_Array,ParamsMovement.ParamByName('ChangePercentAmount').AsString)].Code);
            EditPriceListCode.Text:=  IntToStr(PriceList_Array[GetArrayList_Index_byNumber(PriceList_Array,StrToInt(GetArrayList_Value_byName(Default_Array,'PriceListNumber')))].Code);

            if rgGoodsKind.Items.Count>1
            then begin EditGoodsKindCode.Text:=ParamsMI.ParamByName('GoodsKindCode').AsString;
                       rgGoodsKind.ItemIndex:=GetArrayList_lpIndex_GoodsKind(GoodsKind_Array,ParamsMovement.ParamByName('GoodsKindWeighingGroupId').AsInteger,ParamsMI.ParamByName('GoodsKindCode').AsInteger);
                 end;

            {if (CDS.RecordCount=1)
            then begin
                      EditGoodsKindCode.Text:=CDS.FieldByName('GoodsKindCode').AsString;
                      ActiveControl:=EditTareCount;
            end;}

            if (CDS.RecordCount<>1) then ActiveControl:=EditGoodsCode
            else if (CDS.FieldByName('MeasureId').AsInteger <> zc_Measure_Kg)
                 or ((SettingMain.BranchCode >= 301) and (SettingMain.BranchCode <= 310))
                 then ActiveControl:=EditWeightValue
                 else ActiveControl:=EditTareCount
  end
  else begin
            EditGoodsCode.Text:='';
            EditGoodsName.Text:='';
            EditGoodsKindCode.Text:='';
            EditTareWeightEnter.Text:='';

            EditWeightValue.Text:='0';
            EditPrice.Text:='0';

            EditTareCount.Text:=         GetArrayList_Value_byName(Default_Array,'TareCount');
            EditTareWeightCode.Text:=    IntToStr(TareWeight_Array[GetArrayList_Index_byNumber(TareWeight_Array,StrToInt(GetArrayList_Value_byName(Default_Array,'TareWeightNumber')))].Code);
            EditChangePercentAmountCode.Text:= IntToStr(ChangePercentAmount_Array[GetArrayList_Index_byValue(ChangePercentAmount_Array,ParamsMovement.ParamByName('ChangePercentAmount').AsString)].Code); //IntToStr(ChangePercent_Array[GetArrayList_Index_byNumber(ChangePercent_Array,StrToInt(GetArrayList_Value_byName(Default_Array,'ChangePercentNumber')))].Code);
            EditPriceListCode.Text:=     IntToStr(PriceList_Array[GetArrayList_Index_byNumber(PriceList_Array,StrToInt(GetArrayList_Value_byName(Default_Array,'PriceListNumber')))].Code);

            //InitializeGoodsKind(ParamsMovement.ParamByName('GoodsKindWeighingGroupId').AsInteger);
            //InitializePriceList(ParamsMovement);

            CDS.Filter:='';
            CDS.Filtered:=false;
            if ParamsMovement.ParamByName('OrderExternalId').asInteger<>0 then CDS.Filtered:=true;
            ActiveControl:=EditGoodsCode;
  end;

     Application.ProcessMessages;
     Application.ProcessMessages;
     Application.ProcessMessages;
     fStartWrite:=false;

     result:=ShowModal=mrOk;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.InitializeGoodsKind(GoodsKindWeighingGroupId:Integer);
var i:Integer;
begin
     EditGoodsKindCode.Text:='';
     with rgGoodsKind do
     begin
          Items.Clear;
          i:=0;
          if GoodsKindWeighingGroupId = 0
          then begin Items.Add('(1) ���'); ItemIndex:=0;EditGoodsKindCode.Text:='1';end
          else
              for i:=0 to Length(GoodsKind_Array)-1 do
                 if GoodsKind_Array[i].Number = GoodsKindWeighingGroupId
                 then Items.Add('('+IntToStr(GoodsKind_Array[i].Code)+') '+ GoodsKind_Array[i].Name);

          if i<10 then Columns:=1 else Columns:=2;

     end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.InitializePriceList(execParams:TParams);
var i:Integer;
begin
     with rgPriceList do
     begin
          Items.Clear;
          if execParams.ParamByName('PriceListId').AsInteger=0
          then Items.Add('��� ��������')
          else Items.Add('('+IntToStr(execParams.ParamByName('PriceListCode').AsInteger)+') '+ execParams.ParamByName('PriceListName').AsString);
          EditPriceListCode.Text:=IntToStr(execParams.ParamByName('PriceListCode').AsInteger);
          rgPriceList.ItemIndex:=0;
     end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.FormKeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
var findTareCode:Integer;
begin
    if Key=13 then
    begin
      if (ActiveControl=EditGoodsCode) then EditGoodsCodeExit(EditGoodsCode);
      if (ActiveControl=EditGoodsName)and(trim (EditGoodsName.Text) <> '')
      and((SettingMain.BranchCode >= 301) and (SettingMain.BranchCode <= 310))
      then begin
                spSelect.Params.ParamByName('inGoodsCode').Value:= 0;
                spSelect.Params.ParamByName('inGoodsName').Value:= trim(EditGoodsName.Text);
                actRefreshExecute(Self);
      end;

      if (ActiveControl=EditGoodsCode)and(CDS.RecordCount=1)
      then if (CDS.FieldByName('MeasureId').AsInteger <> zc_Measure_Kg)
           or ((SettingMain.BranchCode >= 301) and (SettingMain.BranchCode <= 310))
           then ActiveControl:=EditWeightValue
           else if rgGoodsKind.Items.Count > 1  then ActiveControl:=EditGoodsKindCode else ActiveControl:=EditTareCount
      else
      if (ActiveControl=EditWeightValue)or(ActiveControl=EditPrice)
      then if (gbPrice.Visible = TRUE)and (ActiveControl<>EditPrice)
           then ActiveControl:=EditPrice
           else if rgGoodsKind.Items.Count > 1  then ActiveControl:=EditGoodsKindCode else ActiveControl:=EditTareCount
      else if (ActiveControl=EditGoodsCode)
           then if (Length(trim(EditGoodsCode.Text))>0)and(CDS.RecordCount>=1)
                then if (CDS.FieldByName('MeasureId').AsInteger <> zc_Measure_Kg)
                     or ((SettingMain.BranchCode >= 301) and (SettingMain.BranchCode <= 310))
                     then ActiveControl:=EditWeightValue
                     else if rgGoodsKind.Items.Count > 1  then ActiveControl:=EditGoodsKindCode else ActiveControl:=EditTareCount
                else ActiveControl:=EditGoodsName

           else if (ActiveControl=EditGoodsName)and(CDS.RecordCount=1)
                then if (CDS.FieldByName('MeasureId').AsInteger <> zc_Measure_Kg)
                     or ((SettingMain.BranchCode >= 301) and (SettingMain.BranchCode <= 310))
                     then ActiveControl:=EditWeightValue
                     else if rgGoodsKind.Items.Count > 1  then ActiveControl:=EditGoodsKindCode else ActiveControl:=EditTareCount

                else if (ActiveControl=EditGoodsName)
                     then if CDS.RecordCount>1 then ActiveControl:=cxDBGrid else ActiveControl:=EditGoodsCode
                     else if (ActiveControl=cxDBGrid)and(CDS.RecordCount>0)
                          then actChoiceExecute(cxDBGrid)

      else if ActiveControl=EditGoodsKindCode then ActiveControl:=EditTareCount
           else if ActiveControl=EditTareCount then ActiveControl:=EditTareWeightCode
                else if ActiveControl=EditTareWeightCode then if (rgTareWeight.ItemIndex=rgTareWeight.Items.Count-1)and(gbTareWeightEnter.Visible)
                                                        then ActiveControl:=EditTareWeightEnter
                                                        else ActiveControl:=EditChangePercentAmountCode
                     else if ActiveControl=EditTareWeightEnter then ActiveControl:=EditChangePercentAmountCode
                          else if ActiveControl=EditChangePercentAmountCode then actSaveExecute(Self) //ActiveControl:=EditPriceListCode
                               else if ActiveControl=EditPriceListCode then actSaveExecute(Self);
    end;
    //
    {if Key=32 then
      if ActiveControl=EditGoodsCode then ActiveControl:=EditGoodsName
      else if ActiveControl=EditGoodsName then ActiveControl:=EditGoodsCode;}
    //
    if (Key=27) then
      if cxDBGridDBTableView.DataController.Filter.Active
      then CancelCxFilter
      else if (fModeSave = false) or (GetArrayList_Value_byName(Default_Array,'isCheckDelete') = AnsiUpperCase('FALSE'))
             or ((ParamsMovement.ParamByName('MovementDescId').AsInteger <> zc_Movement_Sale)
              and(ParamsMovement.ParamByName('MovementDescId').AsInteger <> zc_Movement_SendOnPrice)
                )
           then actExitExecute(Self)
           else with DialogStringValueForm do
                begin
                     if not Execute (false, true) then begin ShowMessage ('��� ������ ����������� ���������� ������ ������.'); exit; end;
                     //
                     if DMMainScaleForm.gpGet_Scale_PSW_delete (StringValueEdit.Text) <> ''
                     then begin ShowMessage ('������ ��������.�������� ����������� ������.');exit;end
                     else begin fCloseOK:= true; actExitExecute(Self); end;
                end;
end;
procedure TGuideGoodsForm.gbWeightValueClick(Sender: TObject);
begin

end;

{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.CDSFilterRecord(DataSet: TDataSet;var Accept: Boolean);
var
   GoodsKindCode:Integer;
begin
     if rgGoodsKind.Items.Count=1
     then GoodsKindCode:=0
     else if (ParamsMovement.ParamByName('OrderExternalId').asInteger<>0)and(trim(EditGoodsKindCode.Text)<>'')
          then try GoodsKindCode:=StrToInt(EditGoodsKindCode.Text) except GoodsKindCode:=0;end
          else GoodsKindCode:=0;
     //
     //
     if fEnterGoodsCode
     then
       if  (EditGoodsCode.Text=DataSet.FieldByName('GoodsCode').AsString)
        and((GoodsKindCode=0)or(GoodsKindCode=DataSet.FieldByName('GoodsKindCode').AsInteger))
       then Accept:=true else Accept:=false // if DataSet.FieldByName('isTare').AsBoolean = FALSE then Accept:=true else Accept:=false
     else
         if (fEnterGoodsKindCode)and(trim(GoodsCode_FilterValue)<>'')
         then
             if  (GoodsCode_FilterValue=DataSet.FieldByName('GoodsCode').AsString)
              and((GoodsKindCode=0)or(GoodsKindCode=DataSet.FieldByName('GoodsKindCode').AsInteger))
             then Accept:=true else Accept:=false // if DataSet.FieldByName('isTare').AsBoolean = FALSE then Accept:=true else Accept:=false
         //else if DataSet.FieldByName('isTare').AsBoolean = FALSE then Accept:=true else Accept:=false
         ;
     //
     //if DataSet.FieldByName('isTare').AsBoolean = FALSE then Accept:=true else Accept:=false
     //
     if fEnterGoodsName
     then
       if  (pos(AnsiUpperCase(EditGoodsName.Text),AnsiUpperCase(DataSet.FieldByName('GoodsName').AsString))>0)
        and((GoodsKindCode=0)or(GoodsKindCode=DataSet.FieldByName('GoodsKindCode').AsInteger))
       then Accept:=true else Accept:=false // if DataSet.FieldByName('isTare').AsBoolean = FALSE then Accept:=true else Accept:=false
     else
         if (fEnterGoodsKindCode)and(trim(GoodsName_FilterValue)<>'')
         then
             if  (pos(AnsiUpperCase(GoodsName_FilterValue),AnsiUpperCase(DataSet.FieldByName('GoodsName').AsString))>0)
              and((GoodsKindCode=0)or(GoodsKindCode=DataSet.FieldByName('GoodsKindCode').AsInteger))
             then Accept:=true else Accept:=false // if DataSet.FieldByName('isTare').AsBoolean = FALSE then Accept:=true else Accept:=false
         //else if DataSet.FieldByName('isTare').AsBoolean = FALSE then Accept:=true else Accept:=false
         ;

     if (trim(EditGoodsCode.Text) = '') and (trim(EditGoodsName.Text) = '') and (ParamsMovement.ParamByName('OrderExternalId').asInteger<>0)
     then if DataSet.FieldByName('isTare').AsBoolean = FALSE then Accept:=true else Accept:=false

end;
{------------------------------------------------------------------------------}
function TGuideGoodsForm.Checked: boolean; //�������� ����������� ����� � Edit
var WeightReal_check:Double;
begin
     Result:=(CDS.RecordCount=1)
          and(rgGoodsKind.ItemIndex>=0)
          and(rgTareWeight.ItemIndex>=0)
          and(rgChangePercentAmount.ItemIndex>=0)
          and(rgPriceList.ItemIndex>=0)
          and(ParamsMI.ParamByName('RealWeight').AsFloat>0.0001)
          ;
     //
     if fModeSave = FALSE then
     begin
          Result:= false;
          ShowMessage ('������.���� ������� � ������ <������ ��������>.');
          exit;
     end;
     //
     if not Result
     then ActiveControl:=EditGoodsCode
     else
     with ParamsMI do begin
        ParamByName('GoodsId').AsInteger:=CDS.FieldByName('GoodsId').AsInteger;
        if rgGoodsKind.Items.Count > 1
        then ParamByName('GoodsKindId').AsInteger:= GoodsKind_Array[GetArrayList_gpIndex_GoodsKind(GoodsKind_Array,ParamsMovement.ParamByName('GoodsKindWeighingGroupId').AsInteger,rgGoodsKind.ItemIndex)].Id
        else ParamByName('GoodsKindId').AsInteger:= 0;

        ParamByName('MovementId_Promo').AsInteger:=CDS.FieldByName('MovementId_Promo').AsInteger;

        ParamByName('Price').AsFloat:=CDS.FieldByName('Price').AsFloat;
        ParamByName('Price_Return').AsFloat:=CDS.FieldByName('Price_Return').AsFloat;
        ParamByName('CountForPrice').AsFloat:= CDS.FieldByName('CountForPrice').AsFloat;
        ParamByName('CountForPrice_Return').AsFloat:= CDS.FieldByName('CountForPrice_Return').AsFloat;

        // ���������� ����
        try ParamByName('CountTare').AsFloat:=StrToFloat(EditTareCount.Text);
        except ParamByName('CountTare').AsFloat:=0;
        end;
        // ��� 1-�� ����
        if  (GetArrayList_Value_byName(Default_Array,'isTareWeightEnter')=AnsiUpperCase('TRUE'))
         and(gbTareWeightEnter.Visible)
         and(rgTareWeight.ItemIndex = rgTareWeight.Items.Count-1)
        then begin
            try ParamByName('WeightTare').AsFloat:=StrToFloat(EditTareWeightEnter.Text);
            except ParamByName('WeightTare').AsFloat:=0;
            end;
            //change ���������� ����
            if (ParamByName('WeightTare').AsFloat<>0) and (ParamByName('CountTare').AsFloat=0)
            then ParamByName('CountTare').AsFloat:=1;
        end
        else
            try ParamByName('WeightTare').AsFloat:=myStrToFloat(TareWeight_Array[rgTareWeight.ItemIndex].Value);
            except ParamByName('WeightTare').AsFloat:=0;
            end;
       // % ������ ��� ���-��
       if (CDS.FieldByName('ChangePercentAmount').AsFloat <> 0) and (SettingMain.isGoodsComplete = FALSE) and (ParamsMovement.ParamByName('MovementDescId').AsInteger = zc_Movement_Sale)
       then EditChangePercentAmountCode.Text:= IntToStr(ChangePercentAmount_Array[GetArrayList_Index_byValue(ChangePercentAmount_Array,FloatToStr(CDS.FieldByName('ChangePercentAmount').AsFloat))].Code)
       else if (SettingMain.isGoodsComplete = FALSE) and (ParamsMovement.ParamByName('MovementDescId').AsInteger <> zc_Movement_Sale)
            then EditChangePercentAmountCode.Text:= IntToStr(ChangePercentAmount_Array[GetArrayList_Index_byValue(ChangePercentAmount_Array,'0')].Code)
            else if (CDS.FieldByName('ChangePercentAmount').AsFloat = 0) and (SettingMain.isGoodsComplete = TRUE)
                 then EditChangePercentAmountCode.Text:= IntToStr(ChangePercentAmount_Array[GetArrayList_Index_byValue(ChangePercentAmount_Array,FloatToStr(CDS.FieldByName('ChangePercentAmount').AsFloat))].Code)
                 else EditChangePercentAmountCode.Text:= IntToStr(ChangePercentAmount_Array[GetArrayList_Index_byValue(ChangePercentAmount_Array,ParamsMovement.ParamByName('ChangePercentAmount').AsString)].Code);

       try ParamByName('ChangePercentAmount').AsFloat:=myStrToFloat(ChangePercentAmount_Array[rgChangePercentAmount.ItemIndex].Value);
       except ParamByName('ChangePercentAmount').AsFloat:=0;
       end;

       //�������� - ���������� (�����) � ������ ����
       Result:=(ParamByName('RealWeight').AsFloat-ParamByName('CountTare').AsFloat*ParamByName('WeightTare').AsFloat)>0;
       if not Result then
       begin
            ShowMessage('������.���������� �� ������� ���� �� ����� ���� ������ 0.');
            exit;
       end;

       //�������� - ���� ����
       if gbPrice.Visible then
       begin
            //!!!����� - �������� ���� ����� ���� ��������!!!
            try ParamsMI.ParamByName('BoxCount').AsFloat:= StrToFloat(EditPrice.Text);
            except
                  ParamsMI.ParamByName('BoxCount').AsFloat:= 0;
            end;
            if ParamsMI.ParamByName('BoxCount').AsFloat <=0
            then begin
                     ShowMessage('������.���� �� ����� ���� <= 0.');
                     exit;
            end;
       end;
     end;
     //
     //Save MI
     if Result = TRUE then
     begin
          //���� �� ��, �������� ������������ - �.�. ��� ����� �� ��� � ���
          if (CDS.FieldByName('MeasureId').AsInteger = zc_Measure_Kg)
         and ((SettingMain.BranchCode < 301) or (SettingMain.BranchCode > 310))
          then begin
                    //�������� ��� ���
                    WeightReal_check:=MainForm.fGetScale_CurrentWeight;
                    //���� ����� ����������� ������ 0.002
                    if abs(WeightReal_check-ParamsMI.ParamByName('RealWeight').AsFloat)> SettingMain.Exception_WeightDiff
                    then
                        with DialogWeightForm do
                        begin
                             rgWeight.Items.Add(FloatToStr(ParamsMI.ParamByName('RealWeight').AsFloat)+' ��');
                             rgWeight.Items.Add(FloatToStr(WeightReal_check)+' ��');
                             rgWeight.ItemIndex:=1;
                             if Execute then
                               if rgWeight.ItemIndex=1
                               then begin
                                         //�������� WeightReal_check - ���������� (�����) � ������ ����
                                         Result:=(WeightReal_check-ParamsMI.ParamByName('CountTare').AsFloat*ParamsMI.ParamByName('WeightTare').AsFloat)>0;
                                         if not Result then
                                         begin
                                              ShowMessage('������.���������� �� ������� ���� �� ����� ���� ������ 0.');
                                              exit;
                                         end;
                                         //!!!�������� �� ����� "����������" ���!!!
                                         ParamsMI.ParamByName('RealWeight').AsFloat:=WeightReal_check;
                                    end
                                else // ������ �� ������, ������� 1-�� �������
                             else begin Result:=FALSE; exit;end; // �� ���� ��������� ������ �� �������, �������� � �����
                        end;
          end;
          //���������� MovementItem
          Result:=DMMainScaleForm.gpInsert_Scale_MI(ParamsMovement,ParamsMI);
          if not Result then ShowMessage('Error.not Result');
          Result:=true;
     end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditGoodsCodeChange(Sender: TObject);
begin
     if fEnterGoodsCode then
       with CDS do begin
           Filtered:=false;
           if trim(EditGoodsCode.Text)<>'' then Filtered:=true
           else if ParamsMovement.ParamByName('OrderExternalId').asInteger<>0 then CDS.Filtered:=true;//!!!
       end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditGoodsCodeEnter(Sender: TObject);
begin TEdit(Sender).SelectAll;
      EditGoodsName.Text:='';
      CDS.Filtered:=false;
      if ParamsMovement.ParamByName('OrderExternalId').asInteger<>0 then CDS.Filtered:=true;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditGoodsCodeExit(Sender: TObject);
var Code_begin:Integer;
begin
      if fStartWrite=true then exit;

      try Code_begin:=StrToInt(EditGoodsCode.Text) except Code_begin:=0;end;

     {try Code_begin:=StrToInt(EditGoodsCode.Text) except Code_begin:=0;end;
     if (GoodsWeight<0.0001)//and(not((GoodsCode>=_CodeStartGoods_onEnterWeight)and(GoodsCode<=_CodeEndGoods_onEnterWeight)))
     then ActiveControl:=EditGoodsCode;
     else
         if (ActiveControl<>EditGoodsName)and((Code_begin<=0)or(Code_begin<>CDS.FieldByName('GoodsCode').AsInteger))
         then ActiveControl:=EditGoodsCode;}
     //
     if (CDS.Filtered=false)and(Length(trim(EditGoodsCode.Text))>0)
     then begin fEnterGoodsCode:=true;CDS.Filtered:=true;end;

     if  (SettingMain.isGoodsComplete = FALSE){(CDS.RecordCount=0}
      and((ParamsMovement.ParamByName('OrderExternalId').asInteger<>0)
       or ((SettingMain.BranchCode >= 301) and (SettingMain.BranchCode <= 310))
         )
      and(Code_begin>0)
     then begin spSelect.Params.ParamByName('inGoodsCode').Value:=Code_begin;
                spSelect.Params.ParamByName('inGoodsName').Value:='';
                actRefreshExecute(Self);
                fEnterGoodsCode:=true;CDS.Filtered:=False;CDS.Filtered:=True;
     end;



     if (CDS.RecordCount=0)and(trim(EditGoodsCode.Text)<>'')
     then if ParamsMovement.ParamByName('OrderExternalId').asInteger<>0
          then begin fEnterGoodsCode:=false;
                     GoodsCode_FilterValue:=EditGoodsCode.Text;
                     GoodsName_FilterValue:='';
               end
          else ActiveControl:=EditGoodsCode
     else begin fEnterGoodsCode:=false;
                GoodsCode_FilterValue:=EditGoodsCode.Text;
                GoodsName_FilterValue:='';
          end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditGoodsCodeKeyDown(Sender: TObject;var Key: Word; Shift: TShiftState);
begin
     if(Key<>32)and(Key<>27)and(Key<>13)then
     begin
          fEnterGoodsCode:=true;
          fEnterGoodsName:=false;
          EditGoodsName.Text:='';

          GoodsCode_FilterValue:=EditGoodsCode.Text;
          GoodsName_FilterValue:='';
     end
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditGoodsCodeKeyPress(Sender: TObject;var Key: Char);
begin if(Key=' ')or(Key='+')then Key:=#0;end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditGoodsNameChange(Sender: TObject);
var Code_begin:String;
begin
     if fEnterGoodsName then
       with CDS do begin
           Code_begin:= FieldByName('GoodsCode').AsString;
           Filtered:=false;
           if trim(EditGoodsName.Text)<>'' then Filtered:=true
           else if ParamsMovement.ParamByName('OrderExternalId').asInteger<>0 then CDS.Filtered:=true;//!!!
           if Code_begin <> '' then Locate('GoodsCode',Code_begin,[loCaseInsensitive,loPartialKey]);
       end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditGoodsNameEnter(Sender: TObject);
var Code_begin:String;
begin
  TEdit(Sender).SelectAll;
  EditGoodsCode.Text:='';
  CDS.Filtered:=false;
  if ParamsMovement.ParamByName('OrderExternalId').asInteger<>0 then CDS.Filtered:=true;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditGoodsNameExit(Sender: TObject);
var Code_begin:Integer;
begin
     if fStartWrite=true then exit;

     {Code_begin:=CDS.FieldByName('GoodsCode').AsInteger;
     //
     if (GoodsWeight<0.0001)//and(not((GoodsCode>=_CodeStartGoods_onEnterWeight)and(GoodsCode<=_CodeEndGoods_onEnterWeight)))
     then ActiveControl:=EditGoodsCode;
     else
        if (Code_begin<=0)and(CDS.RecordCount<=1) then ActiveControl:=EditGoodsName
        else if (Code_begin>0)and(CDS.RecordCount=1) then EditGoodsCode.Text:=IntToStr(Code_begin);}

     if (CDS.Filtered=false)and(Length(trim(EditGoodsName.Text))>0)
     then begin fEnterGoodsName:=true;CDS.Filtered:=true;end;

     if CDS.RecordCount=0
     then if ParamsMovement.ParamByName('OrderExternalId').asInteger<>0
          then begin fEnterGoodsName:=false;
                     GoodsCode_FilterValue:='';
                     GoodsName_FilterValue:=EditGoodsName.Text;
               end
          else ActiveControl:=EditGoodsName
     else begin fEnterGoodsName:=false;
                GoodsCode_FilterValue:='';
                GoodsName_FilterValue:=EditGoodsName.Text;
          end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditGoodsNameKeyDown(Sender: TObject;var Key: Word; Shift: TShiftState);
begin
     if(Key<>27)and(Key<>13)then
     begin
          fEnterGoodsCode:=false;
          fEnterGoodsName:=true;
          EditGoodsCode.Text:='';

          GoodsCode_FilterValue:='';
          GoodsName_FilterValue:=EditGoodsName.Text;
     end
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditGoodsNameKeyPress(Sender: TObject; var Key: Char);
begin if(Key='+')then Key:=#0;end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditWeightValueExit(Sender: TObject);
begin
     if (CDS.FieldByName('MeasureId').AsInteger = zc_Measure_Kg) 
    and ((SettingMain.BranchCode < 301) or (SettingMain.BranchCode > 310))
     then exit;

     try StrToFloat(EditWeightValue.Text)
     except ActiveControl:=EditWeightValue;
            exit;
     end;
     if StrToFloat(EditWeightValue.Text)<=0
     then ActiveControl:=EditWeightValue
     else if CDS.RecordCount=1
          then try ParamsMI.ParamByName('RealWeight').AsFloat:=StrToFloat(EditWeightValue.Text);
          except ParamsMI.ParamByName('RealWeight').AsFloat:=0;end;

     if gbPrice.Visible = TRUE
     then begin
               try StrToFloat(EditPrice.Text)
               except ActiveControl:=EditPrice;
                      exit;
               end;
               //
               if StrToFloat(EditPrice.Text) <= 0
               then ActiveControl:=EditPrice
     end;

end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditWeightValueKeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
begin
    if Key=13
    then if (gbPrice.Visible = TRUE)
         then ActiveControl:=EditPrice
         else if rgGoodsKind.Items.Count>1 then ActiveControl:=EditGoodsKindCode else ActiveControl:=EditTareCount;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditPriceKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
    if Key=13
    then if rgGoodsKind.Items.Count>1 then ActiveControl:=EditGoodsKindCode else ActiveControl:=EditTareCount;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditGoodsKindCodeChange(Sender: TObject);
var Code_begin:Integer;
begin
     if (fStartWrite=true) then exit;

     if rgGoodsKind.Items.Count>1
     then begin
         if trim(EditGoodsKindCode.Text)<>''
         then try Code_begin:=StrToInt(EditGoodsKindCode.Text) except Code_begin:=-1;end else Code_begin:=-1;

         if (Code_begin<=0)
         then rgGoodsKind.ItemIndex:=-1
         else rgGoodsKind.ItemIndex:=GetArrayList_lpIndex_GoodsKind(GoodsKind_Array,ParamsMovement.ParamByName('GoodsKindWeighingGroupId').AsInteger,Code_begin);
     end
     else EditGoodsKindCode.Text:='1';

    if ParamsMovement.ParamByName('OrderExternalId').asInteger<>0
    then begin CDS.Filtered:=false;CDS.Filtered:=true;end;

end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditGoodsKindCodeExit(Sender: TObject);
var GoodsKindId_check:Integer;
begin
      if (fStartWrite=true)or(ActiveControl=EditGoodsCode)or(ActiveControl=EditGoodsName)
       or(ActiveControl=cxDBGrid)or(ActiveControl=rgGoodsKind)or(ActiveControl.Name='')
      then exit;
//Focused
      if (rgGoodsKind.ItemIndex=-1)and (rgGoodsKind.Items.Count>1)
      then begin ShowMessage('������.�� ���������� �������� <��� ���� ��������>.');
                 ActiveControl:=EditGoodsKindCode;
           end
      else
        if CDS.RecordCount<>1
        then if (ParamsMovement.ParamByName('OrderExternalId').asInteger<>0) and (rgGoodsKind.Items.Count>1)
             then begin
                       ShowMessage('������.�� ���������� �������� <��� ���� ��������>.');
                       ActiveControl:=EditGoodsKindCode;
                  end
             else begin
                       ShowMessage('������.�� ������ <��� ������>.');
                       ActiveControl:=EditGoodsCode;
                  end
        else if ParamsMI.ParamByName('RealWeight').AsFloat<=0.0001
             then
                  if (CDS.FieldByName('MeasureId').AsInteger <> zc_Measure_Kg)
                  or ((SettingMain.BranchCode >= 301) and (SettingMain.BranchCode <= 310))
                  then begin ShowMessage('������.�� ���������� �������� <���� ����������>.');ActiveControl:=EditWeightValue;end
                  else begin ShowMessage('������.�� ���������� �������� <��� �� �����>.');ActiveControl:=EditGoodsCode;end;

      //
      if   (ParamsMovement.ParamByName('OrderExternalId').AsInteger = 0)
       // and (ParamsMovement.ParamByName('MovementDescId').AsInteger = zc_Movement_ReturnIn)
       and (CDS.FieldByName('GoodsKindName').AsString <> '')
       and (rgGoodsKind.Items.Count > 1)
      then begin
                GoodsKindId_check:= GoodsKind_Array[GetArrayList_gpIndex_GoodsKind(GoodsKind_Array,ParamsMovement.ParamByName('GoodsKindWeighingGroupId').AsInteger,rgGoodsKind.ItemIndex)].Id;
                if System.Pos(',' + IntToStr(GoodsKindId_check) + ',', ',' + CDS.FieldByName('GoodsKindId_list').AsString + ',') = 0
                then
                begin
                     ShowMessage('������.�������� <��� ��������> ����� ���� ������ �����: <' + CDS.FieldByName('GoodsKindName').AsString + '>.');
                     ActiveControl:=EditGoodsKindCode;
                end;
      end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditGoodsKindCodeKeyPress(Sender: TObject;var Key: Char);
var findIndex:Integer;
begin
     if rgGoodsKind.Items.Count=1 then exit;
     //
     if Key=' ' then Key:=#0;
     if Key='+' then
     begin
          Key:=#0;

          if (rgGoodsKind.ItemIndex = rgGoodsKind.Items.Count-1)or(rgGoodsKind.ItemIndex = -1)
          then findIndex:=GetArrayList_gpIndex_GoodsKind(GoodsKind_Array,ParamsMovement.ParamByName('GoodsKindWeighingGroupId').AsInteger,-1)
          else findIndex:=1+GetArrayList_gpIndex_GoodsKind(GoodsKind_Array,ParamsMovement.ParamByName('GoodsKindWeighingGroupId').AsInteger,rgGoodsKind.ItemIndex);
          //
          EditGoodsKindCode.Text:=IntToStr(GoodsKind_Array[findIndex].Code);
          TEdit(Sender).SelectAll;
     end;

     fEnterGoodsKindCode:=ParamsMovement.ParamByName('OrderExternalId').AsInteger<>0;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.rgGoodsKindClick(Sender: TObject);
var findIndex:Integer;
    fStartWrite_old:Boolean;
begin
    if rgGoodsKind.Items.Count=1 then exit;
    //
    findIndex:=GetArrayList_gpIndex_GoodsKind(GoodsKind_Array,ParamsMovement.ParamByName('GoodsKindWeighingGroupId').AsInteger,rgGoodsKind.ItemIndex);
    fStartWrite_old:= fStartWrite;
    fStartWrite:=true;
    EditGoodsKindCode.Text:=IntToStr(GoodsKind_Array[findIndex].Code);
    if ActiveControl <> cxDBGrid then ActiveControl:=EditGoodsKindCode;
    fStartWrite:=fStartWrite_old;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditTareCountEnter(Sender: TObject);
var Key:Word;
begin
      TEdit(Sender).SelectAll;
      Key:=13;
      //
      //if (ActiveControl=EditTareCount)and(GBUpak.Visible)
      //then begin
      //          PanelUpak.Caption:=GetStringValue('select zf_MyRound0(zf_CalcDivisionNoRound('+FormatToFloatServer(GoodsWeight)+',GoodsProperty_Detail.Ves_onUpakovka))as RetV from dba.GoodsProperty join dba.KindPackage on KindPackage.KindPackageCode = '+trim(EditKindPackageCode.Text)+' join dba.GoodsProperty_Detail on GoodsProperty_Detail.GoodsPropertyId=GoodsProperty.Id and GoodsProperty_Detail.KindPackageID=KindPackage.Id where GoodsProperty.GoodsCode = '+trim(EditGoodsCode.Text));
      //end;
      //
      if (ActiveControl=EditGoodsKindCode)or(ActiveControl=EditTareCount)
      then begin
           if CDS.FieldByName('ChangePercentAmount').AsFloat=0
           then EditChangePercentAmountCode.Text:= IntToStr(ChangePercentAmount_Array[GetArrayList_Index_byValue(ChangePercentAmount_Array,FloatToStr(CDS.FieldByName('ChangePercentAmount').AsFloat))].Code)
           else EditChangePercentAmountCode.Text:= IntToStr(ChangePercentAmount_Array[GetArrayList_Index_byValue(ChangePercentAmount_Array,ParamsMovement.ParamByName('ChangePercentAmount').AsString)].Code);
      end;
      if (ActiveControl=EditGoodsKindCode)
      then begin
           if rgGoodsKind.Items.Count=1 then begin ActiveControl:=EditTareCount;exit;end;
           //
           ActiveControl:=EditGoodsKindCode;
           //
           if (ParamsMovement.ParamByName('OrderExternalId').AsInteger<>0)and(CDS.RecordCount=1)
           then begin
                     fEnterGoodsKindCode:=true;
                     EditGoodsKindCode.Text:=CDS.FieldByName('GoodsKindCode').AsString;
                     //ActiveControl:=EditTareCount;
           end;
           //
           if   (ParamsMovement.ParamByName('OrderExternalId').AsInteger = 0)
            //and (ParamsMovement.ParamByName('MovementDescId').AsInteger = zc_Movement_ReturnIn)
            and (CDS.FieldByName('GoodsKindCode_max').AsInteger <> 0)
            and (fStartWrite = false)
            and (rgGoodsKind.ItemIndex = -1)
           then begin
                     EditGoodsKindCode.Text:=CDS.FieldByName('GoodsKindCode_max').AsString;
                     TEdit(Sender).SelectAll;
           end;
            //
           exit;
      end;

      if (ActiveControl=EditGoodsKindCode)and(rgGoodsKind.ItemIndex>=0)and(rgGoodsKind.Items.Count=1)then begin rgGoodsKind.ItemIndex:=0;FormKeyDown(Sender,Key,[]);exit;end;
      if (ActiveControl=EditTareCount) and ((CDS.FieldByName('MeasureId').AsInteger <> zc_Measure_Kg) or ((SettingMain.BranchCode >= 301) and (SettingMain.BranchCode <= 310))) then begin EditTareCount.Text:='0';FormKeyDown(Sender,Key,[]);exit;end;
      if (ActiveControl=EditTareWeightCode) and ((CDS.FieldByName('MeasureId').AsInteger <> zc_Measure_Kg) or ((SettingMain.BranchCode >= 301) and (SettingMain.BranchCode <= 310))) then begin FormKeyDown(Sender,Key,[]);exit;end;
      if (ActiveControl=EditTareWeightEnter) and ((CDS.FieldByName('MeasureId').AsInteger <> zc_Measure_Kg) or ((SettingMain.BranchCode >= 301) and (SettingMain.BranchCode <= 310))) then begin FormKeyDown(Sender,Key,[]);exit;end;
      if (ActiveControl=EditChangePercentAmountCode)then begin FormKeyDown(Sender,Key,[]);exit;end;
      if (ActiveControl=EditPriceListCode){and(rgPriceList.ItemIndex>=0)and(rgPriceList.Items.Count=1)}then begin FormKeyDown(Sender,Key,[]);exit;end;
      //
      if (ActiveControl=EditTareWeightEnter)and(rgTareWeight.ItemIndex<>rgTareWeight.Items.Count-1)
      then begin FormKeyDown(Sender,Key,[]);exit;end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditTareCountExit(Sender: TObject);
var TareCount:Integer;
begin
     if fStartWrite=true then exit;

     try TareCount:=StrToInt(trim(EditTareCount.Text));except TareCount:=0;end;
     //
     if (TareCount>Length(TareCount_Array))
     then ActiveControl:=EditTareCount;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditTareCountKeyPress(Sender: TObject;var Key: Char);
var Code_begin:Integer;
begin
     if Key=' ' then Key:=#0;
     if Key='+' then
     begin
          Key:=#0;
          //
          try Code_begin:=StrToInt(trim(EditTareCount.Text));except Code_begin:=0;end;
          //
          if Code_begin>=Length(TareCount_Array) then EditTareCount.Text:= '0' else EditTareCount.Text:= IntToStr(Code_begin+1);
          //
          TEdit(Sender).SelectAll;
     end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditTareWeightCodeChange(Sender: TObject);
var Code_begin:Integer;
begin
     try Code_begin:=StrToInt(EditTareWeightCode.Text) except Code_begin:=-1;end;
     if (Code_begin<0)
     then rgTareWeight.ItemIndex:=-1
     else rgTareWeight.ItemIndex:=GetArrayList_Index_byCode(TareWeight_Array,Code_begin);
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditTareWeightCodeExit(Sender: TObject);
begin
     if fStartWrite=true then exit;

     if rgTareWeight.ItemIndex=-1 then ActiveControl:=EditTareWeightCode;
     if (rgTareWeight.ItemIndex <> rgTareWeight.Items.Count-1)and(gbTareWeightEnter.Visible)
     then EditTareWeightEnter.Text:='';
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditTareWeightCodeKeyPress(Sender: TObject;var Key: Char);
var findIndex:Integer;
begin
     if Key=' ' then Key:=#0;
     if Key='+' then
     begin
          Key:=#0;
          //
          if (rgTareWeight.ItemIndex = rgTareWeight.Items.Count-1)or(rgTareWeight.ItemIndex = -1)
          then findIndex:=0
          else findIndex:=1+rgTareWeight.ItemIndex;
          //
          EditTareWeightCode.Text:=IntToStr(TareWeight_Array[findIndex].Code);
          TEdit(Sender).SelectAll;
     end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.rgTareWeightClick(Sender: TObject);
begin
    EditTareWeightCode.Text:=IntToStr(TareWeight_Array[rgTareWeight.ItemIndex].Code);
    ActiveControl:=EditTareWeightCode;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditTareWeightEnterExit(Sender: TObject);
var TareWeight:Double;
begin
     if fStartWrite=true then exit;

     if trim (EditTareWeightEnter.Text)='' then EditTareWeightEnter.Text:='0';
     //
     try TareWeight:=StrToFloat(trim(EditTareWeightEnter.Text));except TareWeight:=-1;end;
     //
     if TareWeight<0
     then ActiveControl:=EditTareWeightEnter;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditChangePercentAmountCodeChange(Sender: TObject);
var Code_begin:Integer;
begin
     try Code_begin:=StrToInt(EditChangePercentAmountCode.Text) except Code_begin:=-1;end;
     if (Code_begin<0)
     then rgChangePercentAmount.ItemIndex:=-1
     else rgChangePercentAmount.ItemIndex:=GetArrayList_Index_byCode(ChangePercentAmount_Array,Code_begin);
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditChangePercentAmountCodeExit(Sender: TObject);
begin
     if fStartWrite=true then exit;

     if rgChangePercentAmount.ItemIndex=-1 then ActiveControl:=EditChangePercentAmountCode;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditChangePercentAmountCodeKeyPress(Sender: TObject;var Key: Char);
var findIndex:Integer;
begin
     if Key=' ' then Key:=#0;
     if Key='+' then
     begin
          Key:=#0;
          //
          if (rgChangePercentAmount.ItemIndex = rgChangePercentAmount.Items.Count-1)or(rgChangePercentAmount.ItemIndex = -1)
          then findIndex:=0
          else findIndex:=1+rgChangePercentAmount.ItemIndex;
          //
          EditChangePercentAmountCode.Text:=IntToStr(ChangePercentAmount_Array[findIndex].Code);
          TEdit(Sender).SelectAll;
     end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.rgChangePercentAmountClick(Sender: TObject);
var newValue:String;
begin
    EditChangePercentAmountCodeChange(EditChangePercentAmountCode);
    // ActiveControl:=EditGoodsCode;
    {newValue:=IntToStr(ChangePercent_Array[rgChangePercent.ItemIndex].Code);
    if newValue<>EditChangePercentCode.Text
    then begin
              EditChangePercentCode.Text:=newValue;
              ActiveControl:=EditChangePercentCode;
    end;}

end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditPriceListCodeChange(Sender: TObject);
var Code_begin:Integer;
begin
{     try Code_begin:=StrToInt(EditPriceListCode.Text) except Code_begin:=-1;end;
     if (Code_begin<0)
     then rgPriceList.ItemIndex:=-1
     else rgPriceList.ItemIndex:=1;//GetArrayList_Index_byCode(PriceList_Array,Code_begin);
     }
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditPriceListCodeExit(Sender: TObject);
begin
     if fStartWrite=true then exit;
     {if rgPriceList.ItemIndex=-1 then ActiveControl:=EditPriceListCode;}
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditPriceListCodeKeyPress(Sender: TObject;var Key: Char);
var findIndex:Integer;
begin
     {if Key=' ' then Key:=#0;
     if Key='+' then
     begin
          Key:=#0;
          //
          if (rgPriceList.ItemIndex = rgPriceList.Items.Count-1)or(rgPriceList.ItemIndex = -1)
          then findIndex:=0
          else findIndex:=1+rgPriceList.ItemIndex;
          //
          EditPriceListCode.Text:=IntToStr(PriceList_Array[findIndex].Code);
          TEdit(Sender).SelectAll;
     end;}
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.rgPriceListClick(Sender: TObject);
begin
    {EditPriceListCodeChange(EditPriceListCode);}
    if ActiveControl=rgPriceList then ActiveControl:=EditGoodsCode;
    {EditPriceListCode.Text:=IntToStr(PriceList_Array[rgPriceList.ItemIndex].Code);
    ActiveControl:=EditPriceListCode;}
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.DSDataChange(Sender: TObject; Field: TField);
begin
     with ParamsMI do begin
        if CDS.RecordCount=1 then
         if (CDS.FieldByName('MeasureId').AsInteger <> zc_Measure_Kg) or ((SettingMain.BranchCode >= 301) and (SettingMain.BranchCode <= 310))
         then try ParamByName('RealWeight').AsFloat:=StrToFloat(EditWeightValue.Text); except ParamByName('RealWeight').AsFloat:=0;end
         else ParamByName('RealWeight').AsFloat:=ParamByName('RealWeight_Get').AsFloat
        else
            ParamByName('RealWeight').AsFloat:=0;
     end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.DBGridDrawColumnCell(Sender: TObject;const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
{     if (AnsiUpperCase(Column.Field.FieldName)=AnsiUpperCase('Amount_diff'))
       and((CDS.FieldByName('Amount_diff').AsFloat>0)or(CDS.FieldByName('isTax_diff').AsBoolean = true))
     then
     with (Sender as TDBGrid).Canvas do
     begin
          if CDS.FieldByName('isTax_diff').AsBoolean = true then Font.Color:=clBlue;
          if CDS.FieldByName('Amount_diff').AsFloat > 0 then Font.Color:=clRed;

          FillRect(Rect);
          if (Column.Alignment=taLeftJustify)or(Rect.Left>=Rect.Right - LengTh(Column.Field.Text))
          then TextOut(Rect.Left+2, Rect.Top+2, Column.Field.Text)
          else TextOut(Rect.Right - TextWidth(Column.Field.Text) - 2, Rect.Top+2 , Column.Field.Text);
     end;}
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.actRefreshExecute(Sender: TObject);
var GoodsCode:String;
begin
    with spSelect do begin
        GoodsCode:= DataSet.FieldByName('GoodsCode').AsString;
        Execute;
        if GoodsCode <> '' then
          DataSet.Locate('GoodsCode',GoodsCode,[loCaseInsensitive]);
    end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.actChoiceExecute(Sender: TObject);
begin
     if CDS.FieldByName('GoodsCode').AsString <> '0'
     then begin EditGoodsCode.Text:=CDS.FieldByName('GoodsCode').AsString;
                fEnterGoodsCode:= true;
                fEnterGoodsName:= false;
                if (SettingMain.BranchCode >= 301) and (SettingMain.BranchCode <= 310)
                then EditGoodsCodeChange(EditGoodsCode); // EditGoodsCodeExit(EditGoodsCode);
          end
     else if ((SettingMain.BranchCode >= 301) and (SettingMain.BranchCode <= 310))
          then begin
                EditGoodsName.Text:=CDS.FieldByName('GoodsName').AsString;
                fEnterGoodsCode:= false;
                fEnterGoodsName:= true;
                EditGoodsNameChange(EditGoodsName) // EditGoodsNameExit(EditGoodsName);
          end;

     if (ParamsMovement.ParamByName('OrderExternalId').asInteger=0)
     then if ((SettingMain.BranchCode < 301) or (SettingMain.BranchCode > 310))
          then EditGoodsCodeChange(EditGoodsCode)
          else
     else begin
               fEnterGoodsKindCode:=true;
               if rgGoodsKind.Items.Count>1
               then EditGoodsKindCode.Text:=CDS.FieldByName('GoodsKindCode').AsString;
               EditGoodsKindCodeChange(EditGoodsKindCode);
          end;
     //
     if (CDS.FieldByName('MeasureId').AsInteger <> zc_Measure_Kg) or ((SettingMain.BranchCode >= 301) and (SettingMain.BranchCode <= 310))
     then ActiveControl:=EditWeightValue
     else if (ParamsMovement.ParamByName('OrderExternalId').asInteger=0)and(rgGoodsKind.Items.Count>1)
          then ActiveControl:=EditGoodsKindCode
          else ActiveControl:=EditTareCount;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.actExitExecute(Sender: TObject);
begin Close;end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.actSaveExecute(Sender: TObject);
begin
     if Checked then begin fCloseOK:=true; Close; ModalResult:= mrOK; end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.FormCloseQuery(Sender: TObject;  var CanClose: Boolean);
begin
     CanClose:=false;
           if (fModeSave = false) or (GetArrayList_Value_byName(Default_Array,'isCheckDelete') = AnsiUpperCase('FALSE'))
             or ((ParamsMovement.ParamByName('MovementDescId').AsInteger <> zc_Movement_Sale)
              and(ParamsMovement.ParamByName('MovementDescId').AsInteger <> zc_Movement_SendOnPrice)
                )
             or (fCloseOK = true)
           then CanClose:=true
           else with DialogStringValueForm do
                begin
                     if not Execute (false, true) then begin ShowMessage ('��� ������ ����������� ���������� ������ ������.'); exit; end;
                     //
                     if DMMainScaleForm.gpGet_Scale_PSW_delete (StringValueEdit.Text) <> ''
                     then begin ShowMessage ('������ ��������.�������� ����������� ������.');exit;end
                     else CanClose:=true;
                end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.FormCreate(Sender: TObject);
var i:Integer;
begin
  fStartWrite:=true;

  //��� ���� (������ �����)
  gbTareWeightEnter.Visible:=GetArrayList_Value_byName(Default_Array,'isTareWeightEnter')=AnsiUpperCase('TRUE');
  //��� ����
  for i := 0 to Length(TareWeight_Array)-1 do
    if TareWeight_Array[i].Number>=1000
    then rgTareWeight.Items.Add('('+IntToStr(0)+') '+ TareWeight_Array[i].Name)
    else rgTareWeight.Items.Add('('+IntToStr(TareWeight_Array[i].Code)+') '+ TareWeight_Array[i].Name);
  //������ �� ����
  for i := 0 to Length(ChangePercentAmount_Array)-1 do
    rgChangePercentAmount.Items.Add('('+IntToStr(ChangePercentAmount_Array[i].Code)+') '+ ChangePercentAmount_Array[i].Name);
  rgChangePercentAmount.Columns:=Length(ChangePercentAmount_Array);
  //�����-����
  {for i := 0 to Length(PriceList_Array)-1 do
    rgPriceList.Items.Add('('+IntToStr(PriceList_Array[i].Code)+') '+ PriceList_Array[i].Name);}

  with spSelect do
  begin
       StoredProcName:='gpSelect_Scale_Goods';
       OutputType:=otDataSet;
       Params.AddParam('inIsGoodsComplete', ftBoolean, ptInput, SettingMain.isGoodsComplete);
       Params.AddParam('inOperDate', ftDateTime, ptInput, ParamsMovement.ParamByName('OperDate').AsDateTime);
       if Self.Tag < 0
       then Params.AddParam('inMovementId', ftInteger, ptInput, Self.Tag)
       else Params.AddParam('inMovementId', ftInteger, ptInput, 0);
       Params.AddParam('inOrderExternalId', ftInteger, ptInput, 0);
       Params.AddParam('inPriceListId', ftInteger, ptInput, 0);
       Params.AddParam('inGoodsCode', ftInteger, ptInput, 0);
       Params.AddParam('inGoodsName', ftString, ptInput, '');
       Params.AddParam('inDayPrior_PriceReturn', ftInteger, ptInput,GetArrayList_Value_byName(Default_Array,'DayPrior_PriceReturn'));
       Params.AddParam('inBranchCode', ftInteger, ptInput, SettingMain.BranchCode);
       Execute;
  end;
  //
{
     // PriceList
     if _isCalcPriceList=zc_rvYes
     then begin
            rgKindPackage.Columns:=2;
            rgPriceList.Columns:=1;
            PriceListPanel.Width:=PriceListPanel.Width-100;
            EditPriceListCode.Width:=EditPriceListCode.Width-100;
            KindPackagePanel.Width:=KindPackagePanel.Width+100;
            rgPriceList.Items.Add('(1) '+_PriceListName_byCalc_new);
            rgPriceList.Items.Add('(2) '+_PriceListName_byCalc_old);
          end
     else
         for i:=0 to ParamsPriceList.Count-1 do
            rgPriceList.Items.Add('('+IntToStr(i+1)+') '+GetStringValue('select PriceListName AS RetV from dba.PriceList_byHistory where Id = '+ParamsPriceList.Items[i].AsString));
}
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.FormDestroy(Sender: TObject);
begin
  if Assigned (ParamsMI) then begin ParamsMI.Free;ParamsMI:=nil;end;
  if Assigned (ParamsMovement) then begin ParamsMovement.Free;ParamsMovement:=nil;end;
end;
{------------------------------------------------------------------------------}
end.
