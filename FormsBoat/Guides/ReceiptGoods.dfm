object ReceiptGoodsForm: TReceiptGoodsForm
  Left = 0
  Top = 0
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1064#1072#1073#1083#1086#1085' '#1089#1073#1086#1088#1082#1072' '#1059#1079#1083#1086#1074'>'
  ClientHeight = 558
  ClientWidth = 1272
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
  AddOnFormData.ChoiceAction = actChoiceGuides
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object PanelMaster: TPanel
    Left = 0
    Top = 59
    Width = 1272
    Height = 225
    Align = alTop
    BevelEdges = [beLeft]
    BevelOuter = bvNone
    TabOrder = 1
    object cxGrid: TcxGrid
      Left = 0
      Top = 17
      Width = 1272
      Height = 208
      Align = alClient
      PopupMenu = PopupMenu
      TabOrder = 0
      LookAndFeel.NativeStyle = True
      LookAndFeel.SkinName = 'UserSkin'
      object cxGridDBTableView: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = DataSource
        DataController.Filter.Options = [fcoCaseInsensitive]
        DataController.Summary.DefaultGroupSummaryItems = <
          item
            Format = ',0.00##'
            Kind = skSum
            Column = EKPrice_summ
          end
          item
            Format = ',0.00##'
            Kind = skSum
            Column = EKPriceWVAT_summ
          end
          item
            Format = ',0.00##'
            Kind = skSum
            Column = EKPrice_summ_colPat
          end
          item
            Format = ',0.00##'
            Kind = skSum
            Column = EKPrice_summ_goods
          end
          item
            Format = ',0.00##'
            Kind = skSum
            Column = EKPriceWVAT_summ_colPat
          end
          item
            Format = ',0.00##'
            Kind = skSum
            Column = EKPriceWVAT_summ_goods
          end>
        DataController.Summary.FooterSummaryItems = <
          item
            Format = 'C'#1090#1088#1086#1082': ,0'
            Kind = skCount
            Column = Name
          end
          item
            Format = ',0.00##'
            Kind = skSum
            Column = EKPrice_summ
          end
          item
            Format = ',0.00##'
            Kind = skSum
            Column = EKPriceWVAT_summ
          end
          item
            Format = ',0.00##'
            Kind = skSum
            Column = EKPrice_summ_colPat
          end
          item
            Format = ',0.00##'
            Kind = skSum
            Column = EKPrice_summ_goods
          end
          item
            Format = ',0.00##'
            Kind = skSum
            Column = EKPriceWVAT_summ_colPat
          end
          item
            Format = ',0.00##'
            Kind = skSum
            Column = EKPriceWVAT_summ_goods
          end>
        DataController.Summary.SummaryGroups = <>
        Images = dmMain.SortImageList
        OptionsCustomize.ColumnHiding = True
        OptionsCustomize.ColumnsQuickCustomization = True
        OptionsData.Deleting = False
        OptionsData.DeletingConfirmation = False
        OptionsData.Editing = False
        OptionsData.Inserting = False
        OptionsView.CellAutoHeight = True
        OptionsView.Footer = True
        OptionsView.GroupSummaryLayout = gslAlignWithColumns
        OptionsView.HeaderAutoHeight = True
        OptionsView.HeaderHeight = 40
        OptionsView.Indicator = True
        Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
        object isMain: TcxGridDBColumn
          Caption = #1043#1083#1072#1074#1085#1099#1081' ('#1076#1072'/'#1085#1077#1090')'
          DataBinding.FieldName = 'isMain'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1043#1083#1072#1074#1085#1099#1081' ('#1076#1072'/'#1085#1077#1090')'
          Options.Editing = False
          Width = 72
        end
        object Code: TcxGridDBColumn
          Caption = #1050#1086#1076
          DataBinding.FieldName = 'Code'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 43
        end
        object UserCode: TcxGridDBColumn
          Caption = #1055#1086#1083#1100#1079'. '#1050#1086#1076
          DataBinding.FieldName = 'UserCode'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100#1089#1082#1080#1081' '#1050#1086#1076
          Options.Editing = False
          Width = 92
        end
        object Name: TcxGridDBColumn
          Caption = #1053#1072#1079#1074#1072#1085#1080#1077
          DataBinding.FieldName = 'Name'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderGlyphAlignmentHorz = taCenter
          Options.Editing = False
          Width = 189
        end
        object ColorPatternName: TcxGridDBColumn
          Caption = #1064#1072#1073#1083#1086#1085' Boat Structure '
          DataBinding.FieldName = 'ColorPatternName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderGlyphAlignmentHorz = taCenter
          Options.Editing = False
          Width = 125
        end
        object MaterialOptionsName: TcxGridDBColumn
          Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1054#1087#1094#1080#1081
          DataBinding.FieldName = 'MaterialOptionsName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 70
        end
        object ProdColorName_pcp: TcxGridDBColumn
          Caption = 'Farbe'
          DataBinding.FieldName = 'ProdColorName_pcp'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = 'Farbe Boat Structure'
          Width = 70
        end
        object Article: TcxGridDBColumn
          Caption = 'Artikel Nr'
          DataBinding.FieldName = 'Article'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Action = actChoiceFormGoods_1
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
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
        object GoodsGroupName: TcxGridDBColumn
          Caption = #1043#1088#1091#1087#1087#1072
          DataBinding.FieldName = 'GoodsGroupName'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 172
        end
        object GoodsCode: TcxGridDBColumn
          Caption = 'Interne Nr'
          DataBinding.FieldName = 'GoodsCode'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1042#1085#1091#1090#1088#1077#1085#1085#1080#1081' '#1082#1086#1076
          Options.Editing = False
          Width = 60
        end
        object GoodsName: TcxGridDBColumn
          Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077
          DataBinding.FieldName = 'GoodsName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 164
        end
        object MeasureName: TcxGridDBColumn
          Caption = #1045#1076'. '#1080#1079#1084'.'
          DataBinding.FieldName = 'MeasureName'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 40
        end
        object EKPrice_summ: TcxGridDBColumn
          Caption = 'Total EK'
          DataBinding.FieldName = 'EKPrice_summ'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1048#1058#1054#1043#1054' '#1057#1091#1084#1084#1072' '#1074#1093'. '#1073#1077#1079' '#1053#1044#1057
          Options.Editing = False
          Width = 70
        end
        object EKPriceWVAT_summ: TcxGridDBColumn
          Caption = #1057#1091#1084#1084#1072' '#1074#1093'. '#1089' '#1053#1044#1057
          DataBinding.FieldName = 'EKPriceWVAT_summ'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1048#1058#1054#1043#1054' '#1057#1091#1084#1084#1072' '#1074#1093'. '#1089' '#1053#1044#1057
          Options.Editing = False
          Width = 70
        end
        object EKPrice_summ_goods: TcxGridDBColumn
          Caption = 'Total EK (art.)'
          DataBinding.FieldName = 'EKPrice_summ_goods'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1057#1091#1084#1084#1072' '#1074#1093'. '#1073#1077#1079' '#1053#1044#1057' ('#1082#1086#1084#1087#1083#1077#1082#1090'.)'
          Options.Editing = False
          Width = 70
        end
        object EKPrice_summ_colPat: TcxGridDBColumn
          Caption = 'Total EK (Items)'
          DataBinding.FieldName = 'EKPrice_summ_colPat'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1057#1091#1084#1084#1072' '#1074#1093'. '#1073#1077#1079' '#1053#1044#1057' (Items Boat Structure)'
          Options.Editing = False
          Width = 70
        end
        object EKPriceWVAT_summ_goods: TcxGridDBColumn
          Caption = #1057#1091#1084#1084#1072' '#1074#1093'. '#1089' '#1053#1044#1057' (art.)'
          DataBinding.FieldName = 'EKPriceWVAT_summ_goods'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1057#1091#1084#1084#1072' '#1074#1093'. '#1089' '#1053#1044#1057' ('#1082#1086#1084#1087#1083#1077#1082#1090'.)'
          Options.Editing = False
          Width = 70
        end
        object EKPriceWVAT_summ_colPat: TcxGridDBColumn
          Caption = #1057#1091#1084#1084#1072' '#1074#1093'. '#1089' '#1053#1044#1057' (Items)'
          DataBinding.FieldName = 'EKPriceWVAT_summ_colPat'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1057#1091#1084#1084#1072' '#1074#1093'. '#1089' '#1053#1044#1057' (Items Boat Structure)'
          Options.Editing = False
          Width = 70
        end
        object BasisPrice: TcxGridDBColumn
          Caption = 'Ladenpreis'
          DataBinding.FieldName = 'BasisPrice'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1062#1077#1085#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1077#1079' '#1085#1076#1089
          Options.Editing = False
          Width = 70
        end
        object BasisPriceWVAT: TcxGridDBColumn
          Caption = #1062#1077#1085#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1089' '#1085#1076#1089
          DataBinding.FieldName = 'BasisPriceWVAT'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1062#1077#1085#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1089' '#1085#1076#1089
          Options.Editing = False
          Width = 70
        end
        object Comment: TcxGridDBColumn
          Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
          DataBinding.FieldName = 'Comment'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderGlyphAlignmentHorz = taCenter
          Options.Editing = False
          Width = 179
        end
        object InsertDate: TcxGridDBColumn
          Caption = #1044#1072#1090#1072' ('#1089#1086#1079#1076'.)'
          DataBinding.FieldName = 'InsertDate'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 55
        end
        object InsertName: TcxGridDBColumn
          Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076'.)'
          DataBinding.FieldName = 'InsertName'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 70
        end
        object UpdateDate: TcxGridDBColumn
          Caption = #1044#1072#1090#1072' ('#1082#1086#1088#1088'.)'
          DataBinding.FieldName = 'UpdateDate'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 55
        end
        object UpdateName: TcxGridDBColumn
          Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1082#1086#1088#1088'.)'
          DataBinding.FieldName = 'UpdateName'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 70
        end
        object isErased: TcxGridDBColumn
          Caption = #1059#1076#1072#1083#1077#1085
          DataBinding.FieldName = 'isErased'
          PropertiesClassName = 'TcxCheckBoxProperties'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 78
        end
      end
      object cxGridLevel: TcxGridLevel
        GridView = cxGridDBTableView
      end
    end
    object Panel3: TPanel
      Left = 0
      Top = 0
      Width = 1272
      Height = 17
      Align = alTop
      Caption = #1057#1073#1086#1088#1082#1072' '#1091#1079#1083#1086#1074
      Color = clSkyBlue
      ParentBackground = False
      TabOrder = 1
    end
  end
  object PanelGoods: TPanel
    Left = 0
    Top = 289
    Width = 567
    Height = 269
    Align = alLeft
    BevelEdges = [beLeft]
    BevelOuter = bvNone
    TabOrder = 0
    object cxGridCh1: TcxGrid
      Left = 0
      Top = 17
      Width = 567
      Height = 252
      Align = alClient
      PopupMenu = PopupMenuColor
      TabOrder = 0
      LookAndFeel.NativeStyle = True
      LookAndFeel.SkinName = 'UserSkin'
      object cxGridDBTableViewCh1: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = Child1DS
        DataController.Filter.Options = [fcoCaseInsensitive]
        DataController.Summary.DefaultGroupSummaryItems = <
          item
            Format = ',0.00##;-,0.00##; ;'
            Kind = skSum
            Column = Value_ch1
          end
          item
            Format = ',0.00##;-,0.00##; ;'
            Kind = skSum
            Column = Value_service_ch1
          end
          item
            Format = ',0.00##'
            Kind = skSum
            Column = EKPrice_summ_ch1
          end
          item
            Format = ',0.00##'
            Kind = skSum
            Column = EKPriceWVAT_summ_ch1
          end>
        DataController.Summary.FooterSummaryItems = <
          item
            Format = 'C'#1090#1088#1086#1082': ,0'
            Kind = skCount
            Column = ObjectName_ch1
          end
          item
            Format = ',0.00##;-,0.00##; ;'
            Kind = skSum
            Column = Value_ch1
          end
          item
            Format = ',0.00##;-,0.00##; ;'
            Kind = skSum
            Column = Value_service_ch1
          end
          item
            Format = ',0.00##'
            Kind = skSum
            Column = EKPrice_summ_ch1
          end
          item
            Format = ',0.00##'
            Kind = skSum
            Column = EKPriceWVAT_summ_ch1
          end>
        DataController.Summary.SummaryGroups = <>
        Images = dmMain.SortImageList
        OptionsCustomize.ColumnHiding = True
        OptionsCustomize.ColumnsQuickCustomization = True
        OptionsData.Appending = True
        OptionsData.Deleting = False
        OptionsData.DeletingConfirmation = False
        OptionsView.CellAutoHeight = True
        OptionsView.Footer = True
        OptionsView.GroupSummaryLayout = gslAlignWithColumns
        OptionsView.HeaderAutoHeight = True
        OptionsView.HeaderHeight = 40
        OptionsView.Indicator = True
        Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
        object NPP_ch1: TcxGridDBColumn
          Caption = #8470' '#1087'/'#1087
          DataBinding.FieldName = 'NPP'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 40
        end
        object DescName_ch1: TcxGridDBColumn
          Caption = #1069#1083#1077#1084#1077#1085#1090
          DataBinding.FieldName = 'DescName'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 70
        end
        object GoodsGroupNameFull_ch1: TcxGridDBColumn
          Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
          DataBinding.FieldName = 'GoodsGroupNameFull'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 150
        end
        object GoodsGroupName_ch1: TcxGridDBColumn
          Caption = #1043#1088#1091#1087#1087#1072
          DataBinding.FieldName = 'GoodsGroupName'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 172
        end
        object ObjectCode_ch1: TcxGridDBColumn
          Caption = 'Interne Nr'
          DataBinding.FieldName = 'ObjectCode'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1042#1085#1091#1090#1088#1077#1085#1085#1080#1081' '#1082#1086#1076
          Options.Editing = False
          Width = 60
        end
        object Article_ch1: TcxGridDBColumn
          Caption = 'Artikel Nr'
          DataBinding.FieldName = 'Article'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Action = actChoiceFormGoods_1
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 55
        end
        object Article_all_ch1: TcxGridDBColumn
          Caption = '***Artikel Nr'
          DataBinding.FieldName = 'Article_all'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 70
        end
        object ObjectName_ch1: TcxGridDBColumn
          Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077' / '#1056#1072#1073#1086#1090#1099'/'#1059#1089#1083#1091#1075#1080
          DataBinding.FieldName = 'ObjectName'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Action = actChoiceFormGoods_1
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 150
        end
        object ProdColorName_ch1: TcxGridDBColumn
          Caption = 'Farbe'
          DataBinding.FieldName = 'ProdColorName'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 70
        end
        object MaterialOptionsName_ch1: TcxGridDBColumn
          Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1054#1087#1094#1080#1081
          DataBinding.FieldName = 'MaterialOptionsName'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Action = actChoiceFormMaterialOptions_1
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 70
        end
        object MeasureName_ch1: TcxGridDBColumn
          Caption = #1045#1076'. '#1080#1079#1084'.'
          DataBinding.FieldName = 'MeasureName'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 55
        end
        object Value_ch1: TcxGridDBColumn
          DataBinding.FieldName = 'Value'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1047#1085#1072#1095#1077#1085#1080#1077' '#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077
          Width = 45
        end
        object Value_service_ch1: TcxGridDBColumn
          Caption = 'Value (service)'
          DataBinding.FieldName = 'Value_service'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1047#1085#1072#1095#1077#1085#1080#1077' '#1056#1072#1073#1086#1090#1099'/'#1059#1089#1083#1091#1075#1080
          Options.Editing = False
          Width = 63
        end
        object EKPrice_ch1: TcxGridDBColumn
          Caption = 'Netto EK'
          DataBinding.FieldName = 'EKPrice'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1062#1077#1085#1072' '#1074#1093'. '#1073#1077#1079' '#1053#1044#1057
          Options.Editing = False
          Width = 70
        end
        object EKPriceWVAT_ch1: TcxGridDBColumn
          Caption = #1062#1077#1085#1072' '#1074#1093'. '#1089' '#1053#1044#1057
          DataBinding.FieldName = 'EKPriceWVAT'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1062#1077#1085#1072' '#1074#1093'. '#1089' '#1053#1044#1057
          Options.Editing = False
          Width = 70
        end
        object EKPrice_summ_ch1: TcxGridDBColumn
          Caption = 'Total EK'
          DataBinding.FieldName = 'EKPrice_summ'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1057#1091#1084#1084#1072' '#1074#1093'. '#1073#1077#1079' '#1053#1044#1057
          Options.Editing = False
          Width = 70
        end
        object EKPriceWVAT_summ_ch1: TcxGridDBColumn
          Caption = #1057#1091#1084#1084#1072' '#1074#1093'. '#1089' '#1053#1044#1057
          DataBinding.FieldName = 'EKPriceWVAT_summ'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1057#1091#1084#1084#1072' '#1074#1093'. '#1089' '#1053#1044#1057
          Options.Editing = False
          Width = 70
        end
        object Comment_ch1: TcxGridDBColumn
          Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
          DataBinding.FieldName = 'Comment'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderGlyphAlignmentHorz = taCenter
          Width = 100
        end
        object InsertDate_ch1: TcxGridDBColumn
          Caption = #1044#1072#1090#1072' ('#1089#1086#1079#1076'.)'
          DataBinding.FieldName = 'InsertDate'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 55
        end
        object InsertName_ch1: TcxGridDBColumn
          Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076'.)'
          DataBinding.FieldName = 'InsertName'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 70
        end
        object UpdateDate_ch1: TcxGridDBColumn
          Caption = #1044#1072#1090#1072' ('#1082#1086#1088#1088'.)'
          DataBinding.FieldName = 'UpdateDate'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 55
        end
        object UpdateName_ch1: TcxGridDBColumn
          Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1082#1086#1088#1088'.)'
          DataBinding.FieldName = 'UpdateName'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 70
        end
        object isErased_ch1: TcxGridDBColumn
          Caption = #1059#1076#1072#1083#1077#1085
          DataBinding.FieldName = 'isErased'
          PropertiesClassName = 'TcxCheckBoxProperties'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 78
        end
        object Color_value_ch1: TcxGridDBColumn
          DataBinding.FieldName = 'Color_value'
          Visible = False
          Options.Editing = False
          VisibleForCustomization = False
          Width = 60
        end
        object Color_Level_ch1: TcxGridDBColumn
          DataBinding.FieldName = 'Color_Level'
          Visible = False
          Options.Editing = False
          VisibleForCustomization = False
          Width = 30
        end
      end
      object cxGridLevel1: TcxGridLevel
        GridView = cxGridDBTableViewCh1
      end
    end
    object Panel1: TPanel
      Left = 0
      Top = 0
      Width = 567
      Height = 17
      Align = alTop
      Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077' / '#1056#1072#1073#1086#1090#1099'/'#1059#1089#1083#1091#1075#1080
      Color = clAqua
      ParentBackground = False
      TabOrder = 1
    end
  end
  object cxTopSplitter: TcxSplitter
    Left = 0
    Top = 284
    Width = 1272
    Height = 5
    AlignSplitter = salTop
    Control = PanelMaster
  end
  object cxRightSplitter: TcxSplitter
    Left = 1264
    Top = 289
    Width = 8
    Height = 269
    AlignSplitter = salRight
  end
  object Panel2: TPanel
    Left = 575
    Top = 289
    Width = 689
    Height = 269
    Align = alClient
    Caption = 'Panel2'
    TabOrder = 5
    object cxGridCh2: TcxGrid
      Left = 1
      Top = 18
      Width = 687
      Height = 250
      Align = alClient
      PopupMenu = PopupMenuColor
      TabOrder = 0
      LookAndFeel.NativeStyle = True
      LookAndFeel.SkinName = 'UserSkin'
      object cxGridDBTableViewCh2: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = Child2DS
        DataController.Filter.Options = [fcoCaseInsensitive]
        DataController.Summary.DefaultGroupSummaryItems = <
          item
            Format = ',0.00##'
            Kind = skSum
            Column = EKPrice_summ_ch2
          end
          item
            Format = ',0.00##'
            Kind = skSum
            Column = EKPriceWVAT_summ_ch2
          end>
        DataController.Summary.FooterSummaryItems = <
          item
            Format = 'C'#1090#1088#1086#1082': ,0'
            Kind = skCount
            Column = ProdColorGroupName_ch2
          end
          item
            Format = ',0.00##'
            Kind = skSum
            Column = EKPrice_summ_ch2
          end
          item
            Format = ',0.00##'
            Kind = skSum
            Column = EKPriceWVAT_summ_ch2
          end
          item
            Format = ',0.00##'
            Kind = skSum
          end
          item
            Format = ',0.00##'
            Kind = skSum
          end>
        DataController.Summary.SummaryGroups = <>
        Images = dmMain.SortImageList
        OptionsCustomize.ColumnHiding = True
        OptionsCustomize.ColumnsQuickCustomization = True
        OptionsData.Appending = True
        OptionsData.Deleting = False
        OptionsData.DeletingConfirmation = False
        OptionsView.CellAutoHeight = True
        OptionsView.Footer = True
        OptionsView.GroupSummaryLayout = gslAlignWithColumns
        OptionsView.HeaderAutoHeight = True
        OptionsView.HeaderHeight = 40
        OptionsView.Indicator = True
        Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
        object isEnabled_ch2: TcxGridDBColumn
          Caption = 'Yes/no'
          DataBinding.FieldName = 'isEnabled'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 35
        end
        object NPP_ch2: TcxGridDBColumn
          Caption = #8470' '#1087'/'#1087
          DataBinding.FieldName = 'NPP'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 40
        end
        object ProdColorGroupName_ch2: TcxGridDBColumn
          Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103
          DataBinding.FieldName = 'ProdColorGroupName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1050#1072#1090#1077#1075#1086#1088#1080#1103
          Options.Editing = False
          Width = 127
        end
        object ProdColorPatternName_ch2: TcxGridDBColumn
          Caption = #1069#1083#1077#1084#1077#1085#1090
          DataBinding.FieldName = 'ProdColorPatternName'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Action = actChoiceFormProdColorPattern_2
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 58
        end
        object ProdColorName_ch2: TcxGridDBColumn
          Caption = 'Farbe'
          DataBinding.FieldName = 'ProdColorName'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Action = actChoiceFormProdColor_goods_2
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 80
        end
        object MaterialOptionsName_ch2: TcxGridDBColumn
          Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1054#1087#1094#1080#1081
          DataBinding.FieldName = 'MaterialOptionsName'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Action = actChoiceFormMaterialOptions_2
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 70
        end
        object Value_ch2: TcxGridDBColumn
          DataBinding.FieldName = 'Value'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1047#1085#1072#1095#1077#1085#1080#1077
          Width = 45
        end
        object GoodsGroupNameFull_ch2: TcxGridDBColumn
          Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
          DataBinding.FieldName = 'GoodsGroupNameFull'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 150
        end
        object GoodsGroupName_2: TcxGridDBColumn
          Caption = #1043#1088#1091#1087#1087#1072
          DataBinding.FieldName = 'GoodsGroupName'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 172
        end
        object GoodsCode_ch2: TcxGridDBColumn
          Caption = 'Interne Nr'
          DataBinding.FieldName = 'GoodsCode'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1042#1085#1091#1090#1088#1077#1085#1085#1080#1081' '#1082#1086#1076
          Options.Editing = False
          Width = 60
        end
        object Article_2: TcxGridDBColumn
          Caption = 'Artikel Nr'
          DataBinding.FieldName = 'Article'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Action = actChoiceFormGoods_2
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 55
        end
        object GoodsName_ch2: TcxGridDBColumn
          Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077
          DataBinding.FieldName = 'GoodsName'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Action = actChoiceFormGoods_2
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 110
        end
        object MeasureName_ch2: TcxGridDBColumn
          Caption = #1045#1076'. '#1080#1079#1084'.'
          DataBinding.FieldName = 'MeasureName'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 55
        end
        object EKPriceWVAT_ch2: TcxGridDBColumn
          Caption = #1062#1077#1085#1072' '#1074#1093'. '#1089' '#1053#1044#1057
          DataBinding.FieldName = 'EKPriceWVAT'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1062#1077#1085#1072' '#1074#1093'. '#1089' '#1053#1044#1057
          Options.Editing = False
          Width = 70
        end
        object EKPrice_ch2: TcxGridDBColumn
          Caption = 'Netto EK'
          DataBinding.FieldName = 'EKPrice'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1062#1077#1085#1072' '#1074#1093'. '#1073#1077#1079' '#1053#1044#1057
          Options.Editing = False
          Width = 70
        end
        object EKPrice_summ_ch2: TcxGridDBColumn
          Caption = 'Total EK'
          DataBinding.FieldName = 'EKPrice_summ'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1057#1091#1084#1084#1072' '#1074#1093'. '#1073#1077#1079' '#1053#1044#1057
          Options.Editing = False
          Width = 70
        end
        object EKPriceWVAT_summ_ch2: TcxGridDBColumn
          Caption = #1057#1091#1084#1084#1072' '#1074#1093'. '#1089' '#1053#1044#1057
          DataBinding.FieldName = 'EKPriceWVAT_summ'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1057#1091#1084#1084#1072' '#1074#1093'. '#1089' '#1053#1044#1057
          Options.Editing = False
          Width = 70
        end
        object Comment_ch2: TcxGridDBColumn
          Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
          DataBinding.FieldName = 'Comment'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderGlyphAlignmentHorz = taCenter
          Width = 100
        end
        object isErased_ch2: TcxGridDBColumn
          Caption = #1059#1076#1072#1083#1077#1085
          DataBinding.FieldName = 'isErased'
          PropertiesClassName = 'TcxCheckBoxProperties'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 78
        end
      end
      object cxGridLevel2: TcxGridLevel
        GridView = cxGridDBTableViewCh2
      end
    end
    object Panel4: TPanel
      Left = 1
      Top = 1
      Width = 687
      Height = 17
      Align = alTop
      Caption = 'Boat Structure'
      Color = clLime
      ParentBackground = False
      TabOrder = 1
      ExplicitLeft = -2
    end
  end
  object cxSplitter1: TcxSplitter
    Left = 567
    Top = 289
    Width = 8
    Height = 269
    Control = PanelGoods
  end
  object Panel5: TPanel
    Left = 0
    Top = 0
    Width = 1272
    Height = 33
    Align = alTop
    TabOrder = 10
    object lbSearchArticle: TcxLabel
      Left = 22
      Top = 6
      Caption = #1055#1086#1080#1089#1082' Artikel Nr : '
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clBlue
      Style.Font.Height = -13
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
    end
    object edSearchArticle: TcxTextEdit
      Left = 147
      Top = 7
      TabOrder = 1
      DesignSize = (
        125
        21)
      Width = 125
    end
  end
  object DataSource: TDataSource
    DataSet = MasterCDS
    Left = 464
    Top = 96
  end
  object MasterCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 560
    Top = 136
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
    Left = 64
    Top = 144
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
    Left = 144
    Top = 128
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
          ItemName = 'BarSubItemBoat'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'BarSubItemColor'
        end
        item
          Visible = True
          ItemName = 'bbShowAll_ch1'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarSubItem1'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbShowAllErased'
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
          ItemName = 'bbChoice'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
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
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrintStructure'
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
          ItemName = 'bbToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridCh1ToExcel'
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
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
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
      Action = actSetErased
      Category = 0
    end
    object bbSetUnErased: TdxBarButton
      Action = actSetUnErased
      Category = 0
    end
    object bbToExcel: TdxBarButton
      Action = actGridToExcel
      Category = 0
    end
    object dxBarStatic: TdxBarStatic
      Caption = '     '
      Category = 0
      Hint = '     '
      Visible = ivAlways
      ShowCaption = False
    end
    object bbChoice: TdxBarButton
      Action = actChoiceGuides
      Category = 0
    end
    object bbProtocolOpenForm: TdxBarButton
      Action = actProtocol
      Category = 0
    end
    object bbShowAllErased: TdxBarButton
      Action = actShowAllErased
      Category = 0
    end
    object bbInsertRecordProdColorItems: TdxBarButton
      Action = actInsertRecordGoods
      Category = 0
    end
    object bbInsertRecordProdOptItems: TdxBarButton
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      Category = 0
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100
      Visible = ivAlways
      ImageIndex = 0
    end
    object bbSetErasedColor: TdxBarButton
      Action = actSetErasedGoods
      Category = 0
    end
    object bbSetUnErasedColor: TdxBarButton
      Action = actSetUnErasedGoods
      Category = 0
    end
    object bbSetErasedOpt: TdxBarButton
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Category = 0
      Hint = #1059#1076#1072#1083#1080#1090#1100
      Visible = ivAlways
      ImageIndex = 2
      ShortCut = 16430
    end
    object bbSetUnErasedOpt: TdxBarButton
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Category = 0
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      Visible = ivAlways
      ImageIndex = 8
      ShortCut = 16430
    end
    object bbStartLoad: TdxBarButton
      Action = mactStartLoad
      Category = 0
    end
    object bbShowAllColorItems: TdxBarButton
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1042#1089#1077' '#1096#1072#1073#1083#1086#1085#1099
      Category = 0
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1042#1089#1077' '#1096#1072#1073#1083#1086#1085#1099
      Visible = ivAlways
      ImageIndex = 63
    end
    object bbShowAllOptItems: TdxBarButton
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1042#1089#1077' '#1096#1072#1073#1083#1086#1085#1099
      Category = 0
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1042#1089#1077' '#1096#1072#1073#1083#1086#1085#1099
      Visible = ivAlways
      ImageIndex = 63
    end
    object BarSubItemBoat: TdxBarSubItem
      Caption = #1064#1072#1073#1083#1086#1085
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbInsert'
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
          ItemName = 'dxBarSeparator1'
        end
        item
          Visible = True
          ItemName = 'bbInsertEnter'
        end>
    end
    object BarSubItemColor: TdxBarSubItem
      Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbInsertRecordProdColorItems'
        end
        item
          Visible = True
          ItemName = 'bbSetErasedColor'
        end
        item
          Visible = True
          ItemName = 'bbSetUnErasedColor'
        end
        item
          Visible = True
          ItemName = 'bbBarSeparetor'
        end
        item
          Visible = True
          ItemName = 'bbInsertRecordGood'
        end>
    end
    object BarSubItemOption: TdxBarSubItem
      Caption = #1064#1072#1073#1083#1086#1085#1099' '#1062#1074#1077#1090#1072
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbInsertRecordProdOptItems'
        end
        item
          Visible = True
          ItemName = 'bbSetErasedOpt'
        end
        item
          Visible = True
          ItemName = 'bbSetUnErasedOpt'
        end>
    end
    object bbShowAllBoatSale: TdxBarButton
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077' '#1083#1086#1076#1082#1080' (+'#1087#1088#1086#1076#1072#1085#1085#1099#1077')'
      Category = 0
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077' '#1083#1086#1076#1082#1080' (+'#1087#1088#1086#1076#1072#1085#1085#1099#1077')'
      Visible = ivAlways
      ImageIndex = 63
    end
    object bbInsertRecordProdColorPattern: TdxBarButton
      Action = InsertRecordProdColorPattern
      Category = 0
    end
    object dxBarSubItem1: TdxBarSubItem
      Caption = 'Boat Structure'
      Category = 0
      Visible = ivNever
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbInsertRecordProdColorPattern'
        end
        item
          Visible = True
          ItemName = 'bbSetErasedProdColorPattern'
        end
        item
          Visible = True
          ItemName = 'bbUnErasedProdColorPattern'
        end>
    end
    object bbSetErasedProdColorPattern: TdxBarButton
      Action = actSetErasedProdColorPattern
      Category = 0
    end
    object bbUnErasedProdColorPattern: TdxBarButton
      Action = actUnErasedProdColorPattern
      Category = 0
    end
    object bbShowAll_ch1: TdxBarButton
      Action = actShowAll_ch2
      Category = 0
    end
    object bbPrintStructure: TdxBarButton
      Action = actPrintStructure
      Category = 0
    end
    object bbInsertRecordGood: TdxBarButton
      Action = actInsertRecordGoods_limit
      Category = 0
    end
    object bbBarSeparetor: TdxBarSeparator
      Caption = 'New Separator'
      Category = 0
      Hint = 'New Separator'
      Visible = ivAlways
      ShowCaption = False
    end
    object bbGridCh1ToExcel: TdxBarButton
      Action = actGridCh1ToExcel
      Category = 0
    end
    object bbInsertEnter: TdxBarButton
      Action = actInsertEnter
      Category = 0
    end
    object dxBarSeparator1: TdxBarSeparator
      Category = 0
      Visible = ivAlways
      ShowCaption = False
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 24
    Top = 96
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelect_child2
        end
        item
          StoredProc = spSelect_child1
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actInsertEnter: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = '***'#1044#1086#1073#1072#1074#1080#1090#1100
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100
      ImageIndex = 0
      FormName = 'TReceiptGoodsEditEnterForm'
      FormNameParam.Value = 'TReceiptGoodsEditEnterForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = '0'
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      DataSource = DataSource
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actInsert: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100
      ImageIndex = 0
      FormName = 'TReceiptGoodsEditForm'
      FormNameParam.Value = 'TReceiptGoodsEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = '0'
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      DataSource = DataSource
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actUpdate: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100
      ImageIndex = 1
      FormName = 'TReceiptGoodsEditForm'
      FormNameParam.Value = 'TReceiptGoodsEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
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
    object actSetErasedProdColorPattern: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedProdColorPattern
      StoredProcList = <
        item
          StoredProc = spErasedProdColorPattern
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100
      ImageIndex = 2
      ShortCut = 16430
      ErasedFieldName = 'isErased'
      DataSource = Child2DS
    end
    object actSetErasedGoods: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedGoods
      StoredProcList = <
        item
          StoredProc = spErasedGoods
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100
      ImageIndex = 2
      ShortCut = 8238
      ErasedFieldName = 'isErased'
      DataSource = Child1DS
    end
    object actSetErased: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErased
      StoredProcList = <
        item
          StoredProc = spErased
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = DataSource
    end
    object actUnErasedProdColorPattern: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spUnErasedProdColorPattern
      StoredProcList = <
        item
          StoredProc = spUnErasedProdColorPattern
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 16430
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = Child1DS
    end
    object actSetUnErasedGoods: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spUnErasedGoods
      StoredProcList = <
        item
          StoredProc = spUnErasedGoods
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 8238
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = Child1DS
    end
    object actSetUnErased: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spUnErased
      StoredProcList = <
        item
          StoredProc = spUnErased
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = DataSource
    end
    object actChoiceGuides: TdsdChoiceGuides
      Category = 'DSDLib'
      MoveParams = <>
      Params = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Name'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      Caption = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      Hint = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      ImageIndex = 7
      DataSource = DataSource
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
          Component = MasterCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Name'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actShowAllErased: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelect_child1
        end
        item
          StoredProc = spSelect_child2
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
    object actUpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = 'actUpdateDataSet'
      DataSource = DataSource
    end
    object InsertRecordProdColorPattern: TInsertRecord
      Category = 'DSDLib'
      MoveParams = <>
      Enabled = False
      PostDataSetBeforeExecute = False
      View = cxGridDBTableViewCh2
      Action = actChoiceFormProdColorPattern_2
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100
      ImageIndex = 0
    end
    object actInsertRecordGoods: TInsertRecord
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableViewCh1
      Action = actChoiceFormGoods_1
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100
      ImageIndex = 0
    end
    object actChoiceFormGoods_2: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceFormGoods_2'
      FormName = 'TGoodsForm'
      FormNameParam.Value = 'TGoodsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = Child2CDS
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = Child2CDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Article'
          Value = Null
          Component = Child2CDS
          ComponentItem = 'Article'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = Child2CDS
          ComponentItem = 'GoodsCode'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProdColorName'
          Value = Null
          Component = Child2CDS
          ComponentItem = 'ProdColorName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actChoiceFormMaterialOptions_2: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceFormMaterialOptions_2'
      FormName = 'TMaterialOptionsForm'
      FormNameParam.Value = 'TMaterialOptionsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = Child2CDS
          ComponentItem = 'MaterialOptionsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = Child2CDS
          ComponentItem = 'MaterialOptionsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actChoiceFormMaterialOptions_1: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceFormMaterialOptions_1'
      FormName = 'TMaterialOptionsForm'
      FormNameParam.Value = 'TMaterialOptionsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = Child1CDS
          ComponentItem = 'MaterialOptionsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = Child1CDS
          ComponentItem = 'MaterialOptionsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actChoiceFormGoods_1: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceFormGoods_1'
      FormName = 'TUnion_Goods_ReceiptServiceForm'
      FormNameParam.Value = 'TUnion_Goods_ReceiptServiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = Child1CDS
          ComponentItem = 'ObjectId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = Child1CDS
          ComponentItem = 'ObjectName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Article'
          Value = Null
          Component = Child1CDS
          ComponentItem = 'Article'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = Child1CDS
          ComponentItem = 'ObjectCode'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProdColorName'
          Value = Null
          Component = Child1CDS
          ComponentItem = 'ProdColorName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actChoiceFormProdColor_goods_2: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceFormProdColor_goods_2'
      FormName = 'TProdColor_goodsForm'
      FormNameParam.Value = 'TProdColor_goodsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'TextValue'
          Value = Null
          Component = Child2CDS
          ComponentItem = 'ProdColorName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = Child2CDS
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsCode'
          Value = Null
          Component = Child2CDS
          ComponentItem = 'GoodsCode'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Article'
          Value = Null
          Component = Child2CDS
          ComponentItem = 'Article'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = Child2CDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupNameFull'
          Value = Null
          Component = Child2CDS
          ComponentItem = 'GoodsGroupNameFull'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = Null
          Component = Child2CDS
          ComponentItem = 'GoodsGroupName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'EKPrice'
          Value = Null
          Component = Child2CDS
          ComponentItem = 'EKPrice'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'EKPriceWVAT'
          Value = Null
          Component = Child2CDS
          ComponentItem = 'EKPriceWVAT'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actUpdateDataSet_Child2: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate_Child2
      StoredProcList = <
        item
          StoredProc = spInsertUpdate_Child2
        end
        item
          StoredProc = spSelect_child2
        end>
      Caption = 'actUpdateDataSetGoods'
      DataSource = Child2DS
    end
    object actUpdateDataSet_Child1: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate_Child1
      StoredProcList = <
        item
          StoredProc = spInsertUpdate_Child1
        end
        item
          StoredProc = spSelect_child1
        end
        item
          StoredProc = spSelect_child2
        end>
      Caption = 'actUpdateDataSet_Child1'
      DataSource = Child1DS
    end
    object actChoiceFormProdColorPattern_2: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceFormProdColorPattern_2'
      FormName = 'TProdColorPatternForm'
      FormNameParam.Value = 'TProdColorPatternForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = Child2CDS
          ComponentItem = 'ProdColorPatternId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = Child2CDS
          ComponentItem = 'ProdColorPatternName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProdColorGroupName'
          Value = Null
          Component = Child2CDS
          ComponentItem = 'ProdColorGroupName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Article'
          Value = Null
          Component = Child2CDS
          ComponentItem = 'Article'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actShowAll_ch2: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect_child2
      StoredProcList = <
        item
          StoredProc = spSelect_child2
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndex = 63
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1079#1072#1087#1086#1083#1085#1077#1085#1099#1077
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1079#1072#1087#1086#1083#1085#1077#1085#1099#1077
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndexTrue = 62
      ImageIndexFalse = 63
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
          Name = 'inOperDate'
          Value = 42132d
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPartnerId'
          Value = ''
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
    end
    object actGetImportSettingId: TdsdExecStoredProc
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSettingId
      StoredProcList = <
        item
          StoredProc = spGetImportSettingId
        end>
      Caption = 'actGetImportSetting'
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1064#1072#1073#1083#1086#1085' '#1089#1073#1086#1088#1082#1080' '#1059#1047#1051#1054#1042' ('#1090#1086#1074#1072#1088#1099')'
    end
    object mactStartLoad: TMultiAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSettingId
        end
        item
          Action = actDoLoad
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1053#1072#1095#1072#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091' '#1064#1072#1073#1083#1086#1085' '#1089#1073#1086#1088#1082#1080' '#1059#1047#1051#1054#1042' ('#1090#1086#1074#1072#1088#1099') '#1080#1079' '#1092#1072#1081#1083#1072'?'
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1079#1072#1075#1088#1091#1078#1077#1085#1099
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1064#1072#1073#1083#1086#1085' '#1089#1073#1086#1088#1082#1080' '#1059#1047#1051#1054#1042' ('#1090#1086#1074#1072#1088#1099')'
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1064#1072#1073#1083#1086#1085' '#1089#1073#1086#1088#1082#1080' '#1059#1047#1051#1054#1042' ('#1090#1086#1074#1072#1088#1099')'
      ImageIndex = 27
      WithoutNext = True
    end
    object actPrintStructureGoods: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.ComponentItem = 'id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProc = spSelectPrintStructureGoods
      StoredProcList = <
        item
          StoredProc = spSelectPrintStructureGoods
        end>
      Caption = 'Print Structure Goods'
      Hint = 'PrintStructure Goods'
      ImageIndex = 17
      DataSets = <
        item
          UserName = 'frxDBDHeader'
        end
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'NPP;GoodsGroupNameFull;GoodsName'
        end>
      Params = <
        item
          Name = 'Id'
          Value = '0'
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintReceiptGoods_StructureGoods'
      ReportNameParam.Value = 'PrintReceiptGoods_StructureGoods'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
      PictureFields.Strings = (
        'photo1')
    end
    object actPrintStructure: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.ComponentItem = 'id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProc = spSelectPrintStructure
      StoredProcList = <
        item
          StoredProc = spSelectPrintStructure
        end>
      Caption = 'Print Structure'
      Hint = 'Print Structure'
      ImageIndex = 15
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GoodsGroupNameFull;NPP;ObjectName'
        end>
      Params = <
        item
          Name = 'Id'
          Value = '0'
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintReceiptGoods_Structure'
      ReportNameParam.Value = 'PrintReceiptGoods_Structure'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
      PictureFields.Strings = (
        'photo1')
    end
    object actInsertRecordGoods_limit: TInsertRecord
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableViewCh1
      Action = actChoiceFormGoods_limit
      Params = <>
      Caption = '***'#1044#1086#1073#1072#1074#1080#1090#1100
      Hint = '***'#1044#1086#1073#1072#1074#1080#1090#1100
      ImageIndex = 54
    end
    object actChoiceFormGoods_limit: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceFormGoods'
      FormName = 'TUnion_Goods_ReceiptService_limitForm'
      FormNameParam.Value = 'TUnion_Goods_ReceiptService_limitForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = Child1CDS
          ComponentItem = 'ObjectId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = Child1CDS
          ComponentItem = 'ObjectName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = Child1CDS
          ComponentItem = 'ObjectCode'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Article'
          Value = Null
          Component = Child1CDS
          ComponentItem = 'Article'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupNameFull'
          Value = Null
          Component = Child1CDS
          ComponentItem = 'GoodsGroupNameFull'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = Null
          Component = Child1CDS
          ComponentItem = 'GoodsGroupName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProdColorName'
          Value = Null
          Component = Child1CDS
          ComponentItem = 'ProdColorName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MeasureName'
          Value = Null
          Component = Child1CDS
          ComponentItem = 'MeasureName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actGridCh1ToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      MoveParams = <>
      Grid = cxGridCh1
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
  end
  object spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_ReceiptGoods'
    DataSet = MasterCDS
    DataSets = <
      item
        DataSet = MasterCDS
      end>
    Params = <
      item
        Name = 'inIsErased'
        Value = False
        Component = actShowAllErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 96
    Top = 120
  end
  object spErased: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_isErased_ReceiptGoods'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 432
    Top = 80
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 352
    Top = 120
  end
  object DBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView
    OnDblClickActionList = <
      item
        Action = actChoiceGuides
      end
      item
        Action = actUpdate
      end>
    ActionItemList = <
      item
        Action = actChoiceGuides
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
    PropertiesCellList = <>
    Left = 656
    Top = 112
  end
  object spUnErased: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_isErased_ReceiptGoods'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 432
    Top = 128
  end
  object Child1CDS: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'ReceiptGoodsId'
    MasterFields = 'Id'
    MasterSource = DataSource
    PacketRecords = 0
    Params = <>
    Left = 216
    Top = 328
  end
  object Child1DS: TDataSource
    DataSet = Child1CDS
    Left = 264
    Top = 392
  end
  object dsdDBViewAddOnGoods: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableViewCh1
    OnDblClickActionList = <
      item
        Action = actChoiceGuides
      end
      item
        Action = actUpdate
      end>
    ActionItemList = <
      item
        Action = actChoiceGuides
        ShortCut = 13
      end
      item
        Action = actUpdate
        ShortCut = 13
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <
      item
        ColorColumn = Value_ch1
        BackGroundValueColumn = Color_value_ch1
        ColorValueList = <>
      end
      item
        ValueColumn = Color_Level_ch1
        ColorValueList = <>
      end>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 416
    Top = 384
  end
  object spSelect_child2: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_ReceiptGoodsChild_ProdColorPattern'
    DataSet = Child2CDS
    DataSets = <
      item
        DataSet = Child2CDS
      end>
    Params = <
      item
        Name = 'inIsShowAll'
        Value = Null
        Component = actShowAll_ch2
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = False
        Component = actShowAllErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 840
    Top = 368
  end
  object spInsertUpdate_Child1: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_ReceiptGoodsChild'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = Child1CDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = Child1CDS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReceiptGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inObjectId'
        Value = Null
        Component = Child1CDS
        ComponentItem = 'ObjectId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inProdColorPatternId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMaterialOptionsId'
        Value = Null
        Component = Child1CDS
        ComponentItem = 'MaterialOptionsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioValue'
        Value = Null
        Component = Child1CDS
        ComponentItem = 'Value'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioValue_service'
        Value = Null
        Component = Child1CDS
        ComponentItem = 'Value_service'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsEnabled'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 64
    Top = 424
  end
  object spErasedGoods: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_isErased_ReceiptGoodsChild'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        Component = Child1CDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 136
    Top = 240
  end
  object spUnErasedGoods: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_isErased_ReceiptGoodsChild'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        Component = Child1CDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 280
    Top = 224
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'ImportSettingId'
        Value = Null
        MultiSelectSeparator = ','
      end>
    Left = 768
    Top = 144
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
        Value = 'TReceiptGoodsForm;zc_Object_ImportSetting_ReceiptGoods'
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
    Left = 1144
    Top = 104
  end
  object PopupMenu: TPopupMenu
    Images = dmMain.ImageList
    Left = 376
    Top = 208
    object N1: TMenuItem
      Action = actRefresh
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
    end
    object N2: TMenuItem
      Action = actInsert
    end
    object N4: TMenuItem
      Action = actUpdate
    end
    object N3: TMenuItem
      Action = actSetErased
    end
    object N5: TMenuItem
      Action = actSetUnErased
    end
  end
  object PopupMenuColor: TPopupMenu
    Images = dmMain.ImageList
    Left = 440
    Top = 208
    object MenuItem2: TMenuItem
      Action = actInsertRecordGoods
    end
    object MenuItem3: TMenuItem
      Action = actSetErasedGoods
    end
    object MenuItem4: TMenuItem
      Action = actSetUnErasedGoods
    end
  end
  object PopupMenuOption: TPopupMenu
    Images = dmMain.ImageList
    Left = 496
    Top = 208
    object MenuItem1: TMenuItem
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100
      ImageIndex = 0
    end
    object MenuItem5: TMenuItem
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100
      ImageIndex = 2
      ShortCut = 16430
    end
    object MenuItem6: TMenuItem
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 16430
    end
  end
  object Child2CDS: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'ReceiptGoodsId'
    MasterFields = 'Id'
    MasterSource = DataSource
    PacketRecords = 0
    Params = <>
    Left = 784
    Top = 432
  end
  object Child2DS: TDataSource
    DataSet = Child2CDS
    Left = 688
    Top = 440
  end
  object dsdDBViewAddOnCh2: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableViewCh2
    OnDblClickActionList = <
      item
        Action = actChoiceGuides
      end
      item
        Action = actUpdate
      end>
    ActionItemList = <
      item
        Action = actChoiceGuides
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
    PropertiesCellList = <>
    Left = 680
    Top = 376
  end
  object spSelect_child1: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_ReceiptGoodsChild_ProdColorPatternNo'
    DataSet = Child1CDS
    DataSets = <
      item
        DataSet = Child1CDS
      end>
    Params = <
      item
        Name = 'inIsShowAll'
        Value = Null
        Component = actShowAll_ch2
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = False
        Component = actShowAllErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 152
    Top = 368
  end
  object spInsertUpdate_Child2: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_ReceiptGoodsChild'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = Child2CDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = Child2CDS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReceiptGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inObjectId'
        Value = Null
        Component = Child2CDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inProdColorPatternId'
        Value = 'ProdColorPatternId'
        Component = Child2CDS
        ComponentItem = 'ProdColorPatternId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMaterialOptionsId'
        Value = Null
        Component = Child2CDS
        ComponentItem = 'MaterialOptionsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue'
        Value = Null
        Component = Child2CDS
        ComponentItem = 'Value'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioValue_service'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsEnabled'
        Value = Null
        Component = Child2CDS
        ComponentItem = 'isEnabled'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 972
    Top = 360
  end
  object spErasedProdColorPattern: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_isErased_ReceiptGoodsChild'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        Component = Child2CDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 744
    Top = 384
  end
  object spUnErasedProdColorPattern: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_isErased_ReceiptGoodsChild'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        Component = Child2CDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 896
    Top = 392
  end
  object spGetImportSettingId_Osculati: TdsdStoredProc
    StoredProcName = 'gpGet_DefaultValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inDefaultKey'
        Value = 'TPriceListOsculatiForm;zc_Object_ImportSetting_PriceListOsculati'
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
        ComponentItem = 'ImportSettingId_Osculati'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 952
    Top = 152
  end
  object spSelectPrintStructureGoods: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_ReceiptGoods_Print'
    DataSets = <
      item
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inReceiptGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 656
    Top = 176
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 1012
    Top = 142
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 1012
    Top = 89
  end
  object PrintItemsColorCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 1012
    Top = 198
  end
  object spSelectPrintStructure: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_ReceiptGoods_Print'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end
      item
        DataSet = PrintItemsCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inReceiptGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 880
    Top = 136
  end
  object FieldFilter_Article: TdsdFieldFilter
    TextEdit = edSearchArticle
    DataSet = Child1CDS
    Column = Article_all_ch1
    ActionNumber1 = actChoiceGuides
    CheckBoxList = <>
    Left = 256
    Top = 152
  end
end
