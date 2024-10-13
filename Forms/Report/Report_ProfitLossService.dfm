inherited Report_ProfitLossServiceForm: TReport_ProfitLossServiceForm
  Caption = #1054#1090#1095#1077#1090' <'#1052#1072#1088#1082#1077#1090#1080#1085#1075' - '#1079#1072#1090#1088#1072#1090#1099' '#1087#1086' '#1090#1086#1074#1072#1088#1072#1084'>'
  ClientHeight = 319
  ClientWidth = 990
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 1006
  ExplicitHeight = 358
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 990
    Height = 262
    TabOrder = 3
    ExplicitWidth = 990
    ExplicitHeight = 262
    ClientRectBottom = 262
    ClientRectRight = 990
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 990
      ExplicitHeight = 262
      inherited cxGrid: TcxGrid
        Width = 990
        Height = 262
        ExplicitWidth = 990
        ExplicitHeight = 262
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountMarket
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummMarket
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CostPromo_m
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CostPromo_mi
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummMarket_calc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CostPromo_m_calc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CostPromo_mi_calc
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountMarket
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummMarket
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CostPromo_m
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CostPromo_mi
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummMarket_calc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CostPromo_m_calc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CostPromo_mi_calc
            end>
          OptionsData.Editing = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object MovementDescName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1076#1086#1082'.'
            DataBinding.FieldName = 'MovementDescName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1080#1076' '#1076#1086#1082'. <'#1053#1072#1095#1080#1089#1083#1077#1085#1080#1077' '#1087#1086' '#1073#1086#1085#1091#1089#1072#1084'> + <'#1053#1072#1095#1080#1089#1083#1077#1085#1080#1077'>'
            Options.Editing = False
            Width = 79
          end
          object InvNumber: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'.'
            DataBinding.FieldName = 'InvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1053#1072#1095#1080#1089#1083#1077#1085#1080#1077' '#1087#1086' '#1073#1086#1085#1091#1089#1072#1084'> + <'#1053#1072#1095#1080#1089#1083#1077#1085#1080#1077'>'
            Options.Editing = False
            Width = 100
          end
          object OperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086#1082'.'
            DataBinding.FieldName = 'OperDate'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = #1044#1072#1090#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1053#1072#1095#1080#1089#1083#1077#1085#1080#1077' '#1087#1086' '#1073#1086#1085#1091#1089#1072#1084'> + <'#1053#1072#1095#1080#1089#1083#1077#1085#1080#1077'>'
            Options.Editing = False
            Width = 40
          end
          object JuridicalName: TcxGridDBColumn
            Caption = #1070#1088'. '#1083#1080#1094#1086' ('#1085#1072#1095#1080#1089#1083#1077#1085#1080#1077')'
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 134
          end
          object PaidKindName: TcxGridDBColumn
            Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099' ('#1085#1072#1095#1080#1089#1083#1077#1085#1080#1077')'
            DataBinding.FieldName = 'PaidKindName'
            FooterAlignmentHorz = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 85
          end
          object ContractCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1076#1086#1075'. ('#1085#1072#1095#1080#1089#1083#1077#1085#1080#1077')'
            DataBinding.FieldName = 'ContractCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 85
          end
          object ContractName: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1075#1086#1074#1086#1088' ('#1085#1072#1095#1080#1089#1083#1077#1085#1080#1077')'
            DataBinding.FieldName = 'ContractName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 85
          end
          object ContractCode_Master: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1076#1086#1075'. ('#1091#1089#1083#1086#1074#1080#1077')'
            DataBinding.FieldName = 'ContractCode_Master'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object ContractName_Master: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1075#1086#1074#1086#1088' ('#1091#1089#1083#1086#1074#1080#1077')'
            DataBinding.FieldName = 'ContractName_Master'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object InfoMoneyName: TcxGridDBColumn
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' ('#1085#1072#1095#1080#1089#1083#1077#1085#1080#1077')'
            DataBinding.FieldName = 'InfoMoneyName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 85
          end
          object ContractConditionKindName: TcxGridDBColumn
            Caption = #1059#1089#1083#1086#1074#1080#1077' '#1076#1086#1075#1086#1074#1086#1088#1072
            DataBinding.FieldName = 'ContractConditionKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object RetailName: TcxGridDBColumn
            Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100' ('#1073#1072#1079#1072')'
            DataBinding.FieldName = 'RetailName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object JuridicalName_baza: TcxGridDBColumn
            Caption = #1070#1088'. '#1083#1080#1094#1086' ('#1073#1072#1079#1072')'
            DataBinding.FieldName = 'JuridicalName_baza'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object ContractChildCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1076#1086#1075'. ('#1073#1072#1079#1072')'
            DataBinding.FieldName = 'ContractChildCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object ContractChildName: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1075#1086#1074#1086#1088' ('#1073#1072#1079#1072')'
            DataBinding.FieldName = 'ContractChildName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 79
          end
          object PaidKindName_Child: TcxGridDBColumn
            Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099' ('#1073#1072#1079#1072')'
            DataBinding.FieldName = 'PaidKindName_Child'
            FooterAlignmentHorz = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object InfoMoneyName_Child: TcxGridDBColumn
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' ('#1076#1086#1075'.'#1073#1072#1079#1072')'
            DataBinding.FieldName = 'InfoMoneyName_Child'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object MovementDescName_doc: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1076#1086#1082'. ('#1073#1072#1079#1072')'
            DataBinding.FieldName = 'MovementDescName_doc'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1040#1082#1094#1080#1103' / '#1058#1088#1077#1081#1076'-'#1084#1072#1088#1082#1077#1090#1080#1085#1075
            Options.Editing = False
            Width = 92
          end
          object InvNumber_doc: TcxGridDBColumn
            Caption = #8470' '#1044#1086#1082'. ('#1073#1072#1079#1072')'
            DataBinding.FieldName = 'InvNumber_doc'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 79
          end
          object OperDate_Doc: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086#1082'. ('#1073#1072#1079#1072')'
            DataBinding.FieldName = 'OperDate_Doc'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 70
          end
          object GoodsGroupPropertyName_Parent: TcxGridDBColumn
            Caption = #1040#1085#1072#1083#1080#1090#1080#1082#1072' '#1059#1088#1086#1074#1077#1085#1100' 1'
            DataBinding.FieldName = 'GoodsGroupPropertyName_Parent'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1043#1088#1091#1087#1087#1072' - '#1040#1085#1072#1083#1080#1090#1080#1095#1077#1089#1082#1080#1081' '#1082#1083#1072#1089#1089#1080#1092#1080#1082#1072#1090#1086#1088
            Options.Editing = False
            Width = 100
          end
          object GoodsGroupPropertyName: TcxGridDBColumn
            Caption = #1040#1085#1072#1083#1080#1090#1080#1082#1072' '#1059#1088#1086#1074#1077#1085#1100' 2'
            DataBinding.FieldName = 'GoodsGroupPropertyName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1040#1085#1072#1083#1080#1090#1080#1095#1077#1089#1082#1080#1081' '#1082#1083#1072#1089#1089#1080#1092#1080#1082#1072#1090#1086#1088' '
            Options.Editing = False
            Width = 100
          end
          object GoodsGroupDirectionName: TcxGridDBColumn
            Caption = #1040#1085#1072#1083#1080#1090#1080#1082#1072' '#1053#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'GoodsGroupDirectionName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1040#1085#1072#1083#1080#1090#1080#1095#1077#1089#1082#1072#1103' '#1075#1088#1091#1087#1087#1072' '#1053#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
            Width = 70
          end
          object TradeMarkName: TcxGridDBColumn
            Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072
            DataBinding.FieldName = 'TradeMarkName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072' ('#1090#1086#1074#1072#1088')'
            Options.Editing = False
            Width = 68
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
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1090#1086#1074'.'
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 36
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 70
          end
          object GoodsKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 72
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
          object Amount: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1053#1072#1095#1080#1089#1083#1077#1085#1080#1103
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1053#1072#1095#1080#1089#1083#1077#1085#1080#1077' '#1087#1086' '#1073#1086#1085#1091#1089#1072#1084'> + <'#1053#1072#1095#1080#1089#1083#1077#1085#1080#1077'>'
            Options.Editing = False
            Width = 70
          end
          object AmountMarket: TcxGridDBColumn
            Caption = #1050#1086#1084#1087#1077#1085#1089#1072#1094#1080#1103', '#1074#1077#1089
            DataBinding.FieldName = 'AmountMarket'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1084#1087#1077#1085#1089#1072#1094#1080#1103' '#1079#1072' '#1074#1077#1089', '#1082#1075
            Options.Editing = False
            Width = 80
          end
          object SummMarket: TcxGridDBColumn
            Caption = #1050#1086#1084#1087#1077#1085#1089#1072#1094#1080#1103', '#1075#1088#1085
            DataBinding.FieldName = 'SummMarket'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1084#1087#1077#1085#1089#1072#1094#1080#1103', '#1075#1088#1085
            Options.Editing = False
            Width = 80
          end
          object CostPromo_m: TcxGridDBColumn
            Caption = #1057#1090#1086#1080#1084#1086#1089#1090#1100' '#1091#1095#1072#1089#1090#1080#1103', '#1075#1088#1085' ('#1040#1082#1094#1080#1103')'
            DataBinding.FieldName = 'CostPromo_m'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1090#1086#1080#1084#1086#1089#1090#1100' '#1091#1095#1072#1089#1090#1080#1103','#1075#1088#1085' ('#1040#1082#1094#1080#1103')'
            Options.Editing = False
            Width = 80
          end
          object CostPromo_mi: TcxGridDBColumn
            Caption = #1057#1090#1086#1080#1084#1086#1089#1090#1100' '#1091#1095#1072#1089#1090#1080#1103', '#1075#1088#1085' ('#1058'-'#1052')'
            DataBinding.FieldName = 'CostPromo_mi'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1090#1086#1080#1084#1086#1089#1090#1100' '#1091#1095#1072#1089#1090#1080#1103', '#1075#1088#1085' ('#1058#1088#1077#1081#1076'-'#1084#1072#1088#1082#1077#1090#1080#1085#1075')'
            Options.Editing = False
            Width = 80
          end
          object SummMarket_calc: TcxGridDBColumn
            Caption = '***'#1050#1086#1084#1087#1077#1085#1089#1072#1094#1080#1103', '#1075#1088#1085
            DataBinding.FieldName = 'SummMarket_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1095#1077#1090' - '#1050#1086#1084#1087#1077#1085#1089#1072#1094#1080#1103', '#1075#1088#1085
            Options.Editing = False
            Width = 100
          end
          object CostPromo_m_calc: TcxGridDBColumn
            Caption = '***'#1057#1090#1086#1080#1084#1086#1089#1090#1100' '#1091#1095#1072#1089#1090#1080#1103','#1075#1088#1085' ('#1040#1082#1094#1080#1103')'
            DataBinding.FieldName = 'CostPromo_m_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1095#1077#1090' - '#1057#1090#1086#1080#1084#1086#1089#1090#1100' '#1091#1095#1072#1089#1090#1080#1103','#1075#1088#1085' ('#1040#1082#1094#1080#1103')'
            Options.Editing = False
            Width = 100
          end
          object CostPromo_mi_calc: TcxGridDBColumn
            Caption = '***'#1057#1090#1086#1080#1084#1086#1089#1090#1100' '#1091#1095#1072#1089#1090#1080#1103','#1075#1088#1085' ('#1058'-'#1052')'
            DataBinding.FieldName = 'CostPromo_mi_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1095#1077#1090' - '#1057#1090#1086#1080#1084#1086#1089#1090#1100' '#1091#1095#1072#1089#1090#1080#1103', '#1075#1088#1085' ('#1058#1088#1077#1081#1076'-'#1084#1072#1088#1082#1077#1090#1080#1085#1075')'
            Options.Editing = False
            Width = 100
          end
          object Persent_part: TcxGridDBColumn
            Caption = '% '#1050#1086#1108#1092'. ('#1090#1086#1074#1072#1088')'
            DataBinding.FieldName = 'Persent_part'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object Persent_part_tm: TcxGridDBColumn
            Caption = '% '#1050#1086#1108#1092'. ('#1058'. '#1084#1072#1088#1082#1072')'
            DataBinding.FieldName = 'Persent_part_tm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object Persent_part_gpp: TcxGridDBColumn
            Caption = '% '#1050#1086#1108#1092'. ('#1082#1083'.'#1091#1088#1086#1074#1077#1085#1100'-1)'
            DataBinding.FieldName = 'Persent_part_gpp'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object Persent_part_gp: TcxGridDBColumn
            Caption = '% '#1050#1086#1108#1092'. ('#1082#1083'.'#1091#1088#1086#1074#1077#1085#1100'-2)'
            DataBinding.FieldName = 'Persent_part_gp'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object SummAmount: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078
            DataBinding.FieldName = 'SummAmount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object TotalSumm: TcxGridDBColumn
            Caption = '*'#1048#1090#1086#1075#1086' '#1089#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078
            DataBinding.FieldName = 'TotalSumm'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 82
          end
          object TotalSumm_tm: TcxGridDBColumn
            Caption = '*'#1048#1090#1086#1075#1086' '#1089#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078' ('#1058#1052')'
            DataBinding.FieldName = 'TotalSumm_tm'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1089#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' ('#1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072')'
            Options.Editing = False
            Width = 70
          end
          object TotalSumm_gpp: TcxGridDBColumn
            Caption = '*'#1048#1090#1086#1075#1086' '#1089#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078' ('#1091#1088#1086#1074#1077#1085#1100'-1)'
            DataBinding.FieldName = 'TotalSumm_gpp'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1089#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' ('#1082#1083#1072#1089#1089#1080#1092#1080#1082#1072#1090#1086#1088' - '#1091#1088#1086#1074#1077#1085#1100'-1)'
            Options.Editing = False
            Width = 70
          end
          object TotalSumm_gp: TcxGridDBColumn
            Caption = '*'#1048#1090#1086#1075#1086' '#1089#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078' ('#1091#1088#1086#1074#1077#1085#1100'-2)'
            DataBinding.FieldName = 'TotalSumm_gp'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1089#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' ('#1082#1083#1072#1089#1089#1080#1092#1080#1082#1072#1090#1086#1088' - '#1091#1088#1086#1074#1077#1085#1100'-2)'
            Options.Editing = False
            Width = 70
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 990
    ExplicitWidth = 990
    inherited deStart: TcxDateEdit
      Left = 109
      EditValue = 45292d
      Properties.SaveTime = False
      ExplicitLeft = 109
    end
    inherited deEnd: TcxDateEdit
      EditValue = 45292d
      Properties.SaveTime = False
    end
  end
  inherited ActionList: TActionList
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_ProfitLossServiceDialogForm'
      FormNameParam.Value = 'TReport_ProfitLossServiceDialogForm'
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
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actGetFormPromo: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = getMovementFormPromo
      StoredProcList = <
        item
          StoredProc = getMovementFormPromo
        end>
      Caption = 'actGetForm'
    end
    object actGetForm: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = getMovementForm
      StoredProcList = <
        item
          StoredProc = getMovementForm
        end>
      Caption = 'actGetForm'
    end
    object actOpenForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1053#1072#1095#1080#1089#1083#1077#1085#1080#1103
      FormName = 'TProfitLossServiceForm'
      FormNameParam.Value = 'TProfitLossServiceForm'
      FormNameParam.Component = FormParams
      FormNameParam.ComponentItem = 'FormName'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenFormPromo: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1040#1082#1094#1080#1080
      FormName = 'TProfitLossServiceForm'
      FormNameParam.Value = 'TProfitLossServiceForm'
      FormNameParam.Component = FormParams
      FormNameParam.ComponentItem = 'FormNamePromo'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId_doc'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'OperDate_Doc'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object mactOpenDocumentPromo: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actGetFormPromo
        end
        item
          Action = actOpenFormPromo
        end>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1040#1082#1094#1080#1103' / '#1058#1088#1077#1081#1076'-'#1080#1072#1088#1082#1077#1090#1080#1085#1075
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1040#1082#1094#1080#1103' / '#1058#1088#1077#1081#1076'-'#1080#1072#1088#1082#1077#1090#1080#1085#1075
      ImageIndex = 28
    end
    object mactOpenDocument: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actGetForm
        end
        item
          Action = actOpenForm
        end>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 28
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
    StoredProcName = 'gpReport_ProfitLossService'
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
        Name = 'fff'
        Value = ''
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    Left = 112
    Top = 208
  end
  inherited BarManager: TdxBarManager
    Left = 144
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
          ItemName = 'bbOpenDocument'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbOpenDocumentPromo'
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
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbOpenDocument: TdxBarButton
      Action = mactOpenDocument
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1053#1072#1095#1080#1089#1083#1077#1085#1080#1077
      Category = 0
    end
    object bbOpenDocumentPromo: TdxBarButton
      Action = mactOpenDocumentPromo
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 368
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 80
    Top = 144
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
      end>
    Left = 184
    Top = 136
  end
  object getMovementForm: TdsdStoredProc
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
        Value = 'TProfitLossServiceForm'
        Component = FormParams
        ComponentItem = 'FormName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 632
    Top = 200
  end
  object getMovementFormPromo: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Form'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId_doc'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'FormName'
        Value = 'TPromoForm'
        Component = FormParams
        ComponentItem = 'FormNamePromo'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 528
    Top = 192
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'StartDate'
        Value = 45474d
        Component = deStart
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndDate'
        Value = 45474d
        Component = deEnd
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionGoodsDate'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsShowAll'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisPrint'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'FormName'
        Value = 'TProfitLossServiceForm'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'FormNamePromo'
        Value = 'TPromoForm'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 408
    Top = 200
  end
end
