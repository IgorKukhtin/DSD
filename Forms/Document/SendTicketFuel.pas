unit SendTicketFuel;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDocument, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu,
  cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB,
  cxDBData, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dsdAddOn, dsdGuides,
  dsdDB, dxBarExtItems, dxBar, cxClasses, Datasnap.DBClient, dsdAction,
  Vcl.ActnList, cxPropertiesStore, cxButtonEdit, cxMaskEdit, cxDropDownEdit,
  cxCalendar, cxLabel, cxTextEdit, Vcl.ExtCtrls, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGridLevel, cxGridCustomView, cxGrid,
  cxPC, Vcl.Grids, Vcl.DBGrids, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter;

type
  TSendTicketFuelForm = class(TAncestorDocumentForm)
    cxLabel3: TcxLabel;
    edFrom: TcxButtonEdit;
    cxLabel4: TcxLabel;
    edTo: TcxButtonEdit;
    FromGuides: TdsdGuides;
    ToGuides: TdsdGuides;
    colFuelName: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TSendTicketFuelForm);

end.
