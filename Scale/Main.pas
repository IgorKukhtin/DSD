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
 ,SysScalesLib_TLB,AxLibLib_TLB, APScale_TLB
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
    bbChangeNumberTare: TSpeedButton;
    bbChangeLevelNumber: TSpeedButton;
    infoPanelTotalSumm: TPanel;
    gbRealWeight: TGroupBox;
    PanelRealWeight: TPanel;
    gbWeightTare: TGroupBox;
    PanelWeightTare: TPanel;
    gbAmountPartnerWeight: TGroupBox;
    PanelAmountPartnerWeight: TPanel;
    gbTotalSumm: TGroupBox;
    PanelTotalSumm: TPanel;
    PanelSaveItem: TPanel;
    BarCodePanel: TPanel;
    BarCodeLabel: TLabel;
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
    bbChangeCountPack: TSpeedButton;
    bbChangeHeadCount: TSpeedButton;
    HeadCount: TcxGridDBColumn;
    EditBarCode: TcxCurrencyEdit;
    PanelCountPack: TPanel;
    LabelCountPack: TLabel;
    EditCountPack: TcxCurrencyEdit;
    HeadCountPanel: TPanel;
    HeadCountLabel: TLabel;
    EditHeadCount: TcxCurrencyEdit;
    PanelPartionGoods: TPanel;
    LabelPartionGoods: TLabel;
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
    Panel25: TPanel;
    Label17: TLabel;
    OperDateEdit: TcxDateEdit;
    bbChangePartionGoods: TSpeedButton;
    bbSale_Order_all: TSpeedButton;
    bbSale_Order_diff: TSpeedButton;
    TransportPanel: TPanel;
    BarCodeTransportPanel: TPanel;
    BarCodeTransportLabel: TLabel;
    EditBarCodeTransport: TcxButtonEdit;
    infoPanelCar: TPanel;
    CarLabel: TLabel;
    PanelCar: TPanel;
    infoPanelPersonalDriver: TPanel;
    PersonalDriverLabel: TLabel;
    PanelPersonalDriver: TPanel;
    infoPanelRoute: TPanel;
    RouteLabel: TLabel;
    PanelRoute: TPanel;
    infoInvNumberTransportPanel: TPanel;
    InvNumberTransportLabel: TLabel;
    PanelInvNumberTransport: TPanel;
    isBarCode: TcxGridDBColumn;
    isPromo: TcxGridDBColumn;
    bbUpdateUnit: TSpeedButton;
    spProtocol_isExit: TdsdStoredProc;
    FormParams: TdsdFormParams;
    TimerProtocol_isProcess: TTimer;
    spProtocol_isProcess: TdsdStoredProc;
    bbReestrKind_PartnerOut: TSpeedButton;
    actReestrStart: TdsdOpenForm;
    actReestrPartnerIn: TdsdOpenForm;
    actReestrRemakeIn: TdsdOpenForm;
    bbReestrKind_PartnerOut_two: TSpeedButton;
    bbReestrKind_PartnerOut_three: TSpeedButton;
    bbReestrReturn: TSpeedButton;
    actReestrReturnStart: TdsdOpenForm;
    bbUpdatePartner: TSpeedButton;
    TaxDoc: TcxGridDBColumn;
    TaxDoc_calc: TcxGridDBColumn;
    Color_calc: TcxGridDBColumn;
    PanelErasedCount: TPanel;
    Ord: TcxGridDBColumn;
    bbGuideGoodsView: TSpeedButton;
    miFont: TMenuItem;
    miLine16: TMenuItem;
    bbSale_Order_diffTax: TSpeedButton;
    rgLanguage: TRadioGroup;
    infoSubjectDocPanel: TPanel;
    SubjectDocPanel: TPanel;
    SubjectDocLabel: TLabel;
    EditSubjectDoc: TcxButtonEdit;
    actReestrStartTTN: TdsdOpenForm;
    bbReestrStartTTN: TSpeedButton;
    bbReestrPartnerInTTN: TSpeedButton;
    actReestrPartnerInTTN: TdsdOpenForm;
    CountTare1: TcxGridDBColumn;
    CountTare2: TcxGridDBColumn;
    CountTare3: TcxGridDBColumn;
    CountTare4: TcxGridDBColumn;
    CountTare5: TcxGridDBColumn;
    CountTare6: TcxGridDBColumn;
    WeightTare1: TcxGridDBColumn;
    WeightTare2: TcxGridDBColumn;
    WeightTare3: TcxGridDBColumn;
    WeightTare4: TcxGridDBColumn;
    WeightTare5: TcxGridDBColumn;
    WeightTare6: TcxGridDBColumn;
    CountTareTotal: TcxGridDBColumn;
    bbSetPartionGoods: TSpeedButton;
    bbReestrKind_Income: TSpeedButton;
    actReestrIncomeStart: TdsdOpenForm;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure PanelWeight_ScaleDblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CDSAfterOpen(DataSet: TDataSet);
    procedure bbDeleteItemClick(Sender: TObject);
    procedure rgScaleClick(Sender: TObject);
    procedure bbChoice_UnComleteClick(Sender: TObject);
    procedure bbView_allClick(Sender: TObject);
    procedure bbChangeNumberTareClick(Sender: TObject);
    procedure bbChangeLevelNumberClick(Sender: TObject);
    procedure bbChangeCountPackClick(Sender: TObject);
    procedure bbChangeHeadCountClick(Sender: TObject);
    procedure EditBarCodePropertiesChange(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure EditPartionGoodsExit(Sender: TObject);
    procedure actRefreshExecute(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure actUpdateBoxExecute(Sender: TObject);
    procedure bbChangeBoxCountClick(Sender: TObject);
    procedure bbChangePartionGoodsClick(Sender: TObject);
    procedure bbSale_Order_allClick(Sender: TObject);
    procedure bbSale_Order_diffClick(Sender: TObject);
    procedure EditBarCodeTransportPropertiesChange(Sender: TObject);
    procedure EditBarCodeTransportExit(Sender: TObject);
    procedure EditBarCodeTransportPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure bbUpdateUnitClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TimerProtocol_isProcessTimer(Sender: TObject);
    procedure bbUpdatePartnerClick(Sender: TObject);
    procedure bbGuideGoodsViewClick(Sender: TObject);
    procedure miFontClick(Sender: TObject);
    procedure bbSale_Order_diffTaxClick(Sender: TObject);
    procedure EditSubjectDocPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure bbSetPartionGoodsClick(Sender: TObject);
    procedure EditPartionGoodsEnter(Sender: TObject);
  private
    //aTest: Boolean;
    Scale_AP: IAPScale;
    Scale_BI: TCasBI;
    Scale_DB: TCasDB;
    Scale_Zeus: TZeus;
    err_count: Integer;
    fStartBarCode : Boolean;

    function Save_Movement_all:Boolean;
    function Print_Movement_afterSave:Boolean;
    function GetParams_MovementDesc(BarCode: String):Boolean;
    function GetParams_Goods (isRetail : Boolean; BarCode : String; isModeSave : Boolean) : Boolean;
    function GetPanelPartnerCaption(execParams:TParams):String;
    procedure Create_Scale;
    procedure Initialize_Scale;
    procedure Initialize_afterSave_all;
    procedure Initialize_afterSave_MI;
    procedure myActiveControl;
    procedure pSetDriverReturn;
    procedure pSetSubjectDoc;

  public
    function Save_Movement_PersonalComplete(execParams:TParams):Boolean;
    function Save_Movement_PersonalLoss(execParams:TParams):Boolean;
    function fGetScale_CurrentWeight:Double;
    function fGetScale_AP_CurrentWeight_cycle : String;

    procedure RefreshDataSet;
    procedure WriteParamsMovement;
  end;

var
  MainForm: TMainForm;

implementation
{$R *.dfm}
uses UnilWin,DMMainScale, UtilConst, DialogMovementDesc
    ,GuideGoods,GuideGoodsPartner,GuideGoodsSticker
    ,GuideGoodsMovement,GuideMovement,GuideMovementTransport, GuidePartner
    ,UtilPrint,DialogNumberValue,DialogStringValue,DialogPersonalComplete,DialogPrint,GuidePersonal, GuideSubjectDoc, DialogDateValue
    ,IdIPWatch, LookAndFillSettings;
//------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------
procedure TMainForm.Initialize_afterSave_all;
begin
     EditPartionGoods.Text:='';
     EditBoxCode.Text:=GetArrayList_Value_byName(Default_Array,'BoxCode');
     //
     {EditBarCodeTransport.Text:='';
     PanelInvNumberTransport.Caption:='';
     PanelPersonalDriver.Caption:='';
     PanelCar.Caption:='';
     PanelRoute.Caption:='';}
end;
//------------------------------------------------------------------------------------------------
procedure TMainForm.Initialize_afterSave_MI;
begin
     EditCountPack.Text:='';
     EditHeadCount.Text:='';
     EditBarCode.Text:='';
     EditBoxCount.Text:=GetArrayList_Value_byName(Default_Array,'BoxCount');
     myActiveControl;
end;
//------------------------------------------------------------------------------------------------
procedure TMainForm.myActiveControl;
begin
     if (PanelPartionGoods.Visible)and(fStartBarCode = false)and(SettingMain.isPartionDate = FALSE)
     then ActiveControl:=EditPartionGoods
     else if BarCodePanel.Visible
          then ActiveControl:=EditBarCode
          else ActiveControl:=cxDBGrid;
end;
//------------------------------------------------------------------------------------------------
procedure TMainForm.miFontClick(Sender: TObject);
begin
  TLookAndFillSettingsForm.Create(nil).Show;
end;
//------------------------------------------------------------------------------------------------
function TMainForm.Save_Movement_all:Boolean;
var execParams:TParams;
begin
     Result:=false;
     //
     OperDateEdit.Text:=DateToStr(DMMainScaleForm.gpGet_Scale_OperDate(ParamsMovement));
     //Проверка
     if SettingMain.isSticker = TRUE
     then begin
         ShowMessage('Ошибка.Проведение документа не предусмотрено.');
         exit;
     end;
     //Проверка
     if ParamsMovement.ParamByName('MovementId').AsInteger=0
     then begin
         ShowMessage('Ошибка.Продукция не взвешена.');
         exit;
     end;
     //Проверка
     if (ParamsMovement.ParamByName('OrderExternalId').AsInteger > 0)
         and(ParamsMovement.ParamByName('isTransport_link').AsBoolean = TRUE)
         and(ParamsMovement.ParamByName('TransportId').AsInteger = 0)
         and(err_count < 3)
     then begin
         err_count:=err_count+1;
         ShowMessage('Ошибка.'+#10+#13+'Не определено значение <Штрих код Путевой лист>.');
         ActiveControl:=EditBarCodeTransport;
         exit;
     end;
     //Проверка
     if (ParamsMovement.ParamByName('MovementDescId').AsInteger = zc_Movement_ReturnIn)
         and(GetArrayList_Value_byName(Default_Array,'isDriverReturn') = AnsiUpperCase('TRUE'))
         and(ParamsMovement.ParamByName('PersonalDriverId').AsInteger=0)
         and(err_count < 3)
     then begin
         err_count:=err_count+1;
         ShowMessage('Ошибка.'+#10+#13+'Не определено значение для возврата <ФИО (водитель/экспедитор)>.');
         pSetDriverReturn;
         exit;
     end;
     //Проверка
     if (ParamsMovement.ParamByName('MovementDescId').AsInteger = zc_Movement_ReturnIn)
         and(ParamsMovement.ParamByName('isTransport_link').AsBoolean = TRUE)
         and(ParamsMovement.ParamByName('TransportId').AsInteger = 0)
         and(err_count < 3)
     then begin
         err_count:=err_count+1;
         ShowMessage('Ошибка.'+#10+#13+'Не определено значение <Штрих код Путевой лист.>.');
         ActiveControl:=EditBarCodeTransport;
         exit;
     end;
     //
     if MessageDlg('Документ попадет в смену за <'+OperDateEdit.Text+'>.Продолжить?',mtConfirmation,mbYesNoCancel,0) <> 6
     then exit;

     //Проверка
     if {((ParamsMovement.ParamByName('MovementDescId').AsInteger = zc_Movement_Send)
      or (ParamsMovement.ParamByName('MovementDescId').AsInteger = zc_Movement_SendOnPrice)
      or (ParamsMovement.ParamByName('MovementDescId').AsInteger = zc_Movement_Loss)
        )
        and}(ParamsMovement.ParamByName('SubjectDocId').AsInteger = 0)
         and(ParamsMovement.ParamByName('isSubjectDoc').AsBoolean = TRUE)
     then begin
         if MessageDlg('Ошибка.'+#10+#13+'Не установлено значение <Основание Возврат>.'+#10+#13+'Хотите исправить?',mtConfirmation,mbYesNoCancel,0) = 6
         then begin pSetSubjectDoc; exit; end;
     end;

     //параметры для списания на сотрудника
     if Save_Movement_PersonalLoss(ParamsMovement) = FALSE then
     begin
         ShowMessage('Ошибка.'+#10+#13+'Для документа <Списание> не определен <Сотрудник>.'+#10+#13+'Документ НЕ будет закрыт.');
         ActiveControl:=cxDBGrid;
         exit;
     end;

     //параметры для печати
     if not DialogPrintForm.Execute(ParamsMovement.ParamByName('MovementDescId').asInteger
                                   ,ParamsMovement.ParamByName('CountMovement').asInteger
                                   ,ParamsMovement.ParamByName('isMovement').asBoolean
                                   ,ParamsMovement.ParamByName('isAccount').asBoolean
                                   ,ParamsMovement.ParamByName('isTransport').asBoolean
                                   ,ParamsMovement.ParamByName('isQuality').asBoolean
                                   ,ParamsMovement.ParamByName('isPack').asBoolean
                                   ,FALSE //ParamsMovement.ParamByName('isPackGross').asBoolean
                                   ,ParamsMovement.ParamByName('isSpec').asBoolean
                                   ,ParamsMovement.ParamByName('isTax').asBoolean
                                   )
     then begin
         //!!!без печати ничего не надо делать!!!
         ShowMessage('Параметры печати не определены.'+#10+#13+'Документ НЕ будет закрыт.');
         exit;
     end;

     //!!!Сохранили документ!!!
     if DMMainScaleForm.gpInsert_Movement_all(ParamsMovement) then
     begin
          //
          //Комплектовщики
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
          //Print and Create Quality + Transport + Tax
          Print_Movement_afterSave;
          //
          //EDI
          if ParamsMovement.ParamByName('isEdiInvoice').asBoolean=TRUE then SendEDI_Invoice (ParamsMovement.ParamByName('MovementId_begin').AsInteger);
          if ParamsMovement.ParamByName('isEdiOrdspr').asBoolean=TRUE then SendEDI_OrdSpr (ParamsMovement.ParamByName('MovementId_begin').AsInteger);
          if ParamsMovement.ParamByName('isEdiDesadv').asBoolean=TRUE then SendEDI_Desadv (ParamsMovement.ParamByName('MovementId_begin').AsInteger);
          //ExportEmail
          if ParamsMovement.ParamByName('isExportEmail').asBoolean=TRUE then Export_Email (ParamsMovement.ParamByName('MovementId_begin').AsInteger);
          //
          //Initialize or Empty
             //НЕ будем автоматов открывать предыдущий док.
          //ParamsMovement.ParamByName('MovementId').AsInteger:=0;//!!!нельзя обнулять, т.к. это будет значить isLast=TRUE!!!
          //DMMainScaleForm.gpGet_Scale_Movement(ParamsMovement,FALSE,FALSE);//isLast=FALSE,isNext=FALSE
          EmptyValuesParams(ParamsMovement);//!!!кроме даты!!!
          gpInitialize_MovementDesc;
          //
          Initialize_afterSave_all;
          Initialize_afterSave_MI;
          //
          RefreshDataSet;
          WriteParamsMovement;
     end;
     err_count:=0;
end;
//------------------------------------------------------------------------------------------------
function TMainForm.Print_Movement_afterSave:Boolean;
begin
     Result:=true;
     //
     //Movement
     if DialogPrintForm.cbPrintMovement.Checked
     then Result:=Print_Movement (ParamsMovement.ParamByName('MovementDescId').AsInteger
                                , ParamsMovement.ParamByName('MovementId_begin').AsInteger // MovementId
                                , ParamsMovement.ParamByName('MovementId').AsInteger       // MovementId_by
                                , StrToInt(DialogPrintForm.PrintCountEdit.Text) // myPrintCount
                                , DialogPrintForm.cbPrintPreview.Checked        // isPreview
                                //, DialogMovementDescForm.Get_isSendOnPriceIn(ParamsMovement.ParamByName('MovementDescNumber').AsInteger)
                                , ParamsMovement.ParamByName('isSendOnPriceIn').AsBoolean
                                 );
     //
     //Tax
     if (DialogPrintForm.cbPrintTax.Checked) and (Result = TRUE)
     then Result:=Print_Tax (ParamsMovement.ParamByName('MovementDescId').AsInteger
                           , ParamsMovement.ParamByName('MovementId_begin').AsInteger
                           , ParamsMovement.ParamByName('CountTax').AsInteger
                           , DialogPrintForm.cbPrintPreview.Checked
                            );
     //
     //Account
     if (DialogPrintForm.cbPrintAccount.Checked) and (Result = TRUE)
     then Result:=Print_Account (ParamsMovement.ParamByName('MovementDescId').AsInteger
                               , ParamsMovement.ParamByName('MovementId_begin').AsInteger
                               , ParamsMovement.ParamByName('CountAccount').AsInteger
                               , DialogPrintForm.cbPrintPreview.Checked
                                );
     //
     //Pack
     if (DialogPrintForm.cbPrintPack.Checked) and (Result = TRUE)
     then Result:=Print_Pack (ParamsMovement.ParamByName('MovementDescId').AsInteger
                            , ParamsMovement.ParamByName('MovementId_begin').AsInteger // MovementId
                            , ParamsMovement.ParamByName('MovementId').AsInteger       // MovementId_by
                            , ParamsMovement.ParamByName('CountPack').AsInteger
                            , DialogPrintForm.cbPrintPreview.Checked
                             );
     //
     //PackGross
     if (DialogPrintForm.cbPrintPackGross.Checked) and (Result = TRUE)
     then Result:=Print_PackGross (ParamsMovement.ParamByName('MovementDescId').AsInteger
                                 , ParamsMovement.ParamByName('MovementId_begin').AsInteger // MovementId
                                 , ParamsMovement.ParamByName('MovementId').AsInteger       // MovementId_by
                                 , ParamsMovement.ParamByName('CountPack').AsInteger
                                 , DialogPrintForm.cbPrintPreview.Checked
                                  );
     //
     //PrintDiffOrder
     if (DialogPrintForm.cbPrintDiffOrder.Checked) and (Result = TRUE)
     then Result:=Print_Sale_Order(ParamsMovement.ParamByName('OrderExternalId').AsInteger
                                 , ParamsMovement.ParamByName('MovementId').AsInteger
                                 , FALSE
                                 , TRUE
                                  );

     //
     //Spec
     if (DialogPrintForm.cbPrintSpec.Checked) and (Result = TRUE)
     then Result:=Print_Spec (ParamsMovement.ParamByName('MovementDescId').AsInteger
                            , ParamsMovement.ParamByName('MovementId_begin').AsInteger // MovementId
                            , ParamsMovement.ParamByName('MovementId').AsInteger       // MovementId_by
                            , ParamsMovement.ParamByName('CountSpec').AsInteger
                            , DialogPrintForm.cbPrintPreview.Checked
                             );
     //
     //Transport
     if (DialogPrintForm.cbPrintTransport.Checked) and (Result = TRUE)
     then Result:=Print_Transport (ParamsMovement.ParamByName('MovementDescId').AsInteger
                                 , 0                                                        // MovementId
                                 , ParamsMovement.ParamByName('MovementId_begin').AsInteger // MovementId_sale
                                 , ParamsMovement.ParamByName('OperDate').AsDateTime
                                 , ParamsMovement.ParamByName('CountTransport').AsInteger
                                 , DialogPrintForm.cbPrintPreview.Checked
                                  );
     //
     //Quality
     if (DialogPrintForm.cbPrintQuality.Checked) and (Result = TRUE)
     then Result:=Print_Quality (ParamsMovement.ParamByName('MovementDescId').AsInteger
                               , ParamsMovement.ParamByName('MovementId_begin').AsInteger
                               , ParamsMovement.ParamByName('CountQuality').AsInteger
                               , DialogPrintForm.cbPrintPreview.Checked
                                );
     //
     if not Result then ShowMessage('Документ сохранен.');
;
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
function TMainForm.Save_Movement_PersonalLoss(execParams:TParams):Boolean;
var lParams:TParams;
begin
     Result:= (GetArrayList_Value_byName(Default_Array,'isPersonalLoss') = AnsiUpperCase('FALSE'))
           or (execParams.ParamByName('MovementDescId').asInteger <> zc_Movement_Loss);
     if not Result then
     begin
          Create_ParamsPersonal(lParams,'');
          //
          Result:= GuidePersonalForm.Execute(lParams);
          if Result then
          begin
               PanelPartner.Caption:='('+IntToStr(lParams.ParamByName('PersonalCode').asInteger)+')'+lParams.ParamByName('PersonalName').asString + ' *** ' + GetPanelPartnerCaption(ParamsMovement);
               ParamAddValue(lParams,'MovementId', ftInteger,execParams.ParamByName('MovementId').asInteger);
               DMMainScaleForm.gpUpdate_Scale_Movement_PersonalLoss(lParams);
          end;
          lParams.Free;
     end;
end;
//------------------------------------------------------------------------------------------------
procedure TMainForm.bbUpdatePartnerClick(Sender: TObject);
var ParamsMovement_local:TParams;
begin
    if ParamsMovement.ParamByName('MovementDescId').AsInteger <> zc_Movement_Income
    then begin
      ShowMessage('Ошибка.Измение возможно только для документа <Приход от Поставщика>.');
      exit;
    end;

    //
    Create_ParamsMovement(ParamsMovement_local);
    //
    try
        CopyValuesParamsFrom(ParamsMovement,ParamsMovement_local);
        if GuidePartnerForm.Execute(ParamsMovement_local)
        then begin
               ParamsMovement.ParamByName('FromId').AsInteger:= ParamsMovement_local.ParamByName('calcPartnerId').AsInteger;
               ParamsMovement.ParamByName('FromCode').AsInteger:= ParamsMovement_local.ParamByName('calcPartnerCode').AsInteger;
               ParamsMovement.ParamByName('FromName').asString:= ParamsMovement_local.ParamByName('calcPartnerName').asString;

               ParamsMovement.ParamByName('calcPartnerId').AsInteger:= ParamsMovement_local.ParamByName('calcPartnerId').AsInteger;
               ParamsMovement.ParamByName('calcPartnerCode').AsInteger:= ParamsMovement_local.ParamByName('calcPartnerCode').AsInteger;
               ParamsMovement.ParamByName('calcPartnerName').asString:= ParamsMovement_local.ParamByName('calcPartnerName').asString;

               ParamsMovement.ParamByName('PaidKindId').AsInteger:= ParamsMovement_local.ParamByName('PaidKindId').AsInteger;
               ParamsMovement.ParamByName('PaidKindName').asString:= ParamsMovement_local.ParamByName('PaidKindName').asString;

               ParamsMovement.ParamByName('ContractId').AsInteger    := ParamsMovement_local.ParamByName('ContractId').AsInteger;
               ParamsMovement.ParamByName('ContractCode').AsInteger  := ParamsMovement_local.ParamByName('ContractCode').AsInteger;
               ParamsMovement.ParamByName('ContractNumber').asString := ParamsMovement_local.ParamByName('ContractNumber').asString;
               ParamsMovement.ParamByName('ContractTagName').asString:= ParamsMovement_local.ParamByName('ContractTagName').asString;
               //
               //Сохранили
               if gpFind_MovementDesc (ParamsMovement)
               then DMMainScaleForm.gpUpdate_Scale_Movement(ParamsMovement);
               //
               WriteParamsMovement;
        end;
    finally
            ParamsMovement_local.Free;
    end;
end;

procedure TMainForm.bbUpdateUnitClick(Sender: TObject);
var ParamsMovement_local: TParams;
begin
     if ParamsMovement.ParamByName('MovementDescId').AsInteger = zc_Movement_Inventory then
     begin
          Create_ParamsMovement(ParamsMovement_local);
          CopyValuesParamsFrom(ParamsMovement,ParamsMovement_local);
          if GuidePartnerForm.Execute(ParamsMovement_local) then
          begin
               // доопределяются остальные параметры
               DMMainScaleForm.gpGet_Scale_PartnerParams(ParamsMovement_local);
               //
               ParamsMovement.ParamByName('GoodsPropertyId').AsInteger:= ParamsMovement_local.ParamByName('GoodsPropertyId').AsInteger;
               ParamsMovement.ParamByName('GoodsPropertyCode').AsInteger:= ParamsMovement_local.ParamByName('GoodsPropertyCode').AsInteger;
               ParamsMovement.ParamByName('GoodsPropertyName').asString:= ParamsMovement_local.ParamByName('GoodsPropertyName').asString;
               //
               PanelPartner.Caption:= ParamsMovement_local.ParamByName('GoodsPropertyName').asString;
          end;
          ParamsMovement_local.Free;
     end
     else
         if DialogMovementDescForm.Execute('isUpdateUnit') then
         begin
              DMMainScaleForm.gpUpdate_Scale_Movement(ParamsMovement);
              WriteParamsMovement;
         end;
     myActiveControl;
end;
//------------------------------------------------------------------------------------------------
function TMainForm.GetParams_MovementDesc(BarCode: String):Boolean;
var MovementId_save:Integer;
begin
     err_count:=0;
     MovementId_save:=ParamsMovement.ParamByName('MovementId').AsInteger;
     //
     if ParamsMovement.ParamByName('MovementId').AsInteger=0
     then if ParamsMovement.ParamByName('MovementDescId').AsInteger=0
          then ParamsMovement.ParamByName('MovementDescNumber').AsInteger:=StrToInt(GetArrayList_Value_byName(Default_Array,'MovementNumber'))
          else
     else if (DMMainScaleForm.gpGet_Scale_Movement_checkId(ParamsMovement)=false)
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
          if ParamsMovement.ParamByName('MovementId_get').AsInteger <> 0
          then begin
                    ParamsMovement.ParamByName('MovementId').AsInteger:=ParamsMovement.ParamByName('MovementId_get').AsInteger;
                    if TRUE = DMMainScaleForm.gpGet_Scale_Movement(ParamsMovement,FALSE,FALSE)//isLast=FALSE,isNext=FALSE
                    then gpInitialize_MovementDesc
                    else begin ShowMessage('Ошибка.'+#10+#13+'Документ взвешивания не найден.'+#10+#13+'Необходимо перезайти в программу.');ParamsMovement.Free;end;
          end
          else
              if ParamsMovement.ParamByName('MovementId').AsInteger<>0
              then DMMainScaleForm.gpInsertUpdate_Scale_Movement(ParamsMovement);
          //
          if MovementId_save <> ParamsMovement.ParamByName('MovementId').AsInteger
          then DMMainScaleForm.gpGet_Scale_Transport(ParamsMovement,'')
          else DMMainScaleForm.gpGet_Scale_Transport(ParamsMovement,EditBarCodeTransport.Text);
          //
          WriteParamsMovement;
          //
          if (MovementId_save <> 0)or(ParamsMovement.ParamByName('MovementId_get').AsInteger<>0) then
          begin
               RefreshDataSet;
               Initialize_afterSave_all;
               Initialize_afterSave_MI;
          end;
     end;
     myActiveControl;
end;
{------------------------------------------------------------------------}
procedure TMainForm.bbGuideGoodsViewClick(Sender: TObject);
begin
     GetParams_Goods (FALSE, '', FALSE);
end;
{------------------------------------------------------------------------}
function TMainForm.GetParams_Goods (isRetail : Boolean; BarCode : String; isModeSave : Boolean) : Boolean;
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
     //т.е. изначально будем считать что это НЕ сканирование
     ParamsMI.ParamByName('isBarCode').AsBoolean:= FALSE;
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
                   ParamsMI.ParamByName('CountTare1').AsFloat:=0;
                   ParamsMI.ParamByName('CountTare2').AsFloat:=0;
                   ParamsMI.ParamByName('CountTare3').AsFloat:=0;
                   ParamsMI.ParamByName('CountTare4').AsFloat:=0;
                   ParamsMI.ParamByName('CountTare5').AsFloat:=0;
                   ParamsMI.ParamByName('CountTare6').AsFloat:=0;
                   //
                   ParamsMI.ParamByName('Count').AsFloat:=0;
                   ParamsMI.ParamByName('HeadCount').AsFloat:=0;
                   //
                   if (SettingMain.isPartionDate = TRUE)and(trim(EditPartionGoods.Text) <> '')
                   then try StrToDate(EditPartionGoods.Text)
                        except
                             ShowMessage('Ошибка.Дата партии не определена');
                             Result:=false;
                             exit;
                        end
                   else ParamsMI.ParamByName('PartionGoods').AsString:='';
                   //
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
     try ParamsMI.ParamByName('Count').AsFloat:=StrToFloat(EditCountPack.Text);except ParamsMI.ParamByName('Count').AsFloat:=0;end;
     try ParamsMI.ParamByName('HeadCount').AsFloat:=StrToFloat(EditHeadCount.Text);except ParamsMI.ParamByName('HeadCount').AsFloat:=0;end;
     try ParamsMI.ParamByName('BoxCount').AsFloat:=StrToFloat(EditBoxCount.Text);except ParamsMI.ParamByName('BoxCount').AsFloat:=0;end;
     try ParamsMI.ParamByName('BoxCode').AsFloat:=StrToFloat(EditBoxCode.Text);except ParamsMI.ParamByName('BoxCode').AsFloat:=0;end;

     // доопределили параметр
     if (SettingMain.isPartionDate = TRUE)and(trim(EditPartionGoods.Text) <> '')
     then try ParamsMI.ParamByName('PartionGoods').AsString:= DateToStr(StrToDate(EditPartionGoods.Text))
          except
               ShowMessage('Ошибка.Дата партии не определена');
               Result:=false;
               exit;
          end
     else ParamsMI.ParamByName('PartionGoods').AsString:=trim(EditPartionGoods.Text);
     //
     //GuideGoodsMovementForm
     if SettingMain.isSticker = TRUE
     then begin
         //
         if (Length(LanguageSticker_Array) > 0) and (rgLanguage.ItemIndex >= 0)
         then
            // Сюда передадим inLanguageId - а после ОК в ParamsMovement будет GoodsKindId - из StickerProperty
            ParamsMovement.ParamByName('PriceListId').AsInteger:= LanguageSticker_Array[GetArrayList_Index_byName(LanguageSticker_Array,rgLanguage.Items[rgLanguage.ItemIndex])].Id
         else
            ParamsMovement.ParamByName('PriceListId').AsInteger:= 0;

         // Диалог для параметров товара - Sticker
         if GuideGoodsStickerForm.Execute (ParamsMovement, isModeSave) = TRUE
         then begin
                    Result:=true;
                    RefreshDataSet;
                    WriteParamsMovement;
              end
     end
     else
     //GuideGoodsMovementForm
     if ParamsMovement.ParamByName('OrderExternalId').AsInteger<>0
     then
         // Диалог для параметров товара из списка заявки + в нем сохранение MovementItem
         if GuideGoodsMovementForm.Execute (ParamsMovement, isModeSave, FALSE) = TRUE
         then begin
                    Result:=true;
                    RefreshDataSet;
                    WriteParamsMovement;
              end
         else
     else
         // Диалог для параметров товара из списка всех товаров + в нем сохранение MovementItem
         if (ParamsMovement.ParamByName('MovementDescId').AsInteger = zc_Movement_ReturnIn)
          or((ParamsMovement.ParamByName('MovementDescId').AsInteger = zc_Movement_Income)
             and((SettingMain.BranchCode >= 301) and (SettingMain.BranchCode <= 310)))
          or((ParamsMovement.ParamByName('MovementDescId').AsInteger = zc_Movement_Send)
             and((SettingMain.BranchCode >= 301) and (SettingMain.BranchCode <= 310)))
         then
              if GuideGoodsPartnerForm.Execute (ParamsMovement, isModeSave, FALSE) = TRUE
              then begin
                         Result:=true;
                         RefreshDataSet;
                         WriteParamsMovement;
                   end
              else
         else
         // Диалог для параметров товара из списка всех товаров + в нем сохранение MovementItem
         if GuideGoodsForm.Execute (ParamsMovement, isModeSave, FALSE) = TRUE
         then begin
                    Result:=true;
                    RefreshDataSet;
                    WriteParamsMovement;
              end;
     Initialize_afterSave_MI;
end;
//------------------------------------------------------------------------------------------------
procedure TMainForm.bbChangeCountPackClick(Sender: TObject);
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
     ParamAddValue(execParams,'inDescCode',ftString,'zc_MIFloat_CountPack');

     with DialogNumberValueForm do
     begin
          LabelNumberValue.Caption:='Количество пакетов';
          ActiveControl:=NumberValueEdit;
          NumberValueEdit.Text:=CDS.FieldByName('Count').AsString;
          if not Execute then begin execParams.Free;exit;end;
          //
          ParamAddValue(execParams,'inValueData',ftFloat,NumberValue);
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
          LabelNumberValue.Caption:='Количество голов';
          ActiveControl:=NumberValueEdit;
          NumberValueEdit.Text:=CDS.FieldByName('HeadCount').AsString;
          if not Execute then begin execParams.Free;exit;end;
          //
          ParamAddValue(execParams,'inValueData',ftFloat,NumberValue);
          DMMainScaleForm.gpUpdate_Scale_MIFloat(execParams);
          //
     end;
     //
     execParams.Free;
     //
     RefreshDataSet;
end;
{------------------------------------------------------------------------}
procedure TMainForm.bbChangePartionGoodsClick(Sender: TObject);
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
     ParamAddValue(execParams,'inDescCode',ftString,'zc_MIString_PartionGoods');

     if SettingMain.isPartionDate = TRUE
     then
         with DialogDateValueForm do
         begin
              LabelDateValue.Caption:='Партия ДАТА';
              ActiveControl:=DateValueEdit;
              try DateValueEdit.Text:=DateToStr(StrToDate(CDS.FieldByName('PartionGoods').AsString));
              except
                   DateValueEdit.Text:=DateToStr(ParamsMovement.ParamByName('OperDate').AsDateTime-1);
              end;
              isPartionGoodsDate:=true;
              if not Execute then begin execParams.Free;exit;end;
              //
              ParamAddValue(execParams,'inValueData',ftString,DateValueEdit.Text);
              DMMainScaleForm.gpUpdate_Scale_MIString(execParams);
         end
      else
         with DialogStringValueForm do
         begin
              LabelStringValue.Caption:='Партия СЫРЬЯ';
              ActiveControl:=StringValueEdit;
              StringValueEdit.Text:=CDS.FieldByName('PartionGoods').AsString;
              if not Execute (true, false) then begin execParams.Free;exit;end;
              //
              ParamAddValue(execParams,'inValueData',ftString,StringValueEdit.Text);
              DMMainScaleForm.gpUpdate_Scale_MIString(execParams);
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
          LabelNumberValue.Caption:='Количество упак.тары';
          ActiveControl:=NumberValueEdit;
          NumberValueEdit.Text:=CDS.FieldByName('BoxCount').AsString;
          if not Execute then begin execParams.Free;exit;end;
          //
          ParamAddValue(execParams,'inValueData',ftFloat,NumberValue);
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
          LabelNumberValue.Caption:='№ Шар';
          ActiveControl:=NumberValueEdit;
          NumberValueEdit.Text:=CDS.FieldByName('LevelNumber').AsString;
          if not Execute then begin execParams.Free;exit;end;
          //
          ParamAddValue(execParams,'inValueData',ftFloat,NumberValue);
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
          LabelNumberValue.Caption:='№ Ящика';
          ActiveControl:=NumberValueEdit;
          NumberValueEdit.Text:=CDS.FieldByName('BoxNumber').AsString;
          if not Execute then begin execParams.Free;exit;end;
          //
          ParamAddValue(execParams,'inValueData',ftFloat,NumberValue);
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
     err_count:=0;
end;
{------------------------------------------------------------------------}
procedure TMainForm.bbView_allClick(Sender: TObject);
var WeightStr_all, WeightStr : String;
begin
    {aTest:= not aTest;
    if aTest = false then begin MemoTest.Lines.Add(DateTimeToStr(now) + ' - STOP' );MemoTest2.Lines.Add(DateTimeToStr(now) + ' - STOP' );exit;end;
    //
    with MemoTest do
    begin
        Lines.Clear;
        MemoTest2.Lines.Clear;
        //
        while aTest = true do begin
          try Initialize_Scale except Lines.Add(DateTimeToStr(now) + ' -!!! err Initialize');end;
          WeightStr_all:= '';
          try
              WeightStr_all:= Scale_AP.Data;
              if WeightStr_all = '' then Lines.Add(DateTimeToStr(now) + ' -!!! err WeightStr_all = null');
              //
              //
              try WeightStr:=trim(WeightStr_all[1]+WeightStr_all[2]+WeightStr_all[3]+WeightStr_all[4]+WeightStr_all[5]+WeightStr_all[6]);
              except WeightStr:= ''
              end;

              if WeightStr <> ''
              then
                if AnsiUpperCase (WeightStr_all[1]) = AnsiUpperCase ('E')
                then MemoTest2.Lines.Add(DateTimeToStr(now) + ' - err - ' + WeightStr)
                else if AnsiUpperCase (WeightStr_all[8]) = AnsiUpperCase ('S')
                     then MemoTest2.Lines.Add(DateTimeToStr(now) + ' - ' + WeightStr)
                     else MemoTest2.Lines.Add(DateTimeToStr(now) + ' - err - ' + '('+WeightStr_all[8]+')' + WeightStr);
          except Lines.Add(DateTimeToStr(now) + ' -!!! err Scale_AP.Data');
          end;
          //
          if WeightStr_all <> ''
          then Lines.Add(DateTimeToStr(now) + ' - ' + WeightStr_all);
           //
           Application.ProcessMessages;
           MyDelay_two(400);
        end;
        exit;
    end;}
    //
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
    AmountPartnerWeight,AmountWeight,RealWeight,WeightTare,CountTare : Double;
    ErasedCount:Integer;
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
       CountTare:=0;
       ErasedCount:=0;
       while not EOF do begin
          if FieldByName('isErased').AsBoolean=false then
          begin
            AmountPartnerWeight:=AmountPartnerWeight+FieldByName('AmountPartnerWeight').AsFloat;
            AmountWeight:=AmountWeight+FieldByName('AmountWeight').AsFloat;
            RealWeight:=RealWeight+FieldByName('RealWeightWeight').AsFloat;
            WeightTare:=WeightTare+FieldByName('WeightTareTotal').AsFloat;
            CountTare:=CountTare+FieldByName('CountTareTotal').AsFloat;
          end
          else ErasedCount:= ErasedCount+1;
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
    PanelWeightTare.Caption:=FormatFloat(',0.####'+' шт.',CountTare) + ' / ' + FormatFloat(',0.000#'+' кг.',WeightTare);
    PanelErasedCount.Caption:=IntToStr(ErasedCount);
end;
//------------------------------------------------------------------------------------------------
procedure TMainForm.EditBarCodePropertiesChange(Sender: TObject);
var lBarCodeText : String;
begin
     lBarCodeText:=trim(EditBarCode.Text);
     //
     if (Length(lBarCodeText)=12)and (lBarCodeText[1]='0')
     then lBarCodeText:= '0' + lBarCodeText;

     if Length(lBarCodeText)>=13
     then begin
               //Проверка <Контрольная сумма>
               if CheckBarCode(lBarCodeText) = FALSE
               then begin
                  EditBarCode.Text:='';
                  ActiveControl:=EditBarCode;
                  exit;
               end;

               try
               fStartBarCode:= true;
               //если в ШК - Id товара или товар+вид товара
               if Pos(zc_BarCodePref_Object,EditBarCode.Text)=1
               then begin
                         GetParams_Goods (FALSE, lBarCodeText, TRUE);//isRetail=FALSE
                         EditBarCode.Text:='';
                    end
               else
                   //если в ШК - Id документа заявки
                   if (Pos(zc_BarCodePref_Movement, lBarCodeText) = 1)
                   and (Pos('20204979', lBarCodeText) <> 1)
                   and (Pos('20204982', lBarCodeText) <> 1)
                   and (Pos('20204983', lBarCodeText) <> 1)
                   then begin
                             GetParams_MovementDesc (lBarCodeText);
                             EditBarCode.Text:='';
                        end
                   else begin
                            //если в ШК - закодированый товар + кол-во, т.е. для Retail
                             GetParams_Goods (TRUE, lBarCodeText, TRUE);//isRetail=TRUE
                             EditBarCode.Text:='';
                        end;
               finally
                 fStartBarCode:= false;
               end;
     end;
end;
//---------------------------------------------------------------------------------------------
procedure TMainForm.EditBarCodeTransportPropertiesChange(Sender: TObject);
begin
     EditBarCodeTransport.Text:=trim(EditBarCodeTransport.Text);
     if Length(EditBarCodeTransport.Text)>=13
     then begin
               ActiveControl:=EditBarCode;
          end
     else begin
     PanelInvNumberTransport.Caption:='';
     PanelPersonalDriver.Caption:='';
     PanelCar.Caption:='';
     PanelRoute.Caption:='';
     if trim(EditBarCodeTransport.Text) = '' then ActiveControl:=EditBarCode;
     end;
end;
//---------------------------------------------------------------------------------------------
procedure TMainForm.EditBarCodeTransportExit(Sender: TObject);
begin
     if Length(EditBarCodeTransport.Text)>=13
     then begin
               //Проверка <Контрольная сумма>
               if CheckBarCode(trim(EditBarCodeTransport.Text)) = FALSE
               then begin
                  EditBarCodeTransport.Text:='';
                  ActiveControl:=EditBarCodeTransport;
                  exit;
               end;
               if DMMainScaleForm.gpGet_Scale_Transport(ParamsMovement,EditBarCodeTransport.Text)
               then begin
                         if not DMMainScaleForm.gpUpdate_Scale_Movement_Transport(ParamsMovement) then
                         DMMainScaleForm.gpGet_Scale_Transport(ParamsMovement,'');
                    end
               else begin
                         ShowMessage('Ошибка.'+#10+#13+'Значение <Штрих код Путевой лист> не найдено.');
                         ActiveControl:=EditBarCodeTransport;
                         exit;
                    end;
          end
     else begin
         DMMainScaleForm.gpGet_Scale_Transport(ParamsMovement,'');
         DMMainScaleForm.gpUpdate_Scale_Movement_Transport(ParamsMovement);
     end;
     //
     WriteParamsMovement;
end;
//---------------------------------------------------------------------------------------------
procedure TMainForm.pSetSubjectDoc;
var execParams:TParams;
begin
     if ParamsMovement.ParamByName('isSubjectDoc').AsBoolean = FALSE then exit;
     //
     Create_ParamsSubjectDoc(execParams);
     //
     with execParams do
     begin
          ParamByName('SubjectDocId').AsInteger:=ParamsMovement.ParamByName('SubjectDocId').AsInteger;
          ParamByName('SubjectDocCode').AsInteger:=ParamsMovement.ParamByName('SubjectDocCode').AsInteger;
          ParamByName('SubjectDocName').asString:=ParamsMovement.ParamByName('SubjectDocName').asString;
     end;
     if GuideSubjectDocForm.Execute(execParams)
     then begin
               ParamsMovement.ParamByName('SubjectDocId').AsInteger:=execParams.ParamByName('SubjectDocId').AsInteger;
               ParamsMovement.ParamByName('SubjectDocCode').AsInteger:=execParams.ParamByName('SubjectDocCode').AsInteger;
               ParamsMovement.ParamByName('SubjectDocName').AsString:=execParams.ParamByName('SubjectDocName').AsString;
               //
               EditSubjectDoc.Text:=execParams.ParamByName('SubjectDocName').AsString;
               //
               DMMainScaleForm.gpInsertUpdate_Scale_Movement(ParamsMovement);
     end;
     //
     execParams.Free;
end;
//---------------------------------------------------------------------------------------------
procedure TMainForm.pSetDriverReturn;
var execParams:TParams;
begin
     Create_ParamsPersonal(execParams,'');
     //
     with execParams do
     begin
          ParamByName('PersonalId').AsInteger:=ParamsMovement.ParamByName('PersonalDriverId').AsInteger;
          ParamByName('PersonalCode').AsInteger:=ParamsMovement.ParamByName('PersonalDriverCode').AsInteger;
     end;
     if GuidePersonalForm.Execute(execParams)
     then begin
               ParamsMovement.ParamByName('TransportId').AsInteger:=0;
               ParamsMovement.ParamByName('PersonalDriverId').AsInteger:=execParams.ParamByName('PersonalId').AsInteger;
               ParamsMovement.ParamByName('PersonalDriverCode').AsInteger:=execParams.ParamByName('PersonalCode').AsInteger;
               ParamsMovement.ParamByName('PersonalDriverName').AsString:=execParams.ParamByName('PersonalName').AsString;
               PanelPersonalDriver.Caption:=execParams.ParamByName('PersonalName').AsString;
               //
               DMMainScaleForm.gpInsertUpdate_Scale_Movement(ParamsMovement);
     end;
     //
     execParams.Free;
end;
//---------------------------------------------------------------------------------------------
procedure TMainForm.EditSubjectDocPropertiesButtonClick(Sender: TObject;AButtonIndex: Integer);
begin
     {if (ParamsMovement.ParamByName('MovementDescId').AsInteger = zc_Movement_Send)
      or(ParamsMovement.ParamByName('MovementDescId').AsInteger = zc_Movement_SendOnPrice)
     then} pSetSubjectDoc;
end;
//---------------------------------------------------------------------------------------------
procedure TMainForm.EditBarCodeTransportPropertiesButtonClick(Sender: TObject;AButtonIndex: Integer);
begin
     if (GetArrayList_Value_byName(Default_Array,'isDriverReturn') = AnsiUpperCase('TRUE'))
     and(ParamsMovement.ParamByName('MovementDescId').AsInteger = zc_Movement_ReturnIn)
     then pSetDriverReturn
     else
     if GuideMovementTransportForm.Execute(ParamsMovement,TRUE)//isChoice=TRUE
     then begin
               ActiveControl:=EditBarCodeTransport;
               EditBarCodeTransport.Text:=ParamsMovement.ParamByName('Transport_BarCode').AsString;
          end;
end;
//---------------------------------------------------------------------------------------------
procedure TMainForm.EditPartionGoodsEnter(Sender: TObject);
begin
     if (SettingMain.isPartionDate = TRUE) then ActiveControl:=EditBarCode;
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
procedure TMainForm.TimerProtocol_isProcessTimer(Sender: TObject);
begin
  //отметили "Работает"
  spProtocol_isProcess.Execute;
end;
//---------------------------------------------------------------------------------------------
procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //отметили "Выход"
  spProtocol_isExit.Execute;
end;
//---------------------------------------------------------------------------------------------
procedure TMainForm.FormCreate(Sender: TObject);
var i : Integer;
begin
  fStartBarCode:= false;
  //aTest:= false;
  // определили IP
  with TIdIPWatch.Create(nil) do
  begin
        Active:=true;
        FormParams.ParamByName('IP_str').Value:=LocalIP;
        Free;
  end;
  //отметили "Работает"
  spProtocol_isProcess.Execute;
  //запустили Таймер
  TimerProtocol_isProcess.Enabled:= TRUE;

  SettingMain.BranchName:=DMMainScaleForm.lpGet_BranchName(SettingMain.BranchCode);
  if SettingMain.isSticker = TRUE
  then Caption:='Печать этикеток (' + GetFileVersionString(ParamStr(0))+') - <'+SettingMain.BranchName+'>' + ' : <'+DMMainScaleForm.gpGet_Scale_User+'>'
  else Caption:='Экспедиция ('      + GetFileVersionString(ParamStr(0))+') - <'+SettingMain.BranchName+'>' + ' : <'+DMMainScaleForm.gpGet_Scale_User+'>';
  //global Initialize
  gpInitialize_Const;
  //global Initialize Array
  if SettingMain.isSticker = TRUE
  then StickerFile_Array:=  DMMainScaleForm.gpSelect_Scale_StickerFile (SettingMain.BranchCode);
  Service_Array:=       DMMainScaleForm.gpSelect_ToolsWeighing_onLevelChild(SettingMain.BranchCode,'Service');
  Default_Array:=       DMMainScaleForm.gpSelect_ToolsWeighing_onLevelChild(SettingMain.BranchCode,'Default');
  gpInitialize_SettingMain_Default; //!!!обязатльно после получения Default_Array!!!

  if SettingMain.isSticker = TRUE
  then PrinterSticker_Array:=DMMainScaleForm.gpSelect_ToolsWeighing_onLevelChild(SettingMain.BranchCode,'PrinterSticker');

  LanguageSticker_Array:=DMMainScaleForm.gpSelect_Object_Language;
  rgLanguage.Visible:= SettingMain.isSticker = TRUE;
  if rgLanguage.Visible = TRUE then
  begin
       for i:= 0 to Length(LanguageSticker_Array) - 1 do
          rgLanguage.Items.Add(LanguageSticker_Array[i].Name);
       //
       rgLanguage.Caption:= '';
       rgLanguage.Height:= 35 * Length(LanguageSticker_Array);
       //
       if Length(LanguageSticker_Array) > 0 then rgLanguage.ItemIndex:= 0;
  end;


  PriceList_Array:=     DMMainScaleForm.gpSelect_ToolsWeighing_onLevelChild(SettingMain.BranchCode,'PriceList');
  TareCount_Array:=     DMMainScaleForm.gpSelect_ToolsWeighing_onLevelChild(SettingMain.BranchCode,'TareCount');
  TareWeight_Array:=    DMMainScaleForm.gpSelect_ToolsWeighing_onLevelChild(SettingMain.BranchCode,'TareWeight');
  ChangePercentAmount_Array:= DMMainScaleForm.gpSelect_ToolsWeighing_onLevelChild(SettingMain.BranchCode,'ChangePercentAmount');
  GoodsKind_Array:=     DMMainScaleForm.gpSelect_Scale_GoodsKindWeighing;
  if SettingMain.isSticker = TRUE then StickerPack_Array:=   DMMainScaleForm.gpSelect_Scale_StickerPack;
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
  //local visible Columns
  //cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('GoodsKindName').Index].Visible       :=SettingMain.isGoodsComplete = TRUE;
  cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('PartionGoods').Index].Visible        :=(SettingMain.isPartionDate = TRUE) or ((SettingMain.isGoodsComplete = FALSE) and (SettingMain.isSticker = FALSE) and not((SettingMain.BranchCode >= 301) and (SettingMain.BranchCode <= 310)));
  cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('HeadCount').Index].Visible           :=(SettingMain.isGoodsComplete = FALSE) and (SettingMain.isSticker = FALSE) and not((SettingMain.BranchCode >= 301) and (SettingMain.BranchCode <= 310));
  cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('Count').Index].Visible               :=((SettingMain.isGoodsComplete = TRUE)  and (SettingMain.isSticker = FALSE)) or ((SettingMain.BranchCode >= 301) and (SettingMain.BranchCode <= 310));
  cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('LevelNumber').Index].Visible         :=(SettingMain.isGoodsComplete = TRUE)  and (SettingMain.isSticker = FALSE);
  cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('BoxNumber').Index].Visible           :=(SettingMain.isGoodsComplete = TRUE)  and (SettingMain.isSticker = FALSE);
  cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('BoxName').Index].Visible             :=(SettingMain.isGoodsComplete = TRUE)  and (SettingMain.isSticker = FALSE);
  cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('BoxCount').Index].Visible            :=(SettingMain.isGoodsComplete = TRUE)  and (SettingMain.isSticker = FALSE);
  //
  cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('TaxDoc').Index].Visible              :=(SettingMain.isGoodsComplete = TRUE)  and (SettingMain.isSticker = FALSE);
  cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('TaxDoc_calc').Index].Visible         :=(SettingMain.isGoodsComplete = TRUE)  and (SettingMain.isSticker = FALSE);
  //
  cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('isPromo').Index].Visible             :=not((SettingMain.BranchCode >= 301) and (SettingMain.BranchCode <= 310));
  cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('ChangePercentAmount').Index].Visible :=not((SettingMain.BranchCode >= 301) and (SettingMain.BranchCode <= 310));
  //
  if (SettingMain.BranchCode >= 301) and (SettingMain.BranchCode <= 310) then
  begin
     cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('Count').Index].Caption            := 'Кол. втулок';
     LabelCountPack.Caption:= 'Кол-во втулок';
  end;
  //
  if SettingMain.isSticker = TRUE then
  begin
     //
     bbChoice_UnComlete.Visible:=false;
     bbView_all.Visible:=false;

     bbReestrReturn.Visible:=false;
     bbReestrKind_PartnerOut.Visible:=false;
     bbReestrKind_PartnerOut_two.Visible:=false;
     bbReestrKind_PartnerOut_three.Visible:=false;
     bbReestrKind_Income.Visible:=false;
     //
     // StickerPack
     cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('GoodsKindName').Index].Caption    := 'Вид пакування';
     // GoodsKindId - из StickerProperty
     cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('PriceListName').Index].Caption    := 'Вид товара';
     // № печати
     cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('Price').Index].Caption            := '№ печати';
     // Кол-во в печати
     cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('Amount').Index].Caption           := 'Печать';

     cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('GoodsKindName').Index].Width      := 150;

     cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('PriceListName').Index].Visible       := TRUE;
     cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('Price').Index].Visible               := TRUE;
     //
     cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('isBarCode').Index].Visible           := FALSE;
     cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('isPromo').Index].Visible             := FALSE;
     cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('ChangePercentAmount').Index].Visible := FALSE;
     cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('AmountPartner').Index].Visible       := FALSE;
     //DataBinding.FieldName = 'Amount'
     cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('RealWeight').Index].Visible          := FALSE;
     cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('CountTareTotal').Index].Visible      := FALSE;
     cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('WeightTareTotal').Index].Visible     := FALSE;
     cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('WeightTare').Index].Visible          := FALSE;
     cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('CountTare').Index].Visible           := FALSE;
     cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('WeightTare1').Index].Visible         := FALSE;
     cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('CountTare1').Index].Visible          := FALSE;
     cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('WeightTare2').Index].Visible         := FALSE;
     cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('CountTare2').Index].Visible          := FALSE;
     cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('WeightTare3').Index].Visible         := FALSE;
     cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('CountTare3').Index].Visible          := FALSE;
     cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('WeightTare4').Index].Visible         := FALSE;
     cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('CountTare4').Index].Visible          := FALSE;
     cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('WeightTare5').Index].Visible         := FALSE;
     cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('CountTare5').Index].Visible          := FALSE;
     cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('WeightTare6').Index].Visible         := FALSE;
     cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('CountTare6').Index].Visible          := FALSE;
     cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('UpdateDate').Index].Visible          := FALSE;
     cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('isErased').Index].Visible            := FALSE;
  end;

  //local visible
  PanelPartionGoods.Visible:=((SettingMain.isGoodsComplete = FALSE) or (SettingMain.isPartionDate = TRUE))
                         and ((SettingMain.BranchCode < 301) or (SettingMain.BranchCode > 310));
  bbSetPartionGoods.Visible:= SettingMain.isPartionDate = TRUE;
  if SettingMain.isPartionDate = TRUE then
  begin
       cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('PartionGoods').Index].Caption:= 'ПАРТИЯ Дата';
       bbChangePartionGoods.Hint:= 'Изменить <Партия Дата>';
       LabelPartionGoods.Caption:= 'ПАРТИЯ Дата';
       //EditPartionGoods.Text:= DateToStr(now-1);
  end;

  HeadCountPanel.Visible:=((SettingMain.isGoodsComplete = FALSE))
                      and ((SettingMain.BranchCode < 301) or (SettingMain.BranchCode > 310));
  PanelCountPack.Visible:=(not PanelPartionGoods.Visible) and (SettingMain.isSticker = FALSE);
  BarCodePanel.Visible:=GetArrayList_Value_byName (Default_Array,'isBarCode') = AnsiUpperCase('TRUE');
  PanelBox.Visible:=GetArrayList_Value_byName (Default_Array,'isBox') = AnsiUpperCase('TRUE');
  TransportPanel.Visible:=GetArrayList_Value_byName (Default_Array,'isTransport') = AnsiUpperCase('TRUE');

  bbChangeHeadCount.Visible:=HeadCountPanel.Visible;
  bbChangePartionGoods.Visible:=(HeadCountPanel.Visible) or (SettingMain.isPartionDate = TRUE);

  bbChangeCountPack.Visible:=not bbChangeHeadCount.Visible;
  //
  bbUpdatePartner.Visible:= (SettingMain.BranchCode >= 301) and (SettingMain.BranchCode <= 310);
  bbUpdateUnit.Visible:= not bbUpdatePartner.Visible;
  //
  bbGuideGoodsView.Visible:= GetArrayList_Value_byName(Default_Array,'isCheckDelete') = AnsiUpperCase('TRUE');
  //
  with spSelect do
  begin
       StoredProcName:='gpSelect_Scale_MI';
       OutputType:=otDataSet;
       Params.AddParam('inMovementId', ftInteger, ptInput,0);
  end;
  err_count:=0;
