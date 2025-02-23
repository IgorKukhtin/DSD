unit PUSHMessageFarmacy;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxLookAndFeels, DataModul,
  cxLookAndFeelPainters, Vcl.Menus, dxSkinsCore, dxSkinsDefaultPainters,
  Vcl.StdCtrls, cxButtons, Vcl.ExtCtrls, cxControls, cxContainer, cxEdit,
  cxTextEdit, cxMemo, dsdAddOn, cxPropertiesStore, cxStyles, dxSkinscxPCPainter,
  cxCustomData, cxFilter, cxData, cxDataStorage, Data.DB, cxDBData, cxGridLevel,
  cxClasses, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, Datasnap.DBClient, Math, cxCurrencyEdit,
  dxSkinsdxBarPainter, Vcl.ActnList, dsdAction, dxBarExtItems, dxBar, cxSplitter;

type
  TPUSHMessageFarmacyForm = class(TForm)
    bbCancel: TcxButton;
    bbOk: TcxButton;
    Memo: TcxMemo;
    pn2: TPanel;
    pn1: TPanel;
    btOpenForm: TcxButton;
    PopupMenu: TPopupMenu;
    pmSelectAll: TMenuItem;
    N1: TMenuItem;
    pmColorDialog: TMenuItem;
    ColorDialog: TColorDialog;
    FontDialog: TFontDialog;
    cxPropertiesStore: TcxPropertiesStore;
    UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    pmFontDialog: TMenuItem;
    cxGridDBTableView1: TcxGridDBTableView;
    cxGridLevel1: TcxGridLevel;
    cxGrid: TcxGrid;
    PUSHCDS: TClientDataSet;
    PUSHDS: TDataSource;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    bbRefresh: TdxBarButton;
    bbStaticText: TdxBarButton;
    bbExecuteDialog: TdxBarButton;
    bb: TdxBarControlContainerItem;
    dxBarButton3: TdxBarButton;
    dxBarButton4: TdxBarButton;
    dxBarButton1: TdxBarButton;
    ActionList: TActionList;
    actExportExel: TdsdGridToExcel;
    dxBarButton2: TdxBarButton;
    Splitter: TcxSplitter;
    procedure FormCreate(Sender: TObject);
    procedure MemoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btOpenFormClick(Sender: TObject);
    procedure pmSelectAllClick(Sender: TObject);
    procedure pmColorDialogClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure pmFontDialogClick(Sender: TObject);
  private
    { Private declarations }
    FFormName : string;
    FParams : string;
    FTypeParams : string;
    FValueParams : string;

    FSpecialLighting : Boolean;
  public
    { Public declarations }
  end;

  function ShowPUSHMessageFarmacy(AMessage : string;
                                  AFormName : string = '';
                                  AButton : string = '';
                                  AParams : string = '';
                                  ATypeParams : string = '';
                                  AValueParams : string = '';
                                  ABeep : Integer = 0;
                                  ASpecialLighting : Boolean = False;
                                  ATextColor : Integer = clWindowText;
                                  AColor : Integer = clCream;
                                  ABold : Boolean = False;
                                  AGridData : string = '') : boolean;

implementation

{$R *.dfm}

uses RegularExpressions, TypInfo, dsdPlaySound;

procedure OpenForm(AFormName, AParams, ATypeParams, AValueParams : string);
  var actOF: TdsdOpenForm; I : Integer; Value : Variant;
      arValue, arParams, arTypeParams, arValueParams: TArray<string>;
begin
  actOF := TdsdOpenForm.Create(Nil);
  try
    actOF.FormNameParam.Value := AFormName;
    actOF.isShowModal := True;
    if Trim(AParams) <> '' then
    begin
      arParams := TRegEx.Split(AParams, ',');
      arTypeParams := TRegEx.Split(ATypeParams, ',');
      arValueParams := TRegEx.Split(AValueParams, ',');
      for I := 0 to High(arParams) do
      begin
        if (High(arTypeParams) < I) or (High(arValueParams) < I) then Break;
        Value := arValueParams[I];
        case TFieldType(GetEnumValue(TypeInfo(TFieldType), arTypeParams[I])) of
          ftDateTime : begin
                         arValue := TRegEx.Split(Value, '-');
                         if High(arValue) = 2 then
                           Value := EncodeDate(StrToInt(arValue[0]), StrToInt(arValue[1]), StrToInt(arValue[2]))
                         else Value := Date;
                       end;
          ftFloat : Value := StringReplace(Value, '.', FormatSettings.DecimalSeparator, [rfReplaceAll]);
        end;
        actOF.GuiParams.AddParam(arParams[I], TFieldType(GetEnumValue(TypeInfo(TFieldType), arTypeParams[I])), ptInput, Value);
      end;
    end;
    actOF.Execute;
  finally
    actOF.Free;
  end;
