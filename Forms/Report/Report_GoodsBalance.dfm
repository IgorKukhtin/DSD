object Report_GoodsBalanceForm: TReport_GoodsBalanceForm
  Left = 0
  Top = 0
  Caption = #1054#1090#1095#1077#1090' <'#1054#1089#1090#1072#1090#1082#1080' '#1087#1086' '#1090#1086#1074#1072#1088#1072#1084'>'
  ClientHeight = 670
  ClientWidth = 1344
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = actRefresh
  AddOnFormData.isSingle = False
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid: TcxGrid
    Left = 0
    Top = 80
    Width = 1344
    Height = 590
    Align = alClient
    TabOrder = 0
    object cxGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = MasterDS
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Filter.Active = True
      DataController.Summary.DefaultGroupSummaryItems = <
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountStart
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SummStart
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountEnd
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SummEnd
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountEnd_calc
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountOut_calc
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountIn_calc
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountOut
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountIn
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountReal
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountIn_sh
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountIn_Weight
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountOut_sh
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountOut_Weight
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountIn_sh_calc
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountIn_Weight_calc
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountOut_sh_calc
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountOut_Weight_calc
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountEnd_sh_calc
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountEnd_Weight_calc
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountReal_sh
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountReal_Weight
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountStart_sh
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountStart_Weight
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountEnd_sh
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountEnd_Weight
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Count_byCount
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Count_onCount
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountStart_byCount
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountEnd_byCount
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SummReal
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SummIn
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SummOut
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SummPriceListStart
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SummPriceListEnd
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountIn_Weight_gp
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountLoss_sh
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountLoss_Weight
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SummLoss
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountInventory_sh
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountInventory_Weight
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SummInventory
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SummInventory_RePrice
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountIn_Weight_end_gp
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountOut_norm_pf
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountIn_Weight_norm_gp
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountOut_byPF
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CuterCount
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountIn_byPF
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SummInventory_Basis
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Count_onCount_in
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Count_onCount_out
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountInventory_byCount
        end>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountStart
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SummStart
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountEnd
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SummEnd
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountEnd_calc
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountOut_calc
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountIn_calc
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountOut
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountIn
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountReal
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountIn_sh
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountIn_Weight
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountOut_sh
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountOut_Weight
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountIn_sh_calc
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountIn_Weight_calc
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountOut_sh_calc
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountOut_Weight_calc
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountEnd_sh_calc
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountEnd_Weight_calc
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountReal_sh
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountReal_Weight
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountStart_sh
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountStart_Weight
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountEnd_sh
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountEnd_Weight
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Count_byCount
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Count_onCount
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountStart_byCount
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountEnd_byCount
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SummReal
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SummIn
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SummOut
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SummPriceListStart
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SummPriceListEnd
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountIn_Weight_gp
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountLoss_sh
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountLoss_Weight
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SummLoss
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountInventory_sh
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountInventory_Weight
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SummInventory
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SummInventory_RePrice
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountIn_Weight_end_gp
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountOut_norm_pf
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountIn_Weight_norm_gp
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountOut_byPF
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CuterCount
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountIn_byPF
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SummInventory_Basis
        end
        item
          Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
          Kind = skCount
          Column = GoodsName
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Count_onCount_in
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Count_onCount_out
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountInventory_byCount
        end>
      DataController.Summary.SummaryGroups = <>
      Images = dmMain.SortImageList
      OptionsBehavior.GoToNextCellOnEnter = True
      OptionsBehavior.FocusCellOnCycle = True
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsCustomize.DataRowSizing = True
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsView.Footer = True
      OptionsView.GroupSummaryLayout = gslAlignWithColumns
      OptionsView.HeaderAutoHeight = True
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object AccountCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1089#1095'.'
        DataBinding.FieldName = 'AccountCode'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 50
      end
      object AccountName_All: TcxGridDBColumn
        Caption = #1057#1095#1077#1090
        DataBinding.FieldName = 'AccountName_All'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object LocationDescName: TcxGridDBColumn
        Caption = #1042#1080#1076' '#1084#1077#1089#1090#1072' '#1091#1095#1077#1090#1072
        DataBinding.FieldName = 'LocationDescName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object LocationCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1084#1077#1089#1090#1072' '#1091#1095'.'
        DataBinding.FieldName = 'LocationCode'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 45
      end
      object LocationName: TcxGridDBColumn
        Caption = #1052#1077#1089#1090#1086' '#1091#1095#1077#1090#1072
        DataBinding.FieldName = 'LocationName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object UnitName_to: TcxGridDBColumn
        Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1080#1085#1092'.)'
        DataBinding.FieldName = 'UnitName_to'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' - '#1080#1085#1092#1086#1088#1084#1072#1090#1080#1074#1085#1086
        Options.Editing = False
        Width = 80
      end
      object DriverName: TcxGridDBColumn
        Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082' ('#1074#1086#1076#1080#1090#1077#1083#1100')'
        DataBinding.FieldName = 'DriverName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1057#1086#1090#1088#1091#1076#1085#1080#1082' ('#1074#1086#1076#1080#1090#1077#1083#1100') - '#1080#1085#1092#1086#1088#1084#1072#1090#1080#1074#1085#1086
        Options.Editing = False
        Width = 70
      end
      object GoodsGroupNameFull: TcxGridDBColumn
        Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072' ('#1074#1089#1077')'
        DataBinding.FieldName = 'GoodsGroupNameFull'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 200
      end
      object GoodsGroupName: TcxGridDBColumn
        Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072
        DataBinding.FieldName = 'GoodsGroupName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object BarCode_Main: TcxGridDBColumn
        Caption = #1064#1090#1088#1080#1093' '#1082#1086#1076
        DataBinding.FieldName = 'BarCode_Main'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object GoodsCode: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'GoodsCode'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object GoodsName: TcxGridDBColumn
        Caption = #1058#1086#1074#1072#1088
        DataBinding.FieldName = 'GoodsName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 150
      end
      object GoodsKindName: TcxGridDBColumn
        Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
        DataBinding.FieldName = 'GoodsKindName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object GoodsKindName_complete: TcxGridDBColumn
        Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' ('#1043#1055')'
        DataBinding.FieldName = 'GoodsKindName_complete'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object GoodsCode_basis: TcxGridDBColumn
        Caption = #1050#1086#1076' ('#1094#1077#1093')'
        DataBinding.FieldName = 'GoodsCode_basis'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object GoodsName_basis: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077' ('#1094#1077#1093')'
        DataBinding.FieldName = 'GoodsName_basis'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 120
      end
      object GoodsCode_main: TcxGridDBColumn
        Caption = #1050#1086#1076' ('#1085#1072' '#1091#1087#1072#1082'.)'
        DataBinding.FieldName = 'GoodsCode_main'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object GoodsName_main: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077' ('#1085#1072' '#1091#1087#1072#1082'.)'
        DataBinding.FieldName = 'GoodsName_main'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 120
      end
      object Name_Scale: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077' (Scale)'
        DataBinding.FieldName = 'Name_Scale'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object PartionGoodsDate: TcxGridDBColumn
        Caption = #1055#1072#1088#1090#1080#1103' ('#1076#1072#1090#1072')'
        DataBinding.FieldName = 'PartionGoodsDate'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 60
      end
      object PartionGoodsName: TcxGridDBColumn
        Caption = #1055#1072#1088#1090#1080#1103
        DataBinding.FieldName = 'PartionGoodsName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 150
      end
      object StorageName: TcxGridDBColumn
        Caption = #1052#1077#1089#1090#1086' '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1087#1072#1088#1090#1080#1103')'
        DataBinding.FieldName = 'StorageName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 40
      end
      object Unit_Partion: TcxGridDBColumn
        Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1087#1072#1088#1090#1080#1103' '#1087#1088#1080#1093#1086#1076#1072')'
        DataBinding.FieldName = 'Unit_Partion'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 40
      end
      object PartionModelName: TcxGridDBColumn
        Caption = #1052#1086#1076#1077#1083#1100' ('#1087#1072#1088#1090#1080#1103' '#1087#1088#1080#1093#1086#1076#1072')'
        DataBinding.FieldName = 'PartionModelName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 40
      end
      object BranchName_Partion: TcxGridDBColumn
        Caption = #1060#1080#1083#1080#1072#1083' ('#1087#1072#1088#1090#1080#1103' '#1087#1088#1080#1093#1086#1076#1072')'
        DataBinding.FieldName = 'BranchName_Partion'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 40
      end
      object PartNumber_Partion: TcxGridDBColumn
        Caption = #1057#1077#1088#1080#1081#1085#1099#1081' '#1085#1086#1084#1077#1088' ('#8470' '#1087#1086' '#1090#1077#1093' '#1087#1072#1089#1087#1086#1088#1090#1091')'
        DataBinding.FieldName = 'PartNumber_Partion'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 40
      end
      object MeasureName: TcxGridDBColumn
        Caption = #1045#1076'. '#1080#1079#1084'.'
        DataBinding.FieldName = 'MeasureName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 35
      end
      object WeightTare: TcxGridDBColumn
        Caption = #1042#1077#1089' '#1074#1090#1091#1083#1082#1080
        DataBinding.FieldName = 'WeightTare'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 72
      end
      object InDate: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' '#1087#1088'. '#1086#1090' '#1087#1086#1089#1090'. '
        DataBinding.FieldName = 'InDate'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1044#1072#1090#1072' '#1087#1086#1089#1083#1077#1076#1085#1077#1075#1086' '#1087#1088#1080#1093#1086#1076#1072' '#1086#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
        Options.Editing = False
        Width = 80
      end
      object PartnerInName: TcxGridDBColumn
        Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
        DataBinding.FieldName = 'PartnerInName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1055#1086#1089#1090#1072#1074#1097#1080#1082' '#1087#1086#1089#1083#1077#1076#1085#1077#1075#1086' '#1087#1088#1080#1093#1086#1076#1072
        Options.Editing = False
        Width = 80
      end
      object isReprice: TcxGridDBColumn
        Caption = #1055#1077#1088#1077#1086#1094#1077#1085#1082#1072
        DataBinding.FieldName = 'isReprice'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object CountStart: TcxGridDBColumn
        Caption = #1054#1089#1090'. '#1085#1072#1095'. '#1082#1086#1083'.'
        DataBinding.FieldName = 'CountStart'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        VisibleForCustomization = False
        Width = 80
      end
      object CountStart_sh: TcxGridDBColumn
        Caption = #1054#1089#1090'. '#1085#1072#1095'. '#1096#1090'.'
        DataBinding.FieldName = 'CountStart_sh'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object CountStart_Weight: TcxGridDBColumn
        Caption = #1054#1089#1090'. '#1085#1072#1095'. '#1074#1077#1089
        DataBinding.FieldName = 'CountStart_Weight'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object PriceStart: TcxGridDBColumn
        Caption = #1086#1089#1090'. '#1085#1072#1095'. '#1094'. c/c'
        DataBinding.FieldName = 'PriceStart'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object PriceListStart: TcxGridDBColumn
        Caption = #1086#1089#1090'. '#1085#1072#1095'. '#1094'. '#1087#1088#1072#1081#1089
        DataBinding.FieldName = 'PriceListStart'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object SummStart: TcxGridDBColumn
        Caption = #1054#1089#1090'. '#1085#1072#1095'. '#1089#1091#1084#1084#1072' '#1089'/'#1089
        DataBinding.FieldName = 'SummStart'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object SummPriceListStart: TcxGridDBColumn
        Caption = #1054#1089#1090'. '#1085#1072#1095'. '#1089#1091#1084#1084#1072' '#1055#1056#1040#1049#1057
        DataBinding.FieldName = 'SummPriceListStart'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object isPriceStart_diff: TcxGridDBColumn
        Caption = #1054#1090#1082#1083'. '#1085#1072#1095'. '#1094'. '#1087#1088#1072#1081#1089
        DataBinding.FieldName = 'isPriceStart_diff'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object CountEnd: TcxGridDBColumn
        Caption = #1054#1089#1090'. '#1082#1086#1085#1077#1095'. '#1082#1086#1083'.'
        DataBinding.FieldName = 'CountEnd'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        VisibleForCustomization = False
        Width = 80
      end
      object CountEnd_sh: TcxGridDBColumn
        Caption = #1054#1089#1090'. '#1082#1086#1085#1077#1095'. '#1096#1090'.'
        DataBinding.FieldName = 'CountEnd_sh'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object CountEnd_Weight: TcxGridDBColumn
        Caption = #1054#1089#1090'. '#1082#1086#1085#1077#1095'. '#1074#1077#1089
        DataBinding.FieldName = 'CountEnd_Weight'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object PriceEnd: TcxGridDBColumn
        Caption = #1086#1089#1090'. '#1082#1086#1085#1077#1095'. '#1094'. c/c'
        DataBinding.FieldName = 'PriceEnd'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 60
      end
      object PriceListEnd: TcxGridDBColumn
        Caption = #1086#1089#1090'. '#1082#1086#1085#1077#1095'. '#1094'. '#1087#1088#1072#1081#1089
        DataBinding.FieldName = 'PriceListEnd'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object SummEnd: TcxGridDBColumn
        Caption = #1054#1089#1090'. '#1082#1086#1085#1077#1095'. '#1089#1091#1084#1084#1072' '#1089'/'#1089
        DataBinding.FieldName = 'SummEnd'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object SummPriceListEnd: TcxGridDBColumn
        Caption = #1054#1089#1090'. '#1082#1086#1085#1077#1095'. '#1089#1091#1084#1084#1072' '#1055#1056#1040#1049#1057
        DataBinding.FieldName = 'SummPriceListEnd'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object isPriceEnd_diff: TcxGridDBColumn
        Caption = #1054#1090#1082#1083'. '#1082#1086#1085#1077#1095'. '#1094'. '#1087#1088#1072#1081#1089
        DataBinding.FieldName = 'isPriceEnd_diff'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 90
      end
      object CountEnd_calc: TcxGridDBColumn
        Caption = #1054#1089#1090'.'#1088#1072#1089#1095'. '#1082#1086#1083'.'
        DataBinding.FieldName = 'CountEnd_calc'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        VisibleForCustomization = False
        Width = 80
      end
      object CountEnd_sh_calc: TcxGridDBColumn
        Caption = #1054#1089#1090'.'#1088#1072#1089#1095'. '#1096#1090'.'
        DataBinding.FieldName = 'CountEnd_sh_calc'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object CountEnd_Weight_calc: TcxGridDBColumn
        Caption = #1054#1089#1090'.'#1088#1072#1089#1095'. '#1074#1077#1089
        DataBinding.FieldName = 'CountEnd_Weight_calc'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object CountIn_calc: TcxGridDBColumn
        Caption = #1055#1088#1080#1093#1086#1076'*** '#1082#1086#1083'.'
        DataBinding.FieldName = 'CountIn_calc'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        VisibleForCustomization = False
        Width = 80
      end
      object CountIn_sh_calc: TcxGridDBColumn
        Caption = #1055#1088#1080#1093#1086#1076'*** '#1096#1090'.'
        DataBinding.FieldName = 'CountIn_sh_calc'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object CountIn_Weight_calc: TcxGridDBColumn
        Caption = #1055#1088#1080#1093#1086#1076'*** '#1074#1077#1089
        DataBinding.FieldName = 'CountIn_Weight_calc'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object CountOut_calc: TcxGridDBColumn
        Caption = #1056#1072#1089#1093#1086#1076'*** '#1082#1086#1083'.'
        DataBinding.FieldName = 'CountOut_calc'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        VisibleForCustomization = False
        Width = 80
      end
      object CountOut_sh_calc: TcxGridDBColumn
        Caption = #1056#1072#1089#1093#1086#1076'*** '#1096#1090'.'
        DataBinding.FieldName = 'CountOut_sh_calc'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object CountOut_Weight_calc: TcxGridDBColumn
        Caption = #1056#1072#1089#1093#1086#1076'*** '#1074#1077#1089
        DataBinding.FieldName = 'CountOut_Weight_calc'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object CountIn: TcxGridDBColumn
        Caption = #1060#1072#1082#1090' '#1087#1088#1080#1093#1086#1076' '#1082#1086#1083'.'
        DataBinding.FieldName = 'CountIn'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        VisibleForCustomization = False
        Width = 90
      end
      object CountIn_sh: TcxGridDBColumn
        Caption = #1060#1072#1082#1090' '#1087#1088#1080#1093#1086#1076' '#1096#1090'.'
        DataBinding.FieldName = 'CountIn_sh'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object CountIn_Weight: TcxGridDBColumn
        Caption = #1060#1072#1082#1090' '#1087#1088#1080#1093#1086#1076' '#1074#1077#1089
        DataBinding.FieldName = 'CountIn_Weight'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object PriceIn: TcxGridDBColumn
        Caption = #1092#1072#1082#1090' '#1087#1088#1080#1093#1086#1076' '#1094'. '#1089'/'#1089
        DataBinding.FieldName = 'PriceIn'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 60
      end
      object SummIn: TcxGridDBColumn
        Caption = #1060#1072#1082#1090' '#1087#1088#1080#1093#1086#1076' '#1089#1091#1084#1084#1072' '#1089'/'#1089
        DataBinding.FieldName = 'SummIn'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object CountOut: TcxGridDBColumn
        Caption = #1060#1072#1082#1090' '#1088#1072#1089#1093#1086#1076' '#1082#1086#1083'.'
        DataBinding.FieldName = 'CountOut'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        VisibleForCustomization = False
        Width = 90
      end
      object CountOut_sh: TcxGridDBColumn
        Caption = #1060#1072#1082#1090' '#1088#1072#1089#1093#1086#1076' '#1096#1090'.'
        DataBinding.FieldName = 'CountOut_sh'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object CountOut_Weight: TcxGridDBColumn
        Caption = #1060#1072#1082#1090' '#1088#1072#1089#1093#1086#1076' '#1074#1077#1089
        DataBinding.FieldName = 'CountOut_Weight'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object PriceOut: TcxGridDBColumn
        Caption = #1092#1072#1082#1090' '#1088#1072#1089#1093#1086#1076' '#1094'. '#1089'/'#1089
        DataBinding.FieldName = 'PriceOut'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 60
      end
      object SummOut: TcxGridDBColumn
        Caption = #1060#1072#1082#1090' '#1088#1072#1089#1093#1086#1076' '#1089#1091#1084#1084#1072' '#1089'/'#1089
        DataBinding.FieldName = 'SummOut'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object CountLoss_sh: TcxGridDBColumn
        Caption = #1057#1087#1080#1089#1072#1085#1080#1077' '#1096#1090'.'
        DataBinding.FieldName = 'CountLoss_sh'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object CountLoss_Weight: TcxGridDBColumn
        Caption = #1057#1087#1080#1089#1072#1085#1080#1077' '#1074#1077#1089
        DataBinding.FieldName = 'CountLoss_Weight'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object PriceLoss: TcxGridDBColumn
        Caption = #1089#1087#1080#1089#1072#1085#1080#1077' '#1094'. '#1089'/'#1089
        DataBinding.FieldName = 'PriceLoss'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object SummLoss: TcxGridDBColumn
        Caption = #1057#1087#1080#1089#1072#1085#1080#1077' '#1089#1091#1084#1084#1072' '#1089'/'#1089
        DataBinding.FieldName = 'SummLoss'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object CountInventory_sh: TcxGridDBColumn
        Caption = #1048#1085#1074#1077#1085#1090'. '#1096#1090'.'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object CountInventory_Weight: TcxGridDBColumn
        Caption = #1048#1085#1074#1077#1085#1090'. '#1074#1077#1089
        DataBinding.FieldName = 'CountInventory_Weight'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object PriceInventory: TcxGridDBColumn
        Caption = #1080#1085#1074#1077#1085#1090'. '#1094'. '#1089'/'#1089
        DataBinding.FieldName = 'PriceInventory'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object SummInventory: TcxGridDBColumn
        Caption = #1048#1085#1074#1077#1085#1090'. '#1089#1091#1084#1084#1072' '#1089'/'#1089
        DataBinding.FieldName = 'SummInventory'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object SummInventory_Basis: TcxGridDBColumn
        Caption = #1057#1091#1084#1084#1072' '#1091#1073#1099#1083#1100' '#1087#1086' '#1094#1077#1085#1072#1084' '#1087#1088#1072#1081#1089#1072
        DataBinding.FieldName = 'SummInventory_Basis'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1057#1091#1084#1084#1072' (-)'#1091#1073#1099#1083#1100' (+)'#1101#1082#1086#1085#1086#1084'. '#1087#1086' '#1094#1077#1085#1072#1084' '#1087#1088#1072#1081#1089#1072
        Options.Editing = False
        Width = 75
      end
      object SummInventory_RePrice: TcxGridDBColumn
        Caption = #1048#1085#1074#1077#1085#1090'. '#1087#1077#1088#1077#1086#1094#1077#1085#1082#1072' '#1089'/'#1089
        DataBinding.FieldName = 'SummInventory_RePrice'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object TaxExit_norm: TcxGridDBColumn
        Caption = '% '#1074#1099#1093' ('#1085#1086#1088#1084'.)'
        DataBinding.FieldName = 'TaxExit_norm'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object TaxExit_norm_real: TcxGridDBColumn
        Caption = '% '#1074#1099#1093' ('#1085#1086#1088#1084'. '#1092#1072#1082#1090')'
        DataBinding.FieldName = 'TaxExit_norm_real'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object TaxExit_real: TcxGridDBColumn
        Caption = '% '#1074#1099#1093' ('#1092#1072#1082#1090')'
        DataBinding.FieldName = 'TaxExit_real'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object CountIn_Weight_end_gp: TcxGridDBColumn
        Caption = #1055#1088#1086#1075#1085#1086#1079' '#1043#1055' '#1074#1077#1089
        DataBinding.FieldName = 'CountIn_Weight_end_gp'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object TermProduction: TcxGridDBColumn
        Caption = #1057#1088#1086#1082' '#1087#1088#1086#1080#1079#1074'. '#1074' '#1076#1085'.'
        DataBinding.FieldName = 'TermProduction'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 60
      end
      object isPartionClose_calc: TcxGridDBColumn
        Caption = #1055#1072#1088#1090'. '#1079'. ('#1076#1072'/'#1085#1077#1090')'
        DataBinding.FieldName = 'isPartionClose_calc'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 60
      end
      object CountOut_norm_pf: TcxGridDBColumn
        Caption = #1085#1086#1088#1084#1072' '#1055#1060' '#1085#1072' '#1043#1055
        DataBinding.FieldName = 'CountOut_norm_pf'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object CountIn_Weight_norm_gp: TcxGridDBColumn
        Caption = #1085#1086#1088#1084#1072' '#1043#1055' '#1085#1072' '#1055#1060
        DataBinding.FieldName = 'CountIn_Weight_norm_gp'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object CountIn_Weight_gp: TcxGridDBColumn
        Caption = #1055#1088#1086#1080#1079#1074'. '#1043#1055' '#1074#1077#1089
        DataBinding.FieldName = 'CountIn_Weight_gp'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object CountOut_byPF: TcxGridDBColumn
        Caption = #1056#1072#1089#1093#1086#1076' '#1055#1060' ('#1043#1055')'
        DataBinding.FieldName = 'CountOut_byPF'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object Value_receipt: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1087#1086' '#1088#1077#1094#1077#1087#1090'.'
        DataBinding.FieldName = 'Value_receipt'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object CuterCount_receipt: TcxGridDBColumn
        Caption = #1050#1091#1090#1077#1088'. '#1087#1086' '#1088#1077#1094#1077#1087#1090'.'
        DataBinding.FieldName = 'CuterCount_receipt'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object CuterCount: TcxGridDBColumn
        Caption = #1055#1088#1080#1093#1086#1076' *** '#1082#1091#1090#1077#1088'.'
        DataBinding.FieldName = 'CuterCount'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object CountIn_byPF: TcxGridDBColumn
        Caption = #1055#1088#1080#1093#1086#1076' *** '#1055#1060' ('#1043#1055')'
        DataBinding.FieldName = 'CountIn_byPF'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object Count_byCount: TcxGridDBColumn
        Caption = #1056#1072#1089#1093#1086#1076' *** '#1055#1060' ('#1043#1055')'
        DataBinding.FieldName = 'Count_byCount'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object Count_onCount: TcxGridDBColumn
        Caption = #1056#1072#1089#1093'. *** '#1073#1072#1090'. '#1055#1060' ('#1043#1055')'
        DataBinding.FieldName = 'Count_onCount'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object Count_onCount_in: TcxGridDBColumn
        Caption = #1055#1088#1080#1093'. *** '#1073#1072#1090'. '#1055#1060' ('#1043#1055') '#1079#1072' '#1087#1077#1088'.'
        DataBinding.FieldName = 'Count_onCount_in'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1055#1088#1080#1093'. *** '#1073#1072#1090'. '#1055#1060' ('#1043#1055') '#1079#1072' '#1087#1077#1088#1080#1086#1076
        Width = 70
      end
      object Count_onCount_out: TcxGridDBColumn
        Caption = #1056#1072#1089#1093'. *** '#1073#1072#1090'. '#1055#1060' ('#1043#1055') '#1079#1072' '#1087#1077#1088'.'
        DataBinding.FieldName = 'Count_onCount_out'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1056#1072#1089#1093'. *** '#1073#1072#1090'. '#1055#1060' ('#1043#1055') '#1079#1072' '#1087#1077#1088#1080#1086#1076
        Width = 70
      end
      object CountStart_byCount: TcxGridDBColumn
        Caption = #1054#1089#1090'. '#1073#1090'. '#1085#1072#1095'. '
        DataBinding.FieldName = 'CountStart_byCount'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object CountInventory_byCount: TcxGridDBColumn
        Caption = #1048#1085#1074#1077#1085#1090'. '#1073#1090'.'
        DataBinding.FieldName = 'CountInventory_byCount'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object CountEnd_byCount: TcxGridDBColumn
        Caption = #1054#1089#1090'. '#1073#1090'. '#1082#1086#1085#1077#1095'.'
        DataBinding.FieldName = 'CountEnd_byCount'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object Weight_byCount: TcxGridDBColumn
        Caption = #1042#1077#1089' 1 '#1073#1090'.'
        DataBinding.FieldName = 'Weight_byCount'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 50
      end
      object CountReal: TcxGridDBColumn
        Caption = #1054#1089#1090'. '#1090#1077#1082'. '#1082#1086#1083'.'
        DataBinding.FieldName = 'CountReal'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        VisibleForCustomization = False
        Width = 80
      end
      object CountReal_sh: TcxGridDBColumn
        Caption = #1054#1089#1090'. '#1090#1077#1082'. '#1096#1090'.'
        DataBinding.FieldName = 'CountReal_sh'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object CountReal_Weight: TcxGridDBColumn
        Caption = #1054#1089#1090'. '#1090#1077#1082'. '#1074#1077#1089
        DataBinding.FieldName = 'CountReal_Weight'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object PriceReal: TcxGridDBColumn
        Caption = #1086#1089#1090'. '#1090#1077#1082'. '#1094'. c/c'
        DataBinding.FieldName = 'PriceReal'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 60
      end
      object SummReal: TcxGridDBColumn
        Caption = #1054#1089#1090'. '#1090#1077#1082'. '#1089#1091#1084#1084#1072' '#1089'/'#1089
        DataBinding.FieldName = 'SummReal'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object CountTotalIn_Weight: TcxGridDBColumn
        DataBinding.FieldName = 'CountTotalIn_Weight'
        Visible = False
        VisibleForCustomization = False
        Width = 55
      end
      object SummTotalIn: TcxGridDBColumn
        DataBinding.FieldName = 'SummTotalIn'
        Visible = False
        VisibleForCustomization = False
        Width = 55
      end
      object ColorB_GreenL: TcxGridDBColumn
        DataBinding.FieldName = 'ColorB_GreenL'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        VisibleForCustomization = False
        Width = 55
      end
      object ColorB_Yelow: TcxGridDBColumn
        DataBinding.FieldName = 'ColorB_Yelow'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        VisibleForCustomization = False
        Width = 55
      end
      object ColorB_Cyan: TcxGridDBColumn
        DataBinding.FieldName = 'ColorB_Cyan'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        VisibleForCustomization = False
        Width = 55
      end
      object AssetToName: TcxGridDBColumn
        DataBinding.FieldName = 'AssetToName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        VisibleForCustomization = False
        Width = 55
      end
      object InfoMoneyName_all: TcxGridDBColumn
        DataBinding.FieldName = 'InfoMoneyName_all'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        VisibleForCustomization = False
        Width = 55
      end
      object InfoMoneyName_all_Detail: TcxGridDBColumn
        DataBinding.FieldName = 'InfoMoneyName_all_Detail'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        VisibleForCustomization = False
        Width = 55
      end
      object PartionCellCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1071#1095#1077#1081#1082#1072
        DataBinding.FieldName = 'PartionCellCode'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1076' '#1071#1095#1077#1081#1082#1072' '#1093#1088#1072#1085#1077#1085#1080#1103
        Options.Editing = False
        Width = 80
      end
      object PartionCellName: TcxGridDBColumn
        Caption = #1071#1095#1077#1081#1082#1072' '#1093#1088#1072#1085#1077#1085#1080#1103
        DataBinding.FieldName = 'PartionCellName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1344
    Height = 54
    Align = alTop
    TabOrder = 1
    object edGoodsGroup: TcxButtonEdit
      Left = 957
      Top = 4
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 0
      Width = 192
    end
    object deStart: TcxDateEdit
      Left = 60
      Top = 5
      EditValue = 43101d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 2
      Width = 85
    end
    object deEnd: TcxDateEdit
      Left = 60
      Top = 30
      EditValue = 43101d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 4
      Width = 85
    end
    object edUnitGroup: TcxButtonEdit
      Left = 659
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 1
      Width = 203
    end
    object cxLabel3: TcxLabel
      Left = 531
      Top = 6
      Caption = #1043#1088#1091#1087#1087#1072' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1081':'
    end
    object cxLabel1: TcxLabel
      Left = 866
      Top = 6
      Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1086#1074':'
    end
    object edGoods: TcxButtonEdit
      Left = 957
      Top = 30
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 6
      Width = 192
    end
    object edLocation: TcxButtonEdit
      Left = 659
      Top = 30
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 203
    end
    object cxLabel4: TcxLabel
      Left = 585
      Top = 31
      Caption = #1052#1077#1089#1090#1086' '#1091#1095#1077#1090#1072':'
    end
    object cxLabel5: TcxLabel
      Left = 13
      Top = 6
      Caption = #1044#1072#1090#1072' '#1089' :'
    end
    object cxLabel6: TcxLabel
      Left = 6
      Top = 31
      Caption = #1044#1072#1090#1072' '#1087#1086' :'
    end
    object cxLabel7: TcxLabel
      Left = 917
      Top = 31
      Caption = #1058#1086#1074#1072#1088':'
    end
    object ceAccountGroup: TcxButtonEdit
      Left = 325
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 12
      Width = 200
    end
    object cxLabel2: TcxLabel
      Left = 248
      Top = 6
      Caption = #1057#1095#1077#1090' '#1075#1088#1091#1087#1087#1072':'
    end
    object cbInfoMoney: TcxCheckBox
      Left = 247
      Top = 30
      Action = actIsInfoMoney
      Properties.ReadOnly = False
      TabOrder = 14
      Width = 154
    end
    object cbAllMO: TcxCheckBox
      Left = 405
      Top = 30
      Action = actIsAllMO
      Properties.ReadOnly = False
      TabOrder = 15
      Width = 64
    end
    object cbAllAuto: TcxCheckBox
      Left = 477
      Top = 30
      Action = actIsAllAuto
      Properties.ReadOnly = False
      TabOrder = 16
      Width = 71
    end
    object cbPartionCell: TcxCheckBox
      Left = 152
      Top = 5
      Action = actisPartionCell
      Properties.ReadOnly = False
      TabOrder = 17
      Width = 83
    end
    object cbOperDate_Partion: TcxCheckBox
      Left = 152
      Top = 30
      Action = actisOperDate_Partion
      Properties.ReadOnly = False
      TabOrder = 18
      Width = 89
    end
  end
  object cbGoodsKind: TcxCheckBox
    Left = 93
    Top = 87
    Caption = #1087#1086' '#1042#1080#1076#1072#1084' '#1090#1086#1074#1072#1088#1072
    Properties.ReadOnly = False
    TabOrder = 2
    Width = 114
  end
  object cbPartionGoods: TcxCheckBox
    Left = 217
    Top = 87
    Caption = #1087#1086' '#1055#1072#1088#1090#1080#1103#1084
    Properties.ReadOnly = False
    TabOrder = 3
    Width = 88
  end
  object cbAmount: TcxCheckBox
    Left = 309
    Top = 87
    Caption = #1090#1086#1083#1100#1082#1086' '#1050#1086#1083'-'#1074#1086
    Properties.ReadOnly = False
    TabOrder = 8
    Width = 102
  end
  object MasterDS: TDataSource
    DataSet = MasterCDS
    Left = 48
    Top = 248
  end
  object MasterCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 88
    Top = 200
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = cbAmount
        Properties.Strings = (
          'Checked')
      end
      item
        Component = cbGoodsKind
        Properties.Strings = (
          'Checked')
      end
      item
        Component = cbInfoMoney
        Properties.Strings = (
          'Checked')
      end
      item
        Component = cbPartionGoods
        Properties.Strings = (
          'Checked')
      end
      item
        Component = deEnd
        Properties.Strings = (
          'Date')
      end
      item
        Component = deStart
        Properties.Strings = (
          'Date')
      end
      item
        Component = GuidesAccountGroup
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesGoods
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesGoodsGroup
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesLocation
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesUnitGroup
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 312
    Top = 232
  end
  object dxBarManager: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    Categories.Strings = (
      'Default')
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    ImageOptions.Images = dmMain.ImageList
    NotDocking = [dsNone, dsLeft, dsTop, dsRight, dsBottom]
    PopupMenuLinks = <>
    ShowShortCutInHint = True
    UseSystemFont = True
    Left = 128
    Top = 264
    DockControlHeights = (
      0
      0
      26
      0)
    object dxBarManagerBar1: TdxBar
      Caption = 'Custom'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 2
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 671
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbDialogForm'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbGoodsKind'
        end
        item
          Visible = True
          ItemName = 'bbPartionGoods'
        end
        item
          Visible = True
          ItemName = 'bbAmount'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbReport_Goods'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrintBy_Goods'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrint2'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrint3'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrint_Loss'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrint_Inventory'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrint_MOAuto'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrintBarCode'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrintCount'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object bbRefresh: TdxBarButton
      Action = actRefresh
      Category = 0
    end
    object bbToExcel: TdxBarButton
      Action = actExportToExcel
      Category = 0
    end
    object bbDialogForm: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbPrintBy_Goods: TdxBarButton
      Action = actPrint
      Category = 0
    end
    object dxBarStatic: TdxBarStatic
      Caption = '   '
      Category = 0
      Hint = '   '
      Visible = ivAlways
    end
    object bbGoodsKind: TdxBarControlContainerItem
      Caption = #1087#1086' '#1042#1080#1076#1072#1084
      Category = 0
      Hint = #1087#1086' '#1042#1080#1076#1072#1084
      Visible = ivAlways
      Control = cbGoodsKind
    end
    object bbPartionGoods: TdxBarControlContainerItem
      Caption = #1087#1086' '#1055#1072#1088#1090#1080#1103#1084
      Category = 0
      Hint = #1087#1086' '#1055#1072#1088#1090#1080#1103#1084
      Visible = ivAlways
      Control = cbPartionGoods
    end
    object bbAmount: TdxBarControlContainerItem
      Caption = #1090#1086#1083#1100#1082#1086' '#1050#1086#1083'-'#1074#1086
      Category = 0
      Hint = #1090#1086#1083#1100#1082#1086' '#1050#1086#1083'-'#1074#1086
      Visible = ivAlways
      Control = cbAmount
    end
    object bbPrint2: TdxBarButton
      Action = actPrint2
      Category = 0
    end
    object bbPrint3: TdxBarButton
      Action = actPrint3
      Category = 0
    end
    object bbPrint_Loss: TdxBarButton
      Action = actPrint_Loss
      Category = 0
    end
    object bbPrint_Inventory: TdxBarButton
      Action = actPrint_Inventory
      Category = 0
    end
    object bbPrintBarCode: TdxBarButton
      Action = actPrintBarCode
      Category = 0
      ImageIndex = 15
    end
    object bbReport_Goods: TdxBarButton
      Action = actReport_Goods
      Category = 0
    end
    object bbPrint_MOAuto: TdxBarButton
      Action = actPrint_MOAuto
      Category = 0
    end
    object bbPrintCount: TdxBarButton
      Action = actPrintCount
      Category = 0
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 256
    Top = 232
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spReport
      StoredProcList = <
        item
          StoredProc = spReport
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actExportToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      MoveParams = <>
      Grid = cxGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_GoodsBalanceDialogForm'
      FormNameParam.Value = 'TReport_GoodsBalanceDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = ''
          Component = GuidesGoods
          ComponentItem = 'Key'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = ''
          Component = GuidesGoods
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupId'
          Value = ''
          Component = GuidesGoodsGroup
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = ''
          Component = GuidesGoodsGroup
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupId'
          Value = ''
          Component = GuidesUnitGroup
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupName'
          Value = ''
          Component = GuidesUnitGroup
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationId'
          Value = ''
          Component = GuidesLocation
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationName'
          Value = ''
          Component = GuidesLocation
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'AccountGroupId'
          Value = Null
          Component = GuidesAccountGroup
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'AccountGroupName'
          Value = Null
          Component = GuidesAccountGroup
          ComponentItem = 'TextValue'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isInfoMoney'
          Value = Null
          Component = cbInfoMoney
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isAllMO'
          Value = Null
          Component = cbAllMO
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isAllAuto'
          Value = Null
          Component = cbAllAuto
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actPrintBarCode: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1086#1089#1090#1072#1090#1082#1072#1084' '#1090#1086#1074#1072#1088#1072' ('#1096#1090#1088#1080#1093'-'#1082#1086#1076')'
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1086#1089#1090#1072#1090#1082#1072#1084' '#1090#1086#1074#1072#1088#1072' ('#1096#1090#1088#1080#1093'-'#1082#1086#1076')'
      ImageIndex = 3
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42005d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42005d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupName'
          Value = ''
          Component = GuidesUnitGroup
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationName'
          Value = ''
          Component = GuidesLocation
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = ''
          Component = GuidesGoodsGroup
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = ''
          Component = GuidesGoods
          ComponentItem = 'TextValue'
          MultiSelectSeparator = ','
        end
        item
          Name = 'isGoodsKind'
          Value = False
          Component = cbGoodsKind
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isAmount'
          Value = False
          Component = cbAmount
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1087#1086' '#1086#1089#1090#1072#1090#1082#1072#1084' '#1090#1086#1074#1072#1088#1072' ('#1096#1090#1088#1080#1093#1082#1086#1076')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1087#1086' '#1086#1089#1090#1072#1090#1082#1072#1084' '#1090#1086#1074#1072#1088#1072' ('#1096#1090#1088#1080#1093#1082#1086#1076')'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintCount: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1086#1089#1090#1072#1090#1082#1072#1084' '#1090#1086#1074#1072#1088#1072' ('#1076#1074#1080#1078#1077#1085#1080#1077' '#1087#1086' '#1073#1072#1090#1086#1085#1072#1084')'
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1086#1089#1090#1072#1090#1082#1072#1084' '#1090#1086#1074#1072#1088#1072' ('#1076#1074#1080#1078#1077#1085#1080#1077' '#1087#1086' '#1073#1072#1090#1086#1085#1072#1084')'
      ImageIndex = 20
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 
            'GoodsGroupNameFull;GoodsGroupName;GoodsName;GoodsKindName;Partio' +
            'nGoodsName;AssetToName;InfoMoneyName_all;InfoMoneyName_all_Detai' +
            'l'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 43101d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 43101d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupName'
          Value = ''
          Component = GuidesUnitGroup
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationName'
          Value = ''
          Component = GuidesLocation
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = ''
          Component = GuidesGoodsGroup
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = ''
          Component = GuidesGoods
          ComponentItem = 'TextValue'
          MultiSelectSeparator = ','
        end
        item
          Name = 'isGoodsKind'
          Value = False
          Component = cbGoodsKind
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPartionGoods'
          Value = False
          Component = cbPartionGoods
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isAmount'
          Value = False
          Component = cbAmount
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isInfoMoney'
          Value = False
          Component = cbInfoMoney
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1087#1086' '#1086#1089#1090#1072#1090#1082#1072#1084' '#1090#1086#1074#1072#1088#1072' ('#1076#1074#1080#1078#1077#1085#1080#1077' '#1087#1086' '#1073#1072#1090#1086#1085#1072#1084')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1087#1086' '#1086#1089#1090#1072#1090#1082#1072#1084' '#1090#1086#1074#1072#1088#1072' ('#1076#1074#1080#1078#1077#1085#1080#1077' '#1087#1086' '#1073#1072#1090#1086#1085#1072#1084')'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1086#1089#1090#1072#1090#1082#1072#1084' '#1090#1086#1074#1072#1088#1072
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1086#1089#1090#1072#1090#1082#1072#1084' '#1090#1086#1074#1072#1088#1072
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 
            'GoodsGroupNameFull;GoodsGroupName;GoodsName;GoodsKindName;Partio' +
            'nGoodsName;AssetToName;InfoMoneyName_all;InfoMoneyName_all_Detai' +
            'l'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupName'
          Value = Null
          Component = GuidesUnitGroup
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationName'
          Value = ''
          Component = GuidesLocation
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = Null
          Component = GuidesGoodsGroup
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = GuidesGoods
          ComponentItem = 'TextValue'
          MultiSelectSeparator = ','
        end
        item
          Name = 'isGoodsKind'
          Value = Null
          Component = cbGoodsKind
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPartionGoods'
          Value = Null
          Component = cbPartionGoods
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isAmount'
          Value = Null
          Component = cbAmount
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isInfoMoney'
          Value = Null
          Component = cbInfoMoney
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1087#1086' '#1086#1089#1090#1072#1090#1082#1072#1084' '#1090#1086#1074#1072#1088#1072' ('#1076#1074#1080#1078#1077#1085#1080#1077')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1087#1086' '#1086#1089#1090#1072#1090#1082#1072#1084' '#1090#1086#1074#1072#1088#1072' ('#1076#1074#1080#1078#1077#1085#1080#1077')'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object SaleJournal: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'SaleJournal'
      FormName = 'TMovementGoodsJournalForm'
      FormNameParam.Value = 'TMovementGoodsJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsKindId'
          Value = 0
          Component = MasterCDS
          ComponentItem = 'GoodsKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsKindName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = ''
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartionGoodsId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartionGoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartionGoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartionGoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'LocationId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationName'
          Value = ''
          Component = MasterCDS
          ComponentItem = 'LocationName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'AccountGroupId'
          Value = Null
          Component = GuidesAccountGroup
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'AccountGroupName'
          Value = Null
          Component = GuidesAccountGroup
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InfoMoneyId_Detail'
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InfoMoneyName_Detail'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupId'
          Value = Null
          Component = GuidesUnitGroup
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupName'
          Value = Null
          Component = GuidesUnitGroup
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'DescSet'
          Value = Null
          Component = FormParams
          ComponentItem = 'SaleDesc'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actIsInfoMoney: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spReport
      StoredProcList = <
        item
          StoredProc = spReport
        end>
      Caption = #1044#1077#1090#1072#1083#1100#1085#1086' '#1087#1086' '#1059#1055' '#1089#1090#1072#1090#1100#1103#1084
      Hint = #1044#1077#1090#1072#1083#1100#1085#1086' '#1087#1086' '#1059#1055' '#1089#1090#1072#1090#1100#1103#1084
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actPrint2: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1054#1090#1095#1077#1090' <'#1054#1089#1090#1072#1090#1086#1082' '#1090#1086#1074#1072#1088#1072' '#1079#1072' '#1087#1077#1088#1080#1086#1076' ('#1088#1072#1089#1095#1077#1090#1085#1099#1081')>'
      Hint = #1054#1090#1095#1077#1090' <'#1054#1089#1090#1072#1090#1086#1082' '#1090#1086#1074#1072#1088#1072' '#1079#1072' '#1087#1077#1088#1080#1086#1076' ('#1088#1072#1089#1095#1077#1090#1085#1099#1081')>'
      ImageIndex = 18
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 
            'GoodsGroupNameFull;GoodsName;GoodsKindName;PartionGoodsName;Asse' +
            'tToName;InfoMoneyName_all;InfoMoneyName_all_Detail'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42005d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42005d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupName'
          Value = ''
          Component = GuidesUnitGroup
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationName'
          Value = ''
          Component = GuidesLocation
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = ''
          Component = GuidesGoodsGroup
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = ''
          Component = GuidesGoods
          ComponentItem = 'TextValue'
          MultiSelectSeparator = ','
        end
        item
          Name = 'isGoodsKind'
          Value = False
          Component = cbGoodsKind
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPartionGoods'
          Value = False
          Component = cbPartionGoods
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isAmount'
          Value = False
          Component = cbAmount
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isInfoMoney'
          Value = False
          Component = cbInfoMoney
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1087#1086' '#1086#1089#1090#1072#1090#1082#1072#1084' '#1090#1086#1074#1072#1088#1072' ('#1076#1074#1080#1078#1077#1085#1080#1077')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1087#1086' '#1086#1089#1090#1072#1090#1082#1072#1084' '#1090#1086#1074#1072#1088#1072' ('#1076#1074#1080#1078#1077#1085#1080#1077')'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint3: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1086#1089#1090#1072#1090#1082#1072#1084' '#1090#1086#1074#1072#1088#1072' ('#1074#1099#1093#1086#1076' '#1043#1055')'
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1086#1089#1090#1072#1090#1082#1072#1084' '#1090#1086#1074#1072#1088#1072' ('#1074#1099#1093#1086#1076' '#1043#1055')'
      ImageIndex = 19
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 
            'GoodsGroupNameFull;GoodsGroupName;GoodsName;GoodsKindName;Partio' +
            'nGoodsName;AssetToName;InfoMoneyName_all;InfoMoneyName_all_Detai' +
            'l'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42005d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42005d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupName'
          Value = ''
          Component = GuidesUnitGroup
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationName'
          Value = ''
          Component = GuidesLocation
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = ''
          Component = GuidesGoodsGroup
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = ''
          Component = GuidesGoods
          ComponentItem = 'TextValue'
          MultiSelectSeparator = ','
        end
        item
          Name = 'isGoodsKind'
          Value = False
          Component = cbGoodsKind
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPartionGoods'
          Value = False
          Component = cbPartionGoods
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isAmount'
          Value = False
          Component = cbAmount
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isInfoMoney'
          Value = False
          Component = cbInfoMoney
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1087#1086' '#1086#1089#1090#1072#1090#1082#1072#1084' '#1090#1086#1074#1072#1088#1072' ('#1074#1099#1093#1086#1076' '#1043#1055')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1087#1086' '#1086#1089#1090#1072#1090#1082#1072#1084' '#1090#1086#1074#1072#1088#1072' ('#1074#1099#1093#1086#1076' '#1043#1055')'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint_Loss: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1054#1090#1095#1077#1090' <% '#1089#1087#1080#1089#1072#1085#1080#1103'>'
      Hint = #1054#1090#1095#1077#1090' <% '#1089#1087#1080#1089#1072#1085#1080#1103'>'
      ImageIndex = 17
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 
            'GoodsGroupNameFull;GoodsGroupName;GoodsName;GoodsKindName;Partio' +
            'nGoodsName;AssetToName;InfoMoneyName_all;InfoMoneyName_all_Detai' +
            'l'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42005d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42005d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupName'
          Value = ''
          Component = GuidesUnitGroup
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationName'
          Value = ''
          Component = GuidesLocation
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = ''
          Component = GuidesGoodsGroup
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = ''
          Component = GuidesGoods
          ComponentItem = 'TextValue'
          MultiSelectSeparator = ','
        end
        item
          Name = 'isGoodsKind'
          Value = False
          Component = cbGoodsKind
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPartionGoods'
          Value = False
          Component = cbPartionGoods
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isAmount'
          Value = False
          Component = cbAmount
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isInfoMoney'
          Value = False
          Component = cbInfoMoney
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupName_by'
          Value = ''
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationName_by'
          Value = ''
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'isLoss'
          Value = True
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1087#1086' '#1086#1089#1090#1072#1090#1082#1072#1084' '#1090#1086#1074#1072#1088#1072' ('#1087#1088#1086#1094#1077#1085#1090' '#1089#1087#1080#1089#1072#1085#1080#1103')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1087#1086' '#1086#1089#1090#1072#1090#1082#1072#1084' '#1090#1086#1074#1072#1088#1072' ('#1087#1088#1086#1094#1077#1085#1090' '#1089#1087#1080#1089#1072#1085#1080#1103')'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint_MOAuto: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100' '#1087#1086' '#1052#1054' '#1080#1083#1080' '#1040#1074#1090#1086
      Hint = #1055#1077#1095#1072#1090#1100' '#1087#1086' '#1052#1054' '#1080#1083#1080' '#1040#1074#1090#1086
      ImageIndex = 16
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 
            'LocationName;UnitName_to;DriverName;GoodsGroupNameFull;GoodsGrou' +
            'pName;GoodsName;GoodsKindName;PartionGoodsName;AssetToName;InfoM' +
            'oneyName_all;InfoMoneyName_all_Detail'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 43101d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 43101d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupName'
          Value = ''
          Component = GuidesUnitGroup
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationName'
          Value = ''
          Component = GuidesLocation
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = ''
          Component = GuidesGoodsGroup
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = ''
          Component = GuidesGoods
          ComponentItem = 'TextValue'
          MultiSelectSeparator = ','
        end
        item
          Name = 'isGoodsKind'
          Value = False
          Component = cbGoodsKind
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPartionGoods'
          Value = False
          Component = cbPartionGoods
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isAmount'
          Value = False
          Component = cbAmount
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isInfoMoney'
          Value = False
          Component = cbInfoMoney
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupName_by'
          Value = ''
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationName_by'
          Value = ''
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1087#1086' '#1086#1089#1090#1072#1090#1082#1072#1084' '#1090#1086#1074#1072#1088#1072' ('#1087#1086' '#1052#1054' '#1080#1083#1080' '#1040#1074#1090#1086')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1087#1086' '#1086#1089#1090#1072#1090#1082#1072#1084' '#1090#1086#1074#1072#1088#1072' ('#1087#1086' '#1052#1054' '#1080#1083#1080' '#1040#1074#1090#1086')'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint_Inventory: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1054#1090#1095#1077#1090' <'#1040#1082#1090' '#1080#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1080'>'
      Hint = #1054#1090#1095#1077#1090' <'#1040#1082#1090' '#1080#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1080'>'
      ImageIndex = 17
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 
            'GoodsGroupNameFull;GoodsGroupName;GoodsName;GoodsKindName;Partio' +
            'nGoodsName;AssetToName;InfoMoneyName_all;InfoMoneyName_all_Detai' +
            'l'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42005d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42005d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupName'
          Value = ''
          Component = GuidesUnitGroup
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationName'
          Value = ''
          Component = GuidesLocation
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = ''
          Component = GuidesGoodsGroup
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = ''
          Component = GuidesGoods
          ComponentItem = 'TextValue'
          MultiSelectSeparator = ','
        end
        item
          Name = 'isGoodsKind'
          Value = False
          Component = cbGoodsKind
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPartionGoods'
          Value = False
          Component = cbPartionGoods
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isAmount'
          Value = False
          Component = cbAmount
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isInfoMoney'
          Value = False
          Component = cbInfoMoney
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupName_by'
          Value = ''
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationName_by'
          Value = ''
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'isLoss'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1087#1086' '#1086#1089#1090#1072#1090#1082#1072#1084' '#1090#1086#1074#1072#1088#1072' ('#1087#1088#1086#1094#1077#1085#1090' '#1089#1087#1080#1089#1072#1085#1080#1103')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1087#1086' '#1086#1089#1090#1072#1090#1082#1072#1084' '#1090#1086#1074#1072#1088#1072' ('#1087#1088#1086#1094#1077#1085#1090' '#1089#1087#1080#1089#1072#1085#1080#1103')'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actIsAllMO: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spReport
      StoredProcList = <
        item
          StoredProc = spReport
        end>
      Caption = #1042#1089#1077' '#1052#1054
      Hint = #1042#1089#1077' '#1052#1054
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actIsAllAuto: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spReport
      StoredProcList = <
        item
          StoredProc = spReport
        end>
      Caption = #1042#1089#1077' '#1040#1074#1090#1086
      Hint = #1042#1089#1077' '#1040#1074#1090#1086
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actReport_Goods: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' <'#1044#1077#1090#1072#1083#1100#1085#1086' '#1087#1086' '#1090#1086#1074#1072#1088#1091'>'
      Hint = #1054#1090#1095#1077#1090' <'#1044#1077#1090#1072#1083#1100#1085#1086' '#1087#1086' '#1090#1086#1074#1072#1088#1091'>'
      ImageIndex = 26
      FormName = 'TReport_GoodsForm'
      FormNameParam.Value = 'TReport_GoodsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 42005d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42005d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupId'
          Value = ''
          Component = GuidesUnitGroup
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupName'
          Value = ''
          Component = GuidesUnitGroup
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'LocationId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'LocationName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsGroupId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsGroupName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'IsPartner'
          Value = True
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actisOperDate_Partion: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spReport
      StoredProcList = <
        item
          StoredProc = spReport
        end>
      Caption = #1044#1072#1090#1072' '#1087#1072#1088#1090#1080#1080
      Hint = #1044#1072#1090#1072' '#1087#1072#1088#1090#1080#1080
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actisPartionCell: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spReport
      StoredProcList = <
        item
          StoredProc = spReport
        end>
      Caption = #1055#1086' '#1103#1095#1077#1081#1082#1072#1084
      Hint = #1055#1086' '#1103#1095#1077#1081#1082#1072#1084
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
  end
  object spReport: TdsdStoredProc
    StoredProcName = 'gpReport_GoodsBalance'
    DataSet = MasterCDS
    DataSets = <
      item
        DataSet = MasterCDS
      end>
    Params = <
      item
        Name = 'inStartDate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 41640d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAccountGroupId'
        Value = Null
        Component = GuidesAccountGroup
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitGroupId'
        Value = ''
        Component = GuidesUnitGroup
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inLocationId'
        Value = ''
        Component = GuidesLocation
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsGroupId'
        Value = ''
        Component = GuidesGoodsGroup
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsInfoMoney'
        Value = Null
        Component = cbInfoMoney
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsAllMO'
        Value = Null
        Component = cbAllMO
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsAllAuto'
        Value = Null
        Component = cbAllAuto
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsOperDate_Partion'
        Value = Null
        Component = cbOperDate_Partion
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPartionCell'
        Value = Null
        Component = cbPartionCell
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 256
    Top = 176
  end
  object DBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <
      item
        ColorColumn = CountOut_calc
        BackGroundValueColumn = ColorB_GreenL
        ColorValueList = <>
      end
      item
        ColorColumn = CountOut_sh_calc
        BackGroundValueColumn = ColorB_GreenL
        ColorValueList = <>
      end
      item
        ColorColumn = CountOut_Weight_calc
        BackGroundValueColumn = ColorB_GreenL
        ColorValueList = <>
      end
      item
        ColorColumn = CountIn_calc
        BackGroundValueColumn = ColorB_GreenL
        ColorValueList = <>
      end
      item
        ColorColumn = CountIn_sh_calc
        BackGroundValueColumn = ColorB_GreenL
        ColorValueList = <>
      end
      item
        ColorColumn = CountIn_Weight_calc
        BackGroundValueColumn = ColorB_GreenL
        ColorValueList = <>
      end
      item
        ColorColumn = CountEnd_calc
        BackGroundValueColumn = ColorB_Yelow
        ColorValueList = <>
      end
      item
        ColorColumn = CountEnd_sh_calc
        BackGroundValueColumn = ColorB_Yelow
        ColorValueList = <>
      end
      item
        ColorColumn = CountEnd_Weight_calc
        BackGroundValueColumn = ColorB_Yelow
        ColorValueList = <>
      end
      item
        ColorColumn = CountReal
        BackGroundValueColumn = ColorB_Cyan
        ColorValueList = <>
      end
      item
        ColorColumn = CountReal_sh
        BackGroundValueColumn = ColorB_Cyan
        ColorValueList = <>
      end
      item
        ColorColumn = CountReal_Weight
        BackGroundValueColumn = ColorB_Cyan
        ColorValueList = <>
      end>
    ColumnAddOnList = <
      item
        Action = SaleJournal
        onExitColumn.Active = False
        onExitColumn.AfterEmptyValue = False
      end>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    ViewDocumentList = <>
    PropertiesCellList = <>
    Left = 456
    Top = 392
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 344
    Top = 288
  end
  object GuidesGoodsGroup: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoodsGroup
    FormNameParam.Value = 'TGoodsGroup_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsGroup_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGoodsGroup
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGoodsGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 968
  end
  object GuidesLocation: TdsdGuides
    KeyField = 'Id'
    LookupControl = edLocation
    FormNameParam.Value = 'TStoragePlace_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TStoragePlace_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesLocation
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesLocation
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 728
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 176
    Top = 176
  end
  object GuidesUnitGroup: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnitGroup
    FormNameParam.Value = 'TUnitTreeForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnitTreeForm'
    PositionDataSet = 'ClientDataSet'
    ParentDataSet = 'TreeDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnitGroup
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnitGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 600
  end
  object GuidesGoods: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoods
    FormNameParam.Value = 'TGoodsFuel_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsFuel_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 904
    Top = 27
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ShowDialogAction = ExecuteDialog
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = GuidesAccountGroup
      end
      item
        Component = GuidesUnitGroup
      end
      item
        Component = GuidesLocation
      end
      item
        Component = GuidesGoodsGroup
      end
      item
        Component = GuidesGoods
      end>
    Left = 144
    Top = 344
  end
  object GuidesAccountGroup: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceAccountGroup
    FormNameParam.Value = 'TAccountGroup_ObjectDescForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TAccountGroup_ObjectDescForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesAccountGroup
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesAccountGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDescCode'
        Value = 'zc_Object_Goods'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 416
    Top = 85
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'IncomeDesc'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReturnOutDesc'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'SaleDesc'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReturnInDesc'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MoneyDesc'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ServiceDesc'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'SendDebtDesc'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OtherDesc'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'SaleRealDesc'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReturnInRealDesc'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'TransferDebtDesc'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 424
    Top = 224
  end
  object spGetDescSets: TdsdStoredProc
    StoredProcName = 'gpGetDescSets'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'IncomeDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'IncomeDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReturnOutDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'ReturnOutDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'SaleDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'SaleDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReturnInDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'ReturnInDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MoneyDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'MoneyDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ServiceDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'ServiceDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'SendDebtDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'SendDebtDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OtherDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'OtherDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'SaleRealDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'SaleRealDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReturnInRealDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'ReturnInRealDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'TransferDebtDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'TransferDebtDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceCorrectiveDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'PriceCorrectiveDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ServiceRealDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'ServiceRealDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ChangeCurrencyDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'ChangeCurrencyDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 528
    Top = 272
  end
end
