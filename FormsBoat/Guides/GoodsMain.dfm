object GoodsMainForm: TGoodsMainForm
  Left = 0
  Top = 0
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <***'#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077'>'
  ClientHeight = 506
  ClientWidth = 1036
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
  AddOnFormData.ChoiceAction = actChoiceGuides
  AddOnFormData.Params = FormParams
  AddOnFormData.SetFocusedAction = actSetFocused
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid: TcxGrid
    Left = 0
    Top = 88
    Width = 1036
    Height = 377
    Align = alClient
    TabOrder = 0
    LookAndFeel.NativeStyle = False
    object cxGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = DataSource
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Filter.Active = True
      DataController.Summary.DefaultGroupSummaryItems = <
        item
          Format = ',0.####'
          Kind = skSum
          Column = AmountRemains
        end>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = 'C'#1090#1088#1086#1082': ,0'
          Kind = skCount
          Column = Name
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = AmountRemains
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
      object isReceiptGoods_group: TcxGridDBColumn
        Caption = #1059#1079#1077#1083' ('#1076#1072'/'#1085#1077#1090')'
        DataBinding.FieldName = 'isReceiptGoods_group'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object isReceiptGoods: TcxGridDBColumn
        Caption = #1057#1073#1086#1088#1082#1072' ('#1076#1072'/'#1085#1077#1090')'
        DataBinding.FieldName = 'isReceiptGoods'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1059#1095#1072#1089#1090#1074#1091#1077#1090' '#1074' '#1089#1073#1086#1088#1082#1077' '#1059#1079#1083#1072'/'#1052#1086#1076#1077#1083#1080' '#1080#1083#1080' '#1074' '#1086#1087#1094#1080#1103#1093
        Options.Editing = False
        Width = 70
      end
      object isProdOptions: TcxGridDBColumn
        Caption = #1054#1087#1094#1080#1103' ('#1076#1072'/'#1085#1077#1090')'
        DataBinding.FieldName = 'isProdOptions'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1059#1095#1072#1089#1090#1074#1091#1077#1090' '#1074' '#1086#1087#1094#1080#1103#1093
        Options.Editing = False
        Width = 70
      end
      object GoodsGroupNameFull: TcxGridDBColumn
        Caption = #1043#1088#1091#1087#1087#1072
        DataBinding.FieldName = 'GoodsGroupNameFull'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
        Width = 150
      end
      object GoodsGroupName: TcxGridDBColumn
        Caption = '***'#1043#1088#1091#1087#1087#1072
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
      object Code: TcxGridDBColumn
        Caption = 'Interne Nr'
        DataBinding.FieldName = 'Code'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1042#1085#1091#1090#1088#1077#1085#1085#1080#1081' '#1082#1086#1076
        Width = 63
      end
      object Article: TcxGridDBColumn
        Caption = 'Artikel Nr'
        DataBinding.FieldName = 'Article'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object Article_all: TcxGridDBColumn
        Caption = '***Artikel Nr'
        DataBinding.FieldName = 'Article_all'
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
        HeaderHint = #1040#1088#1090#1080#1082#1091#1083' ('#1072#1083#1100#1090#1077#1088#1085#1072#1090#1080#1074#1085#1099#1081')'
        Width = 80
      end
      object GoodsArticle: TcxGridDBColumn
        Caption = 'Article Nr (Pricelist)'
        DataBinding.FieldName = 'GoodsArticle'
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
        HeaderGlyphAlignmentHorz = taCenter
        HeaderHint = #1040#1088#1090#1080#1082#1091#1083' '#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077' ('#1074' '#1079#1072#1075#1088#1091#1079#1082#1077' '#1087#1088#1072#1081#1089#1086#1074')'
        Width = 80
      end
      object Name: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'Name'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 206
      end
      object ModelName_calc: TcxGridDBColumn
        Caption = #1052#1086#1076#1077#1083#1100
        DataBinding.FieldName = 'ModelName_calc'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object GoodsTagName: TcxGridDBColumn
        Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103
        DataBinding.FieldName = 'GoodsTagName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object GoodsTypeName: TcxGridDBColumn
        Caption = #1058#1080#1087' '#1076#1077#1090#1072#1083#1080
        DataBinding.FieldName = 'GoodsTypeName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object MeasureName: TcxGridDBColumn
        Caption = #1045#1076'. '#1080#1079#1084'.'
        DataBinding.FieldName = 'MeasureName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object AmountRemains: TcxGridDBColumn
        Caption = #1054#1089#1090#1072#1090#1086#1082
        DataBinding.FieldName = 'AmountRemains'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1054#1089#1090#1072#1090#1086#1082' '#1085#1072' '#1075#1083'. '#1089#1082#1083#1072#1076#1077' ('#1090#1077#1082#1091#1097#1080#1081')'
        Options.Editing = False
        Width = 70
      end
      object Weight: TcxGridDBColumn
        DataBinding.FieldName = 'Weight'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1042#1077#1089
        Width = 45
      end
      object GoodsSizeName: TcxGridDBColumn
        Caption = 'Gr'#246#223'e'
        DataBinding.FieldName = 'GoodsSizeName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1056#1072#1079#1084#1077#1088
        Width = 80
      end
      object EngineName: TcxGridDBColumn
        Caption = 'Engine'
        DataBinding.FieldName = 'EngineName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1052#1086#1090#1086#1088
        Options.Editing = False
        Width = 80
      end
      object ProdColorName: TcxGridDBColumn
        Caption = 'Farbe'
        DataBinding.FieldName = 'ProdColorName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1062#1074#1077#1090
        Options.Editing = False
        Width = 100
      end
      object EKPrice: TcxGridDBColumn
        Caption = 'Netto EK'
        DataBinding.FieldName = 'EKPrice'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1062#1077#1085#1072' '#1074#1093'. '#1073#1077#1079' '#1053#1044#1057
        Options.Editing = False
        Width = 70
      end
      object EKPriceWVAT: TcxGridDBColumn
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
      object EmpfPrice: TcxGridDBColumn
        Caption = 'Empf. VK'
        DataBinding.FieldName = 'EmpfPrice'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1062#1077#1085#1072' '#1088#1077#1082#1086#1084#1077#1085#1076#1086#1074#1072#1085#1085#1072#1103' '#1073#1077#1079' '#1053#1044#1057
        Options.Editing = False
        Width = 70
      end
      object EmpfPriceWVAT: TcxGridDBColumn
        Caption = #1062#1077#1085#1072' '#1088#1077#1082#1086#1084#1077#1085#1076#1091#1077#1084#1072#1103' '#1089' '#1053#1044#1057
        DataBinding.FieldName = 'EmpfPriceWVAT'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1062#1077#1085#1072' '#1088#1077#1082#1086#1084#1077#1085#1076#1086#1074#1072#1085#1085#1072#1103' '#1089' '#1053#1044#1057
        Options.Editing = False
        Width = 70
      end
      object BasisPrice: TcxGridDBColumn
        Caption = 'Ladenpreis'
        DataBinding.FieldName = 'BasisPrice'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
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
      object StartDate_price: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' '#1089
        DataBinding.FieldName = 'StartDate_price'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1044#1072#1090#1072' '#1089' ('#1087#1088#1072#1081#1089')'
        Options.Editing = False
        Width = 70
      end
      object isDoc: TcxGridDBColumn
        Caption = #1045#1089#1090#1100' '#1076#1086#1082'.'
        DataBinding.FieldName = 'isDoc'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1045#1089#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1094#1080#1103
        Options.Editing = False
        Width = 50
      end
      object isPhoto: TcxGridDBColumn
        Caption = #1045#1089#1090#1100' '#1092#1086#1090#1086
        DataBinding.FieldName = 'isPhoto'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1045#1089#1090#1100' '#1092#1086#1090#1086
        Options.Editing = False
        Width = 50
      end
      object PartnerName: TcxGridDBColumn
        Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
        DataBinding.FieldName = 'PartnerName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object DiscountPartnerName: TcxGridDBColumn
        Caption = #1043#1088#1091#1087#1087#1072' '#1089#1082#1080#1076#1082#1080' '#1091' '#1087#1072#1088#1090#1085#1077#1088#1072
        DataBinding.FieldName = 'DiscountPartnerName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1043#1088#1091#1087#1087#1072' '#1089#1082#1080#1076#1082#1080' '#1091' '#1087#1072#1088#1090#1085#1077#1088#1072
        Options.Editing = False
        Width = 70
      end
      object PartnerDate: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' '#1087#1088#1080#1093#1086#1076
        DataBinding.FieldName = 'PartnerDate'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1044#1072#1090#1072' '#1087#1088#1080#1093#1086#1076#1072' '#1086#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072' ('#1087#1086#1089#1083#1077#1076#1085#1103#1103')'
        Options.Editing = False
        Width = 80
      end
      object GoodsName_receipt: TcxGridDBColumn
        Caption = #1057#1073#1086#1088#1082#1072' '#1059#1079#1083#1072'/'#1052#1086#1076#1077#1083#1080
        DataBinding.FieldName = 'GoodsName_receipt'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1053#1072#1079#1074#1072#1085#1080#1077' '#1059#1079#1083#1072'/'#1052#1086#1076#1077#1083#1080', '#1082#1086#1090#1086#1088#1099#1077' '#1089#1086#1073#1080#1088#1072#1102#1090#1089#1103' '#1080#1079' '#1044#1077#1090#1072#1083#1077#1081'/'#1059#1079#1083#1086#1074
        Options.Editing = False
        Width = 100
      end
      object AmountMin: TcxGridDBColumn
        Caption = #1052#1080#1085'. '#1082#1086#1083'.'
        DataBinding.FieldName = 'AmountMin'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1052#1080#1085' '#1082#1086#1083'-'#1074#1086' '#1085#1072' '#1089#1082#1083#1072#1076#1077
        Options.Editing = False
        Width = 72
      end
      object AmountRefer: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1088#1077#1082'. '#1082' '#1079#1072#1082#1091#1087#1082#1077
        DataBinding.FieldName = 'AmountRefer'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = 'P'#1077#1082#1086#1084#1077#1085#1076#1086#1074'. '#1082#1086#1083'-'#1074#1086' '#1079#1072#1082#1091#1087#1082#1080
        Options.Editing = False
        Width = 80
      end
      object Comment: TcxGridDBColumn
        Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
        DataBinding.FieldName = 'Comment'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 122
      end
      object EAN: TcxGridDBColumn
        DataBinding.FieldName = 'EAN'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 100
      end
      object ASIN: TcxGridDBColumn
        DataBinding.FieldName = 'ASIN'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object MatchCode: TcxGridDBColumn
        Caption = 'Matchcode'
        DataBinding.FieldName = 'MatchCode'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1076' '#1089#1086#1086#1090#1074#1077#1090#1089#1090#1074#1080#1103
        Width = 120
      end
      object FeeNumber: TcxGridDBColumn
        Caption = 'Zolltarif Nr'
        DataBinding.FieldName = 'FeeNumber'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #8470' '#1090#1072#1084#1086#1078#1077#1085#1085#1086#1081' '#1087#1086#1096#1083#1080#1085#1099
        Width = 55
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
        VisibleForCustomization = False
        Width = 80
      end
      object InfoMoneyDestinationName: TcxGridDBColumn
        Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
        DataBinding.FieldName = 'InfoMoneyDestinationName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        VisibleForCustomization = False
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
      object InsertDate: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' ('#1089#1086#1079#1076'.)'
        DataBinding.FieldName = 'InsertDate'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object InsertName: TcxGridDBColumn
        Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076'.)'
        DataBinding.FieldName = 'InsertName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object UpdateDate: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' ('#1082#1086#1088#1088'.)'
        DataBinding.FieldName = 'UpdateDate'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object UpdateName: TcxGridDBColumn
        Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1082#1086#1088#1088'.)'
        DataBinding.FieldName = 'UpdateName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object InvNumber_pl: TcxGridDBColumn
        Caption = #8470' '#1076#1086#1082'. '#1087#1088#1072#1081#1089
        DataBinding.FieldName = 'InvNumber_pl'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object Comment_pl: TcxGridDBColumn
        Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' '#1076#1086#1082'. '#1087#1088#1072#1081#1089
        DataBinding.FieldName = 'Comment_pl'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object myCount_pl: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1074' '#1076#1086#1082'. '#1087#1088#1072#1081#1089
        DataBinding.FieldName = 'myCount_pl'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object UnitName: TcxGridDBColumn
        Caption = #1057#1082#1083#1072#1076' / '#1059#1095#1072#1089#1090#1086#1082' '#1089#1073#1086#1088#1082#1080' ('#1087#1088#1080#1093#1086#1076')'
        DataBinding.FieldName = 'UnitName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1053#1072' '#1082#1072#1082#1086#1081' '#1091#1095#1072#1089#1090#1086#1082' '#1087#1088#1086#1080#1089#1093#1086#1076#1080#1090' '#1055#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
        Options.Editing = False
        Width = 120
      end
      object UnitName_receipt: TcxGridDBColumn
        Caption = #1059#1095#1072#1089#1090#1086#1082' '#1089#1073#1086#1088#1082#1080
        DataBinding.FieldName = 'UnitName_receipt'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1053#1072' '#1082#1072#1082#1086#1084' '#1091#1095#1072#1089#1090#1082#1077' '#1087#1088#1086#1080#1089#1093#1086#1076#1080#1090' '#1088#1072#1089#1093#1086#1076' '#1059#1079#1083#1072'/'#1044#1077#1090#1072#1083#1080' '#1085#1072' '#1089#1073#1086#1088#1082#1091
        Options.Editing = False
        Width = 120
      end
      object UnitName_child_receipt: TcxGridDBColumn
        Caption = #1059#1095#1072#1089#1090#1086#1082' '#1089#1073#1086#1088#1082#1080' '#1055#1060
        DataBinding.FieldName = 'UnitName_child_receipt'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1053#1072' '#1082#1072#1082#1086#1084' '#1091#1095#1072#1089#1090#1082#1077' '#1087#1088#1086#1080#1089#1093#1086#1076#1080#1090' '#1088#1072#1089#1093#1086#1076' '#1044#1077#1090#1072#1083#1080' '#1085#1072' '#1089#1073#1086#1088#1082#1091
        Options.Editing = False
        Width = 120
      end
      object UnitName_parent_receipt: TcxGridDBColumn
        Caption = #1059#1095#1072#1089#1090#1086#1082' '#1089#1073#1086#1088#1082#1080' '#1059#1079#1083#1072
        DataBinding.FieldName = 'UnitName_parent_receipt'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1053#1072' '#1082#1072#1082#1086#1084' '#1091#1095#1072#1089#1090#1082#1077' '#1087#1088#1086#1080#1089#1093#1086#1076#1080#1090' '#1089#1073#1086#1088#1082#1072' '#1059#1079#1083#1072
        Options.Editing = False
        Width = 120
      end
      object Feet: TcxGridDBColumn
        DataBinding.FieldName = 'Feet'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 70
      end
      object Metres: TcxGridDBColumn
        DataBinding.FieldName = 'Metres'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 70
      end
      object Len_1: TcxGridDBColumn
        DataBinding.FieldName = 'Len_1'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object Len_2: TcxGridDBColumn
        DataBinding.FieldName = 'Len_2'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object Len_3: TcxGridDBColumn
        DataBinding.FieldName = 'Len_3'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object Len_4: TcxGridDBColumn
        DataBinding.FieldName = 'Len_4'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object Len_5: TcxGridDBColumn
        DataBinding.FieldName = 'Len_5'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object Len_6: TcxGridDBColumn
        DataBinding.FieldName = 'Len_6'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object Len_7: TcxGridDBColumn
        DataBinding.FieldName = 'Len_7'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object Len_8: TcxGridDBColumn
        DataBinding.FieldName = 'Len_8'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object Len_9: TcxGridDBColumn
        DataBinding.FieldName = 'Len_9'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object Len_10: TcxGridDBColumn
        DataBinding.FieldName = 'Len_10'
        Visible = False
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
      object IsArc: TcxGridDBColumn
        Caption = #1040#1088#1093#1080#1074' ('#1076#1072'/'#1085#1077#1090')'
        DataBinding.FieldName = 'isArc'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object Color_Value: TcxGridDBColumn
        DataBinding.FieldName = 'Color_Value'
        Visible = False
        Options.Editing = False
        VisibleForCustomization = False
        Width = 55
      end
      object Name_all: TcxGridDBColumn
        Caption = '***'#1053#1072#1079#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'Name_all'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 1036
    Height = 62
    Align = alTop
    TabOrder = 1
    object edSearchArticle: TcxTextEdit
      Left = 125
      Top = 34
      TabOrder = 0
      DesignSize = (
        125
        21)
      Width = 125
    end
    object lbSearchArticle: TcxLabel
      Left = 3
      Top = 33
      Caption = #1055#1086#1080#1089#1082' Artikel Nr : '
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clBlue
      Style.Font.Height = -13
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
    end
    object lbSearchCode: TcxLabel
      Left = 268
      Top = 33
      Caption = 'Interne Nr : '
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clBlue
      Style.Font.Height = -13
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
    end
    object lbSearchName: TcxLabel
      Left = 478
      Top = 33
      Caption = #1053#1072#1079#1074#1072#1085#1080#1077' : '
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clBlue
      Style.Font.Height = -13
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
    end
    object edSearchCode: TcxTextEdit
      Left = 351
      Top = 34
      TabOrder = 5
      DesignSize = (
        115
        21)
      Width = 115
    end
    object edSearchName: TcxTextEdit
      Left = 558
      Top = 34
      TabOrder = 4
      DesignSize = (
        140
        21)
      Width = 140
    end
    object cxLabel4: TcxLabel
      Left = 715
      Top = 35
      Caption = #1057#1082#1083#1072#1076' ('#1082#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077'):'
    end
    object edUnit: TcxButtonEdit
      Left = 852
      Top = 34
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 188
    end
    object cxLabel1: TcxLabel
      Left = 8
      Top = 7
      Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090':'
    end
    object edPriceList: TcxButtonEdit
      Left = 79
      Top = 6
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 9
      Text = #1056#1086#1079#1085#1080#1095#1085#1072#1103' '#1094#1077#1085#1072
      Width = 171
    end
  end
  object Panel_btn: TPanel
    Left = 0
    Top = 465
    Width = 1036
    Height = 41
    Align = alBottom
    TabOrder = 6
    object btnInsert: TcxButton
      Left = 482
      Top = 7
      Width = 100
      Height = 25
      Action = actInsert
      TabOrder = 0
    end
    object btnUpdate: TcxButton
      Left = 715
      Top = 7
      Width = 100
      Height = 25
      Action = actUpdate
      TabOrder = 1
    end
    object btnChoiceGuides: TcxButton
      Left = 254
      Top = 7
      Width = 85
      Height = 25
      Action = actChoiceGuides
      TabOrder = 2
    end
    object btnSetErased: TcxButton
      Left = 837
      Top = 7
      Width = 100
      Height = 25
      Action = actSetErased
      TabOrder = 3
    end
    object btnFormClose: TcxButton
      Left = 357
      Top = 7
      Width = 85
      Height = 25
      Action = actFormClose
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
    end
    object btnInsertMask: TcxButton
      Left = 601
      Top = 7
      Width = 100
      Height = 25
      Action = actInsertMask
      TabOrder = 5
    end
    object cxButton1: TcxButton
      Left = 22
      Top = 7
      Width = 193
      Height = 25
      Action = actUpdateDocPhoto
      TabOrder = 6
    end
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 40
    Top = 232
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
    Left = 64
    Top = 168
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
          ItemName = 'bbInsert'
        end
        item
          Visible = True
          ItemName = 'bbEdit'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbUpdateDocPhoto'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
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
          ItemName = 'bbInsertMask'
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
          ItemName = 'bbRefresh'
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
          ItemName = 'bbInsertUpdate_Unit'
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
          ItemName = 'bbReport_Goods'
        end
        item
          Visible = True
          ItemName = 'bbReport_Price'
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
      Action = actSetErased
      Category = 0
    end
    object bbSetUnErased: TdxBarButton
      Action = actSetUnErased
      Category = 0
    end
    object bbGridToExcel: TdxBarButton
      Action = actGridToExcel
      Category = 0
    end
    object dxBarStatic1: TdxBarStatic
      Category = 0
      Visible = ivAlways
      ShowCaption = False
    end
    object bbChoiceGuides: TdxBarButton
      Action = actChoiceGuides
      Category = 0
    end
    object bbShowAll: TdxBarButton
      Action = actShowAll
      Category = 0
    end
    object bbProtocolOpenForm: TdxBarButton
      Action = actProtocolOpenForm
      Category = 0
    end
    object bbUpdateGoods_In: TdxBarButton
      Caption = #1054#1087#1088#1077#1076#1077#1083#1080#1090#1100' '#1076#1072#1090#1091' '#1087#1086#1089#1083'. '#1087#1088#1080#1093#1086#1076#1072' '#1086#1090' '#1087#1086#1089#1090#1072#1074#1097'.  '#1080' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
      Category = 0
      Hint = #1054#1087#1088#1077#1076#1077#1083#1080#1090#1100' '#1076#1072#1090#1091' '#1087#1086#1089#1083'. '#1087#1088#1080#1093#1086#1076#1072' '#1086#1090' '#1087#1086#1089#1090#1072#1074#1097'.  '#1080' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
      Visible = ivAlways
      ImageIndex = 43
    end
    object bbStartLoad: TdxBarButton
      Action = actStartLoad
      Category = 0
    end
    object bbInsertUpdate_Unit: TdxBarButton
      Action = macInsertUpdate_Unit
      Category = 0
    end
    object bbReport_Goods: TdxBarButton
      Action = actReport_Goods
      Category = 0
    end
    object bbReport_Price: TdxBarButton
      Action = actReport_Price
      Category = 0
    end
    object bbInsertMask: TdxBarButton
      Action = actInsertMask
      Category = 0
    end
    object bbUpdateDocPhoto: TdxBarButton
      Action = actUpdateDocPhoto
      Category = 0
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 136
    Top = 96
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 90
      ShortCut = 116
      RefreshOnTabSetChanges = False
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
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
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
    object actChoiceGuides: TdsdChoiceGuides
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
          Name = 'TextValue_all'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Name_all'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MeasureId'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'MeasureId'
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
          Name = 'ProdColorName'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'ProdColorName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Article'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Article'
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
          Name = 'GoodsGroupNameFull'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'GoodsGroupNameFull'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'EKPrice'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'EKPrice'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'EKPriceWVAT'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'EKPriceWVAT'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'EmpfPrice'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'EmpfPrice'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'EmpfPriceWVAT'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'EmpfPriceWVAT'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'BasisPrice'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'BasisPrice'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'BasisPriceWVAT'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'BasisPriceWVAT'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'BasisPrice_choice'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'BasisPrice_choice'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'EAN'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'EAN'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerId'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'PartnerId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerName'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'PartnerName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'AmountRemains'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'AmountRemains'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end>
      Caption = #1054#1050
      Hint = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      ImageIndex = 80
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
    object actShowAll: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
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
    object actProtocolOpenForm: TdsdOpenForm
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
        end
        item
          Name = 'MaskId'
          Value = Null
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
          Name = 'inPriceListName'
          Value = Null
          Component = GuidesPriceList
          ComponentItem = 'TextValue'
          DataType = ftString
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
        end
        item
          Name = 'MaskId'
          Value = Null
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
          Name = 'inPriceListName'
          Value = Null
          Component = GuidesPriceList
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      DataSource = DataSource
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
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
      QuestionBeforeExecute = #1053#1072#1095#1072#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091' '#1040#1088#1090#1080#1082#1091#1083#1086#1074' '#1080#1079' '#1092#1072#1081#1083#1072'?'
      InfoAfterExecute = #1040#1088#1090#1080#1082#1091#1083#1099' '#1079#1072#1075#1088#1091#1078#1077#1085#1099
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1040#1088#1090#1080#1082#1091#1083#1099
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1040#1088#1090#1080#1082#1091#1083#1099
      ImageIndex = 41
    end
    object actSetFocused: TdsdSetFocusedAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actSetFocused'
      ControlName.Value = 'FieldFilter_Article'
      ControlName.DataType = ftString
      ControlName.MultiSelectSeparator = ','
    end
    object actReport_Price: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' <'#1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1072#1081#1089#1072#1084'>'
      Hint = #1054#1090#1095#1077#1090' <'#1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1072#1081#1089#1072#1084'>'
      ImageIndex = 24
      FormName = 'TReport_Movement_PriceListForm'
      FormNameParam.Value = 'TReport_Movement_PriceListForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'GoodsId'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Name'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerId'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'PartnerId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerName'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'PartnerName'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actInsertUpdate_Unit: TdsdExecStoredProc
      Category = 'Update'
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
      Category = 'Update'
      MoveParams = <>
      ActionList = <
        item
          Action = actInsertUpdate_Unit
        end>
      View = cxGridDBTableView
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1084#1077#1089#1090#1086' '#1089#1073#1086#1088#1082#1080' '#1076#1083#1103' '#1042#1089#1077#1093' '#1096#1072#1073#1083#1086#1085#1086#1074
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1084#1077#1089#1090#1086' '#1089#1073#1086#1088#1082#1080' '#1076#1083#1103' '#1042#1089#1077#1093' '#1096#1072#1073#1083#1086#1085#1086#1074
    end
    object macInsertUpdate_Unit: TMultiAction
      Category = 'Update'
      MoveParams = <>
      ActionList = <
        item
          Action = macInsertUpdate_Unit_list
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1042#1099#1073#1088#1072#1085#1085#1086#1077' '#1052#1077#1089#1090#1086' '#1091#1095#1077#1090#1072' '#1076#1083#1103' '#1042#1089#1077#1093' '#1082#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1093'?'
      InfoAfterExecute = #1052#1077#1089#1090#1086' '#1089#1073#1086#1088#1082#1080' '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085#1086
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1052#1077#1089#1090#1086' '#1091#1095#1077#1090#1072' '#1076#1083#1103' '#1042#1089#1077#1093' '#1082#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1093
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1052#1077#1089#1090#1086' '#1091#1095#1077#1090#1072' '#1076#1083#1103' '#1042#1089#1077#1093' '#1082#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1093
      ImageIndex = 76
    end
    object actReport_Goods: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' <'#1044#1074#1080#1078#1077#1085#1080#1077' '#1087#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084'>'
      Hint = #1054#1090#1095#1077#1090' <'#1044#1074#1080#1078#1077#1085#1080#1077' '#1087#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084'>'
      ImageIndex = 40
      FormName = 'TReport_GoodsForm'
      FormNameParam.Value = 'TReport_GoodsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'UnitGroupId'
          Value = ''
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupName'
          Value = ''
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Name'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartionId'
          Value = Null
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
          Value = False
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
    object actInsertMask: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1057#1082#1086#1087#1080#1088#1086#1074#1072#1090#1100
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1086' '#1084#1072#1089#1082#1077
      ShortCut = 16429
      ImageIndex = 54
      FormName = 'TGoodsEditForm'
      FormNameParam.Value = 'TGoodsEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MaskId'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      DataSource = DataSource
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actFormClose: TdsdFormClose
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = #1054#1090#1084#1077#1085#1072
      ImageIndex = 52
    end
    object actUpdateDocPhoto: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1055#1088#1086#1089#1084#1086#1090#1088' '#1060#1086#1090#1086
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' / '#1055#1088#1086#1089#1084#1086#1090#1088' '#1060#1086#1090#1086
      ImageIndex = 86
      FormName = 'TGoodsPhotoEditForm'
      FormNameParam.Value = 'TGoodsPhotoEditForm'
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
          Name = 'inMovementId_OrderClient'
          Value = Null
          ParamType = ptUnknown
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      ActionType = acUpdate
      DataSource = DataSource
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
  end
  object spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Goods'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
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
        Name = 'inShowAll'
        Value = True
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsLimit_100'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 112
    Top = 152
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 232
    Top = 240
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
    Left = 360
    Top = 144
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
    ColorRuleList = <
      item
        BackGroundValueColumn = Color_Value
        ColorValueList = <>
      end>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    ViewDocumentList = <>
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
    Left = 536
    Top = 224
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
        Value = 'TGoodsForm;zc_Object_ImportSetting_Goods'
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
    Left = 600
    Top = 136
  end
  object spUnErased: TdsdStoredProc
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
      end
      item
        Name = 'inIsErased'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 456
    Top = 184
  end
  object spErased: TdsdStoredProc
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
      end
      item
        Name = 'inIsErased'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 448
    Top = 136
  end
  object FieldFilter_Article: TdsdFieldFilter
    TextEdit = edSearchArticle
    DataSet = ClientDataSet
    Column = Article
    ColumnList = <
      item
        Column = Article
      end
      item
        Column = Article_all
      end
      item
        Column = Code
        TextEdit = edSearchCode
      end
      item
        Column = Name
        TextEdit = edSearchName
      end>
    ActionNumber1 = actChoiceGuides
    CheckBoxList = <>
    Left = 96
    Top = 312
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
    Left = 927
    Top = 11
  end
  object spInsUpd_Unit: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_Goods_Unit'
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
        Name = 'inUnitId'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 892
    Top = 56
  end
  object GuidesPriceList: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPriceList
    Key = '2773'
    TextValue = #1056#1086#1079#1085#1080#1095#1085#1072#1103' '#1094#1077#1085#1072
    FormNameParam.Value = 'TPriceListForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPriceListForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = '2773'
        Component = GuidesPriceList
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = #1056#1086#1079#1085#1080#1095#1085#1072#1103' '#1094#1077#1085#1072
        Component = GuidesPriceList
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 8
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = GuidesPriceList
      end>
    Left = 568
    Top = 80
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_Goods'
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
        Name = 'inName'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Name'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inArticle'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Article'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inArticleVergl'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'ArticleVergl'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEAN'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'EAN'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inASIN'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'ASIN'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMatchCode'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'MatchCode'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFeeNumber'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'FeeNumber'
        DataType = ftString
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
        Name = 'inGoodsSizeName'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'GoodsSizeName'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsArc'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'IsArc'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFeet'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Feet'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMetres'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Metres'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWeight'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Weight'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountMin'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'AmountMin'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountRefer'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'AmountRefer'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEKPrice'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'EKPrice'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEmpfPrice'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'EmpfPrice'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsGroupId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'GoodsGroupId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMeasureId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'MeasureId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsTagId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'GoodsTagId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsTypeId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'GoodsTypeId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inProdColorId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'ProdColorId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartnerId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'PartnerId'
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
      end
      item
        Name = 'inDiscountPartnerId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'DiscountPartnerId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTaxKindId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'TaxKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEngineId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'EngineId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceListId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'PriceListId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartDate_price'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'StartDate_price'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperPriceList'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'BasisPrice'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 368
    Top = 280
  end
end
