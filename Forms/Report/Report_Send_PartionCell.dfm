inherited Report_Send_PartionCellForm: TReport_Send_PartionCellForm
  Caption = '<'#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072' '#1087#1086' '#1071#1095#1077#1081#1082#1072#1084' '#1093#1088#1072#1085#1077#1085#1080#1103'>'
  ClientHeight = 408
  ClientWidth = 1540
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.Params = FormParams
  ExplicitWidth = 1556
  ExplicitHeight = 447
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 97
    Width = 1540
    Height = 311
    TabOrder = 3
    ExplicitTop = 97
    ExplicitWidth = 1540
    ExplicitHeight = 311
    ClientRectBottom = 311
    ClientRectRight = 1540
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1540
      ExplicitHeight = 311
      inherited cxGrid: TcxGrid
        Width = 1540
        Height = 311
        ExplicitLeft = 3
        ExplicitTop = 24
        ExplicitWidth = 1540
        ExplicitHeight = 311
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_Weight
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = GoodsName
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_Weight
            end>
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object Ord: TcxGridDBColumn
            Caption = #8470' '#1087'/'#1087
            DataBinding.FieldName = 'Ord'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 40
          end
          object ItemName: TcxGridDBColumn
            Caption = #1044#1086#1082#1091#1084#1077#1085#1090
            DataBinding.FieldName = 'ItemName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object isRePack: TcxGridDBColumn
            Caption = #1055#1077#1088#1077#1087#1072#1082
            DataBinding.FieldName = 'isRePack'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 67
          end
          object InvNumber: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'.'
            DataBinding.FieldName = 'InvNumber'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object OperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072
            DataBinding.FieldName = 'OperDate'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object FromName: TcxGridDBColumn
            Caption = #1054#1090' '#1082#1086#1075#1086
            DataBinding.FieldName = 'FromName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
          object ToName: TcxGridDBColumn
            Caption = #1050#1086#1084#1091
            DataBinding.FieldName = 'ToName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
          object InsertDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1089#1086#1079#1076#1072#1085#1080#1103
            DataBinding.FieldName = 'InsertDate'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 68
          end
          object InsertName: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' '#1089#1086#1079#1076'.'
            DataBinding.FieldName = 'InsertName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 98
          end
          object GoodsGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072
            DataBinding.FieldName = 'GoodsGroupName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object GoodsGroupNameFull: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
            DataBinding.FieldName = 'GoodsGroupNameFull'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 200
          end
          object GoodsKindName: TcxGridDBColumn
            Caption = #1042#1080#1076
            DataBinding.FieldName = 'GoodsKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object isChoiceCell_mi: TcxGridDBColumn
            Caption = #1057#1085#1103#1090#1100' '#1089' '#1093#1088#1072#1085#1077#1085#1080#1103
            DataBinding.FieldName = 'isChoiceCell_mi'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object InsertDate_ChoiceCell_mi: TcxGridDBColumn
            Caption = '***'#1057#1085#1103#1090#1100' '#1089' '#1093#1088#1072#1085#1077#1085#1080#1103
            DataBinding.FieldName = 'InsertDate_ChoiceCell_mi'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1089#1082#1072#1085#1080#1088#1086#1074#1072#1085#1080#1103' '#1076#1083#1103' '#1084#1077#1089#1090#1072' '#1086#1090#1073#1086#1088#1072
            Options.Editing = False
            Width = 70
          end
          object PartionGoodsDate_next: TcxGridDBColumn
            Caption = '***'#1055#1072#1088#1090#1080#1103' ('#1076#1072#1090#1072')'
            DataBinding.FieldName = 'PartionGoodsDate_next'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1085#1103#1090#1100' '#1089' '#1093#1088#1072#1085#1077#1085#1080#1103
            Options.Editing = False
            Width = 70
          end
          object PartionGoodsDate: TcxGridDBColumn
            Caption = #1055#1072#1088#1090#1080#1103' ('#1076#1072#1090#1072')'
            DataBinding.FieldName = 'PartionGoodsDate'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.SaveTime = False
            Properties.ShowTime = False
            Properties.UseNullString = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 84
          end
          object NormInDays: TcxGridDBColumn
            Caption = #1057#1088#1086#1082' '#1074' '#1076#1085#1103#1093
            DataBinding.FieldName = 'NormInDays'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1088#1086#1082' '#1093#1088#1072#1085#1077#1085#1080#1103' '#1074' '#1076#1085#1103#1093
            Options.Editing = False
            Width = 50
          end
          object Marker_NormInDays: TcxGridDBColumn
            Caption = #1052#1072#1088#1082#1077#1088
            DataBinding.FieldName = 'Marker_NormInDays'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1076#1083#1103' 0 - '#1041#1086#1083#1100#1096#1077' 70%, '#1076#1083#1103' 1 - '#1086#1090' 50% '#1076#1086' 70%, '#1076#1083#1103' 2 - '#1084#1077#1085#1100#1096#1077' 50%'
            Options.Editing = False
            Width = 55
          end
          object NormInDays_real: TcxGridDBColumn
            Caption = #1054#1089#1090'. '#1074' '#1076#1085#1103#1093
            DataBinding.FieldName = 'NormInDays_real'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1095#1077#1090' '#1086#1089#1090#1072#1090#1082#1072' '#1074' '#1076#1085#1103#1093' '#1076#1083#1103' '#1057#1088#1086#1082#1072' '#1093#1088#1072#1085#1077#1085#1080#1103
            Options.Editing = False
            Width = 50
          end
          object NormInDays_tax: TcxGridDBColumn
            Caption = #1054#1089#1090'. '#1074' %'
            DataBinding.FieldName = 'NormInDays_tax'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1095#1077#1090' '#1086#1089#1090#1072#1090#1082#1072' '#1076#1085#1077#1081' '#1074' % '#1076#1083#1103' '#1057#1088#1086#1082#1072' '#1093#1088#1072#1085#1077#1085#1080#1103
            Options.Editing = False
            Width = 50
          end
          object NormInDays_date: TcxGridDBColumn
            Caption = #1057#1088#1086#1082' ('#1076#1072#1090#1072')'
            DataBinding.FieldName = 'NormInDays_date'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1088#1086#1082' '#1093#1088#1072#1085#1077#1085#1080#1103', '#1076#1072#1090#1072
            Options.Editing = False
            Width = 70
          end
          object MeasureName: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object Amount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' ('#1096#1090'.)'
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 58
          end
          object Amount_Weight: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' ('#1074#1077#1089')'
            DataBinding.FieldName = 'Amount_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 58
          end
          object AmountRemains: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082' ('#1096#1090'.)'
            DataBinding.FieldName = 'AmountRemains'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 58
          end
          object AmountRemains_Weight: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082' ('#1074#1077#1089')'
            DataBinding.FieldName = 'AmountRemains_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 58
          end
          object ChoiceCellCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1086#1090#1073#1086#1088
            DataBinding.FieldName = 'ChoiceCellCode'
            GroupSummaryAlignment = taRightJustify
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1076' '#1084#1077#1089#1090#1072' '#1086#1090#1073#1086#1088#1072
            Options.Editing = False
            Width = 58
          end
          object ChoiceCellName: TcxGridDBColumn
            Caption = #1052#1077#1089#1090#1086' '#1086#1090#1073#1086#1088#1072
            DataBinding.FieldName = 'ChoiceCellName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 58
          end
          object isClose_value_min: TcxGridDBColumn
            Caption = #1045#1089#1090#1100' '#1079#1072#1082#1088#1099#1090#1080#1103
            DataBinding.FieldName = 'isClose_value_min'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object isPartionCell: TcxGridDBColumn
            Caption = #1055#1086' '#1071#1095#1077#1081#1082#1072#1084
            DataBinding.FieldName = 'isPartionCell'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1099' '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1103#1095#1077#1081#1082#1072#1084' ('#1076#1072'/'#1085#1077#1090')'
            Options.Editing = False
            Width = 60
          end
          object isPartionCell_min: TcxGridDBColumn
            Caption = #1045#1089#1090#1100' '#1087#1091#1089#1090#1099#1077' '#1071#1095#1077#1081#1082#1080
            DataBinding.FieldName = 'isPartionCell_min'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object PartionCellCode_1: TcxGridDBColumn
            Caption = '1.1 '#1050#1086#1076
            DataBinding.FieldName = 'PartionCellCode_1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1076' '#1071#1095#1077#1081#1082#1080'-1 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Options.Editing = False
            Width = 60
          end
          object PartionCellName_1: TcxGridDBColumn
            Caption = '1.1 '#1071#1095#1077#1081#1082#1072
            DataBinding.FieldName = 'PartionCellName_1'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actOpenPartionCellForm1
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-1 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Width = 60
          end
          object PartionCellCode_2: TcxGridDBColumn
            Caption = '2.1 '#1050#1086#1076
            DataBinding.FieldName = 'PartionCellCode_2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1076' '#1071#1095#1077#1081#1082#1080'-2 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Options.Editing = False
            Width = 60
          end
          object PartionCellName_2: TcxGridDBColumn
            Caption = '2.1 '#1071#1095#1077#1081#1082#1072
            DataBinding.FieldName = 'PartionCellName_2'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actOpenPartionCellForm2
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-2 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Width = 60
          end
          object PartionCellCode_3: TcxGridDBColumn
            Caption = '3.1 '#1050#1086#1076
            DataBinding.FieldName = 'PartionCellCode_3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1076' '#1071#1095#1077#1081#1082#1080'-3 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Options.Editing = False
            Width = 60
          end
          object PartionCellName_3: TcxGridDBColumn
            Caption = '3.1 '#1071#1095#1077#1081#1082#1072
            DataBinding.FieldName = 'PartionCellName_3'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actOpenPartionCellForm3
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-3 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Width = 60
          end
          object PartionCellCode_4: TcxGridDBColumn
            Caption = '4.1 '#1050#1086#1076
            DataBinding.FieldName = 'PartionCellCode_4'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1076' '#1071#1095#1077#1081#1082#1080'-4 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Options.Editing = False
            Width = 60
          end
          object PartionCellName_4: TcxGridDBColumn
            Caption = '4.1 '#1071#1095#1077#1081#1082#1072
            DataBinding.FieldName = 'PartionCellName_4'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actOpenPartionCellForm4
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-4 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Width = 60
          end
          object PartionCellCode_5: TcxGridDBColumn
            Caption = '5.1 '#1050#1086#1076
            DataBinding.FieldName = 'PartionCellCode_5'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1076' '#1071#1095#1077#1081#1082#1080'-5 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Options.Editing = False
            Width = 60
          end
          object PartionCellName_5: TcxGridDBColumn
            Caption = '5.1 '#1071#1095#1077#1081#1082#1072
            DataBinding.FieldName = 'PartionCellName_5'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actOpenPartionCellForm5
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-5 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Width = 60
          end
          object PartionCellCode_6: TcxGridDBColumn
            Caption = '6.1 '#1050#1086#1076
            DataBinding.FieldName = 'PartionCellCode_6'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1076' '#1071#1095#1077#1081#1082#1080'-6 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Options.Editing = False
            Width = 60
          end
          object PartionCellName_6: TcxGridDBColumn
            Caption = '6.1 '#1071#1095#1077#1081#1082#1072
            DataBinding.FieldName = 'PartionCellName_6'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actOpenPartionCellForm6
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-6 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Width = 60
          end
          object PartionCellCode_7: TcxGridDBColumn
            Caption = '7.1 '#1050#1086#1076
            DataBinding.FieldName = 'PartionCellCode_7'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1076' '#1071#1095#1077#1081#1082#1080'-7 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Options.Editing = False
            Width = 60
          end
          object PartionCellName_7: TcxGridDBColumn
            Caption = '7.1 '#1071#1095#1077#1081#1082#1072
            DataBinding.FieldName = 'PartionCellName_7'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actOpenPartionCellForm7
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-7 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Width = 60
          end
          object PartionCellCode_8: TcxGridDBColumn
            Caption = '8.1 '#1050#1086#1076
            DataBinding.FieldName = 'PartionCellCode_8'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1076' '#1071#1095#1077#1081#1082#1080'-8 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Options.Editing = False
            Width = 60
          end
          object PartionCellName_8: TcxGridDBColumn
            Caption = '8.1 '#1071#1095#1077#1081#1082#1072
            DataBinding.FieldName = 'PartionCellName_8'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actOpenPartionCellForm8
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-8 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Width = 60
          end
          object PartionCellCode_9: TcxGridDBColumn
            Caption = '9.1 '#1050#1086#1076
            DataBinding.FieldName = 'PartionCellCode_9'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1076' '#1071#1095#1077#1081#1082#1080'-9 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Options.Editing = False
            Width = 60
          end
          object PartionCellName_9: TcxGridDBColumn
            Caption = '9.1 '#1071#1095#1077#1081#1082#1072
            DataBinding.FieldName = 'PartionCellName_9'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actOpenPartionCellForm9
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-9 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Width = 60
          end
          object PartionCellCode_10: TcxGridDBColumn
            Caption = '10.1 '#1050#1086#1076
            DataBinding.FieldName = 'PartionCellCode_10'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1076' '#1071#1095#1077#1081#1082#1080'-10 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Options.Editing = False
            Width = 60
          end
          object PartionCellName_10: TcxGridDBColumn
            Caption = '10.1 '#1071#1095#1077#1081#1082#1072
            DataBinding.FieldName = 'PartionCellName_10'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actOpenPartionCellForm10
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-10 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Width = 60
          end
          object PartionCellCode_11: TcxGridDBColumn
            Caption = '11.1 '#1050#1086#1076
            DataBinding.FieldName = 'PartionCellCode_11'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1076' '#1071#1095#1077#1081#1082#1080'-11 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Options.Editing = False
            Width = 60
          end
          object PartionCellName_11: TcxGridDBColumn
            Caption = '11.1 '#1071#1095#1077#1081#1082#1072
            DataBinding.FieldName = 'PartionCellName_11'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actOpenPartionCellForm11
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-11 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Width = 60
          end
          object PartionCellCode_12: TcxGridDBColumn
            Caption = '12.1 '#1050#1086#1076
            DataBinding.FieldName = 'PartionCellCode_12'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1076' '#1071#1095#1077#1081#1082#1080'-12 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Options.Editing = False
            Width = 60
          end
          object PartionCellName_12: TcxGridDBColumn
            Caption = '12.1 '#1071#1095#1077#1081#1082#1072
            DataBinding.FieldName = 'PartionCellName_12'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actOpenPartionCellForm12
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-12 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Width = 60
          end
          object PartionCellCode_13: TcxGridDBColumn
            Caption = '13.1 '#1050#1086#1076
            DataBinding.FieldName = 'PartionCellCode_13'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1076' '#1071#1095#1077#1081#1082#1080'-13 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Options.Editing = False
            Width = 60
          end
          object PartionCellName_13: TcxGridDBColumn
            Caption = '13.1 '#1071#1095#1077#1081#1082#1072
            DataBinding.FieldName = 'PartionCellName_13'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actOpenPartionCellForm13
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-13 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Width = 60
          end
          object PartionCellCode_14: TcxGridDBColumn
            Caption = '14.1 '#1050#1086#1076
            DataBinding.FieldName = 'PartionCellCode_14'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1076' '#1071#1095#1077#1081#1082#1080'-14 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Options.Editing = False
            Width = 60
          end
          object PartionCellName_14: TcxGridDBColumn
            Caption = '14.1 '#1071#1095#1077#1081#1082#1072
            DataBinding.FieldName = 'PartionCellName_14'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actOpenPartionCellForm14
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-14 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Width = 60
          end
          object PartionCellCode_15: TcxGridDBColumn
            Caption = '15.1 '#1050#1086#1076
            DataBinding.FieldName = 'PartionCellCode_15'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1076' '#1071#1095#1077#1081#1082#1080'-15 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Options.Editing = False
            Width = 60
          end
          object PartionCellName_15: TcxGridDBColumn
            Caption = '15.1 '#1071#1095#1077#1081#1082#1072
            DataBinding.FieldName = 'PartionCellName_15'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actOpenPartionCellForm15
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-15 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Width = 60
          end
          object PartionCellCode_16: TcxGridDBColumn
            Caption = '16.1 '#1050#1086#1076
            DataBinding.FieldName = 'PartionCellCode_16'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1076' '#1071#1095#1077#1081#1082#1080'-16 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Options.Editing = False
            Width = 60
          end
          object PartionCellName_16: TcxGridDBColumn
            Caption = '16.1 '#1071#1095#1077#1081#1082#1072
            DataBinding.FieldName = 'PartionCellName_16'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actOpenPartionCellForm16
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-16 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Width = 60
          end
          object PartionCellCode_17: TcxGridDBColumn
            Caption = '17.1 '#1050#1086#1076
            DataBinding.FieldName = 'PartionCellCode_17'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1076' '#1071#1095#1077#1081#1082#1080'-17 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Options.Editing = False
            Width = 60
          end
          object PartionCellName_17: TcxGridDBColumn
            Caption = '17.1 '#1071#1095#1077#1081#1082#1072
            DataBinding.FieldName = 'PartionCellName_17'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actOpenPartionCellForm17
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-17 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Width = 60
          end
          object PartionCellCode_18: TcxGridDBColumn
            Caption = '18.1 '#1050#1086#1076
            DataBinding.FieldName = 'PartionCellCode_18'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1076' '#1071#1095#1077#1081#1082#1080'-18 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Options.Editing = False
            Width = 60
          end
          object PartionCellName_18: TcxGridDBColumn
            Caption = '18.1 '#1071#1095#1077#1081#1082#1072
            DataBinding.FieldName = 'PartionCellName_18'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actOpenPartionCellForm18
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-18 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Width = 60
          end
          object PartionCellCode_19: TcxGridDBColumn
            Caption = '19.1 '#1050#1086#1076
            DataBinding.FieldName = 'PartionCellCode_19'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1076' '#1071#1095#1077#1081#1082#1080'-19 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Options.Editing = False
            Width = 60
          end
          object PartionCellName_19: TcxGridDBColumn
            Caption = '19.1 '#1071#1095#1077#1081#1082#1072
            DataBinding.FieldName = 'PartionCellName_19'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actOpenPartionCellForm19
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-19 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Width = 60
          end
          object PartionCellCode_20: TcxGridDBColumn
            Caption = '20.1 '#1050#1086#1076
            DataBinding.FieldName = 'PartionCellCode_20'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1076' '#1071#1095#1077#1081#1082#1080'-20 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Options.Editing = False
            Width = 60
          end
          object PartionCellName_20: TcxGridDBColumn
            Caption = '20.1 '#1071#1095#1077#1081#1082#1072
            DataBinding.FieldName = 'PartionCellName_20'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actOpenPartionCellForm20
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-20 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Width = 60
          end
          object PartionCellCode_21: TcxGridDBColumn
            Caption = '21.1 '#1050#1086#1076
            DataBinding.FieldName = 'PartionCellCode_21'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1076' '#1071#1095#1077#1081#1082#1080'-21 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Options.Editing = False
            Width = 60
          end
          object PartionCellName_21: TcxGridDBColumn
            Caption = '21.1 '#1071#1095#1077#1081#1082#1072
            DataBinding.FieldName = 'PartionCellName_21'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actOpenPartionCellForm21
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-21 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Width = 60
          end
          object PartionCellCode_22: TcxGridDBColumn
            Caption = '22.1 '#1050#1086#1076
            DataBinding.FieldName = 'PartionCellCode_22'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1076' '#1071#1095#1077#1081#1082#1080'-22 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Options.Editing = False
            Width = 60
          end
          object PartionCellName_22: TcxGridDBColumn
            Caption = '22.1 '#1071#1095#1077#1081#1082#1072
            DataBinding.FieldName = 'PartionCellName_22'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actOpenPartionCellForm22
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-22 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Width = 60
          end
          object PartionCellName_ets: TcxGridDBColumn
            Caption = #1044#1088#1091#1075#1080#1077' '#1071#1095#1077#1081#1082#1080
            DataBinding.FieldName = 'PartionCellName_ets'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object Color_PartionGoodsDate: TcxGridDBColumn
            DataBinding.FieldName = 'Color_PartionGoodsDate'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 55
          end
          object ColorFon_1: TcxGridDBColumn
            DataBinding.FieldName = 'ColorFon_1'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 55
          end
          object ColorFon_2: TcxGridDBColumn
            DataBinding.FieldName = 'ColorFon_2'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 55
          end
          object ColorFon_3: TcxGridDBColumn
            DataBinding.FieldName = 'ColorFon_3'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 55
          end
          object ColorFon_4: TcxGridDBColumn
            DataBinding.FieldName = 'ColorFon_4'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 55
          end
          object ColorFon_5: TcxGridDBColumn
            DataBinding.FieldName = 'ColorFon_5'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 55
          end
          object ColorFon_6: TcxGridDBColumn
            DataBinding.FieldName = 'ColorFon_6'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 55
          end
          object ColorFon_7: TcxGridDBColumn
            DataBinding.FieldName = 'ColorFon_7'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 55
          end
          object ColorFon_8: TcxGridDBColumn
            DataBinding.FieldName = 'ColorFon_8'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 55
          end
          object ColorFon_9: TcxGridDBColumn
            DataBinding.FieldName = 'ColorFon_9'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 55
          end
          object ColorFon_10: TcxGridDBColumn
            DataBinding.FieldName = 'ColorFon_10'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 55
          end
          object ColorFon_11: TcxGridDBColumn
            DataBinding.FieldName = 'ColorFon_11'
            Visible = False
            VisibleForCustomization = False
            Width = 55
          end
          object ColorFon_12: TcxGridDBColumn
            DataBinding.FieldName = 'ColorFon_12'
            Visible = False
            VisibleForCustomization = False
            Width = 55
          end
          object ColorFon_13: TcxGridDBColumn
            DataBinding.FieldName = 'ColorFon_13'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 55
          end
          object ColorFon_14: TcxGridDBColumn
            DataBinding.FieldName = 'ColorFon_14'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 55
          end
          object ColorFon_15: TcxGridDBColumn
            DataBinding.FieldName = 'ColorFon_15'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 55
          end
          object ColorFon_16: TcxGridDBColumn
            DataBinding.FieldName = 'ColorFon_16'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 55
          end
          object ColorFon_17: TcxGridDBColumn
            DataBinding.FieldName = 'ColorFon_17'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 55
          end
          object ColorFon_18: TcxGridDBColumn
            DataBinding.FieldName = 'ColorFon_18'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 55
          end
          object ColorFon_19: TcxGridDBColumn
            DataBinding.FieldName = 'ColorFon_19'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 55
          end
          object ColorFon_20: TcxGridDBColumn
            DataBinding.FieldName = 'ColorFon_20'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 55
          end
          object ColorFon_21: TcxGridDBColumn
            DataBinding.FieldName = 'ColorFon_21'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 55
          end
          object ColorFon_22: TcxGridDBColumn
            DataBinding.FieldName = 'ColorFon_22'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 55
          end
          object Color_1: TcxGridDBColumn
            DataBinding.FieldName = 'Color_1'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 55
          end
          object Color_2: TcxGridDBColumn
            DataBinding.FieldName = 'Color_2'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 55
          end
          object Color_3: TcxGridDBColumn
            DataBinding.FieldName = 'Color_3'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 55
          end
          object Color_4: TcxGridDBColumn
            DataBinding.FieldName = 'Color_4'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 55
          end
          object Color_5: TcxGridDBColumn
            DataBinding.FieldName = 'Color_5'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 55
          end
          object Color_6: TcxGridDBColumn
            DataBinding.FieldName = 'Color_6'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 55
          end
          object Color_7: TcxGridDBColumn
            DataBinding.FieldName = 'Color_7'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 55
          end
          object Color_8: TcxGridDBColumn
            DataBinding.FieldName = 'Color_8'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 55
          end
          object Color_9: TcxGridDBColumn
            DataBinding.FieldName = 'Color_9'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 55
          end
          object Color_10: TcxGridDBColumn
            DataBinding.FieldName = 'Color_10'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 55
          end
          object Color_11: TcxGridDBColumn
            DataBinding.FieldName = 'Color_11'
            Visible = False
            VisibleForCustomization = False
            Width = 55
          end
          object Color_12: TcxGridDBColumn
            DataBinding.FieldName = 'Color_12'
            Visible = False
            VisibleForCustomization = False
            Width = 55
          end
          object Color_13: TcxGridDBColumn
            DataBinding.FieldName = 'Color_13'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 55
          end
          object Color_14: TcxGridDBColumn
            DataBinding.FieldName = 'Color_14'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 55
          end
          object Color_15: TcxGridDBColumn
            DataBinding.FieldName = 'Color_15'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 55
          end
          object Color_16: TcxGridDBColumn
            DataBinding.FieldName = 'Color_16'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 55
          end
          object Color_17: TcxGridDBColumn
            DataBinding.FieldName = 'Color_17'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 55
          end
          object Color_18: TcxGridDBColumn
            DataBinding.FieldName = 'Color_18'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 55
          end
          object Color_19: TcxGridDBColumn
            DataBinding.FieldName = 'Color_19'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 55
          end
          object Color_20: TcxGridDBColumn
            DataBinding.FieldName = 'Color_20'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 55
          end
          object Color_21: TcxGridDBColumn
            DataBinding.FieldName = 'Color_21'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 55
          end
          object Color_22: TcxGridDBColumn
            DataBinding.FieldName = 'Color_22'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 55
          end
          object OperDate_min: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1089
            DataBinding.FieldName = 'OperDate_min'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object OperDate_max: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1087#1086
            DataBinding.FieldName = 'OperDate_max'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object ColorFon_ord: TcxGridDBColumn
            DataBinding.FieldName = 'ColorFon_ord'
            Visible = False
            VisibleForCustomization = False
            Width = 50
          end
          object DescId_milo_num: TcxGridDBColumn
            Caption = #8470' '#1087'/'#1087' '#1103#1095#1077#1081#1082#1080
            DataBinding.FieldName = 'DescId_milo_num'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object PartionCellId_num: TcxGridDBColumn
            Caption = #1050#1083#1102#1095' '#1103#1095#1077#1081#1082#1080
            DataBinding.FieldName = 'PartionCellId_num'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '0.####;-0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object PartionCellName_srch: TcxGridDBColumn
            Caption = '***'#1071#1095#1077#1081#1082#1080' ('#1087#1086#1080#1089#1082')'
            DataBinding.FieldName = 'PartionCellName_srch'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object Color_NormInDays: TcxGridDBColumn
            DataBinding.FieldName = 'Color_NormInDays'
            Visible = False
            VisibleForCustomization = False
            Width = 55
          end
          object isLock_record: TcxGridDBColumn
            DataBinding.FieldName = 'isLock_record'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1540
    Height = 30
    ExplicitWidth = 1540
    ExplicitHeight = 30
    inherited deStart: TcxDateEdit
      Top = 3
      EditValue = 45474d
      Properties.SaveTime = False
      ExplicitTop = 3
    end
    inherited deEnd: TcxDateEdit
      Top = 3
      EditValue = 45474d
      Properties.SaveTime = False
      ExplicitTop = 3
    end
    inherited cxLabel1: TcxLabel
      Left = 9
      Top = 4
      ExplicitLeft = 9
      ExplicitTop = 4
    end
    inherited cxLabel2: TcxLabel
      Left = 199
      Top = 4
      ExplicitLeft = 199
      ExplicitTop = 4
    end
    object cxLabel8: TcxLabel
      Left = 409
      Top = 4
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1082#1086#1084#1091'):'
    end
    object edUnit: TcxButtonEdit
      Left = 538
      Top = 3
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 210
    end
    object cbMovement: TcxCheckBox
      Left = 765
      Top = 3
      Hint = #1055#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084
      Caption = #1055#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084
      Properties.ReadOnly = False
      TabOrder = 6
      Width = 103
    end
    object cbisCell: TcxCheckBox
      Left = 874
      Top = 3
      Action = actRefreshCell
      Properties.ReadOnly = False
      TabOrder = 7
      Width = 89
    end
  end
  object PanelSearch: TPanel [2]
    Left = 0
    Top = 30
    Width = 1540
    Height = 41
    Align = alTop
    TabOrder = 6
    object lbSearchCode: TcxLabel
      Left = 30
      Top = 10
      Caption = #1055#1086#1080#1089#1082' '#1050#1086#1076': '
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clBlue
      Style.Font.Height = -13
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
    end
    object edSearchCode: TcxTextEdit
      Left = 110
      Top = 10
      TabOrder = 1
      DesignSize = (
        79
        21)
      Width = 79
    end
    object lbSearchName: TcxLabel
      Left = 220
      Top = 10
      Caption = #1058#1086#1074#1072#1088':'
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clBlue
      Style.Font.Height = -13
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
    end
    object edSearchName: TcxTextEdit
      Left = 270
      Top = 10
      TabOrder = 3
      DesignSize = (
        337
        21)
      Width = 337
    end
    object cxLabel3: TcxLabel
      Left = 645
      Top = 10
      Caption = #1055#1086#1080#1089#1082' '#1071#1095#1077#1081#1082#1080':'
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clBlue
      Style.Font.Height = -13
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
    end
    object edSearchPartionCellName: TcxTextEdit
      Left = 748
      Top = 10
      TabOrder = 5
      DesignSize = (
        144
        21)
      Width = 144
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
        Component = GuidesUnit
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = cbMovement
        Properties.Strings = (
          'Checked')
      end>
    Left = 528
    Top = 328
  end
  inherited ActionList: TActionList
    Left = 79
    Top = 271
    object actRefreshCell: TdsdDataSetRefresh [0]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1086' '#1103#1095#1077#1081#1082#1072#1084
      Hint = #1055#1086' '#1103#1095#1077#1081#1082#1072#1084
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actRefreshPartion: TdsdDataSetRefresh [1]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084
      Hint = #1055#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actPrint: TdsdPrintAction
      Category = 'Print'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100' '#1087#1086' '#1084#1077#1089#1090#1072#1084' '#1093#1088#1072#1085#1077#1085#1080#1103
      Hint = #1055#1077#1095#1072#1090#1100' '#1087#1086' '#1084#1077#1089#1090#1072#1084' '#1093#1088#1072#1085#1077#1085#1080#1103
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          UserName = 'frxDBDMaster'
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
          Name = 'UnitName'
          Value = Null
          Component = GuidesUnit
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'isCell'
          Value = Null
          Component = cbisCell
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072' '#1087#1086' '#1071#1095#1077#1081#1082#1072#1084' '#1093#1088#1072#1085#1077#1085#1080#1103
      ReportNameParam.Value = #1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072' '#1087#1086' '#1071#1095#1077#1081#1082#1072#1084' '#1093#1088#1072#1085#1077#1085#1080#1103
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
      FormName = 'TReport_Send_PartionCellDialogForm'
      FormNameParam.Value = 'TReport_Send_PartionCellDialogForm'
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
          Name = 'UnitId'
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isMovement'
          Value = Null
          Component = cbMovement
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isCell'
          Value = Null
          Component = cbisCell
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actOpenReport_PartionCell_GoodsHistory: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1048#1089#1090#1086#1088#1080#1103' '#1087#1086' '#1103#1095#1077#1081#1082#1077' '#1093#1088#1072#1085#1077#1085#1080#1103
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1048#1089#1090#1086#1088#1080#1103' '#1087#1086' '#1103#1095#1077#1081#1082#1077' '#1093#1088#1072#1085#1077#1085#1080#1103
      ImageIndex = 24
      FormName = 'TReport_PartionCell_GoodsHistoryForm'
      FormNameParam.Name = 'TReport_PartionCell_historyForm'
      FormNameParam.Value = 'TReport_PartionCell_GoodsHistoryForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = Null
          Component = deStart
          DataType = ftDateTime
          ParamType = ptUnknown
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = Null
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptUnknown
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartionCellId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartionCellId_1'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartionCellName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartionCellName_1'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitId'
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isRePack'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'isRePack'
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
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
    object actOpenReport_PartionCell_history: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1048#1089#1090#1086#1088#1080#1103' '#1087#1086' '#1087#1072#1088#1090#1080#1080
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1048#1089#1090#1086#1088#1080#1103' '#1087#1086' '#1087#1072#1088#1090#1080#1080
      ImageIndex = 26
      FormName = 'TReport_PartionCell_historyForm'
      FormNameParam.Value = 'TReport_PartionCell_historyForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'PartionGoodsDate'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartionGoodsDate'
          DataType = ftDateTime
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
          Name = 'GoodsKindId'
          Value = 0.000000000000000000
          Component = MasterCDS
          ComponentItem = 'GoodsKindId'
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
          Name = 'GoodsKindName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitId'
          Value = Null
          Component = GuidesUnit
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = Null
          Component = GuidesUnit
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isRePack'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'isRePack'
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenFormPartionCell: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1086' '#1103#1095#1077#1081#1082#1072#1084
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1086' '#1103#1095#1077#1081#1082#1072#1084
      ImageIndex = 25
      FormName = 'TPartionCellChoiceAllForm'
      FormNameParam.Value = 'TPartionCellChoiceAllForm'
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
        end
        item
          Name = 'inChangePercentAmount'
          Value = 0.000000000000000000
          DataType = ftFloat
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090
      FormName = 'NULL'
      FormNameParam.Value = Null
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
        end
        item
          Name = 'inChangePercentAmount'
          Value = 0.000000000000000000
          DataType = ftFloat
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenDocument: TMultiAction
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
    object actOpenPartionCellForm1: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'PartionCellForm'
      FormName = 'TPartionCellChoiceForm'
      FormNameParam.Value = 'TPartionCellChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartionCellName_1'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenPartionCellForm2: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'PartionCellForm'
      FormName = 'TPartionCellChoiceForm'
      FormNameParam.Value = 'TPartionCellChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartionCellName_2'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenPartionCellForm3: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'PartionCellForm'
      FormName = 'TPartionCellChoiceForm'
      FormNameParam.Value = 'TPartionCellChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartionCellName_3'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenPartionCellForm4: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'PartionCellForm'
      FormName = 'TPartionCellChoiceForm'
      FormNameParam.Value = 'TPartionCellChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartionCellName_4'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenPartionCellForm5: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'PartionCellForm'
      FormName = 'TPartionCellChoiceForm'
      FormNameParam.Value = 'TPartionCellChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartionCellName_5'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenPartionCellForm6: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'PartionCellForm'
      FormName = 'TPartionCellChoiceForm'
      FormNameParam.Value = 'TPartionCellChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartionCellName_6'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenPartionCellForm7: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'PartionCell_listForm'
      FormName = 'TPartionCellChoiceForm'
      FormNameParam.Value = 'TPartionCellChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartionCellName_7'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenPartionCellForm8: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'PartionCell_listForm'
      FormName = 'TPartionCellChoiceForm'
      FormNameParam.Value = 'TPartionCellChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartionCellName_8'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenPartionCellForm9: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'PartionCellForm'
      FormName = 'TPartionCellChoiceForm'
      FormNameParam.Value = 'TPartionCellChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartionCellName_9'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenPartionCellForm10: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'PartionCellForm'
      FormName = 'TPartionCellChoiceForm'
      FormNameParam.Value = 'TPartionCellChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartionCellName_10'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenPartionCellForm11: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'PartionCellForm'
      FormName = 'TPartionCellChoiceForm'
      FormNameParam.Value = 'TPartionCellChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartionCellName_11'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenPartionCellForm12: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'PartionCellForm'
      FormName = 'TPartionCellChoiceForm'
      FormNameParam.Value = 'TPartionCellChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartionCellName_12'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenPartionCellForm13: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'PartionCellForm'
      FormName = 'TPartionCellChoiceForm'
      FormNameParam.Value = 'TPartionCellChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartionCellName_13'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenPartionCellForm14: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'PartionCellForm'
      FormName = 'TPartionCellChoiceForm'
      FormNameParam.Value = 'TPartionCellChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartionCellName_14'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenPartionCellForm15: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'PartionCellForm'
      FormName = 'TPartionCellChoiceForm'
      FormNameParam.Value = 'TPartionCellChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartionCellName_15'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenPartionCellForm16: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'PartionCellForm'
      FormName = 'TPartionCellChoiceForm'
      FormNameParam.Value = 'TPartionCellChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartionCellName_16'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenPartionCellForm17: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'PartionCellForm'
      FormName = 'TPartionCellChoiceForm'
      FormNameParam.Value = 'TPartionCellChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartionCellName_17'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenPartionCellForm18: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'PartionCellForm'
      FormName = 'TPartionCellChoiceForm'
      FormNameParam.Value = 'TPartionCellChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartionCellName_18'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenPartionCellForm19: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'PartionCellForm'
      FormName = 'TPartionCellChoiceForm'
      FormNameParam.Value = 'TPartionCellChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartionCellName_19'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenPartionCellForm20: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'PartionCellForm'
      FormName = 'TPartionCellChoiceForm'
      FormNameParam.Value = 'TPartionCellChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartionCellName_20'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenPartionCellForm21: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'PartionCellForm'
      FormName = 'TPartionCellChoiceForm'
      FormNameParam.Value = 'TPartionCellChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartionCellName_21'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenPartionCellForm22: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'PartionCellForm'
      FormName = 'TPartionCellChoiceForm'
      FormNameParam.Value = 'TPartionCellChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartionCellName_22'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actUpdateMainDS: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = macPrint_New
      BeforeAction = mactUpdateMainDS
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_MI_Send_byReport
      StoredProcList = <
        item
          StoredProc = spUpdate_MI_Send_byReport
        end>
      Caption = 'actUpdateMainDS'
      DataSource = MasterDS
    end
    object ExecuteDialogUpdatePartionGoodsDate: TExecuteDialog
      Category = 'OperDatePartner'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1090#1091' '#1055#1072#1088#1090#1080#1080
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1090#1091' '#1055#1072#1088#1090#1080#1080
      ImageIndex = 67
      FormName = 'TSend_DatePartionDialogForm'
      FormNameParam.Value = 'TSend_DatePartionDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inPartionGoodsDate'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartionGoodsDate'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actUpdateMI_PartionGoodsDate: TdsdExecStoredProc
      Category = 'OperDatePartner'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateMI_PartionGoodsDate
      StoredProcList = <
        item
          StoredProc = spUpdateMI_PartionGoodsDate
        end>
      Caption = 'actUpdateMI_PartionGoodsDate'
    end
    object macUpdatePartionGoodsDate: TMultiAction
      Category = 'OperDatePartner'
      TabSheet = tsMain
      MoveParams = <>
      ActionList = <
        item
          Action = ExecuteDialogUpdatePartionGoodsDate
        end
        item
          Action = actUpdateMI_PartionGoodsDate
        end
        item
          Action = actRefresh
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1090#1091' '#1055#1072#1088#1090#1080#1080
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1090#1091' '#1055#1072#1088#1090#1080#1080
      ImageIndex = 67
    end
    object actPrint_Pasport: TdsdPrintAction
      Category = 'Print'
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
        end>
      StoredProc = spSelectPrintPasport
      StoredProcList = <
        item
          StoredProc = spSelectPrintPasport
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1087#1072#1089#1087#1086#1088#1090#1072' '#1103#1095#1077#1081#1082#1080
      Hint = #1055#1077#1095#1072#1090#1100' '#1087#1072#1089#1087#1086#1088#1090#1072' '#1103#1095#1077#1081#1082#1080
      ImageIndex = 3
      DataSets = <
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDItems'
        end>
      Params = <
        item
          Name = 'PartionCellName_print'
          Value = 45292d
          Component = FormParams
          ComponentItem = 'PartionCellName_print'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1077#1095#1072#1090#1100' '#1087#1072#1089#1087#1086#1088#1090#1072' '#1103#1095#1077#1081#1082#1080'('#1089#1090#1088#1086#1082#1072')'
      ReportNameParam.Value = #1055#1077#1095#1072#1090#1100' '#1087#1072#1089#1087#1086#1088#1090#1072' '#1103#1095#1077#1081#1082#1080'('#1089#1090#1088#1086#1082#1072')'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
      PreviewWindowMaximized = False
    end
    object actPrint_Pasport_list: TdsdPrintAction
      Category = 'Print'
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
        end>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      StoredProc = spSelectPrintPasportList
      StoredProcList = <
        item
          StoredProc = spSelectPrintPasportList
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1087#1072#1089#1087#1086#1088#1090#1072' '#1103#1095#1077#1077#1082
      Hint = #1055#1077#1095#1072#1090#1100' '#1087#1072#1089#1087#1086#1088#1090#1072' '#1103#1095#1077#1077#1082
      ImageIndex = 3
      DataSets = <
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDItems'
        end>
      Params = <
        item
          Name = 'PartionCellName_print'
          Value = Null
          Component = FormParams
          ComponentItem = 'PartionCellName_print'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1077#1095#1072#1090#1100' '#1087#1072#1089#1087#1086#1088#1090#1072' '#1103#1095#1077#1081#1082#1080'('#1089#1090#1088#1086#1082#1072')'
      ReportNameParam.Value = #1055#1077#1095#1072#1090#1100' '#1087#1072#1089#1087#1086#1088#1090#1072' '#1103#1095#1077#1081#1082#1080'('#1089#1090#1088#1086#1082#1072')'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
      PreviewWindowMaximized = False
    end
    object mactTestPrint5: TMultiAction
      Category = 'Print'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_MI_Send_byReport_test
        end
        item
          Action = actPrint_Pasport_list
        end>
      Caption = 'mactTestPrint'
    end
    object actUpdate_MI_Send_byReport_test: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_MI_Send_byReport
      StoredProcList = <
        item
          StoredProc = spUpdate_MI_Send_byReport
        end>
      Caption = 'actUpdate_MI_Send_byReport_test'
    end
    object actContinueAction: TdsdContinueAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actContinueAction'
      Continue.Value = False
      Continue.Component = FormParams
      Continue.ComponentItem = 'outisEdit'
      Continue.DataType = ftBoolean
      Continue.MultiSelectSeparator = ','
    end
    object mactUpdateMainDS: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actGet_ExecForm
        end
        item
          Action = actExecForm
        end
        item
          Action = actGet_ExecForm_next
        end>
      Caption = 'mactUpdateMainDS'
    end
    object actGet_ExecForm: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_ExecForm
      StoredProcList = <
        item
          StoredProc = spGet_ExecForm
        end>
      Caption = 'actGet_ExecForm'
    end
    object actExecForm: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actExecForm'
      Hint = 'actExecForm'
      FormName = 'TPartionCellCheckEditForm'
      FormNameParam.Value = 'TPartionCellCheckEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = 11237418
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ioIsLock_record'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'isLock_record'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      isNotExecuteDialog = True
      ActionType = acUpdate
      IdFieldName = 'Id'
    end
    object macPrint_New: TMultiAction
      Category = 'Print'
      MoveParams = <>
      ActionList = <
        item
          Action = actContinueAction
        end
        item
          Action = actPrint_Pasport
        end>
      Caption = 'macPrint_New'
    end
    object actPrintChoiceCell: TdsdPrintAction
      Category = 'Print'
      MoveParams = <>
      StoredProc = spSelectPrint_ChoiceCell
      StoredProcList = <
        item
          StoredProc = spSelectPrint_ChoiceCell
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1087#1086' '#1084#1077#1089#1090#1072#1084' '#1086#1090#1073#1086#1088#1072
      Hint = #1055#1077#1095#1072#1090#1100' '#1087#1086' '#1084#1077#1089#1090#1072#1084' '#1086#1090#1073#1086#1088#1072
      ImageIndex = 17
      DataSets = <
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 45474d
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 45474d
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = ''
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'isCell'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1077#1095#1072#1090#1100'_ '#1071#1095#1077#1077#1082#1054#1090#1073#1086#1088#1072
      ReportNameParam.Value = #1055#1077#1095#1072#1090#1100'_ '#1071#1095#1077#1077#1082#1054#1090#1073#1086#1088#1072
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actChoiceCell_Print: TdsdPrintAction
      Category = 'Print'
      MoveParams = <>
      StoredProc = spChoiceCell_Print
      StoredProcList = <
        item
          StoredProc = spChoiceCell_Print
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1057#1085#1103#1090#1080#1077' '#1089' '#1093#1088#1072#1085#1077#1085#1080#1103' '#1074' '#1084#1077#1089#1090#1072' '#1086#1090#1073#1086#1088#1072
      Hint = #1055#1077#1095#1072#1090#1100' '#1057#1085#1103#1090#1080#1077' '#1089' '#1093#1088#1072#1085#1077#1085#1080#1103' '#1074' '#1084#1077#1089#1090#1072' '#1086#1090#1073#1086#1088#1072
      ImageIndex = 15
      DataSets = <
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
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
          Name = 'UnitName'
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'isCell'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1077#1095#1072#1090#1100'_'#1057#1085#1103#1090#1080#1077' '#1089' '#1093#1088#1072#1085#1077#1085#1080#1103' '#1074' '#1084#1077#1089#1090#1072' '#1086#1090#1073#1086#1088#1072
      ReportNameParam.Value = #1055#1077#1095#1072#1090#1100'_'#1057#1085#1103#1090#1080#1077' '#1089' '#1093#1088#1072#1085#1077#1085#1080#1103' '#1074' '#1084#1077#1089#1090#1072' '#1086#1090#1073#1086#1088#1072
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actGet_ExecForm_next: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end>
      Caption = 'actGet_ExecForm_next'
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
    StoredProcName = 'gpReport_Send_PartionCell'
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
        Name = 'inUnitId'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsMovement'
        Value = Null
        Component = cbMovement
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisCell'
        Value = Null
        Component = cbisCell
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsShowAll'
        Value = Null
        Component = FormParams
        ComponentItem = 'inIsShowAll'
        DataType = ftBoolean
        ParamType = ptInput
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
          ItemName = 'bbUpdatePartionGoodsDate'
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
          ItemName = 'bbOpenFormPartionCell'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbOpenReport_PartionCell_history'
        end
        item
          Visible = True
          ItemName = 'bbOpenReport_PartionCell_GoodsHistory'
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
          ItemName = 'bbPrint'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrintChoiceCell'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrint_Pasport'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbChoiceCell_Print'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel'
        end>
    end
    object bbPrint: TdxBarButton
      Action = actPrint
      Category = 0
    end
    object bbSumm_branch: TdxBarControlContainerItem
      Caption = 'bbSumm_branch'
      Category = 0
      Hint = 'bbSumm_branch'
      Visible = ivAlways
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbOpenDocument: TdxBarButton
      Action = actOpenDocument
      Category = 0
    end
    object bbUpdatePartionGoodsDate: TdxBarButton
      Action = macUpdatePartionGoodsDate
      Category = 0
    end
    object bbOpenFormPartionCell: TdxBarButton
      Action = actOpenFormPartionCell
      Category = 0
    end
    object bbPrint_Pasport: TdxBarButton
      Action = actPrint_Pasport_list
      Category = 0
    end
    object bbOpenReport_PartionCell_history: TdxBarButton
      Action = actOpenReport_PartionCell_history
      Category = 0
    end
    object bbPrintChoiceCell: TdxBarButton
      Action = actPrintChoiceCell
      Category = 0
    end
    object bbChoiceCell_Print: TdxBarButton
      Action = actChoiceCell_Print
      Category = 0
    end
    object bbOpenReport_PartionCell_GoodsHistory: TdxBarButton
      Action = actOpenReport_PartionCell_GoodsHistory
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnlyEditingCellOnEnter = True
    ColorRuleList = <
      item
        ColorColumn = PartionGoodsDate
        BackGroundValueColumn = Color_PartionGoodsDate
        ColorValueList = <>
      end
      item
        ColorColumn = PartionCellName_1
        ValueColumn = Color_1
        BackGroundValueColumn = ColorFon_1
        ColorValueList = <>
      end
      item
        ColorColumn = PartionCellName_2
        ValueColumn = Color_2
        BackGroundValueColumn = ColorFon_2
        ColorValueList = <>
      end
      item
        ColorColumn = PartionCellName_3
        ValueColumn = Color_3
        BackGroundValueColumn = ColorFon_3
        ColorValueList = <>
      end
      item
        ColorColumn = PartionCellName_4
        ValueColumn = Color_4
        BackGroundValueColumn = ColorFon_4
        ColorValueList = <>
      end
      item
        ColorColumn = PartionCellName_5
        ValueColumn = Color_5
        BackGroundValueColumn = ColorFon_5
        ColorValueList = <>
      end
      item
        ColorColumn = PartionCellName_6
        ValueColumn = Color_6
        BackGroundValueColumn = ColorFon_6
        ColorValueList = <>
      end
      item
        ColorColumn = PartionCellName_7
        ValueColumn = Color_7
        BackGroundValueColumn = ColorFon_7
        ColorValueList = <>
      end
      item
        ColorColumn = PartionCellName_8
        ValueColumn = Color_8
        BackGroundValueColumn = ColorFon_8
        ColorValueList = <>
      end
      item
        ColorColumn = PartionCellName_9
        ValueColumn = Color_9
        BackGroundValueColumn = ColorFon_9
        ColorValueList = <>
      end
      item
        ColorColumn = PartionCellName_10
        ValueColumn = Color_10
        BackGroundValueColumn = ColorFon_10
        ColorValueList = <>
      end
      item
        ColorColumn = PartionCellName_11
        ValueColumn = Color_11
        BackGroundValueColumn = ColorFon_11
        ColorValueList = <>
      end
      item
        ColorColumn = PartionCellName_12
        ValueColumn = Color_12
        BackGroundValueColumn = ColorFon_12
        ColorValueList = <>
      end
      item
        ColorColumn = PartionCellName_13
        ValueColumn = Color_13
        BackGroundValueColumn = ColorFon_13
        ColorValueList = <>
      end
      item
        ColorColumn = PartionCellName_14
        ValueColumn = Color_14
        BackGroundValueColumn = ColorFon_14
        ColorValueList = <>
      end
      item
        ColorColumn = PartionCellName_15
        ValueColumn = Color_15
        BackGroundValueColumn = ColorFon_15
        ColorValueList = <>
      end
      item
        ColorColumn = PartionCellName_16
        ValueColumn = Color_16
        BackGroundValueColumn = ColorFon_16
        ColorValueList = <>
      end
      item
        ColorColumn = PartionCellName_17
        ValueColumn = Color_17
        BackGroundValueColumn = ColorFon_17
        ColorValueList = <>
      end
      item
        ColorColumn = PartionCellName_18
        ValueColumn = Color_18
        BackGroundValueColumn = ColorFon_18
        ColorValueList = <>
      end
      item
        ColorColumn = PartionCellName_19
        ValueColumn = Color_19
        BackGroundValueColumn = ColorFon_19
        ColorValueList = <>
      end
      item
        ColorColumn = PartionCellName_20
        ValueColumn = Color_20
        BackGroundValueColumn = ColorFon_20
        ColorValueList = <>
      end
      item
        ColorColumn = PartionCellName_21
        ValueColumn = Color_21
        BackGroundValueColumn = ColorFon_21
        ColorValueList = <>
      end
      item
        ColorColumn = PartionCellName_22
        ValueColumn = Color_22
        BackGroundValueColumn = ColorFon_22
        ColorValueList = <>
      end
      item
        ColorColumn = GoodsCode
        BackGroundValueColumn = ColorFon_ord
        ColorValueList = <>
      end
      item
        ColorColumn = GoodsName
        BackGroundValueColumn = ColorFon_ord
        ColorValueList = <>
      end
      item
        ColorColumn = AmountRemains
        BackGroundValueColumn = ColorFon_ord
        ColorValueList = <>
      end
      item
        ColorColumn = AmountRemains_Weight
        BackGroundValueColumn = ColorFon_ord
        ColorValueList = <>
      end
      item
        ColorColumn = GoodsKindName
        BackGroundValueColumn = ColorFon_ord
        ColorValueList = <>
      end
      item
        ColorColumn = MeasureName
        BackGroundValueColumn = ColorFon_ord
        ColorValueList = <>
      end
      item
        ColorColumn = NormInDays
        BackGroundValueColumn = ColorFon_ord
        ColorValueList = <>
      end
      item
        ColorColumn = NormInDays_date
        BackGroundValueColumn = Color_NormInDays
        ColorValueList = <>
      end
      item
        ColorColumn = NormInDays_real
        BackGroundValueColumn = Color_NormInDays
        ColorValueList = <>
      end
      item
        ColorColumn = NormInDays_tax
        BackGroundValueColumn = Color_NormInDays
        ColorValueList = <>
      end
      item
        ColorColumn = Marker_NormInDays
        BackGroundValueColumn = Color_NormInDays
        ColorValueList = <>
      end
      item
        ColorColumn = Amount
        BackGroundValueColumn = ColorFon_ord
        ColorValueList = <>
      end
      item
        ColorColumn = Amount_Weight
        BackGroundValueColumn = ColorFon_ord
        ColorValueList = <>
      end
      item
        ColorColumn = isClose_value_min
        BackGroundValueColumn = ColorFon_ord
        ColorValueList = <>
      end
      item
        ColorColumn = isPartionCell
        BackGroundValueColumn = ColorFon_ord
        ColorValueList = <>
      end
      item
        ColorColumn = Ord
        BackGroundValueColumn = ColorFon_ord
        ColorValueList = <>
      end>
    ColumnEnterList = <
      item
        Column = PartionCellName_1
      end
      item
        Column = PartionCellName_2
      end
      item
        Column = PartionCellName_3
      end
      item
        Column = PartionCellName_4
      end
      item
        Column = PartionCellName_5
      end
      item
        Column = PartionCellName_6
      end
      item
        Column = PartionCellName_7
      end
      item
        Column = PartionCellName_8
      end
      item
        Column = PartionCellName_9
      end
      item
        Column = PartionCellName_10
      end
      item
        Column = PartionCellName_11
      end
      item
        Column = PartionCellName_12
      end
      item
        Column = PartionCellName_13
      end
      item
        Column = PartionCellName_14
      end
      item
        Column = PartionCellName_15
      end
      item
        Column = PartionCellName_16
      end
      item
        Column = PartionCellName_17
      end
      item
        Column = PartionCellName_18
      end
      item
        Column = PartionCellName_19
      end
      item
        Column = PartionCellName_20
      end
      item
        Column = PartionCellName_21
      end
      item
        Column = PartionCellName_22
      end>
    Left = 368
    Top = 240
  end
  inherited PopupMenu: TPopupMenu
    Left = 128
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 170
    Top = 0
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = GuidesUnit
      end
      item
      end
      item
      end
      item
      end>
    Left = 184
    Top = 136
  end
  object GuidesUnit: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnit
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 592
    Top = 65528
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
        Value = 'TSendlForm'
        Component = FormParams
        ComponentItem = 'FormName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 632
    Top = 200
  end
  object FormParams: TdsdFormParams
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
        Value = 'TSendlForm'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 264
    Top = 264
  end
  object spUpdate_MI_Send_byReport: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_Send_byReport'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inUnitId'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartDate'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'OperDate_min'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'OperDate_max'
        DataType = ftDateTime
        ParamType = ptInput
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
        Name = 'inMovementItemId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementItemId'
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
        Name = 'inGoodsKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindId'
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
        Name = 'ioIsChoiceCell_mi'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isChoiceCell_mi'
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPartionCellId_1'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellId_1'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPartionCellId_2'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellId_2'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPartionCellId_3'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellId_3'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPartionCellId_4'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellId_4'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPartionCellId_5'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellId_5'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPartionCellId_6'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellId_6'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPartionCellId_7'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellId_7'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPartionCellId_8'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellId_8'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPartionCellId_9'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellId_9'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPartionCellId_10'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellId_10'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPartionCellId_11'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellId_11'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPartionCellId_12'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellId_12'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPartionCellId_13'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellId_13'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPartionCellId_14'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellId_14'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPartionCellId_15'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellId_15'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPartionCellId_16'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellId_16'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPartionCellId_17'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellId_17'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPartionCellId_18'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellId_18'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPartionCellId_19'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellId_19'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPartionCellId_20'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellId_20'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPartionCellId_21'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellId_21'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPartionCellId_22'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellId_22'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOrd'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Ord'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDescId_milo_num'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'DescId_milo_num'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsRePack'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isRePack'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPartionCellId_last'
        Value = Null
        Component = FormParams
        ComponentItem = 'PartionCellId_last'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPartionCellName_1'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellName_1'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPartionCellName_2'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellName_2'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPartionCellName_3'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellName_3'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPartionCellName_4'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellName_4'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPartionCellName_5'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellName_5'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPartionCellName_6'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellName_6'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPartionCellName_7'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellName_7'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPartionCellName_8'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellName_8'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPartionCellName_9'
        Value = 0
        Component = MasterCDS
        ComponentItem = 'PartionCellName_9'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPartionCellName_10'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellName_10'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPartionCellName_11'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellName_11'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPartionCellName_12'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellName_12'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPartionCellName_13'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellName_13'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPartionCellName_14'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellName_14'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPartionCellName_15'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellName_15'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPartionCellName_16'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellName_16'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPartionCellName_17'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellName_17'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPartionCellName_18'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellName_18'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPartionCellName_19'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellName_19'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPartionCellName_20'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellName_20'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPartionCellName_21'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellName_21'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPartionCellName_22'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellName_22'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsLock_record'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isLock_record'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsPrint'
        Value = Null
        Component = FormParams
        ComponentItem = 'outIsPrint'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 440
    Top = 168
  end
  object spUpdateMI_PartionGoodsDate: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_Send_PartionDate_byReport'
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
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementItemId'
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
        Name = 'inGoodsKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindId'
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
      end>
    PackSize = 1
    Left = 898
    Top = 248
  end
  object FieldFilter_Search: TdsdFieldFilter
    TextEdit = edSearchCode
    DataSet = MasterCDS
    Column = GoodsCode
    ColumnList = <
      item
        Column = GoodsCode
      end
      item
        Column = GoodsName
        TextEdit = edSearchName
      end
      item
        Column = PartionCellName_srch
        TextEdit = edSearchPartionCellName
      end>
    CheckBoxList = <>
    Left = 728
    Top = 112
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 772
    Top = 238
  end
  object spSelectPrintPasport: TdsdStoredProc
    StoredProcName = 'gpReport_PartionCell_PasportPrint'
    DataSet = PrintItemsCDS
    DataSets = <
      item
        DataSet = PrintItemsCDS
      end>
    Params = <
      item
        Name = 'inMovementItemId'
        Value = 43831d
        Component = MasterCDS
        ComponentItem = 'MovementItemId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCellId'
        Value = 43831d
        Component = FormParams
        ComponentItem = 'PartionCellId_last'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsCode'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsCode'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsName'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindName'
        DataType = ftString
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
      end>
    PackSize = 1
    Left = 671
    Top = 264
  end
  object spSelectPrint_ChoiceCell: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_ChoiceCell'
    DataSet = PrintItemsCDS
    DataSets = <
      item
        DataSet = PrintItemsCDS
      end>
    Params = <
      item
        Name = 'inShowAll'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 520
    Top = 248
  end
  object spSelectPrintPasportList: TdsdStoredProc
    StoredProcName = 'gpReport_PartionCell_PasportPrint_list'
    DataSet = PrintItemsCDS
    DataSets = <
      item
        DataSet = PrintItemsCDS
      end>
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementItemId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCellId'
        Value = '0'
        Component = MasterCDS
        ComponentItem = 'PartionCellId_1'
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
        Name = 'inGoodsKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindId'
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
        Name = 'inIsCell'
        Value = Null
        Component = cbisCell
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 759
    Top = 288
  end
  object spChoiceCell_Print: TdsdStoredProc
    StoredProcName = 'gpReport_PartionCell_ChoiceCellPrint'
    DataSet = PrintItemsCDS
    DataSets = <
      item
        DataSet = PrintItemsCDS
      end>
    Params = <
      item
        Name = 'inStartDate'
        Value = 45474d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 45474d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsMovement'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisCell'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsShowAll'
        Value = False
        Component = FormParams
        ComponentItem = 'inIsShowAll'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 432
    Top = 304
  end
  object spGet_ExecForm: TdsdStoredProc
    StoredProcName = 'gpGet_Object_PartionCell_mi_edit'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inPartionCellId_1'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellId_1'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCellId_2'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellId_2'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCellId_3'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellId_3'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCellId_4'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellId_4'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCellId_5'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellId_5'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCellId_6'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellId_6'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCellId_7'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellId_7'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCellId_8'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellId_8'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCellId_9'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellId_9'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCellId_10'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellId_10'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCellId_11'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellId_11'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCellId_12'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellId_12'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCellId_13'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellId_13'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCellId_14'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellId_14'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCellId_15'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellId_15'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCellId_16'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellId_16'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCellId_17'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellId_17'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCellId_18'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellId_18'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCellId_19'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellId_19'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCellId_20'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellId_20'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCellId_21'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellId_21'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCellId_22'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellId_22'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCellName_1'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellName_1'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCellName_2'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellName_2'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCellName_3'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellName_3'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCellName_4'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellName_4'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCellName_5'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellName_5'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCellName_6'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellName_6'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCellName_7'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellName_7'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCellName_8'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellName_8'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCellName_9'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellName_9'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCellName_10'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellName_10'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCellName_11'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellName_11'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCellName_12'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellName_12'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCellName_13'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellName_13'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCellName_14'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellName_14'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCellName_15'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellName_15'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCellName_16'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellName_16'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCellName_17'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellName_17'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCellName_18'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellName_18'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCellName_19'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellName_19'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCellName_20'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellName_20'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCellName_21'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellName_21'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCellName_22'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionCellName_22'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outExecForm'
        Value = Null
        Component = actExecForm
        ComponentItem = 'Enabled'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsLock_record'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isLock_record'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 200
    Top = 328
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_PartionCell'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = 0
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isLock_record'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isLock_record'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 288
    Top = 16
  end
end
