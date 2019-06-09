inherited Report_ReceiptSaleAnalyzeForm: TReport_ReceiptSaleAnalyzeForm
  Caption = #1054#1090#1095#1077#1090' <'#1040#1085#1072#1083#1080#1079' '#1088#1077#1094#1077#1087#1090#1091#1088' '#1080' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080'>'
  ClientHeight = 405
  ClientWidth = 1130
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitLeft = -340
  ExplicitWidth = 1146
  ExplicitHeight = 440
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 83
    Width = 1130
    Height = 322
    TabOrder = 3
    ExplicitTop = 83
    ExplicitWidth = 1130
    ExplicitHeight = 322
    ClientRectBottom = 322
    ClientRectRight = 1130
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1130
      ExplicitHeight = 322
      inherited cxGrid: TcxGrid
        Width = 1130
        Height = 322
        ExplicitWidth = 1130
        ExplicitHeight = 322
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCount_Weight_sale
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn_sale
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummOut_PriceList_sale
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummOut_sale
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCount_Weight_return
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn_return
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummOut_PriceList_return
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummOut_return
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_sale
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummPrice1_sale
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummPrice2_sale
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummPrice3_sale
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCount_sh_return
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCount_sh_sale
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummCost1_sale
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummCost2_sale
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummCost3_sale
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummCost4_sale
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Profit
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCount_Weight_sale
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn_sale
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummOut_PriceList_sale
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummOut_sale
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCount_Weight_return
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn_return
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummOut_PriceList_return
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummOut_return
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_sale
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummPrice1_sale
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummPrice2_sale
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummPrice3_sale
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCount_sh_return
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCount_sh_sale
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummCost1_sale
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummCost2_sale
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummCost3_sale
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummCost4_sale
            end
            item
              Format = ' ,0.####'
              Kind = skSum
              Column = Profit
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
          object Code: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'Code'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object clReceiptCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1088#1077#1094#1077#1087#1090'.'
            DataBinding.FieldName = 'ReceiptCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object TradeMarkName: TcxGridDBColumn
            Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072
            DataBinding.FieldName = 'TradeMarkName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object GoodsGroupAnalystName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1072#1085#1072#1083#1080#1090#1080#1082#1080
            DataBinding.FieldName = 'GoodsGroupAnalystName'
            Visible = False
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
          object colGoodsGroupNameFull: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
            DataBinding.FieldName = 'GoodsGroupNameFull'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object colGoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1090#1086#1074'.'
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object colGoodsName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' ('#1087#1088#1080#1093#1086#1076')'
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 140
          end
          object colGoodsKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object clGoodsKindCompleteName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' '#1043#1055
            DataBinding.FieldName = 'GoodsKindCompleteName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object clMeasureName: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 40
          end
          object Tax_return: TcxGridDBColumn
            Caption = '% '#1074#1086#1079#1074#1088'.'
            DataBinding.FieldName = 'Tax_return'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 45
          end
          object Tax_Summ_sale: TcxGridDBColumn
            Caption = '% '#1088#1077#1085#1090' '#1087#1088'.1/'#1087#1088'. '#1088#1072#1089#1095'.'
            DataBinding.FieldName = 'Tax_Summ_sale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Tax_SummOut_sale: TcxGridDBColumn
            Caption = '% '#1088#1077#1085#1090' '#1087#1088'.1/'#1088#1077#1072#1083#1080#1079'. '#1092#1072#1082#1090
            DataBinding.FieldName = 'Tax_SummOut_sale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object clIsMain: TcxGridDBColumn
            Caption = #1043#1083#1072#1074#1085'.'
            DataBinding.FieldName = 'isMain'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object clTaxExit: TcxGridDBColumn
            Caption = '% '#1074#1099#1093'.'
            DataBinding.FieldName = 'TaxExit'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 40
          end
          object clTaxLoss: TcxGridDBColumn
            Caption = '% '#1087#1086#1090#1077#1088#1100
            DataBinding.FieldName = 'TaxLoss'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object Amount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1088#1077#1094#1077#1087#1090
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object Amount_Weight: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1088#1077#1094#1077#1087#1090' ('#1074#1077#1089')'
            DataBinding.FieldName = 'Amount_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object Price1: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1055#1088#1072#1081#1089'1'
            DataBinding.FieldName = 'Price1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object Price2: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1055#1088#1072#1081#1089'2'
            DataBinding.FieldName = 'Price2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object Price3: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1055#1088#1072#1081#1089'3'
            DataBinding.FieldName = 'Price3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object Price1_cost: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1079#1072#1090#1088#1072#1090#1099' '#1055#1088'.1'
            DataBinding.FieldName = 'Price1_cost'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object Price2_cost: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1079#1072#1090#1088#1072#1090#1099' '#1055#1088'.2'
            DataBinding.FieldName = 'Price2_cost'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object Price3_cost: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1079#1072#1090#1088#1072#1090#1099' '#1055#1088'.3'
            DataBinding.FieldName = 'Price3_cost'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object Price4_cost: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1079#1072#1090#1088#1072#1090#1099' '#1055#1088'.4'
            DataBinding.FieldName = 'Price4_cost'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object SummCost1_sale: TcxGridDBColumn
            Caption = #1047#1072#1090#1088#1072#1090#1099' '#1055#1088#1072#1081#1089'1 '#1088#1077#1072#1083#1080#1079'. ('#1088#1072#1089#1095'.)'
            DataBinding.FieldName = 'SummCost1_sale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object SummCost2_sale: TcxGridDBColumn
            Caption = #1047#1072#1090#1088#1072#1090#1099' '#1055#1088#1072#1081#1089'2 '#1088#1077#1072#1083#1080#1079'. ('#1088#1072#1089#1095'.)'
            DataBinding.FieldName = 'SummCost2_sale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object SummCost3_sale: TcxGridDBColumn
            Caption = #1047#1072#1090#1088#1072#1090#1099' '#1055#1088#1072#1081#1089'3 '#1088#1077#1072#1083#1080#1079'. ('#1088#1072#1089#1095'.)'
            DataBinding.FieldName = 'SummCost3_sale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object SummCost4_sale: TcxGridDBColumn
            Caption = #1047#1072#1090#1088#1072#1090#1099' '#1055#1088#1072#1081#1089'4 '#1088#1077#1072#1083#1080#1079'. ('#1088#1072#1089#1095'.)'
            DataBinding.FieldName = 'SummCost4_sale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object SummPrice1_sale: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1055#1088#1072#1081#1089'1 '#1088#1077#1072#1083#1080#1079'. ('#1088#1072#1089#1095'.)'
            DataBinding.FieldName = 'SummPrice1_sale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 75
          end
          object SummPrice2_sale: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1055#1088#1072#1081#1089'2 '#1088#1077#1072#1083#1080#1079'. ('#1088#1072#1089#1095'.)'
            DataBinding.FieldName = 'SummPrice2_sale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 75
          end
          object SummPrice3_sale: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1055#1088#1072#1081#1089'3 '#1088#1077#1072#1083#1080#1079'. ('#1088#1072#1089#1095'.)'
            DataBinding.FieldName = 'SummPrice3_sale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 75
          end
          object Price_sale: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1089' '#1053#1044#1057
            DataBinding.FieldName = 'Price_sale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object Summ_sale: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089' '#1053#1044#1057' '#1088#1077#1072#1083#1080#1079'. ('#1088#1072#1089#1095'.)'
            DataBinding.FieldName = 'Summ_sale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 75
          end
          object OperCount_sale: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1088#1077#1072#1083#1080#1079'.'
            DataBinding.FieldName = 'OperCount_sale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object OperCount_sh_sale: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1088#1077#1072#1083#1080#1079'. ('#1096#1090'.)'
            DataBinding.FieldName = 'OperCount_sh_sale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object OperCount_Weight_sale: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1088#1077#1072#1083#1080#1079'. ('#1074#1077#1089')'
            DataBinding.FieldName = 'OperCount_Weight_sale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object Price_in_sale: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1089'/'#1089' '#1088#1077#1072#1083#1080#1079'.'
            DataBinding.FieldName = 'Price_in_sale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object SummIn_sale: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089'/'#1089' '#1088#1077#1072#1083#1080#1079'.'
            DataBinding.FieldName = 'SummIn_sale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 81
          end
          object Price_out_pl_sale: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1087#1088#1072#1081#1089' '#1088#1077#1072#1083#1080#1079'.'
            DataBinding.FieldName = 'Price_out_pl_sale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object SummOut_PriceList_sale: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1088#1072#1081#1089' '#1088#1077#1072#1083#1080#1079'.'
            DataBinding.FieldName = 'SummOut_PriceList_sale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 81
          end
          object Price_out_sale: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1088#1077#1072#1083#1080#1079'.'
            DataBinding.FieldName = 'Price_out_sale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object SummOut_sale: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1088#1077#1072#1083#1080#1079'.'
            DataBinding.FieldName = 'SummOut_sale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 81
          end
          object OperCount_return: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1074#1086#1079#1074#1088'.'
            DataBinding.FieldName = 'OperCount_return'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object OperCount_sh_return: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1074#1086#1079#1074#1088'. ('#1096#1090'.)'
            DataBinding.FieldName = 'OperCount_sh_return'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object OperCount_Weight_return: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1074#1086#1079#1074#1088'. ('#1074#1077#1089')'
            DataBinding.FieldName = 'OperCount_Weight_return'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object Price_in_return: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1089'/'#1089' '#1074#1086#1079#1074#1088'.'
            DataBinding.FieldName = 'Price_in_return'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object SummIn_return: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089'/'#1089' '#1074#1086#1079#1074#1088'.'
            DataBinding.FieldName = 'SummIn_return'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 81
          end
          object Price_out_pl_return: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1087#1088#1072#1081#1089' '#1074#1086#1079#1074#1088'.'
            DataBinding.FieldName = 'Price_out_pl_return'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object SummOut_PriceList_return: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1088#1072#1081#1089' '#1074#1086#1079#1074#1088'.'
            DataBinding.FieldName = 'SummOut_PriceList_return'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 81
          end
          object Price_out_return: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1074#1086#1079#1074#1088'.'
            DataBinding.FieldName = 'Price_out_return'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object SummOut_return: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1074#1086#1079#1074#1088'.'
            DataBinding.FieldName = 'SummOut_return'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 81
          end
          object Profit: TcxGridDBColumn
            Caption = #1063#1080#1089#1090#1072#1103' '#1087#1088#1080#1073#1099#1083#1100
            DataBinding.FieldName = 'Profit'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object clComment: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 108
          end
          object isMain_Parent: TcxGridDBColumn
            Caption = #1043#1083#1072#1074#1085'. ('#1087#1086#1080#1089#1082')'
            DataBinding.FieldName = 'isMain_Parent'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object Code_Parent: TcxGridDBColumn
            Caption = #1050#1086#1076' ('#1087#1086#1080#1089#1082')'
            DataBinding.FieldName = 'Code_Parent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = '0.;-0.; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object ReceiptCode_Parent: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1088#1077#1094#1077#1087#1090'. ('#1087#1086#1080#1089#1082')'
            DataBinding.FieldName = 'ReceiptCode_Parent'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object Name_Parent: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1088#1077#1094#1077#1087#1090#1091#1088#1099' ('#1087#1086#1080#1089#1082')'
            DataBinding.FieldName = 'Name_Parent'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object GoodsCode_Parent: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1090#1086#1074'. ('#1087#1086#1080#1089#1082')'
            DataBinding.FieldName = 'GoodsCode_Parent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = '0.;-0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object GoodsName_Parent: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1090#1086#1074#1072#1088#1072' ('#1087#1086#1080#1089#1082')'
            DataBinding.FieldName = 'GoodsName_Parent'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object GoodsKindName_Parent: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' ('#1087#1086#1080#1089#1082')'
            DataBinding.FieldName = 'GoodsKindName_Parent'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object GoodsKindCompleteName_Parent: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' '#1043#1055' ('#1087#1086#1080#1089#1082')'
            DataBinding.FieldName = 'GoodsKindCompleteName_Parent'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
          object MeasureName_Parent: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'. ('#1087#1086#1080#1089#1082')'
            DataBinding.FieldName = 'MeasureName_Parent'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object isCheck_Parent: TcxGridDBColumn
            Caption = #1056#1072#1079#1085'. ('#1087#1086#1080#1089#1082')'
            DataBinding.FieldName = 'isCheck_Parent'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object GoodsCode_isCost: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1090#1086#1074'. ('#1079#1072#1090#1088'.)'
            DataBinding.FieldName = 'GoodsCode_isCost'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object GoodsName_isCost: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1090#1086#1074#1072#1088#1072' ('#1079#1072#1090#1088#1072#1090#1110')'
            DataBinding.FieldName = 'GoodsName_isCost'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object colInfoMoneyCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1059#1055
            DataBinding.FieldName = 'InfoMoneyCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 45
          end
          object colInfoMoneyGroupName: TcxGridDBColumn
            Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object colInfoMoneyDestinationName: TcxGridDBColumn
            Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
            DataBinding.FieldName = 'InfoMoneyDestinationName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object colInfoMoneyName: TcxGridDBColumn
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 129
          end
          object Receiptid: TcxGridDBColumn
            DataBinding.FieldName = 'Receiptid'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            VisibleForCustomization = False
            Width = 55
          end
          object Color_Profit: TcxGridDBColumn
            DataBinding.FieldName = 'Color_Profit'
            Visible = False
            VisibleForCustomization = False
            Width = 30
          end
        end
        object ChildView: TcxGridDBTableView [1]
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = ChildDS
          DataController.DetailKeyFieldNames = 'Receiptid'
          DataController.MasterKeyFieldNames = 'Receiptid'
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ2
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Position = spFooter
              Column = Summ1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Position = spFooter
              Column = Summ2
            end
            item
              Format = ',0.####'
              Kind = skSum
              Position = spFooter
              Column = Summ3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Position = spFooter
              Column = Summ1_Start
            end
            item
              Format = ',0.####'
              Kind = skSum
              Position = spFooter
              Column = Summ2_Start
            end
            item
              Format = ',0.####'
              Kind = skSum
              Position = spFooter
              Column = Summ3_Start
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ1_Start
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ2_Start
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ3_Start
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ2
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ1_Start
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ2_Start
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ3_Start
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
          object GroupNumber: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#8470
            DataBinding.FieldName = 'GroupNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object GoodsGroupNameFull: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
            DataBinding.FieldName = 'GoodsGroupNameFull'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object clGoodsCode: TcxGridDBColumn
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
          object clGoodsName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' ('#1088#1072#1089#1093#1086#1076')'
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
          object GoodsKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object MeasureNameChild: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object AmountChild: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object clPrice1: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1055#1088#1072#1081#1089'1'
            DataBinding.FieldName = 'Price1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object clPrice2: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1055#1088#1072#1081#1089'2'
            DataBinding.FieldName = 'Price2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object clPrice3: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1055#1088#1072#1081#1089'3'
            DataBinding.FieldName = 'Price3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object Summ1: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1055#1088#1072#1081#1089'1'
            DataBinding.FieldName = 'Summ1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object Summ2: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1055#1088#1072#1081#1089'2'
            DataBinding.FieldName = 'Summ2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object Summ3: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1055#1088#1072#1081#1089'3'
            DataBinding.FieldName = 'Summ3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object isStart: TcxGridDBColumn
            Caption = #1041#1072#1079'.'
            DataBinding.FieldName = 'isStart'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object Amount_start: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1073#1072#1079'.'
            DataBinding.FieldName = 'Amount_start'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Summ1_Start: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1073#1072#1079'. '#1055#1088'1'
            DataBinding.FieldName = 'Summ1_Start'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Summ2_Start: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1073#1072#1079'. '#1055#1088'2'
            DataBinding.FieldName = 'Summ2_Start'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Summ3_Start: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1073#1072#1079'. '#1055#1088'3'
            DataBinding.FieldName = 'Summ3_Start'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object ReceiptCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1073#1072#1079'.'
            DataBinding.FieldName = 'ReceiptCode'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = '0.;-0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object ReceiptCode_user: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1088#1077#1094#1077#1087#1090'. '#1073#1072#1079'.'
            DataBinding.FieldName = 'ReceiptCode_user'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object clInfoMoneyCodeChild: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1059#1055
            DataBinding.FieldName = 'InfoMoneyCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object clInfoMoneyGroupNameChild: TcxGridDBColumn
            Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object clInfoMoneyDestinationNameChild: TcxGridDBColumn
            Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
            DataBinding.FieldName = 'InfoMoneyDestinationName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object clInfoMoneyNameChild: TcxGridDBColumn
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object clReceiptid: TcxGridDBColumn
            DataBinding.FieldName = 'Receiptid'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 55
          end
          object Color_calc: TcxGridDBColumn
            DataBinding.FieldName = 'Color_calc'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            VisibleForCustomization = False
            Width = 55
          end
        end
        inherited cxGridLevel: TcxGridLevel
          object cxGridLevel1: TcxGridLevel
            GridView = ChildView
          end
        end
      end
      object cbGoodsKind: TcxCheckBox
        Left = 77
        Top = 15
        Caption = #1087#1086' '#1042#1080#1076#1072#1084' '#1090#1086#1074#1072#1088#1072
        Properties.ReadOnly = False
        TabOrder = 1
        Width = 116
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
      EditValue = 42917d
      ExplicitLeft = 118
      ExplicitTop = 7
    end
    inherited deEnd: TcxDateEdit
      Left = 118
      Top = 32
      EditValue = 42917d
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
      Left = 211
      Top = 6
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1088#1077#1072#1083#1080#1079'.):'
    end
    object edFromUnit: TcxButtonEdit
      Left = 352
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 160
    end
    object cxLabel5: TcxLabel
      Left = 209
      Top = 29
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1074#1086#1079#1074#1088#1072#1090'):'
    end
    object edToUnit: TcxButtonEdit
      Left = 352
      Top = 29
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 9
      Width = 160
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
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = cbGoodsKind
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
      Caption = #1055#1083#1072#1085#1086#1074#1072#1103' '#1055#1088#1080#1073#1099#1083#1100' ('#1094#1077#1085#1072' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080' '#1055#1088#1072#1081#1089')'
      Hint = #1055#1083#1072#1085#1086#1074#1072#1103' '#1055#1088#1080#1073#1099#1083#1100' ('#1094#1077#1085#1072' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080' '#1055#1088#1072#1081#1089')'
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
          Name = 'isGoodsKind'
          Value = 'False'
          Component = cbGoodsKind
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isExcel'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1083#1072#1085#1086#1074#1072#1103' '#1055#1088#1080#1073#1099#1083#1100
      ReportNameParam.Value = #1055#1083#1072#1085#1086#1074#1072#1103' '#1055#1088#1080#1073#1099#1083#1100
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint_Real: TdsdPrintAction
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
      Caption = #1055#1083#1072#1085#1086#1074#1072#1103' '#1055#1088#1080#1073#1099#1083#1100' ('#1094#1077#1085#1072' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080' '#1060#1072#1082#1090')'
      Hint = #1055#1083#1072#1085#1086#1074#1072#1103' '#1055#1088#1080#1073#1099#1083#1100' ('#1094#1077#1085#1072' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080' '#1060#1072#1082#1090')'
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
          Name = 'isGoodsKind'
          Value = 'False'
          Component = cbGoodsKind
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isExcel'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1083#1072#1085#1086#1074#1072#1103' '#1055#1088#1080#1073#1099#1083#1100' ('#1060#1072#1082#1090')'
      ReportNameParam.Value = #1055#1083#1072#1085#1086#1074#1072#1103' '#1055#1088#1080#1073#1099#1083#1100' ('#1060#1072#1082#1090')'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint_Calc_PriceList: TdsdPrintAction
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
      Caption = 
        #1055#1083#1072#1085#1086#1074#1072#1103' '#1055#1088#1080#1073#1099#1083#1100' ('#1088#1077#1072#1083#1080#1079'. '#1055#1088#1072#1081#1089' + '#1094#1077#1085#1072' c/c '#1092#1072#1082#1090' + '#1088#1072#1089#1093#1086#1076#1099' '#1087#1086' '#1087#1088#1072 +
        #1081#1089#1091'2)'
      Hint = 
        #1055#1083#1072#1085#1086#1074#1072#1103' '#1055#1088#1080#1073#1099#1083#1100' ('#1088#1077#1072#1083#1080#1079'. '#1055#1088#1072#1081#1089' + '#1094#1077#1085#1072' c/c '#1092#1072#1082#1090' + '#1088#1072#1089#1093#1086#1076#1099' '#1087#1086' '#1087#1088#1072 +
        #1081#1089#1091'2)'
      ImageIndex = 22
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
          Name = 'isGoodsKind'
          Value = 'False'
          Component = cbGoodsKind
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isExcel'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1083#1072#1085#1086#1074#1072#1103' '#1055#1088#1080#1073#1099#1083#1100' ('#1060#1072#1082#1090' '#1089#1077#1073#1077#1089#1090#1086#1080#1084#1086#1089#1090#1100' '#1080' '#1088#1072#1089#1093#1086#1076#1099' '#1080' '#1087#1088#1072#1081#1089')'
      ReportNameParam.Value = #1055#1083#1072#1085#1086#1074#1072#1103' '#1055#1088#1080#1073#1099#1083#1100' ('#1060#1072#1082#1090' '#1089#1077#1073#1077#1089#1090#1086#1080#1084#1086#1089#1090#1100' '#1080' '#1088#1072#1089#1093#1086#1076#1099' '#1080' '#1087#1088#1072#1081#1089')'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint_Profit: TdsdPrintAction
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
          FromParam.Value = 42917d
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
          FromParam.Value = 42917d
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
      Caption = 
        #1060#1072#1082#1090#1080#1095#1077#1089#1082#1072#1103' '#1055#1088#1080#1073#1099#1083#1100' ('#1088#1077#1072#1083#1080#1079'. '#1060#1072#1082#1090' + '#1094#1077#1085#1072' c/c '#1092#1072#1082#1090' + '#1088#1072#1089#1093#1086#1076#1099' '#1087#1086' '#1087 +
        #1088#1072#1081#1089#1091'2+ '#1095#1080#1089#1090'. '#1087#1088#1080#1073'.)'
      Hint = 
        #1060#1072#1082#1090#1080#1095#1077#1089#1082#1072#1103' '#1055#1088#1080#1073#1099#1083#1100' ('#1088#1077#1072#1083#1080#1079'. '#1060#1072#1082#1090' + '#1094#1077#1085#1072' c/c '#1092#1072#1082#1090' + '#1088#1072#1089#1093#1086#1076#1099' '#1087#1086' '#1087 +
        #1088#1072#1081#1089#1091'2 + '#1095#1080#1089#1090'. '#1087#1088#1080#1073'.)'
      ImageIndex = 19
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GoodsGroupNameFull;GoodsName;GoodsKindName'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42917d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42917d
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
          Name = 'isGoodsKind'
          Value = 'False'
          Component = cbGoodsKind
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isExcel'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1083#1072#1085#1086#1074#1072#1103' '#1055#1088#1080#1073#1099#1083#1100' ('#1095#1080#1089#1090#1072#1103' '#1087#1088#1080#1073#1099#1083#1100')'
      ReportNameParam.Value = #1055#1083#1072#1085#1086#1074#1072#1103' '#1055#1088#1080#1073#1099#1083#1100' ('#1095#1080#1089#1090#1072#1103' '#1087#1088#1080#1073#1099#1083#1100')'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint_Calc: TdsdPrintAction
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
      Caption = 
        #1060#1072#1082#1090#1080#1095#1077#1089#1082#1072#1103' '#1055#1088#1080#1073#1099#1083#1100' ('#1088#1077#1072#1083#1080#1079'. '#1060#1072#1082#1090' + '#1094#1077#1085#1072' c/c '#1092#1072#1082#1090' + '#1088#1072#1089#1093#1086#1076#1099' '#1087#1086' '#1087 +
        #1088#1072#1081#1089#1091'2)'
      Hint = 
        #1055#1083#1072#1085#1086#1074#1072#1103' '#1055#1088#1080#1073#1099#1083#1100' ('#1088#1077#1072#1083#1080#1079'. '#1060#1072#1082#1090' + '#1094#1077#1085#1072' c/c '#1092#1072#1082#1090' + '#1088#1072#1089#1093#1086#1076#1099' '#1087#1086' '#1087#1088#1072#1081 +
        #1089#1091'2)'
      ImageIndex = 18
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
          Name = 'isGoodsKind'
          Value = 'False'
          Component = cbGoodsKind
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isExcel'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1083#1072#1085#1086#1074#1072#1103' '#1055#1088#1080#1073#1099#1083#1100' ('#1060#1072#1082#1090' '#1089#1077#1073#1077#1089#1090#1086#1080#1084#1086#1089#1090#1100' '#1080' '#1088#1072#1089#1093#1086#1076#1099')'
      ReportNameParam.Value = #1055#1083#1072#1085#1086#1074#1072#1103' '#1055#1088#1080#1073#1099#1083#1100' ('#1060#1072#1082#1090' '#1089#1077#1073#1077#1089#1090#1086#1080#1084#1086#1089#1090#1100' '#1080' '#1088#1072#1089#1093#1086#1076#1099')'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint_CalcPrice: TdsdPrintAction
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
      Caption = #1062#1077#1085#1072' c/c '#1092#1072#1082#1090' + '#1088#1072#1089#1093#1086#1076#1099' '#1087#1086' '#1087#1088#1072#1081#1089#1091'3'
      Hint = #1062#1077#1085#1072' c/c '#1092#1072#1082#1090' + '#1088#1072#1089#1093#1086#1076#1099' '#1087#1086' '#1087#1088#1072#1081#1089#1091'3'
      ImageIndex = 16
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
          Name = 'isGoodsKind'
          Value = 'False'
          Component = cbGoodsKind
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isExcel'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1083#1072#1085#1086#1074#1072#1103' '#1055#1088#1080#1073#1099#1083#1100' ('#1094#1077#1085#1072' '#1089#1077#1073#1077#1089#1090#1086#1080#1084#1086#1089#1090#1100' '#1080' '#1088#1072#1089#1093#1086#1076#1099')'
      ReportNameParam.Value = #1055#1083#1072#1085#1086#1074#1072#1103' '#1055#1088#1080#1073#1099#1083#1100' ('#1094#1077#1085#1072' '#1089#1077#1073#1077#1089#1090#1086#1080#1084#1086#1089#1090#1100' '#1080' '#1088#1072#1089#1093#1086#1076#1099')'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint_DiffPrice: TdsdPrintAction
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
      Caption = #1057#1088#1072#1074#1085#1077#1085#1080#1077' '#1094#1077#1085' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080
      Hint = #1057#1088#1072#1074#1085#1077#1085#1080#1077' '#1094#1077#1085' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080
      ImageIndex = 15
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
          Name = 'isGoodsKind'
          Value = 'False'
          Component = cbGoodsKind
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isExcel'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1083#1072#1085#1086#1074#1072#1103' '#1055#1088#1080#1073#1099#1083#1100' ('#1089#1088#1072#1074#1085#1077#1085#1080#1077' '#1094#1077#1085')'
      ReportNameParam.Value = #1055#1083#1072#1085#1086#1074#1072#1103' '#1055#1088#1080#1073#1099#1083#1100' ('#1089#1088#1072#1074#1085#1077#1085#1080#1077' '#1094#1077#1085')'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint_DiffPriceIn: TdsdPrintAction
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
      Caption = #1057#1088#1072#1074#1085#1077#1085#1080#1077' '#1094#1077#1085' '#1089#1077#1073#1077#1089#1090#1086#1080#1084#1086#1089#1090#1080
      Hint = #1057#1088#1072#1074#1085#1077#1085#1080#1077' '#1094#1077#1085' '#1089#1077#1073#1077#1089#1090#1086#1080#1084#1086#1089#1090#1080
      ImageIndex = 23
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
          Name = 'isGoodsKind'
          Value = 'False'
          Component = cbGoodsKind
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1083#1072#1085#1086#1074#1072#1103' '#1055#1088#1080#1073#1099#1083#1100' ('#1089#1088#1072#1074#1085#1077#1085#1080#1077' '#1094#1077#1085' '#1089#1077#1073#1077#1089#1090#1086#1080#1084#1086#1089#1090#1080')'
      ReportNameParam.Value = #1055#1083#1072#1085#1086#1074#1072#1103' '#1055#1088#1080#1073#1099#1083#1100' ('#1089#1088#1072#1074#1085#1077#1085#1080#1077' '#1094#1077#1085' '#1089#1077#1073#1077#1089#1090#1086#1080#1084#1086#1089#1090#1080')'
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
      FormName = 'TReport_ReceiptSaleAnalyzeDialogForm'
      FormNameParam.Value = 'TReport_ReceiptSaleAnalyzeDialogForm'
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
    object actPrint_Calc_PriceListExcel: TdsdPrintAction
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
      Caption = 
        'Excel - '#1055#1083#1072#1085#1086#1074#1072#1103' '#1055#1088#1080#1073#1099#1083#1100' ('#1088#1077#1072#1083#1080#1079'. '#1055#1088#1072#1081#1089' + '#1094#1077#1085#1072' c/c '#1092#1072#1082#1090' + '#1088#1072#1089#1093#1086#1076 +
        #1099' '#1087#1086' '#1087#1088#1072#1081#1089#1091'2)'
      Hint = 
        'Excel - '#1055#1083#1072#1085#1086#1074#1072#1103' '#1055#1088#1080#1073#1099#1083#1100' ('#1088#1077#1072#1083#1080#1079'. '#1055#1088#1072#1081#1089' + '#1094#1077#1085#1072' c/c '#1092#1072#1082#1090' + '#1088#1072#1089#1093#1086#1076 +
        #1099' '#1087#1086' '#1087#1088#1072#1081#1089#1091'2)'
      ImageIndex = 22
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
          Name = 'isGoodsKind'
          Value = 'False'
          Component = cbGoodsKind
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isExcel'
          Value = True
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1083#1072#1085#1086#1074#1072#1103' '#1055#1088#1080#1073#1099#1083#1100' ('#1060#1072#1082#1090' '#1089#1077#1073#1077#1089#1090#1086#1080#1084#1086#1089#1090#1100' '#1080' '#1088#1072#1089#1093#1086#1076#1099' '#1080' '#1087#1088#1072#1081#1089')'
      ReportNameParam.Value = #1055#1083#1072#1085#1086#1074#1072#1103' '#1055#1088#1080#1073#1099#1083#1100' ('#1060#1072#1082#1090' '#1089#1077#1073#1077#1089#1090#1086#1080#1084#1086#1089#1090#1100' '#1080' '#1088#1072#1089#1093#1086#1076#1099' '#1080' '#1087#1088#1072#1081#1089')'
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
    Top = 216
  end
  inherited MasterCDS: TClientDataSet
    Left = 16
    Top = 216
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_ReceiptSaleAnalyze'
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
        Name = 'inUnitId_sale'
        Value = Null
        Component = FromUnitGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId_return'
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
        Name = 'inIsGoodsKind'
        Value = Null
        Component = cbGoodsKind
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 80
    Top = 216
  end
  inherited BarManager: TdxBarManager
    Top = 216
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
          ItemName = 'bbGoodsKind'
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
          ItemName = 'bbPrint_Real'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrint_Calc_PriceList'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrint_Calc'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrint_Profit'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrint_CalcPrice'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrint_DiffPrice'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrint_DiffPriceIn'
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
          ItemName = 'bbPrint_Calc_PriceListExcel'
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
    object bbPrint_Real: TdxBarButton
      Action = actPrint_Real
      Category = 0
    end
    object bbGoodsKind: TdxBarControlContainerItem
      Caption = 'bbGoodsKind'
      Category = 0
      Hint = 'bbGoodsKind'
      Visible = ivAlways
      Control = cbGoodsKind
    end
    object bbPrint_Calc_PriceList: TdxBarButton
      Action = actPrint_Calc_PriceList
      Category = 0
    end
    object bbPrint_Calc: TdxBarButton
      Action = actPrint_Calc
      Category = 0
    end
    object bbPrint_CalcPrice: TdxBarButton
      Action = actPrint_CalcPrice
      Category = 0
    end
    object bbPrint_DiffPrice: TdxBarButton
      Action = actPrint_DiffPrice
      Category = 0
    end
    object bbPrint_DiffPriceIn: TdxBarButton
      Action = actPrint_DiffPriceIn
      Category = 0
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbPrint_Calc_PriceListExcel: TdxBarButton
      Action = actPrint_Calc_PriceListExcel
      Category = 0
    end
    object bbPrint_Profit: TdxBarButton
      Action = actPrint_Profit
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    ColorRuleList = <
      item
        ValueColumn = Color_Profit
        ColorValueList = <>
      end>
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 64
    Top = 8
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    Left = 312
    Top = 176
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
    Left = 488
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
        Value = 'False'
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
        Value = 'False'
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
        Value = 'False'
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
        Value = 'False'
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
    IndexFieldNames = 'ReceiptId'
    Params = <>
    Left = 104
    Top = 168
  end
  object ChildDS: TDataSource
    DataSet = ChildCDS
    Left = 152
    Top = 168
  end
  object ChildViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = ChildView
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <
      item
        ColorColumn = GroupNumber
        ValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = GoodsGroupNameFull
        ValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = clGoodsCode
        ValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = clGoodsName
        ValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = GoodsKindName
        ValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = MeasureNameChild
        ValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = AmountChild
        ValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = clPrice1
        ValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = clPrice2
        ValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = clPrice3
        ValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = Summ1
        ValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = Summ2
        ValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = Summ3
        ValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = clInfoMoneyCodeChild
        ValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = clInfoMoneyGroupNameChild
        ValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = clInfoMoneyDestinationNameChild
        ValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = clInfoMoneyNameChild
        ValueColumn = Color_calc
        ColorValueList = <>
      end>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    Left = 544
    Top = 320
  end
end
