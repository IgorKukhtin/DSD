unit EmployeeScheduleUser;

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
  cxGridBandedTableView, cxGridDBBandedTableView;

type
  TEmployeeScheduleUserForm = class(TAncestorDBGridForm)
    bbOpen: TdxBarButton;
    Panel: TPanel;
    edOperDate: TcxDateEdit;
    cxLabel2: TcxLabel;
    edCashRegisterName: TcxTextEdit;
    cxLabel1: TcxLabel;
    FormParams: TdsdFormParams;
    cxGridDBBandedTableView1: TcxGridDBBandedTableView;
    Range: TcxGridDBBandedColumn;
    Value1: TcxGridDBBandedColumn;
    Value2: TcxGridDBBandedColumn;
    Value3: TcxGridDBBandedColumn;
    Value4: TcxGridDBBandedColumn;
    Value5: TcxGridDBBandedColumn;
    Value6: TcxGridDBBandedColumn;
    Value7: TcxGridDBBandedColumn;
    ValuePlan1: TcxGridDBBandedColumn;
    ValuePlan2: TcxGridDBBandedColumn;
    ValuePlan3: TcxGridDBBandedColumn;
    ValuePlan4: TcxGridDBBandedColumn;
    ValuePlan5: TcxGridDBBandedColumn;
    ValuePlan6: TcxGridDBBandedColumn;
    ValuePlan7: TcxGridDBBandedColumn;
    Color1: TcxGridDBBandedColumn;
    Color2: TcxGridDBBandedColumn;
    Color3: TcxGridDBBandedColumn;
    Color4: TcxGridDBBandedColumn;
    Color5: TcxGridDBBandedColumn;
    Color6: TcxGridDBBandedColumn;
    Color7: TcxGridDBBandedColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TEmployeeScheduleUserForm);

end.
