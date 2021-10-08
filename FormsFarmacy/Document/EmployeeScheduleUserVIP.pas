unit EmployeeScheduleUserVIP;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDialog, Vcl.ActnList, dsdAction, Datasnap.DBClient,
  cxClasses, cxPropertiesStore, dsdAddOn, cxGraphics, cxControls, DateUtils,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.Menus,
  Vcl.StdCtrls, cxButtons, cxTextEdit, Vcl.ExtCtrls, dsdGuides, dsdDB,
  cxMaskEdit, cxButtonEdit, AncestorBase, dxSkinsCore, dxSkinsDefaultPainters, Data.DB,
  Vcl.ComCtrls, dxCore, cxDateUtils, cxCheckBox, cxDropDownEdit,
  cxLabel, cxCalendar, cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage,
  cxNavigator, cxDBData, cxGridLevel, cxGridCustomTableView,
  cxGridTableView, cxGridBandedTableView, cxGridDBBandedTableView,
  cxGridCustomView, cxGridDBTableView, cxGrid, dxSkinscxPCPainter;

type
  TEmployeeScheduleUserVIPForm = class(TAncestorBaseForm)
    edOperDate: TcxDateEdit;
    cxLabel2: TcxLabel;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    cxLabel5: TcxLabel;
    cbStartHour: TcxComboBox;
    cbStartMin: TcxComboBox;
    cxLabel6: TcxLabel;
    cbEndMin: TcxComboBox;
    cxLabel7: TcxLabel;
    cbEndHour: TcxComboBox;
    Panel1: TPanel;
    Panel2: TPanel;
    MasterCDS: TClientDataSet;
    HeaderCDS: TClientDataSet;
    spSelect: TdsdStoredProc;
    MasterDS: TDataSource;
    spGet: TdsdStoredProc;
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    cxGridDBBandedTableView1: TcxGridDBBandedTableView;
    Name0: TcxGridDBBandedColumn;
    Name1: TcxGridDBBandedColumn;
    Name2: TcxGridDBBandedColumn;
    Value: TcxGridDBBandedColumn;
    ValueStart: TcxGridDBBandedColumn;
    ValueEnd: TcxGridDBBandedColumn;
    Color_Calc: TcxGridDBBandedColumn;
    cxGridLevel: TcxGridLevel;
    CrossDBViewAddOn: TCrossDBViewAddOn;
    CrossDBViewStartAddOn: TCrossDBViewAddOn;
    CrossDBViewEndAddOn: TCrossDBViewAddOn;
    cxButton2: TcxButton;
    cxButton1: TcxButton;
    actFormCloseCancel: TdsdFormClose;
    actFormCloseOk: TdsdFormClose;
    spInsertUpdateMI: TdsdStoredProc;
    actInsertUpdateMI: TdsdExecStoredProc;
    actSetFocused: TdsdSetFocusedAction;
    FormParams: TdsdFormParams;
  private
    { Private declarations }
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TEmployeeScheduleUserVIPForm);

End.
