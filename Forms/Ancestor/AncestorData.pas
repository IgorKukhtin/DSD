unit AncestorData;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorBase, Vcl.ActnList, dsdAction,
  cxPropertiesStore, dsdAddOn, dxBarExtItems, dxBar, cxClasses, dsdDB, Data.DB,
  Datasnap.DBClient, Vcl.Menus, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinsdxBarPainter;

type
  TAncestorDataForm = class(TAncestorBaseForm)
    MasterDS: TDataSource;
    MasterCDS: TClientDataSet;
    spSelect: TdsdStoredProc;
    BarManager: TdxBarManager;
    Bar: TdxBar;
    bbRefresh: TdxBarButton;
    dxBarStatic: TdxBarStatic;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
