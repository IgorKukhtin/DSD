unit DialogReestrInsert;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  AncestorDialogScale, dsdDB, Data.DB, Datasnap.DBClient, Vcl.Grids, Vcl.DBGrids,
  Data.Bind.EngExt, Vcl.Bind.DBEngExt, System.Rtti, System.Bindings.Outputs,
  Vcl.Bind.Editors, Data.Bind.Components, dsdAddOn, Data.FMTBcd,
  Data.SqlExpr, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxContainer, cxEdit, dxSkinsCore, dxSkinsDefaultPainters, cxTextEdit,
  cxMaskEdit, cxButtonEdit
, UtilScale, Vcl.Buttons, cxStyles, dxSkinscxPCPainter, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxDBData, cxImageComboBox, cxCurrencyEdit, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxClasses,
  cxGridCustomView, cxGrid;

type
  TDialogReestrInsertForm = class(TAncestorDialogScaleForm)
    CDS: TClientDataSet;
    DataSource: TDataSource;
    spSelect: TdsdStoredProc;
    InfoPanel: TPanel;
    infoPanelPartner: TPanel;
    Panel3: TPanel;
    Label2: TLabel;
    Panel4: TPanel;
    Label3: TLabel;
    PanelPartnerName: TPanel;
    GridPanel: TPanel;
    EditPartnerCode: TcxButtonEdit;
    MessagePanel: TPanel;
    cxDBGrid: TcxGrid;
    cxDBGridDBTableView: TcxGridDBTableView;
    cxDBGridLevel: TcxGridLevel;
    DBViewAddOn: TdsdDBViewAddOn;
    infoPanelContract: TPanel;
    LabelContract: TLabel;
    PanelContract: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    Panel6: TPanel;
    Panel7: TPanel;
    Label4: TLabel;
    Edit1: TEdit;
    Panel5: TPanel;
    ScaleLabel: TLabel;
    EditBarCode: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure EditPartnerCodeExit(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DBGrid111DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid111CellClick(Column: TColumn);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditBarCodeExit(Sender: TObject);
    procedure EditBarCodeChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure EditPartnerCodeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditBarCodeEnter(Sender: TObject);
    procedure EditPartnerCodeEnter(Sender: TObject);
    procedure EditPartnerCodePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure FormShow(Sender: TObject);
    procedure DBGrid111DblClick(Sender: TObject);

  private
    ChoiceNumber:Integer;

    isEditPartnerCodeExit: Boolean;
    isEditBarCode: Boolean;
    isOrderExternal: Boolean;
    isBarCodeMaster: Boolean;
    isUpdateUnit: Boolean;
    ParamsMovement_local: TParams;

    function Checked: boolean; override;//Проверка корректного ввода в Edit
  public
    function Execute(BarCode: String): boolean; virtual;
    function Get_isSendOnPriceIn(MovementDescNumber:Integer): boolean;
  end;

var
  DialogReestrInsertForm: TDialogReestrInsertForm;

implementation
{$R *.dfm}
uses dmMainScale,GuidePartner;
{------------------------------------------------------------------------}
function TDialogReestrInsertForm.Execute(BarCode: String): Boolean; //Проверка корректного ввода в Edit
begin
     isUpdateUnit:= BarCode = 'isUpdateUnit';
     //
     CopyValuesParamsFrom(ParamsMovement,ParamsMovement_local);
     // !!!обязательно обнулили!!!
     ParamsMovement_local.ParamByName('MovementId_get').AsInteger:= 0;
     //
     if isUpdateUnit = True then
     begin BarCode:='';
           // если это изменение
           ParamsMovement_local.ParamByName('isMovementId_check').asBoolean:= TRUE;
     end;

     isEditPartnerCodeExit:= FALSE;
     ParamsMovement_local.ParamByName('isGetPartner').AsBoolean:= false;

     if  isUpdateUnit = TRUE
     then begin
               MessagePanel.Font.Style:=[fsBold];
               MessagePanel.Caption:='Изменение текущего взвешивания.';
     end
     else
     if   (ParamsMovement_local.ParamByName('MovementId').AsInteger <> 0)
       and(ParamsMovement_local.ParamByName('isMovementId_check').asBoolean = FALSE)
     then begin
               MessagePanel.Font.Style:=[fsBold];
               MessagePanel.Caption:='Текущее взвешивание не закрыто.Будет создано <Новое> взвешивание.';
               //
               ParamsMovement_local.ParamByName('MovementDescId').AsInteger:=0;
               ParamsMovement_local.ParamByName('MovementDescNumber').AsInteger:=StrToInt(GetArrayList_Value_byName(Default_Array,'MovementNumber'));
               ParamsMovement_local.ParamByName('OrderExternal_BarCode').AsString:='';
               ParamsMovement_local.ParamByName('OrderExternal_InvNumber').AsString:='';
               ParamsMovement_local.ParamByName('calcPartnerId').AsInteger:=0;
               ParamsMovement_local.ParamByName('calcPartnerCode').AsInteger:=0;
               ParamsMovement_local.ParamByName('calcPartnerName').AsString:='';
          end
     else begin MessagePanel.Font.Style:=[];MessagePanel.Caption:='Новое взвешивание';end;

     if BarCode<>'' then ParamsMovement_local.ParamByName('OrderExternal_BarCode').AsString:=BarCode;

     IsBarCodeMaster:=BarCode<>'';
     IsOrderExternal:=false;

     CDS.Filtered:=false;

     ChoiceNumber:=0;
     with ParamsMovement_local do
     begin
          ChoiceNumber:=ParamByName('MovementDescNumber').AsInteger;
          CDS.Locate('Number',IntToStr(ParamByName('MovementDescNumber').AsInteger),[]);
          if ParamByName('OrderExternal_BarCode').AsString<>''
          then EditBarCode.Text:=ParamByName('OrderExternal_BarCode').AsString
          else if ParamByName('OrderExternal_InvNumber').AsString<> ''
               then EditBarCode.Text:=ParamByName('OrderExternal_InvNumber').AsString
               else EditBarCode.Text:=''{ParamByName('MovementDescNumber').AsString};

          EditPartnerCode.Text:= IntToStr(ParamByName('calcPartnerCode').AsInteger);
          PanelPartnerName.Caption:= ParamByName('calcPartnerName').AsString;
     end;

     ActiveControl:=EditBarCode;
     EditBarCode.SelectAll;
     //isEditBarCode:=BarCode<>'';
     isEditBarCode:=FALSE;//ParamsMovement_local.ParamByName('OrderExternal_DescId').AsInteger<>zc_Movement_SendOnPrice;
//     isEditPartnerCodeExit:= TRUE;

     if BarCode<>'' then begin isEditBarCode:=true;EditBarCodeExit(EditBarCode);Result:=true;end
     else begin Result:=(ShowModal=mrOk);end;
end;
{------------------------------------------------------------------------}
function TDialogReestrInsertForm.Get_isSendOnPriceIn(MovementDescNumber:Integer): boolean;
begin
     Result:=false;
     //
        if MovementDescNumber <> 0 then
        begin
             CDS.Filter:='(Number='+IntToStr(MovementDescNumber)
                        +')'
                          ;
             CDS.Filtered:=true;
             if CDS.RecordCount<>1
             then ShowMessage('Ошибка.Код операции не определен.')
             else Result:=CDS.FieldByName('isSendOnPriceIn').asBoolean;
        end;
end;
{------------------------------------------------------------------------}
function TDialogReestrInsertForm.Checked: boolean; //Проверка корректного ввода в Edit
begin
     ChoiceNumber:=0;
     //
     Result:=(IsOrderExternal=true)and(CDS.FieldByName('MovementDescId').AsInteger>0)and(ActiveControl=DBGrid);
     if not Result then exit;

     //если режим Update, т.е. BarCode = 'isUpdateUnit'
     if isUpdateUnit = TRUE
     then begin
         Result:= (CDS.FieldByName('MovementDescId').asInteger                    = ParamsMovement.ParamByName('MovementDescId').AsInteger)
              and (ParamsMovement_local.ParamByName('calcPartnerId').AsInteger    = ParamsMovement.ParamByName('calcPartnerId').AsInteger)
              and (ParamsMovement_local.ParamByName('OrderExternalId').AsInteger  = ParamsMovement.ParamByName('OrderExternalId').AsInteger)
                 ;
         if not Result then
         begin
              ShowMessage('Ошибка.В выбранном режиме можно исправить ТОЛЬКО склад.');
              exit;
         end;
     end;

     //!!!обнуляется т.к.было изменение MovementDescId!!!
     if  (CDS.FieldByName('MovementDescId').asInteger<>ParamsMovement.ParamByName('MovementDescId').AsInteger)
      or (CDS.FieldByName('isSendOnPriceIn').asBoolean <> ParamsMovement.ParamByName('isSendOnPriceIn').asBoolean)
     then begin
          //!!!только если OrderExternalId был изначально!!!
          if (ParamsMovement.ParamByName('OrderExternalId').AsInteger<>0) then
          begin
               ParamsMovement_local.ParamByName('OrderExternalId').AsInteger        := 0;
               ParamsMovement_local.ParamByName('OrderExternal_DescId').AsInteger   := 0;
               ParamsMovement_local.ParamByName('OrderExternal_BarCode').asString   := '';
               ParamsMovement_local.ParamByName('OrderExternal_InvNumber').asString := '';
               ParamsMovement_local.ParamByName('OrderExternalName_master').asString:= '';
          end;
          //!!!только если OrderExternalId был!!!
          if (ParamsMovement_local.ParamByName('calcPartnerId').AsInteger=ParamsMovement.ParamByName('calcPartnerId').AsInteger)
            and(ParamsMovement_local.ParamByName('isGetPartner').AsBoolean= false)
            and(ParamsMovement.ParamByName('calcPartnerId').AsInteger>0)
          then begin
               ParamsMovement_local.ParamByName('calcPartnerId').AsInteger  := 0;
               ParamsMovement_local.ParamByName('calcPartnerCode').AsInteger:= 0;
               ParamsMovement_local.ParamByName('calcPartnerName').asString := '';
          end;
     end;

     // проверка для контрагента
     if ((CDS.FieldByName('MovementDescId').asInteger=zc_Movement_Income)
       or(CDS.FieldByName('MovementDescId').asInteger=zc_Movement_ReturnOut)
       or(CDS.FieldByName('MovementDescId').asInteger=zc_Movement_Sale)
       or(CDS.FieldByName('MovementDescId').asInteger=zc_Movement_ReturnIn)
        )
       and(ParamsMovement_local.ParamByName('calcPartnerId').AsInteger=0)
     then begin
               ShowMessage('Ошибка.Значение <Код контрагента> не найдено.');
               ActiveControl:=EditPartnerCode;
               Result:=false;
               exit;
     end;
     // проверка для списания
     if   (CDS.FieldByName('MovementDescId').asInteger=zc_Movement_Loss)
       and(ParamsMovement_local.ParamByName('calcPartnerId').AsInteger=0)
       and(CDS.FieldByName('ToId').asInteger=0)
     then begin
               ShowMessage('Ошибка.Значение <Код контрагента> не найдено.');
               ActiveControl:=EditPartnerCode;
               Result:=false;
               exit;
     end;
     // проверка для перемещения с филиалами
     if   (CDS.FieldByName('MovementDescId').asInteger=zc_Movement_SendOnPrice)
       and(ParamsMovement_local.ParamByName('calcPartnerId').AsInteger=0)
       and((CDS.FieldByName('FromId').asInteger=0)
           or (CDS.FieldByName('ToId').asInteger=0))
     then begin
               ShowMessage('Ошибка.Значение <Код контрагента> не найдено.');
               ActiveControl:=EditPartnerCode;
               Result:=false;
               exit;
     end;
     // проверка для формы оплаты
     if ((CDS.FieldByName('MovementDescId').asInteger=zc_Movement_Income)
       or(CDS.FieldByName('MovementDescId').asInteger=zc_Movement_ReturnOut)
       or(CDS.FieldByName('MovementDescId').asInteger=zc_Movement_Sale)
       or(CDS.FieldByName('MovementDescId').asInteger=zc_Movement_ReturnIn)
        )
       and(ParamsMovement_local.ParamByName('PaidKindId').AsInteger<>CDS.FieldByName('PaidKindId').asInteger)
       and(ParamsMovement_local.ParamByName('PaidKindId').AsInteger>0)
     then begin
               ShowMessage('Ошибка.Выберите значение <Форма оплаты> = <'+ParamsMovement_local.ParamByName('PaidKindName').asString+'>.');
               if(Length(trim(EditBarCode.Text))=1)or(Length(trim(EditBarCode.Text))=2)
               then ActiveControl:=EditBarCode
               else ActiveControl:=EditBarCode;//DBGrid;
               isEditBarCode:=false;
               Result:=false;
               exit;
     end;

     //
     with ParamsMovement_local do
     begin
          //
          //if ParamByName('MovementId').AsInteger<>0
          //then ShowMessage('После завершения <Нового> взвешивания возврат к текущему будет произведен автоматически.');
          if ParamsMovement_local.ParamByName('isMovementId_check').asBoolean = FALSE
          then ParamByName('MovementId').AsInteger:=0; // т.е. будет Insert, иначе Update
          //
          ParamByName('ColorGridValue').AsInteger          := CDS.FieldByName('ColorGridValue').asInteger;
          ParamByName('MovementDescNumber').AsInteger      := CDS.FieldByName('Number').asInteger;
          ParamByName('MovementDescId').AsInteger          := CDS.FieldByName('MovementDescId').asInteger;
          ParamByName('MovementDescName_master').asString  := CDS.FieldByName('MovementDescName_master').asString;
          ParamByName('GoodsKindWeighingGroupId').asInteger:= CDS.FieldByName('GoodsKindWeighingGroupId').asInteger;
          ParamByName('DocumentKindId').asInteger          := CDS.FieldByName('DocumentKindId').asInteger;
          ParamByName('DocumentKindName').asString         := CDS.FieldByName('DocumentKindName').asString;
          ParamByName('isSendOnPriceIn').asBoolean         := CDS.FieldByName('isSendOnPriceIn').asBoolean;
          ParamByName('isPartionGoodsDate').asBoolean      := CDS.FieldByName('isPartionGoodsDate').asBoolean;
          ParamByName('isTransport_link').asBoolean        := CDS.FieldByName('isTransport_link').asBoolean;

          if  (CDS.FieldByName('MovementDescId').asInteger = zc_Movement_ReturnIn)
            or(CDS.FieldByName('MovementDescId').asInteger = zc_Movement_Income)
          then begin
                    ParamByName('FromId').AsInteger       := ParamByName('calcPartnerId').asInteger;
                    ParamByName('FromCode').AsInteger     := ParamByName('calcPartnerCode').asInteger;
                    ParamByName('FromName').asString      := ParamByName('calcPartnerName').asString;
                    ParamByName('ToId').AsInteger         := CDS.FieldByName('ToId').asInteger;
                    ParamByName('ToCode').AsInteger       := CDS.FieldByName('ToCode').asInteger;
                    ParamByName('ToName').asString        := CDS.FieldByName('ToName').asString;
                    ParamByName('PaidKindId').AsInteger   := CDS.FieldByName('PaidKindId').asInteger;
                    ParamByName('PaidKindName').asString  := CDS.FieldByName('PaidKindName').asString;
                    ParamByName('InfoMoneyId').AsInteger  := CDS.FieldByName('InfoMoneyId').asInteger;
                    ParamByName('InfoMoneyCode').AsInteger:= CDS.FieldByName('InfoMoneyCode').asInteger;
                    ParamByName('InfoMoneyName').asString := CDS.FieldByName('InfoMoneyName').asString;
                    ParamByName('ChangePercentAmount').asFloat:= 0;
                    ParamByName('OrderExternalId').AsInteger        := 0;
                    ParamByName('OrderExternal_DescId').AsInteger   := 0;
                    ParamByName('OrderExternal_BarCode').asString   := '';
                    ParamByName('OrderExternal_InvNumber').asString := '';
                    ParamByName('OrderExternalName_master').asString:= '';
          end
          else
          if  (CDS.FieldByName('MovementDescId').asInteger = zc_Movement_Sale)
            or(CDS.FieldByName('MovementDescId').asInteger = zc_Movement_ReturnOut)
            or(CDS.FieldByName('MovementDescId').asInteger = zc_Movement_Loss)
          then begin
                    ParamByName('FromId').AsInteger       := CDS.FieldByName('FromId').asInteger;
                    ParamByName('FromCode').asString      := CDS.FieldByName('FromCode').asString;
                    ParamByName('FromName').asString      := CDS.FieldByName('FromName').asString;
                    ParamByName('ToId').AsInteger         := ParamByName('calcPartnerId').asInteger;
                    ParamByName('ToCode').AsInteger       := ParamByName('calcPartnerCode').asInteger;
                    ParamByName('ToName').asString        := ParamByName('calcPartnerName').asString;
                    ParamByName('PaidKindId').AsInteger   := CDS.FieldByName('PaidKindId').asInteger;
                    ParamByName('PaidKindName').asString  := CDS.FieldByName('PaidKindName').asString;
                    ParamByName('InfoMoneyId').AsInteger  := CDS.FieldByName('InfoMoneyId').asInteger;
                    ParamByName('InfoMoneyCode').AsInteger:= CDS.FieldByName('InfoMoneyCode').asInteger;
                    ParamByName('InfoMoneyName').asString := CDS.FieldByName('InfoMoneyName').asString;
                    if (CDS.FieldByName('MovementDescId').asInteger <> zc_Movement_Sale)
                    then ParamByName('ChangePercentAmount').asFloat:= 0;
                    if (CDS.FieldByName('MovementDescId').asInteger = zc_Movement_ReturnOut)
                    then begin
                              ParamByName('OrderExternalId').AsInteger        := 0;
                              ParamByName('OrderExternal_DescId').AsInteger   := 0;
                              ParamByName('OrderExternal_BarCode').asString   := '';
                              ParamByName('OrderExternal_InvNumber').asString := '';
                              ParamByName('OrderExternalName_master').asString:= '';
                    end;
          end
          else
          if  (CDS.FieldByName('MovementDescId').asInteger = zc_Movement_SendOnPrice)
          then begin
                    if CDS.FieldByName('FromId').asInteger = 0 then
                    begin ParamByName('FromId').AsInteger := ParamByName('calcPartnerId').asInteger;
                          ParamByName('FromCode').asString:= ParamByName('calcPartnerCode').asString;
                          ParamByName('FromName').asString:= ParamByName('calcPartnerName').asString;
                    end
                    else
                    begin ParamByName('FromId').AsInteger := CDS.FieldByName('FromId').asInteger;
                          ParamByName('FromCode').asString:= CDS.FieldByName('FromCode').asString;
                          ParamByName('FromName').asString:= CDS.FieldByName('FromName').asString;
                    end;
                    if (CDS.FieldByName('ToId').asInteger = 0) and (CDS.FieldByName('FromId').asInteger <> 0) then
                    begin ParamByName('ToId').AsInteger  := ParamByName('calcPartnerId').asInteger;
                          ParamByName('ToCode').AsInteger:= ParamByName('calcPartnerCode').asInteger;
                          ParamByName('ToName').asString := ParamByName('calcPartnerName').asString;
                    end
                    else
                    begin ParamByName('ToId').AsInteger := CDS.FieldByName('ToId').asInteger;
                          ParamByName('ToCode').asString:= CDS.FieldByName('ToCode').asString;
                          ParamByName('ToName').asString:= CDS.FieldByName('ToName').asString;
                    end;

                    ParamByName('PriceListId').AsInteger      := CDS.FieldByName('PriceListId').asInteger;
                    ParamByName('PriceListCode').AsInteger    := CDS.FieldByName('PriceListCode').asInteger;
                    ParamByName('PriceListName').asString     := CDS.FieldByName('PriceListName').asString;

                    ParamByName('PaidKindId').AsInteger       := 0;
                    ParamByName('PaidKindName').asString      := '';
                    ParamByName('InfoMoneyId').AsInteger      := 0;
                    ParamByName('InfoMoneyCode').AsInteger    := 0;
                    ParamByName('InfoMoneyName').asString     := '';
                    ParamByName('ChangePercentAmount').asFloat:= 0;
                    //!!!!!!!if ParamByName('isSendOnPriceIn').asBoolean = TRUE
                    //!!!!!!!then ParamByName('ChangePercentAmount').asFloat:= 0;

                    {ParamByName('OrderExternalId').AsInteger        := 0;
                    ParamByName('OrderExternal_DescId').AsInteger   := 0;
                    ParamByName('OrderExternal_BarCode').asString   := '';
                    ParamByName('OrderExternal_InvNumber').asString := '';
                    ParamByName('OrderExternalName_master').asString:= '';}
          end
          else begin
                    ParamByName('FromId').AsInteger           := CDS.FieldByName('FromId').asInteger;
                    ParamByName('FromCode').asString          := CDS.FieldByName('FromCode').asString;
                    ParamByName('FromName').asString          := CDS.FieldByName('FromName').asString;
                    ParamByName('ToId').AsInteger             := CDS.FieldByName('ToId').asInteger;
                    ParamByName('ToCode').AsInteger           := CDS.FieldByName('ToCode').asInteger;
                    ParamByName('ToName').asString            := CDS.FieldByName('ToName').asString;
                    ParamByName('PriceListId').AsInteger      := CDS.FieldByName('PriceListId').asInteger;
                    ParamByName('PriceListCode').AsInteger    := CDS.FieldByName('PriceListCode').asInteger;
                    ParamByName('PriceListName').asString     := CDS.FieldByName('PriceListName').asString;
                    ParamByName('calcPartnerId').asInteger    := 0;
                    ParamByName('calcPartnerCode').asInteger  := 0;
                    ParamByName('calcPartnerName').asString   := '';
                    ParamByName('ChangePercent').asFloat      := 0;
                    ParamByName('ChangePercentAmount').asFloat:= 0;
                    ParamByName('isEdiOrdspr').asBoolean      := FALSE;
                    ParamByName('isEdiInvoice').asBoolean     := FALSE;
                    ParamByName('isEdiDesadv').asBoolean      := FALSE;
                    ParamByName('ContractId').AsInteger       := 0;
                    ParamByName('ContractCode').AsInteger     := 0;
                    ParamByName('ContractNumber').asString    := '';
                    ParamByName('ContractTagName').asString   := '';
                    ParamByName('PaidKindId').AsInteger       := 0;
                    ParamByName('PaidKindName').asString      := '';

                    ParamByName('InfoMoneyId').AsInteger      := CDS.FieldByName('InfoMoneyId').asInteger;
                    ParamByName('InfoMoneyCode').AsInteger    := CDS.FieldByName('InfoMoneyCode').asInteger;
                    ParamByName('InfoMoneyName').asString     := CDS.FieldByName('InfoMoneyName').asString;
                    ParamByName('GoodsPropertyId').AsInteger  := 0;
                    ParamByName('GoodsPropertyCode').AsInteger:= 0;
                    ParamByName('GoodsPropertyName').asString := '';

                    ParamByName('OrderExternalId').AsInteger        := 0;
                    ParamByName('OrderExternal_DescId').AsInteger   := 0;
                    ParamByName('OrderExternal_BarCode').asString   := '';
                    ParamByName('OrderExternal_InvNumber').asString := '';
                    ParamByName('OrderExternalName_master').asString:= '';
               end;

    end;

    if(Length(trim(EditBarCode.Text))<=2)
    then EditBarCode.Text:=CDS.FieldByName('Number').asString;

    CopyValuesParamsFrom(ParamsMovement_local,ParamsMovement);

    MyDelay(400);
end;
{------------------------------------------------------------------------}
procedure TDialogReestrInsertForm.EditBarCodeEnter(Sender: TObject);
begin
    if CDS.Filtered then CDS.Filtered:=false;
    CDS.Locate('Number',IntToStr(ParamsMovement_local.ParamByName('MovementDescNumber').AsInteger),[]);
end;
{------------------------------------------------------------------------}
procedure TDialogReestrInsertForm.EditBarCodeExit(Sender: TObject);
var Number:Integer;
    fOK:Boolean;
begin
    if isEditBarCode=false then exit;

    if CDS.Filtered then CDS.Filtered:=false;
    //
    if (Length(trim(EditBarCode.Text))>2) and (SettingMain.isCeh = FALSE)
    then begin
               //Проверка <Контрольная сумма>
               if (Length(trim(EditBarCode.Text))>=13)and(CheckBarCode(trim(EditBarCode.Text)) = FALSE)
               then begin
                  EditBarCode.Text:='';
                  ActiveControl:=EditBarCode;
                  exit;
               end;
              //поиск по номеру или ш-к
              isOrderExternal:=DMMainScaleForm.gpGet_Scale_OrderExternal(ParamsMovement_local,EditBarCode.Text);
              if isOrderExternal=false then
              begin
                   ShowMessage('Ошибка.'+#10+#13+'Значение <Код операции/№ "основания"/Штрих код "основания"> не найдено.');
                   ActiveControl:=EditBarCode;
                   exit;
              end
              else begin
                        EditPartnerCode.Text:= IntToStr(ParamsMovement_local.ParamByName('calcPartnerCode').AsInteger);
                        PanelPartnerName.Caption:= ParamsMovement_local.ParamByName('calcPartnerName').asString;
                   end;
    end
    else begin //обнуление
               isOrderExternal:=true;
               {ParamsMovement_local.ParamByName('OrderExternalId').AsInteger:=0;
               ParamsMovement_local.ParamByName('OrderExternal_DescId').AsInteger:=0;
               ParamsMovement_local.ParamByName('OrderExternal_BarCode').asString :='';
               ParamsMovement_local.ParamByName('OrderExternal_InvNumber').asString :='';
               ParamsMovement_local.ParamByName('OrderExternalName_master').asString :='';}
               //
               try Number:=StrToInt(trim(EditBarCode.Text)) except Number:=0;end;
               // если это код операции
               if Number>0 then
               begin
                    CDS.Locate('Number',IntToStr(Number),[]);
                    fOK:=CDS.FieldByName('Number').asInteger=Number;
                    //
                    if CDS.FieldByName('MovementDescId').asInteger = zc_Movement_SendOnPrice
                    then if CDS.FieldByName('isSendOnPriceIn').asBoolean = TRUE
                         then CDS.Filter:='Number='+IntToStr(Number)+' or (MovementDescId='+IntToStr(-1*CDS.FieldByName('MovementDescId').asInteger) + ' and isSendOnPriceIn = TRUE)'
                         else CDS.Filter:='Number='+IntToStr(Number)+' or (MovementDescId='+IntToStr(-1*CDS.FieldByName('MovementDescId').asInteger) + ' and isSendOnPriceIn = FALSE)'
                    else CDS.Filter:='Number='+IntToStr(Number)+' or MovementDescId='+IntToStr(-1*CDS.FieldByName('MovementDescId').asInteger);

                    CDS.Filtered:=true;
                    CDS.Locate('Number',IntToStr(Number),[]);
                    if not fOK then
                    begin
                         if not IsBarCodeMaster then ShowMessage('Ошибка.Значение <Вид документа> не определено.');
                         ActiveControl:=EditBarCode;
                         exit;
                    end;
                    //
                    ParamsMovement_local.ParamByName('MovementDescNumber').AsInteger:= CDS.FieldByName('Number').asInteger;
                    ParamsMovement_local.ParamByName('InfoMoneyId').AsInteger  := CDS.FieldByName('InfoMoneyId').asInteger;
                    ParamsMovement_local.ParamByName('InfoMoneyCode').AsInteger:= CDS.FieldByName('InfoMoneyCode').asInteger;
                    ParamsMovement_local.ParamByName('InfoMoneyName').asString := CDS.FieldByName('InfoMoneyName').asString;

                    ChoiceNumber:=CDS.FieldByName('Number').asInteger;
                    // завершение
                    if   (CDS.FieldByName('MovementDescId').asInteger<>zc_Movement_Income)
                      and(CDS.FieldByName('MovementDescId').asInteger<>zc_Movement_ReturnOut)
                      and(CDS.FieldByName('MovementDescId').asInteger<>zc_Movement_Sale)
                      and(CDS.FieldByName('MovementDescId').asInteger<>zc_Movement_ReturnIn)
                      and(CDS.FieldByName('MovementDescId').asInteger<>zc_Movement_Loss)
                      and(CDS.FieldByName('MovementDescId').asInteger<>zc_Movement_SendOnPrice)
                    then begin ActiveControl:=DBGrid;bbOkClick(Self);{DBGridCellClick(DBGrid.Columns[0]);}end;
                    //
                    if (CDS.FieldByName('MovementDescId').asInteger=zc_Movement_SendOnPrice)
                    and(CDS.FieldByName('FromId').asInteger<>0)
                    and(CDS.FieldByName('ToId').asInteger<>0)
                    then begin ActiveControl:=DBGrid;bbOkClick(Self);{DBGridCellClick(DBGrid.Columns[0]);}end;
               end;
          end;
    //
    if ParamsMovement_local.ParamByName('OrderExternal_BarCode').asString <> ''
    then begin
              if (ParamsMovement_local.ParamByName('MovementDescId').AsInteger = zc_Movement_SendOnPrice)
               or(ParamsMovement_local.ParamByName('MovementDescId').AsInteger = zc_Movement_Loss)
              then CDS.Filter:='Number='+IntToStr(ParamsMovement_local.ParamByName('MovementDescNumber').asInteger)
              else CDS.Filter:='(MovementDescId='+IntToStr(ParamsMovement_local.ParamByName('MovementDescId').asInteger)
                              +'  and FromId='+IntToStr(ParamsMovement_local.ParamByName('FromId').asInteger)
                              +'  and PaidKindId='+IntToStr(ParamsMovement_local.ParamByName('PaidKindId').asInteger)
                              //+'  and FromId='+IntToStr(ParamsMovement_local.ParamByName('FromId').asInteger)
                              +'     )'
                              +'  or MovementDescId='+IntToStr(-1*ParamsMovement_local.ParamByName('MovementDescId').asInteger)
                              ;
              CDS.Filtered:=true;
              CDS.Locate('MovementDescId',ParamsMovement_local.ParamByName('MovementDescId').asString,[]);
              if ((CDS.RecordCount<>1) and ((ParamsMovement_local.ParamByName('MovementDescId').AsInteger =  zc_Movement_SendOnPrice)
                                          or(ParamsMovement_local.ParamByName('MovementDescId').AsInteger =  zc_Movement_Loss))
                 )
               or((CDS.RecordCount<>2) and (ParamsMovement_local.ParamByName('MovementDescId').AsInteger <> zc_Movement_SendOnPrice)
                                       and (ParamsMovement_local.ParamByName('MovementDescId').AsInteger <> zc_Movement_Loss))
              then begin
                   ShowMessage('Ошибка.Значение <Вид документа> не определено.');
                   ActiveControl:=EditBarCode;
                   isOrderExternal:=false;
                   exit;
              end;
              // завершение
              ActiveControl:=DBGrid;
              bbOkClick(Self);{DBGridCellClick(DBGrid.Columns[0])};
        end;
end;
{------------------------------------------------------------------------}
procedure TDialogReestrInsertForm.EditBarCodeChange(Sender: TObject);
begin
    isEditBarCode:=true;
    if (Length(trim(EditBarCode.Text))>=13)and(not IsBarCodeMaster) then EditBarCodeExit(Self);
end;
{------------------------------------------------------------------------}
procedure TDialogReestrInsertForm.EditPartnerCodeEnter(Sender: TObject);
begin
  TEdit(Sender).SelectAll;
  isEditPartnerCodeExit:= TRUE;
    if ParamsMovement_local.ParamByName('MovementDescNumber').AsInteger<>0
    then begin
              EditBarCode.Text:=IntToStr(ParamsMovement_local.ParamByName('MovementDescNumber').AsInteger);
              isEditBarCode:=true;
              EditBarCodeExit(Self);
              //переопределяются параметры, т.к. они используются в фильтре справ.
              ParamsMovement_local.ParamByName('MovementDescId').AsInteger:= CDS.FieldByName('MovementDescId').asInteger;
    end;
end;
{------------------------------------------------------------------------}
procedure TDialogReestrInsertForm.EditPartnerCodeExit(Sender: TObject);
var PartnerCode_int:Integer;
begin
     //!!!exit!!!
     if isEditPartnerCodeExit = false then exit;

    //if CDS.Filtered then CDS.Filtered:=false;
    //
    try PartnerCode_int:= StrToInt(EditPartnerCode.Text);
    except
     PartnerCode_int:= 0;
    end;

    if (ParamsMovement_local.ParamByName('OrderExternalId').AsInteger<>0)
    then exit;//!!!выход в этом случае!!!
    if (PartnerCode_int=0)
    then exit;//!!!выход в этом случае!!!

     //переопределяются параметры, т.к. они используются в Get
     if CDS.RecordCount = 2
     then begin
               //PaidKindId
               ParamsMovement_local.ParamByName('PaidKindId').AsInteger:=CDS.FieldByName('PaidKindId').asInteger;
               //MovementDescId
               ParamsMovement_local.ParamByName('MovementDescId').AsInteger:=CDS.FieldByName('MovementDescId').asInteger;
           end
     else begin
               //PaidKindId
               ParamsMovement_local.ParamByName('PaidKindId').AsInteger:=0;
               //MovementDescId
               ParamsMovement_local.ParamByName('MovementDescId').AsInteger:=0;
     end;

     //поиск контрагента по коду + заполняются параметры (!!!не только Partner!!!)
     if DMMainScaleForm.gpGet_Scale_Partner(ParamsMovement_local,PartnerCode_int) = true then
     begin
          EditPartnerCode.Text:= IntToStr(ParamsMovement_local.ParamByName('calcPartnerCode').AsInteger);
          PanelPartnerName.Caption:= ParamsMovement_local.ParamByName('calcPartnerName').asString;
     end;

     if ParamsMovement_local.ParamByName('calcPartnerId').AsInteger=0
     then begin
               ShowMessage('Ошибка.Значение <Код контрагента> не найдено.');
               ActiveControl:=EditPartnerCode;
               exit;
     end;
     //
     if   (ParamsMovement_local.ParamByName('ContractId').AsInteger=0)
       and(ParamsMovement_local.ParamByName('MovementDescId').AsInteger<>zc_Movement_Loss)
       and(ParamsMovement_local.ParamByName('MovementDescId').AsInteger<>zc_Movement_SendOnPrice)
     then begin
               ParamsMovement_local.ParamByName('calcPartnerId').AsInteger:=0;
               ShowMessage('Ошибка.У контрагента не определено значение <Договор>.');
               ActiveControl:=EditPartnerCode;
               exit;
     end;
     if   (ParamsMovement_local.ParamByName('PriceListId').AsInteger=0)
       and(ParamsMovement_local.ParamByName('MovementDescId').AsInteger<>zc_Movement_Loss)
       //and(ParamsMovement_local.ParamByName('MovementDescId').AsInteger<>zc_Movement_SendOnPrice)
     then begin
               ParamsMovement_local.ParamByName('calcPartnerId').AsInteger:=0;
               ShowMessage('Ошибка.У контрагента не определено значение <Прайс-лист>.');
               ActiveControl:=EditPartnerCode;
               exit;
     end;
     if   (ParamsMovement_local.ParamByName('PaidKindId').AsInteger=0)
       and(ParamsMovement_local.ParamByName('MovementDescId').AsInteger<>zc_Movement_Loss)
       and(ParamsMovement_local.ParamByName('MovementDescId').AsInteger<>zc_Movement_SendOnPrice)
     then begin
               ParamsMovement_local.ParamByName('calcPartnerId').AsInteger:=0;
               ShowMessage('Ошибка.У контрагента не определено значение <Форма оплаты>.');
               ActiveControl:=EditPartnerCode;
               exit;
     end;
end;
{------------------------------------------------------------------------}
procedure TDialogReestrInsertForm.EditPartnerCodeKeyDown(Sender: TObject;var Key: Word; Shift: TShiftState);
begin
     if Key = VK_RETURN
     then if CDS.RecordCount=2
          then begin ActiveControl:=DBGrid;bbOkClick(Self);{DBGridCellClick(DBGrid.Columns[0]);}end
          else ActiveControl:=EditBarCode;
end;
{------------------------------------------------------------------------}
procedure TDialogReestrInsertForm.EditPartnerCodePropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
var Key:Word;
begin
    if SettingMain.isCeh = TRUE then exit;
    //
    if ParamsMovement_local.ParamByName('MovementDescNumber').AsInteger<>0
    then begin
              EditBarCode.Text:=IntToStr(ParamsMovement_local.ParamByName('MovementDescNumber').AsInteger);
              isEditBarCode:=true;
              EditBarCodeExit(Self);
              //переопределяются параметры, т.к. они используются в фильтре справ.
              ParamsMovement_local.ParamByName('MovementDescId').AsInteger:= CDS.FieldByName('MovementDescId').asInteger;
    end;

    try
    if (trim(EditPartnerCode.Text)<>'')and(trim(EditPartnerCode.Text)<>'0')
    then ParamsMovement_local.ParamByName('calcPartnerCode').AsInteger:=StrToInt(trim(EditPartnerCode.Text))
    except ParamsMovement_local.ParamByName('calcPartnerCode').AsInteger:=0;
    end;

    if GuidePartnerForm.Execute(ParamsMovement_local)
    then begin
              ParamsMovement_local.ParamByName('OrderExternalId').AsInteger:=0;
              ParamsMovement_local.ParamByName('OrderExternal_DescId').AsInteger:=0;
              ParamsMovement_local.ParamByName('OrderExternal_BarCode').asString :='';
              ParamsMovement_local.ParamByName('OrderExternal_InvNumber').asString :='';
              ParamsMovement_local.ParamByName('OrderExternalName_master').asString :='';

              ParamsMovement_local.ParamByName('isGetPartner').AsBoolean:= true;
              EditPartnerCode.Text:=IntToStr(ParamsMovement_local.ParamByName('calcPartnerCode').AsInteger);
              PanelPartnerName.Caption:= ParamsMovement_local.ParamByName('calcPartnerName').AsString;
              Key:=VK_RETURN;
              isEditPartnerCodeExit:= false;
              EditPartnerCodeKeyDown(Sender,Key,[]);
              isEditPartnerCodeExit:= true;
    end;
    //else ActiveControl:=EditBarCode;
end;
{------------------------------------------------------------------------}
procedure TDialogReestrInsertForm.DBGrid111CellClick(Column: TColumn);
begin DBGridDblClick(Self);end;
{------------------------------------------------------------------------}
procedure TDialogReestrInsertForm.DBGrid111DblClick(Sender: TObject);
begin
     if (CDS.FieldByName('MovementDescId').AsInteger<=0)
     then CDS.Next
     else begin
               ChoiceNumber:=CDS.FieldByName('Number').AsInteger;
               ParamsMovement_local.ParamByName('MovementDescNumber').AsInteger:=CDS.FieldByName('Number').AsInteger;
               DBGrid.Repaint;
               if isEditBarCode = FALSE then
               begin CDS.Filter:='Number='+IntToStr(ParamsMovement_local.ParamByName('MovementDescNumber').asInteger);
                     CDS.Filtered:=true;
                     IsOrderExternal:=true;
               end;
               bbOkClick(Self);
     end;
end;
{------------------------------------------------------------------------}
procedure TDialogReestrInsertForm.DBGrid111DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
     //if (gdSelected in State)and(ChoiceNumber=0) then exit;
     if (gdSelected in State) then exit;

     //if ChoiceNumber <> 0 then ShowMessage (CDS.FieldByName('Number').AsString);

     with (Sender as TDBGrid).Canvas do
     if CDS.FieldByName('MovementDescId').AsInteger<=0 then
     begin
          Font.Color:=clNavy;
          Font.Size:=11;
          Font.Style:=[fsBold];
          FillRect(Rect);
          //TextOut(Rect.Left + 30, Rect.Top + 0, Column.Field.Text);
          if (Column.Alignment=taLeftJustify)or(Rect.Left>=Rect.Right - LengTh(Column.Field.Text))
          then TextOut(Rect.Left+32, Rect.Top+2, Column.Field.Text)
          else TextOut(Rect.Right - TextWidth(Column.Field.Text) - 2, Rect.Top+2 , Column.Field.Text);
     end
     else
     if CDS.FieldByName('Number').AsInteger=ChoiceNumber then
     begin
          Font.Color:=clBlue;
          Font.Size:=10;
          Font.Style:=[];
//          FillRect(Rect);
          //TextOut(Rect.Left + 2, Rect.Top + 2, Column.Field.Text);
          if (Column.Alignment=taLeftJustify)or(Rect.Left>=Rect.Right - LengTh(Column.Field.Text))
          then TextOut(Rect.Left+2, Rect.Top+2, Column.Field.Text)
          else TextOut(Rect.Right - TextWidth(Column.Field.Text) - 2, Rect.Top+2 , Column.Field.Text);
     end
     else
     begin
          Font.Color:=clBlack;
          Font.Size:=10;
          Font.Style:=[];
          FillRect(Rect);
          //TextOut(Rect.Left + 5, Rect.Top + 0, Column.Field.Text);
          if (Column.Alignment=taLeftJustify)or(Rect.Left>=Rect.Right - LengTh(Column.Field.Text))
          then TextOut(Rect.Left+2, Rect.Top+2, Column.Field.Text)
          else TextOut(Rect.Right - TextWidth(Column.Field.Text) - 2, Rect.Top+2 , Column.Field.Text);
     end;
end;
{------------------------------------------------------------------------}
procedure TDialogReestrInsertForm.FormCreate(Sender: TObject);
begin
  inherited;
  //
  infoPanelPartner.Visible:= SettingMain.isCeh = FALSE;
  //
  with spSelect do
  begin
       StoredProcName:='gpSelect_Object_ToolsWeighing_MovementDesc';
       OutputType:=otDataSet;
       Params.AddParam('inIsCeh', ftBoolean, ptInput, SettingMain.isCeh);
       Params.AddParam('inBranchCode', ftInteger, ptInput, SettingMain.BranchCode);
       Execute;
  end;
  //
  Create_ParamsMovement(ParamsMovement_local);
  //global Initialize
  gpInitialize_MovementDesc;
  //
  bbOk.Visible := false;
end;
{------------------------------------------------------------------------}
procedure TDialogReestrInsertForm.FormDestroy(Sender: TObject);
begin
  ParamsMovement_local.Free;
  ParamsMovement.Free;
end;
{------------------------------------------------------------------------}
procedure TDialogReestrInsertForm.FormKeyDown(Sender: TObject; var Key: Word;  Shift: TShiftState);
begin
     if Key = VK_RETURN
     then if (ActiveControl=EditBarCode) and (infoPanelPartner.Visible)
          then begin
                    if trim(EditBarCode.Text)=''
                    then EditBarCode.Text:=IntToStr(ParamsMovement_local.ParamByName('MovementDescNumber').AsInteger);

                    isEditBarCode:=true;
                    EditBarCodeExit(Self);
                    //переопределяются параметры, т.к. они используются в фильтре справ.
                    ParamsMovement_local.ParamByName('MovementDescId').AsInteger:= CDS.FieldByName('MovementDescId').asInteger;
                    //
                    ActiveControl:=EditPartnerCode;
              end
          else
          if (ActiveControl=EditBarCode) and (not infoPanelPartner.Visible)
          then ActiveControl:=DBGrid
          else if (ActiveControl=EditPartnerCode)
               then ActiveControl:=DBGrid
               else if (ActiveControl=DBGrid)
                    then DBGridCellClick(DBGrid.Columns[0]);
end;
{------------------------------------------------------------------------}
procedure TDialogReestrInsertForm.FormKeyUp(Sender: TObject; var Key: Word;Shift: TShiftState);
begin
     if (Key = VK_UP)or(Key = VK_DOWN)or(Key = VK_HOME)or(Key = VK_END)or(Key = VK_PRIOR)or(Key = VK_NEXT)
     then if (CDS.FieldByName('MovementDescId').AsInteger<=0)
          then CDS.Next;
end;
{------------------------------------------------------------------------}
procedure TDialogReestrInsertForm.FormShow(Sender: TObject);
begin
   DialogMovementDescForm.Width:=DialogMovementDescForm.Width+1;
   DialogMovementDescForm.Width:=DialogMovementDescForm.Width-1;
end;
{------------------------------------------------------------------------}
end.
