unit OrderRK;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDocument, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dxSkinsdxBarPainter, dsdAddOn,
  dsdGuides, dsdDB, Vcl.Menus, dxBarExtItems, dxBar, cxClasses,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxButtonEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, cxLabel, cxTextEdit, Vcl.ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridCustomView, cxGrid, cxPC, cxCurrencyEdit, cxCheckBox, frxClass, frxDBSet,
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinBlack,
  dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue, dsdCommon;

type
  TOrderRKForm = class(TAncestorDocumentForm)
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    GoodsKindName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    actGoodsKindChoice: TOpenChoiceForm;
    spSelectPrint: TdsdStoredProc;
    N2: TMenuItem;
    N3: TMenuItem;
    RefreshDispatcher: TRefreshDispatcher;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    PrintItemsSverkaCDS: TClientDataSet;
    cxLabel4: TcxLabel;
    edFrom: TcxButtonEdit;
    GuidesFrom: TdsdGuides;
    cxLabel7: TcxLabel;
    edRoute: TcxButtonEdit;
    GuidesRoute: TdsdGuides;
    cxLabel8: TcxLabel;
    edTo: TcxButtonEdit;
    GuidesTo: TdsdGuides;
    MeasureName: TcxGridDBColumn;
    spSavePrintState: TdsdStoredProc;
    actSPSavePrintState: TdsdExecStoredProc;
    mactPrint_Order: TMultiAction;
    cbPrinted: TcxCheckBox;
    GoodsGroupNameFull: TcxGridDBColumn;
    cxLabel18: TcxLabel;
    ceComment: TcxTextEdit;
    cxLabel19: TcxLabel;
    edOperDate_print: TcxDateEdit;
    LineNum: TcxGridDBColumn;
    actShowMessage: TShowMessageAction;
    bbOpenReportForm: TdxBarButton;
    actPrintTotal: TdsdPrintAction;
    spSelectPrintTotal: TdsdStoredProc;
    bbPrintTotal: TdxBarButton;
    actUpdateOperDatePartner: TdsdDataSetRefresh;
    ExecuteDialogUpdateOperDatePartner: TExecuteDialog;
    macUpdateOperDatePartner: TMultiAction;
    spUpdateMovement_OperDatePartner: TdsdStoredProc;
    actRefreshGet: TdsdDataSetRefresh;
    bbUpdateOperDatePartner: TdxBarButton;
    actPrint_2: TdsdPrintAction;
    bbPrintOrder: TdxBarButton;
    mactPrint_Order2: TMultiAction;
    spGetReporNameBill: TdsdStoredProc;
    actPrint_Account_ReportName: TdsdExecStoredProc;
    actPrint_Account: TdsdPrintAction;
    mactPrint_Account: TMultiAction;
    bbPrint_Account: TdxBarButton;
    spSelectPrintBill: TdsdStoredProc;
    cxLabel22: TcxLabel;
    edCarInfo_Date: TcxDateEdit;
    actUpdateMIChild_Amount: TdsdExecStoredProc;
    macUpdateMIChild_Amount: TMultiAction;
    bbUpdateMIChild_Amount: TdxBarButton;
    bbUpdateMIChild_AmountSecond: TdxBarButton;
    actReport_Goods: TdsdOpenForm;
    bbReport_Goods: TdxBarButton;
    bbOpenFormOrderExternalChild: TdxBarButton;
    actUpdate_MIChild_AmountNull: TdsdExecStoredProc;
    bbUpdate_MIChild_AmountNull: TdxBarButton;
    bbUpdate_MIChild_AmountSecondNull: TdxBarButton;
    actPrintSort: TdsdPrintAction;
    bbPrintQty: TdxBarButton;
    actPrintCell: TdsdPrintAction;
    bbPrintCell: TdxBarButton;
    bbsPrint: TdxBarSubItem;
    bbSeparator: TdxBarSeparator;
    mactPrint_Order3: TMultiAction;
    actPrint_3: TdsdPrintAction;
    bbPrint_Order3: TdxBarButton;
    GuidesRetail: TdsdGuides;
    cxLabel3: TcxLabel;
    edRetail: TcxButtonEdit;
    actGoodsChoice: TOpenChoiceForm;
    InsertRecord: TInsertRecord;
    bbInsertRecord: TdxBarButton;
    GuidesOrderExternal: TdsdGuides;
    edOrderExternal: TcxButtonEdit;
    cxLabel5: TcxLabel;
    cxLabel6: TcxLabel;
    edOperDate_OrderExternal: TcxDateEdit;
    cxLabel10: TcxLabel;
    edOperDatePartner_OrderExternal: TcxDateEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TOrderRKForm);

end.
