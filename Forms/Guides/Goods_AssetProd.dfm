object Goods_AssetProdForm: TGoods_AssetProdForm
  Left = 0
  Top = 0
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <T'#1086#1074#1072#1088#1099' ('#1087#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100#1085#1086#1089#1090#1100' '#1054#1057')>'
  ClientHeight = 404
  ClientWidth = 982
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.isAlwaysRefresh = False
  AddOnFormData.RefreshAction = actRefresh
  AddOnFormData.ChoiceAction = dsdChoiceGuides
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid: TcxGrid
    Left = 0
    Top = 26
    Width = 982
    Height = 378
    Align = alClient
    TabOrder = 0
    LookAndFeel.NativeStyle = False
    object cxGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = DataSource
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Filter.Active = True
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = 'C'#1090#1088#1086#1082': ,0'
          Kind = skCount
          Column = Name
        end>
      DataController.Summary.SummaryGroups = <>
      Images = dmMain.SortImageList
      OptionsBehavior.IncSearch = True
      OptionsBehavior.IncSearchItem = Name
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsView.Footer = True
      OptionsView.HeaderHeight = 40
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object GoodsPlatformName: TcxGridDBColumn
        Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1077#1085#1085#1072#1103' '#1087#1083#1086#1097#1072#1076#1082#1072
        DataBinding.FieldName = 'GoodsPlatformName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 120
      end
      object TradeMarkName: TcxGridDBColumn
        Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072
        DataBinding.FieldName = 'TradeMarkName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object GoodsGroupAnalystName: TcxGridDBColumn
        Caption = #1043#1088#1091#1087#1087#1072' '#1072#1085#1072#1083#1080#1090#1080#1082#1080
        DataBinding.FieldName = 'GoodsGroupAnalystName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object GoodsTagName: TcxGridDBColumn
        Caption = #1055#1088#1080#1079#1085#1072#1082' '#1090#1086#1074#1072#1088#1072
        DataBinding.FieldName = 'GoodsTagName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object GroupStatName: TcxGridDBColumn
        Caption = #1043#1088#1091#1087#1087#1072' '#1089#1090#1072#1090#1080#1089#1090#1080#1082#1080
        DataBinding.FieldName = 'GroupStatName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object GoodsGroupNameFull: TcxGridDBColumn
        Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
        DataBinding.FieldName = 'GoodsGroupNameFull'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 150
      end
      object GoodsGroupName: TcxGridDBColumn
        Caption = #1043#1088#1091#1087#1087#1072
        DataBinding.FieldName = 'GoodsGroupName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 172
      end
      object Code: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'Code'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 63
      end
      object Name: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'Name'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 206
      end
      object Name_RUS: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1090#1086#1074#1072#1088#1072' ('#1088#1091#1089#1089'.)'
        DataBinding.FieldName = 'Name_RUS'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1053#1072#1079#1074#1072#1085#1080#1077' '#1090#1086#1074#1072#1088#1072'('#1088#1091#1089#1089'.)'
        Options.Editing = False
        Width = 158
      end
      object AssetName: TcxGridDBColumn
        Caption = #1054#1089#1085#1086#1074#1085#1086#1077' '#1089#1088#1077#1076#1089#1090#1074#1086' ('#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077' '#1058#1052#1062')'
        DataBinding.FieldName = 'AssetName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1054#1089#1085#1086#1074#1085#1086#1077' '#1089#1088#1077#1076#1089#1090#1074#1086' ('#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077' '#1058#1052#1062')'
        Options.Editing = False
        Width = 150
      end
      object AssetProdName: TcxGridDBColumn
        Caption = #1054#1089#1085#1086#1074#1085#1086#1077' '#1089#1088#1077#1076#1089#1090#1074#1086'  ('#1085#1072' '#1082#1086#1090#1086#1088#1086#1084' '#1087#1088#1086#1080#1079#1074#1086#1076#1080#1090#1089#1103')'
        DataBinding.FieldName = 'AssetProdName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actOpenAssetChoiceForm
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1054#1089#1085#1086#1074#1085#1086#1077' '#1089#1088#1077#1076#1089#1090#1074#1086'  ('#1085#1072' '#1082#1086#1090#1086#1088#1086#1084' '#1087#1088#1086#1080#1079#1074#1086#1076#1080#1090#1089#1103')'
        Width = 150
      end
      object MeasureName: TcxGridDBColumn
        Caption = #1045#1076'. '#1080#1079#1084'.'
        DataBinding.FieldName = 'MeasureName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object Weight: TcxGridDBColumn
        Caption = #1042#1077#1089
        DataBinding.FieldName = 'Weight'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 45
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
      object CountForWeight: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1076#1083#1103' '#1042#1077#1089#1072
        DataBinding.FieldName = 'CountForWeight'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 72
      end
      object CountReceipt: TcxGridDBColumn
        Caption = #1050#1086#1083'. '#1087#1072#1088#1090'. '#1076#1083#1103' '#1079#1072#1084#1077#1089#1072
        DataBinding.FieldName = 'CountReceipt'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1083'-'#1074#1086' '#1087#1072#1088#1090#1080#1081' '#1076#1083#1103' '#1079#1072#1084#1077#1089#1072
        Width = 96
      end
      object Value_min: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1084#1080#1085' ('#1088#1077#1094#1077#1087#1090'.)'
        DataBinding.FieldName = 'Value_min'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.##;-,0.##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 84
      end
      object Value_max: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1084#1072#1082#1089' ('#1088#1077#1094#1077#1087#1090'.)'
        DataBinding.FieldName = 'Value_max'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.##;-,0.##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 99
      end
      object isValue_diff: TcxGridDBColumn
        Caption = #1054#1090#1082#1083' '#1082#1086#1083'-'#1074#1072' ('#1088#1077#1094#1077#1087#1090'.)'
        DataBinding.FieldName = 'isValue_diff'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1054#1090#1082#1083#1086#1085#1077#1085#1080#1077' '#1084#1080#1085' '#1080' '#1084#1072#1082#1089' '#1082#1086#1083'-'#1074#1072' ('#1088#1077#1094#1077#1087#1090'.)'
        Options.Editing = False
        Width = 99
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
      object isCheck_basis: TcxGridDBColumn
        Caption = #1088#1072#1079#1085'. ('#1094#1077#1093')'
        DataBinding.FieldName = 'isCheck_basis'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object isCheck_main: TcxGridDBColumn
        Caption = #1088#1072#1079#1085'. ('#1085#1072' '#1091#1087#1072#1082'.)'
        DataBinding.FieldName = 'isCheck_main'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object FuelName: TcxGridDBColumn
        Caption = #1042#1080#1076' '#1090#1086#1087#1083#1080#1074#1072
        DataBinding.FieldName = 'FuelName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object BusinessName: TcxGridDBColumn
        Caption = #1041#1080#1079#1085#1077#1089
        DataBinding.FieldName = 'BusinessName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object InfoMoneyCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1059#1055
        DataBinding.FieldName = 'InfoMoneyCode'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object InfoMoneyGroupName: TcxGridDBColumn
        Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
        DataBinding.FieldName = 'InfoMoneyGroupName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
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
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object IsPartionCount: TcxGridDBColumn
        Caption = #1055#1072#1088#1090#1080#1103' '#1082#1086#1083'-'#1074#1086
        DataBinding.FieldName = 'isPartionCount'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object IsPartionSumm: TcxGridDBColumn
        Caption = #1055#1072#1088#1090#1080#1103' '#1089#1091#1084#1084#1072
        DataBinding.FieldName = 'isPartionSumm'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object IsErased: TcxGridDBColumn
        Caption = #1059#1076#1072#1083#1077#1085
        DataBinding.FieldName = 'isErased'
        PropertiesClassName = 'TcxCheckBoxProperties'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 40
      end
      object InDate: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' '#1087#1088'. '#1086#1090' '#1087#1086#1089#1090'.'
        DataBinding.FieldName = 'InDate'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1044#1072#1090#1072' '#1087#1088#1080#1093#1086#1076#1072' '#1086#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072' ('#1087#1086#1089#1083#1077#1076#1085#1080#1081')'
        Options.Editing = False
        Width = 80
      end
      object PartnerInName: TcxGridDBColumn
        Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
        DataBinding.FieldName = 'PartnerInName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1055#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072' ('#1087#1086#1089#1083#1077#1076#1085#1080#1081')'
        Options.Editing = False
        Width = 80
      end
      object AmountIn: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1087#1088#1080#1093#1086#1076
        DataBinding.FieldName = 'AmountIn'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1083'-'#1074#1086' '#1087#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072' ('#1087#1086#1089#1083#1077#1076#1085#1080#1081')'
        Options.Editing = False
        Width = 70
      end
      object PriceIn: TcxGridDBColumn
        Caption = #1062#1077#1085#1072' '#1089' '#1053#1044#1057' '#1080' '#1089#1082'.'
        DataBinding.FieldName = 'PriceIn'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1062#1077#1085#1072' '#1089' '#1053#1044#1057' '#1080' '#1089#1082#1080#1076#1082#1086#1081' '#1087#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072' ('#1087#1086#1089#1083#1077#1076#1085#1080#1081')'
        Options.Editing = False
        Width = 70
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object cxLabel6: TcxLabel
    Left = 368
    Top = 109
    AutoSize = False
    Caption = #1054#1057':'
    Height = 19
    Width = 33
  end
  object edAssetProd: TcxButtonEdit
    Left = 407
    Top = 108
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 3
    Width = 186
  end
  object cxLabel13: TcxLabel
    Left = 611
    Top = 107
    Hint = #1050#1086#1083'-'#1074#1086' '#1087#1072#1088#1090#1080#1081' '#1087#1086' '#1088#1077#1094#1077#1087#1090#1091#1088#1077
    Caption = #1050#1086#1083'-'#1074#1086' '#1087#1072#1088#1090#1080#1081' '#1087#1086' '#1088#1077#1094'.'
    ParentShowHint = False
    ShowHint = True
  end
  object edCountReceipt: TcxCurrencyEdit
    Left = 611
    Top = 125
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    TabOrder = 8
    Width = 46
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 40
    Top = 272
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 112
    Top = 216
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
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
    Left = 80
    Top = 88
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
    Left = 192
    Top = 96
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
      FloatLeft = 671
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbShowAll'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbChoiceGuides'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'dxBarControlContainerItem1'
        end
        item
          Visible = True
          ItemName = 'dxBarControlContainerItem2'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_AssetProd'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'dxBarControlContainerItem3'
        end
        item
          Visible = True
          ItemName = 'dxBarControlContainerItem4'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_CountReceipt'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbProtocolOpenForm'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
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
    object bbInsert: TdxBarButton
      Action = actInsert
      Category = 0
    end
    object bbEdit: TdxBarButton
      Action = actUpdate
      Category = 0
    end
    object bbSetErased: TdxBarButton
      Action = dsdSetErased
      Category = 0
    end
    object bbSetUnErased: TdxBarButton
      Action = dsdSetUnErased
      Category = 0
    end
    object bbGridToExcel: TdxBarButton
      Action = dsdGridToExcel1
      Category = 0
    end
    object dxBarStatic1: TdxBarStatic
      Caption = '    '
      Category = 0
      Hint = '    '
      Visible = ivAlways
    end
    object bbChoiceGuides: TdxBarButton
      Action = dsdChoiceGuides
      Category = 0
    end
    object bbShowAll: TdxBarButton
      Action = actShowAll
      Category = 0
    end
    object bbProtocolOpenForm: TdxBarButton
      Action = ProtocolOpenForm
      Category = 0
    end
    object bbisPartionCount: TdxBarButton
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' "'#1055#1072#1088#1090#1080#1103' '#1082#1086#1083'-'#1074#1086' ('#1076#1072'/'#1085#1077#1090')"'
      Category = 0
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' "'#1055#1072#1088#1090#1080#1103' '#1082#1086#1083'-'#1074#1086' ('#1076#1072'/'#1085#1077#1090')"'
      Visible = ivAlways
      ImageIndex = 58
    end
    object bbisPartionSumm: TdxBarButton
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' "'#1055#1072#1088#1090#1080#1103' '#1089#1091#1084#1084#1072' ('#1076#1072'/'#1085#1077#1090')"'
      Category = 0
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' "'#1055#1072#1088#1090#1080#1103' '#1089#1091#1084#1084#1072' ('#1076#1072'/'#1085#1077#1090')"'
      Visible = ivAlways
      ImageIndex = 52
    end
    object bbUpdateGoods_In: TdxBarButton
      Caption = #1054#1087#1088#1077#1076#1077#1083#1080#1090#1100' '#1076#1072#1090#1091' '#1087#1086#1089#1083'. '#1087#1088#1080#1093#1086#1076#1072' '#1086#1090' '#1087#1086#1089#1090#1072#1074#1097'.  '#1080' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
      Category = 0
      Hint = #1054#1087#1088#1077#1076#1077#1083#1080#1090#1100' '#1076#1072#1090#1091' '#1087#1086#1089#1083'. '#1087#1088#1080#1093#1086#1076#1072' '#1086#1090' '#1087#1086#1089#1090#1072#1074#1097'.  '#1080' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
      Visible = ivAlways
      ImageIndex = 43
    end
    object bbUpdate_WeightTareList: TdxBarButton
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1074#1077#1089' '#1074#1090#1091#1083#1082#1080
      Category = 0
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1074#1077#1089' '#1074#1090#1091#1083#1082#1080
      Visible = ivAlways
      ImageIndex = 60
    end
    object bbStartLoad: TdxBarButton
      Action = actStartLoad
      Category = 0
    end
    object dxBarControlContainerItem1: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = cxLabel6
    end
    object dxBarControlContainerItem2: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = edAssetProd
    end
    object dxBarControlContainerItem3: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = cxLabel13
    end
    object dxBarControlContainerItem4: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = edCountReceipt
    end
    object bbUpdate_AssetProd: TdxBarButton
      Action = macUpdate_AssetProd
      Category = 0
    end
    object bbUpdate_CountReceipt: TdxBarButton
      Action = macUpdate_CountReceipt
      Category = 0
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 136
    Top = 96
    object macUpdate_CountReceipt: TMultiAction
      Category = 'Update'
      MoveParams = <>
      ActionList = <
        item
          Action = macUpdate_CountReceipt_list
        end
        item
          Action = actRefresh
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1042#1057#1045#1052' - '#1050#1086#1083'-'#1074#1086' '#1087#1072#1088#1090#1080#1081' '#1076#1083#1103' '#1079#1072#1084#1077#1089#1072
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1042#1057#1045#1052' - '#1050#1086#1083'-'#1074#1086' '#1087#1072#1088#1090#1080#1081' '#1076#1083#1103' '#1079#1072#1084#1077#1089#1072
      ImageIndex = 43
    end
    object macUpdate_CountReceipt_list: TMultiAction
      Category = 'Update'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_CountReceipt
        end>
      View = cxGridDBTableView
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1050#1086#1083'-'#1074#1086' '#1087#1072#1088#1090#1080#1081' '#1087#1086' '#1088#1077#1094#1077#1087#1090#1091#1088#1077
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1050#1086#1083'-'#1074#1086' '#1087#1072#1088#1090#1080#1081' '#1087#1086' '#1088#1077#1094#1077#1087#1090#1091#1088#1077
      ImageIndex = 43
    end
    object actUpdate_CountReceipt: TdsdExecStoredProc
      Category = 'Update'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_CountReceipt
      StoredProcList = <
        item
          StoredProc = spUpdate_CountReceipt
        end>
      Caption = 'actUpdateGoods_In'
    end
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
    object macUpdate_AssetProd: TMultiAction
      Category = 'Update'
      MoveParams = <>
      ActionList = <
        item
          Action = macUpdate_AssetProd_list
        end
        item
          Action = actRefresh
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1042#1057#1045#1052' - '#1054#1057' ('#1086#1073#1086#1088#1091#1076#1086#1074#1072#1085#1080#1077' '#1085#1072' '#1082#1086#1090#1086#1088#1086#1084' '#1087#1088#1086#1080#1079#1074#1086#1076#1080#1090#1089#1103')'
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1042#1057#1045#1052' - '#1054#1057' ('#1086#1073#1086#1088#1091#1076#1086#1074#1072#1085#1080#1077' '#1085#1072' '#1082#1086#1090#1086#1088#1086#1084' '#1087#1088#1086#1080#1079#1074#1086#1076#1080#1090#1089#1103')'
      ImageIndex = 43
    end
    object actUpdate_AssetProd: TdsdExecStoredProc
      Category = 'Update'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_AssetProd
      StoredProcList = <
        item
          StoredProc = spUpdate_AssetProd
        end>
      Caption = 'actUpdateGoods_In'
      Hint = #1054#1087#1088#1077#1076#1077#1083#1080#1090#1100' '#1076#1072#1090#1091' '#1087#1086#1089#1083'. '#1087#1088#1080#1093#1086#1076#1072' '#1086#1090' '#1087#1086#1089#1090#1072#1074#1097'.  '#1080' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
    end
    object dsdSetErased: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedUnErased
      StoredProcList = <
        item
          StoredProc = spErasedUnErased
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = DataSource
    end
    object macUpdate_AssetProd_list: TMultiAction
      Category = 'Update'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_AssetProd
        end>
      View = cxGridDBTableView
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1054#1057' ('#1086#1073#1086#1088#1091#1076'. '#1085#1072' '#1082#1086#1090#1086#1088#1086#1084' '#1087#1088#1086#1080#1079#1074#1086#1076#1080#1090#1089#1103')'
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1054#1057' ('#1086#1073#1086#1088#1091#1076'. '#1085#1072' '#1082#1086#1090#1086#1088#1086#1084' '#1087#1088#1086#1080#1079#1074#1086#1076#1080#1090#1089#1103')'
      ImageIndex = 43
    end
    object dsdSetUnErased: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedUnErased
      StoredProcList = <
        item
          StoredProc = spErasedUnErased
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 32776
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = DataSource
    end
    object dsdChoiceGuides: TdsdChoiceGuides
      Category = 'DSDLib'
      MoveParams = <>
      Params = <
        item
          Name = 'Key'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Code'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Name'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'FuelName'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'FuelName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MeasureName'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'MeasureName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'TradeMarkName'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'TradeMarkName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      Caption = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      Hint = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      ImageIndex = 7
    end
    object dsdGridToExcel1: TdsdGridToExcel
      Category = 'DSDLib'
      MoveParams = <>
      Grid = cxGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object actShowAll: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = dsdStoredProc
      StoredProcList = <
        item
          StoredProc = dsdStoredProc
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndex = 63
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndexTrue = 62
      ImageIndexFalse = 63
    end
    object ProtocolOpenForm: TdsdOpenForm
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
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Name'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actUpdate: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100
      ShortCut = 115
      ImageIndex = 1
      FormName = 'TGoodsEditForm'
      FormNameParam.Value = 'TGoodsEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      ActionType = acUpdate
      DataSource = DataSource
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actInsert: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      ShortCut = 45
      ImageIndex = 0
      FormName = 'TGoodsEditForm'
      FormNameParam.Value = 'TGoodsEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      DataSource = DataSource
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actGetImportSetting_Goods_Price: TdsdExecStoredProc
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSettingId
      StoredProcList = <
        item
          StoredProc = spGetImportSettingId
        end>
      Caption = 'actGetImportSetting_Goods_Price'
    end
    object actDoLoad: TExecuteImportSettingsAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ImportSettingsId.Value = '0'
      ImportSettingsId.Component = FormParams
      ImportSettingsId.ComponentItem = 'ImportSettingId'
      ImportSettingsId.MultiSelectSeparator = ','
      ExternalParams = <>
    end
    object actStartLoad: TMultiAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSetting_Goods_Price
        end
        item
          Action = actDoLoad
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1053#1072#1095#1072#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091' '#1042#1077#1089'/'#1042#1077#1089' '#1074#1090#1091#1083#1082#1080'/'#1050#1086#1083'. '#1076#1083#1103' '#1074#1077#1089#1072' '#1080#1079' '#1092#1072#1081#1083#1072'?'
      InfoAfterExecute = #1042#1077#1089'/'#1042#1077#1089' '#1074#1090#1091#1083#1082#1080'/'#1050#1086#1083'. '#1076#1083#1103' '#1074#1077#1089#1072' '#1079#1072#1075#1088#1091#1078#1077#1085#1099
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1042#1077#1089'/'#1042#1077#1089' '#1074#1090#1091#1083#1082#1080'/'#1050#1086#1083'. '#1076#1083#1103' '#1074#1077#1089#1072
      Hint = 
        #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080#1079' '#1069#1082#1089#1077#1083#1103', '#1092#1086#1088#1084#1072#1090' : '#1082#1086#1076' '#1090#1086#1074' + '#1074#1077#1089' + '#1074#1077#1089' '#1074#1090#1091#1083#1082#1080' + '#1082#1086#1083'-'#1074 +
        #1086' '#1085#1072' 1-'#1086#1081' '#1074#1090#1091#1083#1082#1077
      ImageIndex = 41
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
    object actOpenAssetChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actOpenAssetChoiceForm'
      FormName = 'TAssetForm'
      FormNameParam.Value = 'TAssetForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'key'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'AssetProdId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'AssetProdName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
  end
  object dsdStoredProc: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Goods_AssetProd'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <
      item
        Name = 'inShowAll'
        Value = 'True'
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 112
    Top = 152
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 40
    Top = 192
  end
  object spErasedUnErased: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_isErased_Goods'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 200
    Top = 144
  end
  object dsdDBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView
    OnDblClickActionList = <
      item
        Action = dsdChoiceGuides
      end>
    ActionItemList = <
      item
        Action = dsdChoiceGuides
        ShortCut = 13
      end
      item
        Action = actUpdate
        ShortCut = 13
      end>
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    PropertiesCellList = <>
    Left = 232
    Top = 184
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'ImportSettingId'
        Value = Null
        MultiSelectSeparator = ','
      end>
    Left = 464
    Top = 232
  end
  object spGetImportSettingId: TdsdStoredProc
    StoredProcName = 'gpGet_DefaultValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inDefaultKey'
        Value = 'TGoodsForm;zc_Object_ImportSetting_Goods_Weight'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserKeyId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'gpGet_DefaultValue'
        Value = Null
        Component = FormParams
        ComponentItem = 'ImportSettingId'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 536
    Top = 272
  end
  object GuidesAssetProd: TdsdGuides
    KeyField = 'Id'
    LookupControl = edAssetProd
    FormNameParam.Value = 'TAssetForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TAssetForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesAssetProd
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesAssetProd
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 464
    Top = 104
  end
  object spUpdate_AssetProd: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_Goods_AssetProd'
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
        Name = 'inAssetProdId'
        Value = Null
        Component = GuidesAssetProd
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 880
    Top = 216
  end
  object spUpdate_CountReceipt: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_Goods_CountReceipt'
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
        Name = 'inCountReceipt'
        Value = Null
        Component = edCountReceipt
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 880
    Top = 147
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_Goods_AssetProd'
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
        Name = 'inAssetProdId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'AssetProdId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCountReceipt'
        Value = 0.000000000000000000
        Component = ClientDataSet
        ComponentItem = 'CountReceipt'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 688
    Top = 187
  end
end
