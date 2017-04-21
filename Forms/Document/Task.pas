unit Task;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDocument, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dxSkinsdxBarPainter, dsdAddOn,
  dsdGuides, dsdDB, Vcl.Menus, dxBarExtItems, dxBar, cxClasses,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxButtonEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, cxLabel, cxTextEdit, Vcl.ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridCustomView, cxGrid, cxPC, cxCurrencyEdit, cxCheckBox, frxClass, frxDBSet,
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter;

type
  TTaskForm = class(TAncestorDocumentForm)
    cxLabel3: TcxLabel;
    edPersonalTrade: TcxButtonEdit;
    GuidesPersonalTrade: TdsdGuides;
    colPartnerCode: TcxGridDBColumn;
    colPartnerName: TcxGridDBColumn;
    spSelectPrint: TdsdStoredProc;
    N2: TMenuItem;
    N3: TMenuItem;
    RefreshDispatcher: TRefreshDispatcher;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    PrintItemsSverkaCDS: TClientDataSet;
    colDescription: TcxGridDBColumn;
    colisClose: TcxGridDBColumn;
    clComment: TcxGridDBColumn;
    actPartnerChoiceForm: TOpenChoiceForm;
    colUpdateMobileDate: TcxGridDBColumn;
    edBranch: TcxButtonEdit;
    cxLabel4: TcxLabel;
    cxLabel5: TcxLabel;
    edUnit: TcxButtonEdit;
    cxLabel6: TcxLabel;
    edPosition: TcxButtonEdit;
    InsertRecord: TInsertRecord;
    bbInsertRecord: TdxBarButton;
    GuidesPosition: TdsdGuides;
    UpdateDate: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TTaskForm);

end.