end;
//------------------------------------------------------------------------------------------------
function TMainForm.GetPanelPartnerCaption(execParams:TParams):String;
var str_edi:String;
begin
     with execParams do
     begin
          str_edi:='';
          if ParamByName('isEdiInvoice').asBoolean=TRUE then str_edi:=str_edi+'cч.';
          if ParamByName('isEdiOrdspr').asBoolean=TRUE then str_edi:=str_edi+'пн.';
          if ParamByName('isEdiDesadv').asBoolean=TRUE then str_edi:=str_edi+'ув.';

          Result:=str_edi+'('+IntToStr(ParamByName('calcPartnerCode').asInteger)+')'+ParamByName('calcPartnerName').asString;
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

    if ParamsMovement.ParamByName('MovementDescId').AsInteger = zc_Movement_Inventory
    then
        PanelPartner.Caption:= ParamsMovement.ParamByName('GoodsPropertyName').asString
    else
        if ParamByName('calcPartnerId').AsInteger<>0
        then begin
                 PanelPartner.Caption:=GetPanelPartnerCaption(ParamsMovement);
             end
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
    then if (ParamByName('OrderExternal_DescId').AsInteger=zc_Movement_OrderExternal)
          or(ParamByName('OrderExternal_DescId').AsInteger=zc_Movement_OrderInternal)
          or(ParamByName('OrderExternal_DescId').AsInteger=zc_Movement_OrderIncome)
         then PanelOrderExternal.Caption:=' з.'+ParamByName('OrderExternalName_master').asString
         else if ParamByName('OrderExternal_DescId').AsInteger=zc_Movement_SendOnPrice
              then PanelOrderExternal.Caption:=' ф.'+ParamByName('OrderExternalName_master').asString
              else if ParamByName('OrderExternal_DescId').AsInteger=zc_Movement_ReturnIn
                   then PanelOrderExternal.Caption:=' в.'+ParamByName('OrderExternalName_master').asString
                   else PanelOrderExternal.Caption:=' ???'+ParamByName('OrderExternalName_master').asString
    else PanelOrderExternal.Caption:='';

     EditBarCodeTransport.Text:=ParamByName('Transport_BarCode').asString;
     PanelInvNumberTransport.Caption:=ParamByName('Transport_InvNumber').asString;
     PanelPersonalDriver.Caption:=ParamByName('PersonalDriverName').asString;
     PanelCar.Caption:=ParamByName('CarName').asString;
     PanelRoute.Caption:=ParamByName('RouteName').asString;

     EditSubjectDoc.Text:=ParamByName('SubjectDocName').asString;

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
  //
  CDS.First;
