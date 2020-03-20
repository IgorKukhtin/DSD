unit LookAndFillSettings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, Data.DB, cxDBData, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, dxmdaset, cxCheckBox, cxContainer, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxCheckComboBox, cxLabel, cxSpinEdit, cxVGrid,
  cxInplaceContainer, DataModul, dxSkinsCore;

type
  TLookAndFillSettingsForm = class(TForm)
    dxMemData: TdxMemData;
    cxGridDBTableView: TcxGridDBTableView;
    cxGridLevel: TcxGridLevel;
    cxGrid: TcxGrid;
    dxMemDatacolOne: TStringField;
    DataSource: TDataSource;
    cxGridDBTableViewRecId: TcxGridDBColumn;
    cxGridDBTableViewcolOne: TcxGridDBColumn;
    cxLabel1: TcxLabel;
    cxVerticalGrid1: TcxVerticalGrid;
    crContentStyle: TcxCategoryRow;
    erContentFontSize: TcxEditorRow;
    cxSkinComboBox: TcxComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure erContentFontSizeEditPropertiesChange(Sender: TObject);
    procedure cxSkinComboBoxPropertiesChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses {$I dxSkins.inc} dxSkinsStrs, dxSkinsForm, dxSkinInfo;



{$R *.dfm}

procedure TLookAndFillSettingsForm.cxSkinComboBoxPropertiesChange(
  Sender: TObject);
var ItemNumber: Integer;
begin
  dmMain.cxLookAndFeelController.SkinName := cxSkinComboBox.Text;
  ItemNumber := cxSkinComboBox.Properties.Items.IndexOf(cxSkinComboBox.Text);
  case ItemNumber of
    0..3:
      begin
        dmMain.cxLookAndFeelController.SkinName := '';
        dmMain.cxLookAndFeelController.Kind := TcxLookAndFeelKind(ItemNumber);
        dmMain.cxLookAndFeelController.NativeStyle := False;
      end;
    4:
      begin
        dmMain.cxLookAndFeelController.SkinName := '';
        dmMain.cxLookAndFeelController.NativeStyle := True;
      end;
  else
    dmMain.cxLookAndFeelController.NativeStyle := False;
    dmMain.cxLookAndFeelController.SkinName := cxSkinComboBox.Text;
  end;

end;

procedure TLookAndFillSettingsForm.erContentFontSizeEditPropertiesChange(
  Sender: TObject);
begin
  dmMain.cxContentStyle.Font.Size := erContentFontSize.Properties.Value;
end;

procedure TLookAndFillSettingsForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TLookAndFillSettingsForm.FormCreate(Sender: TObject);
var
  ADefaultSkinIndex, I: Integer;
  FSkinResources: TStringList;
  FSkinNames: TStringList;
begin
  erContentFontSize.Properties.Value := dmMain.cxContentStyle.Font.Size;
  FSkinResources := TStringList.Create;
  FSkinNames := TStringList.Create;
  try
    dxSkinsPopulateSkinResources(HInstance, FSkinResources, FSkinNames);
    cxSkinComboBox.Properties.Items.Add('Flat');
    cxSkinComboBox.Properties.Items.Add('Standard');
    cxSkinComboBox.Properties.Items.Add('UltraFlat');
    cxSkinComboBox.Properties.Items.Add('Office11');
    cxSkinComboBox.Properties.Items.Add('Native');
    for I := 0 to FSkinNames.Count - 1 do
        cxSkinComboBox.Properties.Items.Add(FSkinNames[i]);
    cxSkinComboBox.Text := dmMain.cxLookAndFeelController.SkinName;
  finally
    FSkinResources.Free;
    FSkinNames.Free;
  end;
end;

end.
