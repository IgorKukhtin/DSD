unit ContractChoice;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorEnum, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  dsdAddOn, dxBarExtItems, dxBar, cxClasses, dsdDB, Datasnap.DBClient,
  dsdAction, Vcl.ActnList, cxPropertiesStore, cxGridLevel, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, cxPC,
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinsdxBarPainter,
  Vcl.Menus, cxImageComboBox, cxContainer, cxTextEdit, cxMaskEdit, cxButtonEdit,
  cxLabel, dsdGuides;

type
  TContractChoiceForm = class(TAncestorEnumForm)
    colInvNumber: TcxGridDBColumn;
    colStartDate: TcxGridDBColumn;
    colContractKindName: TcxGridDBColumn;
    colJuridicalCode: TcxGridDBColumn;
    colJuridicalName: TcxGridDBColumn;
    colPaidKindName: TcxGridDBColumn;
    colInfoMoneyName: TcxGridDBColumn;
    colisErased: TcxGridDBColumn;
    clOKPO: TcxGridDBColumn;
    clEndDate: TcxGridDBColumn;
    clInfoMoneyDestinationName: TcxGridDBColumn;
    clInfoMoneyGroupName: TcxGridDBColumn;
    clInfoMoneyCode: TcxGridDBColumn;
    FormParams: TdsdFormParams;
    actShowAll: TBooleanStoredProcAction;
    bbShowAll: TdxBarButton;
    cxLabel6: TcxLabel;
    edJuridical: TcxButtonEdit;
    bbJuridicalLabel: TdxBarControlContainerItem;
    bbJuridical: TdxBarControlContainerItem;
    JuridicalGuides: TdsdGuides;
    RefreshDispatcher: TRefreshDispatcher;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization

registerClass(TContractChoiceForm);

end.
