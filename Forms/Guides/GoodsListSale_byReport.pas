unit GoodsListSale_byReport;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxPropertiesStore,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
  cxEdit, Vcl.Menus, Vcl.StdCtrls, cxButtons, cxLabel, cxTextEdit, Vcl.ActnList,
  Vcl.StdActns, cxCurrencyEdit, cxCheckBox,
  Data.DB, Datasnap.DBClient, cxMaskEdit, cxDropDownEdit,
  cxLookupEdit, cxDBLookupEdit, cxDBLookupComboBox, ParentForm, dsdGuides,
  dsdDB, dsdAction, dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, dsdAddOn, cxButtonEdit, Vcl.ComCtrls, dxCore, cxDateUtils,
  cxGroupBox, cxCalendar;

type
  TGoodsListSale_byReportForm = class(TParentForm)
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    ActionList: TActionList;
    spReport: TdsdStoredProc;
    FormParams: TdsdFormParams;
    dsdDataSetRefresh: TdsdDataSetRefresh;
    dsdFormClose: TdsdFormClose;
    cxPropertiesStore: TcxPropertiesStore;
    dsdInsertUpdateGuides: TdsdInsertUpdateGuides;
    cxLabel3: TcxLabel;
    edStartDate1: TcxDateEdit;
    cxLabel4: TcxLabel;
    edEndDate1: TcxDateEdit;
    cxLabel7: TcxLabel;
    edStartDate2: TcxDateEdit;
    cxLabel8: TcxLabel;
    edEndDate2: TcxDateEdit;
    cxLabel9: TcxLabel;
    edStartDate3: TcxDateEdit;
    edEndDate3: TcxDateEdit;
    cxLabel10: TcxLabel;
    edInfoMoney: TcxButtonEdit;
    GuidesInfoMoney: TdsdGuides;
    cxLabel5: TcxLabel;
    cxLabel11: TcxLabel;
    edInfoMoneyDestination: TcxButtonEdit;
    GuidesInfoMoneyDestination: TdsdGuides;
    cxLabel1: TcxLabel;
    edInfoMoney2: TcxButtonEdit;
    GuidesInfoMoney2: TdsdGuides;
    cxLabel2: TcxLabel;
    edInfoMoneyDestination2: TcxButtonEdit;
    GuidesInfoMoneyDestination2: TdsdGuides;
    cxGroupBox1: TcxGroupBox;
    cxGroupBox2: TcxGroupBox;
    cxGroupBox3: TcxGroupBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

initialization
  RegisterClass(TGoodsListSale_byReportForm);

end.
