unit GoodsSPInform_1303;

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
  ExternalLoad;

type
  TGoodsSPInform_1303Form = class(TAncestorDocumentForm)
    actGoodsKindChoice: TOpenChoiceForm;
    spSelectPrint_GoodsSP: TdsdStoredProc;
    N2: TMenuItem;
    N3: TMenuItem;
    RefreshDispatcher: TRefreshDispatcher;
    actRefreshPrice: TdsdDataSetRefresh;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    PrintItemsSverkaCDS: TClientDataSet;
    bbComplete: TdxBarButton;
    spMovementComplete: TdsdStoredProc;
    actComplete: TdsdExecStoredProc;
    edOperDateStart: TcxDateEdit;
    cxLabel3: TcxLabel;
    edOperDateEnd: TcxDateEdit;
    cxLabel4: TcxLabel;
    actIntenalSPChoice: TOpenChoiceForm;
    actKindOutSP_1303Choice: TOpenChoiceForm;
    actBrandSPChoice: TOpenChoiceForm;
    actChoiceMovGoodsSP: TOpenChoiceForm;
    spInsertMI: TdsdStoredProc;
    macInsertMI: TMultiAction;
    actInsertMI: TdsdExecStoredProc;
    actRefreshMI: TdsdDataSetRefresh;
    bbInsertMI: TdxBarButton;
    actDoLoad: TExecuteImportSettingsAction;
    actGetImportSetting: TdsdExecStoredProc;
    spUpdate_isSp_SetErased: TdsdStoredProc;
    actSetErasedGoodsSp: TdsdExecStoredProc;
    macStartLoad: TMultiAction;
    bbStartLoad: TdxBarButton;
    spGetImportSettingId: TdsdStoredProc;
    bbStartLoadDop: TdxBarButton;
    bbStartLoadHelsi: TdxBarButton;
    Dosage_1303Name: TcxGridDBColumn;
    actGoodsMain: TOpenChoiceForm;
    spClearGoods: TdsdStoredProc;
    dxBarButton1: TdxBarButton;
    Color_Count: TcxGridDBColumn;
    Col: TcxGridDBColumn;
    actChoiceGoodsSPInform_1303: TdsdOpenForm;
    dxBarButton2: TdxBarButton;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    actClearGoods: TdsdExecStoredProc;
    dxBarButton3: TdxBarButton;
    spSetGoods: TdsdStoredProc;
    actSetGoods: TdsdExecStoredProc;
    dxBarButton4: TdxBarButton;
    MorionCode: TcxGridDBColumn;
    NDS: TcxGridDBColumn;
    PriceSale: TcxGridDBColumn;
    isSale: TcxGridDBColumn;
    DoubleId: TcxGridDBColumn;
    actGoodsMainEdit: TOpenChoiceForm;
    spUpdate_Goods: TdsdStoredProc;
    spGetImportSettingId_del: TdsdStoredProc;
    actGetImportSettingDel: TdsdExecStoredProc;
    macStartLoadDel: TMultiAction;
    bbStartLoadDel: TdxBarButton;
    actDoLoadDel: TExecuteImportSettingsAction;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TGoodsSPInform_1303Form);

end.
