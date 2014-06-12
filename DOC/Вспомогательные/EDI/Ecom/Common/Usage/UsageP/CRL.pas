unit CRL;

{ ------------------------------------------------------------------------------ }

interface

{ ------------------------------------------------------------------------------ }

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ImgList, StdCtrls, ExtCtrls, ComCtrls, EUSignCP,
  ImageLink;

{ ------------------------------------------------------------------------------ }

type
  TCRLForm = class(TForm)
    BasePanel: TPanel;
    DetailedContentPanel: TPanel;
    FieldsLabel: TLabel;
    DetailedPanel: TPanel;
    ContentPanel: TPanel;
    DataListView: TListView;
    DetailedBottomPanel: TPanel;
    SplitPanel: TPanel;
    DataLabel: TLabel;
    DataMemo: TMemo;
    CommonPanel: TPanel;
    IssuerTitleLabel: TLabel;
    IssuerLabel: TLabel;
    NumberTitleLabel: TLabel;
    NumberLabel: TLabel;
    UpdatesTitleLabel: TLabel;
    UpdatesLabel: TLabel;
    TopPanel: TPanel;
    UnderlineImage: TImage;
    TopImage: TImage;
    TopLabel: TLabel;
    BottomPanel: TPanel;
    BottomUnderlineImage: TImage;
    OKButton: TButton;
    DataImageList: TImageList;
    DetailLabel: TImageLinkFrame;
    ShortInfoLabel: TImageLinkFrame;
    procedure DataListViewSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure ShortInfoLabelClick(Sender: TObject);
    procedure DetailLabelClick(Sender: TObject);

  private
    procedure AddDataListViewItem(Caption, Text: AnsiString; IsHeader: Boolean);

  public
    function SetData(Info: PEUCRLDetailedInfo): Cardinal;

  end;

{ ------------------------------------------------------------------------------ }

implementation

{ ------------------------------------------------------------------------------ }

{$R *.dfm}

{ ============================================================================== }

procedure TCRLForm.AddDataListViewItem(Caption, Text: AnsiString;
  IsHeader: Boolean);
var
  Item: TListItem;

begin
  if ((AnsiString(Text) = '') and (not IsHeader)) then
    Exit;

  Item := DataListView.Items.Add();
  Item.Caption := Caption;
  Item.SubItems.Add(Text);

  if IsHeader then
  begin
    Item.ImageIndex := 0;
  end
  else
  begin
    Item.ImageIndex := -1;
  end;
end;

{ ------------------------------------------------------------------------------ }

function TCRLForm.SetData(Info: PEUCRLDetailedInfo): Cardinal;
var
  TimeZone: TTimeZoneInformation;
  ThisUpdate, NextUpdate: TSystemTime;

begin
  if (Info.Filled <> True) then
  begin
    SetData := EU_ERROR_BAD_PARAMETER;
    Exit;
  end;

  CommonPanel.Visible := True;
  CommonPanel.BringToFront();

  DataListView.Items.Clear();
  DataMemo.Lines.Clear();

  IssuerLabel.Caption := Info.IssuerCN;
  NumberLabel.Caption := IntToStr(Info.CRLNumber);

  GetTimeZoneInformation(TimeZone);
  SystemTimeToTzSpecificLocalTime(@TimeZone, Info.ThisUpdate, ThisUpdate);
  SystemTimeToTzSpecificLocalTime(@TimeZone, Info.NextUpdate, NextUpdate);

  UpdatesLabel.Caption := AnsiString(FormatDateTime('dd.mm.yyyy hh:nn:ss',
    SystemTimeToDateTime(ThisUpdate)));
  UpdatesLabel.Caption := UpdatesLabel.Caption + '.' + #13#10 + 'Наступний - ' +
    FormatDateTime('dd.mm.yyyy hh:nn:ss', SystemTimeToDateTime(NextUpdate));

  AddDataListViewItem('Реквізити ЦСК', Info.Issuer, True);
  AddDataListViewItem('Час формування',
    AnsiString(FormatDateTime('dd.mm.yyyy hh:nn:ss',
    SystemTimeToDateTime(ThisUpdate))), False);
  AddDataListViewItem('Час наступного формування',
    AnsiString(FormatDateTime('dd.mm.yyyy hh:nn:ss',
    SystemTimeToDateTime(NextUpdate))), False);
  AddDataListViewItem('РН', IntToStr(Info.CRLNumber), True);
  AddDataListViewItem('Ідентифікатор відкритого ключа ЕЦП ЦСК',
    Info.IssuerPublicKeyID, True);

  ShortInfoLabelClick(nil);
  SetData := EU_ERROR_NONE;
end;

{ ============================================================================== }

procedure TCRLForm.DataListViewSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  if Selected then
  begin
    DataMemo.Lines.Clear;
    DataMemo.Lines.Add(Item.SubItems.Strings[0]);
  end;

  if (Selected and (AnsiString(Item.SubItems.Strings[0]) <> '')) then
  begin
    DataMemo.Height := ((abs(DataMemo.Font.Height) + 2) *
      DataMemo.Lines.Count) + 10;
    DataMemo.SelStart := 0;
    DataMemo.SelLength := 0;
    DataLabel.Caption := Item.Caption + ':';

    DetailedBottomPanel.Height := SplitPanel.Height + DataMemo.Height;
    DetailedBottomPanel.Visible := True;
  end
  else
  begin
    DetailedBottomPanel.Visible := False;
  end;
end;

{ ------------------------------------------------------------------------------ }

procedure TCRLForm.DetailLabelClick(Sender: TObject);
begin
  CommonPanel.Visible := False;
  ShortInfoLabel.Visible := True;
  DetailedContentPanel.Visible := True;
end;

{ ------------------------------------------------------------------------------ }

procedure TCRLForm.ShortInfoLabelClick(Sender: TObject);
begin
  CommonPanel.Visible := True;
  ShortInfoLabel.Visible := False;
  DetailedContentPanel.Visible := False;
end;

{ ============================================================================== }

end.
