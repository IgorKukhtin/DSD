inherited Report_ReceiptProductionOutAnalyzeTestForm: TReport_ReceiptProductionOutAnalyzeTestForm
  Caption = #1054#1090#1095#1077#1090' <'#1040#1085#1072#1083#1080#1079' '#1087#1083#1072#1085'/'#1092#1072#1082#1090' '#1088#1072#1089#1093#1086#1076' '#1085#1072' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086'> Test'
  ClientHeight = 430
  ClientWidth = 1130
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 1146
  ExplicitHeight = 465
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 83
    Width = 1130
    Height = 347
    TabOrder = 3
    ExplicitTop = 83
    ExplicitWidth = 1130
    ExplicitHeight = 347
    ClientRectBottom = 347
    ClientRectRight = 1130
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1130
      ExplicitHeight = 347
      inherited cxGrid: TcxGrid
        Width = 1130
        Height = 347
        ExplicitWidth = 1130
        ExplicitHeight = 347
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCount_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCountPlan
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCountPlan_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperSumm
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperSummPlan1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperSummPlan2
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperSummPlan3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperSummPlan1_real
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperSummPlan2_real
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperSummPlan3_real
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperSummPlan_real
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CuterCount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCount_gp_real
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCount_gp_plan
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCount_ReWork
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCountPlan_two
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCountPlan_Weight_two
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperSummPlan_real_two
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperSummPlan1_two
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperSummPlan2_two
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperSummPlan3_two
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCount_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCountPlan
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCountPlan_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperSumm
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperSummPlan1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperSummPlan2
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperSummPlan3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperSummPlan1_real
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperSummPlan2_real
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperSummPlan3_real
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperSummPlan_real
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CuterCount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCount_gp_real
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCount_gp_plan
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCount_ReWork
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCountPlan_two
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCountPlan_Weight_two
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperSummPlan_real_two
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperSummPlan1_two
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperSummPlan2_two
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperSummPlan3_two
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
            Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
            DataBinding.FieldName = 'GoodsGroupNameFull'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 150
          end
          object GoodsGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072
            DataBinding.FieldName = 'GoodsGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1090#1086#1074'.'
            DataBinding.FieldName = 'GoodsCode'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = '0.;-0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' ('#1088#1072#1089#1093#1086#1076')'
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 200
          end
          object GoodsKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object GoodsKindName_complete: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' '#1043#1055
            DataBinding.FieldName = 'GoodsKindName_complete'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object PartionGoodsDate: TcxGridDBColumn
            Caption = #1055#1072#1088#1090#1080#1103
            DataBinding.FieldName = 'PartionGoodsDate'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object MeasureName: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 40
          end
          object OperCount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1092#1072#1082#1090
            DataBinding.FieldName = 'OperCount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object OperCount_Weight: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1092#1072#1082#1090' ('#1074#1077#1089')'
            DataBinding.FieldName = 'OperCount_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Price: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1092#1072#1082#1090
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object OperSumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1092#1072#1082#1090
            DataBinding.FieldName = 'OperSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object OperCountPlan: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1087#1083#1072#1085'1'
            DataBinding.FieldName = 'OperCountPlan'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1087#1083#1072#1085'1 ('#1085#1072' '#1074#1077#1089' '#1089#1099#1088#1086#1075#1086')'
            Width = 70
          end
          object OperCountPlan_Weight: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1087#1083#1072#1085'1 ('#1074#1077#1089')'
            DataBinding.FieldName = 'OperCountPlan_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1087#1083#1072#1085'1 ('#1074#1077#1089') ('#1085#1072' '#1074#1077#1089' '#1089#1099#1088#1086#1075#1086')'
            Width = 70
          end
          object OperCountPlan_two: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1087#1083#1072#1085'2'
            DataBinding.FieldName = 'OperCountPlan_two'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1087#1083#1072#1085'2 ('#1085#1072' '#1082#1091#1090#1090#1077#1088')'
            Width = 70
          end
          object OperCountPlan_Weight_two: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1087#1083#1072#1085'2 ('#1074#1077#1089')'
            DataBinding.FieldName = 'OperCountPlan_Weight_two'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1087#1083#1072#1085'2 ('#1074#1077#1089') ('#1085#1072' '#1082#1091#1090#1090#1077#1088')'
            Width = 70
          end
          object PricePlan1: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1055#1088#1072#1081#1089'1'
            DataBinding.FieldName = 'PricePlan1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object PricePlan2: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1055#1088#1072#1081#1089'2'
            DataBinding.FieldName = 'PricePlan2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object PricePlan3: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1055#1088#1072#1081#1089'3'
            DataBinding.FieldName = 'PricePlan3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object OperSummPlan_real: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1083'.1 '#1092#1072#1082#1090' '#1094#1077#1085#1072
            DataBinding.FieldName = 'OperSummPlan_real'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1087#1083'.1 '#1092#1072#1082#1090' '#1094#1077#1085#1072' ('#1085#1072' '#1074#1077#1089' '#1089#1099#1088#1086#1075#1086')'
            Width = 70
          end
          object OperSummPlan_real_two: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1083'.2 '#1092#1072#1082#1090' '#1094#1077#1085#1072
            DataBinding.FieldName = 'OperSummPlan_real_two'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1087#1083'.2 '#1092#1072#1082#1090' '#1094#1077#1085#1072' ('#1085#1072' '#1082#1091#1090#1090#1077#1088')'
            Width = 70
          end
          object OperSummPlan1: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1083'.1 '#1055#1088#1072#1081#1089'1'
            DataBinding.FieldName = 'OperSummPlan1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1085#1072' '#1074#1077#1089' '#1089#1099#1088#1086#1075#1086
            Options.Editing = False
            Width = 80
          end
          object OperSummPlan2: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1083'.1 '#1055#1088#1072#1081#1089'2'
            DataBinding.FieldName = 'OperSummPlan2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1085#1072' '#1074#1077#1089' '#1089#1099#1088#1086#1075#1086
            Options.Editing = False
            Width = 80
          end
          object OperSummPlan3: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1083'.1 '#1055#1088#1072#1081#1089'3'
            DataBinding.FieldName = 'OperSummPlan3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1085#1072' '#1074#1077#1089' '#1089#1099#1088#1086#1075#1086
            Options.Editing = False
            Width = 80
          end
          object OperSummPlan1_two: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1083'.2 '#1055#1088#1072#1081#1089'1'
            DataBinding.FieldName = 'OperSummPlan1_two'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1085#1072' '#1082#1091#1090#1090#1077#1088
            Width = 80
          end
          object OperSummPlan2_two: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1083'.2 '#1055#1088#1072#1081#1089'2'
            DataBinding.FieldName = 'OperSummPlan2_two'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1085#1072' '#1082#1091#1090#1090#1077#1088
            Width = 80
          end
          object OperSummPlan3_two: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1083'.2 '#1055#1088#1072#1081#1089'3'
            DataBinding.FieldName = 'OperSummPlan3_two'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1085#1072' '#1082#1091#1090#1090#1077#1088
            Width = 80
          end
          object OperSummPlan1_real: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1092'. '#1055#1088#1072#1081#1089'1'
            DataBinding.FieldName = 'OperSummPlan1_real'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object OperSummPlan2_real: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1092'. '#1055#1088#1072#1081#1089'2'
            DataBinding.FieldName = 'OperSummPlan2_real'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object OperSummPlan3_real: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1092'. '#1055#1088#1072#1081#1089'3'
            DataBinding.FieldName = 'OperSummPlan3_real'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object CuterCount: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1082#1091#1090#1090#1077#1088#1086#1074
            DataBinding.FieldName = 'CuterCount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object OperCount_gp_real: TcxGridDBColumn
            Caption = #1055#1088#1080#1093#1086#1076' '#1043#1055' '#1092#1072#1082#1090' '#1074#1077#1089' ('#1080#1090#1086#1075')'
            DataBinding.FieldName = 'OperCount_gp_real'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object OperCount_gp_plan: TcxGridDBColumn
            Caption = #1055#1088#1080#1093#1086#1076' '#1043#1055' '#1087#1083#1072#1085' '#1074#1077#1089' ('#1080#1090#1086#1075')'
            DataBinding.FieldName = 'OperCount_gp_plan'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object OperCount_ReWork: TcxGridDBColumn
            Caption = #1056#1072#1089#1093#1086#1076' '#1087#1077#1088#1077#1088#1072#1073#1086#1090#1082#1080' ('#1080#1090#1086#1075')'
            DataBinding.FieldName = 'OperCount_ReWork'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object LossGP_real: TcxGridDBColumn
            Caption = '% '#1087#1086#1090#1077#1088#1100' '#1092#1072#1082#1090
            DataBinding.FieldName = 'LossGP_real'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object LossGP_plan: TcxGridDBColumn
            Caption = '% '#1087#1086#1090#1077#1088#1100' '#1087#1083#1072#1085'1'
            DataBinding.FieldName = 'LossGP_plan'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1085#1072' '#1074#1077#1089' '#1089#1099#1088#1086#1075#1086
            Width = 55
          end
          object LossGP_plan_two: TcxGridDBColumn
            Caption = '% '#1087#1086#1090#1077#1088#1100' '#1087#1083#1072#1085'2'
            DataBinding.FieldName = 'LossGP_plan_two'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1085#1072' '#1082#1091#1090#1090#1077#1088
            Width = 55
          end
          object TaxGP_real: TcxGridDBColumn
            Caption = '% '#1074#1099#1093'. '#1092#1072#1082#1090
            DataBinding.FieldName = 'TaxGP_real'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object TaxGP_plan: TcxGridDBColumn
            Caption = '% '#1074#1099#1093'. '#1087#1083#1072#1085
            DataBinding.FieldName = 'TaxGP_plan'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object Price_sale: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1087#1088#1072#1081#1089' '#1088#1077#1072#1083#1080#1079'.'
            DataBinding.FieldName = 'Price_sale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object TaxSumm_min: TcxGridDBColumn
            Caption = '% '#1076#1086#1083#1103' '#1074' '#1089'/'#1089' '#1086#1090
            DataBinding.FieldName = 'TaxSumm_min'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object TaxSumm_max: TcxGridDBColumn
            Caption = '% '#1076#1086#1083#1103' '#1074' '#1089'/'#1089' '#1076#1086
            DataBinding.FieldName = 'TaxSumm_max'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object InfoMoneyCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1059#1055
            DataBinding.FieldName = 'InfoMoneyCode'
            Visible = False
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
            Width = 80
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
          object InfoMoneyName: TcxGridDBColumn
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 150
          end
          object GoodsId: TcxGridDBColumn
            DataBinding.FieldName = 'GoodsId'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            VisibleForCustomization = False
            Width = 55
          end
          object GoodsKindId: TcxGridDBColumn
            DataBinding.FieldName = 'GoodsKindId'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            VisibleForCustomization = False
            Width = 55
          end
          object MasterKey: TcxGridDBColumn
            DataBinding.FieldName = 'MasterKey'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
        end
        object ChildView: TcxGridDBTableView [1]
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = ChildDS
          DataController.DetailKeyFieldNames = 'MasterKey'
          DataController.MasterKeyFieldNames = 'MasterKey'
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCountIn_Weight_ch
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperSummIn_ch
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCount_ch
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCount_Weight_ch
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperSumm_ch
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCountPlan_ch
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCountPlan_Weight_ch
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperSummPlan1_ch
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperSummPlan2_ch
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperSummPlan3_ch
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperSummPlan1_real_ch
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperSummPlan2_real_ch
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperSummPlan3_real_ch
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperSummPlan_real_ch
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperSummPlan_real_two_ch
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCountPlan_two_ch
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCountPlan_Weight_two_ch
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperSummPlan1_two_ch
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperSummPlan2_two_ch
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperSummPlan3_two_ch
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCountIn_Weight_ch
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperSummIn_ch
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCount_ch
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCount_Weight_ch
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperSumm_ch
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCountPlan_ch
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCountPlan_Weight_ch
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperSummPlan1_ch
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperSummPlan2_ch
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperSummPlan3_ch
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperSummPlan1_real_ch
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperSummPlan2_real_ch
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperSummPlan3_real_ch
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperSummPlan_real_ch
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperSummPlan_real_two_ch
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCountPlan_two_ch
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCountPlan_Weight_two_ch
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperSummPlan1_two_ch
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperSummPlan2_two_ch
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperSummPlan3_two_ch
            end>
          DataController.Summary.SummaryGroups = <>
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsData.Inserting = False
          OptionsView.ColumnAutoWidth = True
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.GroupFooters = gfVisibleWhenExpanded
          OptionsView.HeaderAutoHeight = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object Code_ch: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'Code'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object ReceiptCode_ch: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1088#1077#1094#1077#1087#1090'.'
            DataBinding.FieldName = 'ReceiptCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object TradeMarkName_ch: TcxGridDBColumn
            Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072
            DataBinding.FieldName = 'TradeMarkName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object GoodsGroupAnalystName_ch: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1072#1085#1072#1083#1080#1090#1080#1082#1080
            DataBinding.FieldName = 'GoodsGroupAnalystName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object GoodsTagName_ch: TcxGridDBColumn
            Caption = #1055#1088#1080#1079#1085#1072#1082' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsTagName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object GoodsGroupNameFull_ch: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
            DataBinding.FieldName = 'GoodsGroupNameFull'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object GoodsCode_ch: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1090#1086#1074'.'
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object GoodsName_ch: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' ('#1087#1088#1080#1093#1086#1076')'
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 140
          end
          object GoodsKindName_ch: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object GoodsKindName_complete_ch: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' '#1043#1055
            DataBinding.FieldName = 'GoodsKindName_complete'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object PartionGoodsDate_ch: TcxGridDBColumn
            Caption = #1055#1072#1088#1090#1080#1103
            DataBinding.FieldName = 'PartionGoodsDate'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object MeasureName_ch: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 40
          end
          object isMain_ch: TcxGridDBColumn
            Caption = #1043#1083#1072#1074#1085'.'
            DataBinding.FieldName = 'isMain'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object Comment_ch: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 108
          end
          object OperCountIn_ch: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1087#1088#1080#1093#1086#1076
            DataBinding.FieldName = 'OperCountIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object OperCountIn_Weight_ch: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1087#1088#1080#1093#1086#1076' ('#1074#1077#1089')'
            DataBinding.FieldName = 'OperCountIn_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object PriceIn_ch: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1089'/'#1089' '#1087#1088#1080#1093#1086#1076
            DataBinding.FieldName = 'PriceIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object OperSummIn_ch: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089'/'#1089' '#1087#1088#1080#1093#1086#1076
            DataBinding.FieldName = 'OperSummIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object TaxSumm_ch: TcxGridDBColumn
            Caption = '% '#1076#1086#1083#1103' '#1074' '#1089'/'#1089
            DataBinding.FieldName = 'TaxSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object OperCount_ch: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1092#1072#1082#1090' '#1088#1072#1089#1093'.'
            DataBinding.FieldName = 'OperCount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object OperCount_Weight_ch: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1092#1072#1082#1090' '#1088#1072#1089#1093'. ('#1074#1077#1089')'
            DataBinding.FieldName = 'OperCount_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Price_ch: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1092#1072#1082#1090' '#1088#1072#1089#1093'.'
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object OperSumm_ch: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1092#1072#1082#1090' '#1088#1072#1089#1093'.'
            DataBinding.FieldName = 'OperSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object OperCountPlan_ch: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1087#1083#1072#1085'1 '#1088#1072#1089#1093'.'
            DataBinding.FieldName = 'OperCountPlan'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1085#1072' '#1074#1077#1089' '#1089#1099#1088#1086#1075#1086
            Width = 70
          end
          object OperCountPlan_Weight_ch: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1087#1083#1072#1085'1 '#1088#1072#1089#1093'. ('#1074#1077#1089')'
            DataBinding.FieldName = 'OperCountPlan_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1085#1072' '#1074#1077#1089' '#1089#1099#1088#1086#1075#1086
            Width = 70
          end
          object OperCountPlan_two_ch: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1087#1083#1072#1085'2 '#1088#1072#1089#1093'.'
            DataBinding.FieldName = 'OperCountPlan_two'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1085#1072' '#1082#1091#1090#1090#1077#1088
            Width = 80
          end
          object OperCountPlan_Weight_two_ch: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1087#1083#1072#1085'2 '#1088#1072#1089#1093'. ('#1074#1077#1089')'
            DataBinding.FieldName = 'OperCountPlan_Weight_two'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1085#1072' '#1082#1091#1090#1090#1077#1088
            Width = 80
          end
          object OperSummPlan_real_ch: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1083'.1 '#1092#1072#1082#1090' '#1094#1077#1085#1072
            DataBinding.FieldName = 'OperSummPlan_real'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1085#1072' '#1074#1077#1089' '#1089#1099#1088#1086#1075#1086
            Width = 70
          end
          object OperSummPlan_real_two_ch: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1083'.1 '#1092#1072#1082#1090' '#1094#1077#1085#1072
            DataBinding.FieldName = 'OperSummPlan_real_two'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1085#1072' '#1082#1091#1090#1090#1077#1088
            Width = 70
          end
          object OperSummPlan1_ch: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1083'.1 '#1055#1088#1072#1081#1089'1'
            DataBinding.FieldName = 'OperSummPlan1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1085#1072' '#1074#1077#1089' '#1089#1099#1088#1086#1075#1086
            Options.Editing = False
            Width = 80
          end
          object OperSummPlan2_ch: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1083'.1 '#1055#1088#1072#1081#1089'2'
            DataBinding.FieldName = 'OperSummPlan2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1085#1072' '#1074#1077#1089' '#1089#1099#1088#1086#1075#1086
            Options.Editing = False
            Width = 80
          end
          object OperSummPlan3_ch: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1083'.1 '#1055#1088#1072#1081#1089'3'
            DataBinding.FieldName = 'OperSummPlan3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1085#1072' '#1074#1077#1089' '#1089#1099#1088#1086#1075#1086
            Options.Editing = False
            Width = 80
          end
          object OperSummPlan1_two_ch: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1083'.2 '#1055#1088#1072#1081#1089'1'
            DataBinding.FieldName = 'OperSummPlan1_two'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1085#1072' '#1082#1091#1090#1090#1077#1088
            Width = 80
          end
          object OperSummPlan2_two_ch: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1083'.2 '#1055#1088#1072#1081#1089'2'
            DataBinding.FieldName = 'OperSummPlan2_two'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1085#1072' '#1082#1091#1090#1090#1077#1088
            Width = 80
          end
          object OperSummPlan3_two_ch: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1083'.2 '#1055#1088#1072#1081#1089'3'
            DataBinding.FieldName = 'OperSummPlan3_two'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1085#1072' '#1082#1091#1090#1090#1077#1088
            Width = 80
          end
          object OperSummPlan1_real_ch: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1092'. '#1055#1088#1072#1081#1089'1'
            DataBinding.FieldName = 'OperSummPlan1_real'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object OperSummPlan2_real_ch: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1092'. '#1055#1088#1072#1081#1089'2'
            DataBinding.FieldName = 'OperSummPlan2_real'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object OperSummPlan3_real_ch: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1092'. '#1055#1088#1072#1081#1089'3'
            DataBinding.FieldName = 'OperSummPlan3_real'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object GoodsId_ch: TcxGridDBColumn
            DataBinding.FieldName = 'GoodsId'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 55
          end
          object GoodsKindId_ch: TcxGridDBColumn
            DataBinding.FieldName = 'GoodsKindId'
            Visible = False
            VisibleForCustomization = False
            Width = 55
          end
          object MasterKey_ch: TcxGridDBColumn
            DataBinding.FieldName = 'MasterKey'
            Visible = False
            Width = 55
          end
        end
        inherited cxGridLevel: TcxGridLevel
          object cxGridLevel1: TcxGridLevel
            GridView = ChildView
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1130
    Height = 57
    ExplicitWidth = 1130
    ExplicitHeight = 57
    inherited deStart: TcxDateEdit
      Left = 118
      Top = 7
      EditValue = 42186d
      ExplicitLeft = 118
      ExplicitTop = 7
    end
    inherited deEnd: TcxDateEdit
      Left = 118
      Top = 32
      EditValue = 42186d
      ExplicitLeft = 118
      ExplicitTop = 32
    end
    inherited cxLabel1: TcxLabel
      Left = 27
      Top = 8
      ExplicitLeft = 27
      ExplicitTop = 8
    end
    inherited cxLabel2: TcxLabel
      Left = 8
      Top = 33
      ExplicitLeft = 8
      ExplicitTop = 33
    end
    object cxLabel4: TcxLabel
      Left = 951
      Top = 5
      Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1086#1074':'
    end
    object edGoodsGroup: TcxButtonEdit
      Left = 951
      Top = 29
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 5
      Width = 171
    end
    object cxLabel3: TcxLabel
      Left = 206
      Top = 6
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1086#1090' '#1082#1086#1075#1086'):'
    end
    object edFromUnit: TcxButtonEdit
      Left = 347
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 169
    end
    object cxLabel5: TcxLabel
      Left = 220
      Top = 29
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1082#1086#1084#1091'):'
    end
    object edToUnit: TcxButtonEdit
      Left = 347
      Top = 29
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 9
      Width = 169
    end
    object cxLabel11: TcxLabel
      Left = 519
      Top = 6
      Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090' 1'
    end
    object edPriceList_1: TcxButtonEdit
      Left = 588
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 11
      Width = 125
    end
    object cxLabel6: TcxLabel
      Left = 520
      Top = 32
      Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090' 2'
    end
    object edPriceList_2: TcxButtonEdit
      Left = 588
      Top = 31
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 13
      Width = 125
    end
    object cxLabel7: TcxLabel
      Left = 713
      Top = 6
      Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090' 3'
    end
    object edPriceList_3: TcxButtonEdit
      Left = 821
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 15
      Width = 125
    end
    object cxLabel8: TcxLabel
      Left = 712
      Top = 31
      Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090' '#1087#1088#1086#1076#1072#1078#1072
    end
    object edPriceList_sale: TcxButtonEdit
      Left = 822
      Top = 30
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 17
      Width = 125
    end
  end
  object cbPartionGoods: TcxCheckBox [2]
    Left = 53
    Top = 95
    Caption = #1087#1086' '#1055#1072#1088#1090#1080#1103#1084
    Properties.ReadOnly = False
    TabOrder = 6
    Width = 92
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = cbPartionGoods
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
        Component = FromUnitGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GoodsGroupGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = PriceList_1_Guides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = PriceList_2_Guides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = PriceList_3_Guides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = PriceList_sale_Guides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = ToUnitGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end>
  end
  inherited ActionList: TActionList
    object actPrint_fact: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.ComponentItem = 'id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = '0'
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = 42186d
          FromParam.Component = deStart
          FromParam.DataType = ftDateTime
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'StartDate'
          ToParam.Value = 'NULL'
          ToParam.DataType = ftDateTime
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = 42186d
          FromParam.Component = deEnd
          FromParam.DataType = ftDateTime
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'EndDate'
          ToParam.Value = 'NULL'
          ToParam.DataType = ftDateTime
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProcList = <>
      Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' '#1060#1072#1082#1090'1 '#1088#1072#1089#1093#1086#1076' '#1089#1099#1088#1100#1103
      Hint = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' '#1060#1072#1082#1090'1 '#1088#1072#1089#1093#1086#1076' '#1089#1099#1088#1100#1103
      ImageIndex = 22
      ShortCut = 16464
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GoodsGroupNameFull;GoodsName;GoodsKindName'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42186d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42186d
          Component = deEnd
          DataType = ftDateTime
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
          Name = 'isPartionGoods'
          Value = False
          Component = cbPartionGoods
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromName'
          Value = ''
          Component = FromUnitGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToName'
          Value = ''
          Component = ToUnitGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Num_two'
          Value = 1
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' '#1060#1072#1082#1090' '#1088#1072#1089#1093#1086#1076' '#1089#1099#1088#1100#1103
      ReportNameParam.Value = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' '#1060#1072#1082#1090' '#1088#1072#1089#1093#1086#1076' '#1089#1099#1088#1100#1103
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
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
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = 42186d
          FromParam.Component = deStart
          FromParam.DataType = ftDateTime
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'StartDate'
          ToParam.Value = 'NULL'
          ToParam.DataType = ftDateTime
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = 42186d
          FromParam.Component = deEnd
          FromParam.DataType = ftDateTime
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'EndDate'
          ToParam.Value = 'NULL'
          ToParam.DataType = ftDateTime
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProcList = <>
      Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' '#1055#1083#1072#1085'1/'#1060#1072#1082#1090' '#1088#1072#1089#1093#1086#1076' '#1089#1099#1088#1100#1103
      Hint = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' '#1055#1083#1072#1085'1/'#1060#1072#1082#1090' '#1088#1072#1089#1093#1086#1076' '#1089#1099#1088#1100#1103
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GoodsGroupNameFull;GoodsName;GoodsKindName'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42186d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42186d
          Component = deEnd
          DataType = ftDateTime
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
          Name = 'isPartionGoods'
          Value = False
          Component = cbPartionGoods
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromName'
          Value = Null
          Component = FromUnitGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToName'
          Value = Null
          Component = ToUnitGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Num_two'
          Value = 1
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' '#1055#1083#1072#1085' '#1080' '#1060#1072#1082#1090' '#1088#1072#1089#1093#1086#1076' '#1089#1099#1088#1100#1103
      ReportNameParam.Value = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' '#1055#1083#1072#1085' '#1080' '#1060#1072#1082#1090' '#1088#1072#1089#1093#1086#1076' '#1089#1099#1088#1100#1103
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint_Reserve: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.ComponentItem = 'id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = '0'
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = 42186d
          FromParam.Component = deStart
          FromParam.DataType = ftDateTime
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'StartDate'
          ToParam.Value = 'NULL'
          ToParam.DataType = ftDateTime
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = 42186d
          FromParam.Component = deEnd
          FromParam.DataType = ftDateTime
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'EndDate'
          ToParam.Value = 'NULL'
          ToParam.DataType = ftDateTime
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProcList = <>
      Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' '#1055#1083#1072#1085'/'#1060#1072#1082#1090' '#1079#1072#1087#1072#1089' '#1094#1077#1085
      Hint = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' '#1055#1083#1072#1085'/'#1060#1072#1082#1090' '#1079#1072#1087#1072#1089' '#1094#1077#1085
      ImageIndex = 17
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GoodsGroupNameFull;GoodsName;GoodsKindName'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42186d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42186d
          Component = deEnd
          DataType = ftDateTime
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
          Name = 'isPartionGoods'
          Value = False
          Component = cbPartionGoods
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromName'
          Value = Null
          Component = FromUnitGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToName'
          Value = Null
          Component = ToUnitGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' '#1055#1083#1072#1085' '#1080' '#1060#1072#1082#1090' '#1079#1072#1087#1072#1089' '#1094#1077#1085
      ReportNameParam.Value = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' '#1055#1083#1072#1085' '#1080' '#1060#1072#1082#1090' '#1079#1072#1087#1072#1089' '#1094#1077#1085
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint_TaxReal: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.ComponentItem = 'id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = '0'
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = 42186d
          FromParam.Component = deStart
          FromParam.DataType = ftDateTime
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'StartDate'
          ToParam.Value = 'NULL'
          ToParam.DataType = ftDateTime
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = 42186d
          FromParam.Component = deEnd
          FromParam.DataType = ftDateTime
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'EndDate'
          ToParam.Value = 'NULL'
          ToParam.DataType = ftDateTime
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProcList = <>
      Caption = #1040#1085#1072#1083#1080#1079' '#1074#1099#1093#1086#1076#1086#1074' '#1043#1055
      Hint = #1040#1085#1072#1083#1080#1079' '#1074#1099#1093#1086#1076#1086#1074' '#1043#1055
      ImageIndex = 21
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GoodsGroupNameFull;GoodsName;GoodsKindName'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42186d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42186d
          Component = deEnd
          DataType = ftDateTime
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
          Name = 'isPartionGoods'
          Value = False
          Component = cbPartionGoods
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromName'
          Value = Null
          Component = FromUnitGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToName'
          Value = Null
          Component = ToUnitGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' '#1080' '#1087#1088#1086#1094#1077#1085#1090' '#1074#1099#1093#1086#1076#1072' ('#1040#1085#1072#1083#1080#1079')'
      ReportNameParam.Value = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' '#1080' '#1087#1088#1086#1094#1077#1085#1090' '#1074#1099#1093#1086#1076#1072' ('#1040#1085#1072#1083#1080#1079')'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
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
      FormName = 'TReport_ReceiptProductionOutAnalyzeDialogForm'
      FormNameParam.Value = 'TReport_ReceiptProductionOutAnalyzeDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 42186d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42186d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromUnitId'
          Value = ''
          Component = FromUnitGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromUnitName'
          Value = ''
          Component = FromUnitGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToUnitId'
          Value = ''
          Component = ToUnitGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToUnitName'
          Value = ''
          Component = ToUnitGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PriceListId_1'
          Value = ''
          Component = PriceList_1_Guides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PriceList_1_Name'
          Value = ''
          Component = PriceList_1_Guides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PriceListId_2'
          Value = ''
          Component = PriceList_2_Guides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PriceList_2_Name'
          Value = ''
          Component = PriceList_2_Guides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PriceListId_3'
          Value = ''
          Component = PriceList_3_Guides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PriceList_3_Name'
          Value = ''
          Component = PriceList_3_Guides
          ComponentItem = 'TextValue'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PriceListId_sale'
          Value = ''
          Component = PriceList_sale_Guides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PriceList_sale_Name'
          Value = ''
          Component = PriceList_sale_Guides
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
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actPrint_two: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.ComponentItem = 'id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = '0'
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = 42186d
          FromParam.Component = deStart
          FromParam.DataType = ftDateTime
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'StartDate'
          ToParam.Value = 'NULL'
          ToParam.DataType = ftDateTime
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = 42186d
          FromParam.Component = deEnd
          FromParam.DataType = ftDateTime
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'EndDate'
          ToParam.Value = 'NULL'
          ToParam.DataType = ftDateTime
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProcList = <>
      Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' '#1055#1083#1072#1085'2/'#1060#1072#1082#1090' '#1088#1072#1089#1093#1086#1076' '#1089#1099#1088#1100#1103
      Hint = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' '#1055#1083#1072#1085'2/'#1060#1072#1082#1090' '#1088#1072#1089#1093#1086#1076' '#1089#1099#1088#1100#1103
      ImageIndex = 3
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GoodsGroupNameFull;GoodsName;GoodsKindName'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42186d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42186d
          Component = deEnd
          DataType = ftDateTime
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
          Name = 'isPartionGoods'
          Value = False
          Component = cbPartionGoods
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromName'
          Value = ''
          Component = FromUnitGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToName'
          Value = ''
          Component = ToUnitGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Num_two'
          Value = 2
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' '#1055#1083#1072#1085' '#1080' '#1060#1072#1082#1090' '#1088#1072#1089#1093#1086#1076' '#1089#1099#1088#1100#1103
      ReportNameParam.Value = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' '#1055#1083#1072#1085' '#1080' '#1060#1072#1082#1090' '#1088#1072#1089#1093#1086#1076' '#1089#1099#1088#1100#1103
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint_fact_two: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.ComponentItem = 'id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = '0'
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = 42186d
          FromParam.Component = deStart
          FromParam.DataType = ftDateTime
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'StartDate'
          ToParam.Value = 'NULL'
          ToParam.DataType = ftDateTime
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = 42186d
          FromParam.Component = deEnd
          FromParam.DataType = ftDateTime
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'EndDate'
          ToParam.Value = 'NULL'
          ToParam.DataType = ftDateTime
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProcList = <>
      Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' '#1060#1072#1082#1090'2 '#1088#1072#1089#1093#1086#1076' '#1089#1099#1088#1100#1103
      Hint = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' '#1060#1072#1082#1090'2 '#1088#1072#1089#1093#1086#1076' '#1089#1099#1088#1100#1103
      ImageIndex = 22
      ShortCut = 16464
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GoodsGroupNameFull;GoodsName;GoodsKindName'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42186d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42186d
          Component = deEnd
          DataType = ftDateTime
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
          Name = 'isPartionGoods'
          Value = False
          Component = cbPartionGoods
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromName'
          Value = ''
          Component = FromUnitGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToName'
          Value = ''
          Component = ToUnitGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Num_two'
          Value = 2
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' '#1060#1072#1082#1090' '#1088#1072#1089#1093#1086#1076' '#1089#1099#1088#1100#1103
      ReportNameParam.Value = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' '#1060#1072#1082#1090' '#1088#1072#1089#1093#1086#1076' '#1089#1099#1088#1100#1103
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
  end
  inherited MasterDS: TDataSource
    Left = 48
    Top = 152
  end
  inherited MasterCDS: TClientDataSet
    Left = 16
    Top = 152
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_ReceiptProductionOutAnalyze_Test_ok'
    DataSets = <
      item
        DataSet = MasterCDS
      end
      item
        DataSet = ChildCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inStartDate'
        Value = 41395d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 41395d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitFromId'
        Value = Null
        Component = FromUnitGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitToId'
        Value = Null
        Component = ToUnitGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsGroupId'
        Value = Null
        Component = GoodsGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceListId_1'
        Value = Null
        Component = PriceList_1_Guides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceListId_2'
        Value = Null
        Component = PriceList_2_Guides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceListId_3'
        Value = Null
        Component = PriceList_3_Guides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceListId_sale'
        Value = Null
        Component = PriceList_sale_Guides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsPartionGoods'
        Value = Null
        Component = cbPartionGoods
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 80
    Top = 152
  end
  inherited BarManager: TdxBarManager
    Top = 152
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
          ItemName = 'bbPartionGoods'
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
          ItemName = 'bbPrint_two'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrint_Reserve'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrint_fact'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrint_fact_two'
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
    object bbPrint_Reserve: TdxBarButton
      Action = actPrint_Reserve
      Category = 0
    end
    object bbPartionGoods: TdxBarControlContainerItem
      Caption = 'bbPartionGoods'
      Category = 0
      Hint = 'bbPartionGoods'
      Visible = ivAlways
      Control = cbPartionGoods
    end
    object dxBarButton1: TdxBarButton
      Action = actPrint_TaxReal
      Category = 0
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbPrint_fact: TdxBarButton
      Action = actPrint_fact
      Category = 0
    end
    object bbPrint_two: TdxBarButton
      Action = actPrint_two
      Category = 0
    end
    object bbPrint_fact_two: TdxBarButton
      Action = actPrint_fact_two
      Category = 0
    end
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 48
    Top = 8
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    Left = 96
    Top = 208
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
    Left = 976
    Top = 32
  end
  object FromUnitGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edFromUnit
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = FromUnitGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = FromUnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 408
  end
  object ToUnitGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edToUnit
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ToUnitGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ToUnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 464
    Top = 24
  end
  object PriceList_1_Guides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPriceList_1
    FormNameParam.Value = 'TPriceList_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPriceList_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PriceList_1_Guides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PriceList_1_Guides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceWithVAT'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'VATPercent'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyId'
        Value = ''
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 636
    Top = 65528
  end
  object PriceList_2_Guides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPriceList_2
    FormNameParam.Value = 'TPriceList_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPriceList_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PriceList_2_Guides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PriceList_2_Guides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceWithVAT'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'VATPercent'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyId'
        Value = ''
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 644
    Top = 40
  end
  object PriceList_3_Guides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPriceList_3
    FormNameParam.Value = 'TPriceList_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPriceList_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PriceList_3_Guides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PriceList_3_Guides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceWithVAT'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'VATPercent'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyId'
        Value = ''
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 836
    Top = 16
  end
  object PriceList_sale_Guides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPriceList_sale
    FormNameParam.Value = 'TPriceList_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPriceList_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PriceList_sale_Guides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PriceList_sale_Guides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceWithVAT'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'VATPercent'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyId'
        Value = ''
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 828
    Top = 48
  end
  object ChildCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    IndexFieldNames = 'MasterKey'
    Params = <>
    Left = 176
    Top = 232
  end
  object ChildDS: TDataSource
    DataSet = ChildCDS
    Left = 216
    Top = 232
  end
  object ChildViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = ChildView
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    PropertiesCellList = <>
    Left = 544
    Top = 320
  end
end
