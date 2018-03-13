inherited ProductionUnionTechReceiptJournalForm: TProductionUnionTechReceiptJournalForm
  Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' - '#1058#1077#1093#1085#1086#1083#1086#1075' ('#1088#1077#1094#1077#1087#1090#1091#1088#1099')'
  ClientHeight = 685
  ClientWidth = 1076
  AddOnFormData.RefreshAction = actRefreshStart
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 1092
  ExplicitHeight = 720
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 61
    Width = 1076
    Height = 624
    TabOrder = 2
    ExplicitTop = 61
    ExplicitWidth = 1076
    ExplicitHeight = 624
    ClientRectBottom = 624
    ClientRectRight = 1076
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1076
      ExplicitHeight = 600
      inherited cxGrid: TcxGrid
        Width = 1076
        Height = 292
        ExplicitWidth = 1076
        ExplicitHeight = 292
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Count
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RealWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CuterCount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_order
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CuterCount_order
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_calc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CuterWeight
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Count
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RealWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CuterCount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_order
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CuterCount_order
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_calc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CuterWeight
            end>
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object LineNum: TcxGridDBColumn [0]
            Caption = #8470' '#1087'/'#1087
            DataBinding.FieldName = 'LineNum'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = '0.;-0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object StatusCode: TcxGridDBColumn [1]
            Caption = #1057#1090#1072#1090#1091#1089
            DataBinding.FieldName = 'StatusCode'
            PropertiesClassName = 'TcxImageComboBoxProperties'
            Properties.Images = dmMain.ImageList
            Properties.Items = <
              item
                Description = #1053#1077' '#1087#1088#1086#1074#1077#1076#1077#1085
                ImageIndex = 11
                Value = 1
              end
              item
                Description = #1055#1088#1086#1074#1077#1076#1077#1085
                ImageIndex = 12
                Value = 2
              end
              item
                Description = #1059#1076#1072#1083#1077#1085
                ImageIndex = 13
                Value = 3
              end>
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object InvNumber: TcxGridDBColumn [2]
            Caption = #8470' '#1044#1086#1082
            DataBinding.FieldName = 'InvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object OperDate: TcxGridDBColumn [3]
            Caption = #1044#1072#1090#1072
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object DocumentKindName: TcxGridDBColumn [4]
            Caption = #1058#1080#1087' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
            DataBinding.FieldName = 'DocumentKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 77
          end
          inherited colGoodsName: TcxGridDBColumn
            Options.Editing = False
          end
          object MeasureName: TcxGridDBColumn [7]
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object GoodsKindName: TcxGridDBColumn [8]
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object GoodsKindName_Complete: TcxGridDBColumn [9]
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' '#1043#1055
            DataBinding.FieldName = 'GoodsKindName_Complete'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actGoodsKindChoiceMaster
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object isOrderSecond: TcxGridDBColumn [10]
            Caption = #1044#1086#1079#1072#1103#1074#1082#1072
            DataBinding.FieldName = 'isOrderSecond'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object TermProduction: TcxGridDBColumn [11]
            Caption = #1050'. '#1076#1085'. '#1079#1072#1082#1088'. '#1087#1072#1088#1090'.'
            DataBinding.FieldName = 'TermProduction'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object PartionGoodsDate: TcxGridDBColumn [12]
            Caption = #1055#1072#1088#1090#1080#1103
            DataBinding.FieldName = 'PartionGoodsDate'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object PartionGoodsDateClose: TcxGridDBColumn [13]
            Caption = #1055#1083#1072#1085' '#1074#1099#1093#1086#1076' '#1043#1055
            DataBinding.FieldName = 'PartionGoodsDateClose'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object IsPartionClose: TcxGridDBColumn [14]
            Caption = #1055#1072#1088#1090#1080#1103' '#1079#1072#1082#1088#1099#1090#1072' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isPartionClose'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object CuterCount: TcxGridDBColumn [15]
            Caption = #1050#1091#1090#1090#1077#1088#1086#1074' '#1092#1072#1082#1090
            DataBinding.FieldName = 'CuterCount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object Amount: TcxGridDBColumn [16]
            Caption = #1060#1072#1082#1090' '#1082#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object Amount_calc: TcxGridDBColumn [17]
            Caption = #1056#1072#1089#1095#1077#1090' '#1082#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object CuterWeight: TcxGridDBColumn [18]
            Caption = #1042#1077#1089' '#1087'/'#1092' '#1092#1072#1082#1090'('#1082#1091#1090#1090#1077#1088')'
            DataBinding.FieldName = 'CuterWeight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object RealWeight: TcxGridDBColumn [19]
            Caption = #1042#1077#1089' '#1087'/'#1092' '#1092#1072#1082#1090
            DataBinding.FieldName = 'RealWeight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object Count: TcxGridDBColumn [20]
            Caption = #1050#1086#1083'-'#1074#1086' '#1073#1072#1090#1086#1085#1086#1074
            DataBinding.FieldName = 'Count'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object Amount_order: TcxGridDBColumn [21]
            Caption = #1050#1086#1083'-'#1074#1086' '#1079#1072#1103#1074#1082#1072
            DataBinding.FieldName = 'Amount_order'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object CuterCount_order: TcxGridDBColumn [22]
            Caption = #1050#1091#1090#1090#1077#1088#1086#1074' '#1079#1072#1103#1074#1082#1072
            DataBinding.FieldName = 'CuterCount_order'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object IsMain: TcxGridDBColumn [23]
            Caption = #1043#1083#1072#1074#1085'.'
            DataBinding.FieldName = 'isMain'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object ReceiptCode: TcxGridDBColumn [24]
            Caption = #1050#1086#1076' '#1088#1077#1094#1077#1087#1090'.'
            DataBinding.FieldName = 'ReceiptCode'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actReceiptChoice
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object ReceiptName: TcxGridDBColumn [25]
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1088#1077#1094#1077#1087#1090#1091#1088#1099
            DataBinding.FieldName = 'ReceiptName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actReceiptChoice
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object PartionGoods: TcxGridDBColumn [26]
            Caption = #1055#1072#1088#1090#1080#1103' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'PartionGoods'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object Comment_receipt: TcxGridDBColumn [27]
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' ('#1088#1077#1094#1077#1087#1090#1091#1088#1072')'
            DataBinding.FieldName = 'Comment_receipt'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object Comment: TcxGridDBColumn [28]
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' ('#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086')'
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object InsertName: TcxGridDBColumn [29]
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076#1072#1085#1080#1077')'
            DataBinding.FieldName = 'InsertName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object UpdateName: TcxGridDBColumn [30]
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072')'
            DataBinding.FieldName = 'UpdateName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 110
          end
          object InsertDate: TcxGridDBColumn [31]
            Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1089#1086#1079#1076#1072#1085#1080#1077')'
            DataBinding.FieldName = 'InsertDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
          object UpdateDate: TcxGridDBColumn [32]
            Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072')'
            DataBinding.FieldName = 'UpdateDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 110
          end
          inherited colIsErased: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
        end
      end
      inherited cxGridChild: TcxGrid
        Top = 297
        Width = 1076
        ExplicitTop = 297
        ExplicitWidth = 1076
        inherited cxGridDBTableViewChild: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = colChildAmountReceiptWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colChildAmountWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colChildAmountCalcWeight
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = colChildAmountReceiptWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colChildAmountWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colChildAmountCalcWeight
            end>
          Styles.Content = nil
          object colChildGroupNumber: TcxGridDBColumn [0]
            Caption = #1043#1088#1091#1087#1087#1072' '#8470
            DataBinding.FieldName = 'GroupNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object colChildMeasureName: TcxGridDBColumn [3]
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object colChildGoodsKindName: TcxGridDBColumn [4]
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actGoodsKindChoiceChild
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object colChildGoodsKindCompleteName: TcxGridDBColumn [5]
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' '#1043#1055
            DataBinding.FieldName = 'GoodsKindCompleteName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actGoodsKindCompleteChoiceChild
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object colChildAmountReceipt: TcxGridDBColumn [6]
            Caption = #1050#1086#1083'-'#1074#1086' 1 '#1082#1091#1090#1077#1088
            DataBinding.FieldName = 'AmountReceipt'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object colChildAmount: TcxGridDBColumn [7]
            Caption = #1050#1086#1083'-'#1074#1086' '#1092#1072#1082#1090
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object colChildAmountCalc: TcxGridDBColumn [8]
            Caption = #1050#1086#1083'-'#1074#1086' '#1088#1072#1089#1095#1077#1090
            DataBinding.FieldName = 'AmountCalc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object colChildAmountReceiptWeight: TcxGridDBColumn [9]
            Caption = #1050#1086#1083'-'#1074#1086' 1 '#1082#1091#1090#1077#1088' ('#1074#1077#1089')'
            DataBinding.FieldName = 'AmountReceiptWeight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object colChildAmountWeight: TcxGridDBColumn [10]
            Caption = #1050#1086#1083'-'#1074#1086' '#1092#1072#1082#1090' ('#1074#1077#1089')'
            DataBinding.FieldName = 'AmountWeight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object colChildAmountCalcWeight: TcxGridDBColumn [11]
            Caption = #1050#1086#1083'-'#1074#1086' '#1088#1072#1089#1095'. ('#1074#1077#1089')'
            DataBinding.FieldName = 'AmountCalcWeight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object isTaxExit: TcxGridDBColumn [12]
            Caption = #1047#1072#1074#1080#1089#1080#1090' '#1086#1090' % '#1074#1099#1093'.'
            DataBinding.FieldName = 'isTaxExit'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object isWeightMain: TcxGridDBColumn [13]
            Caption = #1042#1093#1086#1076#1080#1090' '#1074' '#1086#1089#1085'. '#1089#1099#1088#1100#1077' (100 '#1082#1075'.)'
            DataBinding.FieldName = 'isWeightMain'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object colChildPartionGoodsDate: TcxGridDBColumn [14]
            Caption = #1044#1072#1090#1072' '#1087#1072#1088#1090#1080#1080
            DataBinding.FieldName = 'PartionGoodsDate'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.SaveTime = False
            Properties.ShowTime = False
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object colChildPartionGoods: TcxGridDBColumn [15]
            Caption = #1055#1072#1088#1090#1080#1103' '#1089#1099#1088#1100#1103
            DataBinding.FieldName = 'PartionGoods'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object colChildComment: TcxGridDBColumn [16]
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object colChildInsertName: TcxGridDBColumn [17]
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076#1072#1085#1080#1077')'
            DataBinding.FieldName = 'InsertName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object colChildUpdateName: TcxGridDBColumn [18]
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072')'
            DataBinding.FieldName = 'UpdateName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 110
          end
          object colChildInsertDate: TcxGridDBColumn [19]
            Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1089#1086#1079#1076#1072#1085#1080#1077')'
            DataBinding.FieldName = 'InsertDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
          object colChildUpdateDate: TcxGridDBColumn [20]
            Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072')'
            DataBinding.FieldName = 'UpdateDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 110
          end
          object colChildColor_calc: TcxGridDBColumn [21]
            DataBinding.FieldName = 'Color_calc'
            Visible = False
            VisibleForCustomization = False
            Width = 55
          end
          inherited colChildIsErased: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 45
          end
        end
      end
      inherited cxBottomSplitter: TcxSplitter
        Top = 292
        Width = 1076
        ExplicitTop = 292
        ExplicitWidth = 1076
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 1076
    Height = 35
    ExplicitWidth = 1076
    ExplicitHeight = 35
    inherited edInvNumber: TcxTextEdit
      Left = 989
      Top = 7
      Visible = False
      ExplicitLeft = 989
      ExplicitTop = 7
      ExplicitWidth = 75
      Width = 75
    end
    inherited cxLabel1: TcxLabel
      Left = 987
      Top = -2
      Visible = False
      ExplicitLeft = 987
      ExplicitTop = -2
    end
    inherited edOperDate: TcxDateEdit
      Left = 1068
      Top = 7
      Visible = False
      ExplicitLeft = 1068
      ExplicitTop = 7
      ExplicitWidth = 61
      Width = 61
    end
    inherited cxLabel2: TcxLabel
      Left = 1068
      Top = -2
      Visible = False
      ExplicitLeft = 1068
      ExplicitTop = -2
    end
    inherited cxLabel15: TcxLabel
      Left = 1135
      Top = -2
      Visible = False
      ExplicitLeft = 1135
      ExplicitTop = -2
    end
    inherited ceStatus: TcxButtonEdit
      Left = 1135
      Top = 17
      Visible = False
      ExplicitLeft = 1135
      ExplicitTop = 17
      ExplicitWidth = 100
      ExplicitHeight = 22
      Width = 100
    end
    inherited cxLabel3: TcxLabel
      Left = 294
      Top = 8
      Caption = #1054#1090' '#1082#1086#1075#1086' :'
      ExplicitLeft = 294
      ExplicitTop = 8
      ExplicitWidth = 51
    end
    inherited cxLabel4: TcxLabel
      Left = 548
      Top = 8
      Caption = #1050#1086#1084#1091' :'
      ExplicitLeft = 548
      ExplicitTop = 8
      ExplicitWidth = 36
    end
    inherited edFrom: TcxButtonEdit
      Left = 345
      Top = 7
      ExplicitLeft = 345
      ExplicitTop = 7
      ExplicitWidth = 192
      Width = 192
    end
    inherited edTo: TcxButtonEdit
      Left = 584
      Top = 7
      ExplicitLeft = 584
      ExplicitTop = 7
      ExplicitWidth = 200
      Width = 200
    end
    object cxLabel5: TcxLabel
      Left = 5
      Top = 8
      Caption = #1044#1072#1090#1072' '#1089' :'
    end
    object deStart: TcxDateEdit
      Left = 52
      Top = 7
      EditValue = 42522d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 11
      Width = 85
    end
    object cxLabel6: TcxLabel
      Left = 144
      Top = 8
      Caption = #1044#1072#1090#1072' '#1087#1086' :'
    end
    object deEnd: TcxDateEdit
      Left = 198
      Top = 7
      EditValue = 42522d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 13
      Width = 85
    end
  end
  object edJuridicalBasis: TcxButtonEdit [2]
    Left = 900
    Top = 7
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 6
    Width = 150
  end
  object cxLabel27: TcxLabel [3]
    Left = 822
    Top = 8
    Caption = #1055#1088#1077#1076#1087#1088#1080#1103#1090#1080#1077':'
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
      end>
  end
  inherited ActionList: TActionList
    inherited actRefresh: TdsdDataSetRefresh
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      RefreshOnTabSetChanges = True
    end
    inherited actMISetErased: TdsdUpdateErased
      Enabled = False
    end
    inherited actMISetUnErased: TdsdUpdateErased
      Enabled = False
    end
    inherited actInsertUpdateMovement: TdsdExecStoredProc
      Enabled = False
      StoredProc = nil
      StoredProcList = <>
    end
    inherited actShowAll: TBooleanStoredProcAction
      Enabled = False
    end
    object actPrintCeh: TdsdPrintAction [8]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrintCeh
      StoredProcList = <
        item
          StoredProc = spSelectPrintCeh
        end>
      Caption = #1055#1077#1095#1072#1090#1100' - '#1042#1079#1074#1077#1096#1080#1074#1072#1085#1080#1077' '#1087'/'#1092' '#1092#1072#1082#1090' '#1082#1091#1090#1090#1077#1088#1072
      Hint = #1055#1077#1095#1072#1090#1100' - '#1042#1079#1074#1077#1096#1080#1074#1072#1085#1080#1077' '#1087'/'#1092' '#1092#1072#1082#1090' '#1082#1091#1090#1090#1077#1088#1072
      ImageIndex = 22
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      Params = <>
      ReportName = #1053#1072#1082#1083#1072#1076#1085#1072#1103' '#1087#1086' '#1074#1079#1074#1077#1096#1080#1074#1072#1085#1080#1102' '#1082#1091#1090#1090#1077#1088#1072
      ReportNameParam.Value = #1053#1072#1082#1083#1072#1076#1085#1072#1103' '#1087#1086' '#1074#1079#1074#1077#1096#1080#1074#1072#1085#1080#1102' '#1082#1091#1090#1090#1077#1088#1072
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
    end
    inherited actPrint: TdsdPrintAction
      MoveParams = <
        item
          FromParam.Name = 'isDetail'
          FromParam.Value = False
          FromParam.DataType = ftBoolean
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'isDetail'
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'isDetail'
          ToParam.DataType = ftBoolean
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProc = spReport_TaxExit
      StoredProcList = <
        item
          StoredProc = spReport_TaxExit
        end>
      Caption = #1054#1090#1095#1077#1090' <'#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' '#1080' '#1087#1088#1086#1094#1077#1085#1090' '#1074#1099#1093#1086#1076#1072' ('#1080#1090#1086#1075#1080')>'
      Hint = #1054#1090#1095#1077#1090' <'#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' '#1080' '#1087#1088#1086#1094#1077#1085#1090' '#1074#1099#1093#1086#1076#1072' ('#1080#1090#1086#1075#1080')>'
      DataSets = <
        item
          DataSet = PrintMasterCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 
            'GoodsGroupNameFull;GoodsName;PartionGoodsDate;GoodsKindName_Comp' +
            'lete'
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 'NULL'
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 'NULL'
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromId'
          Value = Null
          Component = GuidesFrom
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromName'
          Value = Null
          Component = GuidesFrom
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToId'
          Value = Null
          Component = GuidesTo
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToName'
          Value = Null
          Component = GuidesTo
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'isDetail'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isLoss'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' '#1080' '#1087#1088#1086#1094#1077#1085#1090' '#1074#1099#1093#1086#1076#1072' ('#1080#1090#1086#1075#1080')'
      ReportNameParam.Value = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' '#1080' '#1087#1088#1086#1094#1077#1085#1090' '#1074#1099#1093#1086#1076#1072' ('#1080#1090#1086#1075#1080')'
    end
    object actUpdateChildDS: TdsdUpdateDataSet [10]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMIChild
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIChild
        end>
      Caption = 'actUpdateChildDS'
      DataSource = ChildDS
    end
    inherited actAddMask: TdsdExecStoredProc
      Enabled = False
    end
    inherited InsertRecordChild: TInsertRecord
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090' ('#1088#1072#1089#1093#1086#1076')>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090' ('#1088#1072#1089#1093#1086#1076')>'
    end
    inherited actMIChildSetErased: TdsdUpdateErased
      Caption = #1059#1076#1072#1083#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090' ('#1088#1072#1089#1093#1086#1076')>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090' ('#1088#1072#1089#1093#1086#1076')>'
    end
    inherited actMIChildSetUnErased: TdsdUpdateErased
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090' ('#1088#1072#1089#1093#1086#1076')>'
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090' ('#1088#1072#1089#1093#1086#1076')>'
    end
    object actGoodsKindChoiceChild: TOpenChoiceForm [19]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'GoodsKindForm'
      FormName = 'TGoodsKindForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ChildCDS
          ComponentItem = 'GoodsKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ChildCDS
          ComponentItem = 'GoodsKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actGoodsKindChoiceMaster: TOpenChoiceForm [20]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'GoodsKindForm'
      FormName = 'TGoodsKindForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindCompleteId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindCompleteName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    inherited actMIMasterProtocol: TdsdOpenForm
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementItemId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
    end
    object MovementProtocolOpenForm: TdsdOpenForm [22]
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      ImageIndex = 34
      FormName = 'TMovementProtocolForm'
      FormNameParam.Value = 'TMovementProtocolForm'
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
          Name = 'InvNumber'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InvNumber'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actUpdate: TdsdInsertUpdateAction [23]
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090' ('#1087#1088#1080#1093#1086#1076')>'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090' ('#1087#1088#1080#1093#1086#1076')>'
      ShortCut = 115
      ImageIndex = 1
      FormName = 'TProductionUnionTechEditForm'
      FormNameParam.Value = 'TProductionUnionTechEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'MovementId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDate'
          Value = 41791d
          Component = MasterCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementItemId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MovementItemId_order'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementItemId_order'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromId'
          Value = Null
          Component = GuidesFrom
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToId'
          Value = Null
          Component = GuidesTo
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'DocumentKindId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'DocumentKindId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      ActionType = acUpdate
      DataSource = MasterDS
      DataSetRefresh = actRefresh
      IdFieldName = 'MovementItemId'
    end
    object actInsert: TdsdInsertUpdateAction [24]
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090' ('#1087#1088#1080#1093#1086#1076')>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090' ('#1087#1088#1080#1093#1086#1076')>'
      ImageIndex = 0
      FormName = 'TProductionUnionTechEditForm'
      FormNameParam.Value = 'TProductionUnionTechEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'MovementId'
          Value = 0
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDate'
          Value = 'NULL'
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Id'
          Value = 0
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MovementItemId_order'
          Value = 0
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromId'
          Value = Null
          Component = GuidesFrom
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToId'
          Value = Null
          Component = GuidesTo
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      DataSource = MasterDS
      DataSetRefresh = actRefresh
      IdFieldName = 'MovementItemId'
    end
    inherited actMIChildProtocol: TdsdOpenForm
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = ChildCDS
          ComponentItem = 'MovementItemId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
    end
    object actPrintReceipt: TdsdPrintAction [26]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spPrintReceipt
      StoredProcList = <
        item
          StoredProc = spPrintReceipt
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1088#1077#1094#1077#1087#1090#1091#1088#1099
      Hint = #1055#1077#1095#1072#1090#1100' '#1088#1077#1094#1077#1087#1090#1091#1088#1099
      ImageIndex = 17
      DataSets = <
        item
          DataSet = PrintMasterCDS
          UserName = 'Master'
          IndexFieldNames = 'ReceiptCode;ReceiptId;GroupNumber;InfoMoneyName;GoodsName'
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 41791d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 41791d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1077#1095#1072#1090#1100'_'#1088#1077#1094#1077#1087#1090#1086#1074
      ReportNameParam.Value = #1055#1077#1095#1072#1090#1100'_'#1088#1077#1094#1077#1087#1090#1086#1074
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
    end
    object actUnCompleteList: TMultiAction [27]
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actSimpleUncompleteList
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1088#1072#1089#1087#1088#1086#1074#1077#1076#1077#1085#1080#1080' '#1042#1089#1077#1093' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074'? '
      InfoAfterExecute = #1042#1089#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1088#1072#1089#1087#1088#1086#1074#1077#1076#1077#1085#1099
      Caption = #1056#1072#1089#1087#1088#1086#1074#1077#1089#1090#1080' '#1042#1089#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099
      Hint = #1056#1072#1089#1087#1088#1086#1074#1077#1089#1090#1080' '#1042#1089#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099
      ImageIndex = 11
    end
    object actSetErasedList: TMultiAction [28]
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actSimpleErased
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1091#1076#1072#1083#1077#1085#1080#1080' '#1042#1089#1077#1093' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074'? '
      InfoAfterExecute = #1042#1089#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1091#1076#1072#1083#1077#1085#1099
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1042#1089#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1042#1089#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099
      ImageIndex = 13
    end
    object actSimpleErased: TMultiAction [29]
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = spErased
        end>
      View = cxGridDBTableView
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090#1099
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090#1099
    end
    object spErased: TdsdExecStoredProc [30]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spMovementSetErased
      StoredProcList = <
        item
          StoredProc = spMovementSetErased
        end>
      Caption = 'spErased'
    end
    object actSimpleUncompleteList: TMultiAction [31]
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = spUncomplete
        end>
      View = cxGridDBTableView
      Caption = #1056#1072#1089#1087#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1099
      Hint = #1056#1072#1089#1087#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1099
    end
    object spUncomplete: TdsdExecStoredProc [32]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spMovementUnComplete
      StoredProcList = <
        item
          StoredProc = spMovementUnComplete
        end>
      Caption = 'spUncomplete'
    end
    object spCompete: TdsdExecStoredProc [33]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spMovementComplete
      StoredProcList = <
        item
          StoredProc = spMovementComplete
        end>
      Caption = 'spCompete'
    end
    object actSimpleCompleteList: TMultiAction [34]
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = spCompete
        end>
      View = cxGridDBTableView
      Caption = #1055#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074
      Hint = #1055#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074
    end
    object actCompleteList: TMultiAction [35]
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actSimpleCompleteList
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1080' '#1042#1089#1077#1093' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074'? '
      InfoAfterExecute = #1042#1089#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1087#1088#1086#1074#1077#1076#1077#1085#1099
      Caption = #1055#1088#1086#1074#1077#1089#1090#1080' '#1042#1089#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099
      Hint = #1055#1088#1086#1074#1077#1089#1090#1080' '#1042#1089#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099
      ImageIndex = 12
    end
    object actReCompleteList: TMultiAction [36]
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actSimpleReCompleteList
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1087#1077#1088#1077#1087#1088#1086#1074#1077#1076#1077#1085#1080#1080' '#1042#1089#1077#1093' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074'? '
      InfoAfterExecute = #1042#1089#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1087#1077#1088#1077#1087#1088#1086#1074#1077#1076#1077#1085#1099
      Caption = #1055#1077#1088#1077#1087#1088#1086#1074#1077#1089#1090#1080' '#1042#1089#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099
      Hint = #1055#1077#1088#1077#1087#1088#1086#1074#1077#1089#1090#1080' '#1042#1089#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099
      ImageIndex = 12
    end
    object actSimpleReCompleteList: TMultiAction [37]
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = spReCompete
        end>
      View = cxGridDBTableView
      Caption = #1055#1077#1088#1077#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074
      Hint = #1055#1077#1088#1077#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074
    end
    object spReCompete: TdsdExecStoredProc [38]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spMovementReComplete
      StoredProcList = <
        item
          StoredProc = spMovementReComplete
        end>
      Caption = 'spReCompete'
    end
    object actReport_TaxExit_Loss: TdsdPrintAction [39]
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'isDetail'
          FromParam.Value = True
          FromParam.DataType = ftBoolean
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'isDetail'
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'isDetail'
          ToParam.DataType = ftBoolean
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProc = spReport_TaxExit
      StoredProcList = <
        item
          StoredProc = spReport_TaxExit
        end>
      Caption = #1054#1090#1095#1077#1090' <'#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' '#1080' '#1087#1088#1086#1094#1077#1085#1090' '#1087#1086#1090#1077#1088#1100' ('#1080#1090#1086#1075#1080')>'
      Hint = #1054#1090#1095#1077#1090' <'#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' '#1080' '#1087#1088#1086#1094#1077#1085#1090' '#1087#1086#1090#1077#1088#1100' ('#1080#1090#1086#1075#1080')>'
      ImageIndex = 18
      ShortCut = 16464
      DataSets = <
        item
          DataSet = PrintMasterCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 
            'GoodsGroupNameFull;GoodsName;PartionGoodsDate;GoodsKindName_Comp' +
            'lete'
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 41791d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 41791d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromId'
          Value = ''
          Component = GuidesFrom
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromName'
          Value = ''
          Component = GuidesFrom
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToId'
          Value = ''
          Component = GuidesTo
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToName'
          Value = ''
          Component = GuidesTo
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'isDetail'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isLoss'
          Value = True
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' '#1080' '#1087#1088#1086#1094#1077#1085#1090' '#1074#1099#1093#1086#1076#1072' ('#1080#1090#1086#1075#1080')'
      ReportNameParam.Value = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' '#1080' '#1087#1088#1086#1094#1077#1085#1090' '#1074#1099#1093#1086#1076#1072' ('#1080#1090#1086#1075#1080')'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
    end
    object actReport_TaxLoss: TdsdPrintAction [40]
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'isDetail'
          FromParam.Value = False
          FromParam.DataType = ftBoolean
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'isDetail'
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'isDetail'
          ToParam.DataType = ftBoolean
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProc = spReport_TaxLoss
      StoredProcList = <
        item
          StoredProc = spReport_TaxLoss
        end>
      Caption = #1054#1090#1095#1077#1090' <'#1055#1088#1080#1093#1086#1076' '#1085#1072' '#1089#1082#1083#1072#1076' '#1080' '#1087#1088#1086#1094#1077#1085#1090' '#1087#1086#1090#1077#1088#1100' ('#1080#1090#1086#1075#1080')>'
      Hint = #1054#1090#1095#1077#1090' <'#1055#1088#1080#1093#1086#1076' '#1085#1072' '#1089#1082#1083#1072#1076' '#1080' '#1087#1088#1086#1094#1077#1085#1090' '#1087#1086#1090#1077#1088#1100' ('#1080#1090#1086#1075#1080')>'
      ImageIndex = 19
      DataSets = <
        item
          DataSet = PrintMasterCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GoodsGroupNameFull;GoodsName;GoodsKindName'
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 41791d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 41791d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromId'
          Value = Null
          Component = GuidesFrom
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromName'
          Value = Null
          Component = GuidesFrom
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToId'
          Value = Null
          Component = FormParams
          ComponentItem = 'ToId_baza'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToName'
          Value = Null
          Component = FormParams
          ComponentItem = 'ToName_baza'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'isDetail'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1088#1080#1093#1086#1076' '#1085#1072' '#1089#1082#1083#1072#1076' '#1080' '#1087#1088#1086#1094#1077#1085#1090' '#1087#1086#1090#1077#1088#1100' ('#1080#1090#1086#1075#1080')'
      ReportNameParam.Value = #1055#1088#1080#1093#1086#1076' '#1085#1072' '#1089#1082#1083#1072#1076' '#1080' '#1087#1088#1086#1094#1077#1085#1090' '#1087#1086#1090#1077#1088#1100' ('#1080#1090#1086#1075#1080')'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
    end
    object actReceiptChoice: TOpenChoiceForm [41]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actReceiptChoice'
      FormName = 'TReceipt_ObjectForm'
      FormNameParam.Value = 'TReceipt_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ReceiptId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ReceiptCode_user'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ReceiptCode'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ReceiptName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterReceiptId'
          Value = 0
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterGoodsId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterGoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterGoodsKindId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindId'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actUnComplete: TdsdChangeMovementStatus [45]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spMovementUnComplete
      StoredProcList = <
        item
          StoredProc = spMovementUnComplete
        end>
      Caption = #1056#1072#1089#1087#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090
      Hint = #1056#1072#1089#1087#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090
      ImageIndex = 11
      Status = mtUncomplete
      DataSource = MasterDS
    end
    object actComplete: TdsdChangeMovementStatus [46]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spMovementComplete
      StoredProcList = <
        item
          StoredProc = spMovementComplete
        end>
      Caption = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090
      Hint = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090
      ImageIndex = 12
      Status = mtComplete
      DataSource = MasterDS
    end
    object actSetErased: TdsdChangeMovementStatus [47]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spMovementSetErased
      StoredProcList = <
        item
          StoredProc = spMovementSetErased
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090
      ImageIndex = 13
      Status = mtDelete
      DataSource = MasterDS
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'Dialog'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TMovement_PeriodDialogForm'
      FormNameParam.Value = 'TMovement_PeriodDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 42156d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42156d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actGoodsKindCompleteChoiceChild: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actGoodsKindCompleteChoiceChild'
      FormName = 'TGoodsKind_ObjectForm'
      FormNameParam.Value = 'TGoodsKind_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ChildCDS
          ComponentItem = 'GoodsKindCompleteId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ChildCDS
          ComponentItem = 'GoodsKindCompleteName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actRefreshStart: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet_UserJuridicalBasis
      StoredProcList = <
        item
          StoredProc = spGet_UserJuridicalBasis
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_ProductionUnionTech'
    Params = <
      item
        Name = 'inStartDate'
        Value = 41791d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 41791d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFromId'
        Value = Null
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = False
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalBasisId'
        Value = Null
        Component = JuridicalBasisGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = Null
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
  end
  inherited BarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbComplete'
        end
        item
          Visible = True
          ItemName = 'bbUnComplete'
        end
        item
          Visible = True
          ItemName = 'bbSetErased'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
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
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbAddChild'
        end
        item
          Visible = True
          ItemName = 'bbErasedChild'
        end
        item
          Visible = True
          ItemName = 'bbUnErasedChild'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbShowErased'
        end
        item
          Visible = True
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrintReceipt'
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
          ItemName = 'bbReport_TaxExit_Loss'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbReport_TaxLoss'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrintCeh'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbMovementProtocol'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbMIMasterProtocol'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbMIChildProtocol'
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
    inherited dxBarStatic: TdxBarStatic
      ShowCaption = False
    end
    object bbEdit: TdxBarButton [18]
      Action = actUpdate
      Category = 0
    end
    object bbInsert: TdxBarButton [19]
      Action = actInsert
      Category = 0
    end
    object bbPrintReceipt: TdxBarButton [20]
      Action = actPrintReceipt
      Category = 0
    end
    object bbReport_TaxLoss: TdxBarButton [21]
      Action = actReport_TaxLoss
      Category = 0
    end
    object bbReport_TaxExit_Loss: TdxBarButton [22]
      Action = actReport_TaxExit_Loss
      Category = 0
    end
    object bbComplete: TdxBarButton [23]
      Action = actComplete
      Category = 0
    end
    object bbUnComplete: TdxBarButton [24]
      Action = actUnComplete
      Category = 0
    end
    object bbSetErased: TdxBarButton [25]
      Action = actSetErased
      Category = 0
    end
    object bbMovementProtocol: TdxBarButton [26]
      Action = MovementProtocolOpenForm
      Category = 0
    end
    object bbPrintCeh: TdxBarButton
      Action = actPrintCeh
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnDblClickActionList = <
      item
        Action = actUpdate
      end>
  end
  inherited PopupMenu: TPopupMenu
    Left = 144
    Top = 144
    object N7: TMenuItem [0]
      Action = actInsert
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100
      ShortCut = 45
    end
    object N8: TMenuItem [1]
      Action = actUpdate
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100
    end
    object N9: TMenuItem [2]
      Caption = '-'
    end
    inherited N6: TMenuItem [3]
      Action = actComplete
      Enabled = False
    end
    inherited N5: TMenuItem [4]
      Action = actUnComplete
      Enabled = False
    end
    object N11: TMenuItem [5]
      Action = actSetErased
    end
    object N12: TMenuItem [6]
      Caption = '-'
    end
    object N13: TMenuItem [7]
      Action = actReCompleteList
    end
    object N14: TMenuItem [8]
      Action = actCompleteList
    end
    object N15: TMenuItem [9]
      Action = actUnCompleteList
    end
    object N16: TMenuItem [10]
      Action = actSetErasedList
    end
    object N10: TMenuItem [11]
      Caption = '-'
    end
    inherited N1: TMenuItem [12]
    end
    inherited Excel1: TMenuItem [13]
    end
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Key'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ShowAll'
        Value = False
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSumm'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MIOrderId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'FromId'
        Value = Null
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'FromName'
        Value = Null
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToId'
        Value = Null
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToName'
        Value = Null
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToId_baza'
        Value = 8458
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToName_baza'
        Value = #1057#1082#1083#1072#1076' '#1041#1072#1079#1072' '#1043#1055
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isDetail'
        Value = Null
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
  end
  inherited StatusGuides: TdsdGuides
    Left = 1152
    Top = 16
  end
  inherited spChangeStatus: TdsdStoredProc
    Left = 1032
    Top = 8
  end
  inherited spGet: TdsdStoredProc
    OutputType = otResult
    Left = 288
    Top = 168
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    Left = 442
    Top = 136
  end
  inherited GuidesFiller: TGuidesFiller
    ActionItemList = <
      item
        Action = actRefresh
      end>
  end
  inherited HeaderSaver: THeaderSaver
    Left = 328
    Top = 137
  end
  inherited spErasedMIMaster: TdsdStoredProc
    StoredProcName = ''
    Left = 694
    Top = 512
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = ''
    Left = 646
    Top = 528
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_ProductionUnionTech_Master'
    Params = <
      item
        Name = 'inMovementItemId_order'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementItemId_order'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioMovementItemId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementItemId'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReceiptId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ReceiptId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Count'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRealWeight'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'RealWeight'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    Left = 376
    Top = 256
  end
  inherited ChildCDS: TClientDataSet
    MasterFields = 'MovementItemId'
  end
  inherited spErasedMIChild: TdsdStoredProc
    StoredProcName = 'gpMovementItem_ProductionUnionTech_SetErased'
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'MovementItemId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmount_master'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
  end
  inherited spUnErasedMIChild: TdsdStoredProc
    StoredProcName = 'gpMovementItem_ProductionUnionTech_SetUnErased'
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'MovementItemId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmount_master'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
  end
  inherited GuidesTo: TdsdGuides
    PositionDataSet = 'MasterCDS'
    Left = 672
    Top = 65528
  end
  inherited GuidesFrom: TdsdGuides
    PositionDataSet = 'MasterCDS'
    Left = 448
    Top = 65528
  end
  inherited spInsertUpdateMIChild: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_ProductionUnionTech_Child'
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'MovementItemId'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioAmount'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParentId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementItemId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioAmountReceipt'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'AmountReceipt'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmount_master'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmountWeight'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'AmountWeight'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmountReceiptWeight'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'AmountReceiptWeight'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsWeightMain'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'isWeightMain'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsTaxExit'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'isTaxExit'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'outGroupNumber'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'GroupNumber'
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionGoodsDate'
        Value = 'NULL'
        Component = ChildCDS
        ComponentItem = 'PartionGoodsDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindCompleteId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'GoodsKindCompleteId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
  end
  inherited ChildDBViewAddOn: TdsdDBViewAddOn
    ColorRuleList = <
      item
        ColorColumn = colChildGroupNumber
        ValueColumn = colChildColor_calc
        ColorValueList = <>
      end
      item
        ColorColumn = colChildGoodsCode
        ValueColumn = colChildColor_calc
        ColorValueList = <>
      end
      item
        ColorColumn = colChildGoodsName
        ValueColumn = colChildColor_calc
        ColorValueList = <>
      end
      item
        ColorColumn = colChildMeasureName
        ValueColumn = colChildColor_calc
        ColorValueList = <>
      end
      item
        ColorColumn = colChildAmountReceipt
        ValueColumn = colChildColor_calc
        ColorValueList = <>
      end
      item
        ColorColumn = colChildAmount
        ValueColumn = colChildColor_calc
        ColorValueList = <>
      end
      item
        ColorColumn = colChildAmountCalc
        ValueColumn = colChildColor_calc
        ColorValueList = <>
      end
      item
        ColorColumn = colChildAmountWeight
        ValueColumn = colChildColor_calc
        ColorValueList = <>
      end
      item
        ColorColumn = colChildAmountCalcWeight
        ValueColumn = colChildColor_calc
        ColorValueList = <>
      end
      item
        ColorColumn = isTaxExit
        ValueColumn = colChildColor_calc
        ColorValueList = <>
      end>
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = GuidesFrom
      end
      item
        Component = GuidesTo
      end
      item
        Component = JuridicalBasisGuides
      end>
    Left = 288
    Top = 232
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 176
    Top = 56
  end
  object PrintMasterCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 708
    Top = 233
  end
  object spReport_TaxExit: TdsdStoredProc
    StoredProcName = 'gpReport_GoodsMI_ProductionUnion_TaxExit'
    DataSet = PrintMasterCDS
    DataSets = <
      item
        DataSet = PrintMasterCDS
      end>
    Params = <
      item
        Name = 'inStartDate'
        Value = 41791d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 41791d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFromId'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = Null
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsDetail'
        Value = False
        Component = FormParams
        ComponentItem = 'isDetail'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 496
    Top = 264
  end
  object spPrintReceipt: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Receipt_Print'
    DataSet = PrintMasterCDS
    DataSets = <
      item
        DataSet = PrintMasterCDS
      end>
    Params = <
      item
        Name = 'inReceiptId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = ''
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindId'
        Value = 41791d
        Component = MasterCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inShowAll'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 424
    Top = 185
  end
  object spReport_TaxLoss: TdsdStoredProc
    StoredProcName = 'gpReport_GoodsMI_ProductionUnion_TaxLoss'
    DataSet = PrintMasterCDS
    DataSets = <
      item
        DataSet = PrintMasterCDS
      end>
    Params = <
      item
        Name = 'inStartDate'
        Value = 41791d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 41791d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFromId'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = Null
        Component = FormParams
        ComponentItem = 'ToId_baza'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsDetail'
        Value = False
        Component = FormParams
        ComponentItem = 'isDetail'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 528
    Top = 304
  end
  object spMovementUnComplete: TdsdStoredProc
    StoredProcName = 'gpUnComplete_Movement_ProductionUnion'
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
      end>
    PackSize = 1
    Left = 48
    Top = 288
  end
  object spMovementSetErased: TdsdStoredProc
    StoredProcName = 'gpSetErased_Movement_ProductionUnion'
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
      end>
    PackSize = 1
    Left = 80
    Top = 272
  end
  object spMovementComplete: TdsdStoredProc
    StoredProcName = 'gpComplete_Movement_ProductionUnion'
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
        Name = 'inIsLastComplete'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 151
    Top = 299
  end
  object spMovementReComplete: TdsdStoredProc
    StoredProcName = 'gpReComplete_Movement_ProductionUnion'
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
      end>
    PackSize = 1
    Left = 912
    Top = 144
  end
  object spSelectPrintCeh: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_ProductionUnion_Ceh_Print'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end
      item
        DataSet = PrintItemsCDS
      end>
    OutputType = otMultiDataSet
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
        Name = 'inMovementId_Weighing'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsAll'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 551
    Top = 144
  end
  object JuridicalBasisGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edJuridicalBasis
    Key = '0'
    FormNameParam.Value = 'TJuridical_BasisForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridical_BasisForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = JuridicalBasisGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = JuridicalBasisGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 943
  end
  object spGet_UserJuridicalBasis: TdsdStoredProc
    StoredProcName = 'gpGet_User_JuridicalBasis'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'JuridicalBasisId'
        Value = '0'
        Component = JuridicalBasisGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalBasisName'
        Value = ''
        Component = JuridicalBasisGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 824
    Top = 48
  end
end
