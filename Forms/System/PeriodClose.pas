unit PeriodClose;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDBGrid, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  Vcl.Menus, dsdAddOn, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxPC, cxButtonEdit, cxCalendar, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter;

type
  TPeriodCloseForm = class(TAncestorDBGridForm)
    colRoleName: TcxGridDBColumn;
    colUnitName: TcxGridDBColumn;
    colUserName: TcxGridDBColumn;
    colCloseDate: TcxGridDBColumn;
    colPeriod: TcxGridDBColumn;
    actUserForm: TOpenChoiceForm;
    actRoleForm: TOpenChoiceForm;
    actUnitForm: TOpenChoiceForm;
    spInsertUpdate: TdsdStoredProc;
    UpdateDataSet: TdsdUpdateDataSet;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization

  RegisterClass(TPeriodCloseForm);

end.
