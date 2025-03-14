object JuridicalForm: TJuridicalForm
  Left = 0
  Top = 0
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1070#1088#1080#1076#1080#1095#1077#1089#1082#1080#1077' '#1083#1080#1094#1072'>'
  ClientHeight = 537
  ClientWidth = 953
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
  object cxSplitter: TcxSplitter
    Left = 0
    Top = 26
    Width = 8
    Height = 511
  end
  object cxGrid: TcxGrid
    Left = 8
    Top = 26
    Width = 945
    Height = 511
    Align = alClient
    TabOrder = 1
    object cxGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = GridDS
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
          Kind = skCount
          Column = Name
        end>
      DataController.Summary.SummaryGroups = <>
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsSelection.InvertSelect = False
      OptionsView.Footer = True
      OptionsView.HeaderHeight = 40
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object isIrna: TcxGridDBColumn
        Caption = #1048#1088#1085#1072
        DataBinding.FieldName = 'isIrna'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1048#1088#1085#1072' ('#1044#1072'/'#1053#1077#1090')'
        Options.Editing = False
        Width = 58
      end
      object BasisCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1040#1051#1040#1053
        DataBinding.FieldName = 'BasisCode'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 75
      end
      object Code: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'Code'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 40
      end
      object Name: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'Name'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 150
      end
      object OKPO: TcxGridDBColumn
        Caption = #1054#1050#1055#1054
        DataBinding.FieldName = 'OKPO'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object INN: TcxGridDBColumn
        Caption = #1048#1053#1053
        DataBinding.FieldName = 'INN'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object OKPO_inf: TcxGridDBColumn
        Caption = #1054#1050#1055#1054' '#1085#1072' '#1076#1072#1090#1091
        DataBinding.FieldName = 'OKPO_inf'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object INN_inf: TcxGridDBColumn
        Caption = #1048#1053#1053' '#1085#1072' '#1076#1072#1090#1091
        DataBinding.FieldName = 'INN_inf'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object IsDiff: TcxGridDBColumn
        Caption = #1054#1090#1082#1083'. '#1048#1053#1053' '#1080#1083#1080' '#1054#1050#1055#1054
        DataBinding.FieldName = 'IsDiff'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 40
      end
      object JuridicalAddress: TcxGridDBColumn
        Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1080#1081' '#1072#1076#1088#1077#1089
        DataBinding.FieldName = 'JuridicalAddress'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object JuridicalAddress_inf: TcxGridDBColumn
        Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1080#1081' '#1072#1076#1088#1077#1089' '#1085#1072' '#1076#1072#1090#1091
        DataBinding.FieldName = 'JuridicalAddress_inf'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object InvNumberBranch: TcxGridDBColumn
        Caption = #8470' '#1092#1080#1083#1080#1072#1083#1072
        DataBinding.FieldName = 'InvNumberBranch'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object GLNCode: TcxGridDBColumn
        Caption = 'GLN - '#1055#1086#1082#1091#1087#1072#1090#1077#1083#1100' '#1080'/'#1080#1083#1080' '#1055#1086#1083#1091#1095#1072#1090#1077#1083#1100' '
        DataBinding.FieldName = 'GLNCode'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object RetailName: TcxGridDBColumn
        Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100
        DataBinding.FieldName = 'RetailName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actChoiceRetailForm
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object RetailReportName: TcxGridDBColumn
        Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100' ('#1087#1088#1086#1089#1088#1086#1095#1082#1072')'
        DataBinding.FieldName = 'RetailReportName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actChoiceRetailReportForm
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 100
      end
      object JuridicalGroupName: TcxGridDBColumn
        Caption = #1043#1088#1091#1087#1087#1072
        DataBinding.FieldName = 'JuridicalGroupName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actChoiceJuridicalGroup
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object InfoMoneyGroupCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1059#1055' '#1075#1088#1091#1087#1087#1099
        DataBinding.FieldName = 'InfoMoneyGroupCode'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 50
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
      object InfoMoneyDestinationCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1059#1055' '#1085#1072#1079#1085#1072#1095'.'
        DataBinding.FieldName = 'InfoMoneyDestinationCode'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 50
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
      object InfoMoneyCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1059#1055
        DataBinding.FieldName = 'InfoMoneyCode'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 40
      end
      object InfoMoneyName: TcxGridDBColumn
        Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
        DataBinding.FieldName = 'InfoMoneyName'
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
        Options.Editing = False
        Width = 100
      end
      object IsCorporate: TcxGridDBColumn
        Caption = #1043#1083#1072#1074#1085#1086#1077' '#1102#1088'.'#1083'.'
        DataBinding.FieldName = 'isCorporate'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 40
      end
      object isOrderMin: TcxGridDBColumn
        Caption = #1056#1072#1079#1088#1077#1096#1077#1085' '#1084#1080#1085'. '#1079#1072#1082#1072#1079
        DataBinding.FieldName = 'isOrderMin'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1056#1072#1079#1088#1077#1096#1077#1085' '#1084#1080#1085#1080#1084#1072#1083#1100#1085#1099#1081' '#1079#1072#1082#1072#1079' < 5 '#1082#1075'.'
        Options.Editing = False
        Width = 72
      end
      object isVchasnoEdi: TcxGridDBColumn
        Caption = #1042#1095#1072#1089#1085#1086' EDI'
        DataBinding.FieldName = 'isVchasnoEdi'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1054#1073#1088#1072#1073#1086#1090#1082#1072' '#1085#1072' '#1087#1083#1072#1090#1092#1086#1088#1084#1077' '#1042#1095#1072#1089#1085#1086' EDI'
        Options.Editing = False
        Width = 49
      end
      object isBranchAll: TcxGridDBColumn
        Caption = #1044#1086#1089#1090#1091#1087' '#1091' '#1074#1089#1077#1093' '#1092#1080#1083#1080#1072#1083#1086#1074
        DataBinding.FieldName = 'isBranchAll'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1044#1086#1089#1090#1091#1087' '#1091' '#1074#1089#1077#1093' '#1092#1080#1083#1080#1072#1083#1086#1074
        Options.Editing = False
        Width = 92
      end
      object isTaxSummary: TcxGridDBColumn
        Caption = #1057#1074#1086#1076#1085#1072#1103' '#1053#1053
        DataBinding.FieldName = 'isTaxSummary'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 40
      end
      object isNotTare: TcxGridDBColumn
        Caption = #1053#1077' '#1092#1086#1088#1084#1080#1088'. '#1074#1086#1079#1074#1088#1072#1090' '#1090#1072#1088#1099' '#1086#1090' '#1087#1086#1082#1091#1087'.'
        DataBinding.FieldName = 'isNotTare'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1053#1077' '#1092#1086#1088#1084#1080#1088'. '#1074#1086#1079#1074#1088#1072#1090' '#1090#1072#1088#1099' '#1086#1090' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103
        Options.Editing = False
        Width = 133
      end
      object isNotRealGoods: TcxGridDBColumn
        Caption = #1053#1077#1090' c'#1093#1077#1084#1099' '#1089' '#1079#1072#1084#1077#1085#1086#1081' '#1092#1072#1082#1090'/'#1073#1091#1093#1075' '#1086#1090#1075#1088#1091#1079#1082#1072')'
        DataBinding.FieldName = 'isNotRealGoods'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1053#1077#1090' c'#1093#1077#1084#1099' '#1089' '#1079#1072#1084#1077#1085#1086#1081' '#1092#1072#1082#1090'/'#1073#1091#1093#1075' '#1086#1090#1075#1088#1091#1079#1082#1072')'
        Options.Editing = False
        Width = 133
      end
      object isVatPrice: TcxGridDBColumn
        Caption = #1057#1093'. '#1088#1072#1089#1095'. '#1094#1077#1085#1099' '#1089' '#1053#1044#1057' '#1089#1090#1088'.'
        DataBinding.FieldName = 'isVatPrice'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1057#1093#1077#1084#1072' '#1088#1072#1089#1095#1077#1090#1072' '#1094#1077#1085#1099' '#1089' '#1053#1044#1057' ('#1087#1086#1089#1090#1088#1086#1095#1085#1086')'
        Options.Editing = False
        Width = 110
      end
      object VatPriceDate: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' '#1085#1072#1095'. '#1089#1093'. '#1088#1072#1089#1095'. '#1094#1077#1085#1099' '#1089' '#1053#1044#1057' ('#1089#1090#1088'.)'
        DataBinding.FieldName = 'VatPriceDate'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1057' '#1082#1072#1082#1086#1081' '#1076#1072#1090#1099' '#1089#1093#1077#1084#1072' '#1088#1072#1089#1095#1077#1090#1072' '#1094#1077#1085#1099' '#1089' '#1053#1044#1057' ('#1087#1086#1089#1090#1088#1086#1095#1085#1086')'
        Options.Editing = False
        Width = 124
      end
      object DayTaxSummary: TcxGridDBColumn
        Caption = #1055#1077#1088#1080#1086#1076' '#1074' '#1076#1085'. '#1076#1083#1103' '#1089#1074#1086#1076#1085#1086#1081' '#1053#1053
        DataBinding.FieldName = 'DayTaxSummary'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 85
      end
      object SummOrderMin: TcxGridDBColumn
        Caption = #1052#1080#1085'. '#1079#1072#1082#1072#1079' '#1089' '#1089#1091#1084#1084#1086#1081' >= '
        DataBinding.FieldName = 'SummOrderMin'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1052#1080#1085#1080#1084#1072#1083#1100#1085#1099#1081' '#1079#1072#1082#1072#1079' '#1089' '#1089#1091#1084#1084#1086#1081' >= '
        Width = 91
      end
      object SummOrderFinance: TcxGridDBColumn
        Caption = #1051#1080#1084#1080#1090' '#1087#1086' '#1089#1091#1084#1084#1077' '#1086#1090#1089#1088#1086#1095#1082#1080
        DataBinding.FieldName = 'SummOrderFinance'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 135
      end
      object PriceListName: TcxGridDBColumn
        Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090
        DataBinding.FieldName = 'PriceListName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actChoicePriceListForm
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object PriceListPromoName: TcxGridDBColumn
        Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090' ('#1072#1082#1094#1080#1086#1085#1085#1099#1081')'
        DataBinding.FieldName = 'PriceListPromoName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actChoicePriceListPromoForm
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object StartPromo: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' '#1085#1072#1095'. '#1072#1082#1094#1080#1080
        DataBinding.FieldName = 'StartPromo'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object EndPromo: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' '#1079#1072#1074'. '#1072#1082#1094#1080#1080
        DataBinding.FieldName = 'EndPromo'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 65
      end
      object PriceListName_Prior: TcxGridDBColumn
        Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090' ('#1074#1086#1079#1074#1088#1072#1090#1099' '#1087#1086' '#1089#1090#1072#1088'. '#1094#1077#1085#1072#1084')'
        DataBinding.FieldName = 'PriceListName_Prior'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actChoicePriceList_Prior
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object PriceListName_30103: TcxGridDBColumn
        Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090' ('#1061#1083#1077#1073')'
        DataBinding.FieldName = 'PriceListName_30103'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actChoicePriceList_30103
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object PriceListName_30201: TcxGridDBColumn
        Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090' ('#1052#1103#1089#1085#1086#1077' '#1089#1099#1088#1100#1077')'
        DataBinding.FieldName = 'PriceListName_30201'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actChoicePriceList_30201
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object GoodsPropertyName: TcxGridDBColumn
        Caption = #1050#1083#1072#1089#1089#1080#1092#1080#1082#1072#1090#1086#1088' '#1089#1074#1086#1081#1089#1090#1074' '#1090#1086#1074#1072#1088#1072
        DataBinding.FieldName = 'GoodsPropertyName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object SectionName: TcxGridDBColumn
        Caption = #1057#1077#1075#1084#1077#1085#1090
        DataBinding.FieldName = 'SectionName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object isDiscountPrice: TcxGridDBColumn
        Caption = #1055#1077#1095'. '#1094#1077#1085#1091' '#1089#1086' '#1089#1082#1080#1076#1082#1086#1081
        DataBinding.FieldName = 'isDiscountPrice'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 73
      end
      object isPriceWithVAT: TcxGridDBColumn
        Caption = #1055#1077#1095'. '#1094#1077#1085#1091' '#1089' '#1053#1044#1057
        DataBinding.FieldName = 'isPriceWithVAT'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 71
      end
      object isLongUKTZED: TcxGridDBColumn
        Caption = '10-'#1090#1080' '#1079#1085#1072#1095#1085#1099#1081' '#1082#1086#1076' '#1059#1050#1058' '#1047#1045#1044
        DataBinding.FieldName = 'isLongUKTZED'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 101
      end
      object isGUID: TcxGridDBColumn
        Caption = #1057#1086#1079#1076#1072#1085' '#1085#1072' '#1084#1086#1073'.'#1091#1089#1090#1088'.'
        DataBinding.FieldName = 'isGUID'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object GUID: TcxGridDBColumn
        Caption = #1050#1083#1102#1095' '#1084#1086#1073'.'#1091#1089#1090#1088'.'
        DataBinding.FieldName = 'GUID'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
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
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object cxLabel2: TcxLabel
    Left = 591
    Top = 106
    Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1080#1089#1090#1086#1088#1080#1080' '#1085#1072':'
  end
  object edShowDate: TcxDateEdit
    Left = 689
    Top = 105
    EditValue = 43831d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 7
    Width = 88
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
    Left = 208
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
          ItemName = 'bbEdit'
        end
        item
          Visible = True
          ItemName = 'bbErased'
        end
        item
          Visible = True
          ItemName = 'bbUnErased'
        end
        item
          BeginGroup = True
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
          ItemName = 'dxBarControlContainerItem2'
        end
        item
          Visible = True
          ItemName = 'dxBarControlContainerItem1'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbChoiceGuides'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_IsOrderMin'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_IsBranchAll'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsert_VatPrice'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_IsNotTare'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_IsNotTare_Yes'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsertUpdate_BasisCode'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_isIrna'
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
          ItemName = 'bbProtocolOpen'
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
    object bbInsert: TdxBarButton
      Action = actInsert
      Category = 0
    end
    object bbEdit: TdxBarButton
      Action = actUpdate
      Category = 0
    end
    object bbErased: TdxBarButton
      Action = dsdSetErased
      Category = 0
    end
    object bbUnErased: TdxBarButton
      Action = dsdSetUnErased
      Category = 0
    end
    object bbChoiceGuides: TdxBarButton
      Action = dsdChoiceGuides
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
      ShowCaption = False
    end
    object bbProtocolOpen: TdxBarButton
      Action = ProtocolOpenForm
      Category = 0
    end
    object bbShowAll: TdxBarButton
      Action = actShowAll
      Category = 0
    end
    object bbUpdate_IsOrderMin: TdxBarButton
      Action = actUpdate_IsOrderMin
      Category = 0
    end
    object bbUpdate_IsBranchAll: TdxBarButton
      Action = actUpdate_IsBranchAll
      Category = 0
    end
    object bbInsert_VatPrice: TdxBarButton
      Action = macInsert_VatPrice
      Category = 0
    end
    object bbUpdate_IsNotTare: TdxBarButton
      Action = actUpdate_IsNotTare
      Category = 0
    end
    object bbUpdate_IsNotTare_Yes: TdxBarButton
      Action = macUpdate_IsNotTare_Yes
      Category = 0
    end
    object bbInsertUpdate_BasisCode: TdxBarButton
      Action = macInsertUpdate_BasisCode
      Category = 0
    end
    object bbUpdate_isIrna: TdxBarButton
      Action = macUpdate_isIrna
      Category = 0
    end
    object dxBarControlContainerItem1: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = edShowDate
    end
    object dxBarControlContainerItem2: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = cxLabel2
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 208
    Top = 136
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
    object actInsert: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      ShortCut = 45
      ImageIndex = 0
      FormName = 'TJuridicalEditForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      DataSource = GridDS
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actUpdate: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      ShortCut = 115
      ImageIndex = 1
      FormName = 'TJuridicalEditForm'
      FormNameParam.Value = ''
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
      isShowModal = True
      ActionType = acUpdate
      DataSource = GridDS
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object ProtocolOpenForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072'>'
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
          ComponentItem = 'Name'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
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
      DataSource = GridDS
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
      DataSource = GridDS
    end
    object actChoiceRetailForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'RetailChoiceForm'
      FormName = 'TRetailForm'
      FormNameParam.Value = 'TRetailForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'RetailId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'RetailName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actChoiceRetailReportForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'RetailChoiceForm'
      FormName = 'TRetailReportForm'
      FormNameParam.Value = 'TRetailReportForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'RetailReportId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'RetailReportName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actChoicePriceListPromoForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'PriceListPromoChoiceForm'
      FormName = 'TPriceListForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PriceListPromoId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PriceListPromoName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actChoicePriceListForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'PriceListChoiceForm'
      FormName = 'TPriceListForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PriceListId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PriceListName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object dsdChoiceGuides: TdsdChoiceGuides
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
        end
        item
          Name = 'InfoMoneyId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InfoMoneyId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InfoMoneyName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      Caption = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      Hint = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      ImageIndex = 7
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
      DataSource = GridDS
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
    object actChoiceJuridicalGroup: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'PriceListChoiceForm'
      FormName = 'TJuridicalGroup_ObjectForm'
      FormNameParam.Value = 'TJuridicalGroup_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalGroupId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalGroupName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actChoicePriceList_Prior: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'PriceListChoiceForm'
      FormName = 'TPriceListForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PriceListId_Prior'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PriceListName_Prior'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actChoicePriceList_30103: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'PriceListChoiceForm'
      FormName = 'TPriceListForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PriceListId_30103'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PriceListName_30103'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actChoicePriceList_30201: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'PriceListChoiceForm'
      FormName = 'TPriceListForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PriceListId_30103'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PriceListName_30103'
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
    object actUpdate_IsBranchAll: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_IsBranchAll
      StoredProcList = <
        item
          StoredProc = spUpdate_IsBranchAll
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100'  <'#1044#1086#1089#1090#1091#1087' '#1091' '#1074#1089#1077#1093' '#1092#1080#1083#1080#1072#1083#1086#1074'> '#1044#1072'/'#1053#1077#1090
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100'  <'#1044#1086#1089#1090#1091#1087' '#1091' '#1074#1089#1077#1093' '#1092#1080#1083#1080#1072#1083#1086#1074'> '#1044#1072'/'#1053#1077#1090
      ImageIndex = 77
    end
    object actUpdate_IsOrderMin: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_IsOrderMin
      StoredProcList = <
        item
          StoredProc = spUpdate_IsOrderMin
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1056#1072#1079#1088#1077#1096#1077#1085' '#1084#1080#1085'. '#1079#1072#1082#1072#1079' '#1044#1072'/'#1053#1077#1090
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1056#1072#1079#1088#1077#1096#1077#1085' '#1084#1080#1085'. '#1079#1072#1082#1072#1079' '#1044#1072'/'#1053#1077#1090
      ImageIndex = 76
    end
    object macInsert_VatPrice: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = ExecuteVatPriceDialog
        end
        item
          Action = actInsert_VatPrice
        end>
      Caption = 'C'#1093#1077#1084#1072' '#1088#1072#1089#1095#1077#1090#1072' '#1094#1077#1085#1099' '#1089' '#1053#1044#1057' ('#1087#1086#1089#1090#1088#1086#1095#1085#1086')'
      Hint = 'C'#1093#1077#1084#1072' '#1088#1072#1089#1095#1077#1090#1072' '#1094#1077#1085#1099' '#1089' '#1053#1044#1057' ('#1087#1086#1089#1090#1088#1086#1095#1085#1086')'
      ImageIndex = 50
    end
    object ExecuteVatPriceDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      Caption = 'C'#1093#1077#1084#1072' '#1088#1072#1089#1095#1077#1090#1072' '#1094#1077#1085#1099' '#1089' '#1053#1044#1057' ('#1087#1086#1089#1090#1088#1086#1095#1085#1086')'
      Hint = 'C'#1093#1077#1084#1072' '#1088#1072#1089#1095#1077#1090#1072' '#1094#1077#1085#1099' '#1089' '#1053#1044#1057' ('#1087#1086#1089#1090#1088#1086#1095#1085#1086')'
      ImageIndex = 50
      FormName = 'TJuridicalVatPriceDialogForm'
      FormNameParam.Value = 'TJuridicalVatPriceDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inisVatPrice'
          Value = False
          Component = MasterCDS
          ComponentItem = 'isVatPrice'
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inVatPriceDate'
          Value = '01.05.2020'
          Component = MasterCDS
          ComponentItem = 'VatPriceDate'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actInsert_VatPrice: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_VatPrice
      StoredProcList = <
        item
          StoredProc = spUpdate_VatPrice
        end>
      Caption = 'C'#1093#1077#1084#1072' '#1088#1072#1089#1095#1077#1090#1072' '#1094#1077#1085#1099' '#1089' '#1053#1044#1057' ('#1087#1086#1089#1090#1088#1086#1095#1085#1086')'
      Hint = 'C'#1093#1077#1084#1072' '#1088#1072#1089#1095#1077#1090#1072' '#1094#1077#1085#1099' '#1089' '#1053#1044#1057' ('#1087#1086#1089#1090#1088#1086#1095#1085#1086')'
      ImageIndex = 50
    end
    object actUpdate_IsNotTare_Yes: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_IsNotTare_Yes
      StoredProcList = <
        item
          StoredProc = spUpdate_IsNotTare_Yes
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1042#1057#1045#1052' <'#1053#1077' '#1092#1086#1088#1084#1080#1088'. '#1074#1086#1079#1074#1088#1072#1090' '#1090#1072#1088#1099' '#1086#1090' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103'> '#1044#1072
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1042#1057#1045#1052' <'#1053#1077' '#1092#1086#1088#1084#1080#1088'. '#1074#1086#1079#1074#1088#1072#1090' '#1090#1072#1088#1099' '#1086#1090' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103'> '#1044#1072
      ImageIndex = 79
    end
    object actUpdate_IsNotTare: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_IsNotTare
      StoredProcList = <
        item
          StoredProc = spUpdate_IsNotTare
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100'  <'#1053#1077' '#1092#1086#1088#1084#1080#1088'. '#1074#1086#1079#1074#1088#1072#1090' '#1090#1072#1088#1099' '#1086#1090' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103'> '#1044#1072'/'#1053#1077#1090
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100'  <'#1053#1077' '#1092#1086#1088#1084#1080#1088'. '#1074#1086#1079#1074#1088#1072#1090' '#1090#1072#1088#1099' '#1086#1090' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103'> '#1044#1072'/'#1053#1077#1090
      ImageIndex = 80
    end
    object macUpdate_IsNotTare_list: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_IsNotTare_Yes
        end>
      View = cxGridDBTableView
      Caption = 'macUpdate_IsNotTare_list'
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1042#1057#1045#1052' <'#1053#1077' '#1092#1086#1088#1084#1080#1088'. '#1074#1086#1079#1074#1088#1072#1090' '#1090#1072#1088#1099' '#1086#1090' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103'> '#1044#1072
      ImageIndex = 79
    end
    object macUpdate_IsNotTare_Yes: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = macUpdate_IsNotTare_list
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1042#1057#1045#1052' <'#1053#1077' '#1092#1086#1088#1084#1080#1088'. '#1074#1086#1079#1074#1088#1072#1090' '#1090#1072#1088#1099' '#1086#1090' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103'> '#1044#1072
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1042#1057#1045#1052' <'#1053#1077' '#1092#1086#1088#1084#1080#1088'. '#1074#1086#1079#1074#1088#1072#1090' '#1090#1072#1088#1099' '#1086#1090' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103'> '#1044#1072
      ImageIndex = 79
    end
    object macInsertUpdate_BasisCode_list: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actInsertUpdate_BasisCode
        end>
      View = cxGridDBTableView
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1050#1086#1076' '#1040#1083#1072#1085' = '#1050#1086#1076
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1050#1086#1076' '#1040#1083#1072#1085' = '#1050#1086#1076
      ImageIndex = 39
    end
    object actInsertUpdate_BasisCode: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate_BasisCode
      StoredProcList = <
        item
          StoredProc = spInsertUpdate_BasisCode
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1050#1086#1076' '#1040#1083#1072#1085' = '#1050#1086#1076
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1050#1086#1076' '#1040#1083#1072#1085' = '#1050#1086#1076
      ImageIndex = 39
    end
    object macInsertUpdate_BasisCode: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = macInsertUpdate_BasisCode_list
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1057#1082#1086#1087#1080#1088#1086#1074#1072#1090#1100' '#1076#1083#1103' '#1074#1099#1073#1088#1072#1085#1085#1099#1093' '#1101#1083#1077#1084#1077#1085#1090#1086#1074' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1043#1083#1072#1074#1085#1099#1081' '#1082#1086#1076
      InfoAfterExecute = #1050#1086#1087#1080#1088#1086#1074#1072#1085#1080#1077' '#1074#1099#1087#1086#1083#1085#1077#1085#1086
      Caption = #1057#1082#1086#1087#1080#1088#1086#1074#1072#1090#1100' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1043#1083#1072#1074#1085#1099#1081' '#1082#1086#1076
      Hint = #1057#1082#1086#1087#1080#1088#1086#1074#1072#1090#1100' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1043#1083#1072#1074#1085#1099#1081' '#1082#1086#1076
      ImageIndex = 39
    end
    object actUpdate_isIrna: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isIrna
      StoredProcList = <
        item
          StoredProc = spUpdate_isIrna
        end>
      Caption = 'actUpdate_isIrna'
      ImageIndex = 66
    end
    object macUpdate_isIrna: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = macUpdate_isIrna_list
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = 
        #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1083#1103' '#1042#1099#1073#1088#1072#1085#1085#1099#1093' '#1101#1083#1077#1084#1077#1085#1090#1086#1074' '#1047#1085#1072#1095#1077#1085#1080#1077' <'#1048#1088#1085#1072'> '#1085#1072' '#1087#1088#1086#1090#1080#1074#1086#1087#1086#1083#1086#1078 +
        #1085#1086#1077'?'
      InfoAfterExecute = #1047#1085#1072#1095#1077#1085#1080#1077' '#1080#1079#1084#1077#1085#1077#1085#1086
      Caption = 'macUpdate_isIrna'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1047#1085#1072#1095#1077#1085#1080#1077' <'#1048#1088#1085#1072'> '#1044#1072'/'#1053#1077#1090
      ImageIndex = 66
    end
    object macUpdate_isIrna_list: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_isIrna
        end>
      View = cxGridDBTableView
      Caption = 'macUpdate_isIrna_list'
      ImageIndex = 66
    end
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 272
    Top = 184
  end
  object GridDS: TDataSource
    DataSet = MasterCDS
    Left = 272
    Top = 88
  end
  object MasterCDS: TClientDataSet
    Aggregates = <>
    PacketRecords = 0
    Params = <>
    Left = 272
    Top = 136
  end
  object spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Juridical'
    DataSet = MasterCDS
    DataSets = <
      item
        DataSet = MasterCDS
      end>
    Params = <
      item
        Name = 'inShowDate'
        Value = Null
        Component = edShowDate
        DataType = ftDateTime
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
    Left = 112
    Top = 144
  end
  object spErasedUnErased: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_isErased_Juridical'
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
      end>
    PackSize = 1
    Left = 96
    Top = 200
  end
  object dsdDBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView
    OnDblClickActionList = <
      item
        Action = dsdChoiceGuides
      end
      item
        Action = actUpdate
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
    Left = 248
    Top = 272
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_Juridical_Params'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalGroupId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'JuridicalGroupId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRetailId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'RetailId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRetailReportId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'RetailReportId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBasisCode'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'BasisCode'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummOrderMin'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SummOrderMin'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 120
    Top = 280
  end
  object spUpdate_IsOrderMin: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_Juridical_IsOrderMin'
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
        Name = 'inIsOrderMin'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'IsOrderMin'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsOrderMin'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'IsOrderMin'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 376
    Top = 120
  end
  object spUpdate_IsBranchAll: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_Juridical_isBranchAll'
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
        Name = 'inIsBranchAll'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'IsBranchAll'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsBranchAll'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'IsBranchAll'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 504
    Top = 120
  end
  object spUpdate_VatPrice: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_Juridical_VatPrice'
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
        Name = 'inVatPriceDate'
        Value = Null
        Component = FormParams
        ComponentItem = 'inVatPriceDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsVatPrice'
        Value = Null
        Component = FormParams
        ComponentItem = 'inIsVatPrice'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 680
    Top = 192
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'inisVatPrice'
        Value = 'false'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inVatPriceDate'
        Value = '01.05.2020'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 735
    Top = 127
  end
  object spUpdate_IsNotTare: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_Juridical_isNotTare'
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
        Name = 'inisNotTare'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isNotTare'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisNotTare'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isNotTare'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 504
    Top = 224
  end
  object spUpdate_IsNotTare_Yes: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_Juridical_isNotTare'
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
        Name = 'inisNotTare'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisNotTare'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isNotTare'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 584
    Top = 256
  end
  object spInsertUpdate_BasisCode: TdsdStoredProc
    StoredProcName = 'gpUpdate_ObjectCode_Basis'
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
        Name = 'ioBasisCode'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Code'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 416
    Top = 328
  end
  object spUpdate_isIrna: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_Guide_Irna'
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
        Name = 'inisIrna'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isIrna'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 408
    Top = 184
  end
end
