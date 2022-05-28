unit Layout_Movement;

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
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue,
  cxSplitter;

type
  TLayout_MovementForm = class(TAncestorDocumentForm)
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    actGoodsKindChoice: TOpenChoiceForm;
    spSelectPrint_Loss: TdsdStoredProc;
    N2: TMenuItem;
    N3: TMenuItem;
    RefreshDispatcher: TRefreshDispatcher;
    actRefreshPrice: TdsdDataSetRefresh;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    cxLabel5: TcxLabel;
    edLayout: TcxButtonEdit;
    GuidesLayout: TdsdGuides;
    bbComplete: TdxBarButton;
    spMovementComplete: TdsdStoredProc;
    actComplete: TdsdExecStoredProc;
    actLoadDeferredCheck: TMultiAction;
    actOpenChoiceDeferredCheck: TOpenChoiceForm;
    actExecSPAddDeferredCheck: TdsdExecStoredProc;
    dxBarButton1: TdxBarButton;
    actLoadSend: TMultiAction;
    actOpenChoiceSend: TOpenChoiceForm;
    actExecSPAddSend: TdsdExecStoredProc;
    dxBarButton2: TdxBarButton;
    edComment: TcxTextEdit;
    cxLabel7: TcxLabel;
    actInsertMaskMIMaster: TdsdExecStoredProc;
    dxBarButton3: TdxBarButton;
    bbUpdateSummaFund: TdxBarButton;
    macInsertByLayout: TMultiAction;
    actLayoutJournalChoiceForm: TOpenChoiceForm;
    actInsertMaster: TdsdExecStoredProc;
    spInsertByLayout: TdsdStoredProc;
    bbInsertByLayout: TdxBarButton;
    cbPharmacyItem: TcxCheckBox;
    cxGridChild: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    chisErased: TcxGridDBColumn;
    chUnitCode: TcxGridDBColumn;
    chUnitName: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    chIsChecked: TcxGridDBColumn;
    cxSplitter3: TcxSplitter;
    DetailDS: TDataSource;
    DetailDCS: TClientDataSet;
    spSelect_MovementItem_Child: TdsdStoredProc;
    actUpdateChildDS: TdsdUpdateDataSet;
    spInsertUpdateMIChild: TdsdStoredProc;
    spErasedMIChild: TdsdStoredProc;
    spUnErasedMIChild: TdsdStoredProc;
    actMISetErasedChild: TdsdUpdateErased;
    actMISetUnErasedChild: TdsdUpdateErased;
    dxBarSubItem1: TdxBarSubItem;
    dxBarButton4: TdxBarButton;
    dxBarButton5: TdxBarButton;
    DBViewAddOnChild: TdsdDBViewAddOn;
    cbNotMoveRemainder6: TcxCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TLayout_MovementForm);

end.
