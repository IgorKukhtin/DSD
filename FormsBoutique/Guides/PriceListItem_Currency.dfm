object PriceListItem_CurrencyForm: TPriceListItem_CurrencyForm
  Left = 0
  Top = 0
  Caption = #1055#1088#1072#1081#1089' '#1083#1080#1089#1090' - '#1055#1088#1086#1089#1084#1086#1090#1088' / '#1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1074#1072#1083#1102#1090#1099
  ClientHeight = 398
  ClientWidth = 996
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = actRefreshStart
  AddOnFormData.isSingle = False
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid: TcxGrid
    Left = 0
    Top = 88
    Width = 996
    Height = 310
    Align = alClient
    TabOrder = 0
    LookAndFeel.NativeStyle = True
    LookAndFeel.SkinName = 'UserSkin'
    ExplicitLeft = -8
    ExplicitTop = 86
    object cxGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = DataSource
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Summary.DefaultGroupSummaryItems = <
        item
          Format = ',0.####'
          Kind = skSum
          Column = Remains
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = AmountDebt
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = RemainsAll
        end>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = 'C'#1090#1088#1086#1082': ,0'
          Kind = skCount
          Column = GoodsName
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Remains
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = AmountDebt
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = RemainsAll
        end>
      DataController.Summary.SummaryGroups = <>
      Images = dmMain.SortImageList
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsView.Footer = True
      OptionsView.GroupByBox = False
      OptionsView.HeaderHeight = 40
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object UnitName: TcxGridDBColumn
        Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
        DataBinding.FieldName = 'UnitName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object BrandName: TcxGridDBColumn
        Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072
        DataBinding.FieldName = 'BrandName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 95
      end
      object PeriodName: TcxGridDBColumn
        Caption = #1057#1077#1079#1086#1085
        DataBinding.FieldName = 'PeriodName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object PeriodYear: TcxGridDBColumn
        Caption = #1043#1086#1076
        DataBinding.FieldName = 'PeriodYear'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object GoodsGroupNameFull: TcxGridDBColumn
        Caption = #1043#1088#1091#1087#1087#1072
        DataBinding.FieldName = 'GoodsGroupNameFull'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object LabelName: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'LabelName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 80
      end
      object GoodsCode: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'GoodsCode'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 50
      end
      object GoodsName: TcxGridDBColumn
        Caption = #1040#1088#1090#1080#1082#1091#1083
        DataBinding.FieldName = 'GoodsName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object PriceTax: TcxGridDBColumn
        Caption = '% '#1085#1072#1094'.'
        DataBinding.FieldName = 'PriceTax'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = '% '#1085#1072#1094#1077#1085#1082#1080
        Options.Editing = False
        Width = 45
      end
      object DiscountTax: TcxGridDBColumn
        Caption = '% '#1089#1082'.'
        DataBinding.FieldName = 'DiscountTax'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = '% '#1057#1077#1079#1086#1085#1085#1086#1081' '#1089#1082#1080#1076#1082#1080
        Options.Editing = False
        Width = 45
      end
      object isDiscount: TcxGridDBColumn
        Caption = #1062#1077#1085#1072' '#1089#1086' '#1089#1082#1080#1076#1082#1086#1081
        DataBinding.FieldName = 'isDiscount'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1062#1077#1085#1072' '#1089#1086' '#1089#1082#1080#1076#1082#1086#1081' ('#1076#1072'/'#1085#1077#1090')'
        Width = 73
      end
      object RemainsAll: TcxGridDBColumn
        Caption = #1054#1089#1090'. '#1080#1090#1086#1075#1086
        DataBinding.FieldName = 'RemainsAll'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1083'-'#1074#1086' '#1086#1089#1090#1072#1090#1086#1082' '#1080#1090#1086#1075#1086
        Options.Editing = False
        Width = 55
      end
      object Remains: TcxGridDBColumn
        Caption = #1054#1089#1090'. '#1074' '#1084#1072#1075'.'
        DataBinding.FieldName = 'Remains'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Properties.ReadOnly = True
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1083'-'#1074#1086' '#1086#1089#1090#1072#1090#1086#1082' '#1074' '#1084#1072#1075#1072#1079#1080#1085#1077
        Options.Editing = False
        Width = 55
      end
      object AmountDebt: TcxGridDBColumn
        Caption = #1054#1089#1090'. '#1076#1086#1083#1075
        DataBinding.FieldName = 'AmountDebt'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1083'-'#1074#1086' '#1076#1086#1083#1075#1080' '#1087#1086' '#1084#1072#1075#1072#1079#1080#1085#1091
        Options.Editing = False
        Width = 55
      end
      object CurrencyName: TcxGridDBColumn
        Caption = #1042#1072#1083'. '#1074#1093'.'
        DataBinding.FieldName = 'CurrencyName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 40
      end
      object OperPrice: TcxGridDBColumn
        Caption = #1062#1077#1085#1072' '#1074#1093'.'
        DataBinding.FieldName = 'OperPrice'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object OperPriceBalance: TcxGridDBColumn
        Caption = #1062#1077#1085#1072' '#1074#1093'. '#1043#1056#1053
        DataBinding.FieldName = 'OperPriceBalance'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1062#1077#1085#1072' '#1074#1093'. '#1043#1056#1053
        Options.Editing = False
        Width = 55
      end
      object CurrencyName_price: TcxGridDBColumn
        Caption = #1042#1072#1083'. '#1087#1088#1072#1081#1089
        DataBinding.FieldName = 'CurrencyName_price'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actChoiceCurrency
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1042#1072#1083#1102#1090#1072' '#1087#1088#1072#1081#1089#1072
        Width = 55
      end
      object ValuePrice: TcxGridDBColumn
        Caption = #1062#1077#1085#1072' '#1087#1086' '#1087#1088#1072#1081#1089#1091
        DataBinding.FieldName = 'ValuePrice'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1062#1077#1085#1072' '#1087#1086' '#1087#1088#1072#1081#1089#1091
        Width = 55
      end
      object GoodsGroupName: TcxGridDBColumn
        Caption = #1043#1088#1091#1087#1087#1072' ('#1090#1086#1074'.)'
        DataBinding.FieldName = 'GoodsGroupName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 95
      end
      object StartDate: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' '#1089
        DataBinding.FieldName = 'StartDate'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object EndDate: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' '#1087#1086
        DataBinding.FieldName = 'EndDate'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object CompositionGroupName: TcxGridDBColumn
        Caption = #1043#1088#1091#1087#1087#1072' '#1089#1086#1089#1090#1072#1074#1072
        DataBinding.FieldName = 'CompositionGroupName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 73
      end
      object CompositionName: TcxGridDBColumn
        Caption = #1057#1086#1089#1090#1072#1074
        DataBinding.FieldName = 'CompositionName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 73
      end
      object GoodsInfoName: TcxGridDBColumn
        Caption = #1054#1087#1080#1089#1072#1085#1080#1077
        DataBinding.FieldName = 'GoodsInfoName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 70
      end
      object LineFabricaName: TcxGridDBColumn
        Caption = #1051#1080#1085#1080#1103
        DataBinding.FieldName = 'LineFabricaName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 55
      end
      object FabrikaName: TcxGridDBColumn
        Caption = #1060#1072#1073#1088#1080#1082#1072
        DataBinding.FieldName = 'FabrikaName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 115
      end
      object MeasureName: TcxGridDBColumn
        Caption = #1045#1076'. '#1080#1079#1084'.'
        DataBinding.FieldName = 'MeasureName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 60
      end
      object CurrencyValue: TcxGridDBColumn
        Caption = #1050#1091#1088#1089
        DataBinding.FieldName = 'CurrencyValue'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 45
      end
      object ParValue: TcxGridDBColumn
        Caption = #1053#1086#1084#1080#1085#1072#1083
        DataBinding.FieldName = 'ParValue'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 45
      end
      object OperPriceList_fp: TcxGridDBColumn
        Caption = #1055#1077#1088#1074#1072#1103' '#1094#1077#1085#1072
        DataBinding.FieldName = 'OperPriceList_fp'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1055#1077#1088#1074#1072#1103' '#1094#1077#1085#1072
        Options.Editing = False
        Width = 70
      end
      object CurrencyName_fp: TcxGridDBColumn
        Caption = #1042#1072#1083#1102#1090#1072' ('#1087#1077#1088#1074#1072#1103' '#1094#1077#1085#1072')'
        DataBinding.FieldName = 'CurrencyName_fp'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1042#1072#1083#1102#1090#1072' ('#1087#1077#1088#1074#1072#1103' '#1094#1077#1085#1072')'
        Options.Editing = False
        Width = 95
      end
      object Persent_diff: TcxGridDBColumn
        Caption = '% '#1080#1079#1084'. '#1086#1090' '#1087#1077#1088#1074#1086#1081' '#1094#1077#1085#1099
        DataBinding.FieldName = 'Persent_diff'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.##;-,0.##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = '% '#1080#1079#1084#1077#1085#1077#1085#1080#1103' '#1086#1090' '#1087#1077#1088#1074#1086#1081' '#1094#1077#1085#1099
        Options.Editing = False
        Width = 98
      end
      object isCurrency_diff: TcxGridDBColumn
        Caption = #1048#1079#1084'. '#1074#1072#1083#1102#1090#1072' ('#1076#1072'/'#1085#1077#1090')'
        DataBinding.FieldName = 'isCurrency_diff'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1048#1079#1084#1077#1085#1080#1083#1072#1089#1100' '#1074#1072#1083#1102#1090#1072' '#1076#1072'/'#1085#1077#1090
        Options.Editing = False
        Width = 100
      end
      object InsertDate: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' ('#1089#1086#1079#1076'.)'
        DataBinding.FieldName = 'InsertDate'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 48
      end
      object InsertName: TcxGridDBColumn
        Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076'.)'
        DataBinding.FieldName = 'InsertName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object UpdateDate: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' ('#1082#1086#1088#1088'.)'
        DataBinding.FieldName = 'UpdateDate'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 48
      end
      object UpdateName: TcxGridDBColumn
        Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1082#1086#1088#1088'.)'
        DataBinding.FieldName = 'UpdateName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object isErased: TcxGridDBColumn
        Caption = #1059#1076#1072#1083#1077#1085
        DataBinding.FieldName = 'isErased'
        Visible = False
        Options.Editing = False
        Width = 20
      end
      object ObjectId: TcxGridDBColumn
        DataBinding.FieldName = 'ObjectId'
        Visible = False
        Options.Editing = False
        VisibleForCustomization = False
        Width = 20
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object Panel: TPanel
    Left = 0
    Top = 26
    Width = 996
    Height = 62
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object cxLabel1: TcxLabel
      Left = 26
      Top = 11
      Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090':'
    end
    object edPriceList: TcxButtonEdit
      Left = 93
      Top = 9
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = False
      TabOrder = 1
      Width = 180
    end
    object edShowDate: TcxDateEdit
      Left = 726
      Top = 9
      EditValue = 43831d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 2
      Width = 96
    end
    object cxLabel2: TcxLabel
      Left = 632
      Top = 10
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1094#1077#1085' '#1085#1072':'
    end
    object cxLabel4: TcxLabel
      Left = 3
      Top = 37
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
    end
    object edUnit: TcxButtonEdit
      Left = 93
      Top = 36
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 180
    end
    object cxLabel5: TcxLabel
      Left = 278
      Top = 11
      Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072':'
    end
    object edBrand: TcxButtonEdit
      Left = 368
      Top = 10
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 140
    end
    object cxLabel6: TcxLabel
      Left = 325
      Top = 37
      Caption = #1057#1077#1079#1086#1085' :'
    end
    object edPeriod: TcxButtonEdit
      Left = 368
      Top = 36
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 9
      Width = 140
    end
    object cxLabel7: TcxLabel
      Left = 515
      Top = 11
      Caption = #1043#1086#1076' '#1089' ...'
    end
    object edStartYear: TcxButtonEdit
      Left = 567
      Top = 9
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 11
      Width = 52
    end
    object cxLabel8: TcxLabel
      Left = 512
      Top = 37
      Caption = #1043#1086#1076' '#1087#1086' ...'
    end
    object edEndYear: TcxButtonEdit
      Left = 567
      Top = 36
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 13
      Width = 52
    end
    object cxLabel9: TcxLabel
      Left = 828
      Top = 37
      Caption = #1050#1086#1101#1092#1092'. '#1086#1090' '#1074#1093'. '#1094#1077#1085#1099
    end
    object edPriceTax: TcxCurrencyEdit
      Left = 934
      Top = 35
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####'
      Properties.UseDisplayFormatWhenEditing = True
      TabOrder = 15
      Width = 58
    end
    object cbisChangePrice: TcxCheckBox
      Left = 831
      Top = 8
      Caption = #1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1094#1077#1085#1099
      TabOrder = 16
      Width = 133
    end
  end
  object cxLabel3: TcxLabel
    Left = 625
    Top = 63
    Caption = #1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1094#1077#1085#1099' '#1089':'
  end
  object edOperDate: TcxDateEdit
    Left = 726
    Top = 62
    EditValue = 43831d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 7
    Width = 96
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 48
    Top = 216
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 40
    Top = 160
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = edOperDate
        Properties.Strings = (
          'Date')
      end
      item
        Component = edShowDate
        Properties.Strings = (
          'Date')
      end
      item
        Component = GuidesPriceList
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
        Component = GuidesUnit
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesBrand
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesPeriod
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesStartYear
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesEndYear
        Properties.Strings = (
          'Key'
          'TextValue')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 392
    Top = 184
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
    Left = 248
    Top = 168
    DockControlHeights = (
      0
      0
      26
      0)
    object dxBarManagerBar1: TdxBar
      Caption = 'Custom'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 416
      FloatTop = 259
      FloatClientWidth = 51
      FloatClientHeight = 59
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbExecuteDialog'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPriceListGoodsItem'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbShowAll'
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
          ItemName = 'bbPriceListTaxDialog'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsertUpdate_Price'
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
          ItemName = 'bbProtocol'
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
      NotDocking = [dsLeft]
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
      Action = actGridToExcel
      Category = 0
    end
    object dxBarStatic: TdxBarStatic
      Caption = '       '
      Category = 0
      Hint = '       '
      Visible = ivAlways
      ShowCaption = False
    end
    object bbPriceListGoodsItem: TdxBarButton
      Action = actPriceListGoods
      Category = 0
    end
    object bbShowAll: TdxBarButton
      Action = actShowAll
      Category = 0
    end
    object bbProtocol: TdxBarButton
      Action = actProtocol
      Category = 0
    end
    object bbPriceListTaxDialog: TdxBarButton
      Action = actPriceListTaxDialoglOpenForm
      Category = 0
    end
    object bbPrint: TdxBarButton
      Action = actPrint
      Category = 0
      ImageIndex = 3
      UnclickAfterDoing = False
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbInsertUpdate_Price: TdxBarButton
      Action = macInsertUpdate_Price
      Category = 0
    end
    object bbReport_Goods: TdxBarButton
      Action = actReport_Goods
      Category = 0
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 312
    Top = 176
    object actRefreshStart: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet_Current_Date
      StoredProcList = <
        item
          StoredProc = spGet_Current_Date
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actGridToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      MoveParams = <>
      Grid = cxGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object actPriceListGoods: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088'/'#1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1080#1089#1090#1086#1088#1080#1080
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088'/'#1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1080#1089#1090#1086#1088#1080#1080
      ImageIndex = 28
      FormName = 'TPriceListGoodsItemForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'PriceListId'
          Value = '0'
          Component = GuidesPriceList
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PriceListName'
          Value = ''
          Component = GuidesPriceList
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'GoodsNameFull'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actUpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = 'actUpdateDataSet'
      DataSource = DataSource
    end
    object actShowAll: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077' '#1090#1086#1074#1072#1088#1099
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077' '#1090#1086#1074#1072#1088#1099
      ImageIndex = 63
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1087#1091#1089#1090#1099#1077' '#1094#1077#1085#1099
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077' '#1090#1086#1074#1072#1088#1099
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1087#1091#1089#1090#1099#1077' '#1094#1077#1085#1099
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077' '#1090#1086#1074#1072#1088#1099
      ImageIndexTrue = 62
      ImageIndexFalse = 63
    end
    object actProtocol: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072
      ImageIndex = 34
      FormName = 'TProtocolForm'
      FormNameParam.Value = 'TProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'ObjectId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = GuidesPriceList
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actPriceListTaxDialoglOpenForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1077#1088#1077#1086#1094#1077#1085#1082#1072' '#1085#1072' '#1086#1089#1085#1086#1074#1072#1085#1080#1080
      Hint = #1055#1077#1088#1077#1086#1094#1077#1085#1082#1072' '#1085#1072' '#1086#1089#1085#1086#1074#1072#1085#1080#1080
      ImageIndex = 74
      FormName = 'TPriceListTaxDialogForm'
      FormNameParam.Value = 'TPriceListTaxDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'PriceListId'
          Value = '0'
          Component = GuidesPriceList
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PriceListName'
          Value = ''
          Component = GuidesPriceList
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDate'
          Value = Null
          Component = edOperDate
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitId'
          Value = Null
          Component = GuidesUnit
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = Null
          Component = GuidesUnit
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'BrandId'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'BrandId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'BrandName'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'BrandName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PeriodId'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'PeriodId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PeriodName'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'PeriodName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PeriodYear'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'PeriodYear'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'LineFabricaId'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'LineFabricaId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'LineFabricaName'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'LineFabricaName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupId'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'GoodsGroupId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'GoodsGroupName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'LabelId'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'LabelId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'LabelName'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'LabelName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = dsdStoredProcPrint
      StoredProcList = <
        item
          StoredProc = dsdStoredProcPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1087#1088#1072#1081#1089#1072
      Hint = #1055#1077#1095#1072#1090#1100' '#1087#1088#1072#1081#1089#1072
      ImageIndex = 19
      DataSets = <
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GoodsGroupNameFull;GoodsName'
        end>
      Params = <
        item
          Name = 'PriceListName'
          Value = Null
          Component = GuidesPriceList
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ShowDate'
          Value = 42339d
          Component = edShowDate
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintObjectHistory_PriceListItem'
      ReportNameParam.Name = 'PrintObjectHistory_PriceListItem'
      ReportNameParam.Value = 'PrintObjectHistory_PriceListItem'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099
      ImageIndex = 35
      FormName = 'TPriceListItemDialogForm'
      FormNameParam.Value = 'TPriceListItemDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'ShowDate'
          Value = 42856d
          Component = edShowDate
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitId'
          Value = '0'
          Component = GuidesUnit
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'BrandId'
          Value = '0'
          Component = GuidesBrand
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'BrandName'
          Value = ''
          Component = GuidesBrand
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PeriodId'
          Value = '0'
          Component = GuidesPeriod
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PeriodName'
          Value = ''
          Component = GuidesPeriod
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'StartYear'
          Value = '0'
          Component = GuidesStartYear
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'StartYearText'
          Value = Null
          Component = GuidesStartYear
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndYear'
          Value = ''
          Component = GuidesEndYear
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndYearText'
          Value = Null
          Component = GuidesEndYear
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PriceListId'
          Value = Null
          Component = GuidesPriceList
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PriceListName'
          Value = Null
          Component = GuidesPriceList
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actInsertUpdate_Price: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate_Price
      StoredProcList = <
        item
          StoredProc = spInsertUpdate_Price
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1085#1086#1074#1091#1102' '#1094#1077#1085#1091
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1085#1086#1074#1091#1102' '#1094#1077#1085#1091
    end
    object macInsertUpdate_Price: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = ExecuteDialogPriceTax
        end
        item
          Action = macInsertUpdate_Price_List
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1062#1077#1085#1099' '#1073#1091#1076#1091#1090' '#1086#1073#1085#1086#1074#1083#1077#1085#1099', '#1087#1088#1086#1076#1086#1083#1078#1080#1090#1100'?'
      InfoAfterExecute = #1054#1073#1085#1086#1074#1083#1077#1085#1080#1077' '#1094#1077#1085' '#1086#1082#1086#1085#1095#1077#1085#1086'.'
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1085#1086#1074#1091#1102' '#1094#1077#1085#1091
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1085#1086#1074#1091#1102' '#1094#1077#1085#1091' ('#1074#1093'.'#1094#1077#1085#1072' * '#1082#1086#1101#1092'.)'
      ImageIndex = 76
    end
    object macInsertUpdate_Price_List: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actInsertUpdate_Price
        end>
      View = cxGridDBTableView
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1085#1086#1074#1091#1102' '#1094#1077#1085#1091
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1085#1086#1074#1091#1102' '#1094#1077#1085#1091' ('#1074#1093'.'#1094#1077#1085#1072' * '#1082#1086#1101#1092'.)'
      ImageIndex = 76
    end
    object ExecuteDialogPriceTax: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1050#1086#1101#1092#1092'. '#1086#1090' '#1074#1093'. '#1094#1077#1085#1099
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1050#1086#1101#1092#1092'. '#1086#1090' '#1074#1093'. '#1094#1077#1085#1099
      ImageIndex = 35
      FormName = 'TDiscountPersentDialogForm'
      FormNameParam.Value = 'TDiscountPersentDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'ParamValue'
          Value = 0.000000000000000000
          Component = edPriceTax
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ParamName'
          Value = #1050#1086#1101#1092#1092'. '#1086#1090' '#1074#1093'. '#1094#1077#1085#1099
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actChoiceCurrency: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'CurrencyForm'
      FormName = 'TCurrencyForm'
      FormNameParam.Value = 'TCurrencyForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'CurrencyId_price'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'CurrencyName_price'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actReport_Goods: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' <'#1044#1074#1080#1078#1077#1085#1080#1077' '#1090#1086#1074#1072#1088#1072'>'
      Hint = #1054#1090#1095#1077#1090' <'#1044#1074#1080#1078#1077#1085#1080#1077' '#1090#1086#1074#1072#1088#1072'>'
      ImageIndex = 40
      FormName = 'TReport_GoodsForm'
      FormNameParam.Value = 'TReport_GoodsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'LocationId'
          Value = '0'
          Component = ClientDataSet
          ComponentItem = 'UnitId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationName'
          Value = ''
          Component = ClientDataSet
          ComponentItem = 'UnitName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'GoodsId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'GoodsName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsSizeId'
          Value = '0'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsSizeName'
          Value = Null
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartionId'
          Value = '0'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPeriod'
          Value = True
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPartion'
          Value = True
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MovementId'
          Value = '0'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumber'
          Value = Null
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
  end
  object spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_ObjectHistory_PriceListItem'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <
      item
        Name = 'inPriceListId'
        Value = '0'
        Component = GuidesPriceList
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBrandId'
        Value = Null
        Component = GuidesBrand
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPeriodId'
        Value = Null
        Component = GuidesPeriod
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 41275d
        Component = edShowDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartYear'
        Value = Null
        Component = GuidesStartYear
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndYear'
        Value = Null
        Component = GuidesEndYear
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inShowAll'
        Value = Null
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 128
    Top = 216
  end
  object dsdDBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = True
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <
      item
        Column = GoodsCode
        FindByFullValue = True
        onExitColumn.Active = False
        onExitColumn.AfterEmptyValue = False
      end>
    ColumnEnterList = <
      item
        Column = GoodsCode
      end
      item
        Column = ValuePrice
      end>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 192
    Top = 256
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 312
    Top = 232
  end
  object GuidesPriceList: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPriceList
    Key = '0'
    FormNameParam.Value = 'TPriceListForm123'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPriceListForm123'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GuidesPriceList
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPriceList
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitId'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 192
    Top = 24
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpUpdate_OH_PriceListItem_Currency'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'CurrencyId_price'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceListId'
        Value = Null
        Component = GuidesPriceList
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = Null
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outStartDate'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'StartDate'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'outEndDate'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'EndDate'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioValue'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'ValuePrice'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsLast'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisChangePrice'
        Value = Null
        Component = cbisChangePrice
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDiscount'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'isDiscount'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 88
    Top = 272
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = GuidesPriceList
      end
      item
        Component = GuidesUnit
      end
      item
        Component = GuidesBrand
      end
      item
        Component = GuidesPeriod
      end
      item
        Component = GuidesEndYear
      end
      item
        Component = GuidesStartYear
      end>
    Left = 536
    Top = 168
  end
  object dsdStoredProcPrint: TdsdStoredProc
    StoredProcName = 'gpSelect_ObjectHistory_PriceListItem_Print'
    DataSet = PrintItemsCDS
    DataSets = <
      item
        DataSet = PrintItemsCDS
      end>
    Params = <
      item
        Name = 'inPriceListId'
        Value = '0'
        Component = GuidesPriceList
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 42005d
        Component = edShowDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 144
    Top = 160
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 708
    Top = 270
  end
  object GuidesUnit: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnit
    Key = '0'
    FormNameParam.Value = 'TUnitForm123'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnitForm123'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceListId'
        Value = Null
        Component = GuidesPriceList
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceListName'
        Value = Null
        Component = GuidesPriceList
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 392
    Top = 24
  end
  object GuidesBrand: TdsdGuides
    KeyField = 'Id'
    LookupControl = edBrand
    Key = '0'
    FormNameParam.Value = 'TBrandForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBrandForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GuidesBrand
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesBrand
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 150
    Top = 66
  end
  object GuidesPeriod: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPeriod
    Key = '0'
    FormNameParam.Value = 'TPeriodForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPeriodForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GuidesPeriod
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPeriod
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 590
    Top = 122
  end
  object GuidesStartYear: TdsdGuides
    KeyField = 'Id'
    LookupControl = edStartYear
    Key = '0'
    FormNameParam.Value = 'TPeriodYear_ChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPeriodYear_ChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = '2000'
        Component = GuidesStartYear
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = Null
        Component = GuidesStartYear
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 402
    Top = 121
  end
  object GuidesEndYear: TdsdGuides
    KeyField = 'Id'
    LookupControl = edEndYear
    Key = '0'
    FormNameParam.Value = 'TPeriodYear_ChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPeriodYear_ChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = '2018'
        Component = GuidesEndYear
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = Null
        Component = GuidesEndYear
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 493
    Top = 123
  end
  object spInsertUpdate_Price: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_OH_PriceListItemTax'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inPriceListId'
        Value = Null
        Component = GuidesPriceList
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = 'FALSE'
        Component = ClientDataSet
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = Null
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperPrice'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'OperPrice'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTax'
        Value = Null
        Component = edPriceTax
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 512
    Top = 275
  end
  object spGet_Current_Date: TdsdStoredProc
    StoredProcName = 'gpGet_Current_Date'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'gpGet_Current_Date'
        Value = Null
        Component = edOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 784
    Top = 184
  end
end
