unit PersonalGroupMovement;

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
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue;

type
  TPersonalGroupMovementForm = class(TAncestorDocumentForm)
    cxLabel3: TcxLabel;
    edPairDay: TcxButtonEdit;
    PersonalCode: TcxGridDBColumn;
    PersonalName: TcxGridDBColumn;
    spSelectPrint: TdsdStoredProc;
    N2: TMenuItem;
    N3: TMenuItem;
    RefreshDispatcher: TRefreshDispatcher;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    PrintItemsSverkaCDS: TClientDataSet;
    PositionName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    PositionLevelName: TcxGridDBColumn;
    actPersonalChoiceForm: TOpenChoiceForm;
    UnitName_inf: TcxGridDBColumn;
    cxLabel5: TcxLabel;
    edUnit: TcxButtonEdit;
    cxLabel6: TcxLabel;
    edPersonalGroup: TcxButtonEdit;
    InsertRecord: TInsertRecord;
    bbInsertRecord: TdxBarButton;
    GuidesPersonalGroup: TdsdGuides;
    PositionName_inf: TcxGridDBColumn;
    edInsertName: TcxButtonEdit;
    cxLabel7: TcxLabel;
    cxLabel8: TcxLabel;
    edInsertDate: TcxDateEdit;
    edUpdateName: TcxButtonEdit;
    cxLabel4: TcxLabel;
    edUpdateDate: TcxDateEdit;
    cxLabel9: TcxLabel;
    GuidesUnit: TdsdGuides;
    actPositionChoiceForm: TOpenChoiceForm;
    spInsert_MI: TdsdStoredProc;
    actRefreshMI: TdsdDataSetRefresh;
    PersonalGroupName: TcxGridDBColumn;
    GuidesPairDay: TdsdGuides;
    actWorkTimeKindChoiceForm: TOpenChoiceForm;
    WorkTimeKindName: TcxGridDBColumn;
    Comment: TcxGridDBColumn;
    Count_Personal: TcxGridDBColumn;
    DateOut: TcxGridDBColumn;
    isMain: TcxGridDBColumn;
    WorkTimeKindCode: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TPersonalGroupMovementForm);

end.