end;
//------------------------------------------------------------------------------------------------
procedure TMainForm.Create_Scale;
var i:Integer;
    number:Integer;
begin
  try Scale_DB:=TCasDB.Create(self); except end;
  try Scale_BI:=TCasBI.Create(self); except end;
  try Scale_Zeus:=TZeus.Create(self); except end;
  try Scale_AP:=CoAPScale_.Create; except end;

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
procedure TMainForm.Initialize_Scale;
begin
     //Close prior
     if SettingMain.IndexScale_old>=0
     then begin
               if Scale_Array[SettingMain.IndexScale_old].ScaleType=stBI then Scale_BI.Active := 0;
               if Scale_Array[SettingMain.IndexScale_old].ScaleType=stDB then Scale_DB.Active := 0;
               if Scale_Array[SettingMain.IndexScale_old].ScaleType=stZeus then Scale_DB.Active := 0;
               if Scale_Array[SettingMain.IndexScale_old].ScaleType=stAP   then try Scale_AP.DisConnect; except end;
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

     if Scale_Array[rgScale.ItemIndex].ScaleType = stAP
     then try
             // !!! SCALE Zeus !!!
//             try Scale_AP.DisConnect; except end;
             Scale_AP.Connect('COM' + IntToStr(Scale_Array[rgScale.ItemIndex].ComPort));
             //
             ScaleLabel.Caption:='AP.Connect = OK';
          except
             ScaleLabel.Caption:='AP.Connect = Error-ALL';
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
function TMainForm.fGetScale_AP_CurrentWeight_cycle : String;
var fGetTest : Boolean;
    WeightStr_all, WeightStr : String;
    i : Integer;
