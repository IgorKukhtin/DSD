object PartnerForm: TPartnerForm
  Left = 0
  Top = 0
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1099'>'
  ClientHeight = 432
  ClientWidth = 1139
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
    Top = 61
    Width = 1139
    Height = 371
    Align = alClient
    TabOrder = 1
    object cxGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = DataSource
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = #1057#1090#1088#1086#1082': ,0'
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
        Width = 45
      end
      object isGoodsBox: TcxGridDBColumn
        Caption = #1054#1090#1075#1088'. '#1074' '#1075#1086#1092#1088#1086
        DataBinding.FieldName = 'isGoodsBox'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1054#1090#1075#1088#1091#1079#1082#1072' '#1074' '#1075#1086#1092#1088#1086' '#1044#1072'/'#1053#1077#1090
        Options.Editing = False
        Width = 74
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
        Width = 50
      end
      object Name: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'Name'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 133
      end
      object Address: TcxGridDBColumn
        Caption = #1040#1076#1088#1077#1089
        DataBinding.FieldName = 'Address'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 134
      end
      object RetailName: TcxGridDBColumn
        Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100
        DataBinding.FieldName = 'RetailName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object JuridicalGroupName: TcxGridDBColumn
        Caption = #1043#1088#1091#1087#1087#1072' '#1102#1088'. '#1083'.'
        DataBinding.FieldName = 'JuridicalGroupName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object JuridicalName: TcxGridDBColumn
        Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
        DataBinding.FieldName = 'JuridicalName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 103
      end
      object OKPO: TcxGridDBColumn
        Caption = #1054#1050#1055#1054
        DataBinding.FieldName = 'OKPO'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 46
      end
      object ShortName: TcxGridDBColumn
        Tag = 80
        Caption = #1059#1089#1083#1086#1074#1085#1086#1077' '#1086#1073#1086#1079#1085#1072#1095#1077#1085#1080#1077
        DataBinding.FieldName = 'ShortName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 93
      end
      object Category: TcxGridDBColumn
        Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1058#1058
        DataBinding.FieldName = 'Category'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = '0.;-0.; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object TaxSale_Personal: TcxGridDBColumn
        Caption = 'C'#1091#1087#1077#1088#1074#1072#1081#1079#1077#1088' - %'
        DataBinding.FieldName = 'TaxSale_Personal'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1089#1091#1087#1077#1088#1074#1072#1081#1079#1077#1088' - % '#1086#1090' '#1090#1086#1074#1072#1088#1086#1086#1073#1086#1088#1086#1090#1072
        Options.Editing = False
        Width = 70
      end
      object TaxSale_PersonalTrade: TcxGridDBColumn
        Caption = #1058#1055' - %'
        DataBinding.FieldName = 'TaxSale_PersonalTrade'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1058#1055' - % '#1086#1090' '#1090#1086#1074#1072#1088#1086#1086#1073#1086#1088#1086#1090#1072
        Options.Editing = False
        Width = 70
      end
      object TaxSale_MemberSaler1: TcxGridDBColumn
        Caption = #1055#1088#1086#1076#1072#1074#1077#1094'-1 - %'
        DataBinding.FieldName = 'TaxSale_MemberSaler1'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1055#1088#1086#1076#1072#1074#1077#1094'-1 - % '#1086#1090' '#1090#1086#1074#1072#1088#1086#1086#1073#1086#1088#1086#1090#1072
        Options.Editing = False
        Width = 70
      end
      object TaxSale_MemberSaler2: TcxGridDBColumn
        Caption = #1055#1088#1086#1076#1072#1074#1077#1094'-2 - %'
        DataBinding.FieldName = 'TaxSale_MemberSaler2'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1055#1088#1086#1076#1072#1074#1077#1094'-2 - % '#1086#1090' '#1090#1086#1074#1072#1088#1086#1086#1073#1086#1088#1086#1090#1072
        Options.Editing = False
        Width = 70
      end
      object PersonalCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1089#1091#1087#1077#1088#1074'.'
        DataBinding.FieldName = 'PersonalCode'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1076' '#1089#1086#1090#1088#1091#1076#1085#1080#1082' ('#1089#1091#1087#1077#1088#1074#1072#1081#1079#1077#1088')'
        Options.Editing = False
        Width = 55
      end
      object PersonalName: TcxGridDBColumn
        Caption = #1060#1048#1054' '#1089#1086#1090#1088#1091#1076#1085#1080#1082' ('#1089#1091#1087#1077#1088#1074#1072#1081#1079#1077#1088')'
        DataBinding.FieldName = 'PersonalName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = PersonalChoiceForm
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 120
      end
      object PersonalTradeCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1058#1055
        DataBinding.FieldName = 'PersonalTradeCode'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1076' '#1089#1086#1090#1088#1091#1076#1085#1080#1082' ('#1058#1055')'
        Options.Editing = False
        Width = 55
      end
      object BranchName_Personal: TcxGridDBColumn
        Caption = #1060#1080#1083#1080#1072#1083' ('#1089#1091#1087#1077#1088#1074#1072#1081#1079#1077#1088')'
        DataBinding.FieldName = 'BranchName_Personal'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1060#1080#1083#1080#1072#1083' '#1089#1086#1090#1088#1091#1076#1085#1080#1082' ('#1089#1091#1087#1077#1088#1074#1072#1081#1079#1077#1088')'
        Options.Editing = False
        Width = 80
      end
      object UnitName_Personal: TcxGridDBColumn
        Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1089#1091#1087#1077#1088#1074#1072#1081#1079#1077#1088')'
        DataBinding.FieldName = 'UnitName_Personal'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' '#1089#1086#1090#1088#1091#1076#1085#1080#1082' ('#1089#1091#1087#1077#1088#1074#1072#1081#1079#1077#1088')'
        Options.Editing = False
        Width = 80
      end
      object PersonalTradeName: TcxGridDBColumn
        Caption = #1060#1048#1054' '#1089#1086#1090#1088#1091#1076#1085#1080#1082' ('#1058#1055')'
        DataBinding.FieldName = 'PersonalTradeName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = PersonalTradeChoiceForm
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 120
      end
      object BranchName_PersonalTrade: TcxGridDBColumn
        Caption = #1060#1080#1083#1080#1072#1083' '#1058#1055
        DataBinding.FieldName = 'BranchName_PersonalTrade'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1060#1080#1083#1080#1072#1083' '#1089#1086#1090#1088#1091#1076#1085#1080#1082' ('#1058#1055')'
        Options.Editing = False
        Width = 80
      end
      object UnitName_PersonalTrade: TcxGridDBColumn
        Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' '#1058#1055
        DataBinding.FieldName = 'UnitName_PersonalTrade'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' '#1089#1086#1090#1088#1091#1076#1085#1080#1082' ('#1058#1055')'
        Options.Editing = False
        Width = 80
      end
      object PersonalMerchCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1084#1077#1088#1095'.'
        DataBinding.FieldName = 'PersonalMerchCode'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1076' '#1089#1086#1090#1088#1091#1076#1085#1080#1082' ('#1084#1077#1088#1095#1072#1085#1076#1072#1081#1079#1077#1088')'
        Options.Editing = False
        Width = 55
      end
      object PersonalMerchName: TcxGridDBColumn
        Caption = #1060#1048#1054' '#1089#1086#1090#1088#1091#1076#1085#1080#1082' ('#1084#1077#1088#1095#1072#1085#1076#1072#1081#1079#1077#1088')'
        DataBinding.FieldName = 'PersonalMerchName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = PersonalMerchChoiceForm
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 120
      end
      object PersonalSigningCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1089#1086#1090#1088'. ('#1087#1086#1076#1087#1080#1089#1072#1085#1090')'
        DataBinding.FieldName = 'PersonalSigningCode'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1076' '#1089#1086#1090#1088#1091#1076#1085#1080#1082' ('#1087#1086#1076#1087#1080#1089#1072#1085#1090')'
        Options.Editing = False
        Width = 55
      end
      object PersonalSigningName: TcxGridDBColumn
        Caption = #1060#1048#1054' '#1089#1086#1090#1088#1091#1076#1085#1080#1082' ('#1087#1086#1076#1087#1080#1089#1072#1085#1090')'
        DataBinding.FieldName = 'PersonalSigningName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 120
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
      object UnitMobileName: TcxGridDBColumn
        Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1079#1072#1103#1074#1082#1080' '#1084#1086#1073'.)'
        DataBinding.FieldName = 'UnitMobileName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' '#1086#1090#1075#1088#1091#1079#1082#1080' ('#1079#1072#1103#1074#1082#1080' '#1089' '#1084#1086#1073#1080#1083#1100#1085#1086#1075#1086')'
        Options.Editing = False
        Width = 70
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
        Width = 84
      end
      object PriceListPromoName: TcxGridDBColumn
        Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090' ('#1040#1082#1094#1080#1086#1085#1085#1099#1081')'
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
        Width = 86
      end
      object StartPromo: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' '#1085#1072#1095'. '#1072#1082#1094#1080#1080
        DataBinding.FieldName = 'StartPromo'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object EndPromo: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' '#1079#1072#1074'. '#1072#1082#1094#1080#1080
        DataBinding.FieldName = 'EndPromo'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
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
      object RouteName: TcxGridDBColumn
        Caption = #1052#1072#1088#1096#1088#1091#1090
        DataBinding.FieldName = 'RouteName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actChoiceRoute
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 100
      end
      object RouteName_30201: TcxGridDBColumn
        Caption = #1052#1072#1088#1096#1088#1091#1090' ('#1052#1103#1089#1085#1086#1077' '#1089#1099#1088#1100#1077')'
        DataBinding.FieldName = 'RouteName_30201'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actChoiceRoute_30201
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 100
      end
      object RouteSortingName: TcxGridDBColumn
        Caption = #1057#1086#1088#1090#1080#1088#1086#1074#1082#1072' '#1084#1072#1088#1096#1088#1091#1090#1072
        DataBinding.FieldName = 'RouteSortingName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actChoiceRouteSorting
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object MemberTakeName: TcxGridDBColumn
        Caption = #1060#1048#1054' ('#1101#1082#1089#1087#1077#1076#1080#1090#1086#1088')'
        DataBinding.FieldName = 'MemberTakeName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actChoiceMemberTake
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 100
      end
      object MemberSaler1Name: TcxGridDBColumn
        Caption = #1060#1048#1054' ('#1055#1088#1086#1076#1072#1074#1077#1094'-1)'
        DataBinding.FieldName = 'MemberSaler1Name'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actChoiceMemberSaler1
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
      object MemberSaler2Name: TcxGridDBColumn
        Caption = #1060#1048#1054' ('#1055#1088#1086#1076#1072#1074#1077#1094'-2)'
        DataBinding.FieldName = 'MemberSaler2Name'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actChoiceMemberSaler2
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
      object GLNCode: TcxGridDBColumn
        Caption = 'GLN - '#1084#1077#1089#1090#1086' '#1076#1086#1089#1090#1072#1074#1082#1080
        DataBinding.FieldName = 'GLNCode'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object GLNCodeJuridical: TcxGridDBColumn
        Caption = 'GLN - '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1100
        DataBinding.FieldName = 'GLNCodeJuridical'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object GLNCodeRetail: TcxGridDBColumn
        Caption = 'GLN - '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1100
        DataBinding.FieldName = 'GLNCodeRetail'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object GLNCodeCorporate: TcxGridDBColumn
        Caption = 'GLN - '#1087#1086#1089#1090#1072#1074#1097#1080#1082
        DataBinding.FieldName = 'GLNCodeCorporate'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object AreaName: TcxGridDBColumn
        Caption = #1056#1077#1075#1080#1086#1085
        DataBinding.FieldName = 'AreaName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object PartnerTagName: TcxGridDBColumn
        Caption = #1055#1088#1080#1079#1085#1072#1082' '#1090#1086#1088#1075#1086#1074#1086#1081' '#1090#1086#1095#1082#1080
        DataBinding.FieldName = 'PartnerTagName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object UnitCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1087#1086#1076#1088'.'
        DataBinding.FieldName = 'UnitCode'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object UnitName: TcxGridDBColumn
        Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
        DataBinding.FieldName = 'UnitName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actChoiceUnit
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object PrepareDayCount: TcxGridDBColumn
        Caption = #1044#1085'. '#1079#1072#1082#1072#1079
        DataBinding.FieldName = 'PrepareDayCount'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = '0.;-0.; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 45
      end
      object DocumentDayCount: TcxGridDBColumn
        Caption = #1044#1085'. '#1076#1086#1082'.'
        DataBinding.FieldName = 'DocumentDayCount'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = '0.;-0.; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 45
      end
      object BranchCode: TcxGridDBColumn
        Caption = #1053#1086#1084#1077#1088' '#1092#1080#1083#1080#1072#1083#1072
        DataBinding.FieldName = 'BranchCode'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 40
      end
      object BranchJur: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1102#1088'.'#1083#1080#1094#1072' '#1076#1083#1103' '#1092#1080#1083#1080#1072#1083#1072
        DataBinding.FieldName = 'BranchJur'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 90
      end
      object Terminal: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1090#1077#1088#1084#1080#1085#1072#1083#1072
        DataBinding.FieldName = 'Terminal'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 61
      end
      object EdiOrdspr: TcxGridDBColumn
        Caption = 'EDI - '#1055#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1080#1077
        DataBinding.FieldName = 'EdiOrdspr'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 62
      end
      object EdiInvoice: TcxGridDBColumn
        Caption = 'EDI - '#1057#1095#1077#1090
        DataBinding.FieldName = 'EdiInvoice'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 62
      end
      object EdiDesadv: TcxGridDBColumn
        Caption = 'EDI - '#1091#1074#1077#1076#1086#1084#1083#1077#1085#1080#1077
        DataBinding.FieldName = 'EdiDesadv'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 62
      end
      object Value1: TcxGridDBColumn
        Caption = #1055#1085
        DataBinding.FieldName = 'Value1'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 25
      end
      object Value2: TcxGridDBColumn
        Caption = #1042#1090
        DataBinding.FieldName = 'Value2'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 25
      end
      object Value3: TcxGridDBColumn
        Caption = #1057#1088
        DataBinding.FieldName = 'Value3'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 25
      end
      object Value4: TcxGridDBColumn
        Caption = #1063#1090
        DataBinding.FieldName = 'Value4'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 25
      end
      object Value5: TcxGridDBColumn
        Caption = #1055#1090
        DataBinding.FieldName = 'Value5'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 25
      end
      object Value6: TcxGridDBColumn
        Caption = #1057#1073
        DataBinding.FieldName = 'Value6'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 25
      end
      object Value7: TcxGridDBColumn
        Caption = #1042#1089
        DataBinding.FieldName = 'Value7'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 25
      end
      object Delivery1: TcxGridDBColumn
        Caption = #1055#1085' '#1079'-'#1079
        DataBinding.FieldName = 'Delivery1'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1055#1085' '#1079#1072#1074#1086#1079
        Options.Editing = False
        Width = 25
      end
      object Delivery2: TcxGridDBColumn
        Caption = #1042#1090' '#1079'-'#1079
        DataBinding.FieldName = 'Delivery2'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1042#1090' '#1079#1072#1074#1086#1079
        Options.Editing = False
        Width = 25
      end
      object Delivery3: TcxGridDBColumn
        Caption = #1057#1088' '#1079'-'#1079
        DataBinding.FieldName = 'Delivery3'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1057#1088' '#1079#1072#1074#1086#1079
        Options.Editing = False
        Width = 25
      end
      object Delivery4: TcxGridDBColumn
        Caption = #1063#1090' '#1079'-'#1079
        DataBinding.FieldName = 'Delivery4'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1063#1090' '#1079#1072#1074#1086#1079
        Options.Editing = False
        Width = 25
      end
      object Delivery5: TcxGridDBColumn
        Caption = #1055#1090' '#1079'-'#1079
        DataBinding.FieldName = 'Delivery5'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1055#1090' '#1079#1072#1074#1086#1079
        Options.Editing = False
        Width = 25
      end
      object Delivery6: TcxGridDBColumn
        Caption = #1057#1073' '#1079'-'#1079
        DataBinding.FieldName = 'Delivery6'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1057#1073' '#1079#1072#1074#1086#1079
        Options.Editing = False
        Width = 25
      end
      object Delivery7: TcxGridDBColumn
        Caption = #1042#1089' '#1079'-'#1079
        DataBinding.FieldName = 'Delivery7'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1042#1089' '#1079#1072#1074#1086#1079
        Options.Editing = False
        Width = 25
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
        Width = 50
      end
      object GPSN: TcxGridDBColumn
        Caption = 'GPS '#1096#1080#1088#1086#1090#1072
        DataBinding.FieldName = 'GPSN'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = '0.##;-0.##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object GPSE: TcxGridDBColumn
        Caption = 'GPS '#1076#1086#1083#1075#1086#1090#1072
        DataBinding.FieldName = 'GPSE'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = '0.##;-0.##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object Id: TcxGridDBColumn
        Caption = #1050#1083#1102#1095'-2'
        DataBinding.FieldName = 'Id'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = '0.'
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object MovementComment: TcxGridDBColumn
        Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' ('#1076#1083#1103' '#1087#1088#1086#1076#1072#1078#1080')'
        DataBinding.FieldName = 'MovementComment'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' ('#1076#1083#1103' '#1053#1072#1082#1083#1072#1076#1085#1086#1081' '#1087#1088#1086#1076#1072#1078#1080')'
        Options.Editing = False
        Width = 120
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object Panel: TPanel
    Left = 0
    Top = 0
    Width = 1139
    Height = 35
    Align = alTop
    TabOrder = 0
    object edRetail: TcxButtonEdit
      Left = 389
      Top = 6
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 1
      Width = 129
    end
    object cxLabel3: TcxLabel
      Left = 308
      Top = 7
      Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100':'
    end
    object cxLabel6: TcxLabel
      Left = 5
      Top = 7
      Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086':'
    end
    object edJuridical: TcxButtonEdit
      Left = 109
      Top = 6
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 0
      Width = 194
    end
  end
  object cxLabel2: TcxLabel
    Left = 522
    Top = 7
    Caption = #1060#1048#1054' ('#1058#1055'):'
  end
  object edPersonalTrade: TcxButtonEdit
    Left = 577
    Top = 6
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 4
    Width = 185
  end
  object cxLabel4: TcxLabel
    Left = 767
    Top = 7
    Caption = #1052#1072#1088#1096#1088#1091#1090':'
  end
  object edRoute: TcxButtonEdit
    Left = 819
    Top = 6
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 5
    Width = 176
  end
  object edUnitMobile_text: TcxLabel
    Left = 577
    Top = 140
    Caption = #1055#1086#1076#1088#1072#1079#1076'.('#1079#1072#1103#1074#1082#1080' '#1084#1086#1073'.)'
  end
  object edUnitMobile: TcxButtonEdit
    Left = 577
    Top = 163
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 8
    Width = 176
  end
  object cxLabel18: TcxLabel
    Left = 936
    Top = 191
    Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082
    Visible = False
  end
  object cePersonal_update: TcxButtonEdit
    Left = 936
    Top = 214
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 13
    Text = #1057#1086#1090#1088#1091#1076#1085#1080#1082
    Width = 195
  end
  object DataSource: TDataSource
    DataSet = MasterCDS
    Left = 40
    Top = 208
  end
  object MasterCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 152
    Top = 200
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
    Left = 232
    Top = 248
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
    Left = 96
    Top = 232
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
          ItemName = 'bbErased'
        end
        item
          Visible = True
          ItemName = 'bbUnErased'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic2'
        end
        item
          Visible = True
          ItemName = 'bbShowCurPartnerOnMap'
        end
        item
          Visible = True
          ItemName = 'bbShowAllPartnerOnMap'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic2'
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
          ItemName = 'bbsUpdate'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbedUnitMobile_text'
        end
        item
          Visible = True
          ItemName = 'bbedUnitMobile'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_UnitMobile'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbPersonal'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_Personal'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_PersonalTrade'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_PersonalMerch'
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
          ItemName = 'bbProtocolOpen'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbGridToExel'
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
    object bbGridToExel: TdxBarButton
      Action = dsdGridToExcel
      Category = 0
    end
    object bbChoiceGuides: TdxBarButton
      Action = dsdChoiceGuides
      Category = 0
    end
    object dxBarStatic1: TdxBarStatic
      Caption = '   '
      Category = 0
      Hint = '   '
      Visible = ivAlways
      ShowCaption = False
    end
    object bbJuridicalLabel: TdxBarControlContainerItem
      Caption = 'JuridicalLabel'
      Category = 0
      Hint = 'JuridicalLabel'
      Visible = ivAlways
      Control = cxLabel6
    end
    object bbJuridicalGuides: TdxBarControlContainerItem
      Caption = 'JuridicalGuides'
      Category = 0
      Hint = 'JuridicalGuides'
      Visible = ivAlways
      Control = edJuridical
    end
    object bbProtocolOpen: TdxBarButton
      Action = ProtocolOpenForm
      Category = 0
    end
    object bbUpdateEdiOrdspr: TdxBarButton
      Action = actUpdateEdiOrdspr
      Category = 0
    end
    object bbUpdateEdiInvoice: TdxBarButton
      Action = actUpdateEdiInvoice
      Category = 0
    end
    object bbUpdateEdiDesadv: TdxBarButton
      Action = actUpdateEdiDesadv
      Category = 0
    end
    object bbShowAll: TdxBarButton
      Action = actShowAll
      Category = 0
    end
    object bbInsertMask: TdxBarButton
      Action = actInsertMask
      Category = 0
    end
    object bbShowAllPartnerOnMap: TdxBarButton
      Action = mactShowAllPartnerOnMap
      Category = 0
    end
    object dxBarStatic2: TdxBarStatic
      Caption = '    '
      Category = 0
      Hint = '    '
      Visible = ivAlways
    end
    object bbShowCurPartnerOnMap: TdxBarButton
      Action = actShowCurPartnerOnMap
      Category = 0
    end
    object bbStartLoad: TdxBarButton
      Action = actStartLoad
      Category = 0
    end
    object bbUpdate_Category: TdxBarButton
      Action = actUpdate_Category
      Category = 0
    end
    object bbedUnitMobile_text: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = edUnitMobile_text
    end
    object bbedUnitMobile: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = edUnitMobile
    end
    object bbUpdate_UnitMobile: TdxBarButton
      Action = macUpdate_UnitMobile
      Category = 0
    end
    object bbInsertUpdate_BasisCode: TdxBarButton
      Action = macInsertUpdate_BasisCode
      Category = 0
    end
    object bbUpdate_isIrna: TdxBarButton
      Action = macUpdate_isIrna
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1047#1085#1072#1095#1077#1085#1080#1077' <'#1048#1088#1085#1072'> '#1044#1072'/'#1053#1077#1090
      Category = 0
    end
    object bbUpdateGoodsBox: TdxBarButton
      Action = macUpdateGoodsBox
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1047#1085#1072#1095#1077#1085#1080#1077' <'#1054#1090#1075#1088#1091#1079#1082#1072' '#1074' '#1075#1086#1092#1088#1086'> '#1044#1072'/'#1053#1077#1090
      Category = 0
    end
    object bbsUpdate: TdxBarSubItem
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      Category = 0
      Visible = ivAlways
      ImageIndex = 43
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbSeparator'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_Category'
        end
        item
          Visible = True
          ItemName = 'bbSeparator'
        end
        item
          Visible = True
          ItemName = 'bbUpdateEdiOrdspr'
        end
        item
          Visible = True
          ItemName = 'bbUpdateEdiInvoice'
        end
        item
          Visible = True
          ItemName = 'bbUpdateEdiDesadv'
        end
        item
          Visible = True
          ItemName = 'bbSeparator'
        end
        item
          Visible = True
          ItemName = 'bbInsertUpdate_BasisCode'
        end
        item
          Visible = True
          ItemName = 'bbSeparator'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_isIrna'
        end
        item
          Visible = True
          ItemName = 'bbUpdateGoodsBox'
        end>
    end
    object bbSeparator: TdxBarSeparator
      Caption = 'Separator'
      Category = 0
      Hint = 'Separator'
      Visible = ivAlways
      ShowCaption = False
    end
    object bbPersonal: TdxBarControlContainerItem
      Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082
      Category = 0
      Hint = #1057#1086#1090#1088#1091#1076#1085#1080#1082
      Visible = ivAlways
      Control = cePersonal_update
    end
    object bbUpdate_Personal: TdxBarButton
      Action = macUpdate_Personal
      Category = 0
    end
    object bbUpdate_PersonalTrade: TdxBarButton
      Action = macUpdate_PersonalTrade
      Category = 0
    end
    object bbUpdate_PersonalMerch: TdxBarButton
      Action = macUpdate_PersonalMerch
      Category = 0
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 232
    Top = 144
    object actUpdate_PersonalMerch: TdsdExecStoredProc
      Category = 'Personal'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdatePersonalMerch
      StoredProcList = <
        item
          StoredProc = spUpdatePersonalMerch
        end>
      Caption = 'actUpdate_PersonalMerch'
      ImageIndex = 76
    end
    object actUpdate_PersonalTrade: TdsdExecStoredProc
      Category = 'Personal'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdatePersonalTrade
      StoredProcList = <
        item
          StoredProc = spUpdatePersonalTrade
        end>
      Caption = 'actUpdate_PersonalTrade'
      ImageIndex = 76
    end
    object actUpdate_Personal: TdsdExecStoredProc
      Category = 'Personal'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdatePersonal
      StoredProcList = <
        item
          StoredProc = spUpdatePersonal
        end>
      Caption = 'actUpdate_Personal'
      ImageIndex = 76
    end
    object macUpdate_PersonaTradel_list: TMultiAction
      Category = 'Personal'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_PersonalTrade
        end>
      View = cxGridDBTableView
      Caption = 'macUpdate_PersonaTradel_list'
      ImageIndex = 76
    end
    object macUpdate_PersonalMerch_list: TMultiAction
      Category = 'Personal'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_PersonalMerch
        end>
      View = cxGridDBTableView
      Caption = 'macUpdate_PersonalMerch_list'
      ImageIndex = 76
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
    object macUpdate_Personal_list: TMultiAction
      Category = 'Personal'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_Personal
        end>
      View = cxGridDBTableView
      Caption = 'macUpdate_Personal_list'
      ImageIndex = 76
    end
    object macUpdate_Personal: TMultiAction
      Category = 'Personal'
      MoveParams = <>
      ActionList = <
        item
          Action = macUpdate_Personal_list
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = 
        #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1042#1089#1077#1084' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072#1084' '#1074#1099#1073#1088#1072#1085#1085#1086#1075#1086' <'#1057#1086#1090#1088#1091#1076#1085#1080#1082' ('#1089#1091#1087#1077#1088#1074#1072#1081#1079#1077#1088')' +
        '>?'
      InfoAfterExecute = #1055#1072#1088#1072#1084#1077#1090#1088' <'#1057#1086#1090#1088#1091#1076#1085#1080#1082' ('#1089#1091#1087#1077#1088#1074#1072#1081#1079#1077#1088')> '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1042#1057#1045#1052' <'#1057#1086#1090#1088#1091#1076#1085#1080#1082' ('#1089#1091#1087#1077#1088#1074#1072#1081#1079#1077#1088')>'
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1042#1057#1045#1052' <'#1057#1086#1090#1088#1091#1076#1085#1080#1082' ('#1089#1091#1087#1077#1088#1074#1072#1081#1079#1077#1088')>'
      ImageIndex = 79
    end
    object macUpdate_PersonalTrade: TMultiAction
      Category = 'Personal'
      MoveParams = <>
      ActionList = <
        item
          Action = macUpdate_PersonaTradel_list
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1042#1089#1077#1084' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072#1084' '#1074#1099#1073#1088#1072#1085#1085#1086#1075#1086' <'#1057#1086#1090#1088#1091#1076#1085#1080#1082' ('#1058#1055')>?'
      InfoAfterExecute = #1055#1072#1088#1072#1084#1077#1090#1088' <'#1057#1086#1090#1088#1091#1076#1085#1080#1082' ('#1058#1055')> '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1042#1057#1045#1052' <'#1057#1086#1090#1088#1091#1076#1085#1080#1082' ('#1058#1055')>'
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1042#1057#1045#1052' <'#1057#1086#1090#1088#1091#1076#1085#1080#1082' ('#1058#1055')>'
      ImageIndex = 7
    end
    object macUpdate_PersonalMerch: TMultiAction
      Category = 'Personal'
      MoveParams = <>
      ActionList = <
        item
          Action = macUpdate_PersonalMerch_list
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = 
        #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1042#1089#1077#1084' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072#1084' '#1074#1099#1073#1088#1072#1085#1085#1086#1075#1086' <'#1057#1086#1090#1088#1091#1076#1085#1080#1082' ('#1084#1077#1088#1095#1072#1085#1076#1072#1081#1079#1077#1088 +
        ')>?'
      InfoAfterExecute = #1055#1072#1088#1072#1084#1077#1090#1088' <'#1057#1086#1090#1088#1091#1076#1085#1080#1082' ('#1084#1077#1088#1095#1072#1085#1076#1072#1081#1079#1077#1088')> '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1042#1057#1045#1052' <'#1057#1086#1090#1088#1091#1076#1085#1080#1082' ('#1084#1077#1088#1095#1072#1085#1076#1072#1081#1079#1077#1088')>'
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1042#1057#1045#1052' <'#1057#1086#1090#1088#1091#1076#1085#1080#1082' ('#1084#1077#1088#1095#1072#1085#1076#1072#1081#1079#1077#1088')>'
      ImageIndex = 80
    end
    object actInsert: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      ShortCut = 45
      ImageIndex = 0
      FormName = 'TPartnerEditForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = 0
          MultiSelectSeparator = ','
        end
        item
          Name = 'MaskId'
          Value = 0
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalId'
          Value = ''
          Component = JuridicalGuides
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      DataSource = DataSource
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actInsertMask: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1086' '#1084#1072#1089#1082#1077
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1086' '#1084#1072#1089#1082#1077
      ImageIndex = 54
      FormName = 'TPartnerEditForm'
      FormNameParam.Value = 'TPartnerEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = 0
          MultiSelectSeparator = ','
        end
        item
          Name = 'MaskId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalId'
          Value = 0
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actUpdate_Category: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1050#1072#1090#1077#1075#1086#1088#1080#1102' '#1058#1058
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1050#1072#1090#1077#1075#1086#1088#1080#1102' '#1058#1058
      ImageIndex = 43
      FormName = 'TPartner_CategoryEditForm'
      FormNameParam.Name = 'TPartner_CategoryEditForm'
      FormNameParam.Value = 'TPartner_CategoryEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Category'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Category'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      ActionType = acUpdate
      DataSource = DataSource
      IdFieldName = 'Id'
    end
    object actUpdate: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      ShortCut = 115
      ImageIndex = 1
      FormName = 'TPartnerEditForm'
      FormNameParam.Value = 'TPartnerEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'MaskId'
          Value = 0
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalId'
          Value = 0
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      DataSource = DataSource
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
          Component = MasterCDS
          ComponentItem = 'Name'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actUpdateEdiDesadv: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateEdiDesadv
      StoredProcList = <
        item
          StoredProc = spUpdateEdiDesadv
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' "EDI - '#1091#1074#1077#1076#1086#1084#1083#1077#1085#1080#1077'"'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' "EDI - '#1091#1074#1077#1076#1086#1084#1083#1077#1085#1080#1077'"'
      ImageIndex = 72
    end
    object actUpdateEdiInvoice: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateEdiInvoice
      StoredProcList = <
        item
          StoredProc = spUpdateEdiInvoice
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' "EDI - '#1057#1095#1077#1090'"'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' "EDI - '#1057#1095#1077#1090'"'
      ImageIndex = 52
    end
    object actUpdateEdiOrdspr: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateEdiOrdspr
      StoredProcList = <
        item
          StoredProc = spUpdateEdiOrdspr
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' "EDI - '#1055#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1080#1077'"'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' "EDI - '#1055#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1080#1077'"'
      ImageIndex = 58
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
          Name = 'JuridicalId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalName'
          DataType = ftString
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
    object actChoiceRoute: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'Route_ObjectForm'
      FormName = 'TRoute_ObjectForm'
      FormNameParam.Value = 'TRoute_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'RouteId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'RouteName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actChoiceRoute_30201: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'Route_ObjectForm'
      FormName = 'TRoute_ObjectForm'
      FormNameParam.Value = 'TRoute_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'RouteId_30201'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'RouteName_30201'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actChoiceRouteSorting: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'RouteSorting_ObjectForm'
      FormName = 'TRouteSorting_ObjectForm'
      FormNameParam.Value = 'TRouteSorting_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'RouteSortingId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'RouteSortingName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actChoiceMemberTake: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'Member_ObjectForm'
      FormName = 'TMember_ObjectForm'
      FormNameParam.Value = 'TMember_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MemberTakeId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MemberTakeName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actChoiceMemberSaler1: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'Member_ObjectForm'
      FormName = 'TMember_ObjectForm'
      FormNameParam.Value = 'TMember_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MemberSaler1Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MemberSaler1Name'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actChoiceMemberSaler2: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'Member_ObjectForm'
      FormName = 'TMember_ObjectForm'
      FormNameParam.Value = 'TMember_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MemberSaler2Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MemberSaler2Name'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object PersonalMerchChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'Personal_ObjectForm'
      FormName = 'TPersonal_ObjectForm'
      FormNameParam.Value = 'TPersonal_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PersonalMerchId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PersonalMerchName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object PersonalChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'Personal_ObjectForm'
      FormName = 'TPersonal_ObjectForm'
      FormNameParam.Value = 'TPersonal_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PersonalId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PersonalName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object PersonalTradeChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'Personal_ObjectForm'
      FormName = 'TPersonal_ObjectForm'
      FormNameParam.Value = 'TPersonal_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PersonalTradeId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PersonalTradeName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actChoiceUnit: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'Route_ObjectForm'
      FormName = 'TUnit_ObjectForm'
      FormNameParam.Value = 'TUnit_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UnitId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UnitCode'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UnitName'
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
    object mactShowAllPartnerOnMap: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actCheckShowAllPartnerOnMap
        end
        item
          Action = actShowAllPartnerOnMap
        end>
      QuestionBeforeExecute = 
        #1054#1090#1082#1088#1099#1090#1080#1077' '#1082#1072#1088#1090#1099' '#1076#1083#1103' '#1073#1086#1083#1100#1096#1086#1075#1086' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1072' '#1072#1076#1088#1077#1089#1086#1074' '#1084#1086#1078#1077#1090' '#1074#1099#1087#1086#1083#1085#1103#1090#1100#1089#1103 +
        ' '#1076#1086#1083#1075#1086'.'#1055#1088#1086#1076#1086#1083#1078#1080#1090#1100'? '
      Caption = #1050#1072#1088#1090#1072' Google - '#1042#1057#1045' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1099
      Hint = #1050#1072#1088#1090#1072' Google - '#1042#1057#1045' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1099
      ImageIndex = 40
    end
    object actShowAllPartnerOnMap: TdsdPartnerMapAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1082#1072#1088#1090#1091' '#1076#1083#1103' '#1087#1088#1086#1089#1084#1086#1090#1088#1072' '#1042#1057#1045#1061' '#1072#1076#1088#1077#1089#1086#1074
      Hint = #1054#1090#1082#1088#1099#1090#1100' '#1082#1072#1088#1090#1091' '#1076#1083#1103' '#1087#1088#1086#1089#1084#1086#1090#1088#1072' '#1042#1057#1045#1061' '#1072#1076#1088#1077#1089#1086#1074
      FormName = 'TPartnerMapForm'
      FormNameParam.Value = 'TPartnerMapForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
      MapType = acShowAll
      DataSet = MasterCDS
      GPSNField = 'GPSN'
      GPSEField = 'GPSE'
      AddressField = 'Address'
    end
    object actShowCurPartnerOnMap: TdsdPartnerMapAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1050#1072#1088#1090#1072' Google - '#1090#1086#1083#1100#1082#1086' '#1054#1044#1048#1053' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090
      Hint = #1050#1072#1088#1090#1072' Google - '#1090#1086#1083#1100#1082#1086' '#1054#1044#1048#1053' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090
      ImageIndex = 74
      FormName = 'TPartnerMapForm'
      FormNameParam.Value = 'TPartnerMapForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
      DataSet = MasterCDS
      GPSNField = 'GPSN'
      GPSEField = 'GPSE'
      AddressField = 'Address'
    end
    object actCheckShowAllPartnerOnMap: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spCheck
      StoredProcList = <
        item
          StoredProc = spCheck
        end>
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
    object actUpdateGoodsBox: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateGoodsBox
      StoredProcList = <
        item
          StoredProc = spUpdateGoodsBox
        end>
      Caption = 'UpdateGoodsBox'
      ImageIndex = 11
    end
    object macUpdateGoodsBox_list: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateGoodsBox
        end>
      View = cxGridDBTableView
      Caption = 'macUpdateGoodsBox_list'
      ImageIndex = 11
    end
    object macUpdateGoodsBox: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = macUpdateGoodsBox_list
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = 
        #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1083#1103' '#1042#1099#1073#1088#1072#1085#1085#1099#1093' '#1101#1083#1077#1084#1077#1085#1090#1086#1074' '#1047#1085#1072#1095#1077#1085#1080#1077' <'#1054#1090#1075#1088#1091#1079#1082#1072' '#1074' '#1075#1086#1092#1088#1086'> '#1085#1072' ' +
        #1087#1088#1086#1090#1080#1074#1086#1087#1086#1083#1086#1078#1085#1086#1077'?'
      InfoAfterExecute = #1047#1085#1072#1095#1077#1085#1080#1077' '#1080#1079#1084#1077#1085#1077#1085#1086
      Caption = 'macUpdateGoodsBox'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1047#1085#1072#1095#1077#1085#1080#1077' <'#1054#1090#1075#1088#1091#1079#1082#1072' '#1074' '#1075#1086#1092#1088#1086'> '#1044#1072'/'#1053#1077#1090
      ImageIndex = 11
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
    object actDoLoad: TExecuteImportSettingsAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ImportSettingsId.Value = '0'
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
      QuestionBeforeExecute = #1053#1072#1095#1072#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091' '#1050#1072#1090#1077#1075#1086#1088#1080#1080' '#1058#1058' '#1080#1079' '#1092#1072#1081#1083#1072' ?'
      InfoAfterExecute = #1047#1072#1075#1088#1091#1079#1082#1072' '#1076#1072#1085#1085#1099#1093' '#1074#1099#1087#1086#1083#1085#1077#1085#1072
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080#1079' '#1101#1082#1089#1077#1083#1103' '#1050#1072#1090#1077#1075#1086#1088#1080#1080' '#1058#1058
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080#1079' '#1101#1082#1089#1077#1083#1103' '#1050#1072#1090#1077#1075#1086#1088#1080#1080' '#1058#1058
      ImageIndex = 41
    end
    object actUpdate_UnitMobile: TdsdExecStoredProc
      Category = 'UnitMobile'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_UnitMobile
      StoredProcList = <
        item
          StoredProc = spUpdate_UnitMobile
        end>
      Caption = 'actUpdate_UnitMobile'
      ImageIndex = 76
    end
    object macUpdate_UnitMobile_list: TMultiAction
      Category = 'UnitMobile'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_UnitMobile
        end>
      View = cxGridDBTableView
      Caption = 'macUpdate_UnitMobile_list'
      ImageIndex = 76
    end
    object macUpdate_UnitMobile: TMultiAction
      Category = 'UnitMobile'
      MoveParams = <>
      ActionList = <
        item
          Action = macUpdate_UnitMobile_list
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1042#1089#1077#1084' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072#1084' '#1074#1099#1073#1088#1072#1085#1085#1086#1077' <'#1055#1086#1076#1088#1072#1079#1076'.('#1079#1072#1103#1074#1082#1080' '#1084#1086#1073'.)>?'
      InfoAfterExecute = #1055#1072#1088#1072#1084#1077#1090#1088' <'#1055#1086#1076#1088#1072#1079#1076'.('#1079#1072#1103#1074#1082#1080' '#1084#1086#1073'.)> '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1042#1057#1045#1052' <'#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' '#1086#1090#1075#1088#1091#1079#1082#1080' ('#1079#1072#1103#1074#1082#1080' '#1089' '#1084#1086#1073#1080#1083#1100#1085#1086#1075#1086')>'
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1042#1057#1045#1052' <'#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' '#1086#1090#1075#1088#1091#1079#1082#1080' ('#1079#1072#1103#1074#1082#1080' '#1089' '#1084#1086#1073#1080#1083#1100#1085#1086#1075#1086')>'
      ImageIndex = 76
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
  end
  object spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Partner'
    DataSet = MasterCDS
    DataSets = <
      item
        DataSet = MasterCDS
      end>
    Params = <
      item
        Name = 'inJuridicalId'
        Value = ''
        Component = JuridicalGuides
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
        Name = 'inPersonalTradeId'
        Value = Null
        Component = GuidesPersonalTrade
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRouteId'
        Value = Null
        Component = GuidesRoute
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
    Left = 104
    Top = 152
  end
  object spErasedUnErased: TdsdStoredProc
    StoredProcName = 'gpUpdateObjectIsErased'
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
    Left = 424
    Top = 216
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
    Left = 464
    Top = 288
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 424
    Top = 152
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_Partner_Params'
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
        Name = 'inRouteId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'RouteId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRouteId_30201'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'RouteId_30201'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRouteSortingId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'RouteSortingId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMemberId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MemberTakeId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PersonalId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalTradeId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PersonalTradeId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalMerchId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PersonalMerchId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'UnitId'
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
        Name = 'inPrepareDayCount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PrepareDayCount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDocumentDayCount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'DocumentDayCount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 160
    Top = 320
  end
  object JuridicalGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edJuridical
    FormNameParam.Value = 'TJuridical_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridical_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 224
    Top = 65528
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = JuridicalGuides
      end
      item
      end
      item
        Component = GuidesPersonalTrade
      end
      item
        Component = GuidesRetail
      end
      item
        Component = GuidesRoute
      end
      item
      end>
    Left = 288
    Top = 184
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'MasterJuridicalId'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterJuridicalName'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 352
    Top = 232
  end
  object spUpdateEdiOrdspr: TdsdStoredProc
    StoredProcName = 'gpUpdateObject_Partner_Edi'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = ''
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioValue'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'EdiOrdspr'
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDescCode'
        Value = 'zc_ObjectBoolean_Partner_EdiOrdspr'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 816
    Top = 160
  end
  object spUpdateEdiInvoice: TdsdStoredProc
    StoredProcName = 'gpUpdateObject_Partner_Edi'
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
        Name = 'ioValue'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'EdiInvoice'
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDescCode'
        Value = 'zc_ObjectBoolean_Partner_EdiInvoice'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 720
    Top = 200
  end
  object spUpdateEdiDesadv: TdsdStoredProc
    StoredProcName = 'gpUpdateObject_Partner_Edi'
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
        Name = 'ioValue'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'EdiDesadv'
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDescCode'
        Value = 'zc_ObjectBoolean_Partner_EdiDesadv'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 744
    Top = 264
  end
  object spCheck: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Partner_checkMap'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inJuridicalId'
        Value = Null
        Component = JuridicalGuides
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
        Name = 'inPersonalTradeId'
        Value = Null
        Component = GuidesPersonalTrade
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRouteId'
        Value = Null
        Component = GuidesRoute
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 289
    Top = 290
  end
  object GuidesRetail: TdsdGuides
    KeyField = 'Id'
    LookupControl = edRetail
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
      end>
    Left = 384
    Top = 65528
  end
  object GuidesPersonalTrade: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPersonalTrade
    FormNameParam.Value = 'TPersonal_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPersonal_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPersonalTrade
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPersonalTrade
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 607
  end
  object GuidesRoute: TdsdGuides
    KeyField = 'Id'
    LookupControl = edRoute
    FormNameParam.Value = 'TRoute_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TRoute_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesRoute
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesRoute
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterPositionId'
        Value = '149831'
        MultiSelectSeparator = ','
      end>
    Left = 863
    Top = 65528
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
        Value = 'TPartnerForm;zc_Object_ImportSetting_PartnerCategory'
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
    Left = 624
    Top = 320
  end
  object GuidesUnitMobile: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnitMobile
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnitMobile
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnitMobile
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 632
    Top = 151
  end
  object spUpdate_UnitMobile: TdsdStoredProc
    StoredProcName = 'gpUpdateObject_Partner_UnitMobile'
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
        Name = 'inUnitMobileId'
        Value = Null
        Component = GuidesUnitMobile
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 872
    Top = 264
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
    Left = 360
    Top = 336
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
    Left = 592
    Top = 224
  end
  object spUpdateGoodsBox: TdsdStoredProc
    StoredProcName = 'gpUpdateObject_Partner_Edi'
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
        Name = 'ioValue'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isGoodsBox'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDescCode'
        Value = 'zc_ObjectBoolean_Partner_GoodsBox'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 536
    Top = 344
  end
  object GuidesPersonal_update: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePersonal_update
    FormNameParam.Value = 'TPersonal_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPersonal_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPersonal_update
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPersonal_update
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 1034
    Top = 197
  end
  object spUpdatePersonal: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_Partner_PersonalParam'
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
        Name = 'inPersonalId'
        Value = ''
        Component = GuidesPersonal_update
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParam'
        Value = '1'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 864
    Top = 312
  end
  object spUpdatePersonalTrade: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_Partner_PersonalParam'
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
        Name = 'inPersonalId'
        Value = ''
        Component = GuidesPersonal_update
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParam'
        Value = '2'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 792
    Top = 336
  end
  object spUpdatePersonalMerch: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_Partner_PersonalParam'
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
        Name = 'inPersonalId'
        Value = ''
        Component = GuidesPersonal_update
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParam'
        Value = '3'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 744
    Top = 336
  end
end
