unit SetUserDefaults;

interface

uses
  DataModul, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDBGrid, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  Vcl.Menus, dsdAddOn, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxPC, cxButtonEdit, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter;

type
  TSetUserDefaultsForm = class(TAncestorDBGridForm)
    colDefaultKey: TcxGridDBColumn;
    colUserKey: TcxGridDBColumn;
    colValue: TcxGridDBColumn;
    colFormClassName: TcxGridDBColumn;
    colDescName: TcxGridDBColumn;
    OpenDefaultsKeyForm: TOpenChoiceForm;
    OpenUserKeyForm: TOpenChoiceForm;
    OpenObjectForm: TOpenChoiceForm;
    spInsertUpdate: TdsdStoredProc;
    UpdateDataSet: TdsdUpdateDataSet;
    ItemName_user: TcxGridDBColumn;
    ItemName_value: TcxGridDBColumn;
    spInsertUpdateNull: TdsdStoredProc;
    actUpdateDefaultValue: TdsdExecStoredProc;
    bbUpdateDefaultValue: TdxBarButton;
    macUpdateDefaultValue: TMultiAction;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TSetUserDefaultsForm);


end.
