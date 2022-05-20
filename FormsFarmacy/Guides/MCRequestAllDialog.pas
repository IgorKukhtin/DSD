unit MCRequestAllDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ParentForm, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Vcl.Menus, Vcl.StdCtrls, cxButtons, cxControls,
  cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils, ChoicePeriod,
  dsdGuides, cxDropDownEdit, cxCalendar, cxTextEdit, cxMaskEdit, cxButtonEdit,
  cxPropertiesStore, dsdAddOn, dsdDB, cxLabel, dxSkinsCore,
  dxSkinsDefaultPainters, cxCheckBox, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue,
  cxCurrencyEdit, cxStyles, dxSkinscxPCPainter, cxCustomData, cxFilter, cxData,
  cxDataStorage, Data.DB, cxDBData, Vcl.ActnList, dsdAction, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxClasses,
  cxGridCustomView, cxGrid, Vcl.ExtCtrls, Datasnap.DBClient;

type
  TMCRequestAllDialogForm = class(TParentForm)
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxPropertiesStore: TcxPropertiesStore;
    DataSource: TDataSource;
    ClientDataSet: TClientDataSet;
    spSelect: TdsdStoredProc;
    Panel1: TPanel;
    Panel2: TPanel;
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    MinPrice: TcxGridDBColumn;
    MarginPercentCurr: TcxGridDBColumn;
    MarginPercent: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    ActionList1: TActionList;
    actRefresh: TdsdDataSetRefresh;
    spInsertUpdate: TdsdStoredProc;
    dsdInsertUpdateGuides: TdsdInsertUpdateGuides;
    dsdDataToJson: TdsdDataToJsonAction;
    FormParams: TdsdFormParams;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TMCRequestAllDialogForm);

end.
