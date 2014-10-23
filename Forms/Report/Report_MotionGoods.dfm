object Report_MotionGoodsForm: TReport_MotionGoodsForm
  Left = 0
  Top = 0
  Caption = #1054#1090#1095#1077#1090' <'#1044#1074#1080#1078#1077#1085#1080#1077' '#1090#1086#1074#1072#1088#1086#1074'>'
  ClientHeight = 446
  ClientWidth = 1329
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
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid: TcxGrid
    Left = 0
    Top = 80
    Width = 1329
    Height = 366
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
          Column = CountIncome
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SummIncome
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountSendIn
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SummSendIn
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountSendOut
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SummSendOut
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountSale
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SummSale
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountReturnOut
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SummReturnOut
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountReturnIn
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SummReturnIn
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountLoss
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SummLoss
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountInventory
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SummInventory
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
          Column = CountSendOnPriceIn
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SummSendOnPriceIn
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountSendOnPriceOut
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SummSendOnPriceOut
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountProductionIn
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SummProductionIn
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountProductionOut
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SummProductionOut
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountTotalIn
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountTotalOut
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SummTotalIn
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SummTotalOut
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
          Column = CountIncome
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SummIncome
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountSendIn
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SummSendIn
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountSendOut
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SummSendOut
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountSale
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SummSale
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountReturnOut
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SummReturnOut
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountReturnIn
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SummReturnIn
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountLoss
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SummLoss
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountInventory
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SummInventory
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountSendOnPriceIn
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SummSendOnPriceIn
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountSendOnPriceOut
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SummSendOnPriceOut
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountProductionIn
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SummProductionIn
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountProductionOut
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SummProductionOut
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountTotalIn
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountTotalOut
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SummTotalIn
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SummTotalOut
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
        Width = 50
      end
      object AccountName_All: TcxGridDBColumn
        Caption = #1057#1095#1077#1090
        DataBinding.FieldName = 'AccountName_All'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 100
      end
      object LocationDescName: TcxGridDBColumn
        Caption = #1042#1080#1076' '#1084#1077#1089#1090#1072' '#1091#1095#1077#1090#1072
        DataBinding.FieldName = 'LocationDescName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object LocationCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1084#1077#1089#1090#1072' '#1091#1095'.'
        DataBinding.FieldName = 'LocationCode'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 45
      end
      object LocationName: TcxGridDBColumn
        Caption = #1052#1077#1089#1090#1086' '#1091#1095#1077#1090#1072
        DataBinding.FieldName = 'LocationName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object CarCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1072#1074#1090#1086#1084'.'
        DataBinding.FieldName = 'CarCode'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 45
      end
      object CarName: TcxGridDBColumn
        Caption = #1040#1074#1090#1086#1084#1086#1073#1080#1083#1100
        DataBinding.FieldName = 'CarName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 60
      end
      object GoodsGroupNameFull: TcxGridDBColumn
        Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072' ('#1074#1089#1077')'
        DataBinding.FieldName = 'GoodsGroupNameFull'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object GoodsGroupName: TcxGridDBColumn
        Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072
        DataBinding.FieldName = 'GoodsGroupName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object GoodsCode: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'GoodsCode'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 20
      end
      object GoodsName: TcxGridDBColumn
        Caption = #1058#1086#1074#1072#1088
        DataBinding.FieldName = 'GoodsName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object GoodsKindName: TcxGridDBColumn
        Caption = #1042#1080#1076' '#1091#1087#1072#1082#1086#1074#1082#1080
        DataBinding.FieldName = 'GoodsKindName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 50
      end
      object PartionGoodsName: TcxGridDBColumn
        Caption = #1055#1072#1088#1090#1080#1103' '#1090#1086#1074#1072#1088#1072
        DataBinding.FieldName = 'PartionGoodsName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 40
      end
      object AssetName: TcxGridDBColumn
        Caption = #1054#1057' ('#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077' '#1058#1052#1062')'
        DataBinding.FieldName = 'AssetName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 40
      end
      object MeasureName: TcxGridDBColumn
        Caption = #1045#1076'. '#1080#1079#1084'.'
        DataBinding.FieldName = 'MeasureName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 35
      end
      object Weight: TcxGridDBColumn
        Caption = #1042#1077#1089
        DataBinding.FieldName = 'Weight'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 30
      end
      object CountStart: TcxGridDBColumn
        Caption = #1054#1089#1090'. '#1085#1072#1095'. '#1082#1086#1083'.'
        DataBinding.FieldName = 'CountStart'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; '
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object PriceStart: TcxGridDBColumn
        Caption = #1094#1077#1085#1072' '#1086#1089#1090'.'#1085'.'
        DataBinding.FieldName = 'PriceStart'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 35
      end
      object SummStart: TcxGridDBColumn
        Caption = #1054#1089#1090'. '#1085#1072#1095'. '#1089#1091#1084#1084#1072
        DataBinding.FieldName = 'SummStart'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; '
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object CountIncome: TcxGridDBColumn
        Caption = #1055#1086#1089#1090#1072#1074#1097'. '#1082#1086#1083'.'
        DataBinding.FieldName = 'CountIncome'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; '
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object PriceIncome: TcxGridDBColumn
        Caption = #1094#1077#1085#1072' '#1087#1086#1089#1090'.'
        DataBinding.FieldName = 'PriceIncome'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 35
      end
      object SummIncome: TcxGridDBColumn
        Caption = #1055#1086#1089#1090#1072#1074#1097'. '#1089#1091#1084#1084#1072
        DataBinding.FieldName = 'SummIncome'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; '
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 75
      end
      object CountReturnOut: TcxGridDBColumn
        Caption = #1042#1086#1079#1074#1088'. '#1087#1086#1089#1090'. '#1082#1086#1083'.'
        DataBinding.FieldName = 'CountReturnOut'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; '
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object PriceReturnOut: TcxGridDBColumn
        Caption = #1094#1077#1085#1072' '#1074'.'#1087#1086#1089#1090'.'
        DataBinding.FieldName = 'PriceReturnOut'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 35
      end
      object SummReturnOut: TcxGridDBColumn
        Caption = #1042#1086#1079#1074#1088'. '#1087#1086#1089#1090'. '#1089#1091#1084#1084#1072
        DataBinding.FieldName = 'SummReturnOut'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; '
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 75
      end
      object CountSendIn: TcxGridDBColumn
        Caption = #1055#1077#1088#1077#1084'. '#1087#1088#1080#1093'. '#1082#1086#1083'.'
        DataBinding.FieldName = 'CountSendIn'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; '
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object PriceSendIn: TcxGridDBColumn
        Caption = #1094#1077#1085#1072' '#1087#1088#1080#1093'.'#1087'. '
        DataBinding.FieldName = 'PriceSendIn'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####'
        Visible = False
        FooterAlignmentHorz = taRightJustify
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 40
      end
      object SummSendIn: TcxGridDBColumn
        Caption = #1055#1077#1088#1077#1084'. '#1087#1088#1080#1093'. '#1089#1091#1084#1084#1072
        DataBinding.FieldName = 'SummSendIn'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; '
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 75
      end
      object CountSendOut: TcxGridDBColumn
        Caption = #1055#1077#1088#1077#1084'. '#1088#1072#1089#1093'. '#1082#1086#1083'.'
        DataBinding.FieldName = 'CountSendOut'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; '
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object PriceSendOut: TcxGridDBColumn
        Caption = #1094#1077#1085#1072' '#1088#1072#1089#1093'. '#1087'.'
        DataBinding.FieldName = 'PriceSendOut'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 45
      end
      object SummSendOut: TcxGridDBColumn
        Caption = #1055#1077#1088#1077#1084'. '#1088#1072#1089#1093'. '#1089#1091#1084#1084#1072
        DataBinding.FieldName = 'SummSendOut'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; '
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 75
      end
      object CountSendOnPriceIn: TcxGridDBColumn
        Caption = #1055#1077#1088#1077#1084'. '#1092#1080#1083'. '#1087#1088#1080#1093'. '#1082#1086#1083'.'
        DataBinding.FieldName = 'CountSendOnPriceIn'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; '
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object PriceSendOnPriceIn: TcxGridDBColumn
        Caption = #1094#1077#1085#1072' '#1087#1088#1080#1093'. '#1092'. '
        DataBinding.FieldName = 'PriceSendOnPriceIn'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 45
      end
      object SummSendOnPriceIn: TcxGridDBColumn
        Caption = #1055#1077#1088#1077#1084'. '#1092#1080#1083'. '#1087#1088#1080#1093'. '#1089#1091#1084#1084#1072
        DataBinding.FieldName = 'SummSendOnPriceIn'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; '
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 75
      end
      object CountProductionIn: TcxGridDBColumn
        Caption = #1055#1088#1086#1080#1079#1074'. '#1087#1088#1080#1093'. '#1082#1086#1083
        DataBinding.FieldName = 'CountProductionIn'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; '
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object PriceProductionIn: TcxGridDBColumn
        Caption = #1094#1077#1085#1072' '#1087#1088'.'#1087#1088#1080#1093'.'
        DataBinding.FieldName = 'PriceProductionIn'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; '
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 45
      end
      object SummProductionIn: TcxGridDBColumn
        Caption = #1055#1088#1086#1080#1079#1074'. '#1087#1088#1080#1093'. '#1089#1091#1084#1084#1072
        DataBinding.FieldName = 'SummProductionIn'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; '
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 75
      end
      object CountSendOnPriceOut: TcxGridDBColumn
        Caption = #1055#1077#1088#1077#1084'. '#1092#1080#1083'. '#1088#1072#1089#1093'. '#1082#1086#1083'.'
        DataBinding.FieldName = 'CountSendOnPriceOut'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; '
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object PriceSendOnPriceOut: TcxGridDBColumn
        Caption = #1094#1077#1085#1072' '#1088#1072#1089#1093'.'#1092'. '
        DataBinding.FieldName = 'PriceSendOnPriceOut'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 45
      end
      object SummSendOnPriceOut: TcxGridDBColumn
        Caption = #1055#1077#1088#1077#1084'. '#1092#1080#1083'. '#1088#1072#1089#1093'. '#1089#1091#1084#1084#1072
        DataBinding.FieldName = 'SummSendOnPriceOut'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; '
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 75
      end
      object CountSale: TcxGridDBColumn
        Caption = #1055#1088#1086#1076#1072#1078#1072' '#1082#1086#1083'.'
        DataBinding.FieldName = 'CountSale'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; '
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object PriceSale: TcxGridDBColumn
        Caption = #1094#1077#1085#1072' '#1087#1088#1086#1076'.'
        DataBinding.FieldName = 'PriceSale'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 45
      end
      object SummSale: TcxGridDBColumn
        Caption = #1055#1088#1086#1076#1072#1078#1072' '#1089#1091#1084#1084#1072
        DataBinding.FieldName = 'SummSale'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; '
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 75
      end
      object CountReturnIn: TcxGridDBColumn
        Caption = #1042#1086#1079#1074#1088'. '#1087#1086#1082'. '#1082#1086#1083'.'
        DataBinding.FieldName = 'CountReturnIn'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; '
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object PriceReturnIn: TcxGridDBColumn
        Caption = #1094#1077#1085#1072' '#1074'.'#1087#1086#1082'. '
        DataBinding.FieldName = 'PriceReturnIn'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 45
      end
      object SummReturnIn: TcxGridDBColumn
        Caption = #1042#1086#1079#1074#1088'. '#1087#1086#1082'. '#1089#1091#1084#1084#1072
        DataBinding.FieldName = 'SummReturnIn'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; '
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 75
      end
      object CountLoss: TcxGridDBColumn
        Caption = #1057#1087#1080#1089#1072#1085#1080#1077' '#1082#1086#1083'.'
        DataBinding.FieldName = 'CountLoss'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; '
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object PriceLoss: TcxGridDBColumn
        Caption = #1094#1077#1085#1072' '#1089#1087#1080#1089'.'
        DataBinding.FieldName = 'PriceLoss'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 45
      end
      object SummLoss: TcxGridDBColumn
        Caption = #1057#1087#1080#1089#1072#1085#1080#1077' '#1089#1091#1084#1084#1072
        DataBinding.FieldName = 'SummLoss'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; '
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 75
      end
      object CountProductionOut: TcxGridDBColumn
        Caption = #1055#1088#1086#1080#1079#1074'. '#1088#1072#1089#1093'. '#1082#1086#1083
        DataBinding.FieldName = 'CountProductionOut'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; '
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object PriceProductionOut: TcxGridDBColumn
        Caption = #1094#1077#1085#1072' '#1087#1088'.'#1088#1072#1089#1093'. '
        DataBinding.FieldName = 'PriceProductionOut'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; '
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 45
      end
      object SummProductionOut: TcxGridDBColumn
        Caption = #1055#1088#1086#1080#1079#1074'. '#1088#1072#1089#1093'. '#1089#1091#1084#1084#1072
        DataBinding.FieldName = 'SummProductionOut'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; '
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 75
      end
      object CountInventory: TcxGridDBColumn
        Caption = #1050#1086#1083'. (-) '#1091#1073#1099#1083#1100' (+) '#1101#1082#1086#1085#1086#1084'. '
        DataBinding.FieldName = 'CountInventory'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; '
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object PriceInventory: TcxGridDBColumn
        Caption = #1094#1077#1085#1072' '#1091#1073'.,'#1101#1082'.'
        DataBinding.FieldName = 'PriceInventory'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 45
      end
      object SummInventory: TcxGridDBColumn
        Caption = #1057#1091#1084#1084#1072' (-) '#1091#1073#1099#1083#1100' (+) '#1101#1082#1086#1085#1086#1084'. '
        DataBinding.FieldName = 'SummInventory'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; '
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 75
      end
      object CountEnd: TcxGridDBColumn
        Caption = #1054#1089#1090'. '#1082#1086#1085#1077#1095'. '#1082#1086#1083'.'
        DataBinding.FieldName = 'CountEnd'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; '
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object PriceEnd: TcxGridDBColumn
        Caption = #1094#1077#1085#1072' '#1086#1089#1090'.'#1082'. '
        DataBinding.FieldName = 'PriceEnd'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 45
      end
      object SummEnd: TcxGridDBColumn
        Caption = #1054#1089#1090'. '#1082#1086#1085#1077#1095'. '#1089#1091#1084#1084#1072
        DataBinding.FieldName = 'SummEnd'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; '
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 75
      end
      object CountTotalIn: TcxGridDBColumn
        Caption = #1048#1090#1086#1075#1086' '#1087#1088#1080#1093#1086#1076' '#1082#1086#1083'.'
        DataBinding.FieldName = 'CountTotalIn'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object PriceTotalIn: TcxGridDBColumn
        Caption = #1094#1077#1085#1072' '#1080#1090'.'#1087#1088#1080#1093'.'
        DataBinding.FieldName = 'PriceTotalIn'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object SummTotalIn: TcxGridDBColumn
        Caption = #1048#1090#1086#1075#1086' '#1087#1088#1080#1093#1086#1076' '#1089#1091#1084#1084#1072
        DataBinding.FieldName = 'SummTotalIn'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 75
      end
      object CountTotalOut: TcxGridDBColumn
        Caption = #1048#1090#1086#1075#1086' '#1088#1072#1089#1093#1086#1076' '#1082#1086#1083'.'
        DataBinding.FieldName = 'CountTotalOut'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object PriceTotalOut: TcxGridDBColumn
        Caption = #1094#1077#1085#1072' '#1080#1090'.'#1088#1072#1089#1093'.'
        DataBinding.FieldName = 'PriceTotalOut'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object SummTotalOut: TcxGridDBColumn
        Caption = #1048#1090#1086#1075#1086' '#1088#1072#1089#1093#1086#1076' '#1089#1091#1084#1084#1072
        DataBinding.FieldName = 'SummTotalOut'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 75
      end
      object InfoMoneyCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1059#1055
        DataBinding.FieldName = 'InfoMoneyCode'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 45
      end
      object InfoMoneyGroupName: TcxGridDBColumn
        Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
        DataBinding.FieldName = 'InfoMoneyGroupName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object InfoMoneyDestinationName: TcxGridDBColumn
        Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
        DataBinding.FieldName = 'InfoMoneyDestinationName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object InfoMoneyName: TcxGridDBColumn
        Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
        DataBinding.FieldName = 'InfoMoneyName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object InfoMoneyName_all: TcxGridDBColumn
        Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103
        DataBinding.FieldName = 'InfoMoneyName_all'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 200
      end
      object InfoMoneyCode_Detail: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1059#1055' ('#1076#1077#1090#1072#1083#1100#1085#1086')'
        DataBinding.FieldName = 'InfoMoneyCode_Detail'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 45
      end
      object InfoMoneyGroupName_Detail: TcxGridDBColumn
        Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103'  ('#1076#1077#1090#1072#1083#1100#1085#1086')'
        DataBinding.FieldName = 'InfoMoneyGroupName_Detail'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object InfoMoneyDestinationName_Detail: TcxGridDBColumn
        Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077'  ('#1076#1077#1090#1072#1083#1100#1085#1086')'
        DataBinding.FieldName = 'InfoMoneyDestinationName_Detail'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object InfoMoneyName_Detail: TcxGridDBColumn
        Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103'  ('#1076#1077#1090#1072#1083#1100#1085#1086')'
        DataBinding.FieldName = 'InfoMoneyName_Detail'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object InfoMoneyName_all_Detail: TcxGridDBColumn
        Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' ('#1076#1077#1090#1072#1083#1100#1085#1086')'
        DataBinding.FieldName = 'InfoMoneyName_all'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 200
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1329
    Height = 54
    Align = alTop
    TabOrder = 5
    object edGoodsGroup: TcxButtonEdit
      Left = 900
      Top = 5
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
      EditValue = 41640d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 2
      Width = 85
    end
    object deEnd: TcxDateEdit
      Left = 60
      Top = 30
      EditValue = 41640d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 4
      Width = 85
    end
    object edUnitGroup: TcxButtonEdit
      Left = 585
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
      Left = 457
      Top = 6
      Caption = #1043#1088#1091#1087#1087#1072' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1081':'
    end
    object cxLabel1: TcxLabel
      Left = 809
      Top = 6
      Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1086#1074':'
    end
    object edGoods: TcxButtonEdit
      Left = 900
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
      Left = 585
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
      Left = 511
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
      Left = 860
      Top = 31
      Caption = #1058#1086#1074#1072#1088':'
    end
    object ceAccountGroup: TcxButtonEdit
      Left = 243
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
      Left = 170
      Top = 6
      Caption = #1057#1095#1077#1090' '#1075#1088#1091#1087#1087#1072':'
    end
    object cbInfoMoney: TcxCheckBox
      Left = 243
      Top = 30
      Caption = #1044#1077#1090#1072#1083#1100#1085#1086' '#1087#1086' '#1059#1055' '#1089#1090#1072#1090#1100#1103#1084
      Properties.ReadOnly = True
      TabOrder = 14
      Width = 166
    end
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
        Component = AccountGroupGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = cbInfoMoney
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
        Component = GoodsGroupGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GoodsGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = LocationGuides
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
      end
      item
        Component = UnitGroupGuides
        Properties.Strings = (
          'Key'
          'TextValue')
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
          ItemName = 'bbRefresh'
        end
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
          ItemName = 'bbPrintBy_Goods'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrintBy_Goods_Partion'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrintBy_Goods_Partion_Type'
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
      Action = actPrintBy_Goods
      Category = 0
    end
    object bbPrintBy_Goods_Partion: TdxBarButton
      Action = actPrintBy_Goods_Partion
      Category = 0
      Visible = ivNever
    end
    object bbPrintBy_Goods_Partion_Type: TdxBarButton
      Action = actPrintBy_Goods_Type
      Category = 0
    end
    object dxBarStatic: TdxBarStatic
      Category = 0
      Visible = ivAlways
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 256
    Top = 232
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = dsdStoredProc
      StoredProcList = <
        item
          StoredProc = dsdStoredProc
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
      Caption = #1044#1080#1072#1083#1086#1075' '#1091#1089#1090#1072#1085#1086#1074#1082#1080' '#1087#1072#1088#1072#1084#1077#1090#1088#1086#1074
      Hint = #1044#1080#1072#1083#1086#1075' '#1091#1089#1090#1072#1085#1086#1074#1082#1080' '#1087#1072#1088#1072#1084#1077#1090#1088#1086#1074
      ImageIndex = 35
      FormName = 'TReport_MotionGoodsDialogForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
        end
        item
          Name = 'GoodsId'
          Value = ''
          Component = GoodsGuides
          ComponentItem = 'Key'
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'GoodsName'
          Value = ''
          Component = GoodsGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'GoodsGroupId'
          Value = ''
          Component = GoodsGroupGuides
          ComponentItem = 'Key'
        end
        item
          Name = 'GoodsGroupName'
          Value = ''
          Component = GoodsGroupGuides
          ComponentItem = 'TextValue'
          DataType = ftString
        end
        item
          Name = 'UnitGroupId'
          Value = ''
          Component = UnitGroupGuides
          ComponentItem = 'Key'
        end
        item
          Name = 'UnitGroupName'
          Value = ''
          Component = UnitGroupGuides
          ComponentItem = 'TextValue'
          DataType = ftString
        end
        item
          Name = 'UnitId'
          Value = ''
          Component = LocationGuides
          ComponentItem = 'Key'
        end
        item
          Name = 'UnitName'
          Value = ''
          Component = LocationGuides
          ComponentItem = 'Key'
          DataType = ftString
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actPrintBy_Goods_Type: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100' '#1055#1077#1095#1072#1090#1100' '#1054#1090#1095#1077#1090' '#1076#1074#1080#1078#1077#1085#1080#1077' '#1087#1086' '#1090#1086#1074#1072#1088#1091' + '#1074#1080#1076' ('#1076#1083#1103' '#1074#1089#1077#1093')'
      Hint = #1055#1077#1095#1072#1090#1100' '#1055#1077#1095#1072#1090#1100' '#1054#1090#1095#1077#1090' '#1076#1074#1080#1078#1077#1085#1080#1077' '#1087#1086' '#1090#1086#1074#1072#1088#1091' + '#1074#1080#1076' ('#1076#1083#1103' '#1074#1089#1077#1093')'
      ImageIndex = 19
      ShortCut = 16464
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GoodsGroupName;GoodsName;GoodsKindName'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
        end
        item
          Name = 'ReportType'
          Value = '2'
          ParamType = ptInput
        end
        item
          Name = 'UnitName'
          Value = ''
          Component = UnitGroupGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1076#1074#1080#1078#1077#1085#1080#1077' '#1087#1086' '#1090#1086#1074#1072#1088#1091' ('#1076#1083#1103' '#1074#1089#1077#1093')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1076#1074#1080#1078#1077#1085#1080#1077' '#1087#1086' '#1090#1086#1074#1072#1088#1091' ('#1076#1083#1103' '#1074#1089#1077#1093')'
      ReportNameParam.DataType = ftString
    end
    object actPrintBy_Goods_Partion: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100' '#1055#1077#1095#1072#1090#1100' '#1054#1090#1095#1077#1090' '#1076#1074#1080#1078#1077#1085#1080#1077' '#1087#1086' '#1090#1086#1074#1072#1088#1091' + '#1087#1072#1088#1090#1080#1103' ('#1076#1083#1103' '#1074#1089#1077#1093')'
      Hint = #1055#1077#1095#1072#1090#1100' '#1054#1090#1095#1077#1090' '#1076#1074#1080#1078#1077#1085#1080#1077' '#1087#1086' '#1090#1086#1074#1072#1088#1091' + '#1087#1072#1088#1090#1080#1103' ('#1076#1083#1103' '#1074#1089#1077#1093')'
      ImageIndex = 16
      ShortCut = 16464
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GoodsGroupName;GoodsName;GoodsKindName'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
        end
        item
          Name = 'ReportType'
          Value = '1'
          ParamType = ptInput
        end
        item
          Name = 'UnitName'
          Value = ''
          Component = UnitGroupGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1076#1074#1080#1078#1077#1085#1080#1077' '#1087#1086' '#1090#1086#1074#1072#1088#1091' ('#1076#1083#1103' '#1074#1089#1077#1093')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1076#1074#1080#1078#1077#1085#1080#1077' '#1087#1086' '#1090#1086#1074#1072#1088#1091' ('#1076#1083#1103' '#1074#1089#1077#1093')'
      ReportNameParam.DataType = ftString
    end
    object actPrintBy_Goods: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100' '#1054#1090#1095#1077#1090' '#1076#1074#1080#1078#1077#1085#1080#1077' '#1087#1086' '#1090#1086#1074#1072#1088#1091' ('#1076#1083#1103' '#1074#1089#1077#1093')'
      Hint = #1055#1077#1095#1072#1090#1100' '#1054#1090#1095#1077#1090' '#1076#1074#1080#1078#1077#1085#1080#1077' '#1087#1086' '#1090#1086#1074#1072#1088#1091' ('#1076#1083#1103' '#1074#1089#1077#1093')'
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GoodsGroupName;GoodsName;GoodsKindName'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
        end
        item
          Name = 'ReportType'
          Value = '0'
          ParamType = ptInput
        end
        item
          Name = 'UnitName'
          Value = ''
          Component = UnitGroupGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1076#1074#1080#1078#1077#1085#1080#1077' '#1087#1086' '#1090#1086#1074#1072#1088#1091' ('#1076#1083#1103' '#1074#1089#1077#1093')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1076#1074#1080#1078#1077#1085#1080#1077' '#1087#1086' '#1090#1086#1074#1072#1088#1091' ('#1076#1083#1103' '#1074#1089#1077#1093')'
      ReportNameParam.DataType = ftString
    end
  end
  object dsdStoredProc: TdsdStoredProc
    StoredProcName = 'gpReport_MotionGoods'
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
      end
      item
        Name = 'inEndDate'
        Value = 41640d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inAccountGroupId'
        Value = Null
        Component = AccountGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inUnitGroupId'
        Value = ''
        Component = UnitGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inLocationId'
        Value = ''
        Component = LocationGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inGoodsGroupId'
        Value = ''
        Component = GoodsGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inGoodsId'
        Value = ''
        Component = GoodsGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inIsInfoMoney'
        Value = Null
        Component = cbInfoMoney
        DataType = ftBoolean
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 168
    Top = 192
  end
  object DBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    Left = 216
    Top = 264
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 344
    Top = 288
  end
  object GoodsGroupGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoodsGroup
    FormNameParam.Value = 'TGoodsGroup_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TGoodsGroup_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GoodsGroupGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 864
    Top = 65528
  end
  object LocationGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edLocation
    FormNameParam.Value = 'TStoragePlace_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TStoragePlace_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = LocationGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = LocationGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 496
    Top = 24
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 112
    Top = 120
  end
  object UnitGroupGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnitGroup
    FormNameParam.Value = 'TUnitTreeForm'
    FormNameParam.DataType = ftString
    FormName = 'TUnitTreeForm'
    PositionDataSet = 'ClientDataSet'
    ParentDataSet = 'TreeDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = UnitGroupGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = UnitGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 568
  end
  object GoodsGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoods
    FormNameParam.Value = 'TGoodsFuel_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TGoodsFuel_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GoodsGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 904
    Top = 27
  end
  object RefreshDispatcher: TRefreshDispatcher
    RefreshAction = actRefresh
    ShowDialogAction = ExecuteDialog
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = AccountGroupGuides
      end
      item
        Component = UnitGroupGuides
      end
      item
        Component = LocationGuides
      end
      item
        Component = GoodsGroupGuides
      end
      item
        Component = GoodsGuides
      end>
    Left = 144
    Top = 344
  end
  object AccountGroupGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceAccountGroup
    FormNameParam.Value = 'TAccountGroup_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TAccountGroup_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = AccountGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = AccountGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'AccountDirectionId'
        Value = ''
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'AccountDirectionName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'AccountId'
        Value = ''
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'AccountName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 192
    Top = 21
  end
end
