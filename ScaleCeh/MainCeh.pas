unit MainCeh;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Menus, Data.DB,
  Bde.DBTables, Vcl.Mask, Vcl.StdCtrls, Vcl.Buttons, Vcl.Grids,
  Vcl.DBGrids, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils,
  cxTextEdit, cxMaskEdit, cxDropDownEdit,
  cxCalendar, dsdDB, Datasnap.DBClient, dxSkinsCore,
  dxSkinsDefaultPainters
 ,SysScalesLib_TLB,AxLibLib_TLB
 ,UtilScale,DataModul, cxStyles, dxSkinscxPCPainter, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxDBData, dsdAddOn, cxGridLevel, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxClasses, cxGridCustomView, cxGrid,
  cxCurrencyEdit, Vcl.ActnList, cxButtonEdit, dsdAction;

type
  TMainCehForm = class(TForm)
    GridPanel: TPanel;
    ButtonPanel: TPanel;
    bbDeleteItem: TSpeedButton;
    bbExit: TSpeedButton;
    bbRefresh: TSpeedButton;
    bbExportToEDI: TSpeedButton;
    infoPanelTotalSumm: TPanel;
    gbWeightTare: TGroupBox;
    PanelWeightTare: TPanel;
    gbWeightOther: TGroupBox;
    PanelWeightOther: TPanel;
    gbRealWeight: TGroupBox;
    PanelRealWeight: TPanel;
    gbCountSkewer: TGroupBox;
    PanelCountSkewer: TPanel;
    PanelSaveItem: TPanel;
    infoPanel_Scale: TPanel;
    ScaleLabel: TLabel;
    PanelWeight_Scale: TPanel;
    PanelInfoItem: TPanel;
    PanelProduction_Goods: TPanel;
    LabelProduction_Goods: TLabel;
    GBProduction_GoodsCode: TGroupBox;
    PanelProduction_GoodsCode: TPanel;
    EditProduction_GoodsCode: TEdit;
    GBProduction_Goods_Weight: TGroupBox;
    PanelProduction_Goods_Weight: TPanel;
    GBProduction_GoodsName: TGroupBox;
    PanelProduction_GoodsName: TPanel;
    PanelTare_Goods: TPanel;
    LabelTare_Goods: TLabel;
    GBTare_GoodsCode: TGroupBox;
    PanelTare_GoodsCode: TPanel;
    GBTare_Goods_Weight: TGroupBox;
    PanelTare_Goods_Weight: TPanel;
    GBTare_GoodsName: TGroupBox;
    PanelTare_GoodsName: TPanel;
    gbTare_Goods_Count: TGroupBox;
    PanelTare_Goods_Count: TPanel;
    PanelSpace1: TPanel;
    PanelSpace2: TPanel;
    infoPanelTotalWeight: TPanel;
    GBTotalWeight: TGroupBox;
    PanelTotalWeight: TPanel;
    GBDiscountWeight: TGroupBox;
    PanelDiscountWeight: TPanel;
    infoPanel_mastre: TPanel;
    PanelMovement: TPanel;
    PanelMovementDesc: TPanel;
    PopupMenu: TPopupMenu;
    miPrintZakazMinus: TMenuItem;
    miPrintZakazAll: TMenuItem;
    miLine11: TMenuItem;
    miPrintBill_byInvNumber: TMenuItem;
    miPrintBill_andNaliog_byInvNumber: TMenuItem;
    miPrintBillTotal_byClient: TMenuItem;
    miPrintBillTotal_byFozzi: TMenuItem;
    miLine12: TMenuItem;
    miPrintSchet_byInvNumber: TMenuItem;
    miPrintBillTransport_byInvNumber: TMenuItem;
    miPrintBillTransportNew_byInvNumber: TMenuItem;
    miPrintBillKachestvo_byInvNumber: TMenuItem;
    miPrintBillNumberTare_byInvNumber: TMenuItem;
    miPrintBillNotice_byInvNumber: TMenuItem;
    miLine13: TMenuItem;
    miPrintSaleAll: TMenuItem;
    miPrint_Report_byTare: TMenuItem;
    miPrint_Report_byMemberProduction: TMenuItem;
    miLine14: TMenuItem;
    miScaleIni_DB: TMenuItem;
    miScaleIni_BI: TMenuItem;
    miScaleIni_Zeus: TMenuItem;
    miScaleIni_BI_R: TMenuItem;
    miLine15: TMenuItem;
    miScaleRun_DB: TMenuItem;
    miScaleRun_BI: TMenuItem;
    miScaleRun_Zeus: TMenuItem;
    miScaleRun_BI_R: TMenuItem;
    spSelect: TdsdStoredProc;
    DS: TDataSource;
    CDS: TClientDataSet;
    gbAmountWeight: TGroupBox;
    PanelAmountWeight: TPanel;
    rgScale: TRadioGroup;
    bbChoice_UnComlete: TSpeedButton;
    bbView_all: TSpeedButton;
    cxDBGrid: TcxGrid;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    GoodsKindName: TcxGridDBColumn;
    MeasureName: TcxGridDBColumn;
    PartionGoods: TcxGridDBColumn;
    PartionGoodsDate: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    RealWeight: TcxGridDBColumn;
    WeightTare: TcxGridDBColumn;
    InsertDate: TcxGridDBColumn;
    UpdateDate: TcxGridDBColumn;
    cxDBGridDBTableView: TcxGridDBTableView;
    cxDBGridLevel: TcxGridLevel;
    DBViewAddOn: TdsdDBViewAddOn;
    isErased: TcxGridDBColumn;
    Count: TcxGridDBColumn;
    bbChangeCount: TSpeedButton;
    bbChangeLiveWeight: TSpeedButton;
    HeadCount: TcxGridDBColumn;
    ActionList: TActionList;
    actRefresh: TAction;
    actExit: TAction;
    PanelInfo: TPanel;
    PanelGoods: TPanel;
    LabelGoods: TLabel;
    PanelGoodsKind: TPanel;
    LabelGoodsKind: TLabel;
    PanelGoodsKindCode: TPanel;
    EditGoodsKindCode: TcxCurrencyEdit;
    Panel3: TPanel;
    PanelGoodsCode: TPanel;
    LabelGoodsCode: TLabel;
    EditGoodsCode: TcxCurrencyEdit;
    infoPanelGoodsWeight: TPanel;
    LabelGoodsWeight: TLabel;
    PanelGoodsWeight: TPanel;
    rgGoodsKind: TRadioGroup;
    PanelPartionGoods: TPanel;
    LabelPartionGoods: TLabel;
    EditPartionGoods: TEdit;
    infoPanelCount: TPanel;
    LabelCount_all: TLabel;
    PanelCount: TPanel;
    LabelCount: TLabel;
    EditCount: TcxCurrencyEdit;
    PanelLiveWeight: TPanel;
    LabelCountPack: TLabel;
    EditCountPack: TcxCurrencyEdit;
    infoPanelSkewer2: TPanel;
    PanelSkewer2: TPanel;
    LabelSkewer2: TLabel;
    EditSkewer2: TcxCurrencyEdit;
    infoPanelWeightSkewer2: TPanel;
    LabelWeightSkewer2: TLabel;
    PanelWeightSkewer2: TPanel;
    infoPanelTare_enter: TPanel;
    LabelTare_enter_all: TLabel;
    infoPanelWeightTare_enter: TPanel;
    LabelWeightTare_enter: TLabel;
    EditWeightTare_enter: TcxCurrencyEdit;
    infoPanelWeightTare_enter_two: TPanel;
    LabelWeightTare_enter_two: TLabel;
    PanelWeightTare_enter_two: TPanel;
    PanelGoodsName: TPanel;
    infoPanelSkewer1: TPanel;
    LabelSkewer: TLabel;
    PanelSkewer1: TPanel;
    LabelSkewer1: TLabel;
    EditSkewer1: TcxCurrencyEdit;
    infoPanelWeightSkewer1: TPanel;
    LabelWeightSkewer1: TLabel;
    PanelWeightSkewer1: TPanel;
    infoPanelWeightOther: TPanel;
    LabelWeightOther: TLabel;
    EditWeightOther: TcxCurrencyEdit;
    infoPanel_Weight: TPanel;
    Label_Weight: TLabel;
    Panel_Weight: TPanel;
    Panel25: TPanel;
    Label17: TLabel;
    OperDateEdit: TcxDateEdit;
    PanelPartionDate: TPanel;
    LabelPartionDate: TLabel;
    PartionDateEdit: TcxDateEdit;
    CountSkewer1: TcxGridDBColumn;
    CountSkewer2: TcxGridDBColumn;
    CountSkewer1_k: TcxGridDBColumn;
    WeightSkewer1: TcxGridDBColumn;
    WeightSkewer2: TcxGridDBColumn;
    WeightSkewer1_k: TcxGridDBColumn;
    TotalWeightSkewer1: TcxGridDBColumn;
    TotalWeightSkewer2: TcxGridDBColumn;
    TotalWeightSkewer1_k: TcxGridDBColumn;
    WeightOther: TcxGridDBColumn;
    LiveWeight: TcxGridDBColumn;
    isStartWeighing: TcxGridDBColumn;
    gbStartWeighing: TRadioGroup;
    HeadCountPanel: TPanel;
    HeadCountLabel: TLabel;
    EditEnterCount: TcxCurrencyEdit;
    CountPack: TcxGridDBColumn;
    bbChangeCountPack: TSpeedButton;
    bbChangeHeadCount: TSpeedButton;
    bbChangePartionGoods: TSpeedButton;
    bbChangePartionGoodsDate: TSpeedButton;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure PanelWeight_ScaleDblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CDSAfterOpen(DataSet: TDataSet);
    procedure bbDeleteItemClick(Sender: TObject);
    procedure rgScaleClick(Sender: TObject);
    procedure bbChoice_UnComleteClick(Sender: TObject);
    procedure bbView_allClick(Sender: TObject);
    procedure bbChangeCountClick(Sender: TObject);
    procedure bbChangeHeadCountClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure EditPartionGoodsExit(Sender: TObject);
    procedure actRefreshExecute(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure EditGoodsCodeExit(Sender: TObject);
    procedure gbStartWeighingClick(Sender: TObject);
    procedure EditWeightTare_enterPropertiesChange(Sender: TObject);
    procedure EditSkewer1PropertiesChange(Sender: TObject);
    procedure EditSkewer2PropertiesChange(Sender: TObject);
    procedure EditGoodsCodeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditGoodsKindCodeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditCountKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditCountPackKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditWeightTare_enterKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditPartionGoodsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditSkewer1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditSkewer2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditWeightOtherKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditEnterCountKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure gbStartWeighingEnter(Sender: TObject);
    procedure EditGoodsKindCodePropertiesChange(Sender: TObject);
    procedure rgGoodsKindClick(Sender: TObject);
    procedure EditGoodsKindCodeExit(Sender: TObject);
    procedure EditCountPropertiesChange(Sender: TObject);
    procedure bbChangeCountPackClick(Sender: TObject);
    procedure EditCountPackPropertiesChange(Sender: TObject);
    procedure EditEnterCountPropertiesChange(Sender: TObject);
    procedure EditWeightOtherPropertiesChange(Sender: TObject);
    procedure EditEnterCountEnter(Sender: TObject);
    procedure EditWeightTare_enterExit(Sender: TObject);
    procedure EditSkewer1Exit(Sender: TObject);
    procedure EditSkewer2Exit(Sender: TObject);
    procedure EditWeightOtherExit(Sender: TObject);
    procedure EditEnterCountExit(Sender: TObject);
    procedure bbChangeLiveWeightClick(Sender: TObject);
    procedure bbChangePartionGoodsClick(Sender: TObject);
    procedure bbChangePartionGoodsDateClick(Sender: TObject);
    procedure EditPartionGoodsEnter(Sender: TObject);
  private
    oldGoodsId:Integer;

    Scale_BI: TCasBI;
    Scale_DB: TCasDB;
    Scale_Zeus: TZeus;

    function Save_Movement_all:Boolean;
    function Save_MI:Boolean;
    function Print_Movement_afterSave:Boolean;
    function GetParams_MovementDesc(BarCode: String):Boolean;
    procedure Create_Scale;
    procedure Initialize_Scale;
    procedure RefreshDataSet;
    procedure WriteParamsMovement;
    procedure Initialize_afterSave_all;
    procedure Initialize_afterSave_MI;

    procedure SetParams_OperCount;
    procedure myActiveControl;

    function fGetScale_CurrentWeight:Double;
    function GetOldRealWeight:Double;
  public
    procedure InitializeGoodsKind(GoodsKindWeighingGroupId:Integer);
  end;

var
  MainCehForm: TMainCehForm;


implementation
{$R *.dfm}
uses UnilWin,DMMainScaleCeh, DMMainScale, UtilConst, DialogMovementDesc, UtilPrint
    ,GuideMovementCeh, DialogNumberValue, DialogStringValue, DialogDateValue, DialogPrint, DialogMessage;
//------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------
procedure TMainCehForm.Initialize_afterSave_all;
begin
     oldGoodsId:=0;
     EditPartionGoods.Text:='';
end;
//------------------------------------------------------------------------------------------------
procedure TMainCehForm.Initialize_afterSave_MI;
begin
     EmptyValuesParams(ParamsMI);
     //
     gbStartWeighing.ItemIndex:=0;
     //
     EditGoodsCode.Text:='';
     PanelGoodsName.Caption:='�������� �� �����������';
     //
     EditGoodsKindCode.Text:='';
     if rgGoodsKind.Items.Count > 0 then rgGoodsKind.ItemIndex:=0;
     //
     EditCount.Text:='';
     EditCountPack.Text:='';

     EditWeightTare_enter.Text:='';
     EditSkewer1.Text:='';
     EditSkewer2.Text:='';
     EditWeightOther.Text:='';
     //
     EditEnterCount.Text:='';
     //
     PanelWeightTare_enter_two.Caption:=FormatFloat(fmtWeight, ParamsMI.ParamByName('WeightTare').AsFloat);
     PanelWeightSkewer1.Caption:=FormatFloat(fmtWeight, ParamsMI.ParamByName('CountSkewer1').AsFloat * SettingMain.WeightSkewer1);
     PanelWeightSkewer2.Caption:=FormatFloat(fmtWeight, ParamsMI.ParamByName('CountSkewer2').AsFloat * SettingMain.WeightSkewer2);
     //
     SetParams_OperCount;
     myActiveControl;
end;
//------------------------------------------------------------------------------------------------
procedure TMainCehForm.InitializeGoodsKind(GoodsKindWeighingGroupId:Integer);
var i,i2:Integer;
begin
     PanelGoodsKind.Visible:=(GoodsKindWeighingGroupId>0)or(SettingMain.isGoodsComplete = TRUE);
     //
     //if GoodsKindWeighingGroupId = 0 then exit;
     //
     EditGoodsKindCode.Text:='';
     //
     with rgGoodsKind do
     begin
          Items.Clear;
          i:=0;
          i2:=0;
          if GoodsKindWeighingGroupId = 0
          then begin Items.Add('(1) ���'); ItemIndex:=0;EditGoodsKindCode.Text:='1';end
          else
              for i:=0 to Length(GoodsKind_Array)-1 do
                 if GoodsKind_Array[i].Number = GoodsKindWeighingGroupId
                 then begin i2:=i2+1;Items.Add('('+IntToStr(GoodsKind_Array[i].Code)+') '+ GoodsKind_Array[i].Name);end;
          //
          if i2<5 then Columns:=1 else Columns:=2;
          if i2>15 then PanelGoodsKind.Height:=185 else PanelGoodsKind.Height:=155;
          //
          ItemIndex:=0;
     end;
end;
{------------------------------------------------------------------------------}
function TMainCehForm.GetOldRealWeight:Double;
var bm:TBookMark;
begin
     Result:=0;
     with CDS do begin
         if (BOF)and(EOF)then exit;
         //
         bm:=GetBookMark;
         DisableControls;
         //
         //������ ��������
         First;
         //��������� �� ��� � ������ "��������", � ��� WeightTare = 0
         while(not EOF)and((FieldByName('WeightTare').AsFloat=0)or(FieldByName('isErased').AsBoolean = TRUE)
            or(FieldByName('MeasureId').AsInteger <> zc_Measure_Kg))
         do begin
            //���������� "���������"
            if  (FieldByName('isErased').AsBoolean = FALSE)
             and(FieldByName('MeasureId').AsInteger = zc_Measure_Kg)
            then Result:=Result+FieldByName('Amount').AsFloat
                               +FieldByName('WeightTare').AsFloat
                               +FieldByName('WeightOther').AsFloat
                               +FieldByName('TotalWeightSkewer1_k').AsFloat
                               +FieldByName('TotalWeightSkewer1').AsFloat
                               +FieldByName('TotalWeightSkewer2').AsFloat;
            Next;
         end;
         //����� ������ � ������ "�����"
         if (not EOF)and(FieldByName('isErased').AsBoolean = FALSE)and(FieldByName('MeasureId').AsInteger = zc_Measure_Kg)
         then Result:=Result+FieldByName('Amount').AsFloat
                            +FieldByName('WeightTare').AsFloat
                            +FieldByName('WeightOther').AsFloat
                            +FieldByName('TotalWeightSkewer1_k').AsFloat
                            +FieldByName('TotalWeightSkewer1').AsFloat
                            +FieldByName('TotalWeightSkewer2').AsFloat;
         //
         //�������������� ��������
         {First;
         //���������� "���������"
         while(not EOF)and((FieldByName('isErased').AsBoolean = TRUE)or(FieldByName('MeasureId').AsInteger <> zc_Measure_Kg)) do begin
            Next;
         end;
         //����� ������ � "�����" ������
         if (not EOF)and(FieldByName('isErased').AsBoolean = FALSE)and(FieldByName('MeasureId').AsInteger = zc_Measure_Kg)
         then Result:=FieldByName('RealWeight').AsFloat;}

         GotoBookMark(bm);
         EnableControls;
     end;
end;
{------------------------------------------------------------------------------}
procedure TMainCehForm.SetParams_OperCount;
var calcOperCount:Double;
begin
     with ParamsMI do begin
        if (gbStartWeighing.ItemIndex=0)or(ParamByName('RealWeight').AsFloat=0)
         or(ParamByName('MeasureId').AsInteger <> zc_Measure_Kg)
        then calcOperCount:=ParamByName('RealWeight').AsFloat
        else calcOperCount:=ParamByName('RealWeight').AsFloat - GetOldRealWeight;
        //
        if (ParamByName('MeasureId').AsInteger <> zc_Measure_Kg)
        then ParamByName('OperCount').AsFloat:=calcOperCount
        else ParamByName('OperCount').AsFloat:=calcOperCount
                                              -ParamByName('WeightTare').AsFloat
                                              -ParamByName('WeightOther').AsFloat
                                              -ParamByName('CountSkewer1').AsFloat * SettingMain.WeightSkewer1
                                              -ParamByName('CountSkewer2').AsFloat * SettingMain.WeightSkewer2
                                              ;
        //
        if (ParamByName('MeasureId').AsInteger = zc_Measure_Kg)
        then EditEnterCount.Text:='';
        //
        PanelGoodsWeight.Caption:= FormatFloat(fmtWeight, ParamByName('OperCount').AsFloat);
        Panel_Weight.Caption:= FormatFloat(fmtWeight, calcOperCount);
     end;
end;
{------------------------------------------------------------------------------}
procedure TMainCehForm.myActiveControl;
var Key:Word;
begin
     ActiveControl:=cxDBGrid;
     ActiveControl:=EditGoodsCode;
//     if PanelPartionGoods.Visible
//     then ActiveControl:=EditGoodsCode
//     else ActiveControl:=EditGoodsCode;
end;
//------------------------------------------------------------------------------------------------
function TMainCehForm.Save_Movement_all:Boolean;
var execParams:TParams;
begin
     Result:=false;
     //
     OperDateEdit.Text:=DateToStr(DMMainScaleCehForm.gpGet_Scale_OperDate(ParamsMovement));
     //��������
     if ParamsMovement.ParamByName('MovementId').AsInteger=0
     then begin
         ShowMessage('������.��������� �� ��������.');
         exit;
     end;
     //�������� - ���� ���� ������������� �������, ����� ������������ ��������� �� ����������
     if ParamsMI.ParamByName('GoodsId').AsInteger <> 0 then
     begin
          ShowMessage('��������� ������� ����������� �������� ������� <F4>.');
          ActiveControl:=EditGoodsCode;
          exit;
     end;
     //�������� - ������ ��� ���.
     if SettingMain.isGoodsComplete = FALSE
     then
         //�������� - ������
         if DMMainScaleCehForm.gpGet_ScaleCeh_Movement_checkPartion(ParamsMovement.ParamByName('MovementId').AsInteger,0,'',0) = FALSE
         then exit;


     //if MessageDlg('�������� ������� � ����� �� <'+OperDateEdit.Text+'>.����������?',mtConfirmation,mbYesNoCancel,0) <> 6
     if DialogMessageForm.Execute = FALSE
     then exit;


     //��������� ��� ������
     if not DialogPrintForm.Execute(ParamsMovement.ParamByName('isMovement').asBoolean
                                   ,ParamsMovement.ParamByName('isAccount').asBoolean
                                   ,ParamsMovement.ParamByName('isTransport').asBoolean
                                   ,ParamsMovement.ParamByName('isQuality').asBoolean
                                   ,ParamsMovement.ParamByName('isPack').asBoolean
                                   ,ParamsMovement.ParamByName('isSpec').asBoolean
                                   ,ParamsMovement.ParamByName('isTax').asBoolean
                                   )
     then begin
         //!!!��� ������ ������ �� ���� ������!!!
         ShowMessage('��������� ������ �� ����������.'+#10+#13+'�������� �� ����� ������.');
         exit;
     end;

     //!!!��������� ��������!!!
     if DMMainScaleCehForm.gpInsert_MovementCeh_all(ParamsMovement) then
     begin
          //
          //Print and Create Quality + Transport + Tax
          Print_Movement_afterSave;
          //Initialize or Empty
          //�� ����� ��������� ��������� ���������� ���.
          //ParamsMovement.ParamByName('MovementId').AsInteger:=0;//!!!������ ��������, �.�. ��� ����� ������� isLast=TRUE!!!
          //DMMainScaleCehForm.gpGet_Scale_Movement(ParamsMovement,FALSE,FALSE);//isLast=FALSE,isNext=FALSE
          EmptyValuesParams(ParamsMovement);//!!!����� ����!!!
          gpInitialize_MovementDesc;
          //
          Initialize_afterSave_all;
          Initialize_afterSave_MI;
          //
          RefreshDataSet;
          WriteParamsMovement;
     end;
end;
//------------------------------------------------------------------------------------------------
function TMainCehForm.Save_MI:Boolean;
begin
     Result:=false;
     //
     // ��������
     if  (oldGoodsId=ParamsMI.ParamByName('GoodsId').AsInteger)
      and(MessageDlg ('�������� ������ ���.����������?', mtConfirmation, mbYesNoCancel, 0) <> 6)
      then begin
           ActiveControl:=EditGoodsCode;
           exit;
     end;
     // ��������
     if ParamsMI.ParamByName('GoodsId').AsInteger = 0 then
     begin ActiveControl:=EditGoodsCode;
           PanelMovementDesc.Font.Color:=clRed;
           PanelMovementDesc.Caption:='������.�� ��������� ��� <���������>';
           exit;
     end;
     //������� ����������� ���-��
     SetParams_OperCount;
     // ��������
     if ParamsMI.ParamByName('OperCount').AsFloat <= 0 then
     begin ActiveControl:=EditGoodsCode;
           PanelMovementDesc.Font.Color:=clRed;
           PanelMovementDesc.Caption:='������.��� ��������� �� ����� ���� <= 0';
           exit;
     end;
     // ��������
     if (rgGoodsKind.ItemIndex=-1)and (rgGoodsKind.Items.Count>1) then
     begin ActiveControl:=EditGoodsKindCode;
           PanelMovementDesc.Font.Color:=clRed;
           PanelMovementDesc.Caption:='������.�� ���������� �������� <��� ���� ��������>';
           exit;
     end;
     // ��������
     if (ParamsMovement.ParamByName('MovementDescId').AsInteger = zc_Movement_ProductionSeparate)
        or (trim(EditPartionGoods.Text) <> '')
     then begin
               //���� ������ � �������
               if (Recalc_PartionGoods(EditPartionGoods) = FALSE) or (trim(EditPartionGoods.Text) = '') then
               begin
                    ActiveControl:=EditPartionGoods;
                    PanelMovementDesc.Font.Color:=clRed;
                    PanelMovementDesc.Caption:='������.�� ���������� <������ �����>';
                    exit;
               end;
     end;

     // ������������ ��������
     if (PanelGoodsKind.Visible)and(rgGoodsKind.ItemIndex>=0)
     then ParamsMI.ParamByName('GoodsKindId').AsInteger:= GoodsKind_Array[GetArrayList_gpIndex_GoodsKind(GoodsKind_Array,ParamsMovement.ParamByName('GoodsKindWeighingGroupId').AsInteger,rgGoodsKind.ItemIndex)].Id
     else ParamsMI.ParamByName('GoodsKindId').AsInteger:= 0;
     // ������������ ��������
     try ParamsMI.ParamByName('PartionGoodsDate').AsDateTime:=StrToDate(PartionDateEdit.Text)
     except ParamsMI.ParamByName('PartionGoodsDate').AsDateTime:=ParamsMovement.ParamByName('OperDate').AsDateTime + 1;
     end;
     // ��������
     if (PanelPartionDate.Visible) then
     begin
          if (ParamsMI.ParamByName('PartionGoodsDate').AsDateTime>ParamsMovement.ParamByName('OperDate').AsDateTime) then
          begin
               ShowMessage('������� ����������� ���� <������ ��>. �� ����� ���� ����� <'+DateToStr(ParamsMovement.ParamByName('OperDate').AsDateTime)+'>.');
               exit;
          end;
          if (ParamsMI.ParamByName('PartionGoodsDate').AsDateTime<ParamsMovement.ParamByName('OperDate').AsDateTime - StrToInt(GetArrayList_Value_byName(Default_Array,'PeriodPartionGoodsDate'))) then
          begin
               ShowMessage('������� ����������� ���� <������ ��>. �� ����� ���� ������ <'+DateToStr(ParamsMovement.ParamByName('OperDate').AsDateTime)+'>.');
               exit;
          end;
     end;

     // ������������ ��������
     ParamsMI.ParamByName('PartionGoods').AsString:=trim(EditPartionGoods.Text);
     ParamsMI.ParamByName('isStartWeighing').AsBoolean:=gbStartWeighing.ItemIndex = 0;

     //����������� ����� �������� - ������ ��� ���.
     if ParamsMovement.ParamByName('MovementId').AsInteger = 0 then
     begin
           Result:= DMMainScaleCehForm.gpInsertUpdate_ScaleCeh_Movement(ParamsMovement);
           if not Result then exit;
     end;
     //�������� - ������ ��� ���.
     if SettingMain.isGoodsComplete = FALSE
     then
         //�������� - ������
         if DMMainScaleCehForm.gpGet_ScaleCeh_Movement_checkPartion(ParamsMovement.ParamByName('MovementId').AsInteger,ParamsMI.ParamByName('GoodsId').AsInteger,ParamsMI.ParamByName('PartionGoods').AsString,ParamsMI.ParamByName('OperCount').AsFloat) = FALSE
         then exit;

     //���������� MovementItem
     Result:=DMMainScaleCehForm.gpInsert_ScaleCeh_MI(ParamsMovement,ParamsMI);
     //
     if Result then
     begin
          oldGoodsId:=ParamsMI.ParamByName('GoodsId').AsInteger;
          Initialize_afterSave_MI;
          RefreshDataSet;
          WriteParamsMovement;
     end;
end;
//------------------------------------------------------------------------------------------------
function TMainCehForm.Print_Movement_afterSave:Boolean;
begin
     Result:=true;
     //
     //Movement
     if DialogPrintForm.cbPrintMovement.Checked
     then Result:=Print_Movement (ParamsMovement.ParamByName('MovementDescId').AsInteger
                                , ParamsMovement.ParamByName('MovementId_begin').AsInteger
                                , StrToInt(DialogPrintForm.PrintCountEdit.Text) // myPrintCount
                                , DialogPrintForm.cbPrintPreview.Checked        // isPreview
                                , DialogMovementDescForm.Get_isSendOnPriceIn(ParamsMovement.ParamByName('MovementDescNumber').AsInteger)
                                 );
     //
     if not Result then ShowMessage('�������� ��������.');

end;
//------------------------------------------------------------------------------------------------
function TMainCehForm.GetParams_MovementDesc(BarCode: String):Boolean;
var MovementId_save:Integer;
begin
     MovementId_save:=ParamsMovement.ParamByName('MovementId').AsInteger;
     //
     if ParamsMovement.ParamByName('MovementId').AsInteger=0
     then if ParamsMovement.ParamByName('MovementDescId').AsInteger=0
          then ParamsMovement.ParamByName('MovementDescNumber').AsInteger:=StrToInt(GetArrayList_Value_byName(Default_Array,'MovementNumber'))
          else
     else if (DMMainScaleCehForm.gpGet_Scale_Movement_checkId(ParamsMovement)=false)
          then begin
               //ShowMessage ('������.'+#10+#13+'�������� ����������� � <'+ParamsMovement.ParamByName('InvNumber').AsString+'>  �� <'+DateToStr(ParamsMovement.ParamByName('OperDate_Movement').AsDateTime)+'> �� ������.'+#10+#13+'��������� ���������� �� ��������.');
               //Result:=false;
               if MessageDlg('������� ����������� �� �������.'+#10+#13+'������������� ������� � �������� <������> �����������?',mtConfirmation,mbYesNoCancel,0) <> 6
               then begin Result:=false;exit;end;
          end;
     //
     Result:=DialogMovementDescForm.Execute(BarCode);
     if Result then
     begin
          if ParamsMovement.ParamByName('MovementId').AsInteger<>0
          then DMMainScaleCehForm.gpInsertUpdate_ScaleCeh_Movement(ParamsMovement);
          //
          WriteParamsMovement;
          //
          if MovementId_save <> 0 then
          begin
               RefreshDataSet;
               Initialize_afterSave_all;
               Initialize_afterSave_MI;
          end;
          InitializeGoodsKind(ParamsMovement.ParamByName('GoodsKindWeighingGroupId').AsInteger);
     end;
     myActiveControl;
end;
//------------------------------------------------------------------------------------------------
procedure TMainCehForm.bbChangeCountClick(Sender: TObject);
var execParams:TParams;
begin
     // �����
     if CDS.FieldByName('MovementItemId').AsInteger = 0 then
     begin
          ShowMessage('������.������� ����������� �� ������.');
          exit;
     end;
     //
     execParams:=nil;
     ParamAddValue(execParams,'inMovementItemId',ftInteger,CDS.FieldByName('MovementItemId').AsInteger);
     ParamAddValue(execParams,'inDescCode',ftString,'zc_MIFloat_Count');

     with DialogNumberValueForm do
     begin
          LabelNumberValue.Caption:='���������� �������';
          ActiveControl:=NumberValueEdit;
          NumberValueEdit.Text:=CDS.FieldByName('Count').AsString;
          if not Execute then begin execParams.Free;exit;end;
          //
          ParamAddValue(execParams,'inValueData',ftFloat,NumberValue);
          DMMainScaleCehForm.gpUpdate_Scale_MIFloat(execParams);
          //
     end;
     //
     execParams.Free;
     //
     RefreshDataSet;
end;
{------------------------------------------------------------------------}
procedure TMainCehForm.bbChangeCountPackClick(Sender: TObject);
var execParams:TParams;
begin
     // �����
     if CDS.FieldByName('MovementItemId').AsInteger = 0 then
     begin
          ShowMessage('������.������� ����������� �� ������.');
          exit;
     end;
     //
     execParams:=nil;
     ParamAddValue(execParams,'inMovementItemId',ftInteger,CDS.FieldByName('MovementItemId').AsInteger);
     ParamAddValue(execParams,'inDescCode',ftString,'zc_MIFloat_CountPack');

     with DialogNumberValueForm do
     begin
          LabelNumberValue.Caption:='���������� �������';
          ActiveControl:=NumberValueEdit;
          NumberValueEdit.Text:=CDS.FieldByName('Count').AsString;
          if not Execute then begin execParams.Free;exit;end;
          //
          ParamAddValue(execParams,'inValueData',ftFloat,NumberValue);
          DMMainScaleCehForm.gpUpdate_Scale_MIFloat(execParams);
          //
     end;
     //
     execParams.Free;
     //
     RefreshDataSet;
end;
{------------------------------------------------------------------------}
procedure TMainCehForm.bbChangeHeadCountClick(Sender: TObject);
var execParams:TParams;
begin
     // �����
     if CDS.FieldByName('MovementItemId').AsInteger = 0 then
     begin
          ShowMessage('������.������� ����������� �� ������.');
          exit;
     end;
     //
     execParams:=nil;
     ParamAddValue(execParams,'inMovementItemId',ftInteger,CDS.FieldByName('MovementItemId').AsInteger);
     ParamAddValue(execParams,'inDescCode',ftString,'zc_MIFloat_HeadCount');

     with DialogNumberValueForm do
     begin
          LabelNumberValue.Caption:='���������� �����';
          ActiveControl:=NumberValueEdit;
          NumberValueEdit.Text:=CDS.FieldByName('HeadCount').AsString;
          if not Execute then begin execParams.Free;exit;end;
          //
          ParamAddValue(execParams,'inValueData',ftFloat,NumberValue);
          DMMainScaleCehForm.gpUpdate_Scale_MIFloat(execParams);
          //
     end;
     //
     execParams.Free;
     //
     RefreshDataSet;
end;
{------------------------------------------------------------------------}
procedure TMainCehForm.bbChangeLiveWeightClick(Sender: TObject);
var execParams:TParams;
begin
     // �����
     if CDS.FieldByName('MovementItemId').AsInteger = 0 then
     begin
          ShowMessage('������.������� ����������� �� ������.');
          exit;
     end;
     //
     execParams:=nil;
     ParamAddValue(execParams,'inMovementItemId',ftInteger,CDS.FieldByName('MovementItemId').AsInteger);
     ParamAddValue(execParams,'inDescCode',ftString,'zc_MIFloat_LiveWeight');

     with DialogNumberValueForm do
     begin
          LabelNumberValue.Caption:='����� ���';
          ActiveControl:=NumberValueEdit;
          NumberValueEdit.Text:=CDS.FieldByName('LiveWeight').AsString;
          if not Execute then begin execParams.Free;exit;end;
          //
          ParamAddValue(execParams,'inValueData',ftFloat,NumberValue);
          DMMainScaleCehForm.gpUpdate_Scale_MIFloat(execParams);
          //
     end;
     //
     execParams.Free;
     //
     RefreshDataSet;
end;
{------------------------------------------------------------------------}
procedure TMainCehForm.bbChangePartionGoodsClick(Sender: TObject);
var execParams:TParams;
begin
     // �����
     if CDS.FieldByName('MovementItemId').AsInteger = 0 then
     begin
          ShowMessage('������.������� ����������� �� ������.');
          exit;
     end;
     //
     execParams:=nil;
     ParamAddValue(execParams,'inMovementItemId',ftInteger,CDS.FieldByName('MovementItemId').AsInteger);
     ParamAddValue(execParams,'inDescCode',ftString,'zc_MIString_PartionGoods');

     with DialogStringValueForm do
     begin
          LabelStringValue.Caption:='������ �����';
          ActiveControl:=StringValueEdit;
          StringValueEdit.Text:=CDS.FieldByName('PartionGoods').AsString;
          isPartionGoods:=true;
          if not Execute then begin execParams.Free;exit;end;
          //
          //�������� - ������ ��� ���.
          if SettingMain.isGoodsComplete = FALSE
          then
              //�������� - ������
              if DMMainScaleCehForm.gpGet_ScaleCeh_Movement_checkPartion(ParamsMovement.ParamByName('MovementId').AsInteger,CDS.FieldByName('GoodsId').AsInteger,StringValueEdit.Text,CDS.FieldByName('Amount').AsFloat) = FALSE
              then begin execParams.Free;exit;end;
          //
          ParamAddValue(execParams,'inValueData',ftString,StringValueEdit.Text);
          DMMainScaleCehForm.gpUpdate_Scale_MIString(execParams);
          //
     end;
     //
     execParams.Free;
     //
     RefreshDataSet;
end;
{------------------------------------------------------------------------}
procedure TMainCehForm.bbChangePartionGoodsDateClick(Sender: TObject);
var execParams:TParams;
begin
     // �����
     if CDS.FieldByName('MovementItemId').AsInteger = 0 then
     begin
          ShowMessage('������.������� ����������� �� ������.');
          exit;
     end;
     //
     execParams:=nil;
     ParamAddValue(execParams,'inMovementItemId',ftInteger,CDS.FieldByName('MovementItemId').AsInteger);
     ParamAddValue(execParams,'inDescCode',ftString,'zc_MIDate_PartionGoods');

     with DialogDateValueForm do
     begin
          LabelDateValue.Caption:='������ ����';
          ActiveControl:=DateValueEdit;
          DateValueEdit.Text:=DateToStr(CDS.FieldByName('PartionGoodsDate').AsDateTime);
          isPartionGoodsDate:=true;
          if not Execute then begin execParams.Free;exit;end;
          //
          ParamAddValue(execParams,'inValueData',ftDateTime,StrToDate(DateValueEdit.Text));
          DMMainScaleCehForm.gpUpdate_Scale_MIDate(execParams);
          //
     end;
     //
     execParams.Free;
     //
     RefreshDataSet;
end;
{------------------------------------------------------------------------}
procedure TMainCehForm.bbChoice_UnComleteClick(Sender: TObject);
begin
     if GuideMovementCehForm.Execute(ParamsMovement,TRUE)//isChoice=TRUE
     then begin
               WriteParamsMovement;
               RefreshDataSet;
               CDS.First;
               oldGoodsId:=0;
          end;
     myActiveControl;
end;
{------------------------------------------------------------------------}
procedure TMainCehForm.bbView_allClick(Sender: TObject);
begin
     GuideMovementCehForm.Execute(ParamsMovement,FALSE);//isChoice=FALSE
     myActiveControl;
end;
{------------------------------------------------------------------------}
procedure TMainCehForm.actRefreshExecute(Sender: TObject);
begin
    RefreshDataSet;
    WriteParamsMovement;
end;
//------------------------------------------------------------------------------------------------
procedure TMainCehForm.CDSAfterOpen(DataSet: TDataSet);
var bm: TBookmark;
    RealWeight,AmountWeight,WeightTare,WeightOther,CountSkewer: Double;
begin
  with DataSet do
    try
       //
       bm:=GetBookmark; DisableControls;
       First;
       RealWeight:=0;
       AmountWeight:=0;
       WeightTare:=0;
       WeightOther:=0;
       CountSkewer:=0;
       while not EOF do begin
          if FieldByName('isErased').AsBoolean=false then
          begin
            RealWeight:=RealWeight+FieldByName('RealWeightWeight').AsFloat;
            AmountWeight:=AmountWeight+FieldByName('AmountWeight').AsFloat;
            WeightTare:=WeightTare+FieldByName('WeightTare').AsFloat;
            WeightOther:=WeightOther+FieldByName('TotalWeightSkewer1_k').AsFloat+FieldByName('TotalWeightSkewer1').AsFloat+FieldByName('TotalWeightSkewer2').AsFloat+FieldByName('WeightOther').AsFloat;
            CountSkewer:=CountSkewer+FieldByName('CountSkewer1_k').AsFloat+FieldByName('CountSkewer1').AsFloat+FieldByName('CountSkewer2').AsFloat;
          end;
          //
          Next;
       end;
    finally
       GotoBookmark(bm);
       FreeBookmark(bm);
       EnableControls;
    end;

    PanelRealWeight.Caption:=FormatFloat(fmtWeight, RealWeight);
    PanelAmountWeight.Caption:=FormatFloat(fmtWeight, AmountWeight);
    PanelWeightTare.Caption:=FormatFloat(fmtWeight, WeightTare);
    PanelWeightOther.Caption:=FormatFloat(fmtWeight, WeightOther);
    PanelCountSkewer.Caption:=FormatFloat(',0.#### ��.'+'',CountSkewer);
end;
//------------------------------------------------------------------------------------------------
procedure TMainCehForm.EditGoodsCodeExit(Sender: TObject);
var GoodsCode_int:Integer;
begin
     if (ParamsMovement.ParamByName('MovementDescId').asInteger = 0)and(ActiveControl.ClassName <> 'TcxGridSite')and(ActiveControl.ClassName <> 'TcxGrid') and (ActiveControl.ClassName <> 'TcxDateEdit')
     then if GetParams_MovementDesc('') = false
          then begin
                    ActiveControl:=EditGoodsCode;
                    PanelMovementDesc.Font.Color:=clRed;
                    PanelMovementDesc.Caption:='������.�� ��������� <��� ��������>.������� �� ���������� ������� <F2>';
                    exit;
          end;
     //
     //
     try GoodsCode_int:= StrToInt(EditGoodsCode.Text);
     except
      GoodsCode_int:= 0;
     end;
     //����� ������ �� ���� + ����������� ���������
     if DMMainScaleCehForm.gpGet_Scale_Goods(ParamsMI,IntToStr(GoodsCode_int)) = TRUE
     then begin
          PanelGoodsName.Caption:= ParamsMI.ParamByName('GoodsName').asString;
          WriteParamsMovement;
          if ParamsMI.ParamByName('MeasureId').AsInteger <> zc_Measure_Kg
          then ActiveControl:=EditEnterCount;
     end
     else begin
          if (ActiveControl.ClassName = 'TcxGridSite') or (ActiveControl.ClassName = 'TcxGrid') or (ActiveControl.ClassName = 'TcxDateEdit')
          then WriteParamsMovement
          else begin ActiveControl:=EditGoodsCode;
                     PanelMovementDesc.Font.Color:=clRed;
                     PanelMovementDesc.Caption:='������.�� ��������� ��� <���������>';
               end;

          PanelGoodsName.Caption:= '�������� �� �����������';
          exit;
     end;
     //
     ParamsMI.ParamByName('RealWeight').AsFloat:=fGetScale_CurrentWeight;
     SetParams_OperCount;
     //
     if (ParamsMI.ParamByName('OperCount').AsFloat<=0)and(ParamsMI.ParamByName('MeasureId').AsInteger = zc_Measure_Kg)
     then begin ActiveControl:=EditGoodsCode;
                PanelMovementDesc.Font.Color:=clRed;
                PanelMovementDesc.Caption:='������.�� ��������� ��� <���������>';
          end
     else WriteParamsMovement;
end;
//---------------------------------------------------------------------------------------------
procedure TMainCehForm.EditGoodsKindCodeExit(Sender: TObject);
begin
      if (rgGoodsKind.ItemIndex=-1)and (rgGoodsKind.Items.Count>1)
      then begin PanelMovementDesc.Font.Color:=clRed;
                 PanelMovementDesc.Caption:='������.�� ���������� �������� <��� ���� ��������>';
                 ActiveControl:=EditGoodsKindCode;
           end
      else WriteParamsMovement;
end;
//---------------------------------------------------------------------------------------------
procedure TMainCehForm.EditPartionGoodsExit(Sender: TObject);
var RetV:Boolean;
begin
     if (ParamsMovement.ParamByName('MovementDescId').AsInteger = zc_Movement_ProductionSeparate)
        or (trim(EditPartionGoods.Text) <> '')
     then begin RetV:=Recalc_PartionGoods(EditPartionGoods);
                if trim(EditPartionGoods.Text) = '' then RetV:=false;
     end
     else RetV:=true;

     //���� ������ � �������
     if RetV = FALSE then
     begin
          PanelMovementDesc.Font.Color:=clRed;
          PanelMovementDesc.Caption:='������.�� ���������� <������ �����>';
          ActiveControl:=EditPartionGoods;
     end
     else WriteParamsMovement;
end;
//---------------------------------------------------------------------------------------------
procedure TMainCehForm.EditWeightTare_enterExit(Sender: TObject);
begin
     if ParamsMI.ParamByName('GoodsId').AsInteger > 0 then
     begin
           SetParams_OperCount;
           //
           if (ParamsMI.ParamByName('OperCount').AsFloat<=0)
           then begin ActiveControl:=EditWeightTare_enter;
                      PanelMovementDesc.Font.Color:=clRed;
                      PanelMovementDesc.Caption:='������.��� ��������� �� ����� ���� <= 0';
                end
           else WriteParamsMovement;
     end;
end;
//---------------------------------------------------------------------------------------------
procedure TMainCehForm.EditSkewer1Exit(Sender: TObject);
begin
     if ParamsMI.ParamByName('GoodsId').AsInteger > 0 then
     begin
           SetParams_OperCount;
           //
           if (ParamsMI.ParamByName('OperCount').AsFloat<=0)
           then begin ActiveControl:=EditSkewer1;
                      PanelMovementDesc.Font.Color:=clRed;
                      PanelMovementDesc.Caption:='������.��� ��������� �� ����� ���� <= 0';
                end
           else WriteParamsMovement;
     end;
end;
//---------------------------------------------------------------------------------------------
procedure TMainCehForm.EditSkewer2Exit(Sender: TObject);
begin
     if ParamsMI.ParamByName('GoodsId').AsInteger > 0 then
     begin
           SetParams_OperCount;
           //
           if (ParamsMI.ParamByName('OperCount').AsFloat<=0)
           then begin ActiveControl:=EditSkewer2;
                      PanelMovementDesc.Font.Color:=clRed;
                      PanelMovementDesc.Caption:='������.��� ��������� �� ����� ���� <= 0';
                end
           else WriteParamsMovement;
     end;
end;
//---------------------------------------------------------------------------------------------
procedure TMainCehForm.EditWeightOtherExit(Sender: TObject);
begin
     if ParamsMI.ParamByName('GoodsId').AsInteger > 0 then
     begin
           SetParams_OperCount;
           //
           if (ParamsMI.ParamByName('OperCount').AsFloat<=0)
           then begin ActiveControl:=EditWeightOther;
                      PanelMovementDesc.Font.Color:=clRed;
                      PanelMovementDesc.Caption:='������.��� ��������� �� ����� ���� <= 0';
                end
           else WriteParamsMovement;
     end;
end;
//---------------------------------------------------------------------------------------------
procedure TMainCehForm.EditEnterCountExit(Sender: TObject);
begin
     if ParamsMI.ParamByName('GoodsId').AsInteger > 0 then
     begin
           SetParams_OperCount;
           //
           if (ActiveControl.ClassName = 'TcxGridSite') or (ActiveControl.ClassName = 'TcxGrid') or (ActiveControl.ClassName = 'TcxDateEdit')
           then WriteParamsMovement
           else
           if (ParamsMI.ParamByName('OperCount').AsFloat<=0)
           then begin ActiveControl:=EditEnterCount;
                      PanelMovementDesc.Font.Color:=clRed;
                      PanelMovementDesc.Caption:='������.��� ��������� �� ����� ���� <= 0';
                end
           else WriteParamsMovement;
     end;
end;
//---------------------------------------------------------------------------------------------
procedure TMainCehForm.EditPartionGoodsEnter(Sender: TObject);
begin
     EditPartionGoods.SelectAll;
end;
//---------------------------------------------------------------------------------------------
procedure TMainCehForm.EditGoodsCodeKeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
begin
     if Key = 13 then
     begin
          if PanelGoodsKind.Visible then ActiveControl:=EditGoodsKindCode
          else if PanelPartionGoods.Visible then ActiveControl:=EditPartionGoods
               else ActiveControl:=EditCount;
     end;
end;
//---------------------------------------------------------------------------------------------
procedure TMainCehForm.EditGoodsKindCodeKeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
begin
     if Key = 13 then
     begin
          if PanelPartionGoods.Visible then ActiveControl:=EditPartionGoods
          else ActiveControl:=EditCount;
     end;
end;
//---------------------------------------------------------------------------------------------
procedure TMainCehForm.EditPartionGoodsKeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
begin
     if Key = 13 then ActiveControl:=EditCount;
end;
//---------------------------------------------------------------------------------------------
procedure TMainCehForm.EditCountKeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
begin
     if Key = 13 then ActiveControl:=EditCountPack;
end;
//---------------------------------------------------------------------------------------------
procedure TMainCehForm.EditCountPackKeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
begin
     if Key = 13 then ActiveControl:=EditWeightTare_enter;
end;
//---------------------------------------------------------------------------------------------
procedure TMainCehForm.EditWeightTare_enterKeyDown(Sender: TObject;var Key: Word; Shift: TShiftState);
begin
     if Key = 13 then
     begin
          if infoPanelSkewer1.Visible then ActiveControl:=EditSkewer1
          else if infoPanelSkewer2.Visible then ActiveControl:=EditSkewer2
               else if infoPanelWeightOther.Visible then ActiveControl:=EditWeightOther
                    else ActiveControl:=EditGoodsCode;
     end;
end;
//---------------------------------------------------------------------------------------------
procedure TMainCehForm.EditSkewer1KeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
begin
     if Key = 13 then
     begin
          if infoPanelSkewer2.Visible then ActiveControl:=EditSkewer2
          else if infoPanelWeightOther.Visible then ActiveControl:=EditWeightOther
               else ActiveControl:=EditGoodsCode;
     end;
end;
//---------------------------------------------------------------------------------------------
procedure TMainCehForm.EditSkewer2KeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
begin
     if Key = 13 then
     begin
          if infoPanelWeightOther.Visible then ActiveControl:=EditWeightOther
          else ActiveControl:=EditGoodsCode;
     end;
end;
//---------------------------------------------------------------------------------------------
procedure TMainCehForm.EditWeightOtherKeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
begin
     if Key = 13 then ActiveControl:=EditGoodsCode;
end;
//---------------------------------------------------------------------------------------------
procedure TMainCehForm.EditEnterCountKeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
begin
     if Key = 13 then
     begin
          if PanelGoodsKind.Visible then ActiveControl:=EditGoodsKindCode
          else if PanelPartionGoods.Visible then ActiveControl:=EditPartionGoods
               else ActiveControl:=EditCount;
     end;
end;
{------------------------------------------------------------------------}
procedure TMainCehForm.EditCountPropertiesChange(Sender: TObject);
var tmpValue:Double;
begin
     try tmpValue:=StrToFloat(EditCount.Text);
     except
           tmpValue:=0;
     end;
     if SettingMain.isGoodsComplete = TRUE
     then ParamsMI.ParamByName('Count').AsFloat:=tmpValue     // ������������/�������� - ���������� �������
     else ParamsMI.ParamByName('HeadCount').AsFloat:=tmpValue;// ������� - ���������� �����
end;
//------------------------------------------------------------------------------------------------
procedure TMainCehForm.EditCountPackPropertiesChange(Sender: TObject);
var tmpValue:Double;
begin
     try tmpValue:=StrToFloat(EditCountPack.Text);
     except
           tmpValue:=0;
     end;
     //
     if SettingMain.isGoodsComplete = TRUE
     then ParamsMI.ParamByName('CountPack').AsFloat:=tmpValue  // ������������/�������� - ���������� �������
     else ParamsMI.ParamByName('LiveWeight').AsFloat:=tmpValue;// ������� - ����� ���
end;
//------------------------------------------------------------------------------------------------
procedure TMainCehForm.EditWeightTare_enterPropertiesChange(Sender: TObject);
begin
     try ParamsMI.ParamByName('WeightTare').AsFloat:=StrToFloat(EditWeightTare_enter.Text);
     except
           ParamsMI.ParamByName('WeightTare').AsFloat:=0;
     end;
     PanelWeightTare_enter_two.Caption:=FormatFloat(fmtWeight, ParamsMI.ParamByName('WeightTare').AsFloat);
end;
//---------------------------------------------------------------------------------------------
procedure TMainCehForm.EditSkewer1PropertiesChange(Sender: TObject);
begin
     try ParamsMI.ParamByName('CountSkewer1').AsFloat:=StrToFloat(EditSkewer1.Text);
     except
           ParamsMI.ParamByName('CountSkewer1').AsFloat:=0;
     end;
     PanelWeightSkewer1.Caption:=FormatFloat(fmtWeight, ParamsMI.ParamByName('CountSkewer1').AsFloat * SettingMain.WeightSkewer1);
end;
//---------------------------------------------------------------------------------------------
procedure TMainCehForm.EditSkewer2PropertiesChange(Sender: TObject);
begin
     try ParamsMI.ParamByName('CountSkewer2').AsFloat:=StrToFloat(EditSkewer2.Text);
     except
           ParamsMI.ParamByName('CountSkewer2').AsFloat:=0;
     end;
     PanelWeightSkewer2.Caption:=FormatFloat(fmtWeight, ParamsMI.ParamByName('CountSkewer2').AsFloat * SettingMain.WeightSkewer2);
end;
//---------------------------------------------------------------------------------------------
procedure TMainCehForm.EditWeightOtherPropertiesChange(Sender: TObject);
begin
     try ParamsMI.ParamByName('WeightOther').AsFloat:=StrToFloat(EditWeightOther.Text);
     except
           ParamsMI.ParamByName('WeightOther').AsFloat:=0;
     end;
end;
//---------------------------------------------------------------------------------------------
procedure TMainCehForm.EditEnterCountPropertiesChange(Sender: TObject);
begin
     if ParamsMI.ParamByName('MeasureId').AsInteger <> zc_Measure_Kg
     then
          try ParamsMI.ParamByName('RealWeight').AsFloat:=StrToFloat(EditEnterCount.Text);
              SetParams_OperCount;
          except
                ParamsMI.ParamByName('RealWeight').AsFloat:=0;
          end;
end;
//---------------------------------------------------------------------------------------------
procedure TMainCehForm.EditEnterCountEnter(Sender: TObject);
begin
     if ParamsMI.ParamByName('MeasureId').AsInteger = zc_Measure_Kg
     then ActiveControl:=EditGoodsCode;
end;
//---------------------------------------------------------------------------------------------
procedure TMainCehForm.gbStartWeighingEnter(Sender: TObject);
begin
     ActiveControl:=EditGoodsCode;
end;
//---------------------------------------------------------------------------------------------
procedure TMainCehForm.gbStartWeighingClick(Sender: TObject);
begin
     if gbStartWeighing.ItemIndex = 1 then
     begin
          EditWeightTare_enter.Text:='';
          SetParams_OperCount;
     end;
end;
{------------------------------------------------------------------------}
procedure TMainCehForm.EditGoodsKindCodePropertiesChange(Sender: TObject);
var Code_begin:Integer;
begin
//     if (fStartWrite=true) then exit;

     if rgGoodsKind.Items.Count>1
     then begin
         if trim(EditGoodsKindCode.Text)<>''
         then try Code_begin:=StrToInt(EditGoodsKindCode.Text) except Code_begin:=-1;end else Code_begin:=-1;

         if (Code_begin<=0)
         then rgGoodsKind.ItemIndex:=-1
         else rgGoodsKind.ItemIndex:=GetArrayList_lpIndex_GoodsKind(GoodsKind_Array,ParamsMovement.ParamByName('GoodsKindWeighingGroupId').AsInteger,Code_begin);
     end
end;
{------------------------------------------------------------------------------}
procedure TMainCehForm.rgGoodsKindClick(Sender: TObject);
var findIndex:Integer;
begin
     if rgGoodsKind.Items.Count>1
     then begin
         findIndex:=GetArrayList_gpIndex_GoodsKind(GoodsKind_Array,ParamsMovement.ParamByName('GoodsKindWeighingGroupId').AsInteger,rgGoodsKind.ItemIndex);
         EditGoodsKindCode.Text:=IntToStr(GoodsKind_Array[findIndex].Code);
         if (ActiveControl.ClassName = 'TGroupButton') or (ActiveControl.ClassName = 'TRadioGroup') then ActiveControl:=EditGoodsKindCode;
     end;
end;
{------------------------------------------------------------------------------}
procedure TMainCehForm.FormCreate(Sender: TObject);
begin
  SettingMain.BranchName:=DMMainScaleCehForm.lpGet_BranchName(SettingMain.BranchCode);
  Caption:='������������ ('+GetFileVersionString(ParamStr(0))+') - <'+SettingMain.BranchName+'>' + ' : <'+DMMainScaleCehForm.gpGet_Scale_User+'>';
  //global Initialize
  gpInitialize_Const;
  //global Initialize Array
  Service_Array:=       DMMainScaleCehForm.gpSelect_ToolsWeighing_onLevelChild(SettingMain.BranchCode,'Service');
  Default_Array:=       DMMainScaleCehForm.gpSelect_ToolsWeighing_onLevelChild(SettingMain.BranchCode,'Default');
  gpInitialize_SettingMain_Default; //!!!���������� ����� ��������� Default_Array!!!

  GoodsKind_Array:=     DMMainScaleCehForm.gpSelect_Scale_GoodsKindWeighing;
  //global Initialize
  Create_ParamsMI(ParamsMI);
  //global Initialize
  Create_Scale;
  //
  //local Movement Initialize
  OperDateEdit.Text:=DateToStr(ParamsMovement.ParamByName('OperDate').AsDateTime);
  PartionDateEdit.Text:=DateToStr(ParamsMovement.ParamByName('OperDate').AsDateTime);
  //local Control Form
  Initialize_afterSave_all;
  Initialize_afterSave_MI;
  //local visible Columns
  cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('GoodsKindName').Index].Visible       :=SettingMain.isGoodsComplete = TRUE;
  cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('PartionGoodsDate').Index].Visible    :=SettingMain.isGoodsComplete = TRUE;
  cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('PartionGoods').Index].Visible        :=SettingMain.isGoodsComplete = FALSE;
  cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('Count').Index].Visible               :=SettingMain.isGoodsComplete = TRUE;
  cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('CountPack').Index].Visible           :=SettingMain.isGoodsComplete = TRUE;
  cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('HeadCount').Index].Visible           :=SettingMain.isGoodsComplete = FALSE;
  cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('LiveWeight').Index].Visible          :=SettingMain.isGoodsComplete = FALSE;
  cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('CountSkewer1_k').Index].Visible      :=SettingMain.isGoodsComplete = FALSE;
  cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('TotalWeightSkewer1_k').Index].Visible:=SettingMain.isGoodsComplete = FALSE;
  cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('CountSkewer1').Index].Visible        :=SettingMain.isGoodsComplete = TRUE;
  cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('TotalWeightSkewer1').Index].Visible  :=SettingMain.isGoodsComplete = TRUE;
  cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('CountSkewer2').Index].Visible        :=SettingMain.isGoodsComplete = TRUE;
  cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('TotalWeightSkewer2').Index].Visible  :=SettingMain.isGoodsComplete = TRUE;
  cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('WeightOther').Index].Visible         :=SettingMain.isGoodsComplete = TRUE;
  //local visible
  if SettingMain.isGoodsComplete = TRUE
  then begin
            //Only ������������/��������
            PanelPartionGoods.Visible:= false;
            LabelCount_all.Caption:='���� ���-�� ��.';
            LabelCount.Caption:='������';
            LabelCountPack.Caption:='������';
            LabelSkewer.Caption:='�����';
  end
  else begin
            //Only �������
            PanelPartionGoods.Visible:= true;
            LabelCount_all.Caption:='���� ���-��';
            LabelCount.Caption:='�����';
            LabelCountPack.Caption:='����� ���';
            LabelSkewer.Caption:='������';
  end ;
  infoPanelSkewer2.Visible:=SettingMain.WeightSkewer2 > 0;
  infoPanelWeightOther.Visible:=infoPanelSkewer2.Visible;
  LabelSkewer1.Caption:='���-�� �� '+FloatToStr(SettingMain.WeightSkewer1)+' ��';
  LabelSkewer2.Caption:='���-�� �� '+FloatToStr(SettingMain.WeightSkewer2)+' ��';


  bbChangeHeadCount.Visible:=PanelPartionGoods.Visible;
  bbChangeLiveWeight.Visible:=PanelPartionGoods.Visible;
  bbChangePartionGoods.Visible:=PanelPartionGoods.Visible;
  bbChangeCount.Visible:=not PanelPartionGoods.Visible;
  bbChangeCountPack.Visible:=not PanelPartionGoods.Visible;;
  bbChangePartionGoodsDate.Visible:=not PanelPartionGoods.Visible;
  //local enabled
  gbStartWeighing.Enabled:=SettingMain.isGoodsComplete = TRUE;
  //
  //
  with spSelect do
  begin
       StoredProcName:='gpSelect_ScaleCeh_MI';
       OutputType:=otDataSet;
       Params.AddParam('inIsCeh', ftBoolean, ptInput,FALSE);
       Params.AddParam('inMovementId', ftInteger, ptInput,0);
  end;
