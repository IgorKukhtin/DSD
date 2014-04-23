unit CRLs;

{ ------------------------------------------------------------------------------ }

interface

{ ------------------------------------------------------------------------------ }

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, Menus, ComCtrls, CommCtrl, StdCtrls, ExtCtrls, EUSignCP,
  CRL, ImageLink;

{ ------------------------------------------------------------------------------ }

type
  TCRLsForm = class(TForm)
    BottomPanel: TPanel;
    BottomUnderlineImage: TImage;
    OKButton: TButton;
    ListView: TListView;
    TopPanel: TPanel;
    UnderlineImage: TImage;
    TopImage: TImage;
    TopLabel: TLabel;
    CountLabel: TLabel;
    LVImageList: TImageList;
    ImportFullCRLLabel: TImageLinkFrame;
    CRLOpenDialog: TOpenDialog;
    ImportDeltaCRLLabel: TImageLinkFrame;
    procedure Initialize(CPInterface: PEUSignCP);
    procedure ClearSortListColumn(ListView: TListView);
    procedure SortListView(Column: TListColumn);
    procedure ListViewDblClick(Sender: TObject);
    procedure ListViewCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure ListViewColumnClick(Sender: TObject; Column: TListColumn);
    procedure ImportCRLLabelClick(Sender: TObject);

  private
    CPInterface: PEUSignCP;
    procedure UpdateCRLs();

  public
  end;

{ ------------------------------------------------------------------------------ }

implementation

{ ------------------------------------------------------------------------------ }

uses Certificate, EUSignCPOwnUI;

{ ------------------------------------------------------------------------------ }

{$R *.dfm}

{ ============================================================================== }

function CompareIntegers(Val1, Val2: Integer): Integer;
begin
  if (Val1 > Val2) then
  begin
    CompareIntegers := 1;
  end
  else if (Val1 < Val2) then
  begin
    CompareIntegers := -1;
  end
  else
  begin
    CompareIntegers := 0;
  end;
end;

{ ============================================================================== }

procedure TCRLsForm.Initialize(CPInterface: PEUSignCP);
begin
  self.CPInterface := CPInterface;
  UpdateCRLs();
end;

{ ============================================================================== }

procedure TCRLsForm.ClearSortListColumn(ListView: TListView);
var
  StartColumn, EndColumn: Integer;
  HandleHeader: HWND;
  HeaderItem: THDItem;

begin
  if (ListView.Tag = -1) then
  begin
    StartColumn := 0;
    EndColumn := ListView.Columns.Count - 1;
  end
  else
  begin
    StartColumn := ListView.Tag;
    EndColumn := ListView.Tag;
  end;

  while (StartColumn <= EndColumn) do
  begin
    HandleHeader := SendMessage(ListView.Handle, LVM_GETHEADER, 0, 0);

    ZeroMemory(@HeaderItem, sizeof(THDItem));

    HeaderItem.mask := HDI_FORMAT;
    Header_GetItem(HandleHeader, ListView.Tag, HeaderItem);
    HeaderItem.mask := HDI_FORMAT;
    HeaderItem.hbm := 0;
    HeaderItem.fmt := HeaderItem.fmt and (not HDF_BITMAP_ON_RIGHT) and
      (not HDF_IMAGE);

    Header_SetItem(HandleHeader, ListView.Tag, HeaderItem);
    StartColumn := StartColumn + 1;
  end;
end;

{ ------------------------------------------------------------------------------ }

procedure TCRLsForm.SortListView(Column: TListColumn);
var
  HandleHeader: HWND;
  HeaderItem: THDItem;

begin
  if (ListView.Tag = -1) then
    Exit;

  if (ListView.Tag = Column.Index) then
  begin
    Column.Tag := (Column.Tag + 1) mod 2;
  end
  else
  begin
    ClearSortListColumn(ListView);
    ListView.Tag := Column.Index;
    Column.Tag := 0;
  end;

  ListView.AlphaSort();

  HandleHeader := SendMessage(ListView.Handle, LVM_GETHEADER, 0, 0);
  ZeroMemory(@HeaderItem, sizeof(THDItem));

  HeaderItem.mask := HDI_FORMAT;
  Header_GetItem(HandleHeader, Column.Index, HeaderItem);
  HeaderItem.mask := HeaderItem.mask or HDI_IMAGE;

  HeaderItem.fmt := HeaderItem.fmt or HDF_BITMAP_ON_RIGHT or HDF_IMAGE;
  HeaderItem.iImage := Column.Tag + 1;

  Header_SetItem(HandleHeader, Column.Index, HeaderItem);
end;

{ ============================================================================== }

procedure TCRLsForm.ListViewDblClick(Sender: TObject);
var
  ListItem: TListItem;
  Info: TEUCRLDetailedInfo;
  Error: Cardinal;

begin
  ListItem := TListView(Sender).Selected;

  if (ListItem = nil) then
    Exit;

  Error := CPInterface.GetCRLDetailedInfo
    (PAnsiChar(AnsiString(ListItem.SubItems.Strings[3])),
    StrToInt(ListItem.SubItems.Strings[0]), @Info);

  if (Error = EU_ERROR_NONE) then
  begin
    EUShowCRL(WindowHandle, '', @Info);
    CPInterface.FreeCRLDetailedInfo(@Info);
  end
  else
    EUShowError(Handle, Error);