begin
     Result:='';
     fGetTest:= false;
     i:=0;
     //
     while (fGetTest = false) and (i < 125) do
     begin
          i:= i+1;
          //try Initialize_Scale except PanelWeight_Scale.Caption:= 'err!=Initialize' end;
          WeightStr_all:= '';
          try
              WeightStr_all:= Scale_AP.Data;
              if WeightStr_all = '' then PanelWeight_Scale.Caption:= 'err!=null';
              //
              //
              try WeightStr:=trim(WeightStr_all[1]+WeightStr_all[2]+WeightStr_all[3]+WeightStr_all[4]+WeightStr_all[5]+WeightStr_all[6]);
              except WeightStr:= ''
              end;

              if WeightStr <> ''
              then
                if AnsiUpperCase (WeightStr_all[1]) = AnsiUpperCase ('E')
                then PanelWeight_Scale.Caption:= 'err=' + WeightStr
                else if AnsiUpperCase (WeightStr_all[8]) = AnsiUpperCase ('S')
                     then begin Result:= WeightStr; fGetTest:= true; end
                     else PanelWeight_Scale.Caption:= 'err=' + '('+WeightStr_all[8]+')' + WeightStr
              else PanelWeight_Scale.Caption:= 'err=' + WeightStr_all;

          except PanelWeight_Scale.Caption:= 'err!=Scale_AP.Data';
          end;
          //
          if fGetTest = false then
          begin
            PanelWeight_Scale.Caption:= '('+IntToStr(i)+')'+PanelWeight_Scale.Caption;
            Application.ProcessMessages;
            MyDelay_two(200);
          end;
     end;
     //
     if Result = '' then Result:= PanelWeight_Scale.Caption;