end;
//------------------------------------------------------------------------------------------------
procedure TMainCehForm.WriteParamsMovement;
begin
  PanelPartionDate.Visible:=ParamsMovement.ParamByName('isPartionGoodsDate').asBoolean=true;
  //
  PanelMovementDesc.Font.Color:=clBlue;

  with ParamsMovement do begin

    if ParamByName('MovementId').AsInteger=0
    then PanelMovement.Caption:='����� <��������>.'
    else PanelMovement.Caption:='�������� � <'+ParamByName('InvNumber').AsString+'>  �� <'+DateToStr(ParamByName('OperDate_Movement').AsDateTime)+'>';

    PanelMovementDesc.Caption:=ParamByName('MovementDescName_master').asString;

  end;
end;
//------------------------------------------------------------------------------------------------
procedure TMainCehForm.RefreshDataSet;
begin
  with spSelect do
  begin
       Params.ParamByName('inIsCeh').Value:=SettingMain.isCeh;
       Params.ParamByName('inMovementId').Value:=ParamsMovement.ParamByName('MovementId').AsInteger;
       Execute;
  end;
  //
  CDS.First;
end;
//------------------------------------------------------------------------------------------------
procedure TMainCehForm.Create_Scale;
var i:Integer;
    number:Integer;
begin
  try Scale_DB:=TCasDB.Create(self); except end;
  try Scale_BI:=TCasBI.Create(self); except end;
  try Scale_Zeus:=TZeus.Create(self); except end;

  SettingMain.IndexScale_old:=-1;

  number:=-1;
  for i := 0 to Length(Scale_Array)-1 do
  begin
    if Scale_Array[i].COMPort>=0
    then rgScale.Items.Add(Scale_Array[i].ScaleName+' : COM' +IntToStr(Scale_Array[i].COMPort))
    else rgScale.Items.Add(Scale_Array[i].ScaleName+' : COM?');
    if Scale_Array[i].COMPort=SettingMain.DefaultCOMPort then number:=i;
  end;
  //
  if rgScale.Items.Count = 1
  then rgScale.ItemIndex:=0
  else rgScale.ItemIndex:=number;
