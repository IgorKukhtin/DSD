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
    dsdStoredProc: TdsdStoredProc;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    procedure N3Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure actSaveExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses MeasureUnit, MeasureEditUnit, FormUnit, Xml.XMLDoc, UtilConvert;

procedure TMainForm.actSaveExecute(Sender: TObject);
var
  Stream: TStringStream;
  MemoryStream: TMemoryStream;
  i: integer;
  XMLDocument: TXMLDocument;
  XML: String;
begin
  for I := 0 to Application.ComponentCount - 1 do
    if (Application.Components[i] is TParentForm) and TParentForm(Application.Components[i]).Visible then begin
      Stream := TStringStream.Create;
      MemoryStream := TMemoryStream.Create;
      XMLDocument:= TXMLDocument.Create(nil);
      try
        MemoryStream.WriteComponent(Application.Components[i]);
        MemoryStream.Position := 0;
        ObjectBinaryToText(MemoryStream, Stream);
        dsdStoredProc.ParamByName('FormName').Value := copy(Application.Components[i].ClassName, 2, MaxInt);
        // Оборачиваем символы #13 и #10
        XMLDocument.LoadFromXML('<xml Data="' + gfStrToXmlStr(Stream.DataString) + '"/>');
        XMLDocument.SaveToXML(XML);

        dsdStoredProc.ParamByName('FormData').Value := gfStrToXmlStr(copy(XML, 12, length(XML) - 15));
        dsdStoredProc.Execute;
      finally
        Stream.Free;
        MemoryStream.Free;
      end;
      ShowMessage('Форма ' + dsdStoredProc.ParamByName('FormName').Value + ' сохранена в базе')
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

end.
