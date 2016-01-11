unit BankAccountMovementFarmacy;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BankAccountMovement, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, cxControls, cxContainer,
  cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils, dsdGuides, dsdDB, dsdAction,
  Vcl.ActnList, cxPropertiesStore, dsdAddOn, cxTextEdit, cxCurrencyEdit,
  cxButtonEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, cxLabel, Vcl.StdCtrls,
  cxButtons, cxClasses, dxSkinsCore, dxSkinsDefaultPainters, cxStyles,
  dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage, Data.DB,
  cxDBData, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  Datasnap.DBClient, cxGridLevel, cxGridCustomView, cxGrid;

type
  TBankAccountMovementFarmacyForm = class(TBankAccountMovementForm)
    edIncome: TcxButtonEdit;
    GuidesIncome: TdsdGuides;
    cxLabel15: TcxLabel;
    rdAmountOut: TRefreshDispatcher;
    grtvIncome: TcxGridDBTableView;
    grlIncome: TcxGridLevel;
    grIncome: TcxGrid;
    IncomeCDS: TClientDataSet;
    IncomeDS: TDataSource;
    spSelectIncomeBySumm: TdsdStoredProc;
    actSelectIncomeBySumm: TdsdDataSetRefresh;
    colInvNumber: TcxGridDBColumn;
    colOperDate: TcxGridDBColumn;
    colFromName: TcxGridDBColumn;
    colJuridicalName: TcxGridDBColumn;
    DBViewAddOn: TdsdDBViewAddOn;
    UpdateRecord1: TUpdateRecord;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization

  RegisterClass (TBankAccountMovementFarmacyForm)


end.
