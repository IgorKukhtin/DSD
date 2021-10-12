unit GoodsSP_Movement_Cash;

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
  TGoodsSP_Movement_CashForm = class(TAncestorDocumentForm)
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
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
    spInsertMI: TdsdStoredProc;
    actInsertMI: TdsdExecStoredProc;
    actRefreshMI: TdsdDataSetRefresh;
    bbInsertMI: TdxBarButton;
    spUpdate_isSp_SetErased: TdsdStoredProc;
    bbStartLoad: TdxBarButton;
    spGetImportSettingId: TdsdStoredProc;
    IdSP: TcxGridDBColumn;
    spGetImportSettingDopId: TdsdStoredProc;
    actDoLoadDop: TExecuteImportSettingsAction;
    actGetImportSettingDop: TdsdExecStoredProc;
    macStartLoadDop: TMultiAction;
    bbStartLoadDop: TdxBarButton;
    spGetImportSettingHelsiId: TdsdStoredProc;
    bbStartLoadHelsi: TdxBarButton;
    GuidesMedicalProgramSP: TdsdGuides;
    edMedicalProgramSP: TcxButtonEdit;
    cxLabel5: TcxLabel;
    CountSPMin: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TGoodsSP_Movement_CashForm);

end.
