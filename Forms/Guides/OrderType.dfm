object OrderTypeForm: TOrderTypeForm
  Left = 0
  Top = 0
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090#1099' '#1089#1077#1079#1086#1085#1085#1086#1089#1090#1080' '#1087#1086' '#1084#1077#1089#1103#1094#1072#1084'>'
  ClientHeight = 597
  ClientWidth = 1039
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
    Width = 1039
    Height = 571
    Align = alClient
    TabOrder = 0
    LookAndFeel.Kind = lfStandard
    LookAndFeel.NativeStyle = False
    LookAndFeel.SkinName = ''
    object cxGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = DataSource
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Filter.Active = True
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      Images = dmMain.SortImageList
      OptionsBehavior.IncSearch = True
      OptionsBehavior.IncSearchItem = Koeff1
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsData.Appending = True
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsView.GroupByBox = False
      OptionsView.HeaderAutoHeight = True
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object UnitCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1087#1086#1076#1088'.'
        DataBinding.FieldName = 'UnitCode'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 48
      end
      object UnitName: TcxGridDBColumn
        Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086')'
        DataBinding.FieldName = 'UnitName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = UnitChoiceForm
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 120
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
        Width = 70
      end
      object TradeMarkName: TcxGridDBColumn
        Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072
        DataBinding.FieldName = 'TradeMarkName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object GoodsGroupName: TcxGridDBColumn
        Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072
        DataBinding.FieldName = 'GoodsGroupName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = GoodsChoiceForm
            Default = True
            Kind = bkEllipsis
          end>
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object GoodsGroupNameFull: TcxGridDBColumn
        Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
        DataBinding.FieldName = 'GoodsGroupNameFull'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 150
      end
      object GoodsCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1090#1086#1074'.'
        DataBinding.FieldName = 'GoodsCode'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 56
      end
      object GoodsName: TcxGridDBColumn
        Caption = #1058#1086#1074#1072#1088
        DataBinding.FieldName = 'GoodsName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = GoodsChoiceForm
            Default = True
            Enabled = False
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 150
      end
      object MeasureName: TcxGridDBColumn
        Caption = #1045#1076'. '#1080#1079#1084'.'
        DataBinding.FieldName = 'MeasureName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 45
      end
      object TermProduction: TcxGridDBColumn
        Caption = #1057#1088#1086#1082' '#1087#1088#1086#1080#1079#1074'. '#1074' '#1076#1085#1103#1093
        DataBinding.FieldName = 'TermProduction'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 90
      end
      object NormInDays: TcxGridDBColumn
        Caption = #1053#1086#1088#1084#1072' '#1079#1072#1087#1072#1089' '#1074' '#1076#1085#1103#1093
        DataBinding.FieldName = 'NormInDays'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 90
      end
      object StartProductionInDays: TcxGridDBColumn
        Caption = #1063#1077#1088#1077#1079' '#1089#1082#1086#1083#1100#1082#1086' '#1076#1085#1077#1081' '#1085#1072#1095#1072#1083#1086' '#1087#1088#1086#1080#1079#1074'.'
        DataBinding.FieldName = 'StartProductionInDays'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.AssignedValues.DisplayFormat = True
        Properties.DecimalPlaces = 4
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 140
      end
      object Koeff1: TcxGridDBColumn
        Caption = #1071#1085#1074#1072#1088#1100
        DataBinding.FieldName = 'Koeff1'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 60
      end
      object Koeff2: TcxGridDBColumn
        Caption = #1060#1077#1074#1088#1072#1083#1100
        DataBinding.FieldName = 'Koeff2'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 65
      end
      object Koeff3: TcxGridDBColumn
        Caption = #1052#1072#1088#1090
        DataBinding.FieldName = 'Koeff3'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 60
      end
      object Koeff4: TcxGridDBColumn
        Caption = #1040#1087#1088#1077#1083#1100
        DataBinding.FieldName = 'Koeff4'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 60
      end
      object Koeff5: TcxGridDBColumn
        Caption = #1052#1072#1081' '
        DataBinding.FieldName = 'Koeff5'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 60
      end
      object Koeff6: TcxGridDBColumn
        Caption = #1048#1102#1085#1100
        DataBinding.FieldName = 'Koeff6'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 60
      end
      object Koeff7: TcxGridDBColumn
        Caption = #1048#1102#1083#1100
        DataBinding.FieldName = 'Koeff7'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 60
      end
      object Koeff8: TcxGridDBColumn
        Caption = #1040#1074#1075#1091#1089#1090
        DataBinding.FieldName = 'Koeff8'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 60
      end
      object Koeff9: TcxGridDBColumn
        Caption = #1057#1077#1085#1090#1103#1073#1088#1100
        DataBinding.FieldName = 'Koeff9'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 65
      end
      object Koeff10: TcxGridDBColumn
        Caption = #1054#1082#1090#1103#1073#1088#1100
        DataBinding.FieldName = 'Koeff10'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 60
      end
      object Koeff11: TcxGridDBColumn
        Caption = #1053#1086#1103#1073#1088#1100
        DataBinding.FieldName = 'Koeff11'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 60
      end
      object Koeff12: TcxGridDBColumn
        Caption = #1044#1077#1082#1072#1073#1088#1100
        DataBinding.FieldName = 'Koeff12'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 60
      end
      object InfoMoneyCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1059#1055
        DataBinding.FieldName = 'InfoMoneyCode'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
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
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object isErased: TcxGridDBColumn
        Caption = #1059#1076#1072#1083#1077#1085
        DataBinding.FieldName = 'isErased'
        PropertiesClassName = 'TcxCheckBoxProperties'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 45
      end
      object isOrderPr1: TcxGridDBColumn
        Caption = #1047#1072#1082#1072#1079' '#1055#1053
        DataBinding.FieldName = 'isOrderPr1'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1047#1072#1082#1072#1079' '#1085#1072' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086'- '#1087#1085
        Options.Editing = False
        Width = 70
      end
      object isOrderPr2: TcxGridDBColumn
        Caption = #1047#1072#1082#1072#1079' '#1042#1058
        DataBinding.FieldName = 'isOrderPr2'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1047#1072#1082#1072#1079' '#1085#1072' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086'- '#1074#1090
        Options.Editing = False
        Width = 70
      end
      object isOrderPr3: TcxGridDBColumn
        Caption = #1047#1072#1082#1072#1079' '#1057#1056
        DataBinding.FieldName = 'isOrderPr3'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1047#1072#1082#1072#1079' '#1085#1072' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086'- '#1089#1088
        Options.Editing = False
        Width = 70
      end
      object isOrderPr4: TcxGridDBColumn
        Caption = #1047#1072#1082#1072#1079' '#1063#1058
        DataBinding.FieldName = 'isOrderPr4'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1047#1072#1082#1072#1079' '#1085#1072' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' - '#1095#1090
        Options.Editing = False
        Width = 70
      end
      object isOrderPr5: TcxGridDBColumn
        Caption = #1047#1072#1082#1072#1079' '#1055#1058
        DataBinding.FieldName = 'isOrderPr5'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1047#1072#1082#1072#1079' '#1085#1072' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086'- '#1087#1090
        Options.Editing = False
        Width = 70
      end
      object isOrderPr6: TcxGridDBColumn
        Caption = #1047#1072#1082#1072#1079' '#1057#1041
        DataBinding.FieldName = 'isOrderPr6'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1047#1072#1082#1072#1079' '#1085#1072' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086'- '#1089#1073
        Options.Editing = False
        Width = 70
      end
      object isOrderPr7: TcxGridDBColumn
        Caption = #1047#1072#1082#1072#1079' '#1042#1057
        DataBinding.FieldName = 'isOrderPr7'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1047#1072#1082#1072#1079' '#1085#1072' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086'- '#1074#1089
        Options.Editing = False
        Width = 70
      end
      object isInPr1: TcxGridDBColumn
        Caption = #1042#1099#1093#1086#1076' '#1055#1053
        DataBinding.FieldName = 'isInPr1'
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1042#1099#1093#1086#1076' '#1089' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1072'-'#1087#1085
        Options.Editing = False
        Width = 66
      end
      object isInPr2: TcxGridDBColumn
        Caption = #1042#1099#1093#1086#1076' '#1042#1058
        DataBinding.FieldName = 'isInPr2'
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1042#1099#1093#1086#1076' '#1089' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1072'- '#1074#1090
        Options.Editing = False
        Width = 70
      end
      object isInPr3: TcxGridDBColumn
        Caption = #1042#1099#1093#1086#1076' '#1057#1056
        DataBinding.FieldName = 'isInPr3'
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1042#1099#1093#1086#1076' '#1089' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1072'- '#1089#1088
        Options.Editing = False
        Width = 70
      end
      object isInPr4: TcxGridDBColumn
        Caption = #1042#1099#1093#1086#1076' '#1063#1058
        DataBinding.FieldName = 'isInPr4'
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1042#1099#1093#1086#1076' '#1089' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1072'- '#1095#1090
        Options.Editing = False
        Width = 70
      end
      object isInPr5: TcxGridDBColumn
        Caption = #1042#1099#1093#1086#1076' '#1055#1058
        DataBinding.FieldName = 'isInPr5'
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1042#1099#1093#1086#1076' '#1089' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1072'- '#1087#1090
        Options.Editing = False
        Width = 70
      end
      object isInPr6: TcxGridDBColumn
        Caption = #1042#1099#1093#1086#1076' '#1057#1041
        DataBinding.FieldName = 'isInPr6'
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1042#1099#1093#1086#1076' '#1089' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1072'- '#1089#1073
        Options.Editing = False
        Width = 70
      end
      object isInPr7: TcxGridDBColumn
        Caption = #1042#1099#1093#1086#1076' '#1042#1057
        DataBinding.FieldName = 'isInPr7'
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1042#1099#1093#1086#1076' '#1089' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1072'- '#1074#1089
        Options.Editing = False
        Width = 70
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object ceUnit: TcxButtonEdit
    Left = 522
    Top = 157
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 5
    Width = 154
  end
  object cxLabel6: TcxLabel
    Left = 428
    Top = 158
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 56
    Top = 104
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 48
    Top = 160
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = dsdUnitGuides
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
    Left = 288
    Top = 104
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
    Left = 168
    Top = 104
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
          ItemName = 'bbactShowAll'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbh'
        end
        item
          Visible = True
          ItemName = 'bb1'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_Koeff'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsertUpdate_isPrEdit'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbStartLoad'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbProtocolOpenForm'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel'
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
    object bbGridToExcel: TdxBarButton
      Action = dsdGridToExcel
      Category = 0
    end
    object dxBarStatic: TdxBarStatic
      Caption = '     '
      Category = 0
      Hint = '     '
      Visible = ivAlways
    end
    object bbChoiceGuides: TdxBarButton
      Action = dsdChoiceGuides
      Category = 0
    end
    object bbactShowAll: TdxBarButton
      Action = actShowAll
      Category = 0
    end
    object bbh: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = cxLabel6
    end
    object bb1: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = ceUnit
    end
    object bbProtocolOpenForm: TdxBarButton
      Action = ProtocolOpenForm
      Category = 0
    end
    object bbUpdate_Koeff: TdxBarButton
      Action = macUpdate_Koeff
      Category = 0
    end
    object bbInsertUpdate_isPrEdit: TdxBarButton
      Action = actInsertUpdate_isPrEdit
      Category = 0
    end
    object bbStartLoad: TdxBarButton
      Action = macStartLoad
      Category = 0
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 288
    Top = 160
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
    object dsdChoiceGuides: TdsdChoiceGuides
      Category = 'DSDLib'
      MoveParams = <>
      Params = <
        item
          Name = 'Key'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Id'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Name'
          MultiSelectSeparator = ','
        end>
      Caption = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      Hint = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      ImageIndex = 7
      DataSource = DataSource
    end
    object dsdGridToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      MoveParams = <>
      Grid = cxGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object GoodsChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'Goods_ObjectForm'
      FormName = 'TGoods_ObjectForm'
      FormNameParam.Value = 'TGoods_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'GoodsGroupName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actShowAll: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089#1087#1080#1089#1086#1082
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndex = 63
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077' '#1090#1086#1074#1072#1088#1099
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089#1087#1080#1089#1086#1082
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077' '#1090#1086#1074#1072#1088#1099
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndexTrue = 62
      ImageIndexFalse = 63
    end
    object UnitChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'Unit_ObjectForm'
      FormName = 'TUnit_ObjectForm'
      FormNameParam.Value = 'TUnit_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'UnitId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'UnitName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'UnitCode'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
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
          ComponentItem = 'GoodsName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object ExecuteDialogKoeff: TExecuteDialog
      Category = 'Koeff'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090#1099' '#1089#1077#1079#1086#1085#1085#1086#1089#1090#1080' '#1087#1086' '#1084#1077#1089#1103#1094#1072#1084
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090#1099' '#1089#1077#1079#1086#1085#1085#1086#1089#1090#1080' '#1087#1086' '#1084#1077#1089#1103#1094#1072#1084
      ImageIndex = 26
      FormName = 'TOrderType_EditForm'
      FormNameParam.Value = 'TOrderType_EditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inKoeff1'
          Value = Null
          Component = FormParams
          ComponentItem = 'inKoeff1'
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inKoeff2'
          Value = Null
          Component = FormParams
          ComponentItem = 'inKoeff2'
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inKoeff3'
          Value = Null
          Component = FormParams
          ComponentItem = 'inKoeff3'
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inKoeff4'
          Value = Null
          Component = FormParams
          ComponentItem = 'inKoeff4'
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inKoeff5'
          Value = Null
          Component = FormParams
          ComponentItem = 'inKoeff5'
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inKoeff6'
          Value = Null
          Component = FormParams
          ComponentItem = 'inKoeff6'
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inKoeff7'
          Value = Null
          Component = FormParams
          ComponentItem = 'inKoeff7'
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inKoeff8'
          Value = Null
          Component = FormParams
          ComponentItem = 'inKoeff8'
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inKoeff9'
          Value = Null
          Component = FormParams
          ComponentItem = 'inKoeff9'
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inKoeff10'
          Value = Null
          Component = FormParams
          ComponentItem = 'inKoeff10'
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inKoeff11'
          Value = Null
          Component = FormParams
          ComponentItem = 'inKoeff11'
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inKoeff12'
          Value = Null
          Component = FormParams
          ComponentItem = 'inKoeff12'
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inisChange1'
          Value = True
          Component = FormParams
          ComponentItem = 'inisChange1'
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inisChange2'
          Value = True
          Component = FormParams
          ComponentItem = 'inisChange2'
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inisChange3'
          Value = True
          Component = FormParams
          ComponentItem = 'inisChange3'
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inisChange4'
          Value = True
          Component = FormParams
          ComponentItem = 'inisChange4'
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inisChange5'
          Value = True
          Component = FormParams
          ComponentItem = 'inisChange5'
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inisChange6'
          Value = True
          Component = FormParams
          ComponentItem = 'inisChange6'
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inisChange7'
          Value = True
          Component = FormParams
          ComponentItem = 'inisChange7'
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inisChange8'
          Value = True
          Component = FormParams
          ComponentItem = 'inisChange8'
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inisChange9'
          Value = True
          Component = FormParams
          ComponentItem = 'inisChange9'
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inisChange10'
          Value = True
          Component = FormParams
          ComponentItem = 'inisChange10'
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inisChange11'
          Value = True
          Component = FormParams
          ComponentItem = 'inisChange11'
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inisChange12'
          Value = True
          Component = FormParams
          ComponentItem = 'inisChange12'
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actUpdate_Koeff: TdsdDataSetRefresh
      Category = 'Koeff'
      MoveParams = <>
      StoredProc = spUpdate_Koeff
      StoredProcList = <
        item
          StoredProc = spUpdate_Koeff
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090#1099' '#1089#1077#1079#1086#1085#1085#1086#1089#1090#1080' '#1087#1086' '#1084#1077#1089#1103#1094#1072#1084
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090#1099' '#1089#1077#1079#1086#1085#1085#1086#1089#1090#1080' '#1087#1086' '#1084#1077#1089#1103#1094#1072#1084
      ImageIndex = 26
      ShortCut = 116
      RefreshOnTabSetChanges = True
    end
    object macUpdate_Koeff_list: TMultiAction
      Category = 'Koeff'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_Koeff
        end>
      View = cxGridDBTableView
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090#1099' '#1089#1077#1079#1086#1085#1085#1086#1089#1090#1080' '#1087#1086' '#1084#1077#1089#1103#1094#1072#1084
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090#1099' '#1089#1077#1079#1086#1085#1085#1086#1089#1090#1080' '#1087#1086' '#1084#1077#1089#1103#1094#1072#1084
      ImageIndex = 43
    end
    object macUpdate_Koeff: TMultiAction
      Category = 'Koeff'
      MoveParams = <>
      ActionList = <
        item
          Action = ExecuteDialogKoeff
        end
        item
          Action = macUpdate_Koeff_list
        end
        item
          Action = actRefresh
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090#1099' '#1089#1077#1079#1086#1085#1085#1086#1089#1090#1080' '#1087#1086' '#1084#1077#1089#1103#1094#1072#1084
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090#1099' '#1089#1077#1079#1086#1085#1085#1086#1089#1090#1080' '#1087#1086' '#1084#1077#1089#1103#1094#1072#1084
      ImageIndex = 43
    end
    object actInsertUpdate_isPrEdit: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1047#1072#1082#1072#1079' '#1085#1072' / '#1042#1099#1093#1086#1076' '#1089' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1072'>'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1047#1072#1082#1072#1079' '#1085#1072' / '#1042#1099#1093#1086#1076' '#1089' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1072'>'
      ImageIndex = 1
      FormName = 'TOrderType_isPrEditForm'
      FormNameParam.Value = 'TOrderType_isPrEditForm'
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
          Name = 'GoodsName'
          Value = ''
          Component = ClientDataSet
          ComponentItem = 'GoodsName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      IdFieldName = 'Id'
    end
    object actDoLoad: TExecuteImportSettingsAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ImportSettingsId.Value = Null
      ImportSettingsId.Component = FormParams
      ImportSettingsId.ComponentItem = 'ImportSettingId'
      ImportSettingsId.MultiSelectSeparator = ','
      ExternalParams = <>
    end
    object actGetImportSetting: TdsdExecStoredProc
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSettingId
      StoredProcList = <
        item
          StoredProc = spGetImportSettingId
        end>
      Caption = 'actGetImportSetting'
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' <'#1047#1072#1082#1072#1079' '#1085#1072' '#1087#1088#1086#1080#1079#1074'. / '#1042#1099#1093#1086#1076' '#1089' '#1087#1088#1086#1080#1079#1074'.>'
    end
    object macStartLoad: TMultiAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSetting
        end
        item
          Action = actDoLoad
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = 
        #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' <'#1047#1072#1082#1072#1079' '#1085#1072' '#1087#1088#1086#1080#1079#1074'. / '#1042#1099#1093#1086#1076' '#1089' '#1087#1088#1086#1080#1079#1074'.> '#1080#1079' '#1092#1072#1081#1083 +
        #1072'?'
      InfoAfterExecute = #1047#1072#1075#1088#1091#1079#1082#1072' '#1079#1072#1074#1077#1088#1096#1077#1085#1072'?'
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' <'#1047#1072#1082#1072#1079' '#1085#1072' '#1087#1088#1086#1080#1079#1074'. / '#1042#1099#1093#1086#1076' '#1089' '#1087#1088#1086#1080#1079#1074'.>'
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' <'#1047#1072#1082#1072#1079' '#1085#1072' '#1087#1088#1086#1080#1079#1074'. / '#1042#1099#1093#1086#1076' '#1089' '#1087#1088#1086#1080#1079#1074'.>'
      ImageIndex = 41
      WithoutNext = True
    end
  end
  object spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_OrderType'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <
      item
        Name = 'inUnitId'
        Value = Null
        Component = dsdUnitGuides
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
    Left = 48
    Top = 216
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 168
    Top = 160
  end
  object dsdDBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView
    OnDblClickActionList = <
      item
        Action = dsdChoiceGuides
      end
      item
        Action = actUpdateDataSet
      end>
    ActionItemList = <
      item
        Action = dsdChoiceGuides
        ShortCut = 13
      end
      item
        Action = actUpdateDataSet
        ShortCut = 13
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 168
    Top = 216
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_OrderType'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCode'
        Value = 0
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inName'
        Value = ''
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTermProduction'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'TermProduction'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inNormInDays'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'NormInDays'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartProductionInDays'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'StartProductionInDays'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoeff1'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Koeff1'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoeff2'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Koeff2'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoeff3'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Koeff3'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoeff4'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Koeff4'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoeff5'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Koeff5'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoeff6'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Koeff6'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoeff7'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Koeff7'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoeff8'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Koeff8'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoeff9'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Koeff9'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoeff10'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Koeff10'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoeff11'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Koeff11'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoeff12'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Koeff12'
        DataType = ftFloat
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
        Name = 'inUnitId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'UnitId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 128
    Top = 296
  end
  object dsdUnitGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceUnit
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = dsdUnitGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = dsdUnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 600
    Top = 155
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = dsdUnitGuides
      end
      item
        Component = actShowAll
      end>
    Left = 832
    Top = 168
  end
  object spUpdate_Koeff: TdsdStoredProc
    StoredProcName = 'gpUpdate_OrderType_Koeff'
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
        Name = 'inKoeff1'
        Value = Null
        Component = FormParams
        ComponentItem = 'inKoeff1'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoeff2'
        Value = Null
        Component = FormParams
        ComponentItem = 'inKoeff2'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoeff3'
        Value = Null
        Component = FormParams
        ComponentItem = 'inKoeff3'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoeff4'
        Value = Null
        Component = FormParams
        ComponentItem = 'inKoeff4'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoeff5'
        Value = Null
        Component = FormParams
        ComponentItem = 'inKoeff5'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoeff6'
        Value = Null
        Component = FormParams
        ComponentItem = 'inKoeff6'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoeff7'
        Value = Null
        Component = FormParams
        ComponentItem = 'inKoeff7'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoeff8'
        Value = Null
        Component = FormParams
        ComponentItem = 'inKoeff8'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoeff9'
        Value = Null
        Component = FormParams
        ComponentItem = 'inKoeff9'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoeff10'
        Value = Null
        Component = FormParams
        ComponentItem = 'inKoeff10'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoeff11'
        Value = Null
        Component = FormParams
        ComponentItem = 'inKoeff11'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoeff12'
        Value = Null
        Component = FormParams
        ComponentItem = 'inKoeff12'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisChange1'
        Value = False
        Component = FormParams
        ComponentItem = 'inisChange1'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisChange2'
        Value = False
        Component = FormParams
        ComponentItem = 'inisChange2'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisChange3'
        Value = False
        Component = FormParams
        ComponentItem = 'inisChange3'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisChange4'
        Value = False
        Component = FormParams
        ComponentItem = 'inisChange4'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisChange5'
        Value = False
        Component = FormParams
        ComponentItem = 'inisChange5'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisChange6'
        Value = False
        Component = FormParams
        ComponentItem = 'inisChange6'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisChange7'
        Value = False
        Component = FormParams
        ComponentItem = 'inisChange7'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisChange8'
        Value = False
        Component = FormParams
        ComponentItem = 'inisChange8'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisChange9'
        Value = False
        Component = FormParams
        ComponentItem = 'inisChange9'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisChange10'
        Value = False
        Component = FormParams
        ComponentItem = 'inisChange10'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisChange11'
        Value = False
        Component = FormParams
        ComponentItem = 'inisChange11'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisChange12'
        Value = False
        Component = FormParams
        ComponentItem = 'inisChange12'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 504
    Top = 403
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'inisChange1'
        Value = 'true'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisChange2'
        Value = 'true'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisChange3'
        Value = 'true'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisChange4'
        Value = 'true'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisChange5'
        Value = 'true'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisChange6'
        Value = 'true'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisChange7'
        Value = 'true'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisChange8'
        Value = 'true'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisChange9'
        Value = 'true'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisChange10'
        Value = 'true'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisChange11'
        Value = 'true'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisChange12'
        Value = 'true'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ImportSettingId'
        Value = Null
        MultiSelectSeparator = ','
      end>
    Left = 199
    Top = 306
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
        Value = 'TOrderTypeForm;zc_Object_ImportSetting_OrderType'
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
    Left = 704
    Top = 256
  end
end
