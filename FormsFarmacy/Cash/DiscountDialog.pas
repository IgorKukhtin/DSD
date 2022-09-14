unit DiscountDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDialog, Vcl.ActnList, dsdAction,
  cxClasses, cxPropertiesStore, dsdAddOn, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.Menus,
  Vcl.StdCtrls, cxButtons, cxTextEdit, Vcl.ExtCtrls, dsdGuides, dsdDB,
  cxMaskEdit, cxButtonEdit, AncestorBase, dxSkinsCore, dxSkinsDefaultPainters,
  System.Actions, cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage,
  cxNavigator, dxDateRanges, Data.DB, cxDBData, cxCurrencyEdit, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridCustomView,
  cxGrid, Datasnap.DBClient;

type
  TDiscountDialogForm = class(TAncestorDialogForm)
    ceDiscountExternal: TcxButtonEdit;
    DiscountExternalGuides: TdsdGuides;
    Label1: TLabel;
    edCardNumber: TcxTextEdit;
    Label2: TLabel;
    spDiscountExternal_Search: TdsdStoredProc;
    ListGoodsGrid: TcxGrid;
    ListGoodsGridDBTableView: TcxGridDBTableView;
    colGoodsCode: TcxGridDBColumn;
    colGoodsName: TcxGridDBColumn;
    colPrice: TcxGridDBColumn;
    colAmount: TcxGridDBColumn;
    ListGoodsGridLevel: TcxGridLevel;
    spLoadRemainsDiscount: TdsdStoredProc;
    RemainsDiscountDS: TDataSource;
    RemainsDiscountCDS: TClientDataSet;
    colAmountProject: TcxGridDBColumn;
    procedure bbOkClick(Sender: TObject);
    procedure DiscountExternalGuidesAfterChoice(Sender: TObject);
  private
    { Private declarations }
  public
     function DiscountDialogExecute(var ADiscountExternalId: Integer; var ADiscountExternalName, ADiscountCardNumber: String;
              ACode : Integer = 0; ADiscountCard : String = ''): boolean;
  end;


implementation
{$R *.dfm}
uses DiscountService, CommonData;

procedure TDiscountDialogForm.bbOkClick(Sender: TObject);
var Key :Integer;
    lMsg:String;
begin
  try Key:= DiscountExternalGuides.Params.ParamByName('Key').Value; except Key:= 0;end;
  //
  if Key > 0
  then
      if trim (edCardNumber.Text) <> '' then
      begin
           //обновим "нужные" параметры-Main ***20.07.16
           DiscountServiceForm.pGetDiscountExternal (Key, trim (edCardNumber.Text));
           // проверка карты + сохраним "текущие" параметры-Main
           if DiscountServiceForm.gService = 'CardService' then
           begin
             if DiscountServiceForm.fCheckCard (lMsg
                                               ,DiscountServiceForm.gURL
                                               ,DiscountServiceForm.gService
                                               ,DiscountServiceForm.gPort
                                               ,DiscountServiceForm.gUserName
                                               ,DiscountServiceForm.gPassword
                                               ,trim (edCardNumber.Text)
                                               ,DiscountServiceForm.gisOneSupplier
                                               ,DiscountServiceForm.gisTwoPackages
                                               ,Key
                                               )
             then ModalResult := mrOk;
           end
           else if DiscountServiceForm.gCode > 0 then ModalResult := mrOk;
      end
      else begin ActiveControl:=edCardNumber;ShowMessage ('Ошибка.Значение <№ дисконтной карты> не определено');end
  else begin ActiveControl:=ceDiscountExternal;
             ShowMessage ('Внимание.Значение <Проект> не установлено.');
             ModalResult:=mrOk; // ??? может не надо закрывать
       end;

end;

function TDiscountDialogForm.DiscountDialogExecute(var ADiscountExternalId: Integer; var ADiscountExternalName, ADiscountCardNumber: String;
  ACode : Integer = 0; ADiscountCard : String = ''): boolean;
Begin
      edCardNumber.Text:= ADiscountCardNumber;
      //
      DiscountExternalGuides.Params.ParamByName('Key').Value      := ADiscountExternalId;
      DiscountExternalGuides.Params.ParamByName('TextValue').Value:='';
      if ADiscountExternalId > 0 then
      begin
          ceDiscountExternal.Text:= ADiscountExternalName;
          DiscountExternalGuides.Params.ParamByName('TextValue').Value:=ADiscountExternalName;
      end;
      //
      if ACode <> 0 then
      begin
        spDiscountExternal_Search.ParamByName('inCode').Value := ACode;
        spDiscountExternal_Search.ParamByName('outDiscountExternalId').Value := 0;
        spDiscountExternal_Search.ParamByName('outDiscountExternalName').Value := '';
        spDiscountExternal_Search.Execute;
        Result := spDiscountExternal_Search.ParamByName('outDiscountExternalId').Value <> 0;
        if Result then
        begin
          ADiscountExternalId   := spDiscountExternal_Search.ParamByName('outDiscountExternalId').Value;
          ADiscountExternalName := spDiscountExternal_Search.ParamByName('outDiscountExternalName').Value;
          ADiscountCardNumber   := ADiscountCard;
          //обновим "нужные" параметры-Main ***20.07.16
          DiscountServiceForm.pGetDiscountExternal (ADiscountExternalId, trim (ADiscountCard));
          Exit;
        end else
        begin
          ShowMessage ('Ошибка. По карте № <' + ADiscountCard + '> не найден проект.');
        end;
      end else
      begin
        if gc_User.Local then
        begin
          Height := Height -ListGoodsGrid.Height;
          ListGoodsGrid.Visible := False;
        end else spLoadRemainsDiscount.Execute;
        Result := ShowModal = mrOK;
      end;

      if Result then
      begin
        try ADiscountExternalId := DiscountExternalGuides.Params.ParamByName('Key').Value;
        except
            ADiscountExternalId := 0;
            DiscountExternalGuides.Params.ParamByName('Key').Value:= 0;
        end;
        ADiscountExternalName := DiscountExternalGuides.Params.ParamByName('TextValue').Value;
        ADiscountCardNumber   := trim (edCardNumber.Text);
      end
      else begin
            ADiscountExternalId   := 0;
            ADiscountExternalName := '';
            ADiscountCardNumber   := '';
           end;
end;

procedure TDiscountDialogForm.DiscountExternalGuidesAfterChoice(Sender: TObject);
begin
  if Sender is TForm then TForm(Sender).Close;
  if RemainsDiscountCDS.Active then
  begin
    RemainsDiscountCDS.DisableControls;
    try
      RemainsDiscountCDS.Filtered := False;
      RemainsDiscountCDS.Filter := 'ObjectId = ' + IntToStr(DiscountExternalGuides.Params.ParamByName('Key').Value);
      RemainsDiscountCDS.Filtered := True;
    finally
      RemainsDiscountCDS.EnableControls
    end;
  end;
  edCardNumber.SetFocus;
end;

End.