end;
//------------------------------------------------------------------------------------------------
procedure TMainCehForm.Initialize_Scale;
begin
     //Close prior
     if SettingMain.IndexScale_old>=0
     then begin
               if Scale_Array[SettingMain.IndexScale_old].ScaleType=stBI then Scale_BI.Active := 0;
               if Scale_Array[SettingMain.IndexScale_old].ScaleType=stDB then Scale_DB.Active := 0;
               if Scale_Array[SettingMain.IndexScale_old].ScaleType=stZeus then Scale_DB.Active := 0;
          end;
     MyDelay_two(200);

     ScaleLabel.Caption:='Scale-All Error';
     //
     if Scale_Array[rgScale.ItemIndex].ScaleType = stBI
     then
          // !!! SCALE BI !!!
          try
             Scale_BI.Active := 0;
             Scale_BI.CommPort:='COM' + IntToStr(Scale_Array[rgScale.ItemIndex].ComPort);
             Scale_BI.CommSpeed := 9600;//NEW!!!
             Scale_BI.Active := 1;//NEW!!!
             if Scale_BI.Active=1
             then ScaleLabel.Caption:='BI.Active = OK'
             else ScaleLabel.Caption:='BI.Active = Error';
          except
               ScaleLabel.Caption:='BI.Active = Error-ALL';
          end;

     if Scale_Array[rgScale.ItemIndex].ScaleType = stDB
     then try
             // !!! SCALE DB !!!
             Scale_DB.Active:=0;
             Scale_DB.CommPort:='COM' + IntToStr(Scale_Array[rgScale.ItemIndex].ComPort);
             Scale_DB.Active := 1;
             //
             if Scale_BI.Active=1
             then ScaleLabel.Caption:='DB.Active = OK'
             else ScaleLabel.Caption:='DB.Active = Error';
          except
             ScaleLabel.Caption:='DB.Active = Error-ALL';
         end;

     if Scale_Array[rgScale.ItemIndex].ScaleType = stZeus
     then try
             // !!! SCALE Zeus !!!
             Scale_Zeus.Active:=0;
             Scale_Zeus.CommPort:=Scale_Array[rgScale.ItemIndex].ComPort;
             Scale_Zeus.CommSpeed := 1200;
             Scale_Zeus.Active := 1;
             //
             if Scale_Zeus.Active=1
             then ScaleLabel.Caption:='Zeus.Active = OK'
             else ScaleLabel.Caption:='Zeus.Active = Error';
          except
             ScaleLabel.Caption:='Zeus.Active = Error-ALL';
         end;

     //
     PanelWeight_Scale.Caption:='';
     //
     SettingMain.IndexScale_old:=rgScale.ItemIndex;
     //
     MyDelay_two(500);
