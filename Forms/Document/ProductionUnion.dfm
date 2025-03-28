inherited ProductionUnionForm: TProductionUnionForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' - '#1089#1084#1077#1096#1080#1074#1072#1085#1080#1077'>'
  ClientWidth = 1181
  ExplicitWidth = 1197
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 122
    Width = 1181
    Height = 552
    TabOrder = 2
    ExplicitTop = 122
    ExplicitWidth = 1128
    ExplicitHeight = 552
    ClientRectBottom = 552
    ClientRectRight = 1181
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1128
      ExplicitHeight = 528
      inherited cxGrid: TcxGrid
        Width = 1181
        Height = 220
        ExplicitWidth = 1128
        ExplicitHeight = 220
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Count
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
              Column = Amount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CuterWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RealWeightMsg
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RealWeightShp
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountReal
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountReal_LAK
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountForm
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountNext_out
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountForm_two
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Count
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
              Column = Amount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CuterWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RealWeightMsg
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RealWeightShp
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountReal
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountReal_LAK
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountForm
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountNext_out
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountForm_two
            end>
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object GoodsGroupNameFull: TcxGridDBColumn [0]
            Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
            DataBinding.FieldName = 'GoodsGroupNameFull'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object MeasureName: TcxGridDBColumn [3]
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object GoodsKindName: TcxGridDBColumn [4]
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actGoodsKindChoiceMaster
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object GoodsKindName_Complete: TcxGridDBColumn [5]
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' '#1043#1055
            DataBinding.FieldName = 'GoodsKindName_Complete'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actGoodsKindCompleteChoiceMaster
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object CuterCount: TcxGridDBColumn [6]
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
          object CuterWeight: TcxGridDBColumn [7]
            Caption = #1042#1077#1089' '#1087'/'#1092' '#1092#1072#1082#1090'('#1082#1091#1090#1090#1077#1088')'
            DataBinding.FieldName = 'CuterWeight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object RealWeight: TcxGridDBColumn [8]
            Caption = #1042#1077#1089' '#1087'/'#1092' '#1092#1072#1082#1090
            DataBinding.FieldName = 'RealWeight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object RealWeightMsg: TcxGridDBColumn [9]
            Caption = #1042#1077#1089' '#1087'/'#1092' '#1092#1072#1082#1090' ('#1084#1089#1078')'
            DataBinding.FieldName = 'RealWeightMsg'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1077#1089' '#1087'/'#1092' '#1092#1072#1082#1090' ('#1087#1086#1089#1083#1077' '#1084#1072#1089#1089#1072#1078#1077#1088#1072')'
            Options.Editing = False
            Width = 70
          end
          object RealWeightShp: TcxGridDBColumn [10]
            Caption = #1042#1077#1089' '#1087'/'#1092' '#1092#1072#1082#1090' ('#1096#1087#1088')'
            DataBinding.FieldName = 'RealWeightShp'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1077#1089' '#1087'/'#1092' '#1092#1072#1082#1090' ('#1087#1086#1089#1083#1077' '#1096#1087#1088#1080#1094#1077#1074#1072#1085#1080#1103')'
            Options.Editing = False
            Width = 70
          end
          object CountReal: TcxGridDBColumn [11]
            Caption = #1050#1086#1083'. '#1096#1090'. '#1092#1072#1082#1090' ('#1090#1091#1096#1077#1085#1082#1072')'
            DataBinding.FieldName = 'CountReal'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'. '#1096#1090'. '#1092#1072#1082#1090' ('#1090#1091#1096#1077#1085#1082#1072')'
            Options.Editing = False
            Width = 70
          end
          object CountReal_LAK: TcxGridDBColumn [12]
            Caption = #1050#1086#1083'-'#1074#1086' '#1042#1077#1089' ('#1083#1072#1082')'
            DataBinding.FieldName = 'CountReal_LAK'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1087#1088#1080' '#1086#1087#1077#1088#1072#1094#1080#1080' "'#1051#1072#1082#1080#1088#1086#1074#1072#1085#1080#1077'"'
            Options.Editing = False
            Width = 70
          end
          object Amount_Remains: TcxGridDBColumn [13]
            Caption = #1054#1089#1090#1072#1090#1086#1082' ('#1080#1085#1092'.)'
            DataBinding.FieldName = 'Amount_Remains'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object isClose: TcxGridDBColumn [14]
            Caption = #1047#1072#1082#1088#1099#1090' '#1076#1083#1103' '#1087#1077#1088#1077#1089#1095#1077#1090#1072
            DataBinding.FieldName = 'isClose'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object Count: TcxGridDBColumn [15]
            Caption = #1050#1086#1083'-'#1074#1086' '#1073#1072#1090#1086#1085#1086#1074
            DataBinding.FieldName = 'Count'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object Amount: TcxGridDBColumn [16]
            Caption = #1050#1086#1083'-'#1074#1086' '#1087#1088#1080#1093#1086#1076
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Amount_weight: TcxGridDBColumn [17]
            Caption = #1042#1077#1089' '#1087#1088#1080#1093#1086#1076
            DataBinding.FieldName = 'Amount_weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object AmountForm: TcxGridDBColumn [18]
            Caption = #1050#1086#1083'-'#1074#1086' '#1092#1086#1088#1084#1086#1074#1082#1072'+1'#1076#1077#1085#1100', '#1082#1075
            DataBinding.FieldName = 'AmountForm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1092#1086#1088#1084#1086#1074#1082#1072'+1'#1076#1077#1085#1100','#1082#1075
            Options.Editing = False
            Width = 69
          end
          object AmountForm_two: TcxGridDBColumn [19]
            Caption = #1050#1086#1083'-'#1074#1086' '#1092#1086#1088#1084#1086#1074#1082#1072'+2'#1076#1077#1085#1100', '#1082#1075
            DataBinding.FieldName = 'AmountForm_two'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1092#1086#1088#1084#1086#1074#1082#1072'+2'#1076#1077#1085#1100','#1082#1075
            Options.Editing = False
            Width = 69
          end
          object AmountNext_out: TcxGridDBColumn [20]
            Caption = #1055#1077#1088#1077#1093#1086#1076#1103#1097#1080#1081' '#1055'/'#1060' ('#1087#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076')'
            DataBinding.FieldName = 'AmountNext_out'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object PartionGoodsDate: TcxGridDBColumn [21]
            Caption = #1055#1072#1088#1090#1080#1103' ('#1076#1072#1090#1072')'
            DataBinding.FieldName = 'PartionGoodsDate'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.SaveTime = False
            Properties.ShowTime = False
            Properties.UseNullString = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object PartionGoods: TcxGridDBColumn [22]
            Caption = #1055#1072#1088#1090#1080#1103' '#1089#1099#1088#1100#1103
            DataBinding.FieldName = 'PartionGoods'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object ReceiptCode: TcxGridDBColumn [23]
            Caption = #1050#1086#1076' '#1088#1077#1094#1077#1087#1090'.'
            DataBinding.FieldName = 'ReceiptCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object ReceiptName: TcxGridDBColumn [24]
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1088#1077#1094#1077#1087#1090#1091#1088#1099
            DataBinding.FieldName = 'ReceiptName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object IsPartionClose: TcxGridDBColumn [25]
            Caption = #1055#1072#1088#1090#1080#1103' '#1079#1072#1082#1088#1099#1090#1072' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isPartionClose'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object Comment: TcxGridDBColumn [26]
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 150
          end
          object InfoMoneyCode: TcxGridDBColumn [27]
            Caption = #1050#1086#1076' '#1059#1055
            DataBinding.FieldName = 'InfoMoneyCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object InfoMoneyGroupName: TcxGridDBColumn [28]
            Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object InfoMoneyDestinationName: TcxGridDBColumn [29]
            Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
            DataBinding.FieldName = 'InfoMoneyDestinationName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object InfoMoneyName: TcxGridDBColumn [30]
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object InfoMoneyName_all: TcxGridDBColumn [31]
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103
            DataBinding.FieldName = 'InfoMoneyName_all'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
          object isAuto: TcxGridDBColumn [32]
            Caption = #1040#1074#1090'.'
            DataBinding.FieldName = 'isAuto'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 30
          end
          inherited colIsErased: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          object PersonalName_KVK: TcxGridDBColumn
            Caption = #1054#1087#1077#1088#1072#1090#1086#1088' '#1050#1042#1050' ('#1060'.'#1048'.'#1054')'
            DataBinding.FieldName = 'PersonalName_KVK'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actPersonalChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1087#1077#1088#1072#1090#1086#1088' '#1050#1042#1050' ('#1060'.'#1048'.'#1054')'
            Width = 100
          end
          object PositionName_KVK: TcxGridDBColumn
            Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100' ('#1054#1087'. '#1050#1042#1050')'
            DataBinding.FieldName = 'PositionName_KVK'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1083#1078#1085#1086#1089#1090#1100' ('#1054#1087#1077#1088#1072#1090#1086#1088' '#1050#1042#1050')'
            Options.Editing = False
            Width = 78
          end
          object UnitName_KVK: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1054#1087'. '#1050#1042#1050')'
            DataBinding.FieldName = 'UnitName_KVK'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1054#1087#1077#1088#1072#1090#1086#1088' '#1050#1042#1050')'
            Options.Editing = False
            Width = 83
          end
          object KVK: TcxGridDBColumn
            Caption = #8470' '#1050#1042#1050
            DataBinding.FieldName = 'KVK'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #8470' '#1050#1042#1050
            Width = 70
          end
          object StorageName: TcxGridDBColumn
            Caption = #1052#1077#1089#1090#1086' '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1087#1072#1088#1090#1080#1103' '#1058#1052#1062')'
            DataBinding.FieldName = 'StorageName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actPartionGoodsAssetChoiceMaster
                Default = True
                Kind = bkEllipsis
              end>
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object PartNumber: TcxGridDBColumn
            Caption = #8470' '#1087#1086' '#1090#1077#1093' '#1087#1072#1089#1087#1086#1088#1090#1091
            DataBinding.FieldName = 'PartNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object Model: TcxGridDBColumn
            Caption = #1052#1086#1076#1077#1083#1100
            DataBinding.FieldName = 'Model'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
        end
      end
      inherited cxGridChild: TcxGrid
        Top = 225
        Width = 1181
        ExplicitTop = 225
        ExplicitWidth = 1128
        inherited cxGridDBTableViewChild: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = colChildAmountReceipt
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colChildAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colChildAmount_weight
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = colChildAmountReceipt
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colChildAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colChildAmount_weight
            end>
          OptionsData.CancelOnExit = False
          Styles.Content = nil
          object colChildGroupNumber: TcxGridDBColumn [0]
            Caption = #1043#1088#1091#1087#1087#1072' '#8470
            DataBinding.FieldName = 'GroupNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object colChildGoodsGroupNameFull: TcxGridDBColumn [1]
            Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
            DataBinding.FieldName = 'GoodsGroupNameFull'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object colChildMeasureName: TcxGridDBColumn [4]
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object colChildGoodsKindName: TcxGridDBColumn [5]
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
            Width = 103
          end
          object colChildGoodsKindCompleteName: TcxGridDBColumn [6]
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
          object colChildAmountReceipt: TcxGridDBColumn [7]
            Caption = #1050#1086#1083'-'#1074#1086' 1 '#1082#1091#1090#1077#1088
            DataBinding.FieldName = 'AmountReceipt'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object colchildCount_onCount: TcxGridDBColumn [8]
            Caption = #1050#1086#1083'-'#1074#1086' '#1073#1072#1090#1086#1085#1086#1074
            DataBinding.FieldName = 'Count_onCount'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 59
          end
          object colChildAmount: TcxGridDBColumn [9]
            Caption = #1050#1086#1083'-'#1074#1086' '#1092#1072#1082#1090
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object colChildAmount_weight: TcxGridDBColumn [10]
            Caption = #1042#1077#1089' '#1092#1072#1082#1090
            DataBinding.FieldName = 'Amount_weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 52
          end
          object colChildPartionGoods: TcxGridDBColumn [11]
            Caption = #1055#1072#1088#1090#1080#1103' '#1089#1099#1088#1100#1103
            DataBinding.FieldName = 'PartionGoods'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object colChildPartionGoodsDate: TcxGridDBColumn [12]
            Caption = #1055#1072#1088#1090#1080#1103' ('#1076#1072#1090#1072')'
            DataBinding.FieldName = 'PartionGoodsDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object colChildComment: TcxGridDBColumn [13]
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 150
          end
          object colChildIsAuto: TcxGridDBColumn [14]
            Caption = #1040#1074#1090'.'
            DataBinding.FieldName = 'isAuto'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          inherited colChildIsErased: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          object colChildStorageName: TcxGridDBColumn
            Caption = #1052#1077#1089#1090#1086' '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1087#1072#1088#1090#1080#1103' '#1058#1052#1062')'
            DataBinding.FieldName = 'StorageName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actPartionGoodsAssetChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object colChildPartNumber: TcxGridDBColumn
            Caption = #8470' '#1087#1086' '#1090#1077#1093' '#1087#1072#1089#1087#1086#1088#1090#1091
            DataBinding.FieldName = 'PartNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object colChildModel: TcxGridDBColumn
            Caption = #1052#1086#1076#1077#1083#1100
            DataBinding.FieldName = 'Model'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object colChildisEtiketka: TcxGridDBColumn
            Caption = #1055#1077#1088#1077#1082#1083#1077#1081#1082#1072' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isEtiketka'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
        end
      end
      inherited cxBottomSplitter: TcxSplitter
        Top = 220
        Width = 1181
        ExplicitTop = 220
        ExplicitWidth = 1128
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 1181
    Height = 96
    ExplicitWidth = 1128
    ExplicitHeight = 96
    inherited cxLabel15: TcxLabel
      Left = 10
      Top = 44
      Caption = '*'#1057#1090#1072#1090#1091#1089
      ExplicitLeft = 10
      ExplicitTop = 44
      ExplicitWidth = 46
    end
    inherited ceStatus: TcxButtonEdit
      Left = 10
      ExplicitLeft = 10
      ExplicitWidth = 200
      ExplicitHeight = 22
      Width = 200
    end
    inherited cxLabel3: TcxLabel
      Left = 370
      ExplicitLeft = 370
    end
    inherited cxLabel4: TcxLabel
      Left = 618
      ExplicitLeft = 618
    end
    inherited edFrom: TcxButtonEdit
      Left = 370
      ExplicitLeft = 370
      ExplicitWidth = 239
      Width = 239
    end
    inherited edTo: TcxButtonEdit
      Left = 618
      ExplicitLeft = 618
      ExplicitWidth = 231
      Width = 231
    end
    object cxLabel5: TcxLabel
      Left = 216
      Top = 5
      Caption = #1044#1072#1090#1072'/'#1074#1088'. '#1089#1086#1079#1076'. '#1082#1083#1072#1076#1086#1074#1097'.'
    end
    object cxLabel6: TcxLabel
      Left = 618
      Top = 44
      Caption = #1058#1080#1087' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
    end
    object edDocumentKind: TcxButtonEdit
      Left = 618
      Top = 61
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 12
      Width = 231
    end
    object cxLabel17: TcxLabel
      Left = 414
      Top = 44
      Caption = #1047#1072#1103#1074#1082#1072
    end
    object edInvNumberOrder: TcxButtonEdit
      Left = 414
      Top = 61
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 14
      Width = 195
    end
    object edJuridicalFrom: TcxButtonEdit
      Left = 320
      Top = 38
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 15
      Visible = False
      Width = 64
    end
    object cbClosed: TcxCheckBox
      Left = 1039
      Top = 25
      Hint = #1047#1072#1082#1088#1099#1090' '#1076#1083#1103' '#1087#1077#1088#1077#1089#1095#1077#1090#1072' ('#1076#1072'/'#1085#1077#1090')'
      Caption = #1047#1072#1082#1088#1099#1090' '#1076#1083#1103' '#1087#1077#1088#1077#1089#1095#1077#1090#1072
      Properties.ReadOnly = True
      TabOrder = 16
      Width = 145
    end
    object cxLabel30: TcxLabel
      Left = 858
      Top = 5
      Caption = #1054#1089#1085#1086#1074#1072#1085#1080#1077' '#1076#1083#1103' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103
    end
    object edSubjectDoc: TcxButtonEdit
      Left = 858
      Top = 23
      Properties.Buttons = <
        item
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 18
      Width = 175
    end
    object cbisEtiketka: TcxCheckBox
      Left = 1039
      Top = 4
      Caption = #1055#1077#1088#1077#1082#1083#1077#1081#1082#1072' ('#1076#1072'/'#1085#1077#1090')'
      Properties.ReadOnly = True
      TabOrder = 19
      Width = 148
    end
    object cxLabel27: TcxLabel
      Left = 1044
      Top = 44
      Caption = #8470' '#1076#1086#1082'. '#1087#1077#1088#1077#1089#1086#1088#1090#1080#1094#1099
    end
    object edInvNumberPeresort: TcxButtonEdit
      Left = 1044
      Top = 61
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 21
      Width = 133
    end
  end
  object edIsAuto: TcxCheckBox [2]
    Left = 216
    Top = 65
    Caption = #1057#1086#1079#1076#1072#1085' '#1072#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080' ('#1076#1072'/'#1085#1077#1090')'
    Properties.ReadOnly = True
    TabOrder = 6
    Width = 192
  end
  object edInsert: TcxDateEdit [3]
    Left = 216
    Top = 23
    EditValue = 42206d
    Properties.DateButtons = [btnClear, btnToday]
    Properties.DisplayFormat = 'dd.mm.yyyy hh:mm'
    Properties.EditFormat = 'dd.mm.yyyy hh:mm'
    Properties.InputKind = ikMask
    Properties.Kind = ckDateTime
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 145
  end
  object cbisPeresort: TcxCheckBox [4]
    Left = 216
    Top = 43
    Caption = #1055#1077#1088#1077#1089#1086#1088#1090#1080#1094#1072' ('#1076#1072'/'#1085#1077#1090')'
    Properties.ReadOnly = True
    TabOrder = 8
    Width = 192
  end
  object cxLabel7: TcxLabel [5]
    Left = 858
    Top = 44
    Caption = #1044#1086#1082#1091#1084#1077#1085#1090' '#1086#1089#1085#1086#1074#1072#1085#1080#1077
  end
  object edProductionMov: TcxButtonEdit [6]
    Left = 858
    Top = 61
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 10
    Width = 175
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 555
    Top = 0
  end
  inherited ActionList: TActionList
    object actUpdate_AmountNext_out: TdsdUpdateDataSet [0]
      Category = 'AmountNext_out'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_MI_AmountNext_out
      StoredProcList = <
        item
          StoredProc = spUpdate_MI_AmountNext_out
        end>
      Caption = 'actUpdate_Invnumber'
    end
    object actUpdate_AmountForm_two: TdsdUpdateDataSet [1]
      Category = 'AmountForm'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_AmountForm_two
      StoredProcList = <
        item
          StoredProc = spUpdate_AmountForm_two
        end>
      Caption = 'Update_AmountForm_two'
    end
    object actExecuteDialog_AmountForm_two: TExecuteDialog [2]
      Category = 'AmountForm'
      MoveParams = <>
      Caption = 'ExecuteDialog_AmountForm_two'
      FormName = 'TAmountForm_twoDialogForm'
      FormNameParam.Value = 'TAmountForm_twoDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'AmountForm_two'
          Value = Null
          Component = FormParams
          ComponentItem = 'AmountForm_two'
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'AmountForm_two'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'AmountForm_two'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actRefreshMI: TdsdDataSetRefresh [3]
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
      RefreshOnTabSetChanges = True
    end
    object mactUpdate_AmountForm_two: TMultiAction [4]
      Category = 'AmountForm'
      MoveParams = <>
      ActionList = <
        item
          Action = actExecuteDialog_AmountForm_two
        end
        item
          Action = actUpdate_AmountForm_two
        end
        item
          Action = actRefreshMI
        end>
      QuestionBeforeExecute = #1048#1079#1084#1077#1085#1080#1090#1100' '#1050#1086#1083'-'#1074#1086' '#1092#1086#1088#1084#1086#1074#1082#1072'+2'#1076#1077#1085#1100'?'
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1050#1086#1083'-'#1074#1086' '#1092#1086#1088#1084#1086#1074#1082#1072'+2'#1076#1077#1085#1100
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1050#1086#1083'-'#1074#1086' '#1092#1086#1088#1084#1086#1074#1082#1072'+2'#1076#1077#1085#1100
      ImageIndex = 43
    end
    inherited actRefresh: TdsdDataSetRefresh
      RefreshOnTabSetChanges = True
    end
    object actPrintNoGroup: TdsdPrintAction [13]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrintNoGroup
      StoredProcList = <
        item
          StoredProc = spSelectPrintNoGroup
        end>
      Caption = #1055#1077#1095#1072#1090#1100' ('#1076#1077#1090#1072#1083#1100#1085#1086')'
      Hint = #1055#1077#1095#1072#1090#1100' ('#1076#1077#1090#1072#1083#1100#1085#1086')'
      ImageIndex = 16
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
      ReportName = 'PrintMovement_Send'
      ReportNameParam.Value = 'PrintMovement_Send'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    inherited actPrint: TdsdPrintAction
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      ReportName = 'PrintMovement_Send'
      ReportNameParam.Value = 'PrintMovement_Send'
    end
    object actUpdateMI_Closed: TdsdExecStoredProc [15]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_MI_Close
      StoredProcList = <
        item
          StoredProc = spUpdate_MI_Close
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1086' '#1090#1086#1074#1072#1088#1091' "'#1047#1072#1082#1088#1099#1090' '#1076#1083#1103' '#1087#1077#1088#1077#1089#1095#1077#1090#1072'"'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1086' '#1090#1086#1074#1072#1088#1091' "'#1047#1072#1082#1088#1099#1090' '#1076#1083#1103' '#1087#1077#1088#1077#1089#1095#1077#1090#1072'"'
      ImageIndex = 76
    end
    object actUpdate_Closed: TdsdExecStoredProc [16]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Closed
      StoredProcList = <
        item
          StoredProc = spUpdate_Closed
        end
        item
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1083#1103' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' "'#1047#1072#1082#1088#1099#1090' '#1076#1083#1103' '#1087#1077#1088#1077#1089#1095#1077#1090#1072'"'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1083#1103' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' "'#1047#1072#1082#1088#1099#1090' '#1076#1083#1103' '#1087#1077#1088#1077#1089#1095#1077#1090#1072'" ('#1076#1072'/'#1085#1077#1090')'
      ImageIndex = 77
    end
    object actUpdateChildDS: TdsdUpdateDataSet [17]
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
    object actPrint1: TdsdPrintAction [22]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrint1
      StoredProcList = <
        item
          StoredProc = spSelectPrint1
        end>
      Caption = #1055#1077#1095#1072#1090#1100
      Hint = #1055#1077#1095#1072#1090#1100
      ImageIndex = 3
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_ProductionUnion'
      ReportNameParam.Name = #1053#1072#1082#1083#1072#1076#1085#1072#1103
      ReportNameParam.Value = 'PrintMovement_ProductionUnion'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actGoodsKindChoiceChild: TOpenChoiceForm [28]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actGoodsKindChoiceChild'
      FormName = 'TGoodsKind_ObjectForm'
      FormNameParam.Value = 'TGoodsKind_ObjectForm'
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
    object actPersonalChoiceForm: TOpenChoiceForm [29]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actPersonalChoiceMaster'
      FormName = 'TPersonal_ObjectForm'
      FormNameParam.Value = 'TPersonal_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PersonalId_KVK'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PersonalName_KVK'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actGoodsKindChoiceMaster: TOpenChoiceForm [30]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actGoodsKindChoiceMaster'
      FormName = 'TGoodsKind_ObjectForm'
      FormNameParam.Value = 'TGoodsKind_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    inherited actGoodsChoiceMaster: TOpenChoiceForm
      isShowModal = False
    end
    inherited actGoodsChoiceChild: TOpenChoiceForm
      isShowModal = False
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
    object actGoodsKindCompleteChoiceMaster: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actGoodsKindCompleteChoiceMaster'
      FormName = 'TGoodsKind_ObjectForm'
      FormNameParam.Value = 'TGoodsKind_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindId_Complete'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindName_Complete'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actOpenProductionPeresortForm: TdsdOpenForm
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1055#1077#1088#1077#1089#1086#1088#1090#1080#1094#1072'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1055#1077#1088#1077#1089#1086#1088#1090#1080#1094#1072'>'
      ImageIndex = 26
      FormName = 'TProductionPeresortForm'
      FormNameParam.Value = 'TProductionPeresortForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = '0'
          Component = GuidesProductionPeresort
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ShowAll'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = 42086d
          Component = edOperDate
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actPrintCeh: TdsdPrintAction
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
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actMovementForm: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = getMovementForm
      StoredProcList = <
        item
          StoredProc = getMovementForm
        end>
      Caption = 'actMovementForm'
    end
    object actOpenForm: TdsdOpenForm
      Category = 'DSDLib'
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
          Value = 42005d
          Component = edOperDate
          ComponentItem = 'OperDate'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Id'
          Value = Null
          Component = GuidesProduction
          ComponentItem = 'Key'
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
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object macOpenDocument: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actGet_checkopen
        end
        item
          Action = actMovementForm
        end
        item
          Action = actOpenForm
        end>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1086#1089#1085#1086#1074#1072#1085#1080#1103
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1086#1089#1085#1086#1074#1072#1085#1080#1103
      ImageIndex = 28
    end
    object actGet_checkopen: TdsdExecStoredProc
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_checkopen
      StoredProcList = <
        item
          StoredProc = spGet_checkopen
        end>
      Caption = 'actGet_checkopen_Sale'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1055#1088#1086#1076#1072#1078#1072'>'
      ImageIndex = 24
    end
    object actPartionGoodsAssetChoiceForm: TOpenChoiceForm
      Category = 'Asset'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1090#1080#1102' <'#1054#1057'> ('#1088#1072#1089#1093#1086#1076')'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1090#1080#1102' <'#1054#1057'> ('#1088#1072#1089#1093#1086#1076')'
      ImageIndex = 1
      FormName = 'TPartionGoodsAssetChoiceForm'
      FormNameParam.Value = 'TPartionGoodsAssetChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inGoodsId'
          Value = Null
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inGoodsName'
          Value = Null
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'inUnitId'
          Value = ''
          Component = GuidesFrom
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inUnitName'
          Value = ''
          Component = GuidesFrom
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Key'
          Value = Null
          ParamType = ptUnknown
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartionGoods'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Price'
          Value = Null
          DataType = ftFloat
          ParamType = ptUnknown
          MultiSelectSeparator = ','
        end
        item
          Name = 'Amount'
          Value = Null
          Component = ChildCDS
          ComponentItem = 'Amount'
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = ChildCDS
          ComponentItem = 'GoodsId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = ChildCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartNumber'
          Value = Null
          Component = ChildCDS
          ComponentItem = 'PartNumber'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actInsertRecordAsset: TInsertRecord
      Category = 'Asset'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableViewChild
      Action = actPartionGoodsAssetChoiceForm
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1072#1088#1090#1080#1102' <'#1054#1057'> ('#1088#1072#1089#1093#1086#1076')'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1072#1088#1090#1080#1102' <'#1054#1057'> ('#1088#1072#1089#1093#1086#1076')'
      ImageIndex = 0
    end
    object macInsertRecordAsset: TMultiAction
      Category = 'Asset'
      TabSheet = tsMain
      MoveParams = <>
      ActionList = <
        item
          Action = actInsertRecordAsset
        end
        item
        end>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1072#1088#1090#1080#1102' <'#1054#1057'> ('#1088#1072#1089#1093#1086#1076')'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1072#1088#1090#1080#1102' <'#1054#1057'> ('#1088#1072#1089#1093#1086#1076')'
      ImageIndex = 0
    end
    object actPartionGoodsAssetChoiceMaster: TOpenChoiceForm
      Category = 'Asset'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1090#1080#1102' <'#1054#1057'>'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1090#1080#1102' <'#1054#1057'>'
      ImageIndex = 1
      FormName = 'TPartionGoodsAssetChoiceForm'
      FormNameParam.Value = 'TPartionGoodsAssetChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inGoodsId'
          Value = Null
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inGoodsName'
          Value = Null
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'inUnitId'
          Value = ''
          Component = GuidesFrom
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inUnitName'
          Value = ''
          Component = GuidesFrom
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Key'
          Value = Null
          ParamType = ptUnknown
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartionGoods'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Price'
          Value = Null
          DataType = ftFloat
          ParamType = ptUnknown
          MultiSelectSeparator = ','
        end
        item
          Name = 'Amount'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Amount_Remains'
          DataType = ftFloat
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
          Name = 'PartNumber'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartNumber'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actUpdate_AmountForm: TdsdUpdateDataSet
      Category = 'AmountForm'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_AmountForm
      StoredProcList = <
        item
          StoredProc = spUpdate_AmountForm
        end>
      Caption = 'actUpdate_Invnumber'
    end
    object actExecuteDialog_AmountForm: TExecuteDialog
      Category = 'AmountForm'
      MoveParams = <>
      Caption = 'actUpdate_InvnumberDialog'
      FormName = 'TAmountFormDialogForm'
      FormNameParam.Value = 'TAmountFormDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'AmountForm'
          Value = ''
          Component = FormParams
          ComponentItem = 'AmountForm'
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'AmountForm'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'AmountForm'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object mactUpdate_AmountForm: TMultiAction
      Category = 'AmountForm'
      MoveParams = <>
      ActionList = <
        item
          Action = actExecuteDialog_AmountForm
        end
        item
          Action = actUpdate_AmountForm
        end
        item
          Action = actRefreshMI
        end>
      QuestionBeforeExecute = #1048#1079#1084#1077#1085#1080#1090#1100' '#1050#1086#1083'-'#1074#1086' '#1092#1086#1088#1084#1086#1074#1082#1072'+1'#1076#1077#1085#1100'?'
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1050#1086#1083'-'#1074#1086' '#1092#1086#1088#1084#1086#1074#1082#1072'+1'#1076#1077#1085#1100
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1050#1086#1083'-'#1074#1086' '#1092#1086#1088#1084#1086#1074#1082#1072'+1'#1076#1077#1085#1100
      ImageIndex = 43
    end
    object mactUpdate_AmountNext_out: TMultiAction
      Category = 'AmountNext_out'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_AmountNext_out
        end
        item
          Action = actRefreshMI
        end>
      QuestionBeforeExecute = #1047#1072#1087#1086#1083#1085#1080#1090#1100' <'#1055#1077#1088#1077#1093#1086#1076#1103#1097#1080#1081' '#1055'/'#1060' ('#1088#1072#1089#1093#1086#1076')>?'
      Caption = #1047#1072#1087#1086#1083#1085#1080#1090#1100' <'#1055#1077#1088#1077#1093#1086#1076#1103#1097#1080#1081' '#1055'/'#1060' ('#1088#1072#1089#1093#1086#1076')>'
      Hint = #1047#1072#1087#1086#1083#1085#1080#1090#1100' <'#1055#1077#1088#1077#1093#1086#1076#1103#1097#1080#1081' '#1055'/'#1060' ('#1088#1072#1089#1093#1086#1076')>'
      ImageIndex = 80
    end
  end
  inherited MasterDS: TDataSource
    Left = 768
    Top = 216
  end
  inherited MasterCDS: TClientDataSet
    Top = 208
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MI_ProductionUnion'
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
          ItemName = 'bbInsertUpdateMovement'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bbShowErased'
        end
        item
          Visible = True
          ItemName = 'bbShowAll'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbAddMask'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
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
          Visible = True
          ItemName = 'dxBarStatic'
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
          ItemName = 'bbInsertRecordAsset'
        end
        item
          Visible = True
          ItemName = 'bbPartionGoodsAssetChoice'
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
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbsUpdate'
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
          ItemName = 'bbOpenProductionPeresortForm'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbMIContainer'
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
    object bbPrint1: TdxBarButton
      Action = actPrint1
      Caption = #1053#1072#1082#1083#1072#1076#1085#1072#1103
      Category = 0
      ImageIndex = 16
    end
    object bbPrintCeh: TdxBarButton
      Action = actPrintCeh
      Category = 0
    end
    object bbPrintNoGroup: TdxBarButton
      Action = actPrintNoGroup
      Category = 0
    end
    object bbUpdate_Closed: TdxBarButton
      Action = actUpdate_Closed
      Category = 0
    end
    object bbUpdateMI_Closed: TdxBarButton
      Action = actUpdateMI_Closed
      Category = 0
    end
    object bbOpenDocument: TdxBarButton
      Action = macOpenDocument
      Category = 0
    end
    object bbInsertRecordAsset: TdxBarButton
      Action = macInsertRecordAsset
      Category = 0
    end
    object bbPartionGoodsAssetChoice: TdxBarButton
      Action = actPartionGoodsAssetChoiceForm
      Category = 0
    end
    object bbUpdate_AmountForm: TdxBarButton
      Action = mactUpdate_AmountForm
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
          ItemName = 'bbPrintNoGroup'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator2'
        end
        item
          Visible = True
          ItemName = 'bbPrint1'
        end
        item
          Visible = True
          ItemName = 'bbPrintCeh'
        end>
    end
    object dxBarSeparator2: TdxBarSeparator
      Caption = 'Separator'
      Category = 0
      Hint = 'Separator'
      Visible = ivAlways
      ShowCaption = False
    end
    object bbUpdate_AmountNext_out: TdxBarButton
      Action = mactUpdate_AmountNext_out
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
          ItemName = 'bbUpdate_Closed'
        end
        item
          Visible = True
          ItemName = 'bbUpdateMI_Closed'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_AmountForm'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_AmountForm_two'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_AmountNext_out'
        end>
    end
    object bbUpdate_AmountForm_two: TdxBarButton
      Action = mactUpdate_AmountForm_two
      Category = 0
    end
    object bbOpenProductionPeresortForm: TdxBarButton
      Action = actOpenProductionPeresortForm
      Category = 0
    end
  end
  inherited PopupMenu: TPopupMenu
    Left = 96
    Top = 272
  end
  inherited StatusGuides: TdsdGuides
    Tag = 123
    Left = 88
    Top = 56
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_ProductionUnion'
    Left = 48
    Top = 64
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_ProductionUnion'
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = Null
        Component = FormParams
        ComponentItem = 'inOperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber'
        Value = ''
        Component = edInvNumber
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusCode'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusName'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'TextValue'
        DataType = ftString
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
        Name = 'DocumentKindId'
        Value = Null
        Component = GuidesDocumentKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'DocumentKindName'
        Value = Null
        Component = GuidesDocumentKind
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'IsAuto'
        Value = False
        Component = edIsAuto
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'InsertDate'
        Value = 'Null'
        Component = edInsert
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId_Order'
        Value = Null
        Component = OrderGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_Order'
        Value = Null
        Component = OrderGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalId_From'
        Value = Null
        Component = JuridicalFromGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName_From'
        Value = Null
        Component = JuridicalFromGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isPeresort'
        Value = Null
        Component = cbisPeresort
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isClosed'
        Value = Null
        Component = cbClosed
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId_Production'
        Value = Null
        Component = GuidesProduction
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_ProductionFull'
        Value = Null
        Component = GuidesProduction
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'SubjectDocId'
        Value = Null
        Component = GuidesSubjectDoc
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'SubjectDocName'
        Value = Null
        Component = GuidesSubjectDoc
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isEtiketka'
        Value = Null
        Component = cbisEtiketka
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId_Peresort'
        Value = Null
        Component = GuidesProductionPeresort
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_PeresortFull'
        Value = Null
        Component = GuidesProductionPeresort
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 328
    Top = 176
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_ProductionUnion'
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumber'
        Value = ''
        Component = edInvNumber
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 0d
        Component = edOperDate
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
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDocumentKindId'
        Value = Null
        Component = GuidesDocumentKind
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSubjectDocId'
        Value = Null
        Component = GuidesSubjectDoc
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsPeresort'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 522
    Top = 264
  end
  inherited GuidesFiller: TGuidesFiller
    GuidesList = <
      item
        Guides = GuidesFrom
      end
      item
        Guides = GuidesTo
      end>
  end
  inherited HeaderSaver: THeaderSaver
    ControlList = <
      item
        Control = edInvNumber
      end
      item
        Control = edOperDate
      end
      item
        Control = edFrom
      end
      item
        Control = edTo
      end
      item
        Control = edDocumentKind
      end>
  end
  inherited spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_ProductionUnion_Master_SetErased'
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_ProductionUnion_Master_SetUnErased'
    Left = 334
    Top = 224
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_ProductionUnion_Master'
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
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
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
        Name = 'inAmount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
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
        Name = 'inCuterWeight'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CuterWeight'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionGoodsDate'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionGoodsDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionGoods'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionGoods'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPartNumber'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartNumber'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioModel'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Model'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindId_Complete'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindId_Complete'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStorageId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'StorageId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalId_KVK'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PersonalId_KVK'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKVK'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'KVK'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 552
    Top = 192
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_ProductionUnion_Master'
    Params = <
      item
        Name = 'ioId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
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
        Name = 'inAmount'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCount'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCuterWeight'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CuterWeight'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionGoodsDate'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionGoodsDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionGoods'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionGoods'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPartNumber'
        Value = Null
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioModel'
        Value = Null
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindId_Complete'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindId_Complete'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStorageId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalId_KVK'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PersonalId_KVK'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKVK'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'KVK'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 416
    Top = 280
  end
  inherited spErasedMIChild: TdsdStoredProc
    StoredProcName = 'gpMovementItem_ProductionUnion_Child_SetErased'
  end
  inherited spUnErasedMIChild: TdsdStoredProc
    StoredProcName = 'gpMovementItem_ProductionUnion_Child_SetUnErased'
  end
  inherited spInsertMaskMIChild: TdsdStoredProc
    Left = 656
    Top = 456
  end
  inherited GuidesTo: TdsdGuides
    FormNameParam.Value = 'TStoragePlace_ObjectForm'
    FormName = 'TStoragePlace_ObjectForm'
    Left = 704
    Top = 0
  end
  inherited GuidesFrom: TdsdGuides
    FormNameParam.Value = 'TStoragePlace_ObjectForm'
    FormName = 'TStoragePlace_ObjectForm'
    Left = 496
  end
  inherited spInsertUpdateMIChild: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_ProductionUnion_Child'
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
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
        Name = 'inAmount'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCount_onCount'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Count_onCount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParentId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'ParentId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionGoodsDate'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'PartionGoodsDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionGoods'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'PartionGoods'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPartNumber'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'PartNumber'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioModel'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Model'
        DataType = ftString
        ParamType = ptInputOutput
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
        Name = 'inStorageId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'StorageId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 520
    Top = 520
  end
  inherited PrintHeaderCDS: TClientDataSet
    Left = 716
    Top = 265
  end
  inherited PrintItemsCDS: TClientDataSet
    Left = 644
    Top = 270
  end
  object spSelectPrint: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Send_Print'
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
        Component = FormParams
        ComponentItem = 'Id'
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
        Name = 'inisItem'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 759
    Top = 320
  end
  object spSelectPrint1: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_ProductionUnion_Print'
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
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 383
    Top = 176
  end
  object GuidesDocumentKind: TdsdGuides
    KeyField = 'Id'
    LookupControl = edDocumentKind
    FormNameParam.Value = 'TDocumentKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TDocumentKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesDocumentKind
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesDocumentKind
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 640
    Top = 56
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
        Component = FormParams
        ComponentItem = 'Id'
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
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 423
    Top = 408
  end
  object OrderGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edInvNumberOrder
    Key = '0'
    FormNameParam.Value = 'TOrderIncomeJournalChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TOrderIncomeJournalChoiceForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = OrderGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_Full'
        Value = ''
        Component = OrderGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterJuridicalId'
        Value = ''
        Component = JuridicalFromGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterJuridicalName'
        Value = ''
        Component = JuridicalFromGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 524
    Top = 32
  end
  object spUpdateOrder: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_ProductionUnion_Order'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_Order'
        Value = '0'
        Component = OrderGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 241
    Top = 280
  end
  object HeaderSaver3: THeaderSaver
    IdParam.Value = Null
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    IdParam.MultiSelectSeparator = ','
    StoredProc = spUpdateOrder
    ControlList = <
      item
        Control = edInvNumberOrder
      end>
    GetStoredProc = spGet
    Left = 320
    Top = 273
  end
  object JuridicalFromGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edJuridicalFrom
    FormNameParam.Name = 'TJuridical_ObjectForm'
    FormNameParam.Value = 'TJuridical_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridical_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <>
    Left = 369
    Top = 120
  end
  object spSelectPrintNoGroup: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Send_Print'
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
        Component = FormParams
        ComponentItem = 'Id'
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
        Name = 'inisItem'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 551
    Top = 432
  end
  object spUpdate_Closed: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_ProductionUnion_Closed'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisClosed'
        Value = False
        Component = cbClosed
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outClosed'
        Value = False
        Component = cbClosed
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 80
    Top = 420
  end
  object spUpdate_MI_Close: TdsdStoredProc
    StoredProcName = 'gpUpdateMovementItem_Close'
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
        Name = 'ioisClose'
        Value = False
        Component = MasterCDS
        ComponentItem = 'isClose'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 265
    Top = 424
  end
  object GuidesProduction: TdsdGuides
    KeyField = 'Id'
    LookupControl = edProductionMov
    DisableGuidesOpen = True
    Key = '0'
    FormNameParam.Value = 'TSaleJournalChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TSaleJournalChoiceForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GuidesProduction
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_Full'
        Value = ''
        Component = GuidesProduction
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterJuridicalId'
        Value = ''
        Component = JuridicalFromGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterJuridicalName'
        Value = ''
        Component = JuridicalFromGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 908
    Top = 56
  end
  object getMovementForm: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Form'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = GuidesProduction
        ComponentItem = 'Key'
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
    Left = 976
    Top = 200
  end
  object spGet_checkopen: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_checkopen'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = GuidesProduction
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 971
    Top = 258
  end
  object TdsdStoredProc
    StoredProcName = 'gpGet_Movement_checkopen'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        ComponentItem = 'MovementId_sale'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outFormName'
        Value = Null
        ComponentItem = 'outFormName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1267
    Top = 234
  end
  object GuidesSubjectDoc: TdsdGuides
    KeyField = 'Id'
    LookupControl = edSubjectDoc
    FormNameParam.Value = 'TSubjectDocForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TSubjectDocForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesSubjectDoc
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesSubjectDoc
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 944
  end
  object spUpdate_AmountForm: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_ProductionUnion_AmountForm'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = '0'
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountForm'
        Value = ''
        Component = FormParams
        ComponentItem = 'AmountForm'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1000
    Top = 459
  end
  object spUpdate_MI_AmountNext_out: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_ProductionUnion_AmountNext_out'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 361
    Top = 472
  end
  object spUpdate_AmountForm_two: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_ProductionUnion_AmountForm_two'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountForm_two'
        Value = Null
        Component = FormParams
        ComponentItem = 'AmountForm_two'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1000
    Top = 507
  end
  object GuidesProductionPeresort: TdsdGuides
    KeyField = 'Id'
    LookupControl = edInvNumberPeresort
    Key = '0'
    FormNameParam.Value = 'TProductionPeresortJournalForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TProductionPeresortJournalForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GuidesProductionPeresort
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_Full'
        Value = ''
        Component = GuidesProductionPeresort
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 1084
    Top = 64
  end
end
