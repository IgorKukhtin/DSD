unit DiscountExternalToolsEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ParentForm, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore,
  Vcl.Menus, dsdGuides, Data.DB,
  Datasnap.DBClient, cxMaskEdit, cxDropDownEdit, cxLookupEdit, cxDBLookupEdit,
  cxDBLookupComboBox, cxPropertiesStore, dsdAddOn, dsdDB, dsdAction,
  Vcl.ActnList, cxCurrencyEdit, Vcl.StdCtrls, cxButtons, cxLabel, cxTextEdit,
  cxButtonEdit, Vcl.ComCtrls, dxCore, cxDateUtils, cxCalendar,
  dxSkinsDefaultPainters, cxCheckBox;

type
  TDiscountExternalToolsEditForm = class(TParentForm)
    cxLabel1: TcxLabel;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    ���: TcxLabel;
    ceCode: TcxCurrencyEdit;
    ActionList: TActionList;
    dsdDataSetRefresh: TdsdDataSetRefresh;
    dsdInsertUpdateGuides: TdsdInsertUpdateGuides;
    dsdFormClose: TdsdFormClose;
    spInsertUpdate: TdsdStoredProc;
    dsdFormParams: TdsdFormParams;
    spGet: TdsdStoredProc;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxPropertiesStore: TcxPropertiesStore;
    cxLabel5: TcxLabel;
    ceUserName: TcxTextEdit;
    cxLabel6: TcxLabel;
    cePassword: TcxTextEdit;
    edUnit: TcxButtonEdit;
    cxLabel7: TcxLabel;
    GuidesUnit: TdsdGuides;
    edDiscountExternal: TcxButtonEdit;
    GuidesDiscountExternal: TdsdGuides;
    cxLabel2: TcxLabel;
    ceExternalUnit: TcxTextEdit;
    ceToken: TcxTextEdit;
    cxLabel3: TcxLabel;
    cbNotUseAPI: TcxCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TDiscountExternalToolsEditForm);

end.