end;
//------------------------------------------------------------------------------------------------
procedure TMainCehForm.rgScaleClick(Sender: TObject);
begin
     Initialize_Scale;
     myActiveControl;
end;
//------------------------------------------------------------------------------------------------
procedure TMainCehForm.PanelWeight_ScaleDblClick(Sender: TObject);
begin
   fGetScale_CurrentWeight;
end;
//------------------------------------------------------------------------------------------------
function TMainCehForm.fGetScale_CurrentWeight:Double;
begin
     if ParamsMI.ParamByName('MeasureId').AsInteger = zc_Measure_Sh
     then
          try Result:=StrToFloat(EditEnterCount.Text)
          except Result:=0;
          end
     else begin
     // ��������� ����, ������ ����� ����� ���
     //Initialize_Scale_DB;
     // ���������� ����
     try
        if Scale_Array[rgScale.ItemIndex].ScaleType = stBI
        then Result:=Scale_BI.Weight
             else if Scale_Array[rgScale.ItemIndex].ScaleType = stDB
                  then Result:=Scale_DB.Weight
                  else if Scale_Array[rgScale.ItemIndex].ScaleType = stZeus
                       then Result:=Scale_Zeus.Weight
                       else Result:=0;
     except Result:=0;end;
     // ��������� ����
     // Scale_DB.Active:=0;
     //
