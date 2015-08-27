unit TransportServiceJournal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorJournal, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dsdAddOn, ChoicePeriod,
  dxBarExtItems, dxBar, cxClasses, dsdDB, Datasnap.DBClient, dsdAction,
  Vcl.ActnList, cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, cxPC,
  cxCheckBox, cxImageComboBox, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter, Vcl.Menus, cxCurrencyEdit,
  cxButtonEdit, cxBlobEdit;

type
  TTransportServiceJournalForm = class(TAncestorJournalForm)
    clDistance: TcxGridDBColumn;
    clPrice: TcxGridDBColumn;
    clCountPoint: TcxGridDBColumn;
    clTrevelTime: TcxGridDBColumn;
    clRouteName: TcxGridDBColumn;
    clContractConditionKindName: TcxGridDBColumn;
    spInsertUpdate: TdsdStoredProc;
    actUpdateDataSet: TdsdUpdateDataSet;
    InfoMoneyChoiceForm: TOpenChoiceForm;
    CarChoiceForm: TOpenChoiceForm;
    RouteChoiceForm: TOpenChoiceForm;
    ContractConditionKindChoiceForm: TOpenChoiceForm;
    PaidKindChoiceForm: TOpenChoiceForm;
    clContractName: TcxGridDBColumn;
    ContractChoiceForm: TOpenChoiceForm;
    clInfoMoneyCode: TcxGridDBColumn;
    clJuridicalName: TcxGridDBColumn;
    clInfoMoneyGroupName: TcxGridDBColumn;
    clInfoMoneyDestinationName: TcxGridDBColumn;
    clUnitForwardingName: TcxGridDBColumn;
    StartRun: TcxGridDBColumn;
    StartRunPlan: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TTransportServiceJournalForm);

end.
