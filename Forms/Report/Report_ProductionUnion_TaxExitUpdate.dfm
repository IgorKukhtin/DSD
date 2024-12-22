inherited Report_ProductionUnion_TaxExitUpdateForm: TReport_ProductionUnion_TaxExitUpdateForm
  Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1074#1099#1093#1086#1076#1072#1084' ('#1044#1077#1083#1080#1082#1072#1090#1077#1089#1099')'
  ClientHeight = 651
  ClientWidth = 1298
  AddOnFormData.isSingle = False
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.Params = FormParams
  ExplicitWidth = 1314
  ExplicitHeight = 690
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 84
    Width = 1298
    Height = 567
    TabOrder = 3
    ExplicitTop = 84
    ExplicitWidth = 1298
    ExplicitHeight = 567
    ClientRectBottom = 567
    ClientRectRight = 1298
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1298
      ExplicitHeight = 567
      inherited cxGrid: TcxGrid
        Width = 1298
        Height = 567
        ExplicitWidth = 1298
        ExplicitHeight = 567
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_Humidity
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TaxLossVPR
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RealDelicShp
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RealWeightShp_calc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountShp_diff
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountReceipt
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RealWeightMsg_calc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountMsg_diff
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountTRM_befor_plan
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountTRM_befor_diff
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountTRM_befor_fact
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TaxExit
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TaxExit_fact
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TaxExit_diff
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CuterCount_inf
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CuterCount_calcinf
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RealWeightShpinf
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RealWeightShp_calcinf
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amountinf
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RealWeightMsg_inf
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RealWeightMsg_calcinf
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_outinf
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RealWeight_inf
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_main_det
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountMain_part_det
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_inf_calc
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_Humidity
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RealDelicShp
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RealWeightShp_calc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountShp_diff
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountReceipt
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RealWeightMsg_calc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountMsg_diff
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountTRM_befor_plan
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountTRM_befor_diff
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountTRM_befor_fact
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TaxExit
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TaxExit_fact
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TaxExit_diff
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CuterCount_inf
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CuterCount_calcinf
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RealWeightShpinf
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RealWeightShp_calcinf
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amountinf
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RealWeightMsg_inf
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RealWeightMsg_calcinf
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_outinf
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RealWeight_inf
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_main_det
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountMain_part_det
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_inf_calc
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
          object GoodsGroupNameFull: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072' ('#1042#1089#1077')'
            DataBinding.FieldName = 'GoodsGroupNameFull'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 103
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1090#1086#1074'.'
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 132
          end
          object GoodsKindName_Complete: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName_Complete'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object MeasureName: TcxGridDBColumn
            Caption = #1045#1076' '#1080#1079#1084
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 64
          end
          object PartionGoodsDate: TcxGridDBColumn
            Caption = #1055#1072#1088#1090#1080#1103
            DataBinding.FieldName = 'PartionGoodsDate'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 54
          end
          object RealDelicShp: TcxGridDBColumn
            Caption = #1055#1051#1040#1053' '#1042#1077#1089' '#1087#1086#1089#1083#1077' '#1096#1087#1088#1080#1094'.'
            DataBinding.FieldName = 'RealDelicShp'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1077#1094#1077#1087#1090#1091#1088#1072': '#1042#1077#1089' '#1087#1086#1089#1083#1077' '#1096#1087#1088#1080#1094#1077#1074#1072#1085#1080#1103
            Width = 65
          end
          object RealWeightShp_calc: TcxGridDBColumn
            Caption = #1060#1040#1050#1058' '#1042#1077#1089' '#1087#1086#1089#1083#1077' '#1096#1087#1088#1080#1094'.'
            DataBinding.FieldName = 'RealWeightShp_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object AmountShp_diff: TcxGridDBColumn
            Caption = #1054#1058#1050#1051' '#1042#1077#1089' '#1087#1086#1089#1083#1077' '#1096#1087#1088#1080#1094'.'
            DataBinding.FieldName = 'AmountShp_diff'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          object Amount_Humidity: TcxGridDBColumn
            Caption = #1054#1090#1089#1077#1095#1077#1085#1080#1077' '#1074#1083#1072#1075#1080' ('#1092#1072#1082#1090'), '#1082#1075
            DataBinding.FieldName = 'Amount_Humidity'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1090#1089#1077#1095#1077#1085#1080#1077' '#1074#1083#1072#1075#1080' ('#1092#1072#1082#1090'), '#1082#1075
            Width = 80
          end
          object TaxLossVPR: TcxGridDBColumn
            Caption = #1055#1051#1040#1053' % '#1074#1087#1088#1099#1089#1082#1072
            DataBinding.FieldName = 'TaxLossVPR'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1077#1094#1077#1087#1090#1091#1088#1072': % '#1074#1087#1088#1099#1089#1082#1072
            Width = 66
          end
          object TaxLossVPR_fact: TcxGridDBColumn
            Caption = #1060#1040#1050#1058' % '#1074#1087#1088#1099#1089#1082#1072
            DataBinding.FieldName = 'TaxLossVPR_fact'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object TaxLoss_diff: TcxGridDBColumn
            Caption = #1054#1058#1050#1051' % '#1074#1087#1088#1099#1089#1082#1072
            DataBinding.FieldName = 'TaxLoss_diff'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object AmountReceipt: TcxGridDBColumn
            Caption = #1055#1051#1040#1053' '#1042#1077#1089' '#1087#1086#1089#1083#1077' '#1084#1072#1089#1089#1072#1078#1077#1088#1072', '#1082#1075
            DataBinding.FieldName = 'AmountReceipt'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1077#1094#1077#1087#1090#1091#1088#1099': '#1042#1077#1089' '#1055'/'#1060' ('#1043#1055')'
            Width = 90
          end
          object RealWeightMsg_calc: TcxGridDBColumn
            Caption = #1060#1040#1050#1058' '#1042#1077#1089' '#1087#1086#1089#1083#1077' '#1084#1072#1089#1089#1072#1078#1077#1088#1072', '#1082#1075
            DataBinding.FieldName = 'RealWeightMsg_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object AmountMsg_diff: TcxGridDBColumn
            Caption = #1054#1058#1050#1051' '#1042#1077#1089' '#1087#1086#1089#1083#1077' '#1084#1072#1089#1089#1072#1078#1077#1088#1072', '#1082#1075
            DataBinding.FieldName = 'AmountMsg_diff'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object TaxLossCEH: TcxGridDBColumn
            Caption = #1055#1051#1040#1053' '#1055#1086#1090#1077#1088#1080' ('#1094#1077#1093'), %'
            DataBinding.FieldName = 'TaxLossCEH'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1077#1094#1077#1087#1090#1091#1088#1099': % '#1087#1086#1090#1077#1088#1100' ('#1094#1077#1093')'
            Width = 90
          end
          object TaxLossCEH_fact: TcxGridDBColumn
            Caption = #1060#1040#1050#1058' '#1055#1086#1090#1077#1088#1080' ('#1094#1077#1093'), %'
            DataBinding.FieldName = 'TaxLossCEH_fact'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object TaxLossCEH_diff: TcxGridDBColumn
            Caption = #1054#1058#1050#1051' '#1055#1086#1090#1077#1088#1080' ('#1094#1077#1093'), %'
            DataBinding.FieldName = 'TaxLossCEH_diff'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object AmountTRM_befor_plan: TcxGridDBColumn
            Caption = #1055#1051#1040#1053' '#1042#1077#1089' '#1087#1077#1088#1077#1076' '#1090#1077#1088#1084#1080#1095#1082#1086#1081', '#1082#1075
            DataBinding.FieldName = 'AmountTRM_befor_plan'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object AmountTRM_befor_fact: TcxGridDBColumn
            Caption = #1060#1040#1050#1058' '#1042#1077#1089' '#1087#1077#1088#1077#1076' '#1090#1077#1088#1084#1080#1095#1082#1086#1081', '#1082#1075
            DataBinding.FieldName = 'AmountTRM_befor_fact'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object AmountTRM_befor_diff: TcxGridDBColumn
            Caption = #1054#1058#1050#1051' '#1042#1077#1089' '#1087#1077#1088#1077#1076' '#1090#1077#1088#1084#1080#1095#1082#1086#1081', '#1082#1075
            DataBinding.FieldName = 'AmountTRM_befor_diff'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object TaxLossTRM: TcxGridDBColumn
            Caption = #1055#1051#1040#1053' '#1055#1086#1090#1077#1088#1080' ('#1090#1077#1088#1084'.), %'
            DataBinding.FieldName = 'TaxLossTRM'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1077#1094#1077#1087#1090#1091#1088#1099': % '#1087#1086#1090#1077#1088#1100' ('#1090#1077#1088#1084#1080#1095#1082#1072')'
            Width = 90
          end
          object TaxLossTRM_fact: TcxGridDBColumn
            Caption = #1060#1040#1050#1058' '#1055#1086#1090#1077#1088#1080' ('#1090#1077#1088#1084'.), %'
            DataBinding.FieldName = 'TaxLossTRM_fact'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object TaxLossTRM_diff: TcxGridDBColumn
            Caption = #1054#1058#1050#1051' '#1055#1086#1090#1077#1088#1080' ('#1090#1077#1088#1084'.), %'
            DataBinding.FieldName = 'TaxLossTRM_diff'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderImageIndex = 0
            Width = 90
          end
          object TaxExit: TcxGridDBColumn
            Caption = #1055#1051#1040#1053' '#1042#1099#1093#1086#1076' '#1043#1055', '#1082#1075
            DataBinding.FieldName = 'TaxExit'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1077#1094#1077#1087#1090#1091#1088#1099': % '#1074#1099#1093#1086#1076#1072
            Width = 90
          end
          object TaxExit_fact: TcxGridDBColumn
            Caption = #1060#1040#1050#1058' '#1042#1099#1093#1086#1076' '#1043#1055', '#1082#1075
            DataBinding.FieldName = 'TaxExit_fact'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object TaxExit_diff: TcxGridDBColumn
            Caption = #1054#1058#1050#1051' '#1042#1099#1093#1086#1076' '#1043#1055', '#1082#1075
            DataBinding.FieldName = 'TaxExit_diff'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object Amount_GP_in: TcxGridDBColumn
            Caption = #1042#1099#1093#1086#1076' '#1043#1055' '#1092#1072#1082#1090
            DataBinding.FieldName = 'Amount_GP_in'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object ValueGP: TcxGridDBColumn
            Caption = #1053#1086#1088#1084#1072' '#1086#1090#1082#1083#1086#1085#1077#1085#1080#1103' '#1043#1055', '#1082#1075
            DataBinding.FieldName = 'ValueGP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object ValueGP_diff: TcxGridDBColumn
            Caption = #1054#1058#1050#1051' '#1086#1090' '#1085#1086#1088#1084#1099' '#1042#1099#1093#1086#1076' '#1043#1055', '#1082#1075' '
            DataBinding.FieldName = 'ValueGP_diff'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object ValuePF: TcxGridDBColumn
            Caption = #1053#1086#1088#1084#1072' '#1086#1090#1082#1083#1086#1085#1077#1085#1080#1103' '#1055'/'#1060' ('#1043#1055'), '#1082#1075
            DataBinding.FieldName = 'ValuePF'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object ValuePF_diff: TcxGridDBColumn
            Caption = #1054#1058#1050#1051' '#1086#1090' '#1085#1086#1088#1084#1099' '#1042#1077#1089' '#1087#1086#1089#1083#1077' '#1084#1072#1089#1089#1072#1078#1077#1088#1072', '#1082#1075
            DataBinding.FieldName = 'ValuePF_diff'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object CuterCount_inf: TcxGridDBColumn
            Caption = #1050#1091#1090#1090#1077#1088#1086#1074' '#1092#1072#1082#1090
            DataBinding.FieldName = 'CuterCount_inf'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 68
          end
          object CuterCount_calcinf: TcxGridDBColumn
            Caption = #1050#1091#1090#1090#1077#1088#1086#1074' '#1092#1072#1082#1090' ('#1088#1072#1089#1095#1077#1090')'
            DataBinding.FieldName = 'CuterCount_calcinf'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object RealWeightShpinf: TcxGridDBColumn
            Caption = #1042#1077#1089' '#1087'/'#1092' '#1092#1072#1082#1090' ('#1096#1087#1088') '
            DataBinding.FieldName = 'RealWeightShpinf'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object RealWeightShp_calcinf: TcxGridDBColumn
            Caption = #1042#1077#1089' '#1055'/'#1060' '#1087#1086#1089#1083#1077' '#1096#1087#1088#1080#1094#1077#1074#1072#1085#1080#1103' ('#1088#1072#1089#1095#1077#1090')'
            DataBinding.FieldName = 'RealWeightShp_calcinf'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object Amountinf: TcxGridDBColumn
            Caption = #1060#1072#1082#1090' '#1082#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amountinf'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object Amount_inf_calc: TcxGridDBColumn
            Caption = '***'#1060#1072#1082#1090' '#1082#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount_inf_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object RealWeightMsg_inf: TcxGridDBColumn
            Caption = #1042#1077#1089' '#1087'/'#1092' '#1092#1072#1082#1090' ('#1084#1089#1078')'
            DataBinding.FieldName = 'RealWeightMsg_inf'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object RealWeightMsg_calcinf: TcxGridDBColumn
            Caption = #1042#1077#1089' '#1055'/'#1060' '#1087#1086#1089#1083#1077' '#1084#1072#1089#1089#1072#1078#1077#1088#1072' ('#1088#1072#1089#1095#1077#1090')'
            DataBinding.FieldName = 'RealWeightMsg_calcinf'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object Amount_outinf: TcxGridDBColumn
            Caption = #1055#1077#1088#1077#1093#1086#1076#1103#1097#1080#1081' '#1055'/'#1060' ('#1088#1072#1089#1093#1086#1076'), '#1082#1075
            DataBinding.FieldName = 'Amount_outinf'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object RealWeight_inf: TcxGridDBColumn
            Caption = ' '#1042#1077#1089' '#1087'/'#1092' '#1092#1072#1082#1090
            DataBinding.FieldName = 'RealWeight_inf'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object Amount_main_det: TcxGridDBColumn
            Caption = #1082#1086#1083'-'#1074#1086' '#1092#1072#1082#1090' ('#1086#1089#1085'. '#1089#1099#1088#1100#1077')'
            DataBinding.FieldName = 'Amount_main_det'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object AmountMain_part_det: TcxGridDBColumn
            Caption = #1055#1077#1088#1077#1093#1086#1076#1103#1097#1080#1081' '#1055'/'#1060' ('#1087#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076'), '#1082#1075' ('#1086#1089#1085'. '#1089#1099#1088#1100#1077')'
            DataBinding.FieldName = 'AmountMain_part_det'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object Part_main_det: TcxGridDBColumn
            Caption = #1044#1086#1083#1103' ('#1086#1089#1085'. '#1089#1099#1088#1100#1077')'
            DataBinding.FieldName = 'Part_main_det'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object isPrint: TcxGridDBColumn
            Caption = #1055#1077#1095#1072#1090#1072#1090#1100' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isPrint'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1298
    Height = 58
    ExplicitWidth = 1298
    ExplicitHeight = 58
    inherited deStart: TcxDateEdit
      Left = 108
      EditValue = 45658d
      Properties.SaveTime = False
      ExplicitLeft = 108
    end
    inherited deEnd: TcxDateEdit
      Left = 108
      Top = 29
      EditValue = 45658d
      Properties.SaveTime = False
      ExplicitLeft = 108
      ExplicitTop = 29
    end
    inherited cxLabel1: TcxLabel
      Left = 19
      ExplicitLeft = 19
    end
    inherited cxLabel2: TcxLabel
      Left = 0
      Top = 30
      ExplicitLeft = 0
      ExplicitTop = 30
    end
    object cxLabel3: TcxLabel
      Left = 194
      Top = 6
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1086#1090' '#1082#1086#1075#1086'):'
    end
    object edFromGroup: TcxButtonEdit
      Left = 328
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 169
    end
    object cxLabel5: TcxLabel
      Left = 208
      Top = 30
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1082#1086#1084#1091'):'
    end
    object edToGroup: TcxButtonEdit
      Left = 328
      Top = 29
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 169
    end
    object cbisPartion: TcxCheckBox
      Left = 519
      Top = 5
      Hint = #1043#1088#1091#1087#1087#1080#1088#1086#1074#1072#1090#1100' '#1087#1072#1088#1090#1080#1080
      Caption = #1043#1088#1091#1087#1087#1080#1088#1086#1074#1072#1090#1100' '#1087#1072#1088#1090#1080#1080
      TabOrder = 8
      Width = 138
    end
    object cbIsTerm: TcxCheckBox
      Left = 519
      Top = 29
      Hint = #1058#1077#1088#1084#1080#1095#1082#1072
      Caption = #1058#1077#1088#1084#1080#1095#1082#1072
      TabOrder = 9
      Width = 138
    end
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
        Component = FromGroupGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = ToGroupGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end>
  end
  inherited ActionList: TActionList
    object actRefresh_Term: TdsdDataSetRefresh [0]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1058#1077#1088#1084#1080#1095#1082#1072
      Hint = #1058#1077#1088#1084#1080#1095#1082#1072
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actRefresh_Partion: TdsdDataSetRefresh [1]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1043#1088#1091#1087#1087#1080#1088#1086#1074#1072#1090#1100' '#1087#1072#1088#1090#1080#1080
      Hint = #1043#1088#1091#1087#1087#1080#1088#1086#1074#1072#1090#1100' '#1087#1072#1088#1090#1080#1080
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actPrintOUT: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100' '#1054#1090#1095#1077#1090' '#1087#1086' '#1074#1099#1093#1086#1076#1072#1084
      Hint = #1055#1077#1095#1072#1090#1100' '#1054#1090#1095#1077#1090' '#1087#1086' '#1074#1099#1093#1086#1076#1072#1084
      ImageIndex = 18
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 
            'GoodsGroupNameFull;GoodsCode;GoodsKindName_Complete;PartionGoods' +
            'Date'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42370d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42370d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromName'
          Value = ''
          Component = FromGroupGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToName'
          Value = ''
          Component = ToGroupGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090'_'#1087#1086'_'#1074#1099#1093#1086#1076#1072#1084
      ReportNameParam.Value = #1054#1090#1095#1077#1090'_'#1087#1086'_'#1074#1099#1093#1086#1076#1072#1084
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintCEH_Group_gr: TdsdPrintAction
      Category = 'Print_gr'
      MoveParams = <>
      StoredProc = spPrint_TaxExitUpdate_groupCeh_gr
      StoredProcList = <
        item
          StoredProc = spPrint_TaxExitUpdate_groupCeh_gr
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1054#1090#1095#1077#1090' '#1087#1086' '#1074#1099#1093#1086#1076#1072#1084' ('#1094#1077#1093') '#1075#1088#1091#1087#1087#1080#1088#1086#1074#1082#1072
      Hint = #1055#1077#1095#1072#1090#1100' '#1054#1090#1095#1077#1090' '#1087#1086' '#1074#1099#1093#1086#1076#1072#1084' ('#1094#1077#1093') '#1075#1088#1091#1087#1087#1080#1088#1086#1074#1082#1072
      ImageIndex = 3
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 
            'GoodsGroupNameFull;GoodsCode;GoodsKindName_Complete;PartionGoods' +
            'Date'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42370d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42370d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromName'
          Value = ''
          Component = FromGroupGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToName'
          Value = ''
          Component = ToGroupGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PageNum'
          Value = '2'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090'_'#1087#1086'_'#1074#1099#1093#1086#1076#1072#1084'('#1094#1077#1093')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090'_'#1087#1086'_'#1074#1099#1093#1086#1076#1072#1084'('#1094#1077#1093')'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object macPrintTRM_Group_gr: TMultiAction
      Category = 'Print_gr'
      MoveParams = <>
      ActionList = <
        item
          Action = actDelete_Object_Print
        end
        item
          Action = actPrint_byGrid_list
        end
        item
          Action = actPrintTRM_Group_gr
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1074#1099#1073#1086#1088#1086#1095#1085#1072#1103' '#1054#1090#1095#1077#1090' '#1087#1086' '#1074#1099#1093#1086#1076#1072#1084' ('#1090#1077#1088#1084#1080#1095#1082#1072') '#1075#1088#1091#1087#1087#1080#1088#1086#1074#1082#1072
      Hint = #1055#1077#1095#1072#1090#1100' '#1074#1099#1073#1086#1088#1086#1095#1085#1072#1103' '#1054#1090#1095#1077#1090' '#1087#1086' '#1074#1099#1093#1086#1076#1072#1084' ('#1090#1077#1088#1084#1080#1095#1082#1072') '#1075#1088#1091#1087#1087#1080#1088#1086#1074#1082#1072
      ImageIndex = 3
    end
    object actPrintCEH_Group: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spPrint_TaxExitUpdate_groupCeh
      StoredProcList = <
        item
          StoredProc = spPrint_TaxExitUpdate_groupCeh
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1054#1090#1095#1077#1090' '#1087#1086' '#1074#1099#1093#1086#1076#1072#1084' ('#1094#1077#1093') '#1075#1088#1091#1087#1087#1080#1088#1086#1074#1082#1072
      Hint = #1055#1077#1095#1072#1090#1100' '#1054#1090#1095#1077#1090' '#1087#1086' '#1074#1099#1093#1086#1076#1072#1084' ('#1094#1077#1093') '#1075#1088#1091#1087#1087#1080#1088#1086#1074#1082#1072
      ImageIndex = 3
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 
            'GoodsGroupNameFull;GoodsCode;GoodsKindName_Complete;PartionGoods' +
            'Date'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42370d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42370d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromName'
          Value = ''
          Component = FromGroupGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToName'
          Value = ''
          Component = ToGroupGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PageNum'
          Value = '2'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090'_'#1087#1086'_'#1074#1099#1093#1086#1076#1072#1084'('#1094#1077#1093')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090'_'#1087#1086'_'#1074#1099#1093#1086#1076#1072#1084'('#1094#1077#1093')'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintCEH: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100' '#1054#1090#1095#1077#1090' '#1087#1086' '#1074#1099#1093#1086#1076#1072#1084' ('#1094#1077#1093')'
      Hint = #1055#1077#1095#1072#1090#1100' '#1054#1090#1095#1077#1090' '#1087#1086' '#1074#1099#1093#1086#1076#1072#1084' ('#1094#1077#1093')'
      ImageIndex = 3
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 
            'GoodsGroupNameFull;GoodsCode;GoodsKindName_Complete;PartionGoods' +
            'Date'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42370d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42370d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromName'
          Value = ''
          Component = FromGroupGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToName'
          Value = ''
          Component = ToGroupGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PageNum'
          Value = '1'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090'_'#1087#1086'_'#1074#1099#1093#1086#1076#1072#1084'('#1094#1077#1093')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090'_'#1087#1086'_'#1074#1099#1093#1086#1076#1072#1084'('#1094#1077#1093')'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintTRM_Group_gr: TdsdPrintAction
      Category = 'Print_gr'
      MoveParams = <>
      StoredProc = spPrint_TaxExitUpdate_groupTRM_gr
      StoredProcList = <
        item
          StoredProc = spPrint_TaxExitUpdate_groupTRM_gr
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1054#1090#1095#1077#1090' '#1087#1086' '#1074#1099#1093#1086#1076#1072#1084' ('#1090#1077#1088#1084#1080#1095#1082#1072') '#1075#1088#1091#1087#1087#1080#1088#1086#1074#1082#1072
      Hint = #1055#1077#1095#1072#1090#1100' '#1054#1090#1095#1077#1090' '#1087#1086' '#1074#1099#1093#1086#1076#1072#1084' ('#1090#1077#1088#1084#1080#1095#1082#1072') '#1075#1088#1091#1087#1087#1080#1088#1086#1074#1082#1072
      ImageIndex = 3
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 
            'GoodsGroupNameFull;GoodsCode;GoodsKindName_Complete;PartionGoods' +
            'Date'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42370d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42370d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromName'
          Value = ''
          Component = FromGroupGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToName'
          Value = ''
          Component = ToGroupGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PageNum'
          Value = '2'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090'_'#1087#1086'_'#1074#1099#1093#1086#1076#1072#1084'('#1090#1077#1088#1084#1080#1095#1082#1072')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090'_'#1087#1086'_'#1074#1099#1093#1086#1076#1072#1084'('#1090#1077#1088#1084#1080#1095#1082#1072')'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintTRM_Group: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spPrint_TaxExitUpdate_groupTRM
      StoredProcList = <
        item
          StoredProc = spPrint_TaxExitUpdate_groupTRM
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1054#1090#1095#1077#1090' '#1087#1086' '#1074#1099#1093#1086#1076#1072#1084' ('#1090#1077#1088#1084#1080#1095#1082#1072') '#1075#1088#1091#1087#1087#1080#1088#1086#1074#1082#1072
      Hint = #1055#1077#1095#1072#1090#1100' '#1054#1090#1095#1077#1090' '#1087#1086' '#1074#1099#1093#1086#1076#1072#1084' ('#1090#1077#1088#1084#1080#1095#1082#1072') '#1075#1088#1091#1087#1087#1080#1088#1086#1074#1082#1072
      ImageIndex = 3
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 
            'GoodsGroupNameFull;GoodsCode;GoodsKindName_Complete;PartionGoods' +
            'Date'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42370d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42370d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromName'
          Value = ''
          Component = FromGroupGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToName'
          Value = ''
          Component = ToGroupGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PageNum'
          Value = '2'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090'_'#1087#1086'_'#1074#1099#1093#1086#1076#1072#1084'('#1090#1077#1088#1084#1080#1095#1082#1072')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090'_'#1087#1086'_'#1074#1099#1093#1086#1076#1072#1084'('#1090#1077#1088#1084#1080#1095#1082#1072')'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintTRM: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100' '#1054#1090#1095#1077#1090' '#1087#1086' '#1074#1099#1093#1086#1076#1072#1084' ('#1090#1077#1088#1084#1080#1095#1082#1072')'
      Hint = #1055#1077#1095#1072#1090#1100' '#1054#1090#1095#1077#1090' '#1087#1086' '#1074#1099#1093#1086#1076#1072#1084' ('#1090#1077#1088#1084#1080#1095#1082#1072')'
      ImageIndex = 3
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 
            'GoodsGroupNameFull;GoodsCode;GoodsKindName_Complete;PartionGoods' +
            'Date'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42370d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42370d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromName'
          Value = ''
          Component = FromGroupGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToName'
          Value = ''
          Component = ToGroupGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PageNum'
          Value = '1'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090'_'#1087#1086'_'#1074#1099#1093#1086#1076#1072#1084'('#1090#1077#1088#1084#1080#1095#1082#1072')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090'_'#1087#1086'_'#1074#1099#1093#1086#1076#1072#1084'('#1090#1077#1088#1084#1080#1095#1082#1072')'
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
      Caption = #1055#1077#1095#1072#1090#1100' '#1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1091
      Hint = #1055#1077#1095#1072#1090#1100' '#1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1091
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 
            'GoodsGroupNameFull;GoodsCode;GoodsKindName_Complete;PartionGoods' +
            'Date'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromName'
          Value = Null
          Component = FromGroupGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToName'
          Value = Null
          Component = ToGroupGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090'_'#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086'_'#1058#1077#1093#1085#1086#1083#1086#1075'_new'
      ReportNameParam.Value = #1054#1090#1095#1077#1090'_'#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086'_'#1058#1077#1093#1085#1086#1083#1086#1075'_new'
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
      FormName = 'TReport_ProductionUnion_TaxExitUpdateDialogForm'
      FormNameParam.Value = 'TReport_ProductionUnion_TaxExitUpdateDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromGroupId'
          Value = ''
          Component = FromGroupGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromGroupName'
          Value = ''
          Component = FromGroupGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPartion'
          Value = False
          Component = cbisPartion
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToGroupId'
          Value = ''
          Component = ToGroupGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToGroupName'
          Value = ''
          Component = ToGroupGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'IsTerm'
          Value = Null
          Component = cbIsTerm
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actDelete_Object_Print: TdsdExecStoredProc
      Category = 'Print_gr'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spDelete_Object_Print
      StoredProcList = <
        item
          StoredProc = spDelete_Object_Print
        end>
      Caption = #1091#1076#1072#1083#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1075#1088#1080#1076#1072' '#1076#1083#1103' '#1087#1077#1095#1072#1090#1080
      ImageIndex = 74
    end
    object actReport_Goods: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' <'#1044#1077#1090#1072#1083#1100#1085#1086' '#1087#1086' '#1090#1086#1074#1072#1088#1091'>'
      Hint = #1054#1090#1095#1077#1090' <'#1044#1077#1090#1072#1083#1100#1085#1086' '#1087#1086' '#1090#1086#1074#1072#1088#1091'>'
      ImageIndex = 26
      FormName = 'TReport_GoodsForm'
      FormNameParam.Value = 'TReport_GoodsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 42370d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42370d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupId'
          Value = ''
          Component = FromGroupGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupName'
          Value = ''
          Component = FromGroupGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationId'
          Value = Null
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationName'
          Value = Null
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupId'
          Value = Null
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = Null
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
          Name = 'GoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'IsPartner'
          Value = True
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actPrint_byGrid: TdsdExecStoredProc
      Category = 'Print_gr'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertPrint_byGrid
      StoredProcList = <
        item
          StoredProc = spInsertPrint_byGrid
        end>
      Caption = #1089#1086#1093#1088#1072#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1075#1088#1080#1076#1072' '#1076#1083#1103' '#1087#1077#1095#1072#1090#1080
      ImageIndex = 74
    end
    object actPrint_byGrid_list: TMultiAction
      Category = 'Print_gr'
      MoveParams = <>
      ActionList = <
        item
          Action = actPrint_byGrid
        end>
      View = cxGridDBTableView
      Caption = 'actPrint_byGrid_list'
      ImageIndex = 74
    end
    object macPrintCEH_Group_gr: TMultiAction
      Category = 'Print_gr'
      MoveParams = <>
      ActionList = <
        item
          Action = actDelete_Object_Print
        end
        item
          Action = actPrint_byGrid_list
        end
        item
          Action = actPrintCEH_Group_gr
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1074#1099#1073#1086#1088#1086#1095#1085#1072#1103' '#1054#1090#1095#1077#1090' '#1087#1086' '#1074#1099#1093#1086#1076#1072#1084' ('#1094#1077#1093') '#1075#1088#1091#1087#1087#1080#1088#1086#1074#1082#1072
      Hint = #1055#1077#1095#1072#1090#1100' '#1074#1099#1073#1086#1088#1086#1095#1085#1072#1103' '#1054#1090#1095#1077#1090' '#1087#1086' '#1074#1099#1093#1086#1076#1072#1084' ('#1094#1077#1093') '#1075#1088#1091#1087#1087#1080#1088#1086#1074#1082#1072
      ImageIndex = 3
    end
  end
  inherited MasterDS: TDataSource
    Left = 72
    Top = 208
  end
  inherited MasterCDS: TClientDataSet
    Left = 40
    Top = 208
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_ProductionUnion_TaxExitUpdate'
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
        Value = Null
        Component = FromGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = Null
        Component = ToGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParam'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsList'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsListReport'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPartion'
        Value = Null
        Component = cbisPartion
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsTerm'
        Value = Null
        Component = cbIsTerm
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 112
    Top = 208
  end
  inherited BarManager: TdxBarManager
    Left = 160
    Top = 208
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
          ItemName = 'bbReport_Goods'
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
          ItemName = 'bbsPrint'
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
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
    end
    object bbPrint: TdxBarButton
      Action = actPrint
      Caption = #1055#1077#1095#1072#1090#1100' '#1054#1090#1095#1077#1090' '#1087#1086' '#1074#1099#1093#1086#1076#1072#1084' ('#1044#1077#1083#1080#1082#1072#1090#1077#1089#1099')'
      Category = 0
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbReport_Goods: TdxBarButton
      Action = actReport_Goods
      Category = 0
    end
    object bbPrintTRM: TdxBarButton
      Action = actPrintTRM
      Category = 0
      ImageIndex = 16
    end
    object bbPrintCEH: TdxBarButton
      Action = actPrintCEH
      Category = 0
      ImageIndex = 17
    end
    object bbPrintOUT: TdxBarButton
      Action = actPrintOUT
      Category = 0
    end
    object bbsPrint: TdxBarSubItem
      Caption = #1055#1077#1095#1072#1090#1100
      Category = 0
      Visible = ivAlways
      ImageIndex = 3
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbPrint'
        end
        item
          Visible = True
          ItemName = 'bbxBarSeparator'
        end
        item
          Visible = True
          ItemName = 'bbPrintCEH'
        end
        item
          Visible = True
          ItemName = 'bbPrintTRM'
        end
        item
          Visible = True
          ItemName = 'bbPrintOUT'
        end
        item
          Visible = True
          ItemName = 'bbxBarSeparator'
        end
        item
          Visible = True
          ItemName = 'bbPrintCEH_Group'
        end
        item
          Visible = True
          ItemName = 'bbPrintTRM_Group'
        end
        item
          Visible = True
          ItemName = 'bbxBarSeparator'
        end
        item
          Visible = True
          ItemName = 'bbmacPrintCEH_Group_gr'
        end
        item
          Visible = True
          ItemName = 'bbmacPrintTRM_Group_gr'
        end>
    end
    object bbxBarSeparator: TdxBarSeparator
      Caption = 'Separator'
      Category = 0
      Hint = 'Separator'
      Visible = ivAlways
      ShowCaption = False
    end
    object bbPrintCEH_Group: TdxBarButton
      Action = actPrintCEH_Group
      Category = 0
      ImageIndex = 17
    end
    object bbPrintTRM_Group: TdxBarButton
      Action = actPrintTRM_Group
      Category = 0
      ImageIndex = 16
    end
    object bbmacPrintCEH_Group_gr: TdxBarButton
      Action = macPrintCEH_Group_gr
      Category = 0
    end
    object bbmacPrintTRM_Group_gr: TdxBarButton
      Action = macPrintTRM_Group_gr
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 320
    Top = 232
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 168
    Top = 264
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = FromGroupGuides
      end
      item
        Component = ToGroupGuides
      end
      item
      end
      item
      end
      item
      end
      item
      end
      item
      end
      item
      end>
    Left = 232
    Top = 208
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'InDescName'
        Value = ''
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGroupMovement'
        Value = Null
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Id'
        Value = '1'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 328
    Top = 170
  end
  object FromGroupGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edFromGroup
    FormNameParam.Value = 'TUnitTreeForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnitTreeForm'
    PositionDataSet = 'ClientDataSet'
    ParentDataSet = 'TreeDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = FromGroupGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = FromGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 408
  end
  object ToGroupGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edToGroup
    FormNameParam.Value = 'TUnitTreeForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnitTreeForm'
    PositionDataSet = 'ClientDataSet'
    ParentDataSet = 'TreeDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ToGroupGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ToGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 464
    Top = 24
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 748
    Top = 214
  end
  object spPrint_TaxExitUpdate_groupCeh: TdsdStoredProc
    StoredProcName = 'gpReport_ProductionUnion_TaxExitUpdate'
    DataSet = PrintItemsCDS
    DataSets = <
      item
        DataSet = PrintItemsCDS
      end>
    Params = <
      item
        Name = 'inStartDate'
        Value = 43831d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 43831d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFromId'
        Value = ''
        Component = FromGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = ''
        Component = ToGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isParam'
        Value = '1'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisList'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsListReport'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPartion'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsTerm'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 872
    Top = 209
  end
  object spPrint_TaxExitUpdate_groupTRM: TdsdStoredProc
    StoredProcName = 'gpReport_ProductionUnion_TaxExitUpdate'
    DataSet = PrintItemsCDS
    DataSets = <
      item
        DataSet = PrintItemsCDS
      end>
    Params = <
      item
        Name = 'inStartDate'
        Value = 43831d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 43831d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFromId'
        Value = ''
        Component = FromGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = ''
        Component = ToGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isParam'
        Value = '2'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisList'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsListReport'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPartion'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsTerm'
        Value = True
        Component = cbIsTerm
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 872
    Top = 257
  end
  object spDelete_Object_Print: TdsdStoredProc
    StoredProcName = 'gpDelete_Object_Print_byUser'
    DataSets = <>
    OutputType = otResult
    Params = <>
    PackSize = 1
    Left = 1016
    Top = 3
  end
  object spInsertPrint_byGrid: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_PrintGrid'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReportKindId'
        Value = '1'
        Component = MasterCDS
        ComponentItem = 'GoodsKindId_Complete'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValueDate'
        Value = 42132d
        Component = MasterCDS
        ComponentItem = 'PartionGoodsDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 848
    Top = 19
  end
  object spPrint_TaxExitUpdate_groupCeh_gr: TdsdStoredProc
    StoredProcName = 'gpReport_ProductionUnion_TaxExitUpdate'
    DataSet = PrintItemsCDS
    DataSets = <
      item
        DataSet = PrintItemsCDS
      end>
    Params = <
      item
        Name = 'inStartDate'
        Value = 42370d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 42370d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFromId'
        Value = ''
        Component = FromGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = ''
        Component = ToGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isParam'
        Value = '1'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisList'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsListReport'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPartion'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsTerm'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1016
    Top = 209
  end
  object spPrint_TaxExitUpdate_groupTRM_gr: TdsdStoredProc
    StoredProcName = 'gpReport_ProductionUnion_TaxExitUpdate'
    DataSet = PrintItemsCDS
    DataSets = <
      item
        DataSet = PrintItemsCDS
      end>
    Params = <
      item
        Name = 'inStartDate'
        Value = 42370d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 42370d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFromId'
        Value = ''
        Component = FromGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = ''
        Component = ToGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isParam'
        Value = '2'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisList'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsListReport'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPartion'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsTerm'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1016
    Top = 257
  end
end