//*****
     if (System.Pos('ves=',ParamStr(1))>0)and(Result=0)
     then Result:=myStrToFloat(Copy(ParamStr(1), 5, LengTh(ParamStr(1))-4));
     if (System.Pos('ves=',ParamStr(2))>0)and(Result=0)
     then Result:=myStrToFloat(Copy(ParamStr(2), 5, LengTh(ParamStr(2))-4));
//*****
     end;
     //
     PanelWeight_Scale.Caption:=FloatToStr(Result);
end;
//------------------------------------------------------------------------------------------------
procedure TMainCehForm.FormKeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
begin
     if (Key = VK_F1)and(gbStartWeighing.Enabled) then if gbStartWeighing.ItemIndex = 0 then gbStartWeighing.ItemIndex:= 1 else gbStartWeighing.ItemIndex:= 0;
     if Key = VK_F2 then GetParams_MovementDesc('');
     if Key = VK_F4 then Save_MI;
     if Key = VK_F5 then Save_Movement_all;
     //
     if ShortCut(Key, Shift) = 24659 then
     begin
          gc_isDebugMode := not gc_isDebugMode;
          if gc_isDebugMode
          then ShowMessage('���������� ����� �������')
          else ShowMessage('���� ����� �������');
     end;
end;
{------------------------------------------------------------------------}
procedure TMainCehForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
     if Key=#32 then Key:=#0;
