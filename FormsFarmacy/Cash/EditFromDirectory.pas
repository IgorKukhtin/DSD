unit EditFromDirectory;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDialog, Vcl.ActnList, dsdAction, System.DateUtils,
  cxClasses, cxPropertiesStore, dsdAddOn, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.Menus,
  Vcl.StdCtrls, cxButtons, cxTextEdit, Vcl.ExtCtrls, dsdGuides, dsdDB,
  cxMaskEdit, cxButtonEdit, AncestorBase, dxSkinsCore, dxSkinsDefaultPainters, Data.DB,
  cxStyles, dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage,
  cxDBData, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  Datasnap.DBClient, cxGridLevel, cxGridCustomView, cxGrid, cxCurrencyEdit,
  Vcl.ComCtrls, cxCheckBox, cxBlobEdit, dxSkinsdxBarPainter, dxBarExtItems,
  dxBar, cxNavigator, cxDataControllerConditionalFormattingRulesManagerDialog,
  DataModul, System.Actions;

type
  TSecondEdit = (seText, sePhone);

  TEditFromDirectoryForm = class(TForm)
    pnl1: TPanel;
    Panel1: TPanel;
    Label1: TLabel;
    edMaskName: TcxMaskEdit;
    edMaskSecond: TcxMaskEdit;
    Label2: TLabel;
    bbCancel: TcxButton;
    bbOk: TcxButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure bbOkClick(Sender: TObject);
    procedure bbCancelClick(Sender: TObject);
  private
    { Private declarations }
    FSecondEdit : TSecondEdit;
  public
  end;

function ShowEditFromDirectory(ACaption, AFieldCaption, AFieldSecondCaption : String;
         var AName, ASecond : String) : boolean;

implementation

{$R *.dfm}

uses LocalWorkUnit, CommonData;

procedure TEditFromDirectoryForm.bbCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TEditFromDirectoryForm.bbOkClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TEditFromDirectoryForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if ModalResult = mrOk then
  begin
    if Trim(edMaskName.Text) = '' then
    begin
      ShowMessage('Не введено значение <' + Label1.Caption + '>');
      Action := caNone;
    end else if (FSecondEdit = seText) and (Trim(edMaskSecond.Text) = '') then
    begin
      ShowMessage('Не введено значение <' + Label1.Caption + '>');
      Action := caNone;
    end else if (FSecondEdit = sePhone) and
                (Length(Trim(StringReplace(StringReplace(StringReplace(edMaskSecond.Text,
                                           '(', '', [rfReplaceAll, rfIgnoreCase]),
                                           ')', '', [rfReplaceAll, rfIgnoreCase]),
                                           '-', '', [rfReplaceAll, rfIgnoreCase]))) <> 10) then
    begin
      ShowMessage('Не введено значение <' + Label2.Caption + '>');
      Action := caNone;
    end;
  end;


end;

function ShowEditFromDirectory(ACaption, AFieldCaption, AFieldSecondCaption : String;
         var AName, ASecond : String) : boolean;
begin

  with TEditFromDirectoryForm.Create(nil) do
  try
    FSecondEdit := seText;
    if ACaption <> '' then Caption := 'Ввод ' + ACaption;
    if AFieldCaption <> '' then Label1.Caption := AFieldCaption + ':';
    if AFieldSecondCaption <> '' then Label2.Caption := AFieldSecondCaption + ':';
    if Pos('елефон', AFieldSecondCaption) > 0 then
    begin
      edMaskSecond.Properties.EditMask := '!\(999\)000-00-00;1;_';
      FSecondEdit := sePhone;
    end;
    edMaskName.Text := AName;

    Result := ShowModal = mrOk;
    if True then
    begin
      AName := edMaskName.Text;
      ASecond := edMaskSecond.Text;
    end;
  finally
    Free;
  end;

end;

End.
