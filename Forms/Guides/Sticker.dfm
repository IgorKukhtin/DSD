object StickerForm: TStickerForm
  Left = 0
  Top = 0
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1069#1090#1080#1082#1077#1090#1082#1072'>'
  ClientHeight = 583
  ClientWidth = 934
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
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid: TcxGrid
    Left = 0
    Top = 105
    Width = 934
    Height = 303
    Align = alTop
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
          Format = #1057#1090#1088#1086#1082': ,0'
          Kind = skCount
          Column = GoodsName
        end>
      DataController.Summary.SummaryGroups = <>
      Images = dmMain.SortImageList
      OptionsBehavior.IncSearch = True
      OptionsBehavior.IncSearchItem = Comment
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsView.Footer = True
      OptionsView.HeaderHeight = 40
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object StickerFileName_inf: TcxGridDBColumn
        Caption = #1064#1040#1041#1051#1054#1053' ('#1076#1083#1103' '#1042#1057#1045#1061' '#1101#1090#1086#1081' '#1058#1052')'
        DataBinding.FieldName = 'StickerFileName_inf'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object StickerFileName: TcxGridDBColumn
        Caption = #1064#1040#1041#1051#1054#1053' ('#1080#1085#1076#1080#1074#1080#1076#1091#1072#1083#1100#1085#1099#1081')'
        DataBinding.FieldName = 'StickerFileName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = StickerFileChoiceForm
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 120
      end
      object StickerFileName_70_70: TcxGridDBColumn
        Caption = #1064#1040#1041#1051#1054#1053' 70x70 ('#1080#1085#1076#1080#1074#1080#1076#1091#1072#1083#1100#1085#1099#1081')'
        DataBinding.FieldName = 'StickerFileName_70_70'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = StickerFile_70_70ChoiceForm
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 120
      end
      object clCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1101#1090#1080#1082#1077#1090#1082#1080
        DataBinding.FieldName = 'Code'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 40
      end
      object ItemName: TcxGridDBColumn
        Caption = #1069#1083#1077#1084#1077#1085#1090' ('#1087#1086#1082'.)'
        DataBinding.FieldName = 'ItemName'
        Visible = False
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 80
      end
      object JuridicalCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1087#1086#1082'.'
        DataBinding.FieldName = 'JuridicalCode'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 45
      end
      object JuridicalName: TcxGridDBColumn
        Caption = #1055#1086#1082#1091#1087#1072#1090#1077#1083#1100
        DataBinding.FieldName = 'JuridicalName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = JuridicalUnionChoiceForm
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 132
      end
      object TradeMarkName_Goods: TcxGridDBColumn
        Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072' ('#1090#1086#1074#1072#1088')'
        DataBinding.FieldName = 'TradeMarkName_Goods'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 120
      end
      object TradeMarkName_StickerFile: TcxGridDBColumn
        Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072' ('#1064#1040#1041#1051#1054#1053' '#1080#1085#1076#1080#1074#1080#1076'.)'
        DataBinding.FieldName = 'TradeMarkName_StickerFile'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 150
      end
      object TradeMarkName_StickerFile_70_70: TcxGridDBColumn
        Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072' ('#1064#1040#1041#1051#1054#1053' 70x70 '#1080#1085#1076#1080#1074#1080#1076'.)'
        DataBinding.FieldName = 'TradeMarkName_StickerFile_70_70'
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
        Width = 55
      end
      object GoodsName: TcxGridDBColumn
        Caption = #1058#1086#1074#1072#1088
        DataBinding.FieldName = 'GoodsName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = GoodsChoiceForm
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 113
      end
      object MeasureName: TcxGridDBColumn
        Caption = #1045#1076'.'#1080#1079#1084'.'
        DataBinding.FieldName = 'MeasureName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object StickerGroupName: TcxGridDBColumn
        Caption = #1042#1080#1076' '#1087#1088#1086#1076#1091#1082#1090#1072' ('#1043#1088#1091#1087#1087#1072')'
        DataBinding.FieldName = 'StickerGroupName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = StickerGroupChoiceForm
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 120
      end
      object StickerTypeName: TcxGridDBColumn
        Caption = #1057#1087#1086#1089#1086#1073' '#1080#1079#1075#1086#1090#1086#1074#1083#1077#1085#1080#1103
        DataBinding.FieldName = 'StickerTypeName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = StickerTypeChoiceForm
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 110
      end
      object StickerTagName: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1087#1088#1086#1076#1091#1082#1090#1072
        DataBinding.FieldName = 'StickerTagName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = StickerTagChoiceForm
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 100
      end
      object StickerSortName: TcxGridDBColumn
        Caption = #1057#1086#1088#1090#1085#1086#1089#1090#1100
        DataBinding.FieldName = 'StickerSortName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = StickerSortChoiceForm
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object StickerNormName: TcxGridDBColumn
        Caption = #1058#1059' '#1080#1083#1080' '#1044#1057#1058#1059
        DataBinding.FieldName = 'StickerNormName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = StickerNormChoiceForm
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 79
      end
      object Info: TcxGridDBColumn
        Caption = #1057#1086#1089#1090#1072#1074' '#1087#1088#1086#1076#1091#1082#1090#1072
        DataBinding.FieldName = 'Info'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 63
      end
      object Value1: TcxGridDBColumn
        Caption = #1059#1075#1083#1077#1074#1086#1076#1080' '#1085#1077' '#1073#1086#1083#1100#1096#1077
        DataBinding.FieldName = 'Value1'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.##;-,0.##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object Value2: TcxGridDBColumn
        Caption = #1041#1077#1083#1082#1080' '#1085#1077' '#1084#1077#1085#1100#1096#1077
        DataBinding.FieldName = 'Value2'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.##;-,0.##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object Value3: TcxGridDBColumn
        Caption = #1046#1080#1088#1080' '#1085#1077' '#1073#1086#1083#1100#1096#1077
        DataBinding.FieldName = 'Value3'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.##;-,0.##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object Value4: TcxGridDBColumn
        Caption = #1082#1050#1072#1083#1086#1088
        DataBinding.FieldName = 'Value4'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.##;-,0.##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object Value5: TcxGridDBColumn
        Caption = #1082#1044#1078
        DataBinding.FieldName = 'Value5'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.##;-,0.##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object Value6: TcxGridDBColumn
        Caption = #1079' '#1085#1080#1093' '#1085#1072#1089#1080#1095#1077#1085#1110' ('#1078#1080#1088#1080')'
        DataBinding.FieldName = 'Value6'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.##;-,0.##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object Value7: TcxGridDBColumn
        Caption = #1094#1091#1082#1088#1080
        DataBinding.FieldName = 'Value7'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.##;-,0.##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object Value8: TcxGridDBColumn
        Caption = #1089#1110#1083#1100' '
        DataBinding.FieldName = 'Value8'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.##;-,0.##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object Comment: TcxGridDBColumn
        Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
        DataBinding.FieldName = 'Comment'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 105
      end
      object IsErased: TcxGridDBColumn
        Caption = #1059#1076#1072#1083#1077#1085
        DataBinding.FieldName = 'isErased'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 40
      end
      object Id: TcxGridDBColumn
        DataBinding.FieldName = 'Id'
        Visible = False
        VisibleForCustomization = False
        Width = 20
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object cxTopSplitter: TcxSplitter
    Left = 0
    Top = 408
    Width = 934
    Height = 5
    AlignSplitter = salTop
    Control = cxGrid
  end
  object cxRightSplitter: TcxSplitter
    Left = 930
    Top = 413
    Width = 4
    Height = 170
    AlignSplitter = salRight
  end
  object Panel: TPanel
    Left = 0
    Top = 413
    Width = 930
    Height = 170
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 3
    object cxGridProperty: TcxGrid
      Left = 5
      Top = 0
      Width = 925
      Height = 170
      Align = alClient
      TabOrder = 0
      LookAndFeel.Kind = lfStandard
      LookAndFeel.NativeStyle = False
      LookAndFeel.SkinName = ''
      object cxGridDBTableViewProperty: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = DSProperty
        DataController.Filter.Options = [fcoCaseInsensitive]
        DataController.Filter.Active = True
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        Images = dmMain.SortImageList
        OptionsBehavior.IncSearch = True
        OptionsCustomize.ColumnHiding = True
        OptionsCustomize.ColumnsQuickCustomization = True
        OptionsData.Deleting = False
        OptionsData.DeletingConfirmation = False
        OptionsData.Inserting = False
        OptionsView.GroupByBox = False
        OptionsView.HeaderHeight = 40
        OptionsView.Indicator = True
        Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
        object colCode: TcxGridDBColumn
          Caption = #1050#1086#1076' '#1101#1083#1077#1084'.'
          DataBinding.FieldName = 'Code'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 57
        end
        object colStickerFileName: TcxGridDBColumn
          Caption = #1064#1040#1041#1051#1054#1053' ('#1080#1085#1076#1080#1074#1080#1076#1091#1072#1083#1100#1085#1099#1081')'
          DataBinding.FieldName = 'StickerFileName'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Action = StickerFileChoiceForm1
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 120
        end
        object colStickerFileName_70_70: TcxGridDBColumn
          Caption = #1064#1040#1041#1051#1054#1053' 70x70 ('#1080#1085#1076#1080#1074#1080#1076#1091#1072#1083#1100#1085#1099#1081')'
          DataBinding.FieldName = 'StickerFileName_70_70'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Action = StickerFile_70_70ChoiceForm1
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 120
        end
        object colTradeMarkName_StickerFile: TcxGridDBColumn
          Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072' ('#1064#1040#1041#1051#1054#1053' '#1080#1085#1076#1080#1074#1080#1076'.)'
          DataBinding.FieldName = 'TradeMarkName_StickerFile'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072' ('#1096#1072#1073#1083#1086#1085')'
          Options.Editing = False
          Width = 150
        end
        object colTradeMarkName_StickerFile_70_70: TcxGridDBColumn
          Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072' ('#1064#1040#1041#1051#1054#1053' 70x70 '#1080#1085#1076#1080#1074#1080#1076'.)'
          DataBinding.FieldName = 'TradeMarkName_StickerFile_70_70'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072' ('#1096#1072#1073#1083#1086#1085' 70_70)'
          Options.Editing = False
          Width = 150
        end
        object colGoodsKindName: TcxGridDBColumn
          Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
          DataBinding.FieldName = 'GoodsKindName'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Action = GoodsKindChoiceForm
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 100
        end
        object colisFix: TcxGridDBColumn
          Caption = #1060#1080#1082#1089'. '#1074#1077#1089
          DataBinding.FieldName = 'isFix'
          PropertiesClassName = 'TcxCheckBoxProperties'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1060#1080#1082#1089#1080#1088#1086#1074#1072#1085#1085#1099#1081' '#1074#1077#1089
          Width = 45
        end
        object colisCK: TcxGridDBColumn
          Caption = #1057'/'#1050'+'#1057'/'#1042
          DataBinding.FieldName = 'isCK'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1042#1099#1074#1086#1076#1080#1090#1100' '#1092#1088#1072#1079#1091' '#1076#1083#1103' '#1057'/'#1050'+'#1057'/'#1042
          Options.Editing = False
          Width = 62
        end
        object isNormInDays_not: TcxGridDBColumn
          Caption = #1053#1077' '#1080#1089#1087'. "'#1089#1088#1086#1082' '#1074' '#1076#1085'."'
          DataBinding.FieldName = 'isNormInDays_not'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1053#1077' '#1080#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1089#1074'-'#1074#1086' "'#1089#1088#1086#1082' '#1074' '#1076#1085#1103#1093'"'
          Options.Editing = False
          Width = 85
        end
        object colStickerPackName: TcxGridDBColumn
          Caption = #1042#1080#1076' '#1087#1072#1082#1091#1074#1072#1085#1085#1103
          DataBinding.FieldName = 'StickerPackName'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Action = StickerPackChoiceForm
              Default = True
              Kind = bkEllipsis
            end>
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 80
        end
        object colStickerSkinName: TcxGridDBColumn
          Caption = #1054#1073#1086#1083#1086#1095#1082#1072
          DataBinding.FieldName = 'StickerSkinName'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Action = StickerSkinChoiceForm
              Default = True
              Kind = bkEllipsis
            end>
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 70
        end
        object BarCode: TcxGridDBColumn
          Caption = #1064#1090#1088#1080#1093#1082#1086#1076
          DataBinding.FieldName = 'BarCode'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 70
        end
        object colValue1: TcxGridDBColumn
          Caption = #1042#1086#1083#1086#1075#1110#1089#1090#1100' '#1084#1110#1085
          DataBinding.FieldName = 'Value1'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Action = StickerProperty_ValueChoiceForm
              Default = True
              Kind = bkEllipsis
            end>
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 70
        end
        object colValue2: TcxGridDBColumn
          Caption = #1042#1086#1083#1086#1075#1110#1089#1090#1100' '#1084#1072#1082#1089
          DataBinding.FieldName = 'Value2'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.##;-,0.##; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 70
        end
        object colValue3: TcxGridDBColumn
          Caption = #1058' '#1084#1110#1085
          DataBinding.FieldName = 'Value3'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.##;-,0.##; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 40
        end
        object colValue4: TcxGridDBColumn
          Caption = #1058' '#1084#1072#1082#1089
          DataBinding.FieldName = 'Value4'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.##;-,0.##; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 40
        end
        object colValue5: TcxGridDBColumn
          Caption = #1050#1110#1083#1100#1082#1110#1089#1090#1100' '#1076#1110#1073
          DataBinding.FieldName = 'Value5'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.##;-,0.##; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 70
        end
        object Value5_orig: TcxGridDBColumn
          Caption = '***'#1050#1110#1083#1100#1082#1110#1089#1090#1100' '#1076#1110#1073
          DataBinding.FieldName = 'Value5_orig'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 55
        end
        object NormInDays_gk: TcxGridDBColumn
          Caption = '***'#1089#1088#1086#1082' '#1074' '#1076#1085#1103#1093
          DataBinding.FieldName = 'NormInDays_gk'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 55
        end
        object colValue6: TcxGridDBColumn
          Caption = #1042#1077#1089
          DataBinding.FieldName = 'Value6'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 45
        end
        object colValue7: TcxGridDBColumn
          Caption = '% '#1086#1090#1082'.'
          DataBinding.FieldName = 'Value7'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.##;-,0.##; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 35
        end
        object colValue8: TcxGridDBColumn
          Caption = #1058' '#1084#1110#1085' '#8470'2'
          DataBinding.FieldName = 'Value8'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.##;-,0.##; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1058' '#1084#1110#1085' - '#1074#1090#1086#1088#1086#1081' '#1089#1088#1086#1082' '
          Width = 55
        end
        object colValue9: TcxGridDBColumn
          Caption = #1058' '#1084#1072#1082#1089' '#8470'2'
          DataBinding.FieldName = 'Value9'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.##;-,0.##; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1058' '#1084#1072#1082#1089' - '#1074#1090#1086#1088#1086#1081' '#1089#1088#1086#1082' '
          Width = 55
        end
        object colValue10: TcxGridDBColumn
          Caption = #1050#1110#1083#1100#1082#1110#1089#1090#1100' '#1076#1110#1073' '#8470'2'
          DataBinding.FieldName = 'Value10'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.##;-,0.##; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1050#1110#1083#1100#1082#1110#1089#1090#1100' '#1076#1110#1073' - '#1074#1090#1086#1088#1086#1081' '#1089#1088#1086#1082' '
          Width = 70
        end
        object colValue11: TcxGridDBColumn
          Caption = #1042#1083#1086#1078#1077#1085#1085#1086#1089#1090#1100
          DataBinding.FieldName = 'Value11'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.##;-,0.##; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 70
        end
        object colComment: TcxGridDBColumn
          Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
          DataBinding.FieldName = 'Comment'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 80
        end
        object colisErased: TcxGridDBColumn
          Caption = #1059#1076#1072#1083#1077#1085
          DataBinding.FieldName = 'isErased'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 20
        end
      end
      object cxGridLeveProperty: TcxGridLevel
        GridView = cxGridDBTableViewProperty
      end
    end
    object cxLeftSplitter: TcxSplitter
      Left = 0
      Top = 0
      Width = 5
      Height = 170
      Control = cxGridProperty
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 934
    Height = 79
    Align = alTop
    TabOrder = 5
    object deDateStart: TcxDateEdit
      Left = 68
      Top = 30
      EditValue = 44927d
      Properties.ReadOnly = False
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 0
      Width = 83
    end
    object deDatePack: TcxDateEdit
      Left = 656
      Top = 6
      EditValue = 44927d
      Properties.ReadOnly = False
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 1
      Width = 80
    end
    object cxLabel1: TcxLabel
      Left = 11
      Top = 31
      Caption = #1044#1072#1090#1072' '#1089' ...'
    end
    object cxLabel2: TcxLabel
      Left = 586
      Top = 8
      Caption = #1059#1055#1040#1050#1054#1042#1050#1040':'
    end
    object edPartion: TcxLabel
      Left = 742
      Top = 7
      Hint = #8470' '#1087#1072#1088#1090#1080#1080'  '#1091#1087#1072#1082#1086#1074#1082#1080':'
      Caption = #8470' '#1087#1072#1088#1090#1080#1080'  '#1091#1087#1072#1082'.:'
    end
    object cbStartEnd: TcxCheckBox
      Left = 5
      Top = 5
      Caption = #1055#1077#1095#1072#1090#1072#1090#1100' '#1076#1072#1090#1091' '#1087#1088#1086#1080#1079#1074'-'#1074#1072
      State = cbsChecked
      TabOrder = 5
      Width = 155
    end
    object cbTare: TcxCheckBox
      Left = 168
      Top = 5
      Caption = #1055#1077#1095#1072#1090#1072#1090#1100' '#1076#1083#1103' '#1058#1040#1056#1067
      TabOrder = 6
      Width = 125
    end
    object cbGoodsName: TcxCheckBox
      Left = 168
      Top = 28
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1090#1086#1074#1072#1088#1072
      State = cbsChecked
      TabOrder = 7
      Width = 111
    end
    object cbPartion: TcxCheckBox
      Left = 464
      Top = 8
      Caption = #1055#1040#1056#1058#1048#1071' '#1076#1083#1103' '#1090#1072#1088#1099
      TabOrder = 8
      Width = 117
    end
    object ceNumPack: TcxCurrencyEdit
      Left = 836
      Top = 7
      Hint = #8470' '#1087#1072#1088#1090#1080#1080'  '#1091#1087#1072#1082#1086#1074#1082#1080':'
      EditValue = 1.000000000000000000
      Properties.Alignment.Horz = taRightJustify
      Properties.Alignment.Vert = taVCenter
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0'
      TabOrder = 9
      Width = 33
    end
    object cxLabel4: TcxLabel
      Left = 565
      Top = 31
      Hint = #1044#1072#1090#1072' '#1091#1087#1072#1082#1086#1074#1082#1080
      Caption = #1042#1048#1043#1054#1058#1054#1042#1051#1045#1053#1053#1071':'
    end
    object deDateProduction: TcxDateEdit
      Left = 656
      Top = 28
      EditValue = 44927d
      Properties.ReadOnly = False
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 11
      Width = 80
    end
    object cxLabel5: TcxLabel
      Left = 742
      Top = 29
      Hint = #8470' '#1089#1084#1077#1085#1099' '#1090#1077#1093#1085#1086#1083#1086#1075#1086#1074':'
      Caption = #8470' '#1089#1084#1077#1085#1099' '#1090#1077#1093#1085'.:'
    end
    object ceNumTech: TcxCurrencyEdit
      Left = 836
      Top = 30
      Hint = #8470' '#1089#1084#1077#1085#1099' '#1090#1077#1093#1085#1086#1083#1086#1075#1086#1074':'
      EditValue = 1.000000000000000000
      Properties.Alignment.Horz = taRightJustify
      Properties.Alignment.Vert = taVCenter
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0'
      TabOrder = 13
      Width = 33
    end
    object cb70_70: TcxCheckBox
      Left = 396
      Top = 8
      Caption = '70 x 70'
      TabOrder = 14
      Width = 61
    end
    object ceRetail: TcxButtonEdit
      Left = 398
      Top = 28
      Hint = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 15
      Width = 159
    end
    object cxLabel6: TcxLabel
      Left = 886
      Top = 8
      Caption = #1042#1077#1089':'
    end
    object edWeight: TcxCurrencyEdit
      Left = 879
      Top = 30
      Hint = #8470' '#1089#1084#1077#1085#1099' '#1090#1077#1093#1085#1086#1083#1086#1075#1086#1074':'
      EditValue = 0.000000000000000000
      Properties.Alignment.Horz = taRightJustify
      Properties.Alignment.Vert = taVCenter
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.0###'
      TabOrder = 17
      Width = 49
    end
    object cxLabel30: TcxLabel
      Left = 306
      Top = 55
      Caption = #1050#1083#1072#1089#1089#1080#1092#1080#1082#1072#1090#1086#1088':'
    end
    object edOrderExternal: TcxButtonEdit
      Left = 68
      Top = 55
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 19
      Width = 223
    end
    object edGoodsProperty: TcxButtonEdit
      Left = 398
      Top = 54
      Hint = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 20
      Width = 159
    end
    object cxLabel7: TcxLabel
      Left = 18
      Top = 55
      Caption = #1047#1072#1103#1074#1082#1072':'
    end
  end
  object cxLabel3: TcxLabel
    Left = 302
    Top = 8
    Caption = #1044#1072#1090#1072' '#1076#1083#1103' '#1090#1072#1088#1099':'
  end
  object deDateTare: TcxDateEdit
    Left = 302
    Top = 28
    EditValue = 44927d
    Properties.ReadOnly = False
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 10
    Width = 85
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 40
    Top = 160
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    MasterFields = 'Id'
    Params = <>
    Left = 80
    Top = 160
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = cbGoodsName
        Properties.Strings = (
          'Checked')
      end
      item
        Component = cbPartion
        Properties.Strings = (
          'Checked')
      end
      item
        Component = cbStartEnd
        Properties.Strings = (
          'Checked')
      end
      item
        Component = cbTare
        Properties.Strings = (
          'Checked')
      end
      item
        Component = ceNumPack
        Properties.Strings = (
          'Value')
      end
      item
        Component = ceNumTech
        Properties.Strings = (
          'Value')
      end
      item
        Component = deDatePack
        Properties.Strings = (
          'EditValue')
      end
      item
        Component = deDateProduction
        Properties.Strings = (
          'Date')
      end
      item
        Component = deDateStart
        Properties.Strings = (
          'Date')
      end
      item
        Component = deDateTare
        Properties.Strings = (
          'Date')
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
    Left = 344
    Top = 120
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
    Left = 152
    Top = 88
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
          ItemName = 'bbInsert'
        end
        item
          Visible = True
          ItemName = 'bbInsertMask'
        end
        item
          Visible = True
          ItemName = 'bbEdit'
        end
        item
          Visible = True
          ItemName = 'bbSetErased'
        end
        item
          Visible = True
          ItemName = 'bbSetUnErased'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbProtocol'
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
          ItemName = 'bbRecordCP'
        end
        item
          Visible = True
          ItemName = 'bbInsertPropertyMask'
        end
        item
          Visible = True
          ItemName = 'bbSetErasedProperty'
        end
        item
          Visible = True
          ItemName = 'bbSetUnErasedProperty'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbProtocolOpenFormPartner'
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
          ItemName = 'bbShowAll'
        end
        item
          Visible = True
          ItemName = 'bbShowErased'
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
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_StickerProperty_CK'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_SP_NormInDays_not'
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
          ItemName = 'bbStartLoad'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbPrint'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbPrintJPG'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbPrintJPGLen'
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
      Action = dsdGridToExcel
      Category = 0
    end
    object dxBarStatic1: TdxBarStatic
      Caption = '    '
      Category = 0
      Hint = '    '
      Visible = ivAlways
      ShowCaption = False
    end
    object bbChoiceGuides: TdxBarButton
      Action = dsdChoiceGuides
      Category = 0
    end
    object bbRecordCP: TdxBarButton
      Action = InsertRecordProperty
      Category = 0
    end
    object bbProtocol: TdxBarButton
      Action = ProtocolOpenForm
      Category = 0
    end
    object bbProtocolOpenFormPartner: TdxBarButton
      Action = ProtocolOpenFormProperty
      Category = 0
    end
    object bbShowErased: TdxBarButton
      Action = actShowErased
      Category = 0
    end
    object bbInsertMask: TdxBarButton
      Action = actInsertMask
      Category = 0
    end
    object bbInsertPropertyMask: TdxBarButton
      Action = actInsertPropertyMask
      Category = 0
    end
    object bbSetErasedProperty: TdxBarButton
      Action = actSetErasedProperty
      Category = 0
    end
    object bbSetUnErasedProperty: TdxBarButton
      Action = actSetUnErasedProperty
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1089#1074#1086#1081#1089#1090#1074#1086' '#1101#1090#1080#1082#1077#1090#1082#1080
      Category = 0
    end
    object bbPrint: TdxBarButton
      Action = macPrint
      Category = 0
    end
    object bbStartLoad: TdxBarButton
      Action = macStartLoad
      Category = 0
    end
    object bbPrintJPG: TdxBarButton
      Action = macPrintJPG
      Category = 0
    end
    object bbPrintJPGLen: TdxBarButton
      Action = macPrintJPGLen
      Category = 0
    end
    object bbShowAll: TdxBarButton
      Action = actShowAll
      Category = 0
    end
    object bbUpdate_StickerProperty_CK: TdxBarButton
      Action = actUpdate_StickerProperty_CK
      Category = 0
    end
    object bbUpdate_SP_NormInDays_not: TdxBarButton
      Action = actUpdate_SP_NormInDays_not
      Category = 0
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 248
    Top = 136
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelectProperty
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actShowErased: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelectProperty
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndex = 64
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndexTrue = 65
      ImageIndexFalse = 64
    end
    object actInsertReportName: TdsdExecStoredProc
      Category = 'Print'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertReportName
      StoredProcList = <
        item
          StoredProc = spInsertReportName
        end>
      Caption = 'actInsertReportName'
    end
    object actGet_Params: TdsdExecStoredProc
      Category = 'Print'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_Params
      StoredProcList = <
        item
          StoredProc = spGet_Params
        end>
      Caption = 'actGet_Params'
    end
    object InsertRecordProperty: TInsertRecord
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableViewProperty
      Action = GoodsKindChoiceForm
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1057#1074#1086#1081#1089#1090#1074#1072' '#1101#1090#1080#1082#1077#1090#1082#1080'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1057#1074#1086#1081#1089#1090#1074#1072' '#1101#1090#1080#1082#1077#1090#1082#1080'>'
      ImageIndex = 0
    end
    object actInsertPropertyMask: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1086' '#1084#1072#1089#1082#1077' <'#1057#1074#1086#1081#1089#1090#1074#1072' '#1101#1090#1080#1082#1077#1090#1082#1080'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1057#1074#1086#1081#1089#1090#1074#1072' '#1101#1090#1080#1082#1077#1090#1082#1080'>'
      ImageIndex = 54
      FormName = 'TStickerPropertyEditForm'
      FormNameParam.Value = 'TStickerPropertyEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'inMaskId'
          Value = 0
          Component = CDSProperty
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'StickerName'
          Value = ''
          Component = ClientDataSet
          ComponentItem = 'Comment'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      DataSource = DSProperty
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actInsert: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      ShortCut = 45
      ImageIndex = 0
      FormName = 'TStickerEditForm'
      FormNameParam.Value = 'TStickerEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'inMaskId'
          Value = ''
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      DataSource = DataSource
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actInsertMask: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1086' '#1084#1072#1089#1082#1077' <'#1069#1090#1080#1082#1077#1090#1082#1091'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1086' '#1084#1072#1089#1082#1077
      ImageIndex = 54
      FormName = 'TStickerEditForm'
      FormNameParam.Value = 'TStickerEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = '0'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InMaskId'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object ProtocolOpenFormProperty: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083' <'#1057#1074#1086#1081#1089#1090#1074#1072' '#1101#1090#1080#1082#1077#1090#1082#1080'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083' <'#1057#1074#1086#1081#1089#1090#1074#1072' '#1101#1090#1080#1082#1077#1090#1082#1080'>'
      ImageIndex = 34
      FormName = 'TProtocolForm'
      FormNameParam.Value = 'TProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = CDSProperty
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = CDSProperty
          ComponentItem = 'StickerPackName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object ProtocolOpenForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083' <'#1069#1090#1080#1082#1077#1090#1082#1072'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083' <'#1069#1090#1080#1082#1077#1090#1082#1072'>'
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
    object actUpdate: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      ShortCut = 115
      ImageIndex = 1
      FormName = 'TStickerEditForm'
      FormNameParam.Value = 'TStickerEditForm'
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
          Name = 'inMaskId'
          Value = '0'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      ActionType = acUpdate
      DataSource = DataSource
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actSetErasedProperty: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedUnErasedProperty
      StoredProcList = <
        item
          StoredProc = spErasedUnErasedProperty
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1089#1074#1086#1081#1089#1090#1074#1086' '#1101#1090#1080#1082#1077#1090#1082#1080
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1089#1074#1086#1081#1089#1090#1074#1086' '#1101#1090#1080#1082#1077#1090#1082#1080
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = DSProperty
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
    object actSetUnErasedProperty: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedUnErasedProperty
      StoredProcList = <
        item
          StoredProc = spErasedUnErasedProperty
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = DSProperty
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
      ShortCut = 46
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
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Comment'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'JuridicalName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      Caption = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      Hint = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      ImageIndex = 7
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
    object actUpdateDataSetStickerProperty: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateStickerProperty
      StoredProcList = <
        item
          StoredProc = spInsertUpdateStickerProperty
        end>
      Caption = 'actUpdateDataSet'
      DataSource = DSProperty
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
    object JuridicalUnionChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'JuridicalUnionChoiceForm'
      FormName = 'TJuridicalRetailPartner_ObjectForm'
      FormNameParam.Value = 'TJuridicalRetailPartner_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'JuridicalId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'JuridicalName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalCode'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'JuridicalCode'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object StickerGroupChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'StickerGroupChoiceForm'
      FormName = 'TStickerGroupForm'
      FormNameParam.Value = 'TStickerGroupForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'StickerGroupId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'StickerGroupName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object StickerTagChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'StickerTagChoiceForm'
      FormName = 'TStickerTagForm'
      FormNameParam.Value = 'TStickerTagForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'StickerTagId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'StickerTagName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object StickerNormChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'StickerNormChoiceForm'
      FormName = 'TStickerNormForm'
      FormNameParam.Value = 'TStickerNormForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'StickerNormId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'StickerNormName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object StickerFileChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'StickerFileChoiceForm'
      FormName = 'TStickerFileForm'
      FormNameParam.Value = 'TStickerFileForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'StickerFileId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'StickerFileName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object StickerFile_70_70ChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'StickerFile_70_70ChoiceForm'
      FormName = 'TStickerFileForm'
      FormNameParam.Value = 'TStickerFileForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'StickerFileId_70_70'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'StickerFileName_70_70'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object GoodsChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'GoodsChoiceForm'
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
          Name = 'Code'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'GoodsCode'
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object StickerTypeChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'StickerTypeChoiceForm'
      FormName = 'TStickerTypeForm'
      FormNameParam.Value = 'TStickerTypeForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'StickerTypeId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'StickerTypeName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object StickerSortChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'StickerSortChoiceForm'
      FormName = 'TStickerSortForm'
      FormNameParam.Value = 'TStickerSortForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'StickerSortId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'StickerSortName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object GoodsKindChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'GoodsKindChoiceForm'
      FormName = 'TGoodsKindForm'
      FormNameParam.Value = 'TGoodsKindForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = CDSProperty
          ComponentItem = 'GoodsKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = CDSProperty
          ComponentItem = 'GoodsKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object StickerPackChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'StickerPackChoiceForm'
      FormName = 'TStickerPackForm'
      FormNameParam.Value = 'TStickerPackForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = CDSProperty
          ComponentItem = 'StickerPackId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = CDSProperty
          ComponentItem = 'StickerPackName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object StickerFileChoiceForm1: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TContractChoiceForm'
      FormName = 'TStickerFileForm'
      FormNameParam.Value = 'TStickerFileForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = CDSProperty
          ComponentItem = 'StickerFileId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = CDSProperty
          ComponentItem = 'StickerFileName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object StickerFile_70_70ChoiceForm1: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TStickerFileForm'
      FormName = 'TStickerFileForm'
      FormNameParam.Value = 'TStickerFileForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = CDSProperty
          ComponentItem = 'StickerFileId_70_70'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = CDSProperty
          ComponentItem = 'StickerFileName_70_70'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object StickerSkinChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'StickerSkinChoiceForm'
      FormName = 'TStickerSkinForm'
      FormNameParam.Value = 'TStickerSkinForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = CDSProperty
          ComponentItem = 'StickerSkinId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = CDSProperty
          ComponentItem = 'StickerSkinName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object StickerProperty_ValueChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'StickerProperty_ValueyForm'
      FormName = 'TStickerProperty_ValueForm'
      FormNameParam.Value = 'TStickerProperty_ValueForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Value1'
          Value = Null
          Component = CDSProperty
          ComponentItem = 'Value1'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'Value2'
          Value = Null
          Component = CDSProperty
          ComponentItem = 'Value2'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'Value3'
          Value = Null
          Component = CDSProperty
          ComponentItem = 'Value3'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'Value4'
          Value = Null
          Component = CDSProperty
          ComponentItem = 'Value4'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'Value5'
          Value = Null
          Component = CDSProperty
          ComponentItem = 'Value5'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'Value6'
          Value = Null
          Component = CDSProperty
          ComponentItem = 'Value6'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'Value7'
          Value = Null
          Component = CDSProperty
          ComponentItem = 'Value7'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actUpdateVat: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' "C'#1090#1072#1074#1082#1072' 0% ('#1090#1072#1084#1086#1078#1085#1103') '#1044#1072'/'#1053#1077#1090'"'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' "C'#1090#1072#1074#1082#1072' 0% ('#1090#1072#1084#1086#1078#1085#1103') '#1044#1072'/'#1053#1077#1090'"'
      ImageIndex = 58
    end
    object macPrint: TMultiAction
      Category = 'Print'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.ComponentItem = 'id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = '0'
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      ActionList = <
        item
          Action = actGet_Params
        end
        item
          Action = actGetReportName
        end
        item
          Action = actInsertReportName
        end
        item
          Action = actPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1041#1045#1047' '#1060#1080#1088#1084#1077#1085#1085#1086#1075#1086' '#1047#1085#1072#1082#1072
      Hint = #1055#1077#1095#1072#1090#1100' '#1041#1045#1047' '#1060#1080#1088#1084#1077#1085#1085#1086#1075#1086' '#1047#1085#1072#1082#1072
      ImageIndex = 3
      ShortCut = 16464
    end
    object actPrint: TdsdPrintAction
      Category = 'Print'
      MoveParams = <
        item
          FromParam.Value = Null
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100
      Hint = #1055#1077#1095#1072#1090#1100
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end>
      Params = <>
      ReportName = 'NULL'
      ReportNameParam.Value = ''
      ReportNameParam.Component = FormParams
      ReportNameParam.ComponentItem = 'ReportNameSticker'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actGetReportName: TdsdExecStoredProc
      Category = 'Print'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetReportNameSticker
      StoredProcList = <
        item
          StoredProc = spGetReportNameSticker
        end>
      Caption = 'actGetReportName'
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
    end
    object actDoLoad: TExecuteImportSettingsAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ImportSettingsId.Value = '0'
      ImportSettingsId.Component = FormParams
      ImportSettingsId.ComponentItem = 'ImportSettingId'
      ImportSettingsId.MultiSelectSeparator = ','
      ExternalParams = <
        item
          Name = 'inObjectId'
          Value = '0'
          ComponentItem = 'ObjectId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
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
      QuestionBeforeExecute = #1053#1072#1095#1072#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091' '#1044#1072#1085#1085#1099#1093' '#1069#1090#1080#1082#1077#1090#1082#1080'?'
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1044#1072#1085#1085#1099#1077' '#1069#1090#1080#1082#1077#1090#1082#1080
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1044#1072#1085#1085#1099#1077' '#1069#1090#1080#1082#1077#1090#1082#1080
      ImageIndex = 41
    end
    object macPrintJPG: TMultiAction
      Category = 'Print'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.ComponentItem = 'id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = '0'
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      ActionList = <
        item
          Action = actGet_Params
        end
        item
          Action = actGetReportName
        end
        item
          Action = actInsertReportName
        end
        item
          Action = actPrintJPG
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1089' '#1060#1080#1088#1084#1077#1085#1085#1099#1084' '#1047#1085#1072#1082#1086#1084
      Hint = #1055#1077#1095#1072#1090#1100' '#1089' '#1060#1080#1088#1084#1077#1085#1085#1099#1084' '#1047#1085#1072#1082#1086#1084
      ImageIndex = 3
    end
    object actPrintJPG: TdsdPrintAction
      Category = 'Print'
      MoveParams = <
        item
          FromParam.Value = Null
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProc = spSelectPrintJPG
      StoredProcList = <
        item
          StoredProc = spSelectPrintJPG
        end>
      Caption = #1055#1077#1095#1072#1090#1100
      Hint = #1055#1077#1095#1072#1090#1100
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end>
      Params = <>
      ReportName = 'NULL'
      ReportNameParam.Value = Null
      ReportNameParam.Component = FormParams
      ReportNameParam.ComponentItem = 'ReportNameSticker'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object macPrintJPGLen: TMultiAction
      Category = 'Print'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.ComponentItem = 'id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = '0'
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      ActionList = <
        item
          Action = actGet_Params
        end
        item
          Action = actGetReportName
        end
        item
          Action = actInsertReportName
        end
        item
          Action = actPrintJPGLen
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1089' '#1060#1080#1088#1084#1077#1085#1085#1099#1084' '#1047#1085#1072#1082#1086#1084' + '#1064#1048#1056#1048#1053#1040
      Hint = #1055#1077#1095#1072#1090#1100' '#1089' '#1060#1080#1088#1084#1077#1085#1085#1099#1084' '#1047#1085#1072#1082#1086#1084' + '#1064#1048#1056#1048#1053#1040
      ImageIndex = 3
    end
    object actPrintJPGLen: TdsdPrintAction
      Category = 'Print'
      MoveParams = <
        item
          FromParam.Value = Null
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProc = spSelectPrintJPGLen
      StoredProcList = <
        item
          StoredProc = spSelectPrintJPGLen
        end>
      Caption = #1055#1077#1095#1072#1090#1100
      Hint = #1055#1077#1095#1072#1090#1100
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end>
      Params = <>
      ReportName = 'NULL'
      ReportNameParam.Value = Null
      ReportNameParam.Component = FormParams
      ReportNameParam.ComponentItem = 'ReportNameSticker'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actShowAll: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082' '#1090#1086#1074#1072#1088#1086#1074
      ImageIndex = 63
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089#1087#1080#1089#1086#1082' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082' '#1090#1086#1074#1072#1088#1086#1074
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089#1087#1080#1089#1086#1082'  '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndexTrue = 62
      ImageIndexFalse = 63
    end
    object actUpdate_StickerProperty_CK: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_StickerProperty_CK
      StoredProcList = <
        item
          StoredProc = spUpdate_StickerProperty_CK
        end>
      Caption = #1042#1099#1074#1086#1076#1080#1090#1100' '#1092#1088#1072#1079#1091' '#1076#1083#1103' '#1057'/'#1050'+'#1057'/'#1042' ('#1044#1072'/'#1053#1077#1090')'
      Hint = #1042#1099#1074#1086#1076#1080#1090#1100' '#1092#1088#1072#1079#1091' '#1076#1083#1103' '#1057'/'#1050'+'#1057'/'#1042' ('#1044#1072'/'#1053#1077#1090')'
      ImageIndex = 76
    end
    object actUpdate_SP_NormInDays_not: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_SP_NormInDays_not
      StoredProcList = <
        item
          StoredProc = spUpdate_SP_NormInDays_not
        end
        item
          StoredProc = spSelectProperty
        end>
      Caption = #1053#1077' '#1080#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1089#1074'-'#1074#1086' "'#1089#1088#1086#1082' '#1074' '#1076#1085#1103#1093'"('#1044#1072'/'#1053#1077#1090')'
      Hint = #1053#1077' '#1080#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1089#1074'-'#1074#1086' "'#1089#1088#1086#1082' '#1074' '#1076#1085#1103#1093'" ('#1044#1072'/'#1053#1077#1090')'
      ImageIndex = 77
    end
  end
  object spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Sticker'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <
      item
        Name = 'inShowErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
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
    Left = 216
    Top = 224
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 88
    Top = 256
  end
  object spErasedUnErased: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_isErased_Sticker'
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
    Left = 160
    Top = 160
  end
  object dsdDBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView
    OnDblClickActionList = <
      item
        Action = actUpdate
      end
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
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    ViewDocumentList = <>
    PropertiesCellList = <>
    Left = 648
    Top = 256
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_Sticker'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCode'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Code'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'JuridicalId'
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
        Name = 'inStickerFileId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'StickerFileId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStickerFileId_70_70'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'StickerFileId_70_70'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStickerGroupName'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'StickerGroupName'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStickerTypeName'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'StickerTypeName'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStickerTagName'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'StickerTagName'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStickerSortName'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'StickerSortName'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStickerNormName'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'StickerNormName'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInfo'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Info'
        DataType = ftWideString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue1'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Value1'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue2'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Value2'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue3'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Value3'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue4'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Value4'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue5'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Value5'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue6'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Value6'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue7'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Value7'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue8'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Value8'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 320
    Top = 216
  end
  object PeriodChoice: TPeriodChoice
    Left = 480
    Top = 120
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = PeriodChoice
      end>
    Left = 536
    Top = 160
  end
  object CDSProperty: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'StickerId'
    MasterFields = 'Id'
    MasterSource = DataSource
    PacketRecords = 0
    Params = <>
    Left = 397
    Top = 461
  end
  object DSProperty: TDataSource
    DataSet = CDSProperty
    Left = 294
    Top = 445
  end
  object spSelectProperty: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_StickerProperty'
    DataSet = CDSProperty
    DataSets = <
      item
        DataSet = CDSProperty
      end>
    Params = <
      item
        Name = 'inShowAll'
        Value = Null
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 529
    Top = 461
  end
  object spInsertUpdateStickerProperty: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_StickerProperty'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = CDSProperty
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCode'
        Value = Null
        Component = CDSProperty
        ComponentItem = 'Code'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = CDSProperty
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStickerId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindId'
        Value = Null
        Component = CDSProperty
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStickerFileId'
        Value = Null
        Component = CDSProperty
        ComponentItem = 'StickerFileId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStickerFileId_70_70'
        Value = Null
        Component = CDSProperty
        ComponentItem = 'StickerFileId_70_70'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStickerSkinName'
        Value = Null
        Component = CDSProperty
        ComponentItem = 'StickerSkinName'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStickerPackName'
        Value = Null
        Component = CDSProperty
        ComponentItem = 'StickerPackName'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBarCode'
        Value = Null
        Component = CDSProperty
        ComponentItem = 'BarCode'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisFix'
        Value = Null
        Component = CDSProperty
        ComponentItem = 'isFix'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue1'
        Value = Null
        Component = CDSProperty
        ComponentItem = 'Value1'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue2'
        Value = Null
        Component = CDSProperty
        ComponentItem = 'Value2'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue3'
        Value = Null
        Component = CDSProperty
        ComponentItem = 'Value3'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue4'
        Value = Null
        Component = CDSProperty
        ComponentItem = 'Value4'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue5'
        Value = Null
        Component = CDSProperty
        ComponentItem = 'Value5'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue6'
        Value = Null
        Component = CDSProperty
        ComponentItem = 'Value6'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue7'
        Value = Null
        Component = CDSProperty
        ComponentItem = 'Value7'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue8'
        Value = Null
        Component = CDSProperty
        ComponentItem = 'Value8'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue9'
        Value = Null
        Component = CDSProperty
        ComponentItem = 'Value9'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue10'
        Value = Null
        Component = CDSProperty
        ComponentItem = 'Value10'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue11'
        Value = Null
        Component = CDSProperty
        ComponentItem = 'Value11'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 616
    Top = 456
  end
  object dsdDBViewAddOnStickerProperty: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableViewProperty
    OnDblClickActionList = <
      item
        Action = actUpdate
      end
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
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    ViewDocumentList = <>
    PropertiesCellList = <>
    Left = 360
    Top = 376
  end
  object spErasedUnErasedProperty: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_isErased_StickerProperty'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        Component = CDSProperty
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 192
    Top = 464
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'StickerId'
        Value = ''
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'StickerName'
        Value = ''
        Component = ClientDataSet
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameSticker'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ImportSettingId'
        Value = Null
        MultiSelectSeparator = ','
      end>
    Left = 536
    Top = 248
  end
  object spGetReportNameSticker: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Sticker_ReportName'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        Component = CDSProperty
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIs70_70'
        Value = Null
        Component = cb70_70
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'gpGet_Object_Sticker_ReportName'
        Value = Null
        Component = FormParams
        ComponentItem = 'ReportNameSticker'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 720
    Top = 152
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 836
    Top = 137
  end
  object spSelectPrint: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_StickerProperty_Print'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end>
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        Component = CDSProperty
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRetailId'
        Value = Null
        Component = GuidesRetail
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsJPG'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsLength'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIs70_70'
        Value = Null
        Component = cb70_70
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsStartEnd'
        Value = Null
        Component = cbStartEnd
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsTare'
        Value = Null
        Component = cbTare
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsPartion'
        Value = Null
        Component = cbPartion
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsGoodsName'
        Value = Null
        Component = cbGoodsName
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDateStart'
        Value = Null
        Component = deDateStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDateTare'
        Value = Null
        Component = deDateTare
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDatePack'
        Value = Null
        Component = deDatePack
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDateProduction'
        Value = Null
        Component = deDateProduction
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inNumPack'
        Value = Null
        Component = ceNumPack
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inNumTech'
        Value = Null
        Component = ceNumTech
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWeight'
        Value = Null
        Component = edWeight
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 575
    Top = 96
  end
  object spInsertReportName: TdsdStoredProc
    StoredProcName = 'gpInsert_Object_Sticker_ReportName'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inReportName'
        Value = Null
        Component = FormParams
        ComponentItem = 'ReportNameSticker'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 616
    Top = 184
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
        Value = 'TStickerForm;zc_Object_ImportSetting_Sticker'
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
    Left = 56
    Top = 440
  end
  object spSelectPrintJPG: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_StickerProperty_Print'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end>
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        Component = CDSProperty
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRetailId'
        Value = Null
        Component = GuidesRetail
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsJPG'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsLength'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIs70_70'
        Value = Null
        Component = cb70_70
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsStartEnd'
        Value = True
        Component = cbStartEnd
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsTare'
        Value = False
        Component = cbTare
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsPartion'
        Value = False
        Component = cbPartion
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsGoodsName'
        Value = True
        Component = cbGoodsName
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDateStart'
        Value = 42370d
        Component = deDateStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDateTare'
        Value = 42370d
        Component = deDateTare
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDatePack'
        Value = 42370d
        Component = deDatePack
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDateProduction'
        Value = 42370d
        Component = deDateProduction
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inNumPack'
        Value = 1.000000000000000000
        Component = ceNumPack
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inNumTech'
        Value = 1.000000000000000000
        Component = ceNumTech
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWeight'
        Value = Null
        Component = edWeight
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 623
    Top = 120
  end
  object spSelectPrintJPGLen: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_StickerProperty_Print'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end>
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        Component = CDSProperty
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRetailId'
        Value = Null
        Component = GuidesRetail
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsJPG'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsLength'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIs70_70'
        Value = Null
        Component = cb70_70
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsStartEnd'
        Value = True
        Component = cbStartEnd
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsTare'
        Value = False
        Component = cbTare
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsPartion'
        Value = False
        Component = cbPartion
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsGoodsName'
        Value = True
        Component = cbGoodsName
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDateStart'
        Value = 42370d
        Component = deDateStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDateTare'
        Value = 42370d
        Component = deDateTare
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDatePack'
        Value = 42370d
        Component = deDatePack
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDateProduction'
        Value = 42370d
        Component = deDateProduction
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inNumPack'
        Value = 1.000000000000000000
        Component = ceNumPack
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inNumTech'
        Value = 1.000000000000000000
        Component = ceNumTech
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWeight'
        Value = Null
        Component = edWeight
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 695
    Top = 88
  end
  object spUpdate_StickerProperty_CK: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_StickerProperty_CK'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = CDSProperty
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisCK'
        Value = Null
        Component = CDSProperty
        ComponentItem = 'isCK'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 451
    Top = 518
  end
  object GuidesRetail: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceRetail
    FormNameParam.Value = 'TRetailForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TRetailForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesRetail
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesRetail
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsPropertyId'
        Value = Null
        Component = GuidesGoodsProperty
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsPropertyName'
        Value = Null
        Component = GuidesGoodsProperty
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'OrderExternalId'
        Value = Null
        Component = GuidesOrderExternal
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'OrderExternalInvNumber'
        Value = Null
        Component = GuidesOrderExternal
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 448
    Top = 5
  end
  object GuidesOrderExternal: TdsdGuides
    KeyField = 'Id'
    LookupControl = edOrderExternal
    Key = '0'
    FormNameParam.Value = 'TOrderExternalJournalChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TOrderExternalJournalChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GuidesOrderExternal
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesOrderExternal
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 156
    Top = 48
  end
  object GuidesGoodsProperty: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoodsProperty
    DisableGuidesOpen = True
    FormNameParam.Value = 'TGoodsPropertyForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsPropertyForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGoodsProperty
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGoodsProperty
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 504
    Top = 45
  end
  object spGet_Params: TdsdStoredProc
    StoredProcName = 'gpGet_Params_byOrderExternal'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = GuidesOrderExternal
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRetailId'
        Value = Null
        Component = GuidesRetail
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsPropertyId'
        Value = ''
        Component = GuidesGoodsProperty
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsPropertyName'
        Value = ''
        Component = GuidesGoodsProperty
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'RetailId'
        Value = ''
        Component = GuidesRetail
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'RetailName'
        Value = ''
        Component = GuidesRetail
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId'
        Value = Null
        Component = GuidesOrderExternal
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber'
        Value = Null
        Component = GuidesOrderExternal
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 776
    Top = 224
  end
  object spUpdate_SP_NormInDays_not: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_StickerProperty_NormInDays_not'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = CDSProperty
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisNormInDays_not'
        Value = Null
        Component = CDSProperty
        ComponentItem = 'isNormInDays_not'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 315
    Top = 526
  end
end