end;
{------------------------------------------------------------------------}
procedure TMainCehForm.FormShow(Sender: TObject);
begin
     RefreshDataSet;
     WriteParamsMovement;
     myActiveControl;
end;
{------------------------------------------------------------------------}
procedure TMainCehForm.bbDeleteItemClick(Sender: TObject);
begin
     // �����
     if CDS.FieldByName('MovementItemId').AsInteger = 0 then
     begin
          ShowMessage('������.������� ����������� �� ������.');
          exit;
     end;
     //
     if CDS.FieldByName('isErased').AsBoolean=false
     then
         if MessageDlg('������������� �������? ('+CDS.FieldByName('GoodsName').AsString+' '+CDS.FieldByName('GoodsKindName').AsString+') ���=('+CDS.FieldByName('RealWeight').AsString+')'
                ,mtConfirmation,mbYesNoCancel,0) <> 6
         then exit
         else begin
                   DMMainScaleCehForm.gpUpdate_Scale_MI_Erased(CDS.FieldByName('MovementItemId').AsInteger,true);
                   RefreshDataSet;
                   WriteParamsMovement;
              end
     else
         if MessageDlg('������������� ������������? ('+CDS.FieldByName('GoodsName').AsString+' '+CDS.FieldByName('GoodsKindName').AsString+') ���=('+CDS.FieldByName('RealWeight').AsString+')'
                ,mtConfirmation,mbYesNoCancel,0) <> 6
         then exit
         else begin
                   DMMainScaleCehForm.gpUpdate_Scale_MI_Erased(CDS.FieldByName('MovementItemId').AsInteger,false);
                   RefreshDataSet;
                   WriteParamsMovement;
              end
end;
{------------------------------------------------------------------------}
procedure TMainCehForm.actExitExecute(Sender: TObject);
begin Close;end;
{------------------------------------------------------------------------}
end.
