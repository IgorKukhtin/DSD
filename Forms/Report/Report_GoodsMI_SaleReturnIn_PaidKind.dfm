inherited Report_GoodsMI_SaleReturnIn_PaidKindForm: TReport_GoodsMI_SaleReturnIn_PaidKindForm
  Caption = #1054#1090#1095#1077#1090' <'#1055#1088#1086#1076#1072#1078#1072' / '#1042#1086#1079#1074#1088#1072#1090' ('#1054#1055#1080#1059')>'
  ClientHeight = 415
  ClientWidth = 1362
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.Params = FormParams
  ExplicitLeft = -468
  ExplicitWidth = 1378
  ExplicitHeight = 454
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 107
    Width = 1362
    Height = 308
    TabOrder = 3
    ExplicitTop = 107
    ExplicitWidth = 1362
    ExplicitHeight = 308
    ClientRectBottom = 308
    ClientRectRight = 1362
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1362
      ExplicitHeight = 308
      inherited cxGrid: TcxGrid
        Width = 1362
        Height = 308
        ExplicitWidth = 1362
        ExplicitHeight = 308
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Sale_Summ
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Sale_Amount_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Sale_Amount_Sh
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Return_Amount_Sh
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Return_Amount_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Return_Summ
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Sale_AmountPartner_Sh
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Sale_AmountPartner_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Return_AmountPartner_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Return_AmountPartner_Sh
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Return_SummCost
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Sale_SummCost
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Sale_Summ_10200
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Sale_Summ_10300
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Sale_Amount_10500_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Sale_Amount_40200_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Return_Amount_40200_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Sale_SummCost_10500
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Sale_SummCost_40200
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Return_SummCost_40200
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Return_Summ_10300
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Sale_Summ_10250
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Promo_Summ
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Promo_SummCost
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Promo_AmountPartner_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Promo_AmountPartner_Sh
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Return_Summ_10700
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SaleReturn_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SaleReturn_Summ
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Sale_Summ_opt
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_51201
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Sale_Summ
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Sale_Amount_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Sale_Amount_Sh
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Return_Amount_Sh
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Return_Amount_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Return_Summ
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Sale_AmountPartner_Sh
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Sale_AmountPartner_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Return_AmountPartner_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Return_AmountPartner_Sh
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Return_SummCost
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Sale_SummCost
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Sale_Summ_10200
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Sale_Summ_10300
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Sale_Amount_10500_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Sale_Amount_40200_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Return_Amount_40200_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Sale_SummCost_10500
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Sale_SummCost_40200
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Return_SummCost_40200
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Return_Summ_10300
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Sale_Summ_10250
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Promo_Summ
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Promo_SummCost
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Promo_AmountPartner_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Promo_AmountPartner_Sh
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Return_Summ_10700
            end
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = BranchName
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SaleReturn_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SaleReturn_Summ
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Sale_Summ_opt
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_51201
            end>
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object PaidKindName: TcxGridDBColumn
            Caption = #1060#1086#1088#1084#1072' '#1054#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'PaidKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object BranchName: TcxGridDBColumn
            Caption = #1060#1080#1083#1080#1072#1083
            DataBinding.FieldName = 'BranchName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 95
          end
          object AreaName: TcxGridDBColumn
            Caption = #1056#1077#1075#1080#1086#1085
            DataBinding.FieldName = 'AreaName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object RetailName: TcxGridDBColumn
            Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100
            DataBinding.FieldName = 'RetailName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object RetailReportName: TcxGridDBColumn
            Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100' ('#1087#1088#1086#1089#1088#1086#1095#1082#1072')'
            DataBinding.FieldName = 'RetailReportName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 80
          end
          object JuridicalGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1102#1088'.'#1083'.'
            DataBinding.FieldName = 'JuridicalGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object JuridicalName: TcxGridDBColumn
            Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object ContractCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object ContractNumber: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractNumber'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object ContractTagGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1087#1088#1080#1079#1085#1072#1082' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractTagGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object ContractTagName: TcxGridDBColumn
            Caption = #1055#1088#1080#1079#1085#1072#1082' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractTagName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object Address: TcxGridDBColumn
            Caption = #1040#1076#1088#1077#1089
            DataBinding.FieldName = 'Address'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object RegionName: TcxGridDBColumn
            Caption = #1054#1073#1083#1072#1089#1090#1100
            DataBinding.FieldName = 'RegionName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 80
          end
          object ProvinceName: TcxGridDBColumn
            Caption = #1056#1072#1081#1086#1085
            DataBinding.FieldName = 'ProvinceName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 80
          end
          object CityKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1085'.'#1087'.'
            DataBinding.FieldName = 'CityKindName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 35
          end
          object CityName: TcxGridDBColumn
            Caption = #1053#1072#1089#1077#1083#1077#1085#1085#1099#1081' '#1087#1091#1085#1082#1090
            DataBinding.FieldName = 'CityName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object PartnerCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072
            DataBinding.FieldName = 'PartnerCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object PartnerName: TcxGridDBColumn
            Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090
            DataBinding.FieldName = 'PartnerName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 95
          end
          object PartnerCategory: TcxGridDBColumn
            Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1058#1058
            DataBinding.FieldName = 'PartnerCategory'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '0.;-0.; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object PartnerTagName: TcxGridDBColumn
            Caption = #1055#1088#1080#1079#1085#1072#1082' '#1058#1058
            DataBinding.FieldName = 'PartnerTagName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
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
            Width = 68
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
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object GoodsGroupStatName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1089#1090#1072#1090#1080#1089#1090#1080#1082#1080
            DataBinding.FieldName = 'GoodsGroupStatName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object GoodsGroupNameFull: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072' ('#1074#1089#1077')'
            DataBinding.FieldName = 'GoodsGroupNameFull'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object GoodsGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object IsTop: TcxGridDBColumn
            Caption = #1058#1054#1055
            DataBinding.FieldName = 'IsTop'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1058#1054#1055
            Options.Editing = False
            Width = 39
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 44
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object GoodsKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 56
          end
          object MeasureName: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object SaleReturn_Weight: TcxGridDBColumn
            Caption = #1055#1088#1086#1076'. '#1073#1077#1079' '#1074#1086#1079#1074#1088'., '#1074#1077#1089' ('#1087#1086#1082#1091#1087')'
            DataBinding.FieldName = 'SaleReturn_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1086#1076#1072#1078#1080' '#1079#1072' '#1074#1099#1095#1077#1090#1086#1084' '#1074#1086#1079#1074#1088#1072#1090#1086#1074', '#1074#1077#1089
            Options.Editing = False
            Width = 70
          end
          object SaleReturn_Summ: TcxGridDBColumn
            Caption = #1055#1088#1086#1076'. '#1073#1077#1079' '#1074#1086#1079#1074#1088'., '#1075#1088#1085' ('#1087#1086#1082#1091#1087')'
            DataBinding.FieldName = 'SaleReturn_Summ'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1086#1076#1072#1078#1080' '#1079#1072' '#1074#1099#1095#1077#1090#1086#1084' '#1074#1086#1079#1074#1088#1072#1090#1086#1074', '#1075#1088#1085
            Options.Editing = False
            Width = 70
          end
          object Sale_Amount_Weight: TcxGridDBColumn
            Caption = #1055#1088#1086#1076', '#1074#1077#1089' ('#1089#1082#1083#1072#1076', '#1073#1077#1079' %'#1089#1082'.)'
            DataBinding.FieldName = 'Sale_Amount_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1041#1077#1079' '#1091#1095#1077#1090#1072' %'#1089#1082#1080#1076#1082#1080' '#1079#1072' '#1074#1077#1089
            Options.Editing = False
            Width = 70
          end
          object Sale_Amount_Sh: TcxGridDBColumn
            Caption = #1055#1088#1086#1076', '#1096#1090' ('#1089#1082#1083#1072#1076', '#1073#1077#1079' %'#1089#1082'.)'
            DataBinding.FieldName = 'Sale_Amount_Sh'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1041#1077#1079' '#1091#1095#1077#1090#1072' %'#1089#1082#1080#1076#1082#1080' '#1079#1072' '#1074#1077#1089
            Options.Editing = False
            Width = 70
          end
          object Sale_AmountPartner_Weight: TcxGridDBColumn
            Caption = #1055#1088#1086#1076', '#1074#1077#1089' ('#1087#1086#1082#1091#1087')'
            DataBinding.FieldName = 'Sale_AmountPartner_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057' '#1091#1095#1077#1090#1086#1084' %'#1089#1082#1080#1076#1082#1080' '#1079#1072' '#1074#1077#1089' '#1080' '#1088#1072#1079#1085#1080#1094#1099' '#1074' '#1074#1077#1089#1077
            Options.Editing = False
            Width = 70
          end
          object Sale_AmountPartner_Sh: TcxGridDBColumn
            Caption = #1055#1088#1086#1076', '#1096#1090' ('#1087#1086#1082#1091#1087')'
            DataBinding.FieldName = 'Sale_AmountPartner_Sh'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057' '#1091#1095#1077#1090#1086#1084' %'#1089#1082#1080#1076#1082#1080' '#1079#1072' '#1074#1077#1089' '#1080' '#1088#1072#1079#1085#1080#1094#1099' '#1074' '#1074#1077#1089#1077
            Options.Editing = False
            Width = 70
          end
          object Sale_Amount_10500_Weight: TcxGridDBColumn
            Caption = '(10500)'#1057#1082#1080#1076#1082#1072', '#1074#1077#1089' ('#1087#1088#1080' '#1087#1088#1086#1076'.)'
            DataBinding.FieldName = 'Sale_Amount_10500_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object Sale_Amount_40200_Weight: TcxGridDBColumn
            Caption = '(-)'#1055#1086#1090#1077#1088#1080' (+)'#1069#1082#1086#1085#1086#1084' '#1074#1077#1089' ('#1087#1088#1080' '#1087#1088#1086#1076'.)'
            DataBinding.FieldName = 'Sale_Amount_40200_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object Sale_Summ: TcxGridDBColumn
            Caption = #1055#1088#1086#1076', '#1075#1088#1085' ('#1087#1086#1082#1091#1087')'
            DataBinding.FieldName = 'Sale_Summ'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057' '#1091#1095#1077#1090#1086#1084' %'#1089#1082#1080#1076#1082#1080' '#1079#1072' '#1074#1077#1089' '#1080' '#1088#1072#1079#1085#1080#1094#1099' '#1074' '#1074#1077#1089#1077
            Options.Editing = False
            Width = 70
          end
          object Sale_Summ_opt: TcxGridDBColumn
            Caption = '(10100)C'#1091#1084#1084#1072' '#1087#1086' '#1086#1087#1090' '#1087#1088#1072#1081#1089#1091', '#1075#1088#1085' ('#1087#1088#1086#1076'.)'
            DataBinding.FieldName = 'Sale_Summ_opt'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = 'C'#1091#1084#1084#1072' '#1087#1086' '#1086#1087#1090' '#1087#1088#1072#1081#1089#1091', '#1075#1088#1085' ('#1087#1088#1086#1076'.)'
            Options.Editing = False
            Width = 100
          end
          object Sale_Summ_10200: TcxGridDBColumn
            Caption = '(10200)'#1056#1072#1079#1085#1080#1094#1072' '#1089' '#1086#1087#1090'. '#1075#1088#1085' ('#1087#1088#1080' '#1087#1088#1086#1076'.)'
            DataBinding.FieldName = 'Sale_Summ_10200'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '(10200)'#1056#1072#1079#1085#1080#1094#1072' '#1089' '#1086#1087#1090'. '#1075#1088#1085' ('#1087#1088#1080' '#1087#1088#1086#1076'.)'
            Options.Editing = False
            Width = 100
          end
          object Sale_Summ_10250: TcxGridDBColumn
            Caption = '(10250)'#1057#1082#1080#1076#1082#1072' '#1040#1082#1094#1080#1080', '#1075#1088#1085' ('#1087#1088#1080' '#1087#1088#1086#1076'.)'
            DataBinding.FieldName = 'Sale_Summ_10250'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '(10250)'#1057#1082#1080#1076#1082#1072' '#1040#1082#1094#1080#1080', '#1075#1088#1085' ('#1087#1088#1080' '#1087#1088#1086#1076'.)'
            Options.Editing = False
            Width = 100
          end
          object Sale_Summ_10300: TcxGridDBColumn
            Caption = '(10300)'#1057#1082#1080#1076#1082#1072', '#1075#1088#1085' ('#1087#1088#1080' '#1087#1088#1086#1076'.)'
            DataBinding.FieldName = 'Sale_Summ_10300'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object Sale_SummCost: TcxGridDBColumn
            Caption = '(10400) '#1055#1088#1086#1076' '#1089'/'#1089', '#1075#1088#1085' ('#1087#1086#1082#1091#1087')'
            DataBinding.FieldName = 'Sale_SummCost'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057' '#1091#1095#1077#1090#1086#1084' %'#1089#1082#1080#1076#1082#1080' '#1079#1072' '#1074#1077#1089' '#1080' '#1088#1072#1079#1085#1080#1094#1099' '#1074' '#1074#1077#1089#1077
            Options.Editing = False
            Width = 100
          end
          object Sale_SummCost_10500: TcxGridDBColumn
            Caption = '(10500)'#1057#1082#1080#1076#1082#1072' '#1089'/'#1089', '#1075#1088#1085' ('#1087#1088#1080' '#1087#1088#1086#1076'.)'
            DataBinding.FieldName = 'Sale_SummCost_10500'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object Sale_SummCost_40200: TcxGridDBColumn
            Caption = '(40208)(-)'#1055#1086#1090#1077#1088#1080' (+)'#1069#1082#1086#1085#1086#1084' '#1089'/'#1089', '#1075#1088#1085' ('#1087#1088#1080' '#1087#1088#1086#1076'.)'
            DataBinding.FieldName = 'Sale_SummCost_40200'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object Return_Amount_Weight: TcxGridDBColumn
            Caption = #1042#1086#1079#1074#1088', '#1074#1077#1089' ('#1089#1082#1083#1072#1076')'
            DataBinding.FieldName = 'Return_Amount_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object Return_Amount_Sh: TcxGridDBColumn
            Caption = #1042#1086#1079#1074#1088', '#1096#1090' ('#1089#1082#1083#1072#1076')'
            DataBinding.FieldName = 'Return_Amount_Sh'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object Return_AmountPartner_Weight: TcxGridDBColumn
            Caption = #1042#1086#1079#1074#1088', '#1074#1077#1089' ('#1087#1086#1082#1091#1087')'
            DataBinding.FieldName = 'Return_AmountPartner_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object Return_AmountPartner_Sh: TcxGridDBColumn
            Caption = #1042#1086#1079#1074#1088', '#1096#1090' ('#1087#1086#1082#1091#1087')'
            DataBinding.FieldName = 'Return_AmountPartner_Sh'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object Return_Amount_40200_Weight: TcxGridDBColumn
            Caption = '(-)'#1055#1086#1090#1077#1088#1080' (+)'#1069#1082#1086#1085#1086#1084' '#1074#1077#1089' ('#1087#1088#1080' '#1074#1086#1079#1074#1088'.)'
            DataBinding.FieldName = 'Return_Amount_40200_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object Return_Summ: TcxGridDBColumn
            Caption = '(10700)'#1042#1086#1079#1074#1088', '#1075#1088#1085
            DataBinding.FieldName = 'Return_Summ'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object Return_Summ_10300: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' (-)'#1089#1082#1080#1076#1082'. (+)'#1085#1072#1094#1077#1085#1082#1072'  ('#1087#1088#1080' '#1074#1086#1079#1074#1088'.)'
            DataBinding.FieldName = 'Return_Summ_10300'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object Return_Summ_10700: TcxGridDBColumn
            Caption = #1042#1086#1079#1074#1088', '#1075#1088#1085' ('#1087#1086' '#1087#1088#1072#1081#1089#1091')'
            DataBinding.FieldName = 'Return_Summ_10700'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Return_SummCost: TcxGridDBColumn
            Caption = '(10800)'#1042#1086#1079#1074#1088' '#1089'/'#1089', '#1075#1088#1085
            DataBinding.FieldName = 'Return_SummCost'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object Return_SummCost_40200: TcxGridDBColumn
            Caption = '(40208)(-)'#1055#1086#1090#1077#1088#1080' (+)'#1069#1082#1086#1085#1086#1084' '#1089'/'#1089', '#1075#1088#1085' ('#1087#1088#1080' '#1074#1086#1079#1074#1088'.)'
            DataBinding.FieldName = 'Return_SummCost_40200'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object Summ_51201: TcxGridDBColumn
            Caption = '(11101)'#1059#1089#1083#1091#1075#1080' '#1087#1086' '#1084#1072#1088#1082#1077#1090#1080#1085#1075#1091
            DataBinding.FieldName = 'Summ_51201'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '(111000)'#1059#1089#1083#1091#1075#1080' '#1087#1086' '#1084#1072#1088#1082#1077#1090#1080#1085#1075#1091
            Width = 100
          end
          object Promo_AmountPartner_Weight: TcxGridDBColumn
            Caption = #1040#1082#1094#1080#1080', '#1074#1077#1089' ('#1087#1086#1082#1091#1087')'
            DataBinding.FieldName = 'Promo_AmountPartner_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object Promo_AmountPartner_Sh: TcxGridDBColumn
            Caption = #1040#1082#1094#1080#1080', '#1096#1090' ('#1087#1086#1082#1091#1087')'
            DataBinding.FieldName = 'Promo_AmountPartner_Sh'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object Promo_SummCost: TcxGridDBColumn
            Caption = #1040#1082#1094#1080#1080'  '#1089'/'#1089', '#1075#1088#1085
            DataBinding.FieldName = 'Promo_SummCost'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object Promo_Summ: TcxGridDBColumn
            Caption = #1040#1082#1094#1080#1080', '#1075#1088#1085
            DataBinding.FieldName = 'Promo_Summ'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object BranchName_Personal: TcxGridDBColumn
            Caption = #1060#1080#1083#1080#1072#1083' ('#1089#1091#1087#1077#1088#1074#1072#1081#1079#1077#1088')'
            DataBinding.FieldName = 'BranchName_Personal'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object UnitName_Personal: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1089#1091#1087#1077#1088#1074#1072#1081#1079#1077#1088')'
            DataBinding.FieldName = 'UnitName_Personal'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object PersonalName: TcxGridDBColumn
            Caption = #1060#1048#1054' '#1089#1086#1090#1088#1091#1076#1085#1080#1082' ('#1089#1091#1087#1077#1088#1074#1072#1081#1079#1077#1088')'
            DataBinding.FieldName = 'PersonalName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 110
          end
          object UnitName_PersonalTrade: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1058#1055')'
            DataBinding.FieldName = 'UnitName_PersonalTrade'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object PersonalTradeName: TcxGridDBColumn
            Caption = #1060#1048#1054' '#1089#1086#1090#1088#1091#1076#1085#1080#1082' ('#1058#1055')'
            DataBinding.FieldName = 'PersonalTradeName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 110
          end
          object InfoMoneyCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1059#1055
            DataBinding.FieldName = 'InfoMoneyCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
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
            Width = 80
          end
          object InfoMoneyName: TcxGridDBColumn
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
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
          object ReturnPercent: TcxGridDBColumn
            Caption = '% '#1074#1086#1079#1074#1088#1072#1090#1072
            DataBinding.FieldName = 'ReturnPercent'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object PartnerId: TcxGridDBColumn
            Caption = #1050#1083#1102#1095'-2'
            DataBinding.FieldName = 'PartnerId'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Enabled = False
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 45
          end
          object Sale_SummReal: TcxGridDBColumn
            DataBinding.FieldName = 'Sale_SummReal'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            VisibleForCustomization = False
            Width = 55
          end
          object Sale_AmountPartnerR_Weight: TcxGridDBColumn
            DataBinding.FieldName = 'Sale_AmountPartnerR_Weight'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            VisibleForCustomization = False
            Width = 55
          end
          object Sale_AmountPartnerR_Sh: TcxGridDBColumn
            DataBinding.FieldName = 'Sale_AmountPartnerR_Sh'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            VisibleForCustomization = False
            Width = 55
          end
          object Sale_SummMVAT: TcxGridDBColumn
            Caption = #1055#1088#1086#1076' '#1089#1091#1084#1084#1072' '#1073#1077#1079' '#1053#1044#1057', '#1075#1088#1085' ('#1087#1086#1082#1091#1087')'
            DataBinding.FieldName = 'Sale_SummMVAT'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1077#1079' '#1053#1044#1057', '#1075#1088#1085
            Options.Editing = False
            VisibleForCustomization = False
            Width = 82
          end
          object Sale_SummVAT: TcxGridDBColumn
            Caption = #1055#1088#1086#1076' '#1089#1091#1084#1084#1072' '#1053#1044#1057', '#1075#1088#1085' ('#1087#1086#1082#1091#1087')'
            DataBinding.FieldName = 'Sale_SummVAT'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1053#1044#1057
            Options.Editing = False
            VisibleForCustomization = False
            Width = 70
          end
          object Return_SummMVAT: TcxGridDBColumn
            Caption = #1042#1086#1079#1074#1088' '#1089#1091#1084#1084#1072' '#1073#1077#1079' '#1053#1044#1057', '#1075#1088#1085
            DataBinding.FieldName = 'Return_SummMVAT'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1089#1091#1084#1084#1072' '#1074#1086#1079#1074#1088#1072#1090#1072' '#1073#1077#1079' '#1053#1044#1057
            Options.Editing = False
            VisibleForCustomization = False
            Width = 70
          end
          object Return_SummVAT: TcxGridDBColumn
            Caption = #1042#1086#1079#1074#1088' '#1089#1091#1084#1084#1072' '#1053#1044#1057', '#1075#1088#1085
            DataBinding.FieldName = 'Return_SummVAT'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1089#1091#1084#1084#1072' '#1053#1044#1057' '#1074#1086#1079#1074#1088#1072#1090#1072
            Options.Editing = False
            VisibleForCustomization = False
            Width = 70
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1362
    Height = 81
    ExplicitWidth = 1362
    ExplicitHeight = 81
    inherited deStart: TcxDateEdit
      Left = 60
      EditValue = 44197d
      Properties.SaveTime = False
      ExplicitLeft = 60
    end
    inherited deEnd: TcxDateEdit
      Left = 60
      Top = 30
      EditValue = 44197d
      Properties.SaveTime = False
      ExplicitLeft = 60
      ExplicitTop = 30
    end
    inherited cxLabel1: TcxLabel
      Left = 15
      Caption = #1044#1072#1090#1072' '#1089' :'
      ExplicitLeft = 15
      ExplicitWidth = 45
    end
    inherited cxLabel2: TcxLabel
      Left = 8
      Top = 31
      Caption = #1044#1072#1090#1072' '#1087#1086' :'
      ExplicitLeft = 8
      ExplicitTop = 31
      ExplicitWidth = 52
    end
    object cxLabel4: TcxLabel
      Left = 1050
      Top = 6
      Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1086#1074':'
    end
    object edGoodsGroup: TcxButtonEdit
      Left = 1050
      Top = 30
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 170
    end
    object cxLabel3: TcxLabel
      Left = 625
      Top = 6
      Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086':'
    end
    object edJuridical: TcxButtonEdit
      Left = 625
      Top = 30
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 180
    end
    object cxLabel5: TcxLabel
      Left = 820
      Top = 6
      Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099':'
    end
    object edPaidKind: TcxButtonEdit
      Left = 820
      Top = 30
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 9
      Width = 80
    end
    object cxLabel7: TcxLabel
      Left = 1235
      Top = 7
      Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103':'
    end
    object edInfoMoney: TcxButtonEdit
      Left = 1235
      Top = 30
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 11
      Width = 200
    end
    object edBranch: TcxButtonEdit
      Left = 160
      Top = 30
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 12
      Width = 140
    end
    object cxLabel8: TcxLabel
      Left = 160
      Top = 6
      Caption = #1060#1080#1083#1080#1072#1083':'
    end
    object edArea: TcxButtonEdit
      Left = 315
      Top = 30
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 14
      Width = 140
    end
    object cxLabel20: TcxLabel
      Left = 315
      Top = 6
      Caption = #1056#1077#1075#1080#1086#1085':'
    end
    object edRetail: TcxButtonEdit
      Left = 470
      Top = 30
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 16
      Width = 140
    end
    object cxLabel6: TcxLabel
      Left = 470
      Top = 6
      Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100':'
    end
    object cxLabel9: TcxLabel
      Left = 915
      Top = 6
      Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072
    end
    object еdTradeMark: TcxButtonEdit
      Left = 915
      Top = 30
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 19
      Width = 120
    end
    object cxLabel10: TcxLabel
      Left = 8
      Top = 58
      Hint = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1082#1086#1075#1076#1072' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1083#1080#1089#1100' '#1076#1072#1085#1085#1099#1077' '#1076#1083#1103' '#1055#1088#1086#1076#1072#1078#1072'/'#1074#1086#1079#1074#1088#1072#1090
      Caption = '!'#1074#1072#1078#1085#1086'! '#1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1072#1082#1090#1091#1072#1083#1100#1085#1086#1089#1090#1080' '#1076#1072#1085#1085#1099#1093' '#1076#1083#1103' '#1086#1090#1095#1077#1090#1072' :'
      ParentShowHint = False
      ShowHint = True
    end
    object edProtocolDateOlapSR: TcxDateEdit
      Left = 306
      Top = 57
      EditValue = 42370d
      Enabled = False
      Properties.DisplayFormat = 'dd.mm.yyyy hh:mm'
      Properties.Kind = ckDateTime
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 21
      Width = 140
    end
    object cxLabel11: TcxLabel
      Left = 452
      Top = 58
      Hint = 
        #1055#1086' '#1082#1072#1082#1091#1102' '#1076#1072#1090#1091' '#1074#1082#1083#1102#1095#1080#1090#1077#1083#1100#1085#1086' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1099' '#1076#1072#1085#1085#1099#1077' '#1076#1083#1103' '#1055#1088#1086#1076#1072#1078#1072'/'#1074#1086#1079#1074#1088 +
        #1072#1090
      Caption = #1040#1082#1090#1091#1072#1083#1100#1085#1099#1077' '#1076#1072#1085#1085#1099#1077' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1099' '#1087#1086':'
      ParentShowHint = False
      ShowHint = True
    end
    object edEndDateOlapSR: TcxDateEdit
      Left = 661
      Top = 57
      EditValue = 42370d
      Enabled = False
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 23
      Width = 85
    end
    object cxLabel12: TcxLabel
      Left = 755
      Top = 58
      Hint = 
        #1040#1082#1090#1091#1072#1083#1080#1079#1072#1094#1080#1103' '#1076#1072#1085#1085#1099#1093' '#1087#1088#1086#1080#1089#1093#1086#1076#1080#1090' 1 '#1088#1072#1079' '#1074' '#1089#1091#1090#1082#1080', '#1087#1086#1089#1083#1077' '#1095#1077#1075#1086' '#1073#1099#1089#1090#1088#1077#1077 +
        ' '#1087#1088#1086#1080#1089#1093#1086#1076#1080#1090' '#1086#1090#1082#1088#1099#1090#1080#1077' '#1086#1090#1095#1077#1090#1072
      Caption = 
        #1048#1079#1084#1077#1085#1077#1085#1080#1103' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084'/'#1074#1086#1079#1074#1088#1072#1090#1072#1084', '#1074#1099#1087#1086#1083#1085#1077#1085#1085#1099#1077' '#1087#1086#1089#1083#1077' '#1072#1082#1090#1091#1072#1083#1080#1079#1072#1094#1080#1080' ' +
        #1076#1072#1085#1085#1099#1093', '#1074' '#1086#1090#1095#1077#1090' '#1085#1077' '#1087#1086#1087#1072#1076#1072#1102#1090
      ParentShowHint = False
      ShowHint = True
    end
    object cbPaidKind: TcxCheckBox
      Left = 694
      Top = 87
      Caption = #1087#1086#1082#1072#1079#1072#1090#1100' '#1060#1054
      Properties.ReadOnly = False
      TabOrder = 25
      Width = 91
    end
  end
  object cbPartner: TcxCheckBox [2]
    Left = 212
    Top = 87
    Caption = #1087#1086' '#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072#1084
    Properties.ReadOnly = False
    TabOrder = 6
    Width = 118
  end
  object cbGoods: TcxCheckBox [3]
    Left = 487
    Top = 87
    Caption = #1087#1086' '#1058#1086#1074#1072#1088#1072#1084
    Properties.ReadOnly = False
    TabOrder = 7
    Width = 88
  end
  object cbTradeMark: TcxCheckBox [4]
    Left = 336
    Top = 87
    Caption = #1087#1086' '#1058#1086#1088#1075#1086#1074#1099#1084' '#1084#1072#1088#1082#1072#1084
    Properties.ReadOnly = False
    TabOrder = 8
    Width = 137
  end
  object cbGoodsKind: TcxCheckBox [5]
    Left = 581
    Top = 87
    Caption = #1087#1086' '#1042#1080#1076#1072#1084' '#1090#1086#1074#1072#1088#1072
    Properties.ReadOnly = False
    TabOrder = 9
    Width = 113
  end
  object cbContract: TcxCheckBox [6]
    Left = 104
    Top = 87
    Caption = #1087#1086' '#1044#1086#1075#1086#1074#1086#1088#1072#1084
    Properties.ReadOnly = False
    TabOrder = 10
    Width = 102
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = cbContract
        Properties.Strings = (
          'Checked')
      end
      item
        Component = cbGoods
        Properties.Strings = (
          'Checked')
      end
      item
        Component = cbGoodsKind
        Properties.Strings = (
          'Checked')
      end
      item
        Component = cbPartner
        Properties.Strings = (
          'Checked')
      end
      item
        Component = cbTradeMark
        Properties.Strings = (
          'Checked')
      end
      item
        Component = deEnd
        Properties.Strings = (
          'Date')
      end
      item
        Component = deStart
        Properties.Strings = (
          'Date')
      end
      item
        Component = GuidesArea
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesBranch
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesGoodsGroup
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesInfoMoney
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesJuridical
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesPaidKind
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesRetail
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesTradeMark
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = cbPaidKind
        Properties.Strings = (
          'Checked')
      end>
  end
  inherited ActionList: TActionList
    Left = 87
    inherited actRefresh: TdsdDataSetRefresh
      MoveParams = <
        item
          FromParam.Name = 'isOLAP'
          FromParam.Value = True
          FromParam.DataType = ftBoolean
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'isOLAP'
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'isOLAP'
          ToParam.DataType = ftBoolean
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProc = spGetGlobalConst_DateOlapSR
      StoredProcList = <
        item
          StoredProc = spGetGlobalConst_DateOlapSR
        end
        item
          StoredProc = spSelect
        end>
      ShortCut = 0
    end
    inherited actGridToExcel: TdsdGridToExcel
      ExportType = cxegExportToXlsx
    end
    object actPrint_byPartner: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1055#1088#1086#1076#1072#1078#1072' '#1080' '#1074#1086#1079#1074#1088#1072#1090' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1099
      Hint = #1055#1088#1086#1076#1072#1078#1072' '#1080' '#1074#1086#1079#1074#1088#1072#1090' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1099
      ImageIndex = 21
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'juridicalname;partnername;GoodsGroupName;GoodsName'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1088#1086#1076#1072#1078#1072' '#1080' '#1074#1086#1079#1074#1088#1072#1090' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1099
      ReportNameParam.Value = #1055#1088#1086#1076#1072#1078#1072' '#1080' '#1074#1086#1079#1074#1088#1072#1090' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1099
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint_byJuridical: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1102#1088'.'#1083#1080#1094#1072#1084' ('#1080#1090#1086#1075#1080')'
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1102#1088'.'#1083#1080#1094#1072#1084' ('#1080#1090#1086#1075#1080')'
      ImageIndex = 19
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'juridicalname;partnername'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1088#1086#1076#1072#1078#1072' '#1080' '#1074#1086#1079#1074#1088#1072#1090' '#1087#1086' '#1102#1088#1083#1080#1094#1072#1084
      ReportNameParam.Value = #1055#1088#1086#1076#1072#1078#1072' '#1080' '#1074#1086#1079#1074#1088#1072#1090' '#1087#1086' '#1102#1088#1083#1080#1094#1072#1084
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1090#1086#1074#1072#1088#1072#1084' ('#1080#1090#1086#1075#1080')'
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1090#1086#1074#1072#1088#1072#1084' ('#1080#1090#1086#1075#1080')'
      ImageIndex = 18
      ShortCut = 16464
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GoodsGroupName;GoodsName'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1088#1086#1076#1072#1078#1072' '#1080' '#1074#1086#1079#1074#1088#1072#1090
      ReportNameParam.Value = #1055#1088#1086#1076#1072#1078#1072' '#1080' '#1074#1086#1079#1074#1088#1072#1090
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint_byStatGroup: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1075#1088#1091#1087#1087#1077' '#1073#1091#1093#1075'. '#1089#1090#1072#1090#1080#1089#1090#1080#1082#1080
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1075#1088#1091#1087#1087#1077' '#1073#1091#1093#1075'. '#1089#1090#1072#1090#1080#1089#1090#1080#1082#1080
      ImageIndex = 20
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GoodsGroupStatName;GoodsName'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'isBuh'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1087#1086' '#1075#1088#1091#1087#1087#1077' '#1089#1090#1072#1090#1080#1089#1090#1080#1082#1080
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1087#1086' '#1075#1088#1091#1087#1087#1077' '#1089#1090#1072#1090#1080#1089#1090#1080#1082#1080
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_GoodsMI_SaleReturnIn_PaidKindDialogForm'
      FormNameParam.Value = 'TReport_GoodsMI_SaleReturnIn_PaidKindDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 42005d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42005d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'BranchId'
          Value = ''
          Component = GuidesBranch
          ComponentItem = 'Key'
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'BranchName'
          Value = ''
          Component = GuidesBranch
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PaidKindId'
          Value = ''
          Component = GuidesPaidKind
          ComponentItem = 'Key'
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PaidKindName'
          Value = ''
          Component = GuidesPaidKind
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'AreaId'
          Value = ''
          Component = GuidesArea
          ComponentItem = 'Key'
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'AreaName'
          Value = ''
          Component = GuidesArea
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'RetailId'
          Value = ''
          Component = GuidesRetail
          ComponentItem = 'Key'
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'RetailName'
          Value = ''
          Component = GuidesRetail
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalId'
          Value = Null
          Component = GuidesJuridical
          ComponentItem = 'Key'
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName'
          Value = Null
          Component = GuidesJuridical
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyId'
          Value = Null
          Component = GuidesInfoMoney
          ComponentItem = 'Key'
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyName'
          Value = Null
          Component = GuidesInfoMoney
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupId'
          Value = Null
          Component = GuidesGoodsGroup
          ComponentItem = 'Key'
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = Null
          Component = GuidesGoodsGroup
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TradeMarkId'
          Value = Null
          Component = GuidesTradeMark
          ComponentItem = 'Key'
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TradeMarkName'
          Value = Null
          Component = GuidesTradeMark
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPartner'
          Value = Null
          Component = cbPartner
          DataType = ftBoolean
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isTradeMark'
          Value = Null
          Component = cbTradeMark
          DataType = ftBoolean
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isGoods'
          Value = Null
          Component = cbGoods
          DataType = ftBoolean
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isGoodsKind'
          Value = Null
          Component = cbGoodsKind
          DataType = ftBoolean
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPaidKind'
          Value = Null
          Component = cbPaidKind
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actRefreshReal: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'isOLAP'
          FromParam.Value = False
          FromParam.DataType = ftBoolean
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'isOLAP'
          ToParam.DataType = ftBoolean
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' - '#1076#1072#1085#1085#1099#1077' '#1085#1072' '#1089#1077#1081#1095#1072#1089' ('#1086#1085'-'#1083#1072#1081#1085', '#1074#1099#1087#1086#1083#1085#1103#1077#1090#1089#1103' '#1076#1086#1083#1075#1086')'
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' - '#1076#1072#1085#1085#1099#1077' '#1085#1072' '#1089#1077#1081#1095#1072#1089' ('#1086#1085'-'#1083#1072#1081#1085', '#1074#1099#1087#1086#1083#1085#1103#1077#1090#1089#1103' '#1076#1086#1083#1075#1086')'
      ImageIndex = 41
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
  end
  inherited MasterDS: TDataSource
    Left = 112
    Top = 216
  end
  inherited MasterCDS: TClientDataSet
    Left = 40
    Top = 208
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_GoodsMI_SaleReturnIn_PaidKind'
    DataSets = <
      item
        DataSet = MasterCDS
      end
      item
      end
      item
      end>
    Params = <
      item
        Name = 'inStartDate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 41640d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBranchId'
        Value = Null
        Component = GuidesBranch
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAreaId'
        Value = Null
        Component = GuidesArea
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
        Name = 'inJuridicalId'
        Value = '0'
        Component = GuidesJuridical
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPaidKindId'
        Value = ''
        Component = GuidesPaidKind
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTradeMarkId'
        Value = Null
        Component = GuidesTradeMark
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsGroupId'
        Value = ''
        Component = GuidesGoodsGroup
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInfoMoneyId'
        Value = ''
        Component = GuidesInfoMoney
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsPartner'
        Value = Null
        Component = cbPartner
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsTradeMark'
        Value = Null
        Component = cbTradeMark
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsGoods'
        Value = Null
        Component = cbGoods
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsGoodsKind'
        Value = Null
        Component = cbGoodsKind
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisContract'
        Value = Null
        Component = cbContract
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsOLAP'
        Value = Null
        Component = FormParams
        ComponentItem = 'isOLAP'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPaidKind'
        Value = Null
        Component = cbPaidKind
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    AutoWidth = True
    Left = 176
    Top = 200
  end
  inherited BarManager: TdxBarManager
    Left = 224
    Top = 200
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
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
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbContract'
        end
        item
          Visible = True
          ItemName = 'bbPartner'
        end
        item
          Visible = True
          ItemName = 'bbTradeMark'
        end
        item
          Visible = True
          ItemName = 'bbGoods'
        end
        item
          Visible = True
          ItemName = 'bbGoodsKind'
        end
        item
          Visible = True
          ItemName = 'bbPaidKind'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrint'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrint_byJuridical'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrint_byStatGroup'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrint_byPartner'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbRefreshReal'
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
    end
    object bbPrint: TdxBarButton
      Action = actPrint
      Category = 0
    end
    object bbPrint_byJuridical: TdxBarButton
      Action = actPrint_byJuridical
      Category = 0
    end
    object bbPrint_byStatGroup: TdxBarButton
      Action = actPrint_byStatGroup
      Category = 0
    end
    object bbPartner: TdxBarControlContainerItem
      Caption = #1087#1086' '#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072#1084
      Category = 0
      Hint = #1087#1086' '#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072#1084
      Visible = ivAlways
      Control = cbPartner
    end
    object bbGoods: TdxBarControlContainerItem
      Caption = #1087#1086' '#1058#1086#1074#1072#1088#1072#1084
      Category = 0
      Hint = #1087#1086' '#1058#1086#1074#1072#1088#1072#1084
      Visible = ivAlways
      Control = cbGoods
    end
    object bbPrint_byPartner: TdxBarButton
      Action = actPrint_byPartner
      Category = 0
    end
    object bbTradeMark: TdxBarControlContainerItem
      Caption = #1087#1086' '#1058#1086#1088#1075#1086#1074#1099#1084' '#1084#1072#1088#1082#1072#1084
      Category = 0
      Hint = #1087#1086' '#1058#1086#1088#1075#1086#1074#1099#1084' '#1084#1072#1088#1082#1072#1084
      Visible = ivAlways
      Control = cbTradeMark
    end
    object bbGoodsKind: TdxBarControlContainerItem
      Caption = #1087#1086' '#1042#1080#1076#1072#1084
      Category = 0
      Hint = #1087#1086' '#1042#1080#1076#1072#1084
      Visible = ivAlways
      Control = cbGoodsKind
    end
    object bbContract: TdxBarControlContainerItem
      Caption = #1087#1086' '#1044#1086#1075#1086#1074#1086#1088#1072#1084
      Category = 0
      Hint = #1087#1086' '#1044#1086#1075#1086#1074#1086#1088#1072#1084
      Visible = ivAlways
      Control = cbContract
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbRefreshReal: TdxBarButton
      Action = actRefreshReal
      Category = 0
    end
    object bbPaidKind: TdxBarControlContainerItem
      Caption = #1087#1086#1082#1072#1079#1072#1090#1100' '#1060#1054
      Category = 0
      Hint = #1087#1086#1082#1072#1079#1072#1090#1100' '#1060#1054
      Visible = ivAlways
      Control = cbPaidKind
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 320
    Top = 232
  end
  inherited PopupMenu: TPopupMenu
    Left = 144
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 104
    Top = 192
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ShowDialogAction = ExecuteDialog
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = GuidesBranch
      end
      item
        Component = GuidesArea
      end
      item
        Component = GuidesRetail
      end
      item
        Component = GuidesJuridical
      end
      item
        Component = GuidesPaidKind
      end
      item
        Component = GuidesTradeMark
      end
      item
        Component = GuidesGoodsGroup
      end
      item
        Component = GuidesInfoMoney
      end>
    Left = 192
    Top = 240
  end
  object GuidesGoodsGroup: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoodsGroup
    FormNameParam.Value = 'TGoodsGroup_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsGroup_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGoodsGroup
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGoodsGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 1144
    Top = 8
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'isOLAP'
        Value = Null
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    Left = 312
    Top = 194
  end
  object GuidesJuridical: TdsdGuides
    KeyField = 'Id'
    LookupControl = edJuridical
    Key = '0'
    FormNameParam.Name = 'TJuridical_ObjectForm'
    FormNameParam.Value = 'TJuridical_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridical_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GuidesJuridical
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 728
    Top = 8
  end
  object GuidesInfoMoney: TdsdGuides
    KeyField = 'Id'
    LookupControl = edInfoMoney
    FormNameParam.Value = 'TInfoMoney_ObjectDescForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TInfoMoney_ObjectDescForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesInfoMoney
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesInfoMoney
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDescCode'
        Value = 'zc_Enum_InfoMoneyGroup_30000'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 1368
    Top = 65533
  end
  object GuidesPaidKind: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPaidKind
    FormNameParam.Value = 'TPaidKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPaidKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPaidKind
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPaidKind
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 840
  end
  object GuidesBranch: TdsdGuides
    KeyField = 'Id'
    LookupControl = edBranch
    FormNameParam.Value = 'TBranch_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBranch_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesBranch
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesBranch
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 216
  end
  object GuidesArea: TdsdGuides
    KeyField = 'Id'
    LookupControl = edArea
    FormNameParam.Value = 'TAreaForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TAreaForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesArea
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesArea
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 384
    Top = 5
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
      end>
    Left = 544
    Top = 13
  end
  object GuidesTradeMark: TdsdGuides
    KeyField = 'Id'
    LookupControl = еdTradeMark
    FormNameParam.Value = 'TTradeMarkForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TTradeMarkForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesTradeMark
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesTradeMark
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 784
    Top = 10
  end
  object spGetGlobalConst_DateOlapSR: TdsdStoredProc
    StoredProcName = 'gpGet_Object_GlobalConst_DateOlapSR'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ProtocolDateOlapSR'
        Value = Null
        Component = edProtocolDateOlapSR
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndDateOlapSR'
        Value = Null
        Component = edEndDateOlapSR
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 480
    Top = 232
  end
end