end;

//------------------------------------------------------------------------------------------------
function TMainForm.fGetScale_CurrentWeight:Double;
var WeightStr : String;
begin
     // открываем ВЕСЫ, только когда НУЖЕН вес
     //Initialize_Scale_DB;
     // считывание веса
     try
        if Scale_Array[rgScale.ItemIndex].ScaleType = stBI
        then Result:=Scale_BI.Weight
             else if Scale_Array[rgScale.ItemIndex].ScaleType = stDB
                  then Result:=Scale_DB.Weight
                  else if Scale_Array[rgScale.ItemIndex].ScaleType = stZeus
                       then Result:=Scale_Zeus.Weight
                       else if Scale_Array[rgScale.ItemIndex].ScaleType = stAP
                            then begin
                                      WeightStr:= fGetScale_AP_CurrentWeight_cycle;
                                      Result:= myStrToFloat(WeightStr);
                                 end
                            else Result:=0;
     except Result:=0;end;
     // закрываем ВЕСЫ
     // Scale_DB.Active:=0;
     //
//*****
     if (System.Pos('ves=',ParamStr(1))>0)and(Result=0)
     then Result:=myStrToFloat(Copy(ParamStr(1), 5, LengTh(ParamStr(1))-4));
     if (System.Pos('ves=',ParamStr(2))>0)and(Result=0)
     then Result:=myStrToFloat(Copy(ParamStr(2), 5, LengTh(ParamStr(2))-4));
     if (System.Pos('ves=',ParamStr(3))>0)and(Result=0)
     then Result:=myStrToFloat(Copy(ParamStr(3), 5, LengTh(ParamStr(3))-4));
