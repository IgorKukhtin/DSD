unit MovementProtocol;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorReport, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, cxContainer, Vcl.ComCtrls,
  dxCore, cxDateUtils, dsdAddOn, ChoicePeriod, dxBarExtItems, dxBar, cxClasses,
  dsdDB, Datasnap.DBClient, Vcl.ActnList, dsdAction, cxPropertiesStore, cxLabel,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxButtonEdit, dsdGuides, cxMemo, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, cxPCdxBarPopupMenu, dxSkinsdxBarPainter, cxPC, Vcl.Menus,
  cxSplitter, dsdXMLTransform;

type
  TMovementProtocolForm = class(TAncestorReportForm)
    colDate: TcxGridDBColumn;
    colUserName: TcxGridDBColumn;
    colObjectName: TcxGridDBColumn;
    edUser: TcxButtonEdit;
    edMovementDesc: TcxButtonEdit;
    edObject: TcxButtonEdit;
    cxLabel3: TcxLabel;
    UserGuides: TdsdGuides;
    cxLabel4: TcxLabel;
    MovementDescGuides: TdsdGuides;
    cxLabel5: TcxLabel;
    colObjectTypeName: TcxGridDBColumn;
    FormParams: TdsdFormParams;
    dsdXMLTransform: TdsdXMLTransform;
    cxGridProtocolData: TcxGrid;
    cxGridViewProtocolData: TcxGridDBTableView;
    cxGridDBColumn1: TcxGridDBColumn;
    cxGridDBColumn2: TcxGridDBColumn;
    cxGridLevelProtocolData: TcxGridLevel;
    cxSplitter: TcxSplitter;
    ProtocolDataCDS: TClientDataSet;
    ProtocolDataCDSFieldName: TStringField;
    ProtocolDataCDSFieldValue: TStringField;
    ProtocolDataDS: TDataSource;
    colisInsert: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TMovementProtocolForm);


end.
