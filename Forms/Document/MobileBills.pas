unit MobileBills;

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
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter;

type
  TMobileBillsForm = class(TAncestorDocumentForm)
    MobileEmployeeCode: TcxGridDBColumn;
    MobileEmployeeName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    spSelectPrint: TdsdStoredProc;
    N2: TMenuItem;
    N3: TMenuItem;
    RefreshDispatcher: TRefreshDispatcher;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    PrintItemsSverkaCDS: TClientDataSet;
    CurrMonthly: TcxGridDBColumn;
    RegionName: TcxGridDBColumn;
    EmployeeName: TcxGridDBColumn;
    PrevEmployeeName: TcxGridDBColumn;
    PrevMobileTariffName: TcxGridDBColumn;
    actPersonalChoiceForm: TOpenChoiceForm;
    actRegionChoiceForm: TOpenChoiceForm;
    actMobileTariffChoiceForm: TOpenChoiceForm;
    DutyLimit: TcxGridDBColumn;
    MobileTariffName: TcxGridDBColumn;
    Overlimit: TcxGridDBColumn;
    actMobileEmployeeChoiceForm: TOpenChoiceForm;
    actInsertRecord: TInsertRecord;
    bbInsertRecord: TdxBarButton;
    cxLabel9: TcxLabel;
    edContract: TcxButtonEdit;
    ContractGuides: TdsdGuides;
    isDateOut: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    UnitName_prev: TcxGridDBColumn;
    BranchName: TcxGridDBColumn;
    PositionName: TcxGridDBColumn;
    PositionName_prev: TcxGridDBColumn;
    MobileEmployeeComment: TcxGridDBColumn;
    ItemName: TcxGridDBColumn;
    isPrev: TcxGridDBColumn;
    Amount_ProfitLoss: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TMobileBillsForm);

end.
