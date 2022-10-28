unit PUSH;

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
  dsdExportToXLSAction, cxMemo, cxDBEdit, cxCheckBox;

type
  TPUSHForm = class(TAncestorDocumentForm)
    UserCode: TcxGridDBColumn;
    UserName: TcxGridDBColumn;
    bbPrintCheck: TdxBarButton;
    bbGet_SP_Prior: TdxBarButton;
    dxBarButton1: TdxBarButton;
    dxBarButton2: TdxBarButton;
    dxBarButton3: TdxBarButton;
    cxLabel3: TcxLabel;
    DateViewed: TcxGridDBColumn;
    actUpdateMessage: TdsdUpdateDataSet;
    edMessage: TcxMemo;
    edDateEndPUSH: TcxDateEdit;
    cxLabel4: TcxLabel;
    UnitName: TcxGridDBColumn;
    cxLabel5: TcxLabel;
    edReplays: TcxCurrencyEdit;
    Views: TcxGridDBColumn;
    tsChild: TcxTabSheet;
    cxGridChild: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    chisErased: TcxGridDBColumn;
    chUnitCode: TcxGridDBColumn;
    chUnitName: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    dxBarButton4: TdxBarButton;
    dxBarButton5: TdxBarButton;
    dxBarButton6: TdxBarButton;
    spSelectChild: TdsdStoredProc;
    ChildDS: TDataSource;
    ChildCDS: TClientDataSet;
    dxBarButton7: TdxBarButton;
    chbDaily: TcxCheckBox;
    chParentName: TcxGridDBColumn;
    DBViewAddOnChild: TdsdDBViewAddOn;
    edFunction: TcxTextEdit;
    cxLabel6: TcxLabel;
    chbPoll: TcxCheckBox;
    Result: TcxGridDBColumn;
    edRetail: TcxButtonEdit;
    cxLabel19: TcxLabel;
    GuidesRetail: TdsdGuides;
    chbPharmacist: TcxCheckBox;
    edForm: TcxTextEdit;
    cxLabel7: TcxLabel;
    ViewsLastDay: TcxGridDBColumn;
    ViewsCurrDay: TcxGridDBColumn;
    cbAtEveryEntry: TcxCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TPUSHForm);

end.
