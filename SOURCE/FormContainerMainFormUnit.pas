unit FormContainerMainFormUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ToolWin, Vcl.ActnMan, Vcl.ActnCtrls,
  Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnList, Vcl.Menus,
  dsdDataSetWrapperUnit;

type
  TMainForm = class(TForm)
    MainMenu: TMainMenu;
    ActionManager: TActionManager;
    ActionToolBar1: TActionToolBar;
    actSave: TAction;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    N15: TMenuItem;
    N16: TMenuItem;
    procedure N3Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure actSaveExecute(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure N13Click(Sender: TObject);
    procedure N15Click(Sender: TObject);
    procedure N16Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses MeasureUnit, MeasureEditUnit,
     JuridicalGroupUnit, JuridicalGroupEditUnit,
     JuridicalUnit, JuridicalEditUnit,
     GoodsPropertyUnit, GoodsPropertyEditUnit,
     BusinessUnit, BusinessEditUnit,
     FormUnit, UtilConvert, FormStorageUnit;

procedure TMainForm.actSaveExecute(Sender: TObject);
var
  i: integer;
begin
  for I := 0 to Application.ComponentCount - 1 do
    if (Application.Components[i] is TParentForm) and TParentForm(Application.Components[i]).Visible then begin
      // Что бы форма не выскакивала после загрузки
      TParentForm(Application.Components[i]).Visible := false;
      TdsdFormStorageFactory.GetStorage.Save(Application.Components[i]);
      ShowMessage('Форма ' + Application.Components[i].Name + ' сохранена в базе')
    end;
end;

procedure TMainForm.N3Click(Sender: TObject);
begin
  MeasureForm.Show;
end;

procedure TMainForm.N4Click(Sender: TObject);
begin
  MeasureEditForm.Show;
end;

procedure TMainForm.N6Click(Sender: TObject);
begin
  JuridicalGroupForm.Show;
end;

procedure TMainForm.N7Click(Sender: TObject);
begin
  JuridicalGroupEditForm.Show;
end;

procedure TMainForm.N9Click(Sender: TObject);
begin
  GoodsPropertyForm.Show;
end;

procedure TMainForm.N10Click(Sender: TObject);
begin
  GoodsPropertyEditForm.Show
end;


procedure TMainForm.N12Click(Sender: TObject);
begin
  JuridicalForm.Show
end;

procedure TMainForm.N13Click(Sender: TObject);
begin
  JuridicalEditForm.Show
end;

procedure TMainForm.N15Click(Sender: TObject);
begin
  BusinessForm.Show
end;

procedure TMainForm.N16Click(Sender: TObject);
begin
  BusinessEditForm.Show
end;

end.