end;


procedure TPUSHMessageFarmacyForm.btOpenFormClick(Sender: TObject);
begin
  OpenForm(FFormName, FParams, FTypeParams, FValueParams);
  ModalResult := mrOk;
end;

procedure TPUSHMessageFarmacyForm.FormCreate(Sender: TObject);
begin
  UserSettingsStorageAddOn.LoadUserSettings;
  Memo.Style.Font.Size := Memo.Style.Font.Size + 4;
end;

procedure TPUSHMessageFarmacyForm.FormDestroy(Sender: TObject);
begin
  if not FSpecialLighting then
  begin
    Memo.Style.Font.Size := Memo.Style.Font.Size - 4;
    UserSettingsStorageAddOn.SaveUserSettings;
  end;
end;

procedure TPUSHMessageFarmacyForm.MemoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_Return then ModalResult := mrOk;
end;

procedure TPUSHMessageFarmacyForm.pmColorDialogClick(Sender: TObject);
begin
  ColorDialog.Color := Memo.Style.Color;
  if ColorDialog.Execute then Memo.Style.Color := ColorDialog.Color;
end;

procedure TPUSHMessageFarmacyForm.pmFontDialogClick(Sender: TObject);
begin
  FontDialog.Font := Memo.Style.Font;
  FontDialog.Font.Color := Memo.Style.TextColor;
  if FontDialog.Execute then
  begin
    Memo.Style.Font := FontDialog.Font;
    Memo.Style.TextColor := FontDialog.Font.Color;
  end;
end;

procedure TPUSHMessageFarmacyForm.pmSelectAllClick(Sender: TObject);
begin
  Memo.SelectAll;
end;

function ShowPUSHMessageFarmacy(AMessage : string;
                             AFormName : string = '';
                             AButton : string = '';
                             AParams : string = '';
                             ATypeParams : string = '';
                             AValueParams : string = '';
                             ABeep : Integer = 0;
                             ASpecialLighting : Boolean = False;
                             ATextColor : Integer = clWindowText;
                             AColor : Integer = clCream;
                             ABold : Boolean = False;
                             AGridData : string = '') : boolean;
  var PUSHMessageFarmacyForm : TPUSHMessageFarmacyForm;
      Res, Types : TArray<string>;
      I, W, J, FieldsCount : Integer;