//*****
     if Scale_Array[rgScale.ItemIndex].ScaleType = stAP
     then if Result = 0 then PanelWeight_Scale.Caption:= WeightStr
          else PanelWeight_Scale.Caption:=FloatToStr(Result)
     else PanelWeight_Scale.Caption:=FloatToStr(Result);
end;
//------------------------------------------------------------------------------------------------
procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
var Key2 : Word;

begin
     if Key = VK_F8 then bbSale_Order_allClick(Self);
     if Key = VK_F9 then bbSale_Order_diffTaxClick(Self);

     if Key = VK_F5 then Save_Movement_all;
     if Key = VK_F2 then GetParams_MovementDesc('');
     if (Key = VK_SPACE) and (Shift = []) then
     begin Key := 0;
           Key2:= VK_SPACE;
           if (GetParams_Goods (FALSE, '', TRUE)) and (SettingMain.isSticker = TRUE)
           then FormKeyDown(Sender,Key2, []);
     end;//isRetail=FALSE
     //
     if (Key = VK_SPACE) and (Shift = [ssCtrl]) and (GetArrayList_Value_byName(Default_Array,'isCheckDelete') = AnsiUpperCase('TRUE'))
     then begin Key:= 0; GetParams_Goods (FALSE, '', FALSE); end;//isRetail=FALSE
     //
     // Меняется шрифт
     if (Key = VK_F10) and (Shift = [ssCtrl]) then miFontClick(Self);
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
                   if GetArrayList_Value_byName(Default_Array,'isCheckDelete') = AnsiUpperCase('TRUE')
                   then with DialogStringValueForm do
                        begin
                             if not Execute (false, true) then begin ShowMessage ('Действие отменено.');exit;end;
                             //
                             if DMMainScaleForm.gpGet_Scale_PSW_delete (StringValueEdit.Text) <> ''
                             then begin ShowMessage ('Пароль неверный.Действие отменено.');exit;end;
                        end;
                   //
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
procedure TMainForm.bbSale_Order_allClick(Sender: TObject);
begin
     with ParamsMovement do Print_Sale_Order(ParamByName('OrderExternalId').AsInteger,ParamByName('MovementId').AsInteger,FALSE,FALSE);
