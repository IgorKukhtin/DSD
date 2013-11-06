unit AncestorEnum;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDBGrid, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, dsdAddOn, dxBarExtItems,
  dxBar, cxClasses, dsdDB, Datasnap.DBClient, dsdAction, Vcl.ActnList,
  cxPropertiesStore, cxGridLevel, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid, cxPCdxBarPopupMenu, cxPC;

type
  TAncestorEnumForm = class(TAncestorDBGridForm)
    ChoiceGuides: TdsdChoiceGuides;
    bbChoice: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AncestorEnumForm: TAncestorEnumForm;

implementation

{$R *.dfm}

end.
