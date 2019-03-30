unit EmployeeScheduleUnit;

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
  cxGridBandedTableView, cxGridDBBandedTableView, DataModul, cxSplitter;

type
  TEmployeeScheduleUnitForm = class(TAncestorDBGridForm)
    bbOpen: TdxBarButton;
    FormParams: TdsdFormParams;
    cxGridDBBandedTableView1: TcxGridDBBandedTableView;
    Note: TcxGridDBBandedColumn;
    Value: TcxGridDBBandedColumn;
    HeaderSaver: THeaderSaver;
    HeaderCDS: TClientDataSet;
    CrossDBViewAddOn: TCrossDBViewAddOn;
    NoteNext: TcxGridDBBandedColumn;
    ValueUser: TcxGridDBBandedColumn;
    HeaderUserCDS: TClientDataSet;
    CrossDBViewUserAddOn: TCrossDBViewAddOn;
    cxGridSubstitution: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    cxGridDBBandedTableViewSubstitution: TcxGridDBBandedTableView;
    Substitution_Note: TcxGridDBBandedColumn;
    Substitution_Value: TcxGridDBBandedColumn;
    cxGridLevelSubstitution: TcxGridLevel;
    Substitution_ValueNext: TcxGridDBBandedColumn;
    SubstitutionDS: TDataSource;
    SubstitutionCDS: TClientDataSet;
    CrossDBViewAddOnSubstitutionNext: TCrossDBViewAddOn;
    CrossDBViewAddOnSubstitution: TCrossDBViewAddOn;
    Substitution_PersonalName: TcxGridDBBandedColumn;
    PersonalName: TcxGridDBBandedColumn;
    cxSplitter1: TcxSplitter;
    PersonNull: TcxGridDBBandedColumn;
    ValueNext: TcxGridDBBandedColumn;
    NoteUser: TcxGridDBBandedColumn;
    PersonNull1: TcxGridDBBandedColumn;
    CrossDBViewAddOnNext: TCrossDBViewAddOn;
    Substitution_PersonNull: TcxGridDBBandedColumn;
    Substitution_NoteNext: TcxGridDBBandedColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TEmployeeScheduleUnitForm);

end.