end;

{ ------------------------------------------------------------------------------ }

procedure TCRLsForm.ListViewCompare(Sender: TObject; Item1, Item2: TListItem;
  Data: Integer; var Compare: Integer);
var
  Column: TListColumn;
  nItem: Integer;
  Invertion: Boolean;

begin
  Invertion := False;
  Column := ListView.Column[ListView.Tag];

  if (ListView.Tag = 0) then
  begin
    Compare := AnsiCompareStr(Item1.Caption, Item2.Caption);
    if Column.Tag <> 0 then
      Invertion := True;
  end
  else if (ListView.Tag = 1) then
  begin
    nItem := ListView.Tag - 1;
    Compare := CompareIntegers(StrToInt(Item1.SubItems.Strings[nItem]),
      StrToInt(Item2.SubItems.Strings[nItem]));
    if Column.Tag <> 0 then
      Invertion := True;
  end
  else if (Item1.SubItems.Count = 2) or (ListView.Tag = 3) then
  begin
    if (Item1.SubItems.Count >= ListView.Tag) and
      (Item2.SubItems.Count >= ListView.Tag) then
    begin
      nItem := ListView.Tag - 1;
      Compare := 1;

      if (StrToDateTime(Item1.SubItems.Strings[nItem]) >=
        StrToDateTime(Item2.SubItems.Strings[nItem])) then
      begin
        if (Column.Tag = 0) then
          Invertion := True;
      end
      else
      begin
        if (Column.Tag <> 0) then
          Invertion := True;
      end;
    end;
  end
  else
  begin
    nItem := ListView.Tag - 1;
    Compare := AnsiCompareStr(Item1.SubItems.Strings[nItem],
      Item2.SubItems.Strings[nItem]);
    if (Column.Tag <> 0) then
      Invertion := True;
  end;

  if Invertion then
    Compare := -Compare;
end;

{ ------------------------------------------------------------------------------ }

procedure TCRLsForm.ListViewColumnClick(Sender: TObject; Column: TListColumn);
begin
  SortListView(Column);
end;

{ ------------------------------------------------------------------------------ }

procedure TCRLsForm.UpdateCRLs();
var
  Error: Cardinal;
  Index: Cardinal;
  Info: TEUCRLInfo;
  Item: TListItem;
  TimeZone: TTimeZoneInformation;
  SystemTime: TSystemTime;

begin
  ListView.Clear();

  Index := 0;
  Error := EU_ERROR_NONE;
  while (Error = EU_ERROR_NONE) do
  begin
    Error := CPInterface.EnumCRLs(Index, @Info);
    if ((Error = EU_ERROR_NONE) and (Info.Filled)) then
    begin
      Item := ListView.Items.Add();

      Item.ImageIndex := 0;
      Item.Caption := Info.IssuerCN;

      Item.SubItems.Add(IntToStr(Info.CRLNumber));

      GetTimeZoneInformation(TimeZone);
      SystemTimeToTzSpecificLocalTime(@TimeZone, Info.ThisUpdate, SystemTime);

      Item.SubItems.Add(AnsiString(FormatDateTime('dd.mm.yyyy hh:nn:ss',
        SystemTimeToDateTime(SystemTime))));

      SystemTimeToTzSpecificLocalTime(@TimeZone, Info.NextUpdate, SystemTime);
      Item.SubItems.Add(AnsiString(FormatDateTime('dd.mm.yyyy hh:nn:ss',
        SystemTimeToDateTime(SystemTime))));

      Item.SubItems.Add(Info.Issuer);

      CPInterface.FreeCRLInfo(@Info);
    end;

    Index := Index + 1;
  end;

  ListView.Tag := 0;
  ListView.Column[0].Tag := 1;

  SortListView(ListView.Column[0]);
  CountLabel.Caption := 'Кількість: ' + IntToStr(Index - 1);
end;

{ ============================================================================== }

procedure TCRLsForm.ImportCRLLabelClick(Sender: TObject);
var
  FileName: AnsiString;
  FileStream: TFileStream;
  Error: Cardinal;
  CRLData: PByte;
  CRLDataSize: Int64;
  FullCRL: Boolean;

begin
	if (not CRLOpenDialog.Execute()) then
	  Exit;

  FileName := CRLOpenDialog.FileName;
  if(FileName = '') then
    Exit;

  FullCRL := (Sender = ImportFullCRLLabel);
  FileStream := nil;
  CRLData := nil;

  try
    FileStream := TFileStream.Create(FileName, fmOpenRead);
    FileStream.Seek(0, soBeginning);

    CRLDataSize := FileStream.Size;
    CRLData := GetMemory(CRLDataSize);
    FileStream.Read(CRLData^, CRLDataSize);

    Error := CPInterface.SaveCRL(FullCRL, CRLData,
      Cardinal(CRLDataSize));

    if (Error <> EU_ERROR_NONE) then
    begin
       EUShowError(Handle, Error);
    end
    else
      UpdateCRLs();

  finally
    if (FileStream <> nil) then
      FileStream.Destroy;
    if (CRLData <> nil) then
      FreeMemory(CRLData);
  end;
end;

{ ============================================================================== }

end.
