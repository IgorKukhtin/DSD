unit PromoBonus;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDocument, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu,
  cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB,
  cxDBData, cxCurrencyEdit, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils,
  dsdAddOn, dsdGuides, dsdDB, Vcl.Menus, dxBarExtItems, dxBar, cxClasses,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxButtonEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, cxLabel, cxTextEdit, Vcl.ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridCustomView, cxGrid, cxPC, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter, cxSplitter, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue,
  cxCheckBox, DataModul;

type
  TPromoBonusForm = class(TAncestorDocumentForm)
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    PrintItemsCDS: TClientDataSet;
    PrintHeaderCDS: TClientDataSet;
    cxLabel7: TcxLabel;
    edComment: TcxTextEdit;
    bbOpenPartionDateKind: TdxBarButton;
    bbInsertMI: TdxBarButton;
    cxLabel10: TcxLabel;
    edInsertName: TcxButtonEdit;
    GuidesInsert: TdsdGuides;
    cxLabel12: TcxLabel;
    edInsertdate: TcxDateEdit;
    cxLabel11: TcxLabel;
    edUpdateName: TcxButtonEdit;
    cxLabel13: TcxLabel;
    edUpdateDate: TcxDateEdit;
    GuidesUpdate: TdsdGuides;
    RefreshDispatcher: TRefreshDispatcher;
    actRefreshUnit: TdsdDataSetRefresh;
    bbOpenFormPromo: TdxBarButton;
    bbMIChildProtocolOpenForm: TdxBarButton;
    dxBarButton1: TdxBarButton;
    MakerName: TcxGridDBColumn;
    actInsertByPromo: TdsdExecStoredProc;
    spInsertByPromo: TdsdStoredProc;
    dxBarButton2: TdxBarButton;
    actOpenFormPromo: TdsdInsertUpdateAction;
    macMarketingBonus: TMultiAction;
    actExec_Update_MarketingBonus: TdsdExecStoredProc;
    actExecuteDialogactMarketingBonus: TExecuteDialog;
    dxBarButton3: TdxBarButton;
    sptExec_Update_MarketingBonus: TdsdStoredProc;
    DateUpdate: TcxGridDBColumn;
    actReport_GoodsPrice_PromoBonus: TdsdOpenForm;
    dxBarButton4: TdxBarButton;
    GoodsGroupPromoName: TcxGridDBColumn;
    actReport_Reprice_PromoBonus: TdsdOpenForm;
    dxBarButton5: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TPromoBonusForm);

end.