begin

  if ABeep = 1 then PlaySoundFile('Bell0001.wav');

  if AMessage = '' then
  begin
    OpenForm(AFormName, AParams, ATypeParams, AValueParams);
    Result := True;
    Exit
  end;

  PUSHMessageFarmacyForm := TPUSHMessageFarmacyForm.Create(Screen.ActiveControl);
  try
    PUSHMessageFarmacyForm.Memo.Lines.Text := AMessage;
    PUSHMessageFarmacyForm.FFormName := AFormName;
    PUSHMessageFarmacyForm.FParams := AParams;
    PUSHMessageFarmacyForm.FTypeParams := ATypeParams;
    PUSHMessageFarmacyForm.FValueParams := AValueParams;
    PUSHMessageFarmacyForm.FSpecialLighting := ASpecialLighting;

    if AGridData <> '' then
    begin
      Res := TRegEx.Split(AGridData, #13);
      if High(Res) > 3 then
      begin
        Types := TRegEx.Split(Res[0], ',');
        FieldsCount := High(Types) + 1;

        for I := 0 to High(Types) do
        begin
          if Types[I] = 'ftFloat' then
            PUSHMessageFarmacyForm.PUSHCDS.FieldDefs.Add('Field' + IntToStr(I + 1), ftCurrency)
          else if Types[I] = 'ftInteger' then
            PUSHMessageFarmacyForm.PUSHCDS.FieldDefs.Add('Field' + IntToStr(I + 1), ftInteger)
          else if Types[I] = 'ftBoolean' then
            PUSHMessageFarmacyForm.PUSHCDS.FieldDefs.Add('Field' + IntToStr(I + 1), ftBoolean)
          else PUSHMessageFarmacyForm.PUSHCDS.FieldDefs.Add('Field' + IntToStr(I + 1), ftString, 255);
        end;

        PUSHMessageFarmacyForm.PUSHCDS.CreateDataSet;

        J := 0;
        for I := 1 + FieldsCount to High(Res) do
        begin
          if J = 0 then
          begin
            PUSHMessageFarmacyForm.PUSHCDS.Append;
          end;
          try
            if PUSHMessageFarmacyForm.PUSHCDS.Fields.Fields[J].DataType = ftCurrency then
              PUSHMessageFarmacyForm.PUSHCDS.Fields.Fields[J].Value := StringReplace(Res[I], '.', FormatSettings.DecimalSeparator, [rfReplaceAll])
            else PUSHMessageFarmacyForm.PUSHCDS.Fields.Fields[J].Value := Res[I];
          except
          end;
          inc(J);
          if J = FieldsCount then
          begin
            PUSHMessageFarmacyForm.PUSHCDS.Post;
            J := 0;
          end;
        end;

        if PUSHMessageFarmacyForm.PUSHCDS.State in dsEditModes then
           PUSHMessageFarmacyForm.PUSHCDS.Post;

        for I := 0 to FieldsCount - 1 do
        begin
          with PUSHMessageFarmacyForm.cxGridDBTableView1.CreateColumn do
          begin
            HeaderAlignmentHorz := TAlignment.taCenter;
            Options.Editing := False;
            DataBinding.FieldName := 'Field' + IntToStr(I + 1);
            if High(Res) >= (I + 1) then Caption := Res[I + 1];
            if PUSHMessageFarmacyForm.PUSHCDS.Fields.Fields[I].DataType in [ftCurrency] then
            begin
              PropertiesClass := TcxCurrencyEditProperties;
              TcxCurrencyEditProperties(Properties).DisplayFormat := ',0.####;-,0.####; ;';
            end;
            W := 10;
            for J := 0 to PUSHMessageFarmacyForm.cxGridDBTableView1.DataController.RecordCount - 1 do
            begin
              W := Max(W, LengTh(PUSHMessageFarmacyForm.cxGridDBTableView1.DataController.Values[J, Index]));
              if W > 100 then Break;
            end;
            Width := PUSHMessageFarmacyForm.cxGrid.Canvas.TextWidth('�') * Min(W, 100) + 2;
          end;
        end;

      end else PUSHMessageFarmacyForm.cxGrid.Visible := False;
    end else PUSHMessageFarmacyForm.cxGrid.Visible := False;
    PUSHMessageFarmacyForm.dxBarManagerBar1.Visible := PUSHMessageFarmacyForm.cxGrid.Visible;
    PUSHMessageFarmacyForm.actExportExel.Enabled := PUSHMessageFarmacyForm.cxGrid.Visible;
    PUSHMessageFarmacyForm.Splitter.Visible := PUSHMessageFarmacyForm.cxGrid.Visible;
    if not PUSHMessageFarmacyForm.cxGrid.Visible then PUSHMessageFarmacyForm.Memo.Align := alClient;


    if AButton <> '' then
    begin
      PUSHMessageFarmacyForm.btOpenForm.Width := PUSHMessageFarmacyForm.btOpenForm.Width -
        PUSHMessageFarmacyForm.Canvas.TextWidth(PUSHMessageFarmacyForm.btOpenForm.Caption) +
        PUSHMessageFarmacyForm.Canvas.TextWidth(AButton);
      PUSHMessageFarmacyForm.btOpenForm.Caption := AButton;
      PUSHMessageFarmacyForm.btOpenForm.Visible := True;
    end else PUSHMessageFarmacyForm.btOpenForm.Visible := False;

    if ASpecialLighting then
    begin
      PUSHMessageFarmacyForm.Memo.Style.Color := AColor;
      PUSHMessageFarmacyForm.Memo.Style.TextColor := ATextColor;
      if ABold then PUSHMessageFarmacyForm.Memo.Style.TextStyle := PUSHMessageFarmacyForm.Memo.Style.TextStyle + [fsBold];
    end;

    Result := PUSHMessageFarmacyForm.ShowModal = mrOk;
    PUSHMessageFarmacyForm.cxGridDBTableView1.ClearItems;
  finally
    PUSHMessageFarmacyForm.Free;
  end;
end;

end.
