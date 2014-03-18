unit DialogBillKind;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  AncestorDialog, dsdDB, Data.DB, Datasnap.DBClient, Vcl.Grids, Vcl.DBGrids,
  Data.Bind.EngExt, Vcl.Bind.DBEngExt, System.Rtti, System.Bindings.Outputs,
  Vcl.Bind.Editors, Data.Bind.Components, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, cxDBData, cxCheckBox, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxClasses,
  cxGridCustomView, cxGrid, dsdAddOn;

type
  TDialogBillKindForm = class(TAncestorDialogForm)
    gbPartnerAll: TGroupBox;
    PanelPartner: TPanel;
    LabelPartner: TLabel;
    gbPartnerCode: TGroupBox;
    EditPartnerCode: TEdit;
    gbPartnerName: TGroupBox;
    PanelPartnerName: TPanel;
    PanelRouteUnit: TPanel;
    LabelRouteUnit: TLabel;
    gbRouteUnitCode: TGroupBox;
    EditRouteUnitCode: TEdit;
    gbRouteUnitName: TGroupBox;
    PanelRouteUnitName: TPanel;
    gbGrid: TGroupBox;
    ClientDataSet: TClientDataSet;
    DataSource: TDataSource;
    spData: TdsdStoredProc;
    BindingsList1: TBindingsList;
    BindGridListDBGrid1: TBindGridList;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    clCarModel: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DialogBillKindForm: TDialogBillKindForm;

implementation

{$R *.dfm}



procedure TDialogBillKindForm.FormCreate(Sender: TObject);
begin
  inherited;
  spData.Execute;
  TDrawGrid(DBGrid).ScrollBars:=ssNone;
end;

end.
