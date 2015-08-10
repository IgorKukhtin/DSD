inherited Report_ReceiptProductionOutAnalyzeForm: TReport_ReceiptProductionOutAnalyzeForm
  Caption = #1054#1090#1095#1077#1090' <'#1040#1085#1072#1083#1080#1079' '#1087#1083#1072#1085'/'#1092#1072#1082#1090' '#1088#1072#1089#1093#1086#1076' '#1085#1072' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086'>'
  ClientHeight = 430
  ClientWidth = 1130
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
              Column = OperCount_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperSumm
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCount_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperSumm
            end>
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object clCode: TcxGridDBColumn
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
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object Amount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object Amount_Weight: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' ('#1074#1077#1089')'
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
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object Price1_cost: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1079'. '#1055#1088#1072#1081#1089'1'
            DataBinding.FieldName = 'Price1_cost'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object Price2_cost: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1079'. '#1055#1088#1072#1081#1089'2'
            DataBinding.FieldName = 'Price2_cost'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object Price3_cost: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1079'. '#1055#1088#1072#1081#1089'3'
            DataBinding.FieldName = 'Price3_cost'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
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
          object OperCount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1087#1088#1086#1080#1079#1074'.'
            DataBinding.FieldName = 'OperCount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object OperCount_Weight: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1087#1088#1086#1080#1079#1074'. ('#1074#1077#1089')'
            DataBinding.FieldName = 'OperCount_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object Price_in: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1087#1088#1086#1080#1079#1074'.'
            DataBinding.FieldName = 'Price_in'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object OperSumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1088#1086#1080#1079#1074'.'
            DataBinding.FieldName = 'OperSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 81
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
          object Receiptid: TcxGridDBColumn
            DataBinding.FieldName = 'Receiptid'
            Visible = False
            VisibleForCustomization = False
            Width = 55
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
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_ReceiptProductionAnalyze'
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
      end
      item
        Name = 'inEndDate'
        Value = 41395d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inUnitFromId'
        Value = Null
        Component = FromUnitGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inUnitToId'
        Value = Null
        Component = ToUnitGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inGoodsGroupId'
        Value = Null
        Component = GoodsGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inPriceListId_1'
        Value = Null
        Component = PriceList_1_Guides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inPriceListId_2'
        Value = Null
        Component = PriceList_2_Guides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inPriceListId_3'
        Value = Null
        Component = PriceList_3_Guides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inPriceListId_sale'
        Value = Null
        Component = PriceList_sale_Guides
        ComponentItem = 'Key'
        ParamType = ptInput
      end>
  end
  inherited BarManager: TdxBarManager
    Left = 136
    DockControlHeights = (
      0
      0
      26
      0)
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    Left = 96
    Top = 120
  end
  object GoodsGroupGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoodsGroup
    FormNameParam.Value = 'TGoodsGroup_ObjectForm'
    FormNameParam.DataType = ftString
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
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 976
    Top = 32
  end
  object FromUnitGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edFromUnit
    FormNameParam.Value = 'TUnitTreeForm'
    FormNameParam.DataType = ftString
    FormName = 'TUnitTreeForm'
    PositionDataSet = 'ClientDataSet'
    ParentDataSet = 'TreeDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = FromUnitGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = FromUnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 408
  end
  object ToUnitGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edToUnit
    FormNameParam.Value = 'TUnitTreeForm'
    FormNameParam.DataType = ftString
    FormName = 'TUnitTreeForm'
    PositionDataSet = 'ClientDataSet'
    ParentDataSet = 'TreeDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ToUnitGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ToUnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 464
    Top = 24
  end
  object PriceList_1_Guides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPriceList_1
    FormNameParam.Value = 'TPriceList_ObjectForm'
    FormNameParam.DataType = ftString
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
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PriceList_1_Guides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'PriceWithVAT'
        Value = 'False'
        DataType = ftBoolean
        ParamType = ptInput
      end
      item
        Name = 'VATPercent'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'CurrencyId'
        Value = ''
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'CurrencyName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 636
    Top = 65528
  end
  object PriceList_2_Guides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPriceList_2
    FormNameParam.Value = 'TPriceList_ObjectForm'
    FormNameParam.DataType = ftString
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
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PriceList_2_Guides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'PriceWithVAT'
        Value = 'False'
        DataType = ftBoolean
        ParamType = ptInput
      end
      item
        Name = 'VATPercent'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'CurrencyId'
        Value = ''
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'CurrencyName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 644
    Top = 40
  end
  object PriceList_3_Guides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPriceList_3
    FormNameParam.Value = 'TPriceList_ObjectForm'
    FormNameParam.DataType = ftString
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
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PriceList_3_Guides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'PriceWithVAT'
        Value = 'False'
        DataType = ftBoolean
        ParamType = ptInput
      end
      item
        Name = 'VATPercent'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'CurrencyId'
        Value = ''
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'CurrencyName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 836
    Top = 16
  end
  object PriceList_sale_Guides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPriceList_sale
    FormNameParam.Value = 'TPriceList_ObjectForm'
    FormNameParam.DataType = ftString
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
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PriceList_sale_Guides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'PriceWithVAT'
        Value = 'False'
        DataType = ftBoolean
        ParamType = ptInput
      end
      item
        Name = 'VATPercent'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'CurrencyId'
        Value = ''
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'CurrencyName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
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
    Left = 136
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
