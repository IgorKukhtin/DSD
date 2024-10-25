inherited Report_GoodsMI_OrderExternal_SaleForm: TReport_GoodsMI_OrderExternal_SaleForm
  Caption = #1054#1090#1095#1077#1090' <'#1047#1072#1103#1074#1082#1072' / '#1055#1088#1086#1076#1072#1078#1072' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103#1084'>'
  ClientHeight = 377
  ClientWidth = 1142
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.Params = FormParams
  ExplicitWidth = 1158
  ExplicitHeight = 416
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 91
    Width = 1142
    Height = 286
    TabOrder = 3
    ExplicitTop = 91
    ExplicitWidth = 1092
    ExplicitHeight = 286
    ClientRectBottom = 286
    ClientRectRight = 1142
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1092
      ExplicitHeight = 286
      inherited cxGrid: TcxGrid
        Width = 1142
        Height = 286
        ExplicitWidth = 1092
        ExplicitHeight = 286
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.##'
              Kind = skSum
              Column = AmountSumm1
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = Amount_Weight1
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = Amount_Sh1
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = AmountSummTotal
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = AmountSumm2
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = Amount_Sh2
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = Amount_Weight2
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = Amount_Weight_Itog
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = Amount_Sh_Itog
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = Amount_Weight_Dozakaz
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = Amount_Sh_Dozakaz
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = AmountSumm_Dozakaz
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = Amount_Order
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = Amount_WeightSK
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = AmountSale_Weight
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = AmountSale_Sh
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = SumSale
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = AmountSalePartner_Weight
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = AmountSalePartner_Sh
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountDiff_B
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountDiff_M
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = WeightDiff_B
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = WeightDiff_M
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountPrint_M
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalCount_Diff
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalWeight_Diff
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalAmountTax
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalWeightTax
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSale_Weight_M
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_Weight_M
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_Weight_Dozakaz_M
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalAmountWeight_child
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountWeight_child_one
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountWeight_child_sec
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountWeight_diff
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountWeight_diff_fact
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSh_child_one
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSh_child_sec
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSh_diff
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSh_diff_fact
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalAmountSh_child
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountBox
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.##'
              Kind = skSum
              Column = AmountSumm1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_Weight1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_Sh1
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = AmountSummTotal
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = AmountSumm2
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_Sh2
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_Weight2
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_Weight_Itog
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_Sh_Itog
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_Weight_Dozakaz
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_Sh_Dozakaz
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = AmountSumm_Dozakaz
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = Amount_Order
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = Amount_WeightSK
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = AmountSale_Weight
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = AmountSale_Sh
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = SumSale
            end
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = FromName
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = AmountSalePartner_Weight
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = AmountSalePartner_Sh
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountDiff_B
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountDiff_M
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = WeightDiff_B
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = WeightDiff_M
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountPrint_M
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalCount_Diff
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalWeight_Diff
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalAmountTax
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalWeightTax
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSale_Weight_M
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_Weight_M
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_Weight_Dozakaz_M
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalAmountWeight_child
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountWeight_child_one
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountWeight_child_sec
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountWeight_diff
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountWeight_diff_fact
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSh_child_one
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSh_child_sec
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSh_diff
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSh_diff_fact
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalAmountSh_child
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountBox
            end>
          OptionsData.Editing = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object OperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' ('#1079#1072#1103#1074#1082#1072')'
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 57
          end
          object DayOfWeekName: TcxGridDBColumn
            Caption = #1044#1077#1085#1100' '#1079#1072#1103#1074#1082#1080
            DataBinding.FieldName = 'DayOfWeekName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Alignment.Horz = taCenter
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1077#1085#1100' '#1085#1077#1076#1077#1083#1080' '#1076#1083#1103' '#1044#1072#1090#1072' '#1079#1072#1103#1074#1082#1080
            Options.Editing = False
            Width = 70
          end
          object OperDatePartner: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1089#1082#1083#1072#1076' ('#1079#1072#1103#1074#1082#1072')'
            DataBinding.FieldName = 'OperDatePartner'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          object DayOfWeekName_Partner: TcxGridDBColumn
            Caption = '***'#1044#1077#1085#1100' '#1086#1090#1075#1088#1091#1079#1082#1080
            DataBinding.FieldName = 'DayOfWeekName_Partner'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Alignment.Horz = taCenter
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1077#1085#1100' '#1085#1077#1076#1077#1083#1080' '#1076#1083#1103' '#1044#1072#1090#1072' '#1089#1082#1083#1072#1076' ('#1079#1072#1103#1074#1082#1072')'
            Options.Editing = False
            Width = 70
          end
          object OperDate_CarInfo: TcxGridDBColumn
            Caption = #1044#1072#1090#1072'/'#1074#1088' '#1086#1090#1075#1088#1091#1079#1082#1080
            DataBinding.FieldName = 'OperDate_CarInfo'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object DayOfWeekName_CarInfo: TcxGridDBColumn
            Caption = #1044#1077#1085#1100' '#1086#1090#1075#1088#1091#1079#1082#1080
            DataBinding.FieldName = 'DayOfWeekName_CarInfo'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Alignment.Horz = taCenter
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1077#1085#1100' '#1085#1077#1076#1077#1083#1080' '#1076#1083#1103' '#1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1086#1090#1075#1088#1091#1079#1082#1080' '#1092#1072#1082#1090
            Options.Editing = False
            Width = 70
          end
          object OperDate_CarInfo_date: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1086#1090#1075#1088#1091#1079#1082#1080' ('#1089#1084#1077#1085#1072')'
            DataBinding.FieldName = 'OperDate_CarInfo_date'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object DayOfWeekName_CarInfo_date: TcxGridDBColumn
            Caption = #1044#1077#1085#1100' '#1086#1090#1075#1088#1091#1079#1082#1080' ('#1089#1084#1077#1085#1072')'
            DataBinding.FieldName = 'DayOfWeekName_CarInfo_date'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1077#1085#1100' '#1085#1077#1076#1077#1083#1080' '#1076#1083#1103' '#1044#1072#1090#1072' '#1086#1090#1075#1088#1091#1079#1082#1080' '#1092#1072#1082#1090' '#1076#1083#1103' '#1088#1072#1073#1086#1095#1072#1103' '#1089#1084#1077#1085#1072
            Options.Editing = False
            Width = 80
          end
          object InvNumberOrderPartner: TcxGridDBColumn
            Caption = #8470' '#1079#1072#1082#1072#1079#1072' ('#1087#1086#1082'.'#1089#1077#1090#1080')'
            DataBinding.FieldName = 'InvNumberOrderPartner'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 72
          end
          object InvNumber_Order: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082' ('#1079#1072#1103#1074#1082#1072')'
            DataBinding.FieldName = 'InvNumber_Order'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object OperDate_Sale: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1089#1082#1083#1072#1076' ('#1087#1088#1086#1076'.)'
            DataBinding.FieldName = 'OperDate_Sale'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object OperDatePartner_Sale: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086#1082'. '#1091' '#1087#1086#1082#1091#1087'. ('#1087#1088#1086#1076'.)'
            DataBinding.FieldName = 'OperDatePartner_Sale'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object InvNumber: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. ('#1087#1088#1086#1076'.)'
            DataBinding.FieldName = 'InvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object RouteName: TcxGridDBColumn
            Caption = #1052#1072#1088#1096#1088#1091#1090
            DataBinding.FieldName = 'RouteName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object RetailName: TcxGridDBColumn
            Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100
            DataBinding.FieldName = 'RetailName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object RouteSortingName: TcxGridDBColumn
            Caption = #1057#1086#1088#1090#1080#1088#1086#1074#1082#1072' '#1084#1072#1088#1096#1088#1091#1090#1072
            DataBinding.FieldName = 'RouteSortingName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            VisibleForCustomization = False
            Width = 100
          end
          object FromDescName: TcxGridDBColumn
            Caption = #1069#1083#1077#1084#1077#1085#1090' ('#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090')'
            DataBinding.FieldName = 'FromDescName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 86
          end
          object FromCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1082'.'
            DataBinding.FieldName = 'FromCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 44
          end
          object FromName: TcxGridDBColumn
            Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090
            DataBinding.FieldName = 'FromName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object PaidKindName: TcxGridDBColumn
            Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'PaidKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object GoodsGroupNameFull: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072' ('#1074#1089#1077')'
            DataBinding.FieldName = 'GoodsGroupNameFull'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object GoodsGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 44
          end
          object MeasureName: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 45
          end
          object Article: TcxGridDBColumn
            Caption = #1040#1088#1090#1080#1082#1091#1083
            DataBinding.FieldName = 'Article'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 49
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 150
          end
          object GoodsKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object Amount_WeightSK: TcxGridDBColumn
            Caption = #1047#1072#1082#1072#1079' '#1057'/'#1050', '#1074#1077#1089' '
            DataBinding.FieldName = 'Amount_WeightSK'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Amount_Weight_Itog: TcxGridDBColumn
            Caption = #1047#1072#1082#1072#1079' 1 +2 + '#1076#1086#1079#1072#1082#1072#1079' , '#1082#1075
            DataBinding.FieldName = 'Amount_Weight_Itog'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object AmountSale_Weight: TcxGridDBColumn
            Caption = #1054#1090#1075#1088#1091#1079#1082#1072', '#1074#1077#1089' ('#1089#1082#1083#1072#1076')'
            DataBinding.FieldName = 'AmountSale_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object AmountSalePartner_Weight: TcxGridDBColumn
            Caption = #1054#1090#1075#1088#1091#1079#1082#1072', '#1074#1077#1089' ('#1087#1086#1082#1091#1087'.)'
            DataBinding.FieldName = 'AmountSalePartner_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object Amount_Weight1: TcxGridDBColumn
            Caption = #1047#1072#1082'1, '#1082#1075' '
            DataBinding.FieldName = 'Amount_Weight1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Amount_Weight2: TcxGridDBColumn
            Caption = #1047#1072#1082'2, '#1082#1075' '
            DataBinding.FieldName = 'Amount_Weight2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Amount_Weight_Dozakaz: TcxGridDBColumn
            Caption = #1044#1086#1079#1072#1082#1072#1079', '#1074#1077#1089
            DataBinding.FieldName = 'Amount_Weight_Dozakaz'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Amount_Sh1: TcxGridDBColumn
            Caption = #1047#1072#1082'1, '#1096#1090' '
            DataBinding.FieldName = 'Amount_Sh1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Amount_Sh2: TcxGridDBColumn
            Caption = #1047#1072#1082'2, '#1096#1090' '
            DataBinding.FieldName = 'Amount_Sh2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Amount_Sh_Dozakaz: TcxGridDBColumn
            Caption = #1044#1086#1079#1072#1082#1072#1079', '#1096#1090
            DataBinding.FieldName = 'Amount_Sh_Dozakaz'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          object Amount_Sh_Itog: TcxGridDBColumn
            Caption = #1047#1072#1082#1072#1079' 1 +2 + '#1076#1086#1079#1072#1082#1072#1079', '#1096#1090
            DataBinding.FieldName = 'Amount_Sh_Itog'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          object AmountSale_Sh: TcxGridDBColumn
            Caption = #1054#1090#1075#1088#1091#1079#1082#1072' '#1080#1090#1086#1075', '#1096#1090' ('#1089#1082#1083#1072#1076')'
            DataBinding.FieldName = 'AmountSale_Sh'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object AmountSalePartner_Sh: TcxGridDBColumn
            Caption = #1054#1090#1075#1088#1091#1079#1082#1072' '#1080#1090#1086#1075', '#1096#1090' ('#1087#1086#1082#1091#1087'.)'
            DataBinding.FieldName = 'AmountSalePartner_Sh'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object AmountSummTotal: TcxGridDBColumn
            Caption = #1047#1072#1082#1072#1079' '#1048#1090#1086#1075#1086', '#1075#1088#1085
            DataBinding.FieldName = 'AmountSummTotal'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object Amount_Order: TcxGridDBColumn
            Caption = #1047#1072#1082#1072#1079' 1+2'
            DataBinding.FieldName = 'Amount_Order'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SumSale: TcxGridDBColumn
            Caption = #1054#1090#1075#1088#1091#1079#1082#1072' '#1048#1090#1086#1075#1086', '#1075#1088#1085
            DataBinding.FieldName = 'SumSale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object AmountSumm1: TcxGridDBColumn
            Caption = #1047#1072#1082#1072#1079' 1, '#1075#1088#1085
            DataBinding.FieldName = 'AmountSumm1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object AmountSumm2: TcxGridDBColumn
            Caption = #1047#1072#1082#1072#1079' 2, '#1075#1088#1085
            DataBinding.FieldName = 'AmountSumm2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object AmountSumm_Dozakaz: TcxGridDBColumn
            Caption = #1044#1086#1079#1072#1082#1072#1079', '#1075#1088#1085
            DataBinding.FieldName = 'AmountSumm_Dozakaz'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object PriceSale: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1087#1086#1079#1080#1094#1080#1080
            DataBinding.FieldName = 'PriceSale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object CountDiff_B: TcxGridDBColumn
            Caption = '> '#1079#1072#1103#1074#1082#1080' ('#1096#1090')'
            DataBinding.FieldName = 'CountDiff_B'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = #1041#1086#1083#1100#1096#1077' '#1079#1072#1103#1074#1082#1080
            Width = 60
          end
          object CountDiff_M: TcxGridDBColumn
            Caption = '< '#1079#1072#1103#1074#1082#1080' ('#1096#1090')'
            DataBinding.FieldName = 'CountDiff_M'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = #1052#1077#1085#1100#1096#1077' '#1079#1072#1103#1074#1082#1080
            Width = 60
          end
          object WeightDiff_B: TcxGridDBColumn
            Caption = '> '#1079#1072#1103#1074#1082#1080' ('#1082#1075')'
            DataBinding.FieldName = 'WeightDiff_B'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = '> '#1079#1072#1103#1074#1082#1080' ('#1082#1075')'
            Width = 60
          end
          object WeightDiff_M: TcxGridDBColumn
            Caption = '< '#1079#1072#1103#1074#1082#1080' ('#1082#1075')'
            DataBinding.FieldName = 'WeightDiff_M'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = #1052#1077#1085#1100#1096#1077' '#1079#1072#1103#1074#1082#1080' ('#1082#1075')'
            Width = 60
          end
          object TotalCountDiff_B: TcxGridDBColumn
            Caption = '> '#1079#1072#1103#1074#1082#1080' ('#1096#1090') ('#1080#1090#1086#1075#1086')'
            DataBinding.FieldName = 'TotalCountDiff_B'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = #1041#1086#1083#1100#1096#1077' '#1079#1072#1103#1074#1082#1080' ('#1080#1090#1086#1075#1086')'
            Width = 60
          end
          object TotalCountDiff_M: TcxGridDBColumn
            Caption = '< '#1079#1072#1103#1074#1082#1080' ('#1096#1090') ('#1080#1090#1086#1075#1086')'
            DataBinding.FieldName = 'TotalCountDiff_M'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = #1052#1077#1085#1100#1096#1077' '#1079#1072#1103#1074#1082#1080' ('#1080#1090#1086#1075#1086')'
            Width = 60
          end
          object TotalWeightDiff_B: TcxGridDBColumn
            Caption = '> '#1079#1072#1103#1074#1082#1080' ('#1082#1075') ('#1080#1090#1086#1075#1086')'
            DataBinding.FieldName = 'TotalWeightDiff_B'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = '> '#1079#1072#1103#1074#1082#1080' ('#1082#1075') ('#1080#1090#1086#1075#1086')'
            Width = 60
          end
          object TotalWeightDiff_M: TcxGridDBColumn
            Caption = '< '#1079#1072#1103#1074#1082#1080' ('#1082#1075') ('#1080#1090#1086#1075#1086')'
            DataBinding.FieldName = 'TotalWeightDiff_M'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = #1052#1077#1085#1100#1096#1077' '#1079#1072#1103#1074#1082#1080' ('#1082#1075') ('#1080#1090#1086#1075#1086')'
            Width = 60
          end
          object Amount_Dozakaz: TcxGridDBColumn
            DataBinding.FieldName = 'Amount_Dozakaz'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            VisibleForCustomization = False
            Width = 60
          end
          object AmountSale: TcxGridDBColumn
            DataBinding.FieldName = 'AmountSale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            VisibleForCustomization = False
            Width = 60
          end
          object AmountTax: TcxGridDBColumn
            Caption = '% '#1086#1090#1082#1083
            DataBinding.FieldName = 'AmountTax'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            Width = 60
          end
          object DiffTax: TcxGridDBColumn
            DataBinding.FieldName = 'DiffTax'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            VisibleForCustomization = False
            Width = 60
          end
          object Diff_M: TcxGridDBColumn
            DataBinding.FieldName = 'Diff_M'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            VisibleForCustomization = False
            Width = 60
          end
          object CountPrint_M: TcxGridDBColumn
            DataBinding.FieldName = 'CountPrint_M'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            VisibleForCustomization = False
            Width = 20
          end
          object TotalCount_Diff: TcxGridDBColumn
            DataBinding.FieldName = 'TotalCount_Diff'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            VisibleForCustomization = False
            Width = 50
          end
          object TotalWeight_Diff: TcxGridDBColumn
            DataBinding.FieldName = 'TotalWeight_Diff'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            VisibleForCustomization = False
            Width = 50
          end
          object TotalAmountTax: TcxGridDBColumn
            DataBinding.FieldName = 'TotalAmountTax'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            VisibleForCustomization = False
            Width = 50
          end
          object TotalWeightTax: TcxGridDBColumn
            DataBinding.FieldName = 'TotalWeightTax'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            VisibleForCustomization = False
            Width = 50
          end
          object AmountSale_Weight_M: TcxGridDBColumn
            DataBinding.FieldName = 'AmountSale_Weight_M'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            VisibleForCustomization = False
            Width = 60
          end
          object Amount_Weight_M: TcxGridDBColumn
            DataBinding.FieldName = 'Amount_Weight_M'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            VisibleForCustomization = False
            Width = 50
          end
          object Amount_Weight_Dozakaz_M: TcxGridDBColumn
            DataBinding.FieldName = 'Amount_Weight_Dozakaz_M'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            VisibleForCustomization = False
            Width = 50
          end
          object TotalAmountWeight_child: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1088#1077#1079#1077#1088#1074',  '#1074#1077#1089
            DataBinding.FieldName = 'TotalAmountWeight_child'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1088#1077#1079#1077#1088#1074' '#1089' '#1086#1089#1090#1072#1090#1082#1072'+'#1087#1088#1080#1093#1086#1076', '#1074#1077#1089
            Options.Editing = False
            Width = 70
          end
          object AmountWeight_child_one: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1088#1077#1079#1077#1088#1074'-1,  '#1074#1077#1089
            DataBinding.FieldName = 'AmountWeight_child_one'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1088#1077#1079#1077#1088#1074' '#1089' '#1086#1089#1090#1072#1090#1082#1072', '#1074#1077#1089
            Options.Editing = False
            Width = 70
          end
          object AmountWeight_child_sec: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1088#1077#1079#1077#1088#1074'-2,  '#1074#1077#1089
            DataBinding.FieldName = 'AmountWeight_child_sec'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1088#1077#1079#1077#1088#1074' '#1089' '#1087#1088#1080#1093#1086#1076#1072', '#1074#1077#1089
            Options.Editing = False
            Width = 70
          end
          object AmountWeight_diff: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1088#1077#1079#1077#1088#1074' '#1084#1080#1085#1091#1089', '#1074#1077#1089
            DataBinding.FieldName = 'AmountWeight_diff'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1085#1077' '#1093#1074#1072#1090#1072#1077#1090' '#1076#1083#1103' '#1088#1077#1079#1077#1088#1074#1072', '#1074#1077#1089
            Options.Editing = False
            Width = 80
          end
          object AmountWeight_diff_fact: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1088#1077#1079#1077#1088#1074' '#1084#1080#1085#1091#1089' '#1092#1072#1082#1090' '#1086#1090#1075#1088'., '#1074#1077#1089
            DataBinding.FieldName = 'AmountWeight_diff_fact'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1088#1077#1079#1077#1088#1074' '#1084#1080#1085#1091#1089' '#1092#1072#1082#1090' '#1086#1090#1075#1088'., '#1074#1077#1089#1084
            Options.Editing = False
            Width = 80
          end
          object TotalAmountSh_child: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1088#1077#1079#1077#1088#1074',  '#1096#1090
            DataBinding.FieldName = 'TotalAmountSh_child'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1088#1077#1079#1077#1088#1074' '#1089' '#1086#1089#1090#1072#1090#1082#1072'+'#1087#1088#1080#1093#1086#1076', '#1096#1090
            Options.Editing = False
            Width = 70
          end
          object AmountSh_child_one: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1088#1077#1079#1077#1088#1074'-1,  '#1096#1090
            DataBinding.FieldName = 'AmountSh_child_one'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1088#1077#1079#1077#1088#1074' '#1089' '#1086#1089#1090#1072#1090#1082#1072', '#1096#1090
            Options.Editing = False
            Width = 70
          end
          object AmountSh_child_sec: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1088#1077#1079#1077#1088#1074'-2,  '#1096#1090
            DataBinding.FieldName = 'AmountSh_child_sec'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1088#1077#1079#1077#1088#1074' '#1089' '#1087#1088#1080#1093#1086#1076#1072', '#1096#1090
            Options.Editing = False
            Width = 70
          end
          object AmountSh_diff: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1088#1077#1079#1077#1088#1074' '#1084#1080#1085#1091#1089', '#1096#1090
            DataBinding.FieldName = 'AmountSh_diff'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1085#1077' '#1093#1074#1072#1090#1072#1077#1090' '#1076#1083#1103' '#1088#1077#1079#1077#1088#1074#1072', '#1096#1090
            Options.Editing = False
            Width = 80
          end
          object AmountSh_diff_fact: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1088#1077#1079#1077#1088#1074' '#1084#1080#1085#1091#1089' '#1092#1072#1082#1090' '#1086#1090#1075#1088'., '#1096#1090
            DataBinding.FieldName = 'AmountSh_diff_fact'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1088#1077#1079#1077#1088#1074' '#1084#1080#1085#1091#1089' '#1092#1072#1082#1090' '#1086#1090#1075#1088'., '#1096#1090
            Options.Editing = False
            Width = 80
          end
          object isPrint_M: TcxGridDBColumn
            Caption = #1052#1077#1085#1100#1096#1077' '#1079#1072#1103#1074#1082#1080' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isPrint_M'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object InfoMoneyName: TcxGridDBColumn
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object GoodsBoxName_short: TcxGridDBColumn
            Caption = #1071#1097'. '#1075#1086#1092#1088#1086
            DataBinding.FieldName = 'GoodsBoxName_short'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 76
          end
          object AmountBox: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1103#1097#1080#1082#1086#1074
            DataBinding.FieldName = 'AmountBox'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object BoxCount: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1074' '#1103#1097'.'
            DataBinding.FieldName = 'BoxCount'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object MovementPromo_order: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082' '#1072#1082#1094#1080#1103' ('#1079#1072#1103#1074#1082#1072')'
            DataBinding.FieldName = 'MovementPromo_order'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
          object MovementPromo_sale: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082' '#1072#1082#1094#1080#1103' ('#1087#1088#1086#1076#1072#1078#1072')'
            DataBinding.FieldName = 'MovementPromo_sale'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1142
    Height = 65
    ExplicitWidth = 1092
    ExplicitHeight = 65
    inherited deStart: TcxDateEdit
      Left = 118
      EditValue = 43101d
      Properties.SaveTime = False
      ExplicitLeft = 118
    end
    inherited deEnd: TcxDateEdit
      Left = 118
      Top = 30
      EditValue = 43101d
      Properties.SaveTime = False
      ExplicitLeft = 118
      ExplicitTop = 30
    end
    inherited cxLabel1: TcxLabel
      Left = 25
      ExplicitLeft = 25
    end
    inherited cxLabel2: TcxLabel
      Left = 6
      Top = 31
      ExplicitLeft = 6
      ExplicitTop = 31
    end
    object cxLabel4: TcxLabel
      Left = 713
      Top = 6
      Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1086#1074':'
    end
    object edGoodsGroup: TcxButtonEdit
      Left = 804
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 5
      Width = 164
    end
    object cxLabel13: TcxLabel
      Left = 209
      Top = 31
      Caption = #1057#1086#1088#1090#1080#1088#1086#1074#1082#1072' '#1084#1072#1088#1096#1088#1091#1090#1072':'
    end
    object edRouteSorting: TcxButtonEdit
      Left = 330
      Top = 30
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 7
      Width = 171
    end
    object cxLabel7: TcxLabel
      Left = 508
      Top = 31
      Caption = #1052#1072#1088#1096#1088#1091#1090':'
    end
    object edRoute: TcxButtonEdit
      Left = 561
      Top = 30
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 9
      Width = 146
    end
    object cxLabel3: TcxLabel
      Left = 209
      Top = 6
      Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090':'
    end
    object edPartner: TcxButtonEdit
      Left = 278
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 11
      Width = 223
    end
    object cbByDoc: TcxCheckBox
      Left = 713
      Top = 32
      Action = actRefreshDoc
      TabOrder = 12
      Width = 211
    end
    object cbbyPromo: TcxCheckBox
      Left = 930
      Top = 32
      Action = actRefreshPromo
      TabOrder = 13
      Width = 204
    end
  end
  object edTo: TcxButtonEdit [2]
    Left = 551
    Top = 5
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 6
    Width = 156
  end
  object cxLabel8: TcxLabel [3]
    Left = 508
    Top = 6
    Caption = #1057#1082#1083#1072#1076':'
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
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
        Component = GoodsGroupGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesPartner
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesRouteSorting
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesRoute
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesTo
        Properties.Strings = (
          'Key'
          'TextValue')
      end>
  end
  inherited ActionList: TActionList
    Left = 407
    Top = 239
    object actRefreshPromo: TdsdDataSetRefresh [0]
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1056#1072#1079#1074#1077#1088#1085#1091#1090#1100' '#1087#1086' '#1076#1086#1082'. '#1040#1082#1094#1080#1103' ('#1076#1072'/'#1085#1077#1090')'
      Hint = #1056#1072#1079#1074#1077#1088#1085#1091#1090#1100' '#1087#1086' '#1076#1086#1082'. '#1040#1082#1094#1080#1103' ('#1076#1072'/'#1085#1077#1090')'
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actOpenFormOrder: TdsdOpenForm [1]
      Category = 'OpenForm'
      MoveParams = <>
      Caption = 'actOpenForm'
      FormName = 'NULL'
      FormNameParam.Value = ''
      FormNameParam.Component = FormParams
      FormNameParam.ComponentItem = 'FormName'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inOperDate'
          Value = 43101d
          Component = deStart
          ComponentItem = 'OperDate'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId'
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actRefreshDoc: TdsdDataSetRefresh [2]
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1056#1072#1079#1074#1077#1088#1085#1091#1090#1100' '#1087#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084'  ('#1076#1072'/'#1085#1077#1090')'
      Hint = #1056#1072#1079#1074#1077#1088#1085#1091#1090#1100' '#1087#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084'  ('#1076#1072'/'#1085#1077#1090')'
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actOpenFormSale: TdsdOpenForm [3]
      Category = 'OpenForm'
      MoveParams = <>
      Caption = 'actOpenFormSale'
      FormName = 'NULL'
      FormNameParam.Value = ''
      FormNameParam.Component = FormParams
      FormNameParam.ComponentItem = 'FormName'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inOperDate'
          Value = 43101d
          Component = deStart
          ComponentItem = 'OperDate'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId_Sale'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ShowAll'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inChangePercentAmount'
          Value = 0.000000000000000000
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    inherited actRefresh: TdsdDataSetRefresh
      TabSheet = tsMain
    end
    object macOpenDocumentOrder: TMultiAction [5]
      Category = 'OpenForm'
      MoveParams = <>
      ActionList = <
        item
          Action = actMovementOrderForm
        end
        item
          Action = actOpenFormOrder
        end>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1047#1072#1082#1072#1079
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1047#1072#1082#1072#1079
      ImageIndex = 28
    end
    object actPrint_byType: TdsdPrintAction
      Category = 'Print_old'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1087#1086' '#1074#1080#1076#1091' '#1090#1086#1074#1072#1088#1072')'
      Hint = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1087#1086' '#1074#1080#1076#1091' '#1090#1086#1074#1072#1088#1072')'
      ImageIndex = 21
      ShortCut = 16464
      DataSets = <
        item
          DataSet = MasterCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'goodskindname;GoodsGroupNameFull;goodsname'
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
      ReportName = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1087#1086' '#1074#1080#1076#1091' '#1090#1086#1074#1072#1088#1072')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1087#1086' '#1074#1080#1076#1091' '#1090#1086#1074#1072#1088#1072')'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint_byPack: TdsdPrintAction
      Category = 'Print_old'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1076#1083#1103' '#1059#1087#1072#1082#1086#1074#1082#1080')'
      Hint = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1076#1083#1103' '#1059#1087#1072#1082#1086#1074#1082#1080')'
      ImageIndex = 19
      ShortCut = 16464
      DataSets = <
        item
          DataSet = MasterCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'routesortingname;GoodsGroupNameFull;goodsname;goodskindname'
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
      ReportName = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1076#1083#1103' '#1059#1087#1072#1082#1086#1074#1082#1080')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1076#1083#1103' '#1059#1087#1072#1082#1086#1074#1082#1080')'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint_byProduction: TdsdPrintAction
      Category = 'Print_old'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1085#1072' '#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086')'
      Hint = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1087#1086' '#1055#1086#1082#1091#1087#1072#1090#1077#1083#1103#1084'-'#1074#1089#1077')'
      ImageIndex = 20
      ShortCut = 16464
      DataSets = <
        item
          DataSet = MasterCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GoodsGroupNameFull;GoodsName;GoodsKindName'
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
      ReportName = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1085#1072' '#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1085#1072' '#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086')'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint_byRouteItog: TdsdPrintAction
      Category = 'Print_old'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1087#1086' '#1052#1072#1088#1096#1088#1091#1090#1072#1084'-'#1080#1090#1086#1075#1086')'
      Hint = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1087#1086' '#1052#1072#1088#1096#1088#1091#1090#1072#1084'-'#1080#1090#1086#1075#1086')'
      ImageIndex = 16
      ShortCut = 16464
      DataSets = <
        item
          DataSet = MasterCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'InfoMoneyName;routename'
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
      ReportName = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1087#1086' '#1052#1072#1088#1096#1088#1091#1090#1072#1084'-'#1080#1090#1086#1075#1086')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1087#1086' '#1052#1072#1088#1096#1088#1091#1090#1072#1084'-'#1080#1090#1086#1075#1086')'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint_byRoute: TdsdPrintAction
      Category = 'Print_old'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1087#1086' '#1052#1072#1088#1096#1088#1091#1090#1072#1084'-'#1076#1077#1090#1072#1083#1100#1085#1086')'
      Hint = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1087#1086' '#1052#1072#1088#1096#1088#1091#1090#1072#1084'-'#1076#1077#1090#1072#1083#1100#1085#1086')'
      ImageIndex = 22
      ShortCut = 16464
      DataSets = <
        item
          DataSet = MasterCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'routename;routesortingname;fromname'
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
      ReportName = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1087#1086' '#1052#1072#1088#1096#1088#1091#1090#1072#1084'-'#1076#1077#1090#1072#1083#1100#1085#1086')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1087#1086' '#1052#1072#1088#1096#1088#1091#1090#1072#1084'-'#1076#1077#1090#1072#1083#1100#1085#1086')'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint_byByer: TdsdPrintAction
      Category = 'Print_old'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1087#1086' '#1055#1086#1082#1091#1087#1072#1090#1077#1083#1103#1084'-'#1074#1089#1077')'
      Hint = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1087#1086' '#1055#1086#1082#1091#1087#1072#1090#1077#1083#1103#1084'-'#1074#1089#1077')'
      ImageIndex = 18
      ShortCut = 16464
      DataSets = <
        item
          DataSet = MasterCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 
            'FromName;RouteSortingName;RouteName;GoodsGroupNameFull;GoodsName' +
            ';GoodsKindName'
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
      ReportName = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1087#1086' '#1055#1086#1082#1091#1087#1072#1090#1077#1083#1103#1084'-'#1074#1089#1077')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1087#1086' '#1055#1086#1082#1091#1087#1072#1090#1077#1083#1103#1084'-'#1074#1089#1077')'
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
      FormName = 'TReport_GoodsMI_OrderExternal_SaleDialogForm'
      FormNameParam.Value = 'TReport_GoodsMI_OrderExternal_SaleDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 42005d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42005d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerId'
          Value = ''
          Component = GuidesPartner
          ComponentItem = 'Key'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerName'
          Value = ''
          Component = GuidesPartner
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupId'
          Value = ''
          Component = GoodsGroupGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = ''
          Component = GoodsGroupGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'RouteSortingId'
          Value = ''
          Component = GuidesRouteSorting
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'RouteSortingName'
          Value = ''
          Component = GuidesRouteSorting
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'RouteId'
          Value = ''
          Component = GuidesRoute
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'RouteName'
          Value = ''
          Component = GuidesRoute
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToId'
          Value = ''
          Component = GuidesTo
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToName'
          Value = ''
          Component = GuidesTo
          ComponentItem = 'TextValue'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inIsByDoc'
          Value = False
          Component = cbByDoc
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inIsByPromo'
          Value = Null
          Component = cbbyPromo
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
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
        end
        item
          FromParam.Value = 43101d
          FromParam.Component = deStart
          FromParam.DataType = ftDateTime
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'StartDate'
          ToParam.Value = Null
          ToParam.DataType = ftDateTime
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = 43101d
          FromParam.Component = deEnd
          FromParam.DataType = ftDateTime
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'EndDate'
          ToParam.Value = Null
          ToParam.DataType = ftDateTime
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProcList = <>
      Caption = #1052#1077#1085#1100#1096#1077' '#1079#1072#1103#1074#1082#1080
      Hint = #1052#1077#1085#1100#1096#1077' '#1079#1072#1103#1074#1082#1080
      ImageIndex = 3
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'fromname;InvNumber_Order;GoodsName;GoodsKindName'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 43101d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 43101d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'maintext'
          Value = Null
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerName'
          Value = Null
          Component = GuidesPartner
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToName'
          Value = Null
          Component = GuidesTo
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1047#1072#1103#1074#1082#1072' '#1054#1090#1075#1088#1091#1079#1082#1072' ('#1084#1077#1085#1100#1096#1077' '#1079#1072#1103#1074#1082#1080')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1047#1072#1103#1074#1082#1072' '#1054#1090#1075#1088#1091#1079#1082#1072' ('#1084#1077#1085#1100#1096#1077' '#1079#1072#1103#1074#1082#1080')'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actMovementOrderForm: TdsdExecStoredProc
      Category = 'OpenForm'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = getMovementOrderForm
      StoredProcList = <
        item
          StoredProc = getMovementOrderForm
        end>
      Caption = 'actMovementForm'
    end
    object actMovementSaleForm: TdsdExecStoredProc
      Category = 'OpenForm'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = getMovementSaleForm
      StoredProcList = <
        item
          StoredProc = getMovementSaleForm
        end>
      Caption = 'actMovementForm'
    end
    object macOpenDocumentSale: TMultiAction
      Category = 'OpenForm'
      MoveParams = <>
      ActionList = <
        item
          Action = actMovementSaleForm
        end
        item
          Action = actOpenFormSale
        end>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1055#1088#1086#1076#1072#1078#1080
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1055#1088#1086#1076#1072#1078#1080
      ImageIndex = 28
    end
  end
  inherited MasterDS: TDataSource
    Left = 112
    Top = 200
  end
  inherited MasterCDS: TClientDataSet
    Left = 40
    Top = 208
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_OrderExternal_Sale'
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
        Name = 'inFromId'
        Value = ''
        Component = GuidesPartner
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRouteId'
        Value = ''
        Component = GuidesRoute
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRouteSortingId'
        Value = ''
        Component = GuidesRouteSorting
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsGroupId'
        Value = ''
        Component = GoodsGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsByDoc'
        Value = False
        Component = cbByDoc
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsByPromo'
        Value = Null
        Component = cbbyPromo
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
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
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbOpenDocumentOrder'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbOpenDocumentSale'
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
          ItemName = 'bbPrintNew'
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
    object bbPrintPrint_byByer: TdxBarButton
      Action = actPrint_byByer
      Category = 0
      Visible = ivNever
    end
    object bbPrint_byPack: TdxBarButton
      Action = actPrint_byPack
      Category = 0
      Visible = ivNever
    end
    object bbPrint_byProduction: TdxBarButton
      Action = actPrint_byProduction
      Category = 0
      Visible = ivNever
    end
    object bbPrint_byType: TdxBarButton
      Action = actPrint_byType
      Category = 0
      Visible = ivNever
    end
    object bbPrint_byRoute: TdxBarButton
      Action = actPrint_byRoute
      Category = 0
      Visible = ivNever
    end
    object bbPrint_byRouteItog: TdxBarButton
      Action = actPrint_byRouteItog
      Category = 0
      Visible = ivNever
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbPrint: TdxBarButton
      Action = actPrint
      Category = 0
    end
    object bbPrintNew: TdxBarButton
      Action = actPrint
      Category = 0
    end
    object bbOpenDocumentOrder: TdxBarButton
      Action = macOpenDocumentOrder
      Category = 0
    end
    object bbOpenDocumentSale: TdxBarButton
      Action = macOpenDocumentSale
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1055#1088#1086#1076#1072#1078#1072
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 712
    Top = 200
  end
  inherited PopupMenu: TPopupMenu
    Left = 144
    Top = 256
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 56
    Top = 32
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = GoodsGroupGuides
      end
      item
        Component = GuidesPartner
      end
      item
        Component = GuidesRoute
      end
      item
        Component = GuidesRouteSorting
      end
      item
        Component = GuidesTo
      end>
    Left = 504
    Top = 216
  end
  object GoodsGroupGuides: TdsdGuides
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
        Component = GoodsGroupGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 800
    Top = 8
  end
  object FormParams: TdsdFormParams
    Params = <>
    Left = 224
    Top = 250
  end
  object GuidesRouteSorting: TdsdGuides
    KeyField = 'Id'
    LookupControl = edRouteSorting
    FormNameParam.Value = 'TRouteSortingForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TRouteSortingForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesRouteSorting
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesRouteSorting
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 424
    Top = 16
  end
  object GuidesRoute: TdsdGuides
    KeyField = 'Id'
    LookupControl = edRoute
    FormNameParam.Value = 'TRouteForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TRouteForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesRoute
        ComponentItem = 'Key'
        DataType = ftString
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
      end>
    Left = 560
    Top = 16
  end
  object GuidesPartner: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPartner
    FormNameParam.Value = 'TPartner_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPartner_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPartner
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPartner
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 360
    Top = 65528
  end
  object GuidesTo: TdsdGuides
    KeyField = 'Id'
    LookupControl = edTo
    FormNameParam.Value = 'TStoragePlace_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TStoragePlace_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 616
    Top = 65532
  end
  object getMovementSaleForm: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Form'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId_Sale'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'FormName'
        Value = Null
        Component = FormParams
        ComponentItem = 'FormName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 848
    Top = 216
  end
  object getMovementOrderForm: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Form'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'FormName'
        Value = Null
        Component = FormParams
        ComponentItem = 'FormName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 744
    Top = 256
  end
end
