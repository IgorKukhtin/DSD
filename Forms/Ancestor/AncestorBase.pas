unit AncestorBase;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ParentForm, dsdAddOn, Vcl.ActnList,
  dsdAction, cxPropertiesStore, DataModul, Vcl.Menus,
  {$IFDEF VER330} Actions, {$ENDIF} cxClasses, dsdCommon;

type
  TAncestorBaseForm = class(TParentForm)
    UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxPropertiesStore: TcxPropertiesStore;
    ActionList: TActionList;
    actRefresh: TdsdDataSetRefresh;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
