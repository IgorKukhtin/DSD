unit PromoManagerDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ParentForm, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Vcl.Menus, Vcl.StdCtrls, cxButtons, cxControls,
  cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils, ChoicePeriod,
  dsdGuides, cxDropDownEdit, cxCalendar, cxTextEdit, cxMaskEdit, cxButtonEdit,
  cxPropertiesStore, dsdAddOn, dsdDB, cxLabel, dxSkinsCore,
  dxSkinsDefaultPainters, cxCheckBox, cxCurrencyEdit, cxMemo, cxStyles,
  dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage, Data.DB,
  cxDBData, Datasnap.DBClient, cxGridLevel, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxClasses, cxGridCustomView, cxGrid,
  dsdAction, Vcl.ActnList;

type
  TPromoManagerDialogForm = class(TParentForm)
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxPropertiesStore: TcxPropertiesStore;
    FormParams: TdsdFormParams;
    cxLabel1: TcxLabel;
    cxLabel5: TcxLabel;
    edPromoStateKindName: TcxTextEdit;
    MemoComment: TcxMemo;
    cxGridPromoStateKind: TcxGrid;
    cxGridDBTableViewPromoStateKind: TcxGridDBTableView;
    psOrd: TcxGridDBColumn;
    psisQuickly: TcxGridDBColumn;
    psPromoStateKindName: TcxGridDBColumn;
    psComment: TcxGridDBColumn;
    psInsertName: TcxGridDBColumn;
    psInsertDate: TcxGridDBColumn;
    psIsErased: TcxGridDBColumn;
    cxGridLevel4: TcxGridLevel;
    PromoStateKindDS: TDataSource;
    PromoStateKindDCS: TClientDataSet;
    dsdDBViewAddOnPromoStateKind: TdsdDBViewAddOn;
    spSelectMIPromoStateKind: TdsdStoredProc;
    ActionList: TActionList;
    actRefresh: TdsdDataSetRefresh;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TPromoManagerDialogForm);

end.
