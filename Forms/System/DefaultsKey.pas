unit DefaultsKey;

interface

uses
  DataModul, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorEnum, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  Vcl.Menus, dsdAddOn, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxPC, Defaults, cxButtonEdit;

type
  TDefaultsKeyForm = class(TAncestorEnumForm)
    colKey: TcxGridDBColumn;
    colFormClassName: TcxGridDBColumn;
    colDescName: TcxGridDBColumn;
    DefaultKey: TDefaultKey;
    spInsertUpdateKey: TdsdStoredProc;
    InsertUpdateKey: TdsdUpdateDataSet;
    OpenFormsForm: TOpenChoiceForm;
    OpenUnionDescForm: TOpenChoiceForm;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TDefaultsKeyForm);

end.
