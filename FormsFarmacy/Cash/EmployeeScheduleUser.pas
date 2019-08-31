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
  cxGridBandedTableView, cxGridDBBandedTableView, DataModul, Vcl.StdCtrls,
  cxButtons;

type
  TEmployeeScheduleUserForm = class(TAncestorDBGridForm)
    bbOpen: TdxBarButton;
    Panel: TPanel;
    edOperDate: TcxDateEdit;
    cxLabel2: TcxLabel;
    FormParams: TdsdFormParams;
    cxGridDBBandedTableView1: TcxGridDBBandedTableView;
    Note: TcxGridDBBandedColumn;
    Value: TcxGridDBBandedColumn;
    cxLabel1: TcxLabel;
    cbValueUser: TcxComboBox;
    spGet: TdsdStoredProc;
    spUpdateEmployeeScheduleUser: TdsdStoredProc;
    HeaderSaver: THeaderSaver;
    HeaderCDS: TClientDataSet;
    CrossDBViewAddOn: TCrossDBViewAddOn;
    NoteUser: TcxGridDBBandedColumn;
    ValueUser: TcxGridDBBandedColumn;
    HeaderUserCDS: TClientDataSet;
    CrossDBViewUserAddOn: TCrossDBViewAddOn;
    Color_Calc: TcxGridDBBandedColumn;
    Color_CalcFont: TcxGridDBBandedColumn;
    Color_CalcFontUser: TcxGridDBBandedColumn;
    cxGridSubstitution: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    cxGridDBBandedTableViewSubstitution: TcxGridDBBandedTableView;
    Substitution_Note: TcxGridDBBandedColumn;
    Substitution_Value: TcxGridDBBandedColumn;
    Substitution_Color_CalcFont: TcxGridDBBandedColumn;
    cxGridLevelSubstitution: TcxGridLevel;
    Substitution_UnitName: TcxGridDBBandedColumn;
    Substitution_ValueNext: TcxGridDBBandedColumn;
    SubstitutionDS: TDataSource;
    SubstitutionCDS: TClientDataSet;
    CrossDBViewAddOnSubstitutionNext: TCrossDBViewAddOn;
    CrossDBViewAddOnSubstitution: TCrossDBViewAddOn;
    actEmployeeScheduleUnit: TdsdOpenForm;
    dxBarButton1: TdxBarButton;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    edStart: TcxTextEdit;
    edEnd: TcxTextEdit;
    cxLabel5: TcxLabel;
    cxButton1: TcxButton;
    InsertUpdateGuides: TdsdInsertUpdateGuides;
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
