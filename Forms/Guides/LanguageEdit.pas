unit LanguageEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxPropertiesStore,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
  cxEdit, Vcl.Menus, Vcl.StdCtrls, cxButtons, cxLabel, cxTextEdit, Vcl.ActnList,
  Vcl.StdActns, cxCurrencyEdit, cxCheckBox,
  Data.DB, Datasnap.DBClient, cxMaskEdit, cxDropDownEdit,
  cxLookupEdit, cxDBLookupEdit, cxDBLookupComboBox, ParentForm, dsdGuides,
  dsdDB, dsdAction, cxButtonEdit, dsdAddOn, dxSkinsCore, dxSkinsDefaultPainters,
  cxGroupBox;

type
  TLanguageEditForm = class(TParentForm)
    edName: TcxTextEdit;
    cxLabel1: TcxLabel;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    ActionList: TActionList;
    spInsertUpdate: TdsdStoredProc;
    dsdFormParams: TdsdFormParams;
    spGet: TdsdStoredProc;
    dsdDataSetRefresh: TdsdDataSetRefresh;
    dsdInsertUpdateGuides: TdsdInsertUpdateGuides;
    dsdFormClose: TdsdFormClose;
    Код: TcxLabel;
    ceCode: TcxCurrencyEdit;
    cxLabel2: TcxLabel;
    edComment: TcxTextEdit;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxPropertiesStore: TcxPropertiesStore;
    cxLabel3: TcxLabel;
    edValue1: TcxTextEdit;
    cxLabel4: TcxLabel;
    edValue2: TcxTextEdit;
    cxLabel5: TcxLabel;
    edValue3: TcxTextEdit;
    cxLabel6: TcxLabel;
    edValue4: TcxTextEdit;
    cxLabel7: TcxLabel;
    edValue6: TcxTextEdit;
    cxGroupBox1: TcxGroupBox;
    cxLabel8: TcxLabel;
    edValue5: TcxTextEdit;
    cxLabel9: TcxLabel;
    edValue7: TcxTextEdit;
    cxLabel10: TcxLabel;
    edValue8: TcxTextEdit;
    cxLabel11: TcxLabel;
    edValue9: TcxTextEdit;
    cxLabel12: TcxLabel;
    edValue10: TcxTextEdit;
    cxLabel13: TcxLabel;
    edValue11: TcxTextEdit;
    cxLabel14: TcxLabel;
    edValue12: TcxTextEdit;
    edValue13: TcxTextEdit;
    cxLabel15: TcxLabel;
    cxLabel16: TcxLabel;
    edValue14: TcxTextEdit;
    cxLabel17: TcxLabel;
    edValue15: TcxTextEdit;
    cxLabel18: TcxLabel;
    edValue16: TcxTextEdit;
    cxLabel19: TcxLabel;
    edValue17: TcxTextEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

initialization
  RegisterClass(TLanguageEditForm);

end.
       