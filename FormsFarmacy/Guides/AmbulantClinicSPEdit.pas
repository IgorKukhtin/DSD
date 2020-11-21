unit AmbulantClinicSPEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxPropertiesStore, dsdDB,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
  cxEdit, Vcl.Menus, Vcl.StdCtrls, cxButtons, cxLabel, cxTextEdit, Vcl.ActnList,
  Vcl.StdActns, dsdAction, ParentForm, Data.DB, Datasnap.DBClient,
  cxCurrencyEdit, cxMaskEdit, cxDropDownEdit, cxDBEdit, cxCustomData, cxStyles,
  cxTL, cxTLdxBarBuiltInMenu, cxInplaceContainer, cxTLData, cxDBTL,
  cxLookupEdit, cxDBLookupEdit, cxDBLookupComboBox, dsdGuides,
  Vcl.Grids, Vcl.DBGrids, dxSkinsCore, cxButtonEdit, dsdAddOn,
  dxSkinsDefaultPainters;

type
  TAmbulantClinicSPEditForm = class(TParentForm)
    edName: TcxTextEdit;
    cxLabel1: TcxLabel;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    ActionList: TActionList;
    spInsertUpdate: TdsdStoredProc;
    dsdFormParams: TdsdFormParams;
    spGet: TdsdStoredProc;
    dsdDataSetRefresh: TdsdDataSetRefresh;
    dsdFormClose: TdsdFormClose;
    ceCode: TcxCurrencyEdit;
    Код: TcxLabel;
    dsdInsertUpdateGuides: TdsdInsertUpdateGuides;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxPropertiesStore: TcxPropertiesStore;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TAmbulantClinicSPEditForm);

end.
