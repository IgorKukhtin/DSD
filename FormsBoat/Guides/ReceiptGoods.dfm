﻿object ReceiptGoodsForm: TReceiptGoodsForm
  Left = 0
  Top = 0
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1064#1072#1073#1083#1086#1085' '#1089#1073#1086#1088#1082#1072' '#1059#1079#1083#1086#1074'>'
  ClientHeight = 558
  ClientWidth = 1169
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
    Top = 117
    Width = 1169
    Height = 225
    Align = alTop
    BevelEdges = [beLeft]
    BevelOuter = bvNone
    TabOrder = 1
    object cxGrid: TcxGrid
      Left = 0
      Top = 17
      Width = 1169
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
          end>
        DataController.Summary.SummaryGroups = <>
        Images = dmMain.SortImageList
        OptionsCustomize.ColumnHiding = True
        OptionsCustomize.ColumnsQuickCustomization = True
        OptionsData.Deleting = False
        OptionsData.DeletingConfirmation = False
        OptionsData.Inserting = False
        OptionsView.CellAutoHeight = True
        OptionsView.Footer = True
        OptionsView.GroupByBox = False
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
          HeaderHint = #1043#1083#1072#1074#1085#1099#1081' '#1096#1072#1073#1083#1086#1085' ('#1076#1072'/'#1085#1077#1090')'
          Options.Editing = False
          Width = 72
        end
        object Code: TcxGridDBColumn
          Caption = #1050#1086#1076' ('#1096#1072#1073#1083#1086#1085')'
          DataBinding.FieldName = 'Code'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 43
        end
        object UserCode: TcxGridDBColumn
          Caption = #1055#1086#1083#1100#1079'. '#1050#1086#1076' ('#1096#1072#1073#1083#1086#1085')'
          DataBinding.FieldName = 'UserCode'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100#1089#1082#1080#1081' '#1050#1086#1076' ('#1096#1072#1073#1083#1086#1085')'
          Options.Editing = False
          Width = 92
        end
        object Name: TcxGridDBColumn
          Caption = #1053#1072#1079#1074#1072#1085#1080#1077' ('#1096#1072#1073#1083#1086#1085')'
          DataBinding.FieldName = 'Name'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderGlyphAlignmentHorz = taCenter
          Options.Editing = False
          Width = 189
        end
        object ModelName: TcxGridDBColumn
          Caption = #1052#1086#1076#1077#1083#1100
          DataBinding.FieldName = 'ModelName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 70
        end
        object ColorPatternName: TcxGridDBColumn
          Caption = #1064#1072#1073#1083#1086#1085' '#1050#1086#1085#1092#1080#1075#1091#1088#1072#1090#1086#1088#1072
          DataBinding.FieldName = 'ColorPatternName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderGlyphAlignmentHorz = taCenter
          HeaderHint = #1064#1072#1073#1083#1086#1085' Boat Structure'
          Options.Editing = False
          Width = 125
        end
        object MaterialOptionsName: TcxGridDBColumn
          Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1054#1087#1094#1080#1081
          DataBinding.FieldName = 'MaterialOptionsName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 70
        end
        object ProdColorName_pcp: TcxGridDBColumn
          Caption = '~Farbe'
          DataBinding.FieldName = 'ProdColorName_pcp'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
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
          HeaderHint = 'Artikel Nr ('#1059#1079#1077#1083')'
          Width = 80
        end
        object ArticleVergl: TcxGridDBColumn
          Caption = 'Vergl. Nr'
          DataBinding.FieldName = 'ArticleVergl'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1040#1088#1090#1080#1082#1091#1083' '#1059#1079#1077#1083' ('#1072#1083#1100#1090#1077#1088#1085#1072#1090#1080#1074#1085#1099#1081')'
          Width = 55
        end
        object Article_all: TcxGridDBColumn
          Caption = '***Artikel Nr'
          DataBinding.FieldName = 'Article_all'
          Visible = False
          Width = 70
        end
        object GoodsGroupName: TcxGridDBColumn
          Caption = #1043#1088#1091#1087#1087#1072
          DataBinding.FieldName = 'GoodsGroupName'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 172
        end
        object GoodsCode: TcxGridDBColumn
          Caption = 'Interne Nr'
          DataBinding.FieldName = 'GoodsCode'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1042#1085#1091#1090#1088#1077#1085#1085#1080#1081' '#1082#1086#1076' ('#1059#1079#1077#1083')'
          Width = 60
        end
        object GoodsName: TcxGridDBColumn
          Caption = #1059#1079#1077#1083
          DataBinding.FieldName = 'GoodsName'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 164
        end
        object Comment_goods: TcxGridDBColumn
          Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' '#1059#1079#1077#1083
          DataBinding.FieldName = 'Comment_goods'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' '#1059#1079#1077#1083
          Options.Editing = False
          Width = 80
        end
        object ProdColorName: TcxGridDBColumn
          Caption = 'Farbe '#1059#1079#1077#1083
          DataBinding.FieldName = 'ProdColorName'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = 'Farbe '#1059#1079#1077#1083
          Width = 70
        end
        object Article_group: TcxGridDBColumn
          Caption = 'Artikel Nr***'
          DataBinding.FieldName = 'Article_group'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = '***'#1041#1072#1079#1086#1074#1072#1103' '#1089#1073#1086#1088#1082#1072
          Width = 80
        end
        object GoodsCode_group: TcxGridDBColumn
          Caption = 'Interne Nr***'
          DataBinding.FieldName = 'GoodsCode_group'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = '***'#1041#1072#1079#1086#1074#1072#1103' '#1089#1073#1086#1088#1082#1072
          Width = 70
        end
        object GoodsName_group: TcxGridDBColumn
          Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077'***'
          DataBinding.FieldName = 'GoodsName_group'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = '***'#1041#1072#1079#1086#1074#1072#1103' '#1089#1073#1086#1088#1082#1072
          Width = 120
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
        object UnitName: TcxGridDBColumn
          Caption = #1059#1095#1072#1089#1090#1086#1082' '#1089#1073#1086#1088#1082#1080
          DataBinding.FieldName = 'UnitName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 100
        end
        object UnitChildName: TcxGridDBColumn
          Caption = #1059#1095#1072#1089#1090#1086#1082' '#1089#1073#1086#1088#1082#1080' ('#1059#1079#1077#1083' '#1055#1060')'
          DataBinding.FieldName = 'UnitChildName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 100
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
        object EKPrice_summ: TcxGridDBColumn
          Caption = 'Total EK'
          DataBinding.FieldName = 'EKPrice_summ'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1057#1091#1084#1084#1072' '#1074#1093'. '#1073#1077#1079' '#1053#1044#1057
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
          HeaderHint = #1057#1091#1084#1084#1072' '#1074#1093'. '#1089' '#1053#1044#1057
          Options.Editing = False
          Width = 70
        end
        object Comment: TcxGridDBColumn
          Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
          DataBinding.FieldName = 'Comment'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderGlyphAlignmentHorz = taCenter
          HeaderHint = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' '#1064#1072#1073#1083#1086#1085' '#1089#1073#1086#1088#1082#1080
          Options.Editing = False
          Width = 100
        end
        object isMany_pf: TcxGridDBColumn
          Caption = #1054#1096#1080#1073#1082#1072' '#1055#1060
          DataBinding.FieldName = 'isMany_pf'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1059#1082#1072#1079#1072#1085#1086' '#1085#1077#1089#1082#1086#1083#1100#1082#1086' '#1091#1079#1083#1086#1074' '#1055#1060
          Options.Editing = False
          Width = 55
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
      Width = 1169
      Height = 17
      Align = alTop
      Caption = #1057#1073#1086#1088#1082#1072' '#1091#1079#1083#1086#1074
      Color = clSkyBlue
      ParentBackground = False
      TabOrder = 1
    end
    object clReceiptGoods: TcxLabel
      Left = 259
      Top = 183
      Hint = #1069#1090#1072#1087' '#1089#1073#1086#1088#1082#1080
      Caption = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100' '#1080#1079' '#1064#1072#1073#1083#1086#1085#1072' '#1089#1073#1086#1088#1082#1080' '#1059#1079#1083#1086#1074':'
      ParentShowHint = False
      ShowHint = True
    end
    object edReceiptGoods: TcxButtonEdit
      Left = 468
      Top = 182
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 3
      Width = 201
    end
  end
  object PanelGoods: TPanel
    Left = 0
    Top = 347
    Width = 472
    Height = 147
    Align = alClient
    BevelEdges = [beLeft]
    BevelOuter = bvNone
    TabOrder = 0
    object cxGridCh1: TcxGrid
      Left = 0
      Top = 17
      Width = 472
      Height = 130
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
            Format = ',0.########'
            Kind = skSum
            Column = Value_ch1
          end
          item
            Format = ',0.########'
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
          end
          item
            Format = ',0.########'
            Kind = skSum
            Column = Value_child_ch1
          end>
        DataController.Summary.FooterSummaryItems = <
          item
            Format = 'C'#1090#1088#1086#1082': ,0'
            Kind = skCount
            Column = ObjectName_ch1
          end
          item
            Format = ',0.########'
            Kind = skSum
            Column = Value_ch1
          end
          item
            Format = ',0.########'
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
          end
          item
            Format = ',0.########'
            Kind = skSum
            Column = Value_child_ch1
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
        OptionsView.GroupByBox = False
        OptionsView.GroupSummaryLayout = gslAlignWithColumns
        OptionsView.HeaderAutoHeight = True
        OptionsView.HeaderHeight = 40
        OptionsView.Indicator = True
        Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
        object NPP_calc_ch1: TcxGridDBColumn
          Caption = #8470' '#1087'/'#1087
          DataBinding.FieldName = 'NPP_calc'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #8470' '#1087'/'#1087' '#1088#1072#1089#1095#1077#1090#1085#1099#1081
          Options.Editing = False
          Width = 40
        end
        object NPP_ch1: TcxGridDBColumn
          Caption = '***'#8470' '#1087'/'#1087
          DataBinding.FieldName = 'NPP'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #8470' '#1087'/'#1087' '#1074' '#1079#1072#1075#1088#1091#1079#1082#1077' '#1080#1079' '#1101#1082#1089#1077#1083#1103
          Options.Editing = False
          Width = 45
        end
        object NPP_service_ch1: TcxGridDBColumn
          Caption = #8470' '#1087'/'#1087' '#1088#1072#1073#1086#1090
          DataBinding.FieldName = 'NPP_service'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #8470' '#1087'/'#1087' - '#1086#1095#1077#1088#1077#1076#1085#1086#1089#1090#1100' '#1088#1072#1073#1086#1090
          Width = 58
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
        object ReceiptLevelName_ch1: TcxGridDBColumn
          Caption = 'Level'
          DataBinding.FieldName = 'ReceiptLevelName'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Action = actChoiceFormReceiptLevel_ch1
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 75
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
        object ArticleVergl_ch1: TcxGridDBColumn
          Caption = 'Vergl. Nr'
          DataBinding.FieldName = 'ArticleVergl'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 70
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
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 70
        end
        object Comment_goods_ch1: TcxGridDBColumn
          Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' ('#1050#1086#1084#1087#1083'.)'
          DataBinding.FieldName = 'Comment_goods'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' '#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077
          Options.Editing = False
          Width = 80
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
          Properties.DecimalPlaces = 8
          Properties.DisplayFormat = ',0.########;-,0.########; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1047#1085#1072#1095#1077#1085#1080#1077' '#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077
          Width = 45
        end
        object Value_child_ch1: TcxGridDBColumn
          Caption = '***Value'
          DataBinding.FieldName = 'Value_child'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 8
          Properties.DisplayFormat = ',0.########;-,0.########; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1047#1085#1072#1095#1077#1085#1080#1077' '#1076#1083#1103' '#1089#1073#1086#1088#1082#1080' '#1059#1079#1083#1072' '#1055#1060
          Options.Editing = False
        end
        object Value_service_ch1: TcxGridDBColumn
          Caption = 'Value (service)'
          DataBinding.FieldName = 'Value_service'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 8
          Properties.DisplayFormat = ',0.########;-,0.########; ;'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1047#1085#1072#1095#1077#1085#1080#1077' '#1056#1072#1073#1086#1090#1099'/'#1059#1089#1083#1091#1075#1080
          Options.Editing = False
          Width = 63
        end
        object ForCount_ch1: TcxGridDBColumn
          Caption = 'For Count'
          DataBinding.FieldName = 'ForCount'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.#;-,0.#; ;'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1076#1083#1103' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1072
          Options.Editing = False
          Width = 45
        end
        object GoodsChildName_ch1: TcxGridDBColumn
          Caption = #1089#1073#1086#1088#1082#1072' '#1059#1079#1083#1072' '#1055#1060
          DataBinding.FieldName = 'GoodsChildName'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Action = actChoiceFormGoodsChild_1
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 111
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
      Width = 472
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
    Top = 342
    Width = 1169
    Height = 5
    AlignSplitter = salTop
    Control = PanelMaster
  end
  object PanelProdColorPattern: TPanel
    Left = 480
    Top = 347
    Width = 689
    Height = 147
    Align = alRight
    Caption = 'PanelProdColorPattern'
    TabOrder = 4
    object cxGridCh2: TcxGrid
      Left = 1
      Top = 18
      Width = 687
      Height = 128
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
          end
          item
            Format = ',0.########'
            Kind = skSum
            Column = Value_ch2
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
          end
          item
            Format = ',0.########'
            Kind = skSum
            Column = Value_ch2
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
        OptionsView.GroupByBox = False
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
        object NPP_calc_ch2: TcxGridDBColumn
          Caption = #8470' '#1087'/'#1087
          DataBinding.FieldName = 'NPP_calc'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #8470' '#1087'/'#1087' '#1088#1072#1089#1095#1077#1090#1085#1099#1081
          Options.Editing = False
          Width = 40
        end
        object NPP_ch2: TcxGridDBColumn
          Caption = '***'#8470' '#1087'/'#1087
          DataBinding.FieldName = 'NPP'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #8470' '#1087'/'#1087' '#1074' '#1079#1072#1075#1088#1091#1079#1082#1077' '#1080#1079' '#1101#1082#1089#1077#1083#1103
          Options.Editing = False
          Width = 45
        end
        object NPP_service_ch2: TcxGridDBColumn
          Caption = #8470' '#1087'/'#1087' '#1088#1072#1073#1086#1090
          DataBinding.FieldName = 'NPP_service'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #8470' '#1087'/'#1087' - '#1086#1095#1077#1088#1077#1076#1085#1086#1089#1090#1100' '#1088#1072#1073#1086#1090
          Width = 52
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
        object ProdColorPatternName_all_ch2: TcxGridDBColumn
          Caption = '***'#1069#1083#1077#1084#1077#1085#1090
          DataBinding.FieldName = 'ProdColorPatternName_all'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 80
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
        object Comment_ch2: TcxGridDBColumn
          Caption = '***Material/farbe'
          DataBinding.FieldName = 'Comment'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Action = actChoiceFormProdOptions_сomment
              Default = True
              Kind = bkEllipsis
            end>
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderGlyphAlignmentHorz = taCenter
          Width = 100
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
          Properties.DecimalPlaces = 8
          Properties.DisplayFormat = ',0.########;-,0.########; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1047#1085#1072#1095#1077#1085#1080#1077
          Width = 45
        end
        object ForCount_ch2: TcxGridDBColumn
          Caption = 'For Count'
          DataBinding.FieldName = 'ForCount'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.#;-,0.#; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1076#1083#1103' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1072
          Options.Editing = False
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
        object Article_ch2: TcxGridDBColumn
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
        object ColorPatternName_ch2: TcxGridDBColumn
          Caption = #1064#1072#1073#1083#1086#1085' Boat Structure'
          DataBinding.FieldName = 'ColorPatternName'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 80
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
        object GoodsCode_receipt_ch2: TcxGridDBColumn
          Caption = '***Interne Nr'
          DataBinding.FieldName = 'GoodsCode_receipt'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077' - '#1064#1072#1073#1083#1086#1085' '#1089#1073#1086#1088#1082#1080' '#1091#1079#1083#1072
          Width = 70
        end
        object GoodsName_receipt_ch2: TcxGridDBColumn
          Caption = '***'#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077
          DataBinding.FieldName = 'GoodsName_receipt'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077' - '#1064#1072#1073#1083#1086#1085' '#1089#1073#1086#1088#1082#1080' '#1091#1079#1083#1072
          Width = 70
        end
        object Article_receipt_ch2: TcxGridDBColumn
          Caption = '***Artikel Nr'
          DataBinding.FieldName = 'Article_receipt'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077' - '#1064#1072#1073#1083#1086#1085' '#1089#1073#1086#1088#1082#1080' '#1091#1079#1083#1072
          Width = 70
        end
        object ProdColorName_receipt_ch2: TcxGridDBColumn
          Caption = '***Farbe'
          DataBinding.FieldName = 'ProdColorName_receipt'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077' - '#1064#1072#1073#1083#1086#1085' '#1089#1073#1086#1088#1082#1080' '#1091#1079#1083#1072' ('#1090#1086#1083#1100#1082#1086' '#1055#1088#1080#1084#1077#1095#1072#1085#1080#1077')'
          Width = 70
        end
        object ReceiptLevelName_ch2: TcxGridDBColumn
          Caption = 'Level'
          DataBinding.FieldName = 'ReceiptLevelName'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Action = actChoiceFormReceiptLevel_ch2
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 74
        end
        object GoodsChildName_ch2: TcxGridDBColumn
          Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077' '#1089#1073#1086#1088#1082#1080' '#1059#1079#1077#1083#1072
          DataBinding.FieldName = 'GoodsChildName'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Action = actChoiceFormGoodsChild_2
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 114
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
      Caption = #1050#1086#1085#1092#1080#1075#1091#1088#1072#1090#1086#1088
      Color = clLime
      ParentBackground = False
      TabOrder = 1
    end
  end
  object cxSplitterRight: TcxSplitter
    Left = 472
    Top = 347
    Width = 8
    Height = 147
    AlignSplitter = salRight
    Control = PanelProdColorPattern
  end
  object Panel5: TPanel
    Left = 0
    Top = 0
    Width = 1169
    Height = 91
    Align = alTop
    TabOrder = 5
    object lbSearchArticle: TcxLabel
      Left = 522
      Top = 65
      Caption = #1055#1086#1080#1089#1082' Artikel Nr:'
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clBlue
      Style.Font.Height = -13
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
    end
    object edSearchArticle: TcxTextEdit
      Left = 638
      Top = 65
      TabOrder = 1
      DesignSize = (
        110
        21)
      Width = 110
    end
    object lbReceiptLevel: TcxLabel
      Left = 757
      Top = 9
      Hint = #1069#1090#1072#1087' '#1089#1073#1086#1088#1082#1080
      Caption = '2.1.'#1047#1072#1087#1086#1083#1085#1103#1090#1100' '#1072#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080' Level :'
      ParentShowHint = False
      ShowHint = True
    end
    object edReceiptLevel: TcxButtonEdit
      Left = 951
      Top = 8
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 3
      Width = 220
    end
    object cxLabel4: TcxLabel
      Left = 177
      Top = 9
      Caption = '1.1.'#1047#1072#1087#1086#1083#1085#1103#1090#1100' '#1072#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080' '#1059#1095#1072#1089#1090#1086#1082' '#1089#1073#1086#1088#1082#1080' :'
    end
    object edUnit: TcxButtonEdit
      Left = 426
      Top = 8
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 194
    end
    object cxLabel15: TcxLabel
      Left = 700
      Top = 38
      Caption = '2.2.'#1047#1072#1087#1086#1083#1085#1103#1090#1100' '#1072#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080' '#1057#1073#1086#1088#1082#1072' '#1059#1079#1083#1072' '#1055#1060' :'
      ParentShowHint = False
      ShowHint = True
    end
    object edGoodsChild: TcxButtonEdit
      Left = 951
      Top = 37
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 220
    end
    object lbSearchName: TcxLabel
      Left = 298
      Top = 65
      Caption = #1059#1079#1077#1083':'
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clBlue
      Style.Font.Height = -13
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
    end
    object edSearchName: TcxTextEdit
      Left = 342
      Top = 65
      TabOrder = 9
      DesignSize = (
        140
        21)
      Width = 140
    end
    object edSearchArticle_master: TcxTextEdit
      Left = 173
      Top = 65
      TabOrder = 10
      DesignSize = (
        110
        21)
      Width = 110
    end
    object cxLabel2: TcxLabel
      Left = 7
      Top = 65
      Caption = #1055#1086#1080#1089#1082' Artikel Nr ('#1059#1079#1077#1083'):'
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clBlue
      Style.Font.Height = -13
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
    end
  end
  object Panel_btn: TPanel
    Left = 0
    Top = 494
    Width = 1169
    Height = 64
    Align = alBottom
    TabOrder = 7
    object btnInsert: TcxButton
      Left = 17
      Top = 4
      Width = 115
      Height = 25
      Action = actInsert
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
    end
    object btnChoiceFormGoods_1: TcxButton
      Left = 398
      Top = 4
      Width = 115
      Height = 25
      Action = actChoiceFormGoods_1
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
    end
    object btnSetErasedGoods: TcxButton
      Left = 398
      Top = 35
      Width = 115
      Height = 25
      Action = actSetErasedGoods
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
    end
    object btnChoiceGuides: TcxButton
      Left = 754
      Top = 4
      Width = 153
      Height = 25
      Action = actChoiceGuides
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
    end
    object btnShowAll: TcxButton
      Left = 538
      Top = 35
      Width = 174
      Height = 25
      Action = actShowAll_ch2
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
    end
    object btnInsertAction: TcxButton
      Left = 277
      Top = 4
      Width = 115
      Height = 25
      Action = actInsertRecordGoods
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
    end
    object btnUpdate: TcxButton
      Left = 139
      Top = 4
      Width = 115
      Height = 25
      Action = actUpdate
      ParentShowHint = False
      ShowHint = True
      TabOrder = 6
    end
    object btnFormClose: TcxButton
      Left = 754
      Top = 35
      Width = 153
      Height = 25
      Action = actFormClose
      ParentShowHint = False
      ShowHint = True
      TabOrder = 7
    end
    object btnSetErased: TcxButton
      Left = 138
      Top = 35
      Width = 115
      Height = 25
      Action = actSetErased
      ParentShowHint = False
      ShowHint = True
      TabOrder = 8
    end
    object cxButton1: TcxButton
      Left = 538
      Top = 4
      Width = 174
      Height = 25
      Action = actSetVisible_ProdColorItems
      ParentShowHint = False
      ShowHint = True
      TabOrder = 9
    end
    object btnUpdate_all: TcxButton
      Left = 17
      Top = 35
      Width = 115
      Height = 25
      Action = actUpdate_all
      ParentShowHint = False
      ShowHint = True
      TabOrder = 10
    end
  end
  object cxLabel1: TcxLabel
    Left = 247
    Top = 38
    Caption = '1.2.'#1059#1095#1072#1089#1090#1086#1082' '#1089#1073#1086#1088#1082#1080' '#1076#1083#1103' '#1059#1079#1083#1072' '#1055#1060' :'
  end
  object edUnitChild: TcxButtonEdit
    Left = 426
    Top = 37
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 12
    Width = 194
  end
  object DataSource: TDataSource
    DataSet = MasterCDS
    Left = 456
    Top = 168
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
        Component = actSetVisible_ProdColorItems
        Properties.Strings = (
          'Value')
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
    Left = 152
    Top = 200
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
          ItemName = 'bbclReceiptGoods'
        end
        item
          Visible = True
          ItemName = 'bbedReceiptGoods'
        end
        item
          Visible = True
          ItemName = 'bbInsertUpdate_ReceiptGoods'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsertUpDate_Child_bySend'
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
          ItemName = 'bbInsertUpdate_Unit'
        end
        item
          Visible = True
          ItemName = 'bbb'
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
          ItemName = 'bbPrintStructureSum'
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
          ItemName = 'bbProtocol1'
        end
        item
          Visible = True
          ItemName = 'bbProtocol2'
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
      Category = 0
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
        end
        item
          Visible = True
          ItemName = 'bbUpdateProdColPattetnGoods'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator1'
        end
        item
          Visible = True
          ItemName = 'bbShowAllErased'
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
          ItemName = 'bbChoiceFormGoods_1'
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
        end
        item
          Visible = True
          ItemName = 'bbBarSeparetor'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_Child_union'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator1'
        end
        item
          Visible = True
          ItemName = 'bbErasedGoods_child1'
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
    object bbInsertRecordProdColorPattern: TdxBarButton
      Action = InsertRecordProdColorPattern
      Category = 0
    end
    object dxBarSubItem1: TdxBarSubItem
      Caption = #1050#1086#1085#1092#1080#1075#1091#1088#1072#1090#1086#1088
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
        end
        item
          Visible = True
          ItemName = 'bbBarSeparetor'
        end
        item
          Visible = True
          ItemName = 'bbShowAll_ch1'
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
      Category = 0
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
    object bbInsertUpdate_Unit: TdxBarButton
      Action = macInsertUpdate_Unit
      Category = 0
    end
    object bbProtocolGoods: TdxBarButton
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' '#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077' / '#1056#1072#1073#1086#1090#1099' / '#1059#1089#1083#1091#1075#1080' '
      Category = 0
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' '#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077' / '#1056#1072#1073#1086#1090#1099' / '#1059#1089#1083#1091#1075#1080' '
      Visible = ivAlways
      ImageIndex = 34
    end
    object bbProtocolPattern: TdxBarButton
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' Boat Structure'
      Category = 0
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' Boat Structure'
      Visible = ivAlways
      ImageIndex = 34
    end
    object bbclReceiptGoods: TdxBarControlContainerItem
      Caption = 'clReceiptGoods'
      Category = 0
      Hint = 'clReceiptGoods'
      Visible = ivAlways
      Control = clReceiptGoods
    end
    object bbedReceiptGoods: TdxBarControlContainerItem
      Caption = 'clReceiptGoods'
      Category = 0
      Hint = 'ReceiptGoods'
      Visible = ivAlways
      Control = edReceiptGoods
    end
    object bbInsertUpdate_ReceiptGoods: TdxBarButton
      Action = actspInsertUpdate_ReceiptGoods
      Category = 0
    end
    object bbProtocol1: TdxBarButton
      Action = actProtocol1
      Category = 0
    end
    object bbProtocol2: TdxBarButton
      Action = actProtocol2
      Category = 0
    end
    object bbUpdateProdColPattetnGoods: TdxBarButton
      Action = actUpdate_all
      Category = 0
    end
    object bbInsertUpDate_Child_bySend: TdxBarButton
      Action = macInsertUpDate_Child_bySend
      Category = 0
    end
    object bbErasedGoods_child1: TdxBarButton
      Action = macErasedGoods_child1
      Category = 0
    end
    object bbChoiceFormGoods_1: TdxBarButton
      Action = actChoiceFormGoods_1
      Category = 0
    end
    object bbb: TdxBarButton
      Action = macInsertUpdate_UnitChild
      Category = 0
      ImageIndex = 80
    end
    object bbUpdate_Child_union: TdxBarButton
      Action = mactUpdate_Child_union
      Category = 0
    end
    object bbPrintStructureSum: TdxBarButton
      Action = actPrintStructureSum
      Category = 0
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 24
    Top = 144
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
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 90
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object macInsertUpdate_UnitChild: TMultiAction
      Category = 'Update_all'
      MoveParams = <>
      ActionList = <
        item
          Action = macInsertUpdate_UnitChild_list
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1042#1099#1073#1088#1072#1085#1085#1086#1077' '#1052#1077#1089#1090#1086' '#1089#1073#1086#1088#1082#1080' '#1059#1079#1083#1072' '#1055#1060' '#1076#1083#1103' '#1042#1089#1077#1093' '#1096#1072#1073#1083#1086#1085#1086#1074'?'
      InfoAfterExecute = #1052#1077#1089#1090#1086' '#1089#1073#1086#1088#1082#1080' '#1059#1079#1083#1072' '#1055#1060' '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085#1086
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1084#1077#1089#1090#1086' '#1089#1073#1086#1088#1082#1080'  '#1059#1079#1083#1072' '#1055#1060' '#1076#1083#1103' '#1042#1089#1077#1093' '#1096#1072#1073#1083#1086#1085#1086#1074
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1084#1077#1089#1090#1086' '#1089#1073#1086#1088#1082#1080' '#1059#1079#1083#1072' '#1055#1060' '#1076#1083#1103' '#1042#1089#1077#1093' '#1096#1072#1073#1083#1086#1085#1086#1074
      ImageIndex = 77
    end
    object actInsertUpdate_UnitChild: TdsdExecStoredProc
      Category = 'Update_all'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsUpd_UnitChild
      StoredProcList = <
        item
          StoredProc = spInsUpd_UnitChild
        end>
      Caption = 'actInsertUpdate_UnitChild'
    end
    object macInsertUpdate_UnitChild_list: TMultiAction
      Category = 'Update_all'
      MoveParams = <>
      ActionList = <
        item
          Action = actInsertUpdate_UnitChild
        end>
      View = cxGridDBTableView
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1084#1077#1089#1090#1086' '#1089#1073#1086#1088#1082#1080' '#1059#1079#1083#1072' '#1055#1060' '#1076#1083#1103' '#1042#1089#1077#1093' '#1096#1072#1073#1083#1086#1085#1086#1074
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1084#1077#1089#1090#1086' '#1089#1073#1086#1088#1082#1080' '#1059#1079#1083#1072' '#1055#1060' '#1076#1083#1103' '#1042#1089#1077#1093' '#1096#1072#1073#1083#1086#1085#1086#1074
    end
    object macInsertUpdate_Unit: TMultiAction
      Category = 'Update_all'
      MoveParams = <>
      ActionList = <
        item
          Action = macInsertUpdate_Unit_list
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1042#1099#1073#1088#1072#1085#1085#1086#1077' '#1052#1077#1089#1090#1086' '#1089#1073#1086#1088#1082#1080' '#1076#1083#1103' '#1042#1089#1077#1093' '#1096#1072#1073#1083#1086#1085#1086#1074'?'
      InfoAfterExecute = #1052#1077#1089#1090#1086' '#1089#1073#1086#1088#1082#1080' '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085#1086
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1084#1077#1089#1090#1086' '#1089#1073#1086#1088#1082#1080' '#1076#1083#1103' '#1042#1089#1077#1093' '#1096#1072#1073#1083#1086#1085#1086#1074
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1084#1077#1089#1090#1086' '#1089#1073#1086#1088#1082#1080' '#1076#1083#1103' '#1042#1089#1077#1093' '#1096#1072#1073#1083#1086#1085#1086#1074
      ImageIndex = 76
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
    object actInsert: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1064#1072#1073#1083#1086#1085
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
    object actRefreshChild: TdsdDataSetRefresh
      Category = 'Insert_all'
      MoveParams = <>
      StoredProc = spSelect_child1
      StoredProcList = <
        item
          StoredProc = spSelect_child1
        end
        item
          StoredProc = spSelect_child2
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actUpdate: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1064#1072#1073#1083#1086#1085
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
    object actSetErased: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErased
      StoredProcList = <
        item
          StoredProc = spErased
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1064#1072#1073#1083#1086#1085
      ImageIndex = 2
      ShortCut = 49220
      ErasedFieldName = 'isErased'
      DataSource = DataSource
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
      ShortCut = 49220
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = DataSource
    end
    object actUpdate_all: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1042#1089#1077
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1042#1089#1077' '#1076#1083#1103' '#1057#1073#1086#1088#1082#1072' '#1091#1079#1083#1072
      ImageIndex = 24
      FormName = 'TProdColorPatternGoodsEditForm'
      FormNameParam.Value = 'TProdColorPatternGoodsEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inReceiptGoodsId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inReceiptLevelId'
          Value = Null
          Component = GuidesReceiptLevel
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UserCode'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UserCode'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Name'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Name'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Article'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Article'
          DataType = ftString
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
          Name = 'GoodsId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ColorPatternId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ColorPatternId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ColorPatternName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ColorPatternName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      ActionType = acUpdate
      DataSource = Child1DS
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actSetErasedProdColorPattern: TdsdUpdateErased
      Category = 'Grid_2'
      MoveParams = <>
      StoredProc = spErasedProdColorPattern
      StoredProcList = <
        item
          StoredProc = spErasedProdColorPattern
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100
      ImageIndex = 2
      ShortCut = 49202
      ErasedFieldName = 'isErased'
      DataSource = Child2DS
    end
    object actSetErasedGoods: TdsdUpdateErased
      Category = 'Grid_1'
      MoveParams = <>
      StoredProc = spErasedGoods
      StoredProcList = <
        item
          StoredProc = spErasedGoods
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077
      ImageIndex = 2
      ShortCut = 49201
      ErasedFieldName = 'isErased'
      DataSource = Child1DS
    end
    object actUnErasedProdColorPattern: TdsdUpdateErased
      Category = 'Grid_2'
      MoveParams = <>
      StoredProc = spUnErasedProdColorPattern
      StoredProcList = <
        item
          StoredProc = spUnErasedProdColorPattern
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 49203
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = Child1DS
    end
    object actSetUnErasedGoods: TdsdUpdateErased
      Category = 'Grid_1'
      MoveParams = <>
      StoredProc = spUnErasedGoods
      StoredProcList = <
        item
          StoredProc = spUnErasedGoods
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 49201
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = Child1DS
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
      Caption = #1042#1099#1073#1086#1088' '#1079#1085#1072#1095#1077#1085#1080#1103
      Hint = #1042#1099#1073#1086#1088' '#1079#1085#1072#1095#1077#1085#1080#1103' '#1080#1079' '#1089#1087#1080#1089#1082#1072
      ImageIndex = 7
      DataSource = DataSource
    end
    object actProtocol1: TdsdOpenForm
      Category = 'Grid_1'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' '#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' '#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077
      ImageIndex = 34
      FormName = 'TProtocolForm'
      FormNameParam.Value = 'TProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = Child1CDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = Child1CDS
          ComponentItem = 'ObjectName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actProtocol2: TdsdOpenForm
      Category = 'Grid_2'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' Boat Structure'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' Boat Structure'
      ImageIndex = 34
      FormName = 'TProtocolForm'
      FormNameParam.Value = 'TProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = Child2CDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = Child2CDS
          ComponentItem = 'ProdColorPatternName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
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
    object InsertRecordProdColorPattern: TInsertRecord
      Category = 'Grid_2'
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
      Category = 'Grid_1'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableViewCh1
      Action = actChoiceFormGoods_1
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077
      ImageIndex = 0
    end
    object actInsertRecordGoods_limit: TInsertRecord
      Category = 'Grid_1'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableViewCh1
      Action = actChoiceFormGoods_limit
      Params = <>
      Caption = '***'#1044#1086#1073#1072#1074#1080#1090#1100
      Hint = '***'#1044#1086#1073#1072#1074#1080#1090#1100
      ImageIndex = 54
    end
    object actChoiceFormGoods_1: TOpenChoiceForm
      Category = 'Grid_1'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077
      ImageIndex = 1
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
    object actChoiceFormReceiptLevel_ch1: TOpenChoiceForm
      Category = 'Grid_1'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceFormReceiptLevel_ch1'
      FormName = 'TReceiptLevelForm'
      FormNameParam.Value = 'TReceiptLevelForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = Child1CDS
          ComponentItem = 'ReceiptLevelId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = Child1CDS
          ComponentItem = 'ReceiptLevelName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterObjectDesc'
          Value = 'zc_Object_ReceiptGoods'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actChoiceFormGoods_2: TOpenChoiceForm
      Category = 'Grid_2'
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
      Category = 'Grid_2'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceFormMaterialOptions_2'
      FormName = 'TMaterialOptionsChoiceForm'
      FormNameParam.Value = 'TMaterialOptionsChoiceForm'
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
        end
        item
          Name = 'ProdColorPatternId'
          Value = Null
          Component = Child2CDS
          ComponentItem = 'ProdColorPatternId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProdColorPatternName'
          Value = Null
          Component = Child2CDS
          ComponentItem = 'ProdColorPatternName_all'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ColorPatternId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ColorPatternId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ColorPatternName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ColorPatternName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actChoiceFormMaterialOptions_1: TOpenChoiceForm
      Category = 'Grid_1'
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
    object actChoiceFormProdColor_goods_2: TOpenChoiceForm
      Category = 'Grid_2'
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
      Category = 'Grid_2'
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
      Category = 'Grid_1'
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
      Category = 'Grid_2'
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
        end
        item
          Name = 'ColorPatternId'
          Value = Null
          Component = Child2CDS
          ComponentItem = 'ColorPatternId'
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ColorPatternName'
          Value = Null
          Component = Child2CDS
          ComponentItem = 'ColorPatternName'
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actShowAll_ch2: TBooleanStoredProcAction
      Category = 'Grid_2'
      MoveParams = <>
      StoredProc = spSelect_child2
      StoredProcList = <
        item
          StoredProc = spSelect_child2
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082' '#1050#1086#1085#1092#1080#1075#1091#1088#1072#1090#1086#1088#1072
      ImageIndex = 63
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1079#1072#1087#1086#1083#1085#1077#1085#1099#1077
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082' '#1050#1086#1085#1092#1080#1075#1091#1088#1072#1090#1086#1088#1072
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
      QuestionBeforeExecute = #1053#1072#1095#1072#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091' '#1064#1072#1073#1083#1086#1085' '#1089#1073#1086#1088#1082#1080' '#1059#1047#1051#1067' + '#1052#1086#1076#1077#1083#1100' '#1083#1086#1076#1082#1080' '#1080#1079' '#1092#1072#1081#1083#1072'?'
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1079#1072#1075#1088#1091#1078#1077#1085#1099
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1064#1072#1073#1083#1086#1085' '#1089#1073#1086#1088#1082#1080' '#1059#1047#1051#1067' + '#1052#1086#1076#1077#1083#1100' '#1083#1086#1076#1082#1080
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1064#1072#1073#1083#1086#1085' '#1089#1073#1086#1088#1082#1080' '#1059#1047#1051#1067' + '#1052#1086#1076#1077#1083#1100' '#1083#1086#1076#1082#1080
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
          IndexFieldNames = 'TitleGroup;NPP_3;ObjectCode'
        end>
      Params = <
        item
          Name = 'Id'
          Value = '0'
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPrice'
          Value = False
          DataType = ftBoolean
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
    object actPrintStructureSum: TdsdPrintAction
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
      Caption = 'Print Structure with Price'
      Hint = 'Print Structure with Price'
      ImageIndex = 16
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'TitleGroup;NPP_3;ObjectCode'
        end>
      Params = <
        item
          Name = 'Id'
          Value = '0'
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPrice'
          Value = True
          DataType = ftBoolean
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
    object actChoiceFormGoods_limit: TOpenChoiceForm
      Category = 'Grid_1'
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
      Category = 'Grid_1'
      MoveParams = <>
      Grid = cxGridCh1
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object actChoiceFormProdOptions_сomment: TOpenChoiceForm
      Category = 'Grid_2'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceFormProdOptions_'#1089'omment'
      FormName = 'TProdOptions_CommentForm'
      FormNameParam.Value = 'TProdOptions_CommentForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'TextValue'
          Value = Null
          Component = Child2CDS
          ComponentItem = 'Comment'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProdColorPatternId'
          Value = Null
          Component = Child2CDS
          ComponentItem = 'ProdColorPatternId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProdColorPatternName'
          Value = Null
          Component = Child2CDS
          ComponentItem = 'ProdColorPatternName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ColorPatternId'
          Value = Null
          Component = Child2CDS
          ComponentItem = 'ColorPatternId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ColorPatternName'
          Value = Null
          Component = Child2CDS
          ComponentItem = 'ColorPatternName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actChoiceFormGoodsChild_1: TOpenChoiceForm
      Category = 'Grid_1'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceFormGoodsChild_1'
      FormName = 'TUnion_Goods_ReceiptServiceForm'
      FormNameParam.Value = 'TUnion_Goods_ReceiptServiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = Child1CDS
          ComponentItem = 'GoodsChildId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = Child1CDS
          ComponentItem = 'GoodsChildName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actChoiceFormReceiptLevel_ch2: TOpenChoiceForm
      Category = 'Grid_2'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceFormReceiptLevel_ch2'
      FormName = 'TReceiptLevelForm'
      FormNameParam.Value = 'TReceiptLevelForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = Child2CDS
          ComponentItem = 'ReceiptLevelId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = Child2CDS
          ComponentItem = 'ReceiptLevelName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterObjectDesc'
          Value = 'zc_Object_ReceiptGoods'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actChoiceFormGoodsChild_2: TOpenChoiceForm
      Category = 'Grid_2'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceFormGoodsChild_1'
      FormName = 'TUnion_Goods_ReceiptServiceForm'
      FormNameParam.Value = 'TUnion_Goods_ReceiptServiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = Child2CDS
          ComponentItem = 'GoodsChildId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = Child2CDS
          ComponentItem = 'GoodsChildName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actInsertUpdate_Unit: TdsdExecStoredProc
      Category = 'Update_all'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsUpd_Unit
      StoredProcList = <
        item
          StoredProc = spInsUpd_Unit
        end>
      Caption = 'actInsertUpdate_Unit'
    end
    object macInsertUpdate_Unit_list: TMultiAction
      Category = 'Update_all'
      MoveParams = <>
      ActionList = <
        item
          Action = actInsertUpdate_Unit
        end>
      View = cxGridDBTableView
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1084#1077#1089#1090#1086' '#1089#1073#1086#1088#1082#1080' '#1076#1083#1103' '#1042#1089#1077#1093' '#1096#1072#1073#1083#1086#1085#1086#1074
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1084#1077#1089#1090#1086' '#1089#1073#1086#1088#1082#1080' '#1076#1083#1103' '#1042#1089#1077#1093' '#1096#1072#1073#1083#1086#1085#1086#1074
    end
    object actUpdate_Child_union: TdsdExecStoredProc
      Category = 'Update_all'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Child_union
      StoredProcList = <
        item
          StoredProc = spUpdate_Child_union
        end>
      Caption = 'actUpdate_Child_union'
      ImageIndex = 38
    end
    object mactUpdate_Child_union_List: TMultiAction
      Category = 'Update_all'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_Child_union
        end>
      View = cxGridDBTableView
      Caption = 'C'#1091#1084#1084#1080#1088#1086#1074#1072#1090#1100' '#1087#1086#1074#1090#1086#1088#1103#1102#1097#1080#1077' '#1076#1077#1090#1072#1083#1080
      Hint = 'C'#1091#1084#1084#1080#1088#1086#1074#1072#1090#1100' '#1087#1086#1074#1090#1086#1088#1103#1102#1097#1080#1077' '#1076#1077#1090#1072#1083#1080
      ImageIndex = 38
    end
    object mactUpdate_Child_union: TMultiAction
      Category = 'Update_all'
      MoveParams = <>
      ActionList = <
        item
          Action = mactUpdate_Child_union_List
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = 'C'#1091#1084#1084#1080#1088#1086#1074#1072#1090#1100' '#1087#1086#1074#1090#1086#1088#1103#1102#1097#1080#1077' '#1076#1077#1090#1072#1083#1080' '#1076#1083#1103' '#1042#1089#1077#1093' '#1096#1072#1073#1083#1086#1085#1086#1074'?'
      InfoAfterExecute = 'C'#1091#1084#1084#1080#1088#1086#1074#1072#1085#1080#1077' '#1074#1099#1087#1086#1083#1085#1077#1085#1086
      Caption = 'C'#1091#1084#1084#1080#1088#1086#1074#1072#1090#1100' '#1087#1086#1074#1090#1086#1088#1103#1102#1097#1080#1077' '#1076#1077#1090#1072#1083#1080
      Hint = 'C'#1091#1084#1084#1080#1088#1086#1074#1072#1090#1100' '#1087#1086#1074#1090#1086#1088#1103#1102#1097#1080#1077' '#1076#1077#1090#1072#1083#1080
      ImageIndex = 38
    end
    object actspInsertUpdate_ReceiptGoods: TdsdExecStoredProc
      Category = 'Insert_all'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate_ReceiptGoods
      StoredProcList = <
        item
          StoredProc = spInsertUpdate_ReceiptGoods
        end
        item
          StoredProc = spSelect_child1
        end
        item
          StoredProc = spSelect_child2
        end>
      Caption = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100' '#1074' '#1074#1099#1073#1088#1072#1085#1085#1099#1081' '#1064#1072#1073#1083#1086#1085' '#1089#1073#1086#1088#1082#1072' '#1059#1079#1083#1072
      Hint = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100' '#1074' '#1074#1099#1073#1088#1072#1085#1085#1099#1081' '#1064#1072#1073#1083#1086#1085' '#1089#1073#1086#1088#1082#1072' '#1059#1079#1083#1072
      ImageIndex = 82
      QuestionBeforeExecute = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1074#1099#1073#1088#1072#1085#1085#1086#1075#1086' <'#1064#1072#1073#1083#1086#1085' '#1089#1073#1086#1088#1082#1072' '#1059#1079#1083#1072'>?'
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1089#1082#1086#1087#1080#1088#1086#1074#1072#1085#1099
    end
    object actSendInsertForm: TOpenChoiceForm
      Category = 'Insert_all'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'SendJournalForm'
      ImageIndex = 47
      FormName = 'TSendJournalChoiceForm'
      FormNameParam.Value = 'TSendJournalChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = '0'
          Component = FormParams
          ComponentItem = 'MovementId_Send'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actInsertUpDate_Child_bySend: TdsdExecStoredProc
      Category = 'Insert_all'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpDate_Child_bySend
      StoredProcList = <
        item
          StoredProc = spInsertUpDate_Child_bySend
        end
        item
        end>
      Caption = 'actInsert_MI_Send'
      ImageIndex = 47
    end
    object macInsertUpDate_Child_bySend: TMultiAction
      Category = 'Insert_all'
      MoveParams = <>
      ActionList = <
        item
          Action = actSendInsertForm
        end
        item
          Action = actInsertUpDate_Child_bySend
        end
        item
          Action = actRefreshChild
        end>
      QuestionBeforeExecute = 
        #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1079#1072#1087#1086#1083#1085#1080#1090#1100' '#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077' '#1085#1072' '#1086#1089#1085#1086#1074#1072#1085#1080#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1055#1077#1088 +
        #1077#1084#1077#1097#1077#1085#1080#1077'?'
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1089#1086#1093#1088#1072#1085#1077#1085#1099
      Caption = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077' '#1085#1072' '#1086#1089#1085#1086#1074#1072#1085#1080#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077
      Hint = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077' '#1085#1072' '#1086#1089#1085#1086#1074#1072#1085#1080#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077
      ImageIndex = 47
    end
    object macErasedGoods_child1_list: TMultiAction
      Category = 'Grid_1'
      MoveParams = <>
      ActionList = <
        item
          Action = actSetErasedGoods
        end>
      View = cxGridDBTableViewCh1
      Caption = 'macErasedGoods_child1_list'
    end
    object macErasedGoods_child1: TMultiAction
      Category = 'Grid_1'
      MoveParams = <>
      ActionList = <
        item
          Action = macErasedGoods_child1_list
        end
        item
          Action = actRefreshChild
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1091#1076#1072#1083#1080#1090#1100' '#1042#1089#1077' '#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077'?'
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1091#1076#1072#1083#1077#1085#1099
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1042#1089#1077' '#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1042#1089#1077' '#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077
      ImageIndex = 52
    end
    object actFormClose: TdsdFormClose
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = #1047#1072#1082#1088#1099#1090#1100
      ImageIndex = 87
    end
    object actSetVisible_ProdColorItems: TBooleanSetVisibleAction
      MoveParams = <>
      Value = False
      Components = <
        item
          Component = PanelProdColorPattern
        end
        item
          Component = PanelProdColorPattern
        end>
      HintTrue = #1057#1082#1088#1099#1090#1100' '#1050#1086#1085#1092#1080#1075#1091#1088#1072#1090#1086#1088
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1050#1086#1085#1092#1080#1075#1091#1088#1072#1090#1086#1088
      CaptionTrue = #1057#1082#1088#1099#1090#1100' '#1050#1086#1085#1092#1080#1075#1091#1088#1072#1090#1086#1088
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1050#1086#1085#1092#1080#1075#1091#1088#1072#1090#1086#1088
      ImageIndexTrue = 25
      ImageIndexFalse = 26
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
    Left = 104
    Top = 208
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
    Left = 480
    Top = 160
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
    ViewDocumentList = <>
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
    Left = 408
    Top = 168
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
    ViewDocumentList = <>
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
        Name = 'inNPP'
        Value = 0
        Component = Child1CDS
        ComponentItem = 'NPP'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inNPP_service'
        Value = Null
        Component = Child1CDS
        ComponentItem = 'NPP_service'
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
        Name = 'inReceiptLevelId_top'
        Value = Null
        Component = GuidesReceiptLevel
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReceiptLevelId'
        Value = Null
        Component = Child1CDS
        ComponentItem = 'ReceiptLevelId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsChildId'
        Value = Null
        Component = Child1CDS
        ComponentItem = 'GoodsChildId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsChildId_top'
        Value = Null
        Component = GuidesGoods
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outGoodsChildName'
        Value = Null
        Component = Child1CDS
        ComponentItem = 'GoodsChildName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioValue'
        Value = Null
        Component = Child1CDS
        ComponentItem = 'Value'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioValue_service'
        Value = Null
        Component = Child1CDS
        ComponentItem = 'Value_service'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioForCount'
        Value = 0.000000000000000000
        Component = Child1CDS
        ComponentItem = 'ForCount'
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
      end
      item
        Name = 'outReceiptLevelName'
        Value = Null
        Component = Child1CDS
        ComponentItem = 'ReceiptLevelName'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDescName'
        Value = Null
        Component = Child1CDS
        ComponentItem = 'DescName'
        DataType = ftString
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
    Left = 312
    Top = 344
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'ImportSettingId'
        Value = Null
        MultiSelectSeparator = ','
      end>
    Left = 736
    Top = 200
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
    Left = 1104
    Top = 120
  end
  object PopupMenu: TPopupMenu
    Images = dmMain.ImageList
    Left = 376
    Top = 208
    object N1: TMenuItem
      Action = actRefresh
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
    ViewDocumentList = <>
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
        Name = 'inReceiptGoodsId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReceiptLevelId'
        Value = Null
        Component = GuidesReceiptLevel
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
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
    Left = 144
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
        Name = 'inNPP'
        Value = 0
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inNPP_service'
        Value = Null
        Component = Child2CDS
        ComponentItem = 'NPP_service'
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
        Name = 'inReceiptLevelId_top'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReceiptLevelId'
        Value = '0'
        Component = Child2CDS
        ComponentItem = 'ReceiptLevelId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsChildId'
        Value = '0'
        Component = Child2CDS
        ComponentItem = 'GoodsChildId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsChildId_top'
        Value = Null
        Component = GuidesGoods
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioValue'
        Value = Null
        Component = Child2CDS
        ComponentItem = 'Value'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioValue_service'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioForCount'
        Value = Null
        Component = Child2CDS
        ComponentItem = 'ForCount'
        DataType = ftFloat
        ParamType = ptInputOutput
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
    Left = 608
    Top = 432
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
    Left = 896
    Top = 144
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
    Left = 1076
    Top = 177
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
    Left = 824
    Top = 136
  end
  object FieldFilter_Article: TdsdFieldFilter
    TextEdit = edSearchArticle
    DataSet = Child1CDS
    Column = Article_all_ch1
    ColumnList = <
      item
        Column = Article_all_ch1
      end
      item
        Column = Article_ch1
      end>
    ActionNumber1 = actChoiceGuides
    CheckBoxList = <>
    Left = 32
    Top = 8
  end
  object GuidesReceiptLevel: TdsdGuides
    KeyField = 'Id'
    LookupControl = edReceiptLevel
    Key = '0'
    FormNameParam.Value = 'TReceiptLevelForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TReceiptLevelForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesReceiptLevel
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesReceiptLevel
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterObjectDesc'
        Value = 'zc_Object_ReceiptGoods'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 1144
    Top = 65528
  end
  object GuidesUnit: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnit
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
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
      end>
    Left = 559
    Top = 65531
  end
  object spInsUpd_Unit: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_ReceiptGoods_Unit'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
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
      end>
    PackSize = 1
    Left = 916
    Top = 104
  end
  object GuidesReceiptGoods: TdsdGuides
    KeyField = 'Id'
    LookupControl = edReceiptGoods
    FormNameParam.Value = 'TReceiptGoodsChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TReceiptGoodsChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesReceiptGoods
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesReceiptGoods
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 296
    Top = 80
  end
  object spInsertUpdate_ReceiptGoods: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_ReceiptGoodsChild_byReceiptGoods'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inReceiptGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReceiptGoodsId_mask'
        Value = ''
        Component = GuidesReceiptGoods
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsChildId'
        Value = Null
        Component = GuidesGoods
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 176
    Top = 192
  end
  object spInsertUpDate_Child_bySend: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_ReceiptGoodsChild_bySend'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inReceiptGoodsId'
        Value = ''
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_Send'
        Value = '0'
        Component = FormParams
        ComponentItem = 'MovementId_Send'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsChildId'
        Value = Null
        Component = GuidesGoods
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 526
    Top = 343
  end
  object GuidesGoods: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoodsChild
    FormNameParam.Value = 'TGoodsForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue_all'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 1080
    Top = 24
  end
  object GuidesUnitChild: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnitChild
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnitChild
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnitChild
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 487
    Top = 19
  end
  object spInsUpd_UnitChild: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_ReceiptGoods_UnitChild'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitChildId'
        Value = ''
        Component = GuidesUnitChild
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 828
    Top = 184
  end
  object spUpdate_Child_union: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_ReceiptGoodsChild_union'
    DataSets = <>
    OutputType = otResult
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
    Left = 188
    Top = 432
  end
  object FieldFilter_Master: TdsdFieldFilter
    TextEdit = edSearchArticle_master
    DataSet = MasterCDS
    Column = Article_all
    ColumnList = <
      item
        Column = Article_all
        TextEdit = edSearchArticle_master
      end
      item
        Column = GoodsName
        TextEdit = edSearchName
      end>
    ActionNumber1 = actChoiceGuides
    CheckBoxList = <>
    Left = 144
  end
end
