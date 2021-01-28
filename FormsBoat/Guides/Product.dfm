object ProductForm: TProductForm
  Left = 0
  Top = 0
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <Boat>'
  ClientHeight = 435
  ClientWidth = 1188
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
    Top = 26
    Width = 1188
    Height = 209
    Align = alTop
    BevelEdges = [beLeft]
    BevelOuter = bvNone
    TabOrder = 0
    object cxGrid: TcxGrid
      Left = 0
      Top = 17
      Width = 1188
      Height = 192
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
            Format = ',0.####'
            Kind = skSum
            Column = Hours
          end
          item
            Format = ',0.00'
            Kind = skSum
            Column = EKPrice_summ
          end
          item
            Format = ',0.00'
            Kind = skSum
            Column = EKPriceWVAT_summ
          end
          item
            Format = ',0.00'
            Kind = skSum
            Column = Basis_summ
          end
          item
            Format = ',0.00'
            Kind = skSum
            Column = BasisWVAT_summ
          end
          item
            Format = ',0.00'
            Kind = skSum
            Column = EKPrice_summ1
          end
          item
            Format = ',0.00'
            Kind = skSum
            Column = EKPriceWVAT_summ1
          end
          item
            Format = ',0.00'
            Kind = skSum
            Column = Basis_summ1
          end
          item
            Format = ',0.00'
            Kind = skSum
            Column = BasisWVAT_summ1
          end
          item
            Format = ',0.00'
            Kind = skSum
            Column = EKPrice_summ2
          end
          item
            Format = ',0.00'
            Kind = skSum
            Column = EKPriceWVAT_summ2
          end
          item
            Format = ',0.00'
            Kind = skSum
            Column = Basis_summ2
          end
          item
            Format = ',0.00'
            Kind = skSum
            Column = BasisWVAT_summ2
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
            Column = Hours
          end
          item
            Format = ',0.00'
            Kind = skSum
            Column = EKPrice_summ
          end
          item
            Format = ',0.00'
            Kind = skSum
            Column = EKPriceWVAT_summ
          end
          item
            Format = ',0.00'
            Kind = skSum
            Column = Basis_summ
          end
          item
            Format = ',0.00'
            Kind = skSum
            Column = BasisWVAT_summ
          end
          item
            Format = ',0.00'
            Kind = skSum
            Column = EKPrice_summ1
          end
          item
            Format = ',0.00'
            Kind = skSum
            Column = EKPriceWVAT_summ1
          end
          item
            Format = ',0.00'
            Kind = skSum
            Column = Basis_summ1
          end
          item
            Format = ',0.00'
            Kind = skSum
            Column = BasisWVAT_summ1
          end
          item
            Format = ',0.00'
            Kind = skSum
            Column = EKPrice_summ2
          end
          item
            Format = ',0.00'
            Kind = skSum
            Column = EKPriceWVAT_summ2
          end
          item
            Format = ',0.00'
            Kind = skSum
            Column = Basis_summ2
          end
          item
            Format = ',0.00'
            Kind = skSum
            Column = BasisWVAT_summ2
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
        object isSale: TcxGridDBColumn
          Caption = #1055#1088#1086#1076#1072#1085#1072' ('#1076#1072'/'#1085#1077#1090')'
          DataBinding.FieldName = 'isSale'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1055#1088#1086#1076#1072#1085#1072' ('#1076#1072'/'#1085#1077#1090')'
          Width = 72
        end
        object isBasicConf: TcxGridDBColumn
          Caption = 'Basic Yes/no'
          DataBinding.FieldName = 'isBasicConf'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1042#1082#1083#1102#1095#1080#1090#1100' '#1073#1072#1079#1086#1074#1091#1102' '#1050#1086#1084#1087#1083#1077#1082#1090#1072#1094#1080#1102' '#1052#1086#1076#1077#1083#1080' Yes/no'
          Options.Editing = False
          Width = 55
        end
        object Code: TcxGridDBColumn
          Caption = 'Interne Nr'
          DataBinding.FieldName = 'Code'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1042#1085#1091#1090#1088#1077#1085#1085#1080#1081' '#1082#1086#1076
          Options.Editing = False
          Width = 43
        end
        object CIN: TcxGridDBColumn
          Caption = 'CIN Nr.'
          DataBinding.FieldName = 'CIN'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 100
        end
        object BrandName: TcxGridDBColumn
          Caption = 'Brand'
          DataBinding.FieldName = 'BrandName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 80
        end
        object ClientName: TcxGridDBColumn
          Caption = 'Kunden'
          DataBinding.FieldName = 'ClientName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1050#1083#1080#1077#1085#1090
          Options.Editing = False
          Width = 80
        end
        object ModelName: TcxGridDBColumn
          Caption = 'Model'
          DataBinding.FieldName = 'ModelName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 80
        end
        object ProdColorName: TcxGridDBColumn
          Caption = '~Color'
          DataBinding.FieldName = 'ProdColorName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 100
        end
        object EngineName: TcxGridDBColumn
          Caption = 'Engine'
          DataBinding.FieldName = 'EngineName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1052#1086#1090#1086#1088
          Options.Editing = False
          Width = 80
        end
        object EngineNum: TcxGridDBColumn
          Caption = 'Engine Nr.'
          DataBinding.FieldName = 'EngineNum'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #8470' '#1084#1086#1090#1086#1088#1072
          Options.Editing = False
          Width = 66
        end
        object ReceiptProdModelName: TcxGridDBColumn
          Caption = #1064#1072#1073#1083#1086#1085' '#1089#1073#1086#1088#1082#1080' '#1052#1086#1076#1077#1083#1080
          DataBinding.FieldName = 'ReceiptProdModelName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1064#1072#1073#1083#1086#1085' '#1089#1073#1086#1088#1082#1080' '#1052#1086#1076#1077#1083#1080
          Options.Editing = False
          Width = 112
        end
        object Name: TcxGridDBColumn
          Caption = #1053#1072#1079#1074#1072#1085#1080#1077
          DataBinding.FieldName = 'Name'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderGlyphAlignmentHorz = taCenter
          Options.Editing = False
          Width = 100
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
        object Basis_summ: TcxGridDBColumn
          Caption = 'Total LP'
          DataBinding.FieldName = 'Basis_summ'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1048#1058#1054#1043#1054' '#1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1077#1079' '#1053#1044#1057
          Options.Editing = False
          Width = 70
        end
        object BasisWVAT_summ: TcxGridDBColumn
          Caption = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1089' '#1053#1044#1057
          DataBinding.FieldName = 'BasisWVAT_summ'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1048#1058#1054#1043#1054' '#1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1089' '#1053#1044#1057
          Options.Editing = False
          Width = 70
        end
        object EKPrice_summ1: TcxGridDBColumn
          Caption = 'Total EK (Basis)'
          DataBinding.FieldName = 'EKPrice_summ1'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1048#1058#1054#1043#1054' '#1057#1091#1084#1084#1072' '#1074#1093'. '#1073#1077#1079' '#1053#1044#1057' (Basis)'
          Options.Editing = False
          Width = 70
        end
        object EKPriceWVAT_summ1: TcxGridDBColumn
          Caption = #1057#1091#1084#1084#1072' '#1074#1093'. '#1089' '#1053#1044#1057' (Basis)'
          DataBinding.FieldName = 'EKPriceWVAT_summ1'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1048#1058#1054#1043#1054' '#1057#1091#1084#1084#1072' '#1074#1093'. '#1089' '#1053#1044#1057' (Basis)'
          Options.Editing = False
          Width = 70
        end
        object Basis_summ1: TcxGridDBColumn
          Caption = 'Total LP (Basis)'
          DataBinding.FieldName = 'Basis_summ1'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1048#1058#1054#1043#1054' '#1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1077#1079' '#1053#1044#1057' (Basis)'
          Options.Editing = False
          Width = 70
        end
        object BasisWVAT_summ1: TcxGridDBColumn
          Caption = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1089' '#1053#1044#1057' (Basis)'
          DataBinding.FieldName = 'BasisWVAT_summ1'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1048#1058#1054#1043#1054' '#1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1089' '#1053#1044#1057' (Basis)'
          Options.Editing = False
          Width = 70
        end
        object EKPrice_summ2: TcxGridDBColumn
          Caption = 'Total EK (options)'
          DataBinding.FieldName = 'EKPrice_summ2'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1048#1058#1054#1043#1054' '#1057#1091#1084#1084#1072' '#1074#1093'. '#1073#1077#1079' '#1053#1044#1057' (options)'
          Options.Editing = False
          Width = 70
        end
        object EKPriceWVAT_summ2: TcxGridDBColumn
          Caption = #1057#1091#1084#1084#1072' '#1074#1093'. '#1089' '#1053#1044#1057' (options)'
          DataBinding.FieldName = 'EKPriceWVAT_summ2'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1048#1058#1054#1043#1054' '#1057#1091#1084#1084#1072' '#1074#1093'. '#1089' '#1053#1044#1057' (options)'
          Options.Editing = False
          Width = 70
        end
        object Basis_summ2: TcxGridDBColumn
          Caption = 'Total LP (options)'
          DataBinding.FieldName = 'Basis_summ2'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1048#1058#1054#1043#1054' '#1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1077#1079' '#1053#1044#1057' (options)'
          Options.Editing = False
          Width = 70
        end
        object BasisWVAT_summ2: TcxGridDBColumn
          Caption = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1089' '#1053#1044#1057' (options)'
          DataBinding.FieldName = 'BasisWVAT_summ2'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1048#1058#1054#1043#1054' '#1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1089' '#1053#1044#1057' (options)'
          Options.Editing = False
          Width = 70
        end
        object SummDiscount_total: TcxGridDBColumn
          Caption = #1057#1091#1084#1084#1072' '#1089#1082'. ('#1080#1090#1086#1075#1086')'
          DataBinding.FieldName = 'SummDiscount_total'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1048#1090#1086#1075#1086#1074#1072#1103' '#1089#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1080' '#1087#1086' '#1074#1089#1077#1084' % '#1089#1082#1080#1076#1082#1080
          Options.Editing = False
          Width = 75
        end
        object SummDiscount1: TcxGridDBColumn
          Caption = #1057#1091#1084#1084#1072' '#1089#1082'. (% '#1086#1089#1085'.)'
          DataBinding.FieldName = 'SummDiscount1'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1057#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1080' '#1087#1086' '#1086#1089#1085#1086#1074#1085#1086#1084#1091' % '#1089#1082#1080#1076#1082#1080
          Options.Editing = False
          Width = 75
        end
        object SummDiscount2: TcxGridDBColumn
          Caption = #1057#1091#1084#1084#1072' '#1089#1082'. (% '#1076#1086#1087'.)'
          DataBinding.FieldName = 'SummDiscount2'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1057#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1080' '#1087#1086' '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086#1084#1091' % '#1089#1082#1080#1076#1082#1080
          Options.Editing = False
          Width = 75
        end
        object SummDiscount3: TcxGridDBColumn
          Caption = #1057#1091#1084#1084#1072' '#1089#1082'. (% '#1086#1087#1094'.)'
          DataBinding.FieldName = 'SummDiscount3'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1057#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1080' '#1087#1086' % '#1089#1082#1080#1076#1082#1080' '#1074' '#1054#1087#1094#1080#1103#1093
          Options.Editing = False
          Width = 75
        end
        object Hours: TcxGridDBColumn
          Caption = #1042#1088#1077#1084#1103' '#1086#1073#1089#1083#1091#1078'., '#1095'.'
          DataBinding.FieldName = 'Hours'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1042#1088#1077#1084#1103' '#1086#1073#1089#1083#1091#1078#1080#1074#1072#1085#1080#1103', '#1095'.'
          Options.Editing = False
          Width = 84
        end
        object DiscountTax: TcxGridDBColumn
          Caption = '% '#1089#1082#1080#1076#1082#1080
          DataBinding.FieldName = 'DiscountTax'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = '% '#1089#1082#1080#1076#1082#1080' ('#1086#1089#1085#1086#1074#1085#1086#1081')'
          Options.Editing = False
          Width = 84
        end
        object DiscountNextTax: TcxGridDBColumn
          Caption = '% '#1089#1082#1080#1076#1082#1080' ('#1076#1086#1087'.)'
          DataBinding.FieldName = 'DiscountNextTax'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = '% '#1089#1082#1080#1076#1082#1080' ('#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1081')'
          Options.Editing = False
          Width = 84
        end
        object DateStart: TcxGridDBColumn
          Caption = #1053#1072#1095#1072#1083#1086' '#1087#1088#1086#1080#1079#1074'.'
          DataBinding.FieldName = 'DateStart'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1072
          Options.Editing = False
          Width = 64
        end
        object DateBegin: TcxGridDBColumn
          Caption = #1042#1074#1086#1076' '#1074' '#1101#1082#1089#1087#1083'.'
          DataBinding.FieldName = 'DateBegin'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1044#1072#1090#1072' '#1074#1074#1086#1076#1072' '#1074' '#1101#1082#1089#1087#1083#1091#1072#1090#1072#1094#1080#1102
          Options.Editing = False
          Width = 66
        end
        object DateSale: TcxGridDBColumn
          Caption = #1055#1088#1086#1076#1072#1078#1072
          DataBinding.FieldName = 'DateSale'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1044#1072#1090#1072' '#1087#1088#1086#1076#1072#1078#1080
          Options.Editing = False
          Width = 66
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
        object Color_fon: TcxGridDBColumn
          DataBinding.FieldName = 'Color_fon'
          Visible = False
          VisibleForCustomization = False
        end
      end
      object cxGridLevel: TcxGridLevel
        GridView = cxGridDBTableView
      end
    end
    object Panel3: TPanel
      Left = 0
      Top = 0
      Width = 1188
      Height = 17
      Align = alTop
      Caption = 'Boat'
      Color = clSkyBlue
      ParentBackground = False
      TabOrder = 1
    end
  end
  object PanelProdOptItems: TPanel
    Left = 652
    Top = 240
    Width = 536
    Height = 195
    Align = alClient
    BevelEdges = [beLeft]
    BevelOuter = bvNone
    TabOrder = 1
    object cxGridProdOptItems: TcxGrid
      Left = 0
      Top = 17
      Width = 536
      Height = 178
      Align = alClient
      PopupMenu = PopupMenuOption
      TabOrder = 0
      LookAndFeel.NativeStyle = True
      LookAndFeel.SkinName = 'UserSkin'
      ExplicitLeft = 6
      ExplicitTop = 23
      object cxGridDBTableViewProdOptItems: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = ProdOptItemsDS
        DataController.Filter.Options = [fcoCaseInsensitive]
        DataController.Summary.DefaultGroupSummaryItems = <
          item
            Format = ',0.####'
            Kind = skSum
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
            Format = ',0.00'
            Kind = skSum
          end
          item
            Format = ',0.00'
            Kind = skSum
          end
          item
            Format = ',0.00'
            Kind = skSum
            Column = SalePrice_ch2
          end
          item
            Format = ',0.00'
            Kind = skSum
            Column = SalePriceWVAT_ch2
          end
          item
            Format = ',0.00'
            Kind = skSum
            Column = EKPrice_ch2
          end
          item
            Format = ',0.00'
            Kind = skSum
            Column = EKPriceWVAT_ch2
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
            Column = Sale_summ_ch2
          end
          item
            Format = ',0.00##'
            Kind = skSum
            Column = SaleWVAT_summ_ch2
          end>
        DataController.Summary.FooterSummaryItems = <
          item
            Format = 'C'#1090#1088#1086#1082': ,0'
            Kind = skCount
          end
          item
            Format = ',0.####'
            Kind = skSum
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
            Format = ',0.00'
            Kind = skSum
          end
          item
            Format = ',0.00'
            Kind = skSum
          end
          item
            Format = ',0.00'
            Kind = skSum
            Column = SalePrice_ch2
          end
          item
            Format = ',0.00'
            Kind = skSum
            Column = SalePriceWVAT_ch2
          end
          item
            Format = ',0.00'
            Kind = skSum
            Column = EKPrice_ch2
          end
          item
            Format = ',0.00'
            Kind = skSum
            Column = EKPriceWVAT_ch2
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
            Column = Sale_summ_ch2
          end
          item
            Format = ',0.00##'
            Kind = skSum
            Column = SaleWVAT_summ_ch2
          end>
        DataController.Summary.SummaryGroups = <>
        Images = dmMain.SortImageList
        OptionsCustomize.ColumnHiding = True
        OptionsCustomize.ColumnsQuickCustomization = True
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
          Width = 55
        end
        object NPP_ch2: TcxGridDBColumn
          Caption = #8470' '#1087'/'#1087
          DataBinding.FieldName = 'NPP'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 40
        end
        object DiscountTax_ch2: TcxGridDBColumn
          Caption = '% '#1089#1082#1080#1076#1082#1080
          DataBinding.FieldName = 'DiscountTax'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 60
        end
        object Code_ch2: TcxGridDBColumn
          Caption = #1050#1086#1076
          DataBinding.FieldName = 'Code'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DisplayFormat = ',0.##;-,0.##; ;'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 43
        end
        object ProdOptPatternName_ch2: TcxGridDBColumn
          Caption = #1069#1083#1077#1084#1077#1085#1090
          DataBinding.FieldName = 'ProdOptPatternName'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Action = actChoiceFormProdOptPattern
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderGlyphAlignmentHorz = taCenter
          Options.Editing = False
          Width = 152
        end
        object ProdOptionsName_ch2: TcxGridDBColumn
          Caption = #1054#1087#1094#1080#1103
          DataBinding.FieldName = 'ProdOptionsName'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Action = actChoiceFormProdOptions
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 80
        end
        object ProdColorName_ch2: TcxGridDBColumn
          Caption = 'Farbe'
          DataBinding.FieldName = 'ProdColorName'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Action = actChoiceFormProdColor_goods
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 100
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
        object GoodsGroupName_ch2: TcxGridDBColumn
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
          Width = 55
        end
        object Article_ch2: TcxGridDBColumn
          Caption = 'Artikel Nr'
          DataBinding.FieldName = 'Article'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Action = actChoiceFormGoods_optitems
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
              Action = actChoiceFormGoods_optitems
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 120
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
        object PartNumber_ch2: TcxGridDBColumn
          Caption = #8470' '#1076#1086#1087'. '#1086#1073#1086#1088#1091#1076'.'
          DataBinding.FieldName = 'PartNumber'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #8470' '#1087#1086' '#1090#1077#1093' '#1087#1072#1089#1087#1086#1088#1090#1091' '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085#1085#1086#1075#1086' '#1076#1086#1087'. '#1086#1073#1086#1088#1091#1076#1086#1074#1072#1085#1080#1103
          Width = 80
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
          Width = 50
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
        object SalePrice_ch2: TcxGridDBColumn
          Caption = 'Ladenpreis'
          DataBinding.FieldName = 'SalePrice'
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
        object SalePriceWVAT_ch2: TcxGridDBColumn
          Caption = #1062#1077#1085#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1089' '#1085#1076#1089
          DataBinding.FieldName = 'SalePriceWVAT'
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
          Width = 80
        end
        object Sale_summ_ch2: TcxGridDBColumn
          Caption = 'Total LP'
          DataBinding.FieldName = 'Sale_summ'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1077#1079' '#1053#1044#1057
          Options.Editing = False
          Width = 70
        end
        object SaleWVAT_summ_ch2: TcxGridDBColumn
          Caption = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1089' '#1053#1044#1057
          DataBinding.FieldName = 'SaleWVAT_summ'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1089' '#1053#1044#1057
          Options.Editing = False
          Width = 80
        end
        object Comment_ch2: TcxGridDBColumn
          Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
          DataBinding.FieldName = 'Comment'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderGlyphAlignmentHorz = taCenter
          Width = 179
        end
        object InsertDate_ch2: TcxGridDBColumn
          Caption = #1044#1072#1090#1072' ('#1089#1086#1079#1076'.)'
          DataBinding.FieldName = 'InsertDate'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 55
        end
        object InsertName_ch2: TcxGridDBColumn
          Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076'.)'
          DataBinding.FieldName = 'InsertName'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 70
        end
        object IsErased_ch2: TcxGridDBColumn
          Caption = #1059#1076#1072#1083#1077#1085
          DataBinding.FieldName = 'isErased'
          PropertiesClassName = 'TcxCheckBoxProperties'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 78
        end
        object Color_fon_ch2: TcxGridDBColumn
          DataBinding.FieldName = 'Color_fon'
          Visible = False
          VisibleForCustomization = False
          Width = 55
        end
      end
      object cxGridLevel1: TcxGridLevel
        GridView = cxGridDBTableViewProdOptItems
      end
    end
    object Panel1: TPanel
      Left = 0
      Top = 0
      Width = 536
      Height = 17
      Align = alTop
      Caption = 'Options'
      Color = clAqua
      ParentBackground = False
      TabOrder = 1
      ExplicitLeft = 6
      ExplicitTop = 1
    end
  end
  object PanelProdColorItems: TPanel
    Left = 0
    Top = 240
    Width = 644
    Height = 195
    Align = alLeft
    BevelEdges = [beLeft]
    BevelOuter = bvNone
    TabOrder = 2
    object cxGridProdColorItems: TcxGrid
      Left = 0
      Top = 17
      Width = 644
      Height = 178
      Align = alClient
      PopupMenu = PopupMenuColor
      TabOrder = 0
      LookAndFeel.NativeStyle = True
      LookAndFeel.SkinName = 'UserSkin'
      object cxGridDBTableViewProdColorItems: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = ProdColorItemsDS
        DataController.Filter.Options = [fcoCaseInsensitive]
        DataController.Summary.DefaultGroupSummaryItems = <
          item
            Format = ',0.####'
            Kind = skSum
          end
          item
            Format = ',0.00'
            Kind = skSum
            Column = EKPrice_ch1
          end
          item
            Format = ',0.00'
            Kind = skSum
            Column = EKPriceWVAT_ch1
          end
          item
            Format = ',0.00'
            Kind = skSum
            Column = BasisPrice_ch1
          end
          item
            Format = ',0.00'
            Kind = skSum
            Column = BasisPriceWVAT_ch1
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
            Format = ',0.00##'
            Kind = skSum
            Column = Basis_summ_ch1
          end
          item
            Format = ',0.00##'
            Kind = skSum
            Column = BasisWVAT_summ_ch1
          end>
        DataController.Summary.FooterSummaryItems = <
          item
            Format = 'C'#1090#1088#1086#1082': ,0'
            Kind = skCount
          end
          item
            Format = ',0.####'
            Kind = skSum
          end
          item
            Format = ',0.00'
            Kind = skSum
            Column = EKPrice_ch1
          end
          item
            Format = ',0.00'
            Kind = skSum
            Column = EKPriceWVAT_ch1
          end
          item
            Format = ',0.00'
            Kind = skSum
            Column = BasisPrice_ch1
          end
          item
            Format = ',0.00'
            Kind = skSum
            Column = BasisPriceWVAT_ch1
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
            Format = ',0.00##'
            Kind = skSum
            Column = Basis_summ_ch1
          end
          item
            Format = ',0.00##'
            Kind = skSum
            Column = BasisWVAT_summ_ch1
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
        object isEnabled_ch1: TcxGridDBColumn
          Caption = 'Yes/no'
          DataBinding.FieldName = 'isEnabled'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 45
        end
        object NPP_ch1: TcxGridDBColumn
          Caption = #8470' '#1087'/'#1087
          DataBinding.FieldName = 'NPP'
          Options.Editing = False
          Width = 40
        end
        object Code_ch1: TcxGridDBColumn
          Caption = #1050#1086#1076
          DataBinding.FieldName = 'Code'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DisplayFormat = ',0.##;-,0.##; ;'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 43
        end
        object ProdColorGroupName_ch1: TcxGridDBColumn
          Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103
          DataBinding.FieldName = 'ProdColorGroupName'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Action = actChoiceFormProdColorGroup
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 100
        end
        object ProdColorPatternName_ch1: TcxGridDBColumn
          Caption = #1069#1083#1077#1084#1077#1085#1090
          DataBinding.FieldName = 'ProdColorPatternName'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Action = actChoiceFormProdColorPattern
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderGlyphAlignmentHorz = taCenter
          Options.Editing = False
          Width = 58
        end
        object isDiff_ch1: TcxGridDBColumn
          Caption = 'Diff'
          DataBinding.FieldName = 'isDiff'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1086#1090#1082#1083#1086#1085#1077#1085#1080#1077' '#1086#1090' '#1041#1072#1079#1086#1074#1086#1081' '#1050#1086#1084#1087#1083#1077#1082#1090#1072#1094#1080#1080' Yes/no'
          Options.Editing = False
          Width = 50
        end
        object ProdColorName_ch1: TcxGridDBColumn
          Caption = 'Farbe'
          DataBinding.FieldName = 'ProdColorName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 80
        end
        object IsProdOptions_ch1: TcxGridDBColumn
          Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1082#1072#1082' '#1054#1087#1094#1080#1102
          DataBinding.FieldName = 'IsProdOptions'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1082#1072#1082' '#1054#1087#1094#1080#1102
          Width = 62
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
        object GoodsCode_ch1: TcxGridDBColumn
          Caption = 'Interne Nr'
          DataBinding.FieldName = 'GoodsCode'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1042#1085#1091#1090#1088#1077#1085#1085#1080#1081' '#1082#1086#1076
          Options.Editing = False
          Width = 55
        end
        object Article_ch1: TcxGridDBColumn
          Caption = 'Artikel Nr'
          DataBinding.FieldName = 'Article'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Action = actChoiceFormGoods
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 70
        end
        object GoodsName_ch1: TcxGridDBColumn
          Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077
          DataBinding.FieldName = 'GoodsName'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Action = actChoiceFormGoods
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
          Width = 110
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
          Width = 50
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
        object BasisPrice_ch1: TcxGridDBColumn
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
        object BasisPriceWVAT_ch1: TcxGridDBColumn
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
          Width = 80
        end
        object Basis_summ_ch1: TcxGridDBColumn
          Caption = 'Total LP'
          DataBinding.FieldName = 'Basis_summ'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1077#1079' '#1053#1044#1057
          Options.Editing = False
          Width = 70
        end
        object BasisWVAT_summ_ch1: TcxGridDBColumn
          Caption = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1089' '#1053#1044#1057
          DataBinding.FieldName = 'BasisWVAT_summ'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1089' '#1053#1044#1057
          Options.Editing = False
          Width = 80
        end
        object Comment_ch1: TcxGridDBColumn
          Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
          DataBinding.FieldName = 'Comment'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderGlyphAlignmentHorz = taCenter
          Width = 179
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
        object Color_fon_ch1: TcxGridDBColumn
          DataBinding.FieldName = 'Color_fon'
          Visible = False
          VisibleForCustomization = False
          Width = 55
        end
      end
      object cxGridLevel2: TcxGridLevel
        GridView = cxGridDBTableViewProdColorItems
      end
    end
    object Panel2: TPanel
      Left = 0
      Top = 0
      Width = 644
      Height = 17
      Align = alTop
      Caption = 'Items Boat Structure'
      Color = clLime
      ParentBackground = False
      TabOrder = 1
    end
  end
  object cxTopSplitter: TcxSplitter
    Left = 0
    Top = 235
    Width = 1188
    Height = 5
    AlignSplitter = salTop
    Control = PanelMaster
  end
  object cxRightSplitter: TcxSplitter
    Left = 644
    Top = 240
    Width = 8
    Height = 195
    Control = PanelProdColorItems
  end
  object DataSource: TDataSource
    DataSet = MasterCDS
    Left = 608
    Top = 120
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
    Left = 144
    Top = 40
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
    Left = 48
    Top = 64
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
          ItemName = 'bbShowAllBoatSale'
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
          ItemName = 'bbShowAllColorItems'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'BarSubItemOption'
        end
        item
          Visible = True
          ItemName = 'bbShowAllOptItems'
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
          ItemName = 'bbChoice'
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
    object bbShowAll: TdxBarButton
      Action = actShowAllErased
      Category = 0
    end
    object bbInsertRecordProdColorItems: TdxBarButton
      Action = InsertRecordProdColorItems
      Category = 0
    end
    object bbInsertRecordProdOptItems: TdxBarButton
      Action = InsertRecordProdOptItems
      Category = 0
    end
    object bbSetErasedColor: TdxBarButton
      Action = actSetErasedColor
      Category = 0
    end
    object bbSetUnErasedColor: TdxBarButton
      Action = actSetUnErasedColor
      Category = 0
    end
    object bbSetErasedOpt: TdxBarButton
      Action = actSetErasedOpt
      Category = 0
    end
    object bbSetUnErasedOpt: TdxBarButton
      Action = actSetUnErasedOpt
      Category = 0
    end
    object bbStartLoad: TdxBarButton
      Action = actStartLoad
      Category = 0
    end
    object bbShowAllColorItems: TdxBarButton
      Action = actShowAllColorItems
      Category = 0
    end
    object bbShowAllOptItems: TdxBarButton
      Action = actShowAllOptItems
      Category = 0
    end
    object BarSubItemBoat: TdxBarSubItem
      Caption = 'Boat'
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
        end>
    end
    object BarSubItemColor: TdxBarSubItem
      Caption = 'Boat Structure'
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
        end>
    end
    object BarSubItemOption: TdxBarSubItem
      Caption = 'Options'
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
      Action = actShowAllBoatSale
      Category = 0
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 8
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
          StoredProc = spSelect_ProdColorItems
        end
        item
          StoredProc = spSelect_ProdOptItems
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actInsert: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100
      ImageIndex = 0
      FormName = 'TProductEditForm'
      FormNameParam.Value = 'TProductEditForm'
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
      FormName = 'TProductEditForm'
      FormNameParam.Value = 'TProductEditForm'
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
    object actSetErasedColor: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedColor
      StoredProcList = <
        item
          StoredProc = spErasedColor
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100
      ImageIndex = 2
      ShortCut = 8238
      ErasedFieldName = 'isErased'
      DataSource = ProdColorItemsDS
    end
    object actSetErasedOpt: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedOpt
      StoredProcList = <
        item
          StoredProc = spErasedOpt
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100
      ImageIndex = 2
      ShortCut = 16430
      ErasedFieldName = 'isErased'
      DataSource = ProdOptItemsDS
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
    object actSetUnErasedOpt: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spUnErasedOpt
      StoredProcList = <
        item
          StoredProc = spUnErasedOpt
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 16430
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = ProdOptItemsDS
    end
    object actSetUnErasedColor: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spUnErasedColor
      StoredProcList = <
        item
          StoredProc = spUnErasedColor
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 8238
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = ProdColorItemsDS
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
          StoredProc = spSelect_ProdColorItems
        end
        item
          StoredProc = spSelect_ProdOptItems
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
    object InsertRecordProdOptItems: TInsertRecord
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableViewProdOptItems
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100
      ImageIndex = 0
    end
    object InsertRecordProdColorItems: TInsertRecord
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableViewProdColorItems
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100
      ImageIndex = 0
    end
    object actChoiceFormProdColorGroup: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceFormProdColorGroup'
      FormName = 'TProdColorGroupForm'
      FormNameParam.Value = 'TProdColorGroupForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ProdColorItemsCDS
          ComponentItem = 'ProdColorGroupId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ProdColorItemsCDS
          ComponentItem = 'ProdColorGroupName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actChoiceFormProdOptPattern: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceFormProdOptPattern'
      FormName = 'TProdOptPatternForm'
      FormNameParam.Value = 'TProdOptPatternForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'ProdOptPatternId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'ProdOptPatternName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actChoiceFormProdOptions: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceFormProdOptions'
      FormName = 'TProdOptionsForm'
      FormNameParam.Value = 'TProdOptionsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'ProdOptionsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'ProdOptionsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId_choice'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsCode'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'GoodsCode'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Article'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'Article'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProdColorName'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'ProdColorName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProdColorPatternId'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'ProdColorPatternId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'EKPrice'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'EKPrice'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'EKPriceWVAT'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'EKPriceWVAT'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'SalePrice'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'SalePrice'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'SalePriceWVAT'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'SalePriceWVAT'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'ModelId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ModelId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ModelName_full'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ModelName_full'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actChoiceFormProdColorPattern: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceFormProdColorPattern'
      FormName = 'TProdColorPatternForm'
      FormNameParam.Value = 'TProdColorPatternForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ProdColorItemsCDS
          ComponentItem = 'ProdColorPatternId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ProdColorItemsCDS
          ComponentItem = 'ProdColorPatternName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProdColorGroupId'
          Value = Null
          Component = ProdColorItemsCDS
          ComponentItem = 'ProdColorGroupId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProdColorGroupName'
          Value = Null
          Component = ProdColorItemsCDS
          ComponentItem = 'ProdColorGroupName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actChoiceFormProdColor_goods: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceFormProdColor_goods'
      FormName = 'TProdColor_goodsForm'
      FormNameParam.Value = 'TProdColor_goodsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'TextValue'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'ProdColorName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsCode'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'GoodsCode'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Article'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'Article'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupNameFull'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'GoodsGroupNameFull'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'GoodsGroupName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'EKPrice'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'EKPrice'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'EKPriceWVAT'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'EKPriceWVAT'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actUpdateDataSetProdOptItems: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateProdOptItems
      StoredProcList = <
        item
          StoredProc = spInsertUpdateProdOptItems
        end
        item
          StoredProc = spSelect_ProdOptItems
        end
        item
          StoredProc = spSelect_ProdColorItems
        end>
      Caption = 'actUpdateDataSetProdColorItems'
      DataSource = ProdOptItemsDS
    end
    object actUpdateDataSetProdColorItems: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateProdColorItems
      StoredProcList = <
        item
          StoredProc = spInsertUpdateProdColorItems
        end
        item
          StoredProc = spSelect_ProdColorItems
        end
        item
          StoredProc = spSelect_ProdOptItems
        end>
      Caption = 'actUpdateDataSetProdColorItems'
      DataSource = ProdColorItemsDS
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
    object actShowAllBoatSale: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelect_ProdColorItems
        end
        item
          StoredProc = spSelect_ProdOptItems
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077' '#1083#1086#1076#1082#1080' (+'#1087#1088#1086#1076#1072#1085#1085#1099#1077')'
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077' '#1083#1086#1076#1082#1080' (+'#1087#1088#1086#1076#1072#1085#1085#1099#1077')'
      ImageIndex = 63
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1087#1088#1086#1076#1072#1085#1085#1099#1077
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077' '#1083#1086#1076#1082#1080' (+'#1087#1088#1086#1076#1072#1085#1085#1099#1077')'
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1087#1088#1086#1076#1072#1085#1085#1099#1077
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077' '#1083#1086#1076#1082#1080' (+'#1087#1088#1086#1076#1072#1085#1085#1099#1077')'
      ImageIndexTrue = 62
      ImageIndexFalse = 63
    end
    object actShowAllColorItems: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect_ProdColorItems
      StoredProcList = <
        item
          StoredProc = spSelect_ProdColorItems
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1042#1089#1077' '#1096#1072#1073#1083#1086#1085#1099
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1042#1089#1077' '#1096#1072#1073#1083#1086#1085#1099
      ImageIndex = 63
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1099#1073#1088#1072#1085#1085#1099#1077
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1042#1089#1077' '#1096#1072#1073#1083#1086#1085#1099
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1099#1073#1088#1072#1085#1085#1099#1077
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1042#1089#1077' '#1096#1072#1073#1083#1086#1085#1099
      ImageIndexTrue = 62
      ImageIndexFalse = 63
    end
    object actChoiceFormGoods_optitems: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceFormGoods'
      FormName = 'TGoodsForm'
      FormNameParam.Value = 'TGoodsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'GoodsCode'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Article'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'Article'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupNameFull'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'GoodsGroupNameFull'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'GoodsGroupName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProdColorName'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'ProdColorName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MeasureName'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'MeasureName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'EKPrice'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'EKPrice'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'EKPriceWVAT'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'EKPriceWVAT'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'BasisPrice'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'SalePrice'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'BasisPriceWVAT'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'SalePriceWVAT'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end>
      isShowModal = False
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
    object actStartLoad: TMultiAction
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
      QuestionBeforeExecute = #1053#1072#1095#1072#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091' '#1042#1057#1045#1061' '#1044#1072#1085#1085#1099#1093'?'
      InfoAfterExecute = #1047#1072#1075#1088#1091#1079#1082#1072' '#1074#1099#1087#1086#1083#1085#1077#1085#1072
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1042#1057#1045' '#1044#1072#1085#1085#1099#1077' '#1051#1086#1076#1082#1072#1084
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1042#1057#1045' '#1044#1072#1085#1085#1099#1077' '#1051#1086#1076#1082#1072#1084
      ImageIndex = 41
    end
    object actShowAllOptItems: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect_ProdOptItems
      StoredProcList = <
        item
          StoredProc = spSelect_ProdOptItems
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1042#1089#1077' '#1096#1072#1073#1083#1086#1085#1099
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1042#1089#1077' '#1096#1072#1073#1083#1086#1085#1099
      ImageIndex = 63
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1099#1073#1088#1072#1085#1085#1099#1077
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1042#1089#1077' '#1096#1072#1073#1083#1086#1085#1099
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1099#1073#1088#1072#1085#1085#1099#1077
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1042#1089#1077' '#1096#1072#1073#1083#1086#1085#1099
      ImageIndexTrue = 62
      ImageIndexFalse = 63
    end
    object actChoiceFormGoods: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceFormGoods'
      FormName = 'TGoodsForm'
      FormNameParam.Value = 'TGoodsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ProdColorItemsCDS
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ProdColorItemsCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = ProdColorItemsCDS
          ComponentItem = 'GoodsCode'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Article'
          Value = Null
          Component = ProdColorItemsCDS
          ComponentItem = 'Article'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupNameFull'
          Value = Null
          Component = ProdColorItemsCDS
          ComponentItem = 'GoodsGroupNameFull'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = Null
          Component = ProdColorItemsCDS
          ComponentItem = 'GoodsGroupName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProdColorName'
          Value = Null
          Component = ProdColorItemsCDS
          ComponentItem = 'ProdColorName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MeasureName'
          Value = Null
          Component = ProdColorItemsCDS
          ComponentItem = 'MeasureName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'EKPrice'
          Value = Null
          Component = ProdColorItemsCDS
          ComponentItem = 'EKPrice'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'EKPriceWVAT'
          Value = Null
          Component = ProdColorItemsCDS
          ComponentItem = 'EKPriceWVAT'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'BasisPrice'
          Value = Null
          Component = ProdColorItemsCDS
          ComponentItem = 'BasisPrice'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'BasisPriceWVAT'
          Value = Null
          Component = ProdColorItemsCDS
          ComponentItem = 'BasisPriceWVAT'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
  end
  object spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Product'
    DataSet = MasterCDS
    DataSets = <
      item
        DataSet = MasterCDS
      end>
    Params = <
      item
        Name = 'inIsShowAll'
        Value = False
        Component = actShowAllErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSale'
        Value = Null
        Component = actShowAllBoatSale
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 96
    Top = 120
  end
  object spErased: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_isErased_Product'
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
    ColorRuleList = <
      item
        BackGroundValueColumn = Color_fon
        ColorValueList = <>
      end>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 656
    Top = 128
  end
  object spUnErased: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_isErased_Product'
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
  object ProdOptItemsCDS: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'ProductId'
    MasterFields = 'Id'
    MasterSource = DataSource
    PacketRecords = 0
    Params = <>
    Left = 624
    Top = 288
  end
  object ProdOptItemsDS: TDataSource
    DataSet = ProdOptItemsCDS
    Left = 672
    Top = 296
  end
  object dsdDBViewAddOnProdOptItems: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableViewProdOptItems
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
    ColorRuleList = <
      item
        ColorValueList = <>
      end>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 728
    Top = 344
  end
  object ProdColorItemsCDS: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'ProductId'
    MasterFields = 'Id'
    MasterSource = DataSource
    PacketRecords = 0
    Params = <>
    Left = 248
    Top = 272
  end
  object ProdColorItemsDS: TDataSource
    DataSet = ProdColorItemsCDS
    Left = 248
    Top = 336
  end
  object dsdDBViewAddOnProdColorItems: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableViewProdColorItems
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
    ColorRuleList = <
      item
        ColorValueList = <>
      end>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 368
    Top = 296
  end
  object spSelect_ProdColorItems: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_ProdColorItems'
    DataSet = ProdColorItemsCDS
    DataSets = <
      item
        DataSet = ProdColorItemsCDS
      end>
    Params = <
      item
        Name = 'inisShowAll'
        Value = Null
        Component = actShowAllColorItems
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
      end
      item
        Name = 'inIsSale'
        Value = Null
        Component = actShowAllBoatSale
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 120
    Top = 336
  end
  object spSelect_ProdOptItems: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_ProdOptItems'
    DataSet = ProdOptItemsCDS
    DataSets = <
      item
        DataSet = ProdOptItemsCDS
      end>
    Params = <
      item
        Name = 'inIsShowAll'
        Value = False
        Component = actShowAllOptItems
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = Null
        Component = actShowAllErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsSale'
        Value = Null
        Component = actShowAllBoatSale
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 536
    Top = 288
  end
  object spInsertUpdateProdColorItems: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_ProdColorItems'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = ProdColorItemsCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCode'
        Value = Null
        Component = ProdColorItemsCDS
        ComponentItem = 'Code'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inProductId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = ProdColorItemsCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inProdColorPatternId'
        Value = Null
        Component = ProdColorItemsCDS
        ComponentItem = 'ProdColorPatternId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = ProdColorItemsCDS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsEnabled'
        Value = Null
        Component = ProdColorItemsCDS
        ComponentItem = 'isEnabled'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioIsProdOptions'
        Value = Null
        Component = ProdColorItemsCDS
        ComponentItem = 'IsProdOptions'
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 64
    Top = 312
  end
  object spInsertUpdateProdOptItems: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_ProdOptItems'
    DataSet = ProdOptItemsCDS
    DataSets = <
      item
        DataSet = ProdOptItemsCDS
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = ProdOptItemsCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCode'
        Value = Null
        Component = ProdOptItemsCDS
        ComponentItem = 'Code'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inProductId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inProdOptionsId'
        Value = Null
        Component = ProdOptItemsCDS
        ComponentItem = 'ProdOptionsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inProdOptPatternId'
        Value = Null
        Component = ProdOptItemsCDS
        ComponentItem = 'ProdOptPatternId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inProdColorPatternId'
        Value = Null
        Component = ProdOptItemsCDS
        ComponentItem = 'ProdColorPatternId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioGoodsId'
        Value = Null
        Component = ProdOptItemsCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outGoodsName'
        Value = Null
        Component = ProdOptItemsCDS
        ComponentItem = 'GoodsName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceIn'
        Value = Null
        Component = ProdOptItemsCDS
        ComponentItem = 'EKPrice'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceOut'
        Value = Null
        Component = ProdOptItemsCDS
        ComponentItem = 'SalePrice'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDiscountTax'
        Value = Null
        Component = ProdOptItemsCDS
        ComponentItem = 'DiscountTax'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartNumber'
        Value = Null
        Component = ProdOptItemsCDS
        ComponentItem = 'PartNumber'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = ProdOptItemsCDS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 568
    Top = 336
  end
  object spErasedColor: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_isErased_ProdColorItems'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        Component = ProdColorItemsCDS
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
    Left = 176
    Top = 208
  end
  object spUnErasedColor: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_isErased_ProdColorItems'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        Component = ProdColorItemsCDS
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
    Left = 176
    Top = 256
  end
  object spErasedOpt: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_isErased_ProdOptItems'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        Component = ProdOptItemsCDS
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
    Left = 824
    Top = 312
  end
  object spUnErasedOpt: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_isErased_ProdOptItems'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        Component = ProdOptItemsCDS
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
    Left = 872
    Top = 352
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'ImportSettingId'
        Value = Null
        MultiSelectSeparator = ','
      end>
    Left = 768
    Top = 72
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
        Value = 'TBoat1Form;zc_Object_ImportSetting_Boat1'
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
    Left = 872
    Top = 112
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
      Action = InsertRecordProdColorItems
    end
    object MenuItem3: TMenuItem
      Action = actSetErasedColor
    end
    object MenuItem4: TMenuItem
      Action = actSetUnErasedColor
    end
  end
  object PopupMenuOption: TPopupMenu
    Images = dmMain.ImageList
    Left = 496
    Top = 208
    object MenuItem1: TMenuItem
      Action = InsertRecordProdOptItems
    end
    object MenuItem5: TMenuItem
      Action = actSetErasedOpt
    end
    object MenuItem6: TMenuItem
      Action = actSetUnErasedOpt
    end
  end
end
