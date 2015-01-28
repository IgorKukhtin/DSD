unit GuideGoods;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, DBTables, StdCtrls, ExtCtrls, Grids, DBGrids, Buttons
 ,UtilScale, Datasnap.DBClient, dsdDB, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore,
  dxSkinsDefaultPainters, cxTextEdit, cxCurrencyEdit;

type
  TGuideGoodsForm = class(TForm)
    GridPanel: TPanel;
    DBGrid: TDBGrid;
    ParamsPanel: TPanel;
    infoPanelTare: TPanel;
    rgTareWeight: TRadioGroup;
    SummPanel: TPanel;
    infoPanelPriceList: TPanel;
    rgPriceList: TRadioGroup;
    PanelTare: TPanel;
    gbTareCount: TGroupBox;
    EditTareCount: TEdit;
    gbTareWeightCode: TGroupBox;
    EditTareWeightCode: TEdit;
    gbPriceListCode: TGroupBox;
    EditPriceListCode: TEdit;
    DataSource: TDataSource;
    infoPanelGoods: TPanel;
    gbGoodsName: TGroupBox;
    EditGoodsName: TEdit;
    gbGoodsCode: TGroupBox;
    EditGoodsCode: TEdit;
    gbGoodsWieghtValue: TGroupBox;
    PanelGoodsWieghtValue: TPanel;
    DiscountPanel: TPanel;
    rgChangePercent: TRadioGroup;
    gbChangePercentCode: TGroupBox;
    EditChangePercentCode: TEdit;
    ButtonPanel: TPanel;
    ButtonExit: TSpeedButton;
    ButtonRefresh: TSpeedButton;
    ButtonSaveAllItem: TSpeedButton;
    infoPanelGoodsKind: TPanel;
    rgGoodsKind: TRadioGroup;
    gbGoodsKindCode: TGroupBox;
    EditGoodsKindCode: TEdit;
    gbTareWeightEnter: TGroupBox;
    EditTareWeightEnter: TEdit;
    spSelect: TdsdStoredProc;
    CDS: TClientDataSet;
    gbWeightValue: TGroupBox;
    EditWeightValue: TcxCurrencyEdit;
    procedure FormCreate(Sender: TObject);
    procedure ButtonRefreshClick(Sender: TObject);
    procedure ButtonExitClick(Sender: TObject);
    procedure EditGoodsNameEnter(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ButtonSaveAllItemClick(Sender: TObject);
    procedure EditGoodsCodeKeyPress(Sender: TObject; var Key: Char);
    procedure EditGoodsCodeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditGoodsNameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditGoodsCodeExit(Sender: TObject);
    procedure EditGoodsNameExit(Sender: TObject);
    procedure EditGoodsCodeChange(Sender: TObject);
    procedure EditGoodsNameChange(Sender: TObject);
    procedure EditTareCountKeyPress(Sender: TObject; var Key: Char);
    procedure EditTareCountExit(Sender: TObject);
    procedure EditTareWeightCodeKeyPress(Sender: TObject; var Key: Char);
    procedure EditTareWeightCodeExit(Sender: TObject);
    procedure EditChangePercentCodeKeyPress(Sender: TObject; var Key: Char);
    procedure EditChangePercentCodeExit(Sender: TObject);
    procedure EditTareWeightCodeChange(Sender: TObject);
    procedure EditChangePercentCodeChange(Sender: TObject);
    procedure EditPriceListCodeKeyPress(Sender: TObject; var Key: Char);
    procedure EditPriceListCodeExit(Sender: TObject);
    procedure EditPriceListCodeChange(Sender: TObject);
    procedure rgTareWeightClick(Sender: TObject);
    procedure rgChangePercentClick(Sender: TObject);
    procedure rgPriceListClick(Sender: TObject);
    procedure EditGoodsCodeEnter(Sender: TObject);
    procedure EditTareCountEnter(Sender: TObject);
    procedure rgGoodsKindClick(Sender: TObject);
    procedure EditGoodsKindCodeChange(Sender: TObject);
    procedure EditGoodsKindCodeExit(Sender: TObject);
    procedure EditGoodsKindCodeKeyPress(Sender: TObject; var Key: Char);
    procedure EditTareWeightEnterExit(Sender: TObject);
    procedure CDSFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure DBGridDblClick(Sender: TObject);
    procedure EditGoodsNameKeyPress(Sender: TObject; var Key: Char);
    procedure DataSourceDataChange(Sender: TObject; Field: TField);
    procedure FormDestroy(Sender: TObject);
    procedure EditWeightValueExit(Sender: TObject);
    procedure EditWeightValueKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    fStartWtrite:Boolean;
    fEnterGoodsCode:Boolean;
    fEnterGoodsName:Boolean;
    function Checked: boolean;
    procedure InitializeGoodsKind(GoodsKindWeighingGroupId:Integer);
    procedure InitializePriceList(execParams:TParams);
  public
    GoodsWeight:Double;
    function Execute(BillDate:TDateTime): boolean;
  end;

var
  GuideGoodsForm: TGuideGoodsForm;

implementation

{$R *.dfm}

 uses dmMainScale;
{------------------------------------------------------------------------------}
function TGuideGoodsForm.Execute(BillDate:TDateTime): boolean;
begin
     fStartWtrite:=true;

  PanelGoodsWieghtValue.Caption:=FloatToStr(ParamsMI.ParamByName('RealWeight_Get').AsFloat);

  EditGoodsCode.Text:='';
  EditGoodsName.Text:='';
  EditGoodsKindCode.Text:='';
  EditTareWeightEnter.Text:='';

  EditWeightValue.Text:='0';

  EditTareCount.Text:=         GetArrayList_Value_byName(Default_Array,'TareCount');
  EditTareWeightCode.Text:=    IntToStr(TareWeight_Array[GetArrayList_Index_byNumber(TareWeight_Array,StrToInt(GetArrayList_Value_byName(Default_Array,'TareWeightNumber')))].Code);
  EditChangePercentCode.Text:= IntToStr(ChangePercent_Array[GetArrayList_Index_byValue(ChangePercent_Array,ParamsMovement.ParamByName('ChangePercent').AsString)].Code); //IntToStr(ChangePercent_Array[GetArrayList_Index_byNumber(ChangePercent_Array,StrToInt(GetArrayList_Value_byName(Default_Array,'ChangePercentNumber')))].Code);
  EditPriceListCode.Text:=     IntToStr(PriceList_Array[GetArrayList_Index_byNumber(PriceList_Array,StrToInt(GetArrayList_Value_byName(Default_Array,'PriceListNumber')))].Code);

  InitializeGoodsKind(ParamsMovement.ParamByName('GoodsKindWeighingGroupId').AsInteger);
  InitializePriceList(ParamsMovement);

  CDS.Filtered:=false;

     ActiveControl:=EditGoodsCode;
     Application.ProcessMessages;
     Application.ProcessMessages;
     Application.ProcessMessages;
     fStartWtrite:=false;

     result:=ShowModal=mrOk;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.InitializeGoodsKind(GoodsKindWeighingGroupId:Integer);
var i:Integer;
begin
     EditGoodsKindCode.Text:='';
     with rgGoodsKind do
     begin
          Items.Clear;
          for i:=0 to Length(GoodsKind_Array)-1 do
          if GoodsKind_Array[i].Number = GoodsKindWeighingGroupId
          then Items.Add('('+IntToStr(GoodsKind_Array[i].Code)+') '+ GoodsKind_Array[i].Name);

          if i<10 then Columns:=1 else Columns:=2;

     end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.InitializePriceList(execParams:TParams);
var i:Integer;
begin
     with rgPriceList do
     begin
          Items.Clear;
          if execParams.ParamByName('PriceListId').AsInteger=0
          then Items.Add('нет значения')
          else Items.Add('('+IntToStr(execParams.ParamByName('PriceListCode').AsInteger)+') '+ execParams.ParamByName('PriceListName').AsString);
          EditPriceListCode.Text:=IntToStr(execParams.ParamByName('PriceListCode').AsInteger);
          rgPriceList.ItemIndex:=0;
     end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.FormKeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
var findTareCode:Integer;
begin
    if Key=13 then
    begin
      if (ActiveControl=EditGoodsCode) then EditGoodsCodeExit(EditGoodsCode);
      if (ActiveControl=EditGoodsName) then EditGoodsNameExit(EditGoodsName);

      if (ActiveControl=EditGoodsCode)and(CDS.RecordCount=1)
      then if CDS.FieldByName('MeasureId').AsInteger = zc_Measure_Sh
           then ActiveControl:=EditWeightValue
           else ActiveControl:=EditGoodsKindCode
      else
      if ActiveControl=EditWeightValue
      then ActiveControl:=EditGoodsKindCode
      else if (ActiveControl=EditGoodsCode)
           then ActiveControl:=EditGoodsName
           else if (ActiveControl=EditGoodsName)and(CDS.RecordCount=1)
                then if CDS.FieldByName('MeasureId').AsInteger = zc_Measure_Sh
                     then ActiveControl:=EditWeightValue
                     else ActiveControl:=EditGoodsKindCode

                else if (ActiveControl=EditGoodsName)
                then ActiveControl:=EditGoodsCode
                else if (ActiveControl=DBGrid)and(CDS.RecordCount>0)
                     then DBGridDblClick(DBGrid)

      else if ActiveControl=EditGoodsKindCode then ActiveControl:=EditTareCount
           else if ActiveControl=EditTareCount then ActiveControl:=EditTareWeightCode
                else if ActiveControl=EditTareWeightCode then if (rgTareWeight.ItemIndex=rgTareWeight.Items.Count-1)and(gbTareWeightEnter.Visible)
                                                        then ActiveControl:=EditTareWeightEnter
                                                        else ActiveControl:=EditChangePercentCode
                     else if ActiveControl=EditTareWeightEnter then ActiveControl:=EditChangePercentCode
                          else if ActiveControl=EditChangePercentCode then ButtonSaveAllItemClick(Self) //ActiveControl:=EditPriceListCode
                               else if ActiveControl=EditPriceListCode then ButtonSaveAllItemClick(Self);
    end;
    //
    {if Key=32 then
      if ActiveControl=EditGoodsCode then ActiveControl:=EditGoodsName
      else if ActiveControl=EditGoodsName then ActiveControl:=EditGoodsCode;}
    //
    if Key=27 then Close;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.CDSFilterRecord(DataSet: TDataSet;var Accept: Boolean);
//var
//   KindPackageId:Integer;
begin
//     try KindPackageId:=ParamsKindPackage.Items[StrToInt(EditKindPackageCode.Text)-1].AsInteger except KindPackageId:=0;end;
     //
     if fEnterGoodsCode then
       if  (EditGoodsCode.Text=DataSet.FieldByName('GoodsCode').AsString)
//        and((KindPackageId=0)or(KindPackageId=DataSet.FieldByName('KindPackageId').AsInteger))
       then Accept:=true else Accept:=false;
     //
     if fEnterGoodsName then
       if  (pos(AnsiUpperCase(EditGoodsName.Text),AnsiUpperCase(DataSet.FieldByName('GoodsName').AsString))>0)
//        and((KindPackageId=0)or(KindPackageId=DataSet.FieldByName('KindPackageId').AsInteger))
       then Accept:=true else Accept:=false;
end;
{------------------------------------------------------------------------------}
function TGuideGoodsForm.Checked: boolean; //Проверка корректного ввода в Edit
begin
     Result:=(CDS.RecordCount=1)
          and(rgGoodsKind.ItemIndex>=0)
          and(rgTareWeight.ItemIndex>=0)
          and(rgChangePercent.ItemIndex>=0)
          and(rgPriceList.ItemIndex>=0)
          and(ParamsMI.ParamByName('RealWeight').AsFloat>0.0001)
          ;

     //
     if not Result
     then ActiveControl:=EditGoodsCode
     else
     with ParamsMI do begin
        ParamByName('GoodsId').AsInteger:=CDS.FieldByName('GoodsId').AsInteger;
        ParamByName('GoodsKindId').AsInteger:= GoodsKind_Array[GetArrayList_gpIndex_GoodsKind(GoodsKind_Array,ParamsMovement.ParamByName('GoodsKindWeighingGroupId').AsInteger,rgGoodsKind.ItemIndex)].Id;

        // Количество тары
        try ParamByName('CountTare').AsFloat:=StrToFloat(EditTareCount.Text);
        except ParamByName('CountTare').AsFloat:=0;
        end;
        // Вес 1-ой тары
        if  (GetArrayList_Value_byName(Default_Array,'isTareWeightEnter')=AnsiUpperCase('TRUE'))
         and(gbTareWeightEnter.Visible)
         and(rgTareWeight.ItemIndex = rgTareWeight.Items.Count-1)
        then begin
            try ParamByName('WeightTare').AsFloat:=StrToFloat(EditTareWeightEnter.Text);
            except ParamByName('WeightTare').AsFloat:=0;
            end;
            //change Количество тары
            if (ParamByName('WeightTare').AsFloat<>0) and (ParamByName('CountTare').AsFloat=0)
            then ParamByName('CountTare').AsFloat:=1;
        end
        else
            try ParamByName('WeightTare').AsFloat:=StrToFloat(TareWeight_Array[rgTareWeight.ItemIndex].Value);
            except ParamByName('WeightTare').AsFloat:=0;
            end;
       // % скидки для кол-ва
       try ParamByName('ChangePercentAmount').AsFloat:=StrToFloat(ChangePercent_Array[rgChangePercent.ItemIndex].Value);
       except ParamByName('ChangePercentAmount').AsFloat:=0;
       end;

       //ПРОВЕРКА - Количество (склад) с учетом тары
       Result:=(ParamByName('RealWeight').AsFloat-ParamByName('CountTare').AsFloat*ParamByName('WeightTare').AsFloat)>0;
       if not Result then
       begin
            ShowMessage('Ошибка.Количество за минусом тары не может быть меньше 0.');
            exit;
       end;
     end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditGoodsCodeChange(Sender: TObject);
begin
     if fEnterGoodsCode then
       with CDS do begin
           Filtered:=false;
           if trim(EditGoodsCode.Text)<>'' then Filtered:=true;
       end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditGoodsCodeEnter(Sender: TObject);
begin TEdit(Sender).SelectAll;end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditGoodsCodeExit(Sender: TObject);
var Code_begin:Integer;
begin
      if fStartWtrite=true then exit;

     {try Code_begin:=StrToInt(EditGoodsCode.Text) except Code_begin:=0;end;
     if (GoodsWeight<0.0001)//and(not((GoodsCode>=_CodeStartGoods_onEnterWeight)and(GoodsCode<=_CodeEndGoods_onEnterWeight)))
     then ActiveControl:=EditGoodsCode;
     else
         if (ActiveControl<>EditGoodsName)and((Code_begin<=0)or(Code_begin<>CDS.FieldByName('GoodsCode').AsInteger))
         then ActiveControl:=EditGoodsCode;}
     //
     if (CDS.Filtered=false)and(Length(trim(EditGoodsCode.Text))>0)
     then begin fEnterGoodsCode:=true;CDS.Filtered:=true;end;

     if CDS.RecordCount=0 then ActiveControl:=EditGoodsCode
     else fEnterGoodsCode:=false;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditGoodsCodeKeyDown(Sender: TObject;var Key: Word; Shift: TShiftState);
begin
     if(Key<>32)and(Key<>27)and(Key<>13)then begin fEnterGoodsCode:=true;fEnterGoodsName:=false;EditGoodsName.Text:='';end
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditGoodsCodeKeyPress(Sender: TObject;var Key: Char);
begin if(Key=' ')or(Key='+')then Key:=#0;end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditGoodsNameChange(Sender: TObject);
var Code_begin:String;
begin
     if fEnterGoodsName then
       with CDS do begin
           Code_begin:= FieldByName('GoodsCode').AsString;
           Filtered:=false;
           if trim(EditGoodsName.Text)<>'' then Filtered:=true;
           if Code_begin <> '' then Locate('GoodsCode',Code_begin,[loCaseInsensitive,loPartialKey]);
       end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditGoodsNameEnter(Sender: TObject);
var Code_begin:String;
begin
  TEdit(Sender).SelectAll;
  CDS.Filtered:=false;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditGoodsNameExit(Sender: TObject);
var Code_begin:Integer;
begin
     if fStartWtrite=true then exit;

     {Code_begin:=CDS.FieldByName('GoodsCode').AsInteger;
     //
     if (GoodsWeight<0.0001)//and(not((GoodsCode>=_CodeStartGoods_onEnterWeight)and(GoodsCode<=_CodeEndGoods_onEnterWeight)))
     then ActiveControl:=EditGoodsCode;
     else
        if (Code_begin<=0)and(CDS.RecordCount<=1) then ActiveControl:=EditGoodsName
        else if (Code_begin>0)and(CDS.RecordCount=1) then EditGoodsCode.Text:=IntToStr(Code_begin);}

     if (CDS.Filtered=false)and(Length(trim(EditGoodsName.Text))>0)
     then begin fEnterGoodsName:=true;CDS.Filtered:=true;end;

     if CDS.RecordCount=0 then ActiveControl:=EditGoodsName
     else fEnterGoodsName:=false;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditGoodsNameKeyDown(Sender: TObject;var Key: Word; Shift: TShiftState);
begin
     if(Key<>27)and(Key<>13)then begin fEnterGoodsCode:=false;fEnterGoodsName:=true;EditGoodsCode.Text:='';end
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditGoodsNameKeyPress(Sender: TObject; var Key: Char);
begin if(Key='+')then Key:=#0;end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditWeightValueExit(Sender: TObject);
begin
     if CDS.FieldByName('MeasureId').AsInteger <> zc_Measure_Sh
     then exit;

     try StrToFloat(EditWeightValue.Text)
     except ActiveControl:=EditWeightValue;
            exit;
     end;
     if StrToFloat(EditWeightValue.Text)<=0
     then ActiveControl:=EditWeightValue
     else if CDS.RecordCount=1
          then try ParamsMI.ParamByName('RealWeight').AsFloat:=StrToFloat(EditWeightValue.Text);
          except ParamsMI.ParamByName('RealWeight').AsFloat:=0;end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditWeightValueKeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
begin
    if Key=13 then ActiveControl:=EditGoodsKindCode;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditGoodsKindCodeChange(Sender: TObject);
var Code_begin:Integer;
begin
     try Code_begin:=StrToInt(EditGoodsKindCode.Text) except Code_begin:=-1;end;
     if (Code_begin<=0)
     then rgGoodsKind.ItemIndex:=-1
     else rgGoodsKind.ItemIndex:=GetArrayList_lpIndex_GoodsKind(GoodsKind_Array,ParamsMovement.ParamByName('GoodsKindWeighingGroupId').AsInteger,Code_begin);
     //
//     if EditGoodsCode.Text<>''then fEnterGoodsCode:=true else if EditGoodsName.Text<>''then fEnterGoodsName:=true;
//     with Query do
//        if (EditGoodsCode.Text='')and(EditGoodsName.Text='') then Filtered:=false else Filtered:=true;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditGoodsKindCodeExit(Sender: TObject);
begin
      if (fStartWtrite=true)or(ActiveControl=EditGoodsCode) then exit;

      if (rgGoodsKind.ItemIndex=-1)then begin ShowMessage('Ошибка.Не определено значение <Код вида упаковки>.');ActiveControl:=EditGoodsKindCode;end
      else
        if CDS.RecordCount<>1 then
        begin
             ShowMessage('Ошибка.Не выбран <Код товара>.');
             ActiveControl:=EditGoodsCode;
        end
        else if ParamsMI.ParamByName('RealWeight').AsFloat<=0.0001
             then
                  if CDS.FieldByName('MeasureId').AsInteger = zc_Measure_Sh
                  then begin ShowMessage('Ошибка.Не определено значение <Ввод КОЛИЧЕСТВО>.');ActiveControl:=EditWeightValue;end
                  else begin ShowMessage('Ошибка.Не определено значение <Вес на Табло>.');ActiveControl:=EditGoodsCode;end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditGoodsKindCodeKeyPress(Sender: TObject;var Key: Char);
var findIndex:Integer;
begin
     if Key=' ' then Key:=#0;
     if Key='+' then
     begin
          Key:=#0;

          if (rgGoodsKind.ItemIndex = rgGoodsKind.Items.Count-1)or(rgGoodsKind.ItemIndex = -1)
          then findIndex:=GetArrayList_gpIndex_GoodsKind(GoodsKind_Array,ParamsMovement.ParamByName('GoodsKindWeighingGroupId').AsInteger,-1)
          else findIndex:=1+GetArrayList_gpIndex_GoodsKind(GoodsKind_Array,ParamsMovement.ParamByName('GoodsKindWeighingGroupId').AsInteger,rgGoodsKind.ItemIndex);
          //
          EditGoodsKindCode.Text:=IntToStr(GoodsKind_Array[findIndex].Code);
          TEdit(Sender).SelectAll;
     end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.rgGoodsKindClick(Sender: TObject);
var findIndex:Integer;
begin
    findIndex:=GetArrayList_gpIndex_GoodsKind(GoodsKind_Array,ParamsMovement.ParamByName('GoodsKindWeighingGroupId').AsInteger,rgGoodsKind.ItemIndex);
    EditGoodsKindCode.Text:=IntToStr(GoodsKind_Array[findIndex].Code);
    ActiveControl:=EditGoodsKindCode;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditTareCountEnter(Sender: TObject);
var Key:Word;
begin
      TEdit(Sender).SelectAll;
      Key:=13;
      //
      //if (ActiveControl=EditTareCount)and(GBUpak.Visible)
      //then begin
      //          PanelUpak.Caption:=GetStringValue('select zf_MyRound0(zf_CalcDivisionNoRound('+FormatToFloatServer(GoodsWeight)+',GoodsProperty_Detail.Ves_onUpakovka))as RetV from dba.GoodsProperty join dba.KindPackage on KindPackage.KindPackageCode = '+trim(EditKindPackageCode.Text)+' join dba.GoodsProperty_Detail on GoodsProperty_Detail.GoodsPropertyId=GoodsProperty.Id and GoodsProperty_Detail.KindPackageID=KindPackage.Id where GoodsProperty.GoodsCode = '+trim(EditGoodsCode.Text));
      //end;
      //
      if (ActiveControl=EditGoodsKindCode)
      then begin
           if CDS.FieldByName('ChangePercent').AsFloat=0
           then EditChangePercentCode.Text:= IntToStr(ChangePercent_Array[GetArrayList_Index_byValue(ChangePercent_Array,FloatToStr(CDS.FieldByName('ChangePercent').AsFloat))].Code)
           else EditChangePercentCode.Text:= IntToStr(ChangePercent_Array[GetArrayList_Index_byValue(ChangePercent_Array,ParamsMovement.ParamByName('ChangePercent').AsString)].Code);
           ActiveControl:=EditGoodsKindCode;
      end;

      if (ActiveControl=EditGoodsKindCode)and(rgGoodsKind.ItemIndex>=0)and(rgGoodsKind.Items.Count=1)then begin rgGoodsKind.ItemIndex:=0;FormKeyDown(Sender,Key,[]);end;
      if (ActiveControl=EditTareCount)and(CDS.FieldByName('MeasureId').AsInteger = zc_Measure_Sh)then begin EditTareCount.Text:='0';FormKeyDown(Sender,Key,[]);end;
      if (ActiveControl=EditTareWeightCode)and(CDS.FieldByName('MeasureId').AsInteger = zc_Measure_Sh)then begin FormKeyDown(Sender,Key,[]);end;
      if (ActiveControl=EditTareWeightEnter)and(CDS.FieldByName('MeasureId').AsInteger = zc_Measure_Sh)then begin FormKeyDown(Sender,Key,[]);end;
      if (ActiveControl=EditChangePercentCode)then begin FormKeyDown(Sender,Key,[]);end;
      if (ActiveControl=EditPriceListCode){and(rgPriceList.ItemIndex>=0)and(rgPriceList.Items.Count=1)}then FormKeyDown(Sender,Key,[]);
      //
      if (ActiveControl=EditTareWeightEnter)and(rgTareWeight.ItemIndex<>rgTareWeight.Items.Count-1)
      then FormKeyDown(Sender,Key,[]);
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditTareCountExit(Sender: TObject);
var TareCount:Integer;
begin
     if fStartWtrite=true then exit;

     try TareCount:=StrToInt(trim(EditTareCount.Text));except TareCount:=0;end;
     //
     if (TareCount>Length(TareCount_Array))
     then ActiveControl:=EditTareCount;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditTareCountKeyPress(Sender: TObject;var Key: Char);
var Code_begin:Integer;
begin
     if Key=' ' then Key:=#0;
     if Key='+' then
     begin
          Key:=#0;
          //
          try Code_begin:=StrToInt(trim(EditTareCount.Text));except Code_begin:=0;end;
          //
          if Code_begin>=Length(TareCount_Array) then EditTareCount.Text:= '0' else EditTareCount.Text:= IntToStr(Code_begin+1);
          //
          TEdit(Sender).SelectAll;
     end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditTareWeightCodeChange(Sender: TObject);
var Code_begin:Integer;
begin
     try Code_begin:=StrToInt(EditTareWeightCode.Text) except Code_begin:=-1;end;
     if (Code_begin<0)
     then rgTareWeight.ItemIndex:=-1
     else rgTareWeight.ItemIndex:=GetArrayList_Index_byCode(TareWeight_Array,Code_begin);
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditTareWeightCodeExit(Sender: TObject);
begin
     if fStartWtrite=true then exit;

     if rgTareWeight.ItemIndex=-1 then ActiveControl:=EditTareWeightCode;
     if (rgTareWeight.ItemIndex <> rgTareWeight.Items.Count-1)and(gbTareWeightEnter.Visible)
     then EditTareWeightEnter.Text:='';
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditTareWeightCodeKeyPress(Sender: TObject;var Key: Char);
var findIndex:Integer;
begin
     if Key=' ' then Key:=#0;
     if Key='+' then
     begin
          Key:=#0;
          //
          if (rgTareWeight.ItemIndex = rgTareWeight.Items.Count-1)or(rgTareWeight.ItemIndex = -1)
          then findIndex:=0
          else findIndex:=1+rgTareWeight.ItemIndex;
          //
          EditTareWeightCode.Text:=IntToStr(TareWeight_Array[findIndex].Code);
          TEdit(Sender).SelectAll;
     end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.rgTareWeightClick(Sender: TObject);
begin
    EditTareWeightCode.Text:=IntToStr(TareWeight_Array[rgTareWeight.ItemIndex].Code);
    ActiveControl:=EditTareWeightCode;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditTareWeightEnterExit(Sender: TObject);
var TareWeight:Double;
begin
     if fStartWtrite=true then exit;

     if trim (EditTareWeightEnter.Text)='' then EditTareWeightEnter.Text:='0';
     //
     try TareWeight:=StrToFloat(trim(EditTareWeightEnter.Text));except TareWeight:=-1;end;
     //
     if TareWeight<0
     then ActiveControl:=EditTareWeightEnter;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditChangePercentCodeChange(Sender: TObject);
var Code_begin:Integer;
begin
     try Code_begin:=StrToInt(EditChangePercentCode.Text) except Code_begin:=-1;end;
     if (Code_begin<0)
     then rgChangePercent.ItemIndex:=-1
     else rgChangePercent.ItemIndex:=GetArrayList_Index_byCode(ChangePercent_Array,Code_begin);
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditChangePercentCodeExit(Sender: TObject);
begin
     if fStartWtrite=true then exit;

     if rgChangePercent.ItemIndex=-1 then ActiveControl:=EditChangePercentCode;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditChangePercentCodeKeyPress(Sender: TObject;var Key: Char);
var findIndex:Integer;
begin
     if Key=' ' then Key:=#0;
     if Key='+' then
     begin
          Key:=#0;
          //
          if (rgChangePercent.ItemIndex = rgChangePercent.Items.Count-1)or(rgChangePercent.ItemIndex = -1)
          then findIndex:=0
          else findIndex:=1+rgChangePercent.ItemIndex;
          //
          EditChangePercentCode.Text:=IntToStr(ChangePercent_Array[findIndex].Code);
          TEdit(Sender).SelectAll;
     end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.rgChangePercentClick(Sender: TObject);
var newValue:String;
begin
    EditChangePercentCodeChange(EditChangePercentCode);
    // ActiveControl:=EditGoodsCode;
    {newValue:=IntToStr(ChangePercent_Array[rgChangePercent.ItemIndex].Code);
    if newValue<>EditChangePercentCode.Text
    then begin
              EditChangePercentCode.Text:=newValue;
              ActiveControl:=EditChangePercentCode;
    end;}

end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditPriceListCodeChange(Sender: TObject);
var Code_begin:Integer;
begin
{     try Code_begin:=StrToInt(EditPriceListCode.Text) except Code_begin:=-1;end;
     if (Code_begin<0)
     then rgPriceList.ItemIndex:=-1
     else rgPriceList.ItemIndex:=1;//GetArrayList_Index_byCode(PriceList_Array,Code_begin);
     }
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditPriceListCodeExit(Sender: TObject);
begin
     if fStartWtrite=true then exit;
     {if rgPriceList.ItemIndex=-1 then ActiveControl:=EditPriceListCode;}
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.EditPriceListCodeKeyPress(Sender: TObject;var Key: Char);
var findIndex:Integer;
begin
     {if Key=' ' then Key:=#0;
     if Key='+' then
     begin
          Key:=#0;
          //
          if (rgPriceList.ItemIndex = rgPriceList.Items.Count-1)or(rgPriceList.ItemIndex = -1)
          then findIndex:=0
          else findIndex:=1+rgPriceList.ItemIndex;
          //
          EditPriceListCode.Text:=IntToStr(PriceList_Array[findIndex].Code);
          TEdit(Sender).SelectAll;
     end;}
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.rgPriceListClick(Sender: TObject);
begin
    {EditPriceListCodeChange(EditPriceListCode);}
    if ActiveControl=rgPriceList then ActiveControl:=EditGoodsCode;
    {EditPriceListCode.Text:=IntToStr(PriceList_Array[rgPriceList.ItemIndex].Code);
    ActiveControl:=EditPriceListCode;}
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.DataSourceDataChange(Sender: TObject; Field: TField);
begin
     with ParamsMI do begin
        if CDS.RecordCount=1 then
         if CDS.FieldByName('MeasureId').AsInteger = zc_Measure_Sh
         then try ParamByName('RealWeight').AsFloat:=StrToFloat(EditWeightValue.Text); except ParamByName('RealWeight').AsFloat:=0;end
         else ParamByName('RealWeight').AsFloat:=ParamByName('RealWeight_Get').AsFloat
        else
            ParamByName('RealWeight').AsFloat:=0;
     end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.DBGridDblClick(Sender: TObject);
begin
     EditGoodsCode.Text:=CDS.FieldByName('GoodsCode').AsString;
     fEnterGoodsCode:=true;
     EditGoodsCodeChange(EditGoodsCode);
     //
     if CDS.FieldByName('MeasureId').AsInteger = zc_Measure_Sh
     then ActiveControl:=EditWeightValue
     else ActiveControl:=EditGoodsKindCode;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.ButtonRefreshClick(Sender: TObject);
var GoodsCode:String;
begin
    with spSelect do begin
        GoodsCode:= DataSet.FieldByName('GoodsCode').AsString;
        Execute;
        if GoodsCode <> '' then
          DataSet.Locate('GoodsCode',GoodsCode,[loCaseInsensitive]);
    end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.ButtonSaveAllItemClick(Sender: TObject);
begin
     if Checked then ModalResult:=mrOK;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.ButtonExitClick(Sender: TObject);
begin Close end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsForm.FormCreate(Sender: TObject);
var i:Integer;
begin
  fEnterGoodsCode:=false;
  fEnterGoodsName:=false;
  fStartWtrite:=true;

  //вес тары (ручной режим)
  gbTareWeightEnter.Visible:=GetArrayList_Value_byName(Default_Array,'isTareWeightEnter')=AnsiUpperCase('TRUE');
  //вес тары
  for i := 0 to Length(TareWeight_Array)-1 do
    if TareWeight_Array[i].Number>=1000
    then rgTareWeight.Items.Add('('+IntToStr(0)+') '+ TareWeight_Array[i].Name)
    else rgTareWeight.Items.Add('('+IntToStr(TareWeight_Array[i].Code)+') '+ TareWeight_Array[i].Name);
  //Скидка по весу
  for i := 0 to Length(ChangePercent_Array)-1 do
    rgChangePercent.Items.Add('('+IntToStr(ChangePercent_Array[i].Code)+') '+ ChangePercent_Array[i].Name);
  //прайс-лист
  {for i := 0 to Length(PriceList_Array)-1 do
    rgPriceList.Items.Add('('+IntToStr(PriceList_Array[i].Code)+') '+ PriceList_Array[i].Name);}

  with spSelect do
  begin
       StoredProcName:='gpSelect_Scale_Goods';
       OutputType:=otDataSet;
       Params.AddParam('inOperDate', ftDateTime, ptInput, ParamsMovement.ParamByName('OperDate').AsDateTime);
       Params.AddParam('inOrderExternalId', ftInteger, ptInput, 0);
       Params.AddParam('inPriceListId', ftInteger, ptInput, 0);
       Params.AddParam('inInfoMoneyId', ftInteger, ptInput, 0);
       Params.AddParam('inDayPrior_PriceReturn', ftInteger, ptInput,GetArrayList_Value_byName(Default_Array,'DayPrior_PriceReturn'));
       Execute;
  end;
  //
{
     // PriceList
     if _isCalcPriceList=zc_rvYes
     then begin
            rgKindPackage.Columns:=2;
            rgPriceList.Columns:=1;
            PriceListPanel.Width:=PriceListPanel.Width-100;
            EditPriceListCode.Width:=EditPriceListCode.Width-100;
            KindPackagePanel.Width:=KindPackagePanel.Width+100;
            rgPriceList.Items.Add('(1) '+_PriceListName_byCalc_new);
            rgPriceList.Items.Add('(2) '+_PriceListName_byCalc_old);
          end
     else
         for i:=0 to ParamsPriceList.Count-1 do
            rgPriceList.Items.Add('('+IntToStr(i+1)+') '+GetStringValue('select PriceListName AS RetV from dba.PriceList_byHistory where Id = '+ParamsPriceList.Items[i].AsString));
}
end;
procedure TGuideGoodsForm.FormDestroy(Sender: TObject);
begin
  ParamsMI.Free;
end;

{------------------------------------------------------------------------------}
end.
