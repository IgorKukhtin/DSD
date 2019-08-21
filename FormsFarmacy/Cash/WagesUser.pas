unit WagesUser;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDBGrid, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  Vcl.Menus, dsdAddOn, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxPC, dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter,
  dxSkinsdxBarPainter, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils,
  cxTextEdit, cxLabel, cxMaskEdit, cxDropDownEdit, cxCalendar, Vcl.ExtCtrls,
  cxGridBandedTableView, cxGridDBBandedTableView, DataModul, cxCurrencyEdit;

type
  TWagesUserForm = class(TAncestorDBGridForm)
    bbOpen: TdxBarButton;
    Panel: TPanel;
    edOperDate: TcxDateEdit;
    cxLabel2: TcxLabel;
    FormParams: TdsdFormParams;
    spGet: TdsdStoredProc;
    dxBarButton1: TdxBarButton;
    cxGridDBTableViewColumn1: TcxGridDBColumn;
    cxGridDBTableViewColumn2: TcxGridDBColumn;
    cxGridDBTableViewColumn3: TcxGridDBColumn;
    PanelBottom: TPanel;
    ceTotal: TcxCurrencyEdit;
    cxLabel4: TcxLabel;
    ceCard: TcxCurrencyEdit;
    cxLabel1: TcxLabel;
    ceOnHand: TcxCurrencyEdit;
    cxLabel3: TcxLabel;
    actDataDialog: TExecuteDialog;
    dxBarButton2: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TWagesUserForm);

end.
