unit EmailSettings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorEnum, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  Vcl.Menus, dsdAddOn, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxPC, dsdGuides, cxContainer, cxTextEdit, cxMaskEdit, cxButtonEdit,
  cxLabel, cxCurrencyEdit, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter, Vcl.ExtCtrls;

type
  TEmailSettingsForm = class(TAncestorEnumForm)
    colCode: TcxGridDBColumn;
    colValue: TcxGridDBColumn;
    spInsertUpdate: TdsdStoredProc;
    actInsertUpdate: TdsdUpdateDataSet;
    EmailGuides: TdsdGuides;
    bbLabel: TdxBarControlContainerItem;
    bbGuides: TdxBarControlContainerItem;
    RefreshDispatcher: TRefreshDispatcher;
    Panel: TPanel;
    cxLabel4: TcxLabel;
    ceEmail: TcxButtonEdit;
    colEmailKindName: TcxGridDBColumn;
    colEmailToolsName: TcxGridDBColumn;
    colEmailName: TcxGridDBColumn;
    colJuridicalName: TcxGridDBColumn;
    actShowAll: TBooleanStoredProcAction;
    bbShowAll: TdxBarButton;
    cxLabel1: TcxLabel;
    bbInsertUpdate: TdxBarButton;
    spInsertUpdate_Juridical: TdsdStoredProc;
    actInsertUpdateJuridical0: TdsdExecStoredProc;
    mactInsertUpdateJuridical1: TMultiAction;
    macInsertUpdateJuridicalList: TMultiAction;
    edValue: TcxTextEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TEmailSettingsForm)


end.