end;
{------------------------------------------------------------------------}
procedure TMainForm.bbSale_Order_diffClick(Sender: TObject);
begin
     with ParamsMovement do Print_Sale_Order(ParamByName('OrderExternalId').AsInteger,ParamByName('MovementId').AsInteger,TRUE,FALSE);
end;
{------------------------------------------------------------------------}
procedure TMainForm.bbSale_Order_diffTaxClick(Sender: TObject);
begin
     with ParamsMovement do Print_Sale_Order(ParamByName('OrderExternalId').AsInteger,ParamByName('MovementId').AsInteger,FALSE,TRUE);
end;
{------------------------------------------------------------------------}
procedure TMainForm.bbSetPartionGoodsClick(Sender: TObject);
begin
     with DialogDateValueForm do
     begin
          LabelDateValue.Caption:='Партия ДАТА';
          ActiveControl:=DateValueEdit;
          try DateValueEdit.Text:=DateToStr(StrToDate(EditPartionGoods.Text));
          except
               DateValueEdit.Text:=DateToStr(ParamsMovement.ParamByName('OperDate').AsDateTime-1);
          end;
          isPartionGoodsDate:=true;
          if not Execute then begin EditPartionGoods.Text:=''; exit;end;
          //
          EditPartionGoods.Text:=DateValueEdit.Text;
          //
     end;
end;
{------------------------------------------------------------------------}
procedure TMainForm.actExitExecute(Sender: TObject);
begin Close;end;
{------------------------------------------------------------------------}
end.
