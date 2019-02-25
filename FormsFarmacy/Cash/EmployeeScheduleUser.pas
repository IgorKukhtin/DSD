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
    FormParams: TdsdFormParams;
    cxGridDBBandedTableView1: TcxGridDBBandedTableView;
    WhoInput: TcxGridDBBandedColumn;
    Value: TcxGridDBBandedColumn;
    cxLabel1: TcxLabel;
    cbValueUser: TcxComboBox;
    spGet: TdsdStoredProc;
    spUpdateEmployeeScheduleUser: TdsdStoredProc;
    HeaderSaver: THeaderSaver;
    HeaderCDS: TClientDataSet;
    CrossDBViewAddOn: TCrossDBViewAddOn;
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
