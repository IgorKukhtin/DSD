unit Protocol;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorReport, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, cxContainer, Vcl.ComCtrls,
  dxCore, cxDateUtils, dsdAddOn, ChoicePeriod, dxBarExtItems, dxBar, cxClasses,
  dsdDB, Datasnap.DBClient, Vcl.ActnList, dsdAction, cxPropertiesStore, cxLabel,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxButtonEdit, dsdGuides, cxMemo, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, cxPCdxBarPopupMenu, dxSkinsdxBarPainter, cxPC, Vcl.Menus,
  dsdXMLTransform, cxSplitter, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue, dsdCommon;

type
  TProtocolForm = class(TAncestorReportForm)
    colDate: TcxGridDBColumn;
    colUserName: TcxGridDBColumn;
    colObjectName: TcxGridDBColumn;
    edUser: TcxButtonEdit;
    edObjectDesc: TcxButtonEdit;
    edObject: TcxButtonEdit;
    cxLabel3: TcxLabel;
    UserGuides: TdsdGuides;
    cxLabel4: TcxLabel;
    ObjectDescGuides: TdsdGuides;
    ObjectGuides: TdsdGuides;
    cxLabel5: TcxLabel;
    colObjectTypeName: TcxGridDBColumn;
    colInsert: TcxGridDBColumn;
    dsdXMLTransform: TdsdXMLTransform;
    ProtocolDataCDS: TClientDataSet;
    ProtocolDataDS: TDataSource;
    ProtocolDataCDSFieldName: TStringField;
    ProtocolDataCDSFieldValue: TStringField;
    cxSplitter: TcxSplitter;
    cxGridProtocolData: TcxGrid;
    cxGridViewProtocolData: TcxGridDBTableView;
    cxGridDBColumn1: TcxGridDBColumn;
    cxGridDBColumn2: TcxGridDBColumn;
    cxGridLevelProtocolData: TcxGridLevel;
    FormParams: TdsdFormParams;
    actGridTwoToExcel: TdsdGridToExcel;
    bbGridTwoToExcel: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TProtocolForm);
  RegisterClass(TStringField);


end.
