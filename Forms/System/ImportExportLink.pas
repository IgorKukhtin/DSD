unit ImportExportLink;

interface

uses
  DataModul, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDBGrid, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  Vcl.Menus, dsdAddOn, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxPC, cxButtonEdit;

type
  TImportExportLinkForm = class(TAncestorDBGridForm)
    colIntegerKey: TcxGridDBColumn;
    colObjectChildName: TcxGridDBColumn;
    colStringKey: TcxGridDBColumn;
    colObjectMainName: TcxGridDBColumn;
    OpenObjectForm: TOpenChoiceForm;
    spInsertUpdate: TdsdStoredProc;
    UpdateDataSet: TdsdUpdateDataSet;
    OpenObjectChildForm: TOpenChoiceForm;
    colLinkTypeName: TcxGridDBColumn;
    OpenLinkTypeForm: TOpenChoiceForm;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TImportExportLinkForm);


end.
