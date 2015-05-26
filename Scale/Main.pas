unit Main;

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
 ,SysScalesLib_TLB
 ,UtilScale,DataModul, cxStyles, dxSkinscxPCPainter, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxDBData, dsdAddOn, cxGridLevel, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxClasses, cxGridCustomView, cxGrid,
  cxCurrencyEdit, Vcl.ActnList, cxButtonEdit, dsdAction;

type
  TMainForm = class(TForm)
    GridPanel: TPanel;
    ButtonPanel: TPanel;
    bbDeleteItem: TSpeedButton;
    bbExit: TSpeedButton;
    bbRefresh: TSpeedButton;
    bbRefreshZakaz: TSpeedButton;
    bbChangeNumberTare: TSpeedButton;
    bbChangeLevelNumber: TSpeedButton;
    bbExportToEDI: TSpeedButton;
    infoPanelTotalSumm: TPanel;
    gbRealWeight: TGroupBox;
    PanelRealWeight: TPanel;
    gbPanelWeightTare: TGroupBox;
    PanelWeightTare: TPanel;
    gbAmountPartnerWeight: TGroupBox;
    PanelAmountPartnerWeight: TPanel;
    gbTotalSumm: TGroupBox;
    PanelTotalSumm: TPanel;
    PanelSaveItem: TPanel;
    BarCodePanel: TPanel;
    BarCodeLabel: TLabel;
    gbOperDate: TGroupBox;
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
    infoPanel: TPanel;
    infoPanelPartner: TPanel;
    LabelPartner: TLabel;
    PanelPartner: TPanel;
    infoPanelPriceList: TPanel;
    PriceListNameLabel: TLabel;
    PanelPriceList: TPanel;
    infoPanelOrderExternal: TPanel;
    LabelOrderExternal: TLabel;
    PanelOrderExternal: TPanel;
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
    OperDateEdit: TcxDateEdit;
    spSelect: TdsdStoredProc;
    DS: TDataSource;
    CDS: TClientDataSet;
    infoPanelContract: TPanel;
    LabelContract: TLabel;
    PanelContract: TPanel;
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
    PriceListName: TcxGridDBColumn;
    Price: TcxGridDBColumn;
    ChangePercentAmount: TcxGridDBColumn;
    AmountPartner: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    RealWeight: TcxGridDBColumn;
    WeightTareTotal: TcxGridDBColumn;
    WeightTare: TcxGridDBColumn;
    CountTare: TcxGridDBColumn;
    LevelNumber: TcxGridDBColumn;
    BoxNumber: TcxGridDBColumn;
    BoxName: TcxGridDBColumn;
    BoxCount: TcxGridDBColumn;
    InsertDate: TcxGridDBColumn;
    UpdateDate: TcxGridDBColumn;
    cxDBGridDBTableView: TcxGridDBTableView;
    cxDBGridLevel: TcxGridLevel;
    DBViewAddOn: TdsdDBViewAddOn;
    isErased: TcxGridDBColumn;
    Count: TcxGridDBColumn;
    bbChangeCount: TSpeedButton;
    bbChangeHeadCount: TSpeedButton;
    HeadCount: TcxGridDBColumn;
    EditBarCode: TcxCurrencyEdit;
    CountPanel: TPanel;
    CountLabel: TLabel;
    EditCount: TcxCurrencyEdit;
    HeadCountPanel: TPanel;
    HeadCountLabel: TLabel;
    EditHeadCount: TcxCurrencyEdit;
    PartionGoodsPanel: TPanel;
    PartionGoodsLabel: TLabel;
    EditPartionGoods: TEdit;
    ActionList: TActionList;
    actRefresh: TAction;
    actExit: TAction;
    actChoiceBox: TOpenChoiceForm;
    actUpdateBox: TAction;
    bbChangeBoxCount: TSpeedButton;
    PanelBox: TPanel;
    Label1: TLabel;
    Panel2: TPanel;
    Label2: TLabel;
    EditBoxCount: TcxCurrencyEdit;
    Panel3: TPanel;
    Label3: TLabel;
    EditBoxCode: TcxCurrencyEdit;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure PanelWeight_ScaleDblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CDSAfterOpen(DataSet: TDataSet);
    procedure bbDeleteItemClick(Sender: TObject);
    procedure DBGridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure rgScaleClick(Sender: TObject);
    procedure bbChoice_UnComleteClick(Sender: TObject);
    procedure bbView_allClick(Sender: TObject);
    procedure bbChangeNumberTareClick(Sender: TObject);
    procedure bbChangeLevelNumberClick(Sender: TObject);
    procedure bbChangeCountClick(Sender: TObject);
    procedure bbChangeHeadCountClick(Sender: TObject);
    procedure EditBarCodePropertiesChange(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure EditPartionGoodsExit(Sender: TObject);
    procedure actRefreshExecute(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure actUpdateBoxExecute(Sender: TObject);
    procedure bbChangeBoxCountClick(Sender: TObject);
  private
    Scale_BI: TCasBI;
    Scale_DB: TCasDB;

    function Save_Movement_all:Boolean;
    function GetParams_MovementDesc(BarCode: String):Boolean;
    function GetParams_Goods(isRetail:Boolean;BarCode: String):Boolean;
    procedure Create_Scale;
    procedure Initialize_Scale;
    procedure RefreshDataSet;
    procedure WriteParamsMovement;
    procedure Initialize_afterSave_all;
    procedure Initialize_afterSave_MI;
    procedure myActiveControl;
  public
    function Save_Movement_PersonalComplete(execParams:TParams):Boolean;
    function fGetScale_CurrentWeight:Double;
  end;

var
  MainForm: TMainForm;


implementation
{$R *.dfm}
uses UnilWin,DMMainScale, UtilConst, DialogMovementDesc, GuideGoods,GuideGoodsMovement,UtilPrint
    ,GuideMovement, DialogNumberValue,DialogPersonalComplete;
//------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------
procedure TMainForm.Initialize_afterSave_all;
begin
     EditPartionGoods.Text:='';
     EditBoxCode.Text:=GetArrayList_Value_byName(Default_Array,'BoxCode');
end;
//------------------------------------------------------------------------------------------------
procedure TMainForm.Initialize_afterSave_MI;
begin
     EditCount.Text:='';
     EditHeadCount.Text:='';
     EditBarCode.Text:='';
     EditBoxCount.Text:=GetArrayList_Value_byName(Default_Array,'BoxCount');
     myActiveControl;
end;
//------------------------------------------------------------------------------------------------
procedure TMainForm.myActiveControl;
begin
     if PartionGoodsPanel.Visible
     then ActiveControl:=EditPartionGoods
     else ActiveControl:=EditBarCode;
end;
//------------------------------------------------------------------------------------------------
function TMainForm.Save_Movement_all:Boolean;
var execParams:TParams;
begin
     Result:=false;
     //
     OperDateEdit.Text:=DateToStr(gpInitialize_OperDate(ParamsMovement));
     //
     if MessageDlg('Документ попадет в смену за <'+OperDateEdit.Text+'>.Продолжить?',mtConfirmation,mbYesNoCancel,0) <> 6
     then exit;

     if DMMainScaleForm.gpInsert_Movement_all(ParamsMovement) then
     begin
          //
          Create_ParamsPersonalComplete(execParams);
          execParams.ParamByName('MovementId').AsInteger:=ParamsMovement.ParamByName('MovementId').AsInteger;
          execParams.ParamByName('InvNumber').AsString:=ParamsMovement.ParamByName('InvNumber').AsString;
          execParams.ParamByName('OperDate').AsDateTime:=ParamsMovement.ParamByName('OperDate').AsDateTime;
          execParams.ParamByName('MovementDescId').AsInteger:=ParamsMovement.ParamByName('MovementDescId').AsInteger;
          execParams.ParamByName('FromName').AsString:=ParamsMovement.ParamByName('FromName').AsString;
          execParams.ParamByName('ToName').AsString:=ParamsMovement.ParamByName('ToName').AsString;
          Save_Movement_PersonalComplete(execParams);
          execParams.Free;
          //
             //Print
             Print_Movemenet (ParamsMovement.ParamByName('MovementDescId').AsInteger
                            , ParamsMovement.ParamByName('MovementId_begin').AsInteger
                            , 1    // myPrintCount
                            , TRUE // isPreview
                              );
          //
          //EDI
          if ParamsMovement.ParamByName('isEdiInvoice').asBoolean=TRUE then SendEDI_Invoice (ParamsMovement.ParamByName('MovementId_begin').AsInteger);
          if ParamsMovement.ParamByName('isEdiOrdspr').asBoolean=TRUE then SendEDI_OrdSpr (ParamsMovement.ParamByName('MovementId_begin').AsInteger);
          if ParamsMovement.ParamByName('isEdiDesadv').asBoolean=TRUE then SendEDI_Desadv (ParamsMovement.ParamByName('MovementId_begin').AsInteger);

          //Initialize or Empty
          //НЕ будем автоматов открывать предыдущий док.
          //ParamsMovement.ParamByName('MovementId').AsInteger:=0;//!!!может и ненадо!!!
          DMMainScaleForm.gpGet_Scale_Movement(ParamsMovement,FALSE,FALSE);//isLast=FALSE,isNext=FALSE
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
function TMainForm.Save_Movement_PersonalComplete(execParams:TParams):Boolean;
begin
     Result:= GetArrayList_Value_byName(Default_Array,'isPersonalComplete') = AnsiUpperCase('TRUE');
     if Result then
     begin
          Result:= DialogPersonalCompleteForm.Execute(execParams);
          if Result then
          begin
               DMMainScaleForm.gpUpdate_Scale_Movement_PersonalComlete(execParams)
          end;
     end;
end;
//------------------------------------------------------------------------------------------------
function TMainForm.GetParams_MovementDesc(BarCode: String):Boolean;
var MovementId_save:Integer;
begin
     MovementId_save:=ParamsMovement.ParamByName('MovementId').AsInteger;
     //
     if ParamsMovement.ParamByName('MovementId').AsInteger=0
     then if ParamsMovement.ParamByName('MovementDescId').AsInteger=0
          then ParamsMovement.ParamByName('MovementDescNumber').AsString:=GetArrayList_Value_byName(Default_Array,'MovementNumber')
          else
     else if (DMMainScaleForm.gpUpdate_Scale_Movement_check(ParamsMovement)=false)
          then begin
               //ShowMessage ('Ошибка.'+#10+#13+'Документ взвешивания № <'+ParamsMovement.ParamByName('InvNumber').AsString+'>  от <'+DateToStr(ParamsMovement.ParamByName('OperDate_Movement').AsDateTime)+'> не закрыт.'+#10+#13+'Изменение параметров не возможно.');
               //Result:=false;
               if MessageDlg('Текущее взвешивание не закрыто.'+#10+#13+'Действительно перейти к созданию <Нового> взвешивания?',mtConfirmation,mbYesNoCancel,0) <> 6
               then begin Result:=false;exit;end;
          end;
     //
     Result:=DialogMovementDescForm.Execute(BarCode);
     if Result then
     begin
          if ParamsMovement.ParamByName('MovementId').AsInteger<>0
          then DMMainScaleForm.gpInsertUpdate_Scale_Movement(ParamsMovement);
          //
          WriteParamsMovement;
          //
          if MovementId_save <> 0 then
          begin
               RefreshDataSet;
               Initialize_afterSave_all;
               Initialize_afterSave_MI;
          end;
     end;
     myActiveControl;
end;
{------------------------------------------------------------------------}
function TMainForm.GetParams_Goods(isRetail:Boolean;BarCode: String):Boolean;
begin
     Result:=false;
     //
     if ParamsMovement.ParamByName('MovementDescId').asInteger=0
     then if GetParams_MovementDesc('')=false then exit;
     //
     //если партия с ошибкой
     if Recalc_PartionGoods(EditPartionGoods) = FALSE then
     begin
          PanelMovementDesc.Caption:='Ошибка.Не определена <ПАРТИЯ СЫРЬЯ>';
          ActiveControl:=EditPartionGoods;
          exit;
     end
     else WriteParamsMovement;
     //
     //если есть ШК - параметры товара определяются из него
     if trim(BarCode) <> ''
     then
        if isRetail = TRUE then
        begin
             //в ШК - закодированый товар + кол-во, т.е. для Retail
             Result:=DMMainScaleForm.gpGet_Scale_GoodsRetail(ParamsMovement,ParamsMI,BarCode);
             if Result then
             begin
                   ParamsMI.ParamByName('Count').AsFloat:=0;
                   ParamsMI.ParamByName('HeadCount').AsFloat:=0;
                   ParamsMI.ParamByName('PartionGoods').AsString:='';
                   try ParamsMI.ParamByName('BoxCount').AsFloat:=StrToFloat(EditBoxCount.Text);except ParamsMI.ParamByName('BoxCount').AsFloat:=0;end;
                   try ParamsMI.ParamByName('BoxCode').AsFloat:=StrToFloat(EditBoxCode.Text);except ParamsMI.ParamByName('BoxCode').AsFloat:=0;end;
                   //сохранение MovementItem
                   DMMainScaleForm.gpInsert_Scale_MI(ParamsMovement,ParamsMI);
                   Initialize_afterSave_MI;
                   RefreshDataSet;
                   WriteParamsMovement;
                   CDS.First;
             end;
             myActiveControl;
             exit;//!!!выход!!! т.к. открывать диалог для параметров товара и проверять есть ли там сканируемый товар - пока не надо
        end
        else
            begin
                 //в ШК - Id товара или товар+вид товара
                 DMMainScaleForm.gpGet_Scale_Goods(ParamsMI,BarCode);
                 if ParamsMI.ParamByName('GoodsId').AsInteger=0 then
                 begin
                      ShowMessage('Ошибка.Товар не найден.');
                      Result:=false;
                      myActiveControl;
                      exit;
                 end;
            end
     else EmptyValuesParams(ParamsMI); //очистили предыдущие и откроем диалог для ввода всех параметров товара


     //
     ParamsMI.ParamByName('RealWeight_Get').AsFloat:=fGetScale_CurrentWeight;
     try ParamsMI.ParamByName('Count').AsFloat:=StrToFloat(EditCount.Text);except ParamsMI.ParamByName('Count').AsFloat:=0;end;
     try ParamsMI.ParamByName('HeadCount').AsFloat:=StrToFloat(EditHeadCount.Text);except ParamsMI.ParamByName('HeadCount').AsFloat:=0;end;
     try ParamsMI.ParamByName('BoxCount').AsFloat:=StrToFloat(EditBoxCount.Text);except ParamsMI.ParamByName('BoxCount').AsFloat:=0;end;
     try ParamsMI.ParamByName('BoxCode').AsFloat:=StrToFloat(EditBoxCode.Text);except ParamsMI.ParamByName('BoxCode').AsFloat:=0;end;

     ParamsMI.ParamByName('PartionGoods').AsString:=trim(EditPartionGoods.Text);
     //
     if ParamsMovement.ParamByName('OrderExternalId').AsInteger<>0
     then
         // Диалог для параметров товара из списка заявки + в нем сохранение MovementItem
         if GuideGoodsMovementForm.Execute(ParamsMovement) = TRUE
         then begin
                    Result:=true;
                    RefreshDataSet;
                    WriteParamsMovement;
                    CDS.First;
              end
         else
     else
         // Диалог для параметров товара из списка всех товаров + в нем сохранение MovementItem
         if GuideGoodsForm.Execute(ParamsMovement) = TRUE
         then begin
                    Result:=true;
                    RefreshDataSet;
                    WriteParamsMovement;
                    CDS.First;
              end;
     Initialize_afterSave_MI;
end;
//------------------------------------------------------------------------------------------------
procedure TMainForm.bbChangeCountClick(Sender: TObject);
var execParams:TParams;
begin
     // выход
     if CDS.FieldByName('MovementItemId').AsInteger = 0 then
     begin
          ShowMessage('Ошибка.Элемент взвешивания не выбран.');
          exit;
     end;
     //
     execParams:=nil;
     ParamAddValue(execParams,'inMovementItemId',ftInteger,CDS.FieldByName('MovementItemId').AsInteger);
     ParamAddValue(execParams,'inDescCode',ftString,'zc_MIFloat_Count');

     with DialogNumberValueForm do
     begin
          NumberValueLabel.Caption:='Количество пакетов';
          ActiveControl:=NumberValueEdit;
          NumberValueEdit.Text:=CDS.FieldByName('Count').AsString;
          if not Execute then begin execParams.Free;exit;end;
          //
          ParamAddValue(execParams,'inValueData',ftFloat,StrToFloat(NumberValueEdit.Text));
          DMMainScaleForm.gpUpdate_Scale_MIFloat(execParams);
          //
     end;
     //
     execParams.Free;
     //
     RefreshDataSet;
end;
{------------------------------------------------------------------------}
procedure TMainForm.bbChangeHeadCountClick(Sender: TObject);
var execParams:TParams;
begin
     // выход
     if CDS.FieldByName('MovementItemId').AsInteger = 0 then
     begin
          ShowMessage('Ошибка.Элемент взвешивания не выбран.');
          exit;
     end;
     //
     execParams:=nil;
     ParamAddValue(execParams,'inMovementItemId',ftInteger,CDS.FieldByName('MovementItemId').AsInteger);
     ParamAddValue(execParams,'inDescCode',ftString,'zc_MIFloat_HeadCount');

     with DialogNumberValueForm do
     begin
          NumberValueLabel.Caption:='Количество голов';
          ActiveControl:=NumberValueEdit;
          NumberValueEdit.Text:=CDS.FieldByName('HeadCount').AsString;
          if not Execute then begin execParams.Free;exit;end;
          //
          ParamAddValue(execParams,'inValueData',ftFloat,StrToFloat(NumberValueEdit.Text));
          DMMainScaleForm.gpUpdate_Scale_MIFloat(execParams);
          //
     end;
     //
     execParams.Free;
     //
     RefreshDataSet;
end;
{------------------------------------------------------------------------}
procedure TMainForm.bbChangeBoxCountClick(Sender: TObject);
var execParams:TParams;
begin
     // выход
     if CDS.FieldByName('MovementItemId').AsInteger = 0 then
     begin
          ShowMessage('Ошибка.Элемент взвешивания не выбран.');
          exit;
     end;
     //
     execParams:=nil;
     ParamAddValue(execParams,'inMovementItemId',ftInteger,CDS.FieldByName('MovementItemId').AsInteger);
     ParamAddValue(execParams,'inDescCode',ftString,'zc_MIFloat_BoxCount');

     with DialogNumberValueForm do
     begin
          NumberValueLabel.Caption:='Количество упак.тары';
          ActiveControl:=NumberValueEdit;
          NumberValueEdit.Text:=CDS.FieldByName('BoxCount').AsString;
          if not Execute then begin execParams.Free;exit;end;
          //
          ParamAddValue(execParams,'inValueData',ftFloat,StrToFloat(NumberValueEdit.Text));
          DMMainScaleForm.gpUpdate_Scale_MIFloat(execParams);
          //
     end;
     //
     execParams.Free;
     //
     RefreshDataSet;
end;
{------------------------------------------------------------------------}
procedure TMainForm.bbChangeLevelNumberClick(Sender: TObject);
var execParams:TParams;
begin
     // выход
     if CDS.FieldByName('MovementItemId').AsInteger = 0 then
     begin
          ShowMessage('Ошибка.Элемент взвешивания не выбран.');
          exit;
     end;
     //
     execParams:=nil;
     ParamAddValue(execParams,'inMovementItemId',ftInteger,CDS.FieldByName('MovementItemId').AsInteger);
     ParamAddValue(execParams,'inDescCode',ftString,'zc_MIFloat_LevelNumber');

     with DialogNumberValueForm do
     begin
          NumberValueLabel.Caption:='№ Шар';
          ActiveControl:=NumberValueEdit;
          NumberValueEdit.Text:=CDS.FieldByName('LevelNumber').AsString;
          if not Execute then begin execParams.Free;exit;end;
          //
          ParamAddValue(execParams,'inValueData',ftFloat,StrToFloat(NumberValueEdit.Text));
          DMMainScaleForm.gpUpdate_Scale_MIFloat(execParams);
          //
     end;
     //
     execParams.Free;
     //
     RefreshDataSet;
end;
{------------------------------------------------------------------------}
procedure TMainForm.bbChangeNumberTareClick(Sender: TObject);
var execParams:TParams;
begin
     // выход
     if CDS.FieldByName('MovementItemId').AsInteger = 0 then
     begin
          ShowMessage('Ошибка.Элемент взвешивания не выбран.');
          exit;
     end;
     //
     execParams:=nil;
     ParamAddValue(execParams,'inMovementItemId',ftInteger,CDS.FieldByName('MovementItemId').AsInteger);
     ParamAddValue(execParams,'inDescCode',ftString,'zc_MIFloat_BoxNumber');

     with DialogNumberValueForm do
     begin
          NumberValueLabel.Caption:='№ Ящика';
          ActiveControl:=NumberValueEdit;
          NumberValueEdit.Text:=CDS.FieldByName('BoxNumber').AsString;
          if not Execute then begin execParams.Free;exit;end;
          //
          ParamAddValue(execParams,'inValueData',ftFloat,StrToFloat(NumberValueEdit.Text));
          DMMainScaleForm.gpUpdate_Scale_MIFloat(execParams);
          //
     end;
     //
     execParams.Free;
     //
     RefreshDataSet;
end;
{------------------------------------------------------------------------}
procedure TMainForm.bbChoice_UnComleteClick(Sender: TObject);
begin
     if GuideMovementForm.Execute(ParamsMovement,TRUE)//isChoice=TRUE
     then begin
               WriteParamsMovement;
               RefreshDataSet;
               CDS.First;
          end;
     myActiveControl;
end;
{------------------------------------------------------------------------}
procedure TMainForm.bbView_allClick(Sender: TObject);
begin
     GuideMovementForm.Execute(ParamsMovement,FALSE);//isChoice=FALSE
     myActiveControl;
end;
{------------------------------------------------------------------------}
procedure TMainForm.actRefreshExecute(Sender: TObject);
begin
    RefreshDataSet;
    WriteParamsMovement;
end;
//------------------------------------------------------------------------------------------------
procedure TMainForm.actUpdateBoxExecute(Sender: TObject);
var execParams:TParams;
begin
     // выход
     if CDS.FieldByName('MovementItemId').AsInteger = 0 then
     begin
          ShowMessage('Ошибка.Элемент взвешивания не выбран.');
          exit;
     end;
     //
     actChoiceBox.GuiParams.ParamByName('Key').Value:=CDS.FieldByName('BoxId').AsString;
     actChoiceBox.GuiParams.ParamByName('TextValue').Value:=CDS.FieldByName('BoxName').AsString;
     //
     if actChoiceBox.Execute
     then begin
               execParams:=nil;
               ParamAddValue(execParams,'inMovementItemId',ftInteger,CDS.FieldByName('MovementItemId').AsInteger);
               ParamAddValue(execParams,'inDescCode',ftString,'zc_MILinkObject_Box');
               ParamAddValue(execParams,'inObjectId',ftInteger,actChoiceBox.GuiParams.ParamByName('Key').Value);
               if DMMainScaleForm.gpUpdate_Scale_MILinkObject(execParams) then
               begin
                    CDS.Edit;
                    CDS.FieldByName('BoxId').AsString:=actChoiceBox.GuiParams.ParamByName('Key').Value;
                    CDS.FieldByName('BoxName').AsString:=actChoiceBox.GuiParams.ParamByName('TextValue').Value;
                    CDS.Post;
               end;
               execParams.Free;
     end;
end;
//------------------------------------------------------------------------------------------------
procedure TMainForm.CDSAfterOpen(DataSet: TDataSet);
var bm: TBookmark;
    AmountPartnerWeight,AmountWeight,RealWeight,WeightTare: Double;
begin
  with DataSet do
    try
       //
       bm:=GetBookmark; DisableControls;
       First;
       AmountPartnerWeight:=0;
       AmountWeight:=0;
       RealWeight:=0;
       WeightTare:=0;
       while not EOF do begin
          if FieldByName('isErased').AsBoolean=false then
          begin
            AmountPartnerWeight:=AmountPartnerWeight+FieldByName('AmountPartnerWeight').AsFloat;
            AmountWeight:=AmountWeight+FieldByName('AmountWeight').AsFloat;
            RealWeight:=RealWeight+FieldByName('RealWeightWeight').AsFloat;
            WeightTare:=WeightTare+FieldByName('WeightTareTotal').AsFloat;
          end;
          //
          Next;
       end;
    finally
       GotoBookmark(bm);
       FreeBookmark(bm);
       EnableControls;
    end;
    PanelAmountPartnerWeight.Caption:=FormatFloat(',0.000#'+' кг.',AmountPartnerWeight);
    PanelAmountWeight.Caption:=FormatFloat(',0.000#'+' кг.',AmountWeight);
    PanelRealWeight.Caption:=FormatFloat(',0.000#'+' кг.',RealWeight);
    PanelWeightTare.Caption:=FormatFloat(',0.000#'+' кг.',WeightTare);
end;
//------------------------------------------------------------------------------------------------
procedure TMainForm.DBGridDrawColumnCell(Sender: TObject; const Rect: TRect;DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
     if CDS.FieldByName('isErased').AsBoolean=true then
     with (Sender as TDBGrid).Canvas do
     begin
          Font.Color:=clRed;
          FillRect(Rect);
          if (Column.Alignment=taLeftJustify)or(Rect.Left>=Rect.Right - LengTh(Column.Field.Text))
          then TextOut(Rect.Left+2, Rect.Top+2, Column.Field.Text)
          else TextOut(Rect.Right - TextWidth(Column.Field.Text) - 2, Rect.Top+2 , Column.Field.Text);
     end;
end;
//---------------------------------------------------------------------------------------------
procedure TMainForm.EditBarCodePropertiesChange(Sender: TObject);
begin
     EditBarCode.Text:=trim(EditBarCode.Text);
     if Length(EditBarCode.Text)>=13
     then begin
               //Проверка <Контрольная сумма>
               if CheckBarCode(trim(EditBarCode.Text)) = FALSE
               then begin
                  EditBarCode.Text:='';
                  ActiveControl:=EditBarCode;
                  exit;
               end;
               //если в ШК - Id товара или товар+вид товара
               if Pos(zc_BarCodePref_Object,EditBarCode.Text)=1
               then begin
                         GetParams_Goods(FALSE,EditBarCode.Text);//isRetail=FALSE
                         EditBarCode.Text:='';
                    end
               else
                   //если в ШК - Id документа заявки
                   if Pos(zc_BarCodePref_Movement,EditBarCode.Text)=1
                   then begin
                             GetParams_MovementDesc(EditBarCode.Text);
                             EditBarCode.Text:='';
                        end
                   else begin
                            //если в ШК - закодированый товар + кол-во, т.е. для Retail
                             GetParams_Goods(TRUE,EditBarCode.Text);//isRetail=TRUE
                             EditBarCode.Text:='';
                        end;
     end;
end;
//---------------------------------------------------------------------------------------------
procedure TMainForm.EditPartionGoodsExit(Sender: TObject);
begin
     //если партия с ошибкой
     if Recalc_PartionGoods(EditPartionGoods) = FALSE then
     begin
          PanelMovementDesc.Caption:='Ошибка.Не определена <ПАРТИЯ СЫРЬЯ>';
          ActiveControl:=EditPartionGoods;
     end
     else WriteParamsMovement;
end;
//---------------------------------------------------------------------------------------------
procedure TMainForm.FormCreate(Sender: TObject);
begin
  Caption:='Экспедиция ('+GetFileVersionString(ParamStr(0))+') - <'+DMMainScaleForm.gpGet_Scale_User+'>';
  //global Initialize
  gpInitialize_Const;
  //global Initialize Array
  Default_Array:=       DMMainScaleForm.gpSelect_ToolsWeighing_onLevelChild(SettingMain.BrancCode,'Default');
  Service_Array:=       DMMainScaleForm.gpSelect_ToolsWeighing_onLevelChild(SettingMain.BrancCode,'Service');

  PriceList_Array:=     DMMainScaleForm.gpSelect_ToolsWeighing_onLevelChild(SettingMain.BrancCode,'PriceList');
  TareCount_Array:=     DMMainScaleForm.gpSelect_ToolsWeighing_onLevelChild(SettingMain.BrancCode,'TareCount');
  TareWeight_Array:=    DMMainScaleForm.gpSelect_ToolsWeighing_onLevelChild(SettingMain.BrancCode,'TareWeight');
  ChangePercentAmount_Array:= DMMainScaleForm.gpSelect_ToolsWeighing_onLevelChild(SettingMain.BrancCode,'ChangePercentAmount');
  GoodsKind_Array:=     DMMainScaleForm.gpSelect_Scale_GoodsKindWeighing;
  //global Initialize
  Create_ParamsMI(ParamsMI);
  //global Initialize
  Create_Scale;
  //
  //local Movement Initialize
  OperDateEdit.Text:=DateToStr(ParamsMovement.ParamByName('OperDate').AsDateTime);
  //local Control Form
  Initialize_afterSave_all;
  Initialize_afterSave_MI;
  //local visible
  PartionGoodsPanel.Visible:=StrToInt(GetArrayList_Value_byName(Default_Array,'InfoMoneyId_sale')) = zc_Enum_InfoMoney_30201; // Доходы + Мясное сырье + Мясное сырье
  HeadCountPanel.Visible:=PartionGoodsPanel.Visible;
  BarCodePanel.Visible:=not PartionGoodsPanel.Visible;
  PanelBox.Visible:=GetArrayList_Value_byName(Default_Array,'isBox') = AnsiUpperCase('TRUE');

  bbChangeHeadCount.Visible:=HeadCountPanel.Visible;
  bbChangeCount.Visible:=not bbChangeHeadCount.Visible;
  //
  with spSelect do
  begin
       StoredProcName:='gpSelect_Scale_MI';
       OutputType:=otDataSet;
       Params.AddParam('inMovementId', ftInteger, ptInput,0);
  end;
end;
//------------------------------------------------------------------------------------------------
procedure TMainForm.WriteParamsMovement;
begin
  with ParamsMovement do begin

    if ParamByName('MovementId').AsInteger=0
    then PanelMovement.Caption:='Новый <Документ>.'
    else PanelMovement.Caption:='Документ № <'+ParamByName('InvNumber').AsString+'>  от <'+DateToStr(ParamByName('OperDate_Movement').AsDateTime)+'>';

    PanelMovementDesc.Caption:=ParamByName('MovementDescName_master').asString;
    PanelPriceList.Caption:=ParamByName('PriceListName').asString;

    if ParamByName('calcPartnerId').AsInteger<>0
    then PanelPartner.Caption:='  ('+IntToStr(ParamByName('calcPartnerCode').asInteger)+') '+ParamByName('calcPartnerName').asString
    else PanelPartner.Caption:='';

    if ParamByName('ContractId').AsInteger<>0
    then PanelContract.Caption:=' № '+ParamByName('ContractNumber').asString
                               +' '+ParamByName('ContractTagName').asString
                               +'  ('+ParamByName('ContractCode').asString+')'
                               //+'  ('+ParamByName('PaidKindName').asString+')'
    else PanelContract.Caption:='';

    if ParamByName('ChangePercent').AsFloat<=0
    then LabelPartner.Caption:='Контрагент - скидка <'+FloatToStr(-1*ParamByName('ChangePercent').asFloat)+'%>'
    else LabelPartner.Caption:='Контрагент - наценка <'+FloatToStr(ParamByName('ChangePercent').asFloat)+'%>';


    PanelTotalSumm.Caption:=FormatFloat(',0.00##',ParamByName('TotalSumm').asFloat);

    if ParamByName('OrderExternalId').AsInteger<>0
    then PanelOrderExternal.Caption:='  '+ParamByName('OrderExternalName_master').asString
    else PanelOrderExternal.Caption:='';

  end;
end;
//------------------------------------------------------------------------------------------------
procedure TMainForm.RefreshDataSet;
begin
  with spSelect do
  begin
       Params.ParamByName('inMovementId').Value:=ParamsMovement.ParamByName('MovementId').AsInteger;
       Execute;
  end;
end;
//------------------------------------------------------------------------------------------------
procedure TMainForm.Create_Scale;
var i:Integer;
    number:Integer;
begin
  Scale_DB:=TCasDB.Create(self);
  Scale_BI:=TCasBI.Create(self);
  SettingMain.IndexScale_old:=-1;

  number:=-1;
  for i := 0 to Length(Scale_Array)-1 do
  begin
    if Scale_Array[i].COMPort>=0
    then rgScale.Items.Add(Scale_Array[i].ScaleName+' : COM' +IntToStr(Scale_Array[i].COMPort))
    else rgScale.Items.Add(Scale_Array[i].ScaleName+' : COM?');
    if Scale_Array[i].COMPort=SettingMain.DefaultCOMPort then number:=i;
  end;
  rgScale.ItemIndex:=number;
end;
//------------------------------------------------------------------------------------------------
procedure TMainForm.Initialize_Scale;
begin
     //Close prior
     if SettingMain.IndexScale_old>=0
     then begin
               if Scale_Array[SettingMain.IndexScale_old].ScaleType=stBI then Scale_BI.Active := 0;
               if Scale_Array[SettingMain.IndexScale_old].ScaleType=stDB then Scale_DB.Active := 0;
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

     //
     PanelWeight_Scale.Caption:='';
     //
     SettingMain.IndexScale_old:=rgScale.ItemIndex;
     //
     MyDelay_two(500);
end;
//------------------------------------------------------------------------------------------------
procedure TMainForm.rgScaleClick(Sender: TObject);
begin
     Initialize_Scale;
     myActiveControl;
end;
//------------------------------------------------------------------------------------------------
procedure TMainForm.PanelWeight_ScaleDblClick(Sender: TObject);
begin
   fGetScale_CurrentWeight;
end;
//------------------------------------------------------------------------------------------------
function TMainForm.fGetScale_CurrentWeight:Double;
begin
     // открываем ВЕСЫ, только когда НУЖЕН вес
     //Initialize_Scale_DB;
     // считывание веса
     try
        if Scale_Array[rgScale.ItemIndex].ScaleType = stBI
        then Result:=Scale_BI.Weight
             else if Scale_Array[rgScale.ItemIndex].ScaleType = stDB
                  then Result:=Scale_DB.Weight
                  else Result:=0;
     except Result:=0;end;
     // закрываем ВЕСЫ
     // Scale_DB.Active:=0;
     //
//*****
     if (System.Pos('ves=',ParamStr(1))>0)and(Result=0)
     then Result:=StrToFloat(Copy(ParamStr(1), 5, LengTh(ParamStr(1))-5));
     if (System.Pos('ves=',ParamStr(2))>0)and(Result=0)
     then Result:=StrToFloat(Copy(ParamStr(2), 5, LengTh(ParamStr(2))-5));
//*****
     PanelWeight_Scale.Caption:=FloatToStr(Result);
end;
//------------------------------------------------------------------------------------------------
procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
begin
     if Key = VK_F5 then Save_Movement_all;
     if Key = VK_F2 then GetParams_MovementDesc('');
     if Key = VK_SPACE then begin Key:= 0; GetParams_Goods(FALSE,''); end;//isRetail=FALSE
     //
     if ShortCut(Key, Shift) = 24659 then
     begin
          gc_isDebugMode := not gc_isDebugMode;
          if gc_isDebugMode
          then ShowMessage('Установлен режим отладки')
          else ShowMessage('Снят режим отладки');
     end;
end;
{------------------------------------------------------------------------}
procedure TMainForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
     if Key=#32 then Key:=#0;
end;
{------------------------------------------------------------------------}
procedure TMainForm.FormShow(Sender: TObject);
begin
     RefreshDataSet;
     WriteParamsMovement;
     myActiveControl;
end;
{------------------------------------------------------------------------}
procedure TMainForm.bbDeleteItemClick(Sender: TObject);
begin
     // выход
     if CDS.FieldByName('MovementItemId').AsInteger = 0 then
     begin
          ShowMessage('Ошибка.Элемент взвешивания не выбран.');
          exit;
     end;
     //
     if CDS.FieldByName('isErased').AsBoolean=false
     then
         if MessageDlg('Действительно удалить? ('+CDS.FieldByName('GoodsName').AsString+' '+CDS.FieldByName('GoodsKindName').AsString+') вес=('+CDS.FieldByName('RealWeight').AsString+')'
                ,mtConfirmation,mbYesNoCancel,0) <> 6
         then exit
         else begin
                   DMMainScaleForm.gpUpdate_Scale_MI_Erased(CDS.FieldByName('MovementItemId').AsInteger,true);
                   RefreshDataSet;
                   WriteParamsMovement;
              end
     else
         if MessageDlg('Действительно воостановить? ('+CDS.FieldByName('GoodsName').AsString+' '+CDS.FieldByName('GoodsKindName').AsString+') вес=('+CDS.FieldByName('RealWeight').AsString+')'
                ,mtConfirmation,mbYesNoCancel,0) <> 6
         then exit
         else begin
                   DMMainScaleForm.gpUpdate_Scale_MI_Erased(CDS.FieldByName('MovementItemId').AsInteger,false);
                   RefreshDataSet;
                   WriteParamsMovement;
              end
end;
{------------------------------------------------------------------------}
procedure TMainForm.actExitExecute(Sender: TObject);
begin Close;end;
{------------------------------------------------------------------------}
end.
