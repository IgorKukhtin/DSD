unit PeriodClose;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDBGrid, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  Vcl.Menus, dsdAddOn, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxPC, cxButtonEdit, cxCalendar, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter, cxContainer, Vcl.ComCtrls, dxCore,
  cxDateUtils, cxLabel, cxTextEdit, cxMaskEdit, cxDropDownEdit, Vcl.ExtCtrls,
  dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue;

type
  TPeriodCloseForm = class(TAncestorDBGridForm)
    RoleName: TcxGridDBColumn;
    OperDate: TcxGridDBColumn;
    UserName: TcxGridDBColumn;
    CloseDate: TcxGridDBColumn;
    Period: TcxGridDBColumn;
    actUserForm_excl: TOpenChoiceForm;
    actRoleForm: TOpenChoiceForm;
    actBranchForm: TOpenChoiceForm;
    spInsertUpdate: TdsdStoredProc;
    UpdateDataSet: TdsdUpdateDataSet;
    Code: TcxGridDBColumn;
    Name: TcxGridDBColumn;
    RoleCode: TcxGridDBColumn;
    UserName_list: TcxGridDBColumn;
    isUserName: TcxGridDBColumn;
    UserCode_excl: TcxGridDBColumn;
    UserName_excl: TcxGridDBColumn;
    CloseDate_excl: TcxGridDBColumn;
    DescId: TcxGridDBColumn;
    DescName: TcxGridDBColumn;
    DescId_excl: TcxGridDBColumn;
    DescName_excl: TcxGridDBColumn;
    PaidKindCode: TcxGridDBColumn;
    PaidKindName: TcxGridDBColumn;
    BranchCode: TcxGridDBColumn;
    BranchName: TcxGridDBColumn;
    actPaidKindForm: TOpenChoiceForm;
    Panel: TPanel;
    deOperDate: TcxDateEdit;
    cxLabel1: TcxLabel;
    actUpdate_CloseDate: TdsdExecStoredProc;
    spUpdate_CloseDate: TdsdStoredProc;
    bbUpdate_PeriodClose_all: TdxBarButton;
    mactUpdate_CloseDate: TMultiAction;
    UserByGroupName_excl: TcxGridDBColumn;
    actUserByGroupForm_excl: TOpenChoiceForm;
    UserByGroupCode_excl: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization

  RegisterClass(TPeriodCloseForm);

end.
