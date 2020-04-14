inherited Report_Send_RemainsSunOut_express_v2Form: TReport_Send_RemainsSunOut_express_v2Form
  Caption = #1054#1090#1095#1077#1090' <'#1087#1086' '#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1102' '#1057#1059#1053'-'#1069#1082#1089#1087#1088#1077#1089#1089'> ('#1088#1072#1089#1093#1086#1076#1099') V2'
  ClientHeight = 673
  ClientWidth = 782
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 798
  ExplicitHeight = 711
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 59
    Width = 782
    Height = 614
    TabOrder = 2
    ExplicitTop = 59
    ExplicitWidth = 784
    ExplicitHeight = 614
    ClientRectBottom = 614
    ClientRectRight = 782
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 784
      ExplicitHeight = 614
      inherited cxGrid: TcxGrid
        Top = 252
        Width = 782
        Height = 180
        Align = alBottom
        ExplicitTop = 252
        ExplicitWidth = 784
        ExplicitHeight = 180
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_sale
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_sale
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountRemains
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountIncome
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSend_in
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_res
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_res
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountOrderExternal
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountReserve
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSend_out
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountRemains_calc
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_sale
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_sale
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountRemains
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountIncome
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSend_in
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_res
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_res
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountOrderExternal
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountReserve
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSend_out
            end
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = UnitName
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountRemains_calc
            end
            item
              Format = ',0.####'
              Kind = skSum
            end>
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object UnitName: TcxGridDBColumn
            Caption = #1055#1086#1083#1091#1095#1072#1090#1077#1083#1100
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object MCS: TcxGridDBColumn
            Caption = #1053#1058#1047
            DataBinding.FieldName = 'MCS'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1053#1058#1047' '#1089' '#1091#1095#1077#1090#1086#1084' '#1079#1085#1072#1095#1077#1085#1080#1103' '#1074' '#1072#1089#1089#1086#1088#1090'. '#1084#1072#1090#1088#1080#1094#1077
            Options.Editing = False
            Width = 55
          end
          object Price: TcxGridDBColumn
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object Amount_res: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1088#1077#1079'. '#1087#1088#1080#1093'.'
            DataBinding.FieldName = 'Amount_res'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = 
              #1056#1077#1079#1091#1083#1100#1090#1072#1090': '#1050#1086#1083'-'#1074#1086' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1086' - '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1088#1080#1093#1086#1076' '#1074' '#1090#1086#1095#1082#1091' '#1087#1086#1083#1091 +
              #1095#1072#1090#1077#1083#1100
            Width = 85
          end
          object Summ_res: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1088#1077#1079'. '#1087#1088#1080#1093'.'
            DataBinding.FieldName = 'Summ_res'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1077#1079#1091#1083#1100#1090#1072#1090': '#1057#1091#1084#1084#1072' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1086' - '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1088#1080#1093#1086#1076
            Width = 88
          end
          object AmountRemains_calc: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082' '#1088#1072#1089#1095#1077#1090
            DataBinding.FieldName = 'AmountRemains_calc'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = 
              #1054#1089#1090#1072#1090#1086#1082' '#1074' '#1090#1086#1095#1082#1077' '#1055#1086#1083#1091#1095#1072#1090#1077#1083#1103' '#1089' '#1091#1095#1077#1090#1086#1084': '#1055#1088#1080#1093#1086#1076' ('#1086#1078#1080#1076#1072#1077#1084#1099#1081') + '#1055#1077#1088#1077#1084#1077 +
              #1097#1077#1085#1080#1077' '#1087#1088#1080#1093#1086#1076' ('#1086#1078#1080#1076#1072#1077#1090#1089#1103') - '#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1088#1072#1089#1093#1086#1076' ('#1086#1078#1080#1076#1072#1077#1090#1089#1103') + '#1047#1072#1082#1072 +
              #1079' ('#1086#1078#1080#1076#1072#1077#1084#1099#1081') - '#1056#1077#1079#1077#1088#1074' '#1087#1086' '#1095#1077#1082#1072#1084
            Options.Editing = False
            Width = 70
          end
          object AmountRemains: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082
            DataBinding.FieldName = 'AmountRemains'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1089#1090#1072#1090#1086#1082' '#1074' '#1090#1086#1095#1082#1077' '#1055#1086#1083#1091#1095#1072#1090#1077#1083#1103
            Width = 58
          end
          object Amount_sale: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1087#1088#1086#1076'.'
            DataBinding.FieldName = 'Amount_sale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1090#1072#1090#1080#1089#1090#1080#1082#1072' '#1079#1072' '#1061'*24 '#1095#1072#1089#1086#1074' '#1074' '#1090#1086#1095#1082#1077' '#1055#1086#1083#1091#1095#1072#1090#1077#1083#1103
            Width = 55
          end
          object Summ_sale: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078
            DataBinding.FieldName = 'Summ_sale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1090#1072#1090#1080#1089#1090#1080#1082#1072' '#1079#1072' '#1061'*24 '#1095#1072#1089#1086#1074
            Width = 70
          end
          object AmountIncome: TcxGridDBColumn
            Caption = #1055#1088#1080#1093#1086#1076' ('#1086#1078#1080#1076#1072#1077#1090#1089#1103')'
            DataBinding.FieldName = 'AmountIncome'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1080#1093#1086#1076' ('#1086#1078#1080#1076#1072#1077#1090#1089#1103') '#1074' '#1090#1086#1095#1082#1077' '#1055#1086#1083#1091#1095#1072#1090#1077#1083#1103
            Width = 87
          end
          object AmountOrderExternal: TcxGridDBColumn
            Caption = #1047#1072#1082#1072#1079' ('#1086#1078#1080#1076#1072#1077#1090#1089#1103')'
            DataBinding.FieldName = 'AmountOrderExternal'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1082#1072#1079' '#1086#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072' ('#1086#1078#1080#1076#1072#1077#1090#1089#1103') '#1074' '#1090#1086#1095#1082#1077' '#1055#1086#1083#1091#1095#1072#1090#1077#1083#1103
            Width = 87
          end
          object AmountSend_in: TcxGridDBColumn
            Caption = #1055#1077#1088#1077#1084#1077#1097'. '#1087#1088#1080#1093'. ('#1086#1078#1080#1076#1072#1077#1090#1089#1103')'
            DataBinding.FieldName = 'AmountSend_in'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1088#1080#1093#1086#1076' ('#1086#1078#1080#1076#1072#1077#1090#1089#1103') '#1074' '#1090#1086#1095#1082#1077' '#1055#1086#1083#1091#1095#1072#1090#1077#1083#1103
            Width = 87
          end
          object AmountSend_out: TcxGridDBColumn
            Caption = #1055#1077#1088#1077#1084#1077#1097'. '#1088#1072#1089#1093'. ('#1086#1078#1080#1076#1072#1077#1090#1089#1103')'
            DataBinding.FieldName = 'AmountSend_out'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1088#1072#1089#1093#1086#1076' ('#1086#1078#1080#1076#1072#1077#1090#1089#1103') '#1074' '#1090#1086#1095#1082#1077' '#1055#1086#1083#1091#1095#1072#1090#1077#1083#1103
            Width = 87
          end
          object AmountReserve: TcxGridDBColumn
            Caption = #1056#1077#1079#1077#1088#1074' '#1087#1086' '#1095#1077#1082#1072#1084
            DataBinding.FieldName = 'AmountReserve'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1077#1079#1077#1088#1074' '#1087#1086' '#1095#1077#1082#1072#1084' '#1074' '#1090#1086#1095#1082#1077' '#1055#1086#1083#1091#1095#1072#1090#1077#1083#1103
            Width = 87
          end
        end
      end
      object cxGrid2: TcxGrid
        Left = 0
        Top = 440
        Width = 782
        Height = 174
        Align = alBottom
        PopupMenu = PopupMenu
        TabOrder = 1
        ExplicitWidth = 784
        object cxGridDBTableViewResult_child: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = Result_childDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = ch2Amount
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = ch2Amount
            end
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = ch2FromName
            end>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsBehavior.GoToNextCellOnEnter = True
          OptionsBehavior.FocusCellOnCycle = True
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsCustomize.DataRowSizing = True
          OptionsData.CancelOnExit = False
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsData.Inserting = False
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object ch2FromName: TcxGridDBColumn
            Caption = #1054#1090' '#1082#1086#1075#1086
            DataBinding.FieldName = 'ToName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 200
          end
          object ch2ToName: TcxGridDBColumn
            Caption = #1050#1086#1084#1091
            DataBinding.FieldName = 'ToName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 200
          end
          object ch2Amount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1077#1079#1091#1083#1100#1090#1072#1090' - '#1050#1086#1083'-'#1074#1086' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1086' - '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1088#1072#1089#1093#1086#1076
            Options.Editing = False
            Width = 99
          end
        end
        object cxGridLevel2: TcxGridLevel
          GridView = cxGridDBTableViewResult_child
        end
      end
      object cxGrid1: TcxGrid
        Left = 0
        Top = 0
        Width = 782
        Height = 244
        Align = alClient
        PopupMenu = PopupMenu
        TabOrder = 2
        ExplicitWidth = 784
        object cxGridDBTableViewPartion: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = PartionDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmountRemains
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmountReserve
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmountSend_in
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmountSend_out
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmountRemains
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmountReserve
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmountSend_in
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmountSend_out
            end
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = chFromName
            end>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsBehavior.GoToNextCellOnEnter = True
          OptionsBehavior.FocusCellOnCycle = True
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsCustomize.DataRowSizing = True
          OptionsData.CancelOnExit = False
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsData.Inserting = False
          OptionsView.Footer = True
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object chFromName: TcxGridDBColumn
            Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1077#1083#1100
            DataBinding.FieldName = 'FromName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 158
          end
          object chToName: TcxGridDBColumn
            Caption = #1050#1086#1084#1091
            DataBinding.FieldName = 'ToName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object chGoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object chGoodsName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object chMCS: TcxGridDBColumn
            Caption = #1053#1058#1047
            DataBinding.FieldName = 'MCS'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1053#1058#1047' '#1074' '#1040#1087#1090#1077#1082#1077' "'#1054#1090' '#1082#1086#1075#1086'" '#1089' '#1091#1095#1077#1090#1086#1084' '#1079#1085#1072#1095#1077#1085#1080#1103' '#1074' '#1072#1089#1089#1086#1088#1090'. '#1084#1072#1090#1088#1080#1094#1077
            Width = 45
          end
          object chPrice: TcxGridDBColumn
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1074' '#1040#1087#1090#1077#1082#1077' "'#1054#1090' '#1082#1086#1075#1086'"'
            Width = 70
          end
          object chAmount_res: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1088#1077#1079'. '#1088#1072#1089#1093'.'
            DataBinding.FieldName = 'Amount_res'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = 
              #1056#1077#1079#1091#1083#1100#1090#1072#1090': '#1050#1086#1083'-'#1074#1086' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1086' - '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1088#1072#1089#1093#1086#1076' '#1076#1083#1103' '#1090#1086#1095#1082#1080' '#1086#1090 +
              #1087#1088#1072#1074#1080#1090#1077#1083#1103
            Width = 75
          end
          object chSumm_res: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1088#1077#1079'. '#1088#1072#1089#1093'.'
            DataBinding.FieldName = 'Summ_res'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = 
              #1056#1077#1079#1091#1083#1100#1090#1072#1090': '#1057#1091#1084#1084#1072' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1086' - '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1088#1072#1089#1093#1086#1076' '#1076#1083#1103' '#1090#1086#1095#1082#1080' '#1086#1090#1087 +
              #1088#1072#1074#1080#1090#1077#1083#1103
            Width = 80
          end
          object chAmountRemains_calc: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082' '#1088#1072#1089#1095#1077#1090
            DataBinding.FieldName = 'AmountRemains_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = 
              #1054#1089#1090#1072#1090#1086#1082' '#1074' '#1090#1086#1095#1082#1077' '#1054#1090#1087#1088#1072#1074#1080#1090#1077#1083#1103' '#1089' '#1091#1095#1077#1090#1086#1084': - '#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1088#1072#1089#1093#1086#1076' ('#1086#1078#1080#1076 +
              #1072#1077#1090#1089#1103') - '#1056#1077#1079#1077#1088#1074' '#1087#1086' '#1095#1077#1082#1072#1084
            Width = 70
          end
          object chAmountRemains_calc_all: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082' '#1088#1072#1089#1095'. ('#1087#1086#1083#1085#1099#1081')'
            DataBinding.FieldName = 'AmountRemains_calc_all'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = 
              #1054#1089#1090#1072#1090#1086#1082' '#1074' '#1090#1086#1095#1082#1077' '#1054#1090#1087#1088#1072#1074#1080#1090#1077#1083#1103' '#1089' '#1091#1095#1077#1090#1086#1084': '#1055#1088#1080#1093#1086#1076' ('#1086#1078#1080#1076#1072#1077#1084#1099#1081') + '#1055#1077#1088#1077#1084 +
              #1077#1097#1077#1085#1080#1077' '#1087#1088#1080#1093#1086#1076' ('#1086#1078#1080#1076#1072#1077#1090#1089#1103') - '#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1088#1072#1089#1093#1086#1076' ('#1086#1078#1080#1076#1072#1077#1090#1089#1103') + '#1047#1072#1082 +
              #1072#1079' ('#1086#1078#1080#1076#1072#1077#1084#1099#1081') - '#1056#1077#1079#1077#1088#1074' '#1087#1086' '#1095#1077#1082#1072#1084
            Width = 60
          end
          object chAmountRemains: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082
            DataBinding.FieldName = 'AmountRemains'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1089#1090#1072#1090#1086#1082' '#1074' '#1090#1086#1095#1082#1077' '#1054#1090#1087#1088#1072#1074#1080#1090#1077#1083#1103
            Width = 55
          end
          object chAmount_sale: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1087#1088#1086#1076'.'
            DataBinding.FieldName = 'Amount_sale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1090#1072#1090#1080#1089#1090#1080#1082#1072' '#1079#1072' '#1061'*24 '#1095#1072#1089#1086#1074' '#1074' '#1090#1086#1095#1082#1077' '#1054#1090#1087#1088#1072#1074#1080#1090#1077#1083#1103
            Width = 60
          end
          object chSumm_sale: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078
            DataBinding.FieldName = 'Summ_sale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1090#1072#1090#1080#1089#1090#1080#1082#1072' '#1079#1072' '#1061'*24 '#1095#1072#1089#1086#1074' '#1074' '#1090#1086#1095#1082#1077' '#1054#1090#1087#1088#1072#1074#1080#1090#1077#1083#1103
            Width = 88
          end
          object chAmountIncome: TcxGridDBColumn
            Caption = #1055#1088#1080#1093#1086#1076' ('#1086#1078#1080#1076#1072#1077#1090#1089#1103')'
            DataBinding.FieldName = 'AmountIncome'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1080#1093#1086#1076' ('#1086#1078#1080#1076#1072#1077#1090#1089#1103') '#1074' '#1090#1086#1095#1082#1077' '#1054#1090#1087#1088#1072#1074#1080#1090#1077#1083#1103
            Width = 82
          end
          object chAmountOrderExternal: TcxGridDBColumn
            Caption = #1047#1072#1082#1072#1079' ('#1086#1078#1080#1076#1072#1077#1090#1089#1103')'
            DataBinding.FieldName = 'AmountOrderExternal'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1082#1072#1079' '#1086#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072' ('#1086#1078#1080#1076#1072#1077#1090#1089#1103') '#1074' '#1090#1086#1095#1082#1077' '#1054#1090#1087#1088#1072#1074#1080#1090#1077#1083#1103
            Width = 88
          end
          object chAmountSend_in: TcxGridDBColumn
            Caption = #1055#1077#1088#1077#1084#1077#1097'. '#1087#1088#1080#1093'. ('#1086#1078#1080#1076#1072#1077#1090#1089#1103')'
            DataBinding.FieldName = 'AmountSend_in'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1088#1080#1093#1086#1076' ('#1086#1078#1080#1076#1072#1077#1090#1089#1103') '#1074' '#1090#1086#1095#1082#1077' '#1054#1090#1087#1088#1072#1074#1080#1090#1077#1083#1103
            Width = 55
          end
          object chAmountSend_out: TcxGridDBColumn
            Caption = #1055#1077#1088#1077#1084#1077#1097'. '#1088#1072#1089#1093'. ('#1086#1078#1080#1076#1072#1077#1090#1089#1103')'
            DataBinding.FieldName = 'AmountSend_out'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1088#1072#1089#1093#1086#1076' ('#1086#1078#1080#1076#1072#1077#1090#1089#1103') '#1074' '#1090#1086#1095#1082#1077' '#1054#1090#1087#1088#1072#1074#1080#1090#1077#1083#1103
            Width = 55
          end
          object chAmountReserve: TcxGridDBColumn
            Caption = #1056#1077#1079#1077#1088#1074' '#1087#1086' '#1095#1077#1082#1072#1084
            DataBinding.FieldName = 'AmountReserve'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1077#1079#1077#1088#1074' '#1087#1086' '#1095#1077#1082#1072#1084' '#1074' '#1090#1086#1095#1082#1077' '#1054#1090#1087#1088#1072#1074#1080#1090#1077#1083#1103
            Width = 55
          end
        end
        object cxGridLevel1: TcxGridLevel
          GridView = cxGridDBTableViewPartion
        end
      end
      object cxSplitter2: TcxSplitter
        Left = 0
        Top = 432
        Width = 782
        Height = 8
        HotZoneClassName = 'TcxMediaPlayer8Style'
        AlignSplitter = salBottom
        Control = cxGrid2
        ExplicitWidth = 784
      end
      object cxSplitter1: TcxSplitter
        Left = 0
        Top = 244
        Width = 782
        Height = 8
        HotZoneClassName = 'TcxMediaPlayer8Style'
        AlignSplitter = salBottom
        Control = cxGrid
        ExplicitWidth = 784
      end
    end
  end
  inherited Panel: TPanel
    Width = 782
    Height = 33
    TabOrder = 4
    ExplicitWidth = 784
    ExplicitHeight = 33
    inherited deStart: TcxDateEdit
      Left = 29
      EditValue = 43466d
      Properties.Kind = ckDateTime
      ExplicitLeft = 29
      ExplicitWidth = 140
      Width = 140
    end
    inherited deEnd: TcxDateEdit
      Left = 699
      EditValue = 43466d
      TabOrder = 2
      Visible = False
      ExplicitLeft = 699
    end
    inherited cxLabel1: TcxLabel
      Caption = #1057':'
      ExplicitWidth = 15
    end
    inherited cxLabel2: TcxLabel
      Left = 675
      Caption = #1087#1086':'
      Visible = False
      ExplicitLeft = 675
      ExplicitWidth = 20
    end
    object cxLabel3: TcxLabel
      Left = 186
      Top = 6
      Caption = #1058#1086#1074#1072#1088': '
    end
    object edGoods: TcxButtonEdit
      Left = 233
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 5
      Width = 312
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 83
    Top = 280
  end
  inherited ActionList: TActionList
    Left = 143
    Top = 335
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelectSend
        end>
    end
    object actGet_UserUnit: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_UserUnit
      StoredProcList = <
        item
          StoredProc = spGet_UserUnit
        end>
      Caption = 'actGet_UserUnit'
    end
    object actRefreshSend: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectSend
      StoredProcList = <
        item
          StoredProc = spSelectSend
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      RefreshOnTabSetChanges = False
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_Send_RemainsSun_expressV2DialogForm'
      FormNameParam.Value = 'TReport_Send_RemainsSun_expressV2DialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inOperDate'
          Value = 42370d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = GuidesGoods
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = GuidesGoods
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actRefreshOnDay: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1087#1086' '#1044#1085#1103#1084
      Hint = #1087#1086' '#1044#1085#1103#1084
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actSendSUN_ex2: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSendSUN_express2
      StoredProcList = <
        item
          StoredProc = spSendSUN_express2
        end>
      Caption = 'actSendSUN_ex2'
      ImageIndex = 41
    end
    object macSendSUN: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = macSendSUN_List
        end
        item
          Action = actRefreshSend
        end>
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' <'#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1086'  '#1069'-'#1057#1059#1053'>? '
      InfoAfterExecute = #1044#1086#1082#1091#1084#1077#1085#1090#1099' <'#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1086'  '#1069'-'#1057#1059#1053'> '#1089#1086#1079#1076#1072#1085#1099
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' <'#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1086'  '#1069'-'#1057#1059#1053'>'
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' <'#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1086' '#1057#1059#1053'>'
      ImageIndex = 41
    end
    object actOpenReportPartionDateForm: TdsdOpenForm
      Category = 'Report'
      TabSheet = tsMain
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' <'#1055#1086' '#1086#1089#1090#1072#1090#1082#1072#1084' '#1089#1088#1086#1082#1086#1074#1099#1093' '#1090#1086#1074#1072#1088#1086#1074'>'
      Hint = #1054#1090#1095#1077#1090' <'#1055#1086' '#1086#1089#1090#1072#1090#1082#1072#1084' '#1089#1088#1086#1082#1086#1074#1099#1093' '#1090#1086#1074#1072#1088#1086#1074'>'
      ImageIndex = 24
      FormName = 'TReport_GoodsPartionDateForm'
      FormNameParam.Value = 'TReport_GoodsPartionDateForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'UnitId'
          Value = ''
          Component = MasterCDS
          ComponentItem = 'UnitId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = ''
          Component = MasterCDS
          ComponentItem = 'UnitName'
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
          Name = 'IsDetail'
          Value = 'TRUE'
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenReportPartionHistoryForm: TdsdOpenForm
      Category = 'Report'
      TabSheet = tsMain
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' <'#1055#1086' '#1076#1074#1080#1078#1077#1085#1080#1102' '#1087#1072#1088#1090#1080#1080' '#1090#1086#1074#1072#1088#1072'>'
      Hint = #1054#1090#1095#1077#1090' <'#1055#1086' '#1076#1074#1080#1078#1077#1085#1080#1102' '#1087#1072#1088#1090#1080#1080' '#1090#1086#1074#1072#1088#1072'>'
      ImageIndex = 25
      FormName = 'TReport_GoodsPartionHistoryForm'
      FormNameParam.Value = 'TReport_GoodsPartionHistoryForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'UnitId'
          Value = ''
          Component = MasterCDS
          ComponentItem = 'UnitId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = ''
          Component = MasterCDS
          ComponentItem = 'UnitName'
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
          Name = 'isPartion'
          Value = 'TRUE'
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartyId'
          Value = '0'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartyName'
          Value = Null
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenReportPartionDateChild: TdsdOpenForm
      Category = 'Report'
      TabSheet = tsMain
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' <'#1055#1086' '#1086#1089#1090#1072#1090#1082#1072#1084' '#1089#1088#1086#1082#1086#1074#1099#1093' '#1090#1086#1074#1072#1088#1086#1074'> ('#1089#1088#1086#1082#1080')'
      Hint = #1054#1090#1095#1077#1090' <'#1055#1086' '#1086#1089#1090#1072#1090#1082#1072#1084' '#1089#1088#1086#1082#1086#1074#1099#1093' '#1090#1086#1074#1072#1088#1086#1074'> ('#1089#1088#1086#1082#1080')'
      ImageIndex = 24
      FormName = 'TReport_GoodsPartionDateForm'
      FormNameParam.Value = 'TReport_GoodsPartionDateForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'UnitId'
          Value = Null
          Component = PartionCDS
          ComponentItem = 'UnitId_from'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = Null
          Component = PartionCDS
          ComponentItem = 'FromName'
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
          Name = 'IsDetail'
          Value = 'TRUE'
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenReportPartionHistoryChild: TdsdOpenForm
      Category = 'Report'
      TabSheet = tsMain
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' <'#1055#1086' '#1076#1074#1080#1078#1077#1085#1080#1102' '#1087#1072#1088#1090#1080#1080' '#1090#1086#1074#1072#1088#1072'> ('#1089#1088#1086#1082#1080')'
      Hint = #1054#1090#1095#1077#1090' <'#1055#1086' '#1076#1074#1080#1078#1077#1085#1080#1102' '#1087#1072#1088#1090#1080#1080' '#1090#1086#1074#1072#1088#1072'> ('#1089#1088#1086#1082#1080')'
      ImageIndex = 25
      FormName = 'TReport_GoodsPartionHistoryForm'
      FormNameParam.Value = 'TReport_GoodsPartionHistoryForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'UnitId'
          Value = Null
          Component = PartionCDS
          ComponentItem = 'UnitId_from'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = Null
          Component = PartionCDS
          ComponentItem = 'FromName'
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
          Name = 'isPartion'
          Value = 'TRUE'
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartyId'
          Value = '0'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartyName'
          Value = Null
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actReportSendSUN: TdsdOpenForm
      Category = 'Report'
      TabSheet = tsMain
      MoveParams = <>
      Caption = #1055#1086#1076#1088#1086#1073#1085#1086' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1086' '#1057#1059#1053
      Hint = #1055#1086#1076#1088#1086#1073#1085#1086' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1086' '#1057#1059#1053
      ImageIndex = 26
      FormName = 'TReport_GoodsSendSUNForm'
      FormNameParam.Value = 'TReport_GoodsSendSUNForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 42132d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42132d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitId'
          Value = ''
          Component = MasterCDS
          ComponentItem = 'UnitId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = ''
          Component = MasterCDS
          ComponentItem = 'UnitName'
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
        end>
      isShowModal = False
    end
    object macSendSUN_List: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actSendSUN_ex2
        end>
      View = cxGridDBTableView
      Caption = 'macSendSUN_List'
    end
  end
  inherited MasterDS: TDataSource
    Left = 120
    Top = 400
  end
  inherited MasterCDS: TClientDataSet
    IndexFieldNames = 'GoodsId'
    MasterFields = 'GoodsId'
    MasterSource = PartionDS
    PacketRecords = 0
    Left = 56
    Top = 384
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_Send_RemainsSun_express_v2'
    DataSets = <
      item
        DataSet = MasterCDS
      end
      item
        DataSet = PartionCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inOperDate'
        Value = 41395d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = GuidesGoods
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 248
    Top = 160
  end
  inherited BarManager: TdxBarManager
    Left = 160
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
          ItemName = 'bbSendSUN'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbReportPartionHistory'
        end
        item
          Visible = True
          ItemName = 'bbReportPartionDate'
        end
        item
          Visible = True
          ItemName = 'bbReportSendSUN'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbOpenReportPartionHistoryChild'
        end
        item
          Visible = True
          ItemName = 'bbOpenReportPartionDateChild'
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
    object dxBarButton1: TdxBarButton
      Caption = #1055#1086' '#1087#1072#1088#1090#1080#1103#1084
      Category = 0
      Hint = #1055#1086' '#1087#1072#1088#1090#1080#1103#1084
      Visible = ivAlways
      ImageIndex = 38
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbPrint: TdxBarButton
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1085#1072' '#1082#1072#1089#1089#1072#1093
      Category = 0
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1085#1072' '#1082#1072#1089#1089#1072#1093
      Visible = ivAlways
      ImageIndex = 3
      ShortCut = 16464
    end
    object bbSendSUN: TdxBarButton
      Action = macSendSUN
      Category = 0
    end
    object bbReportPartionDate: TdxBarButton
      Action = actOpenReportPartionDateForm
      Category = 0
    end
    object bbReportPartionHistory: TdxBarButton
      Action = actOpenReportPartionHistoryForm
      Category = 0
    end
    object bbOpenReportPartionHistoryChild: TdxBarButton
      Action = actOpenReportPartionHistoryChild
      Category = 0
    end
    object bbOpenReportPartionDateChild: TdxBarButton
      Action = actOpenReportPartionDateChild
      Category = 0
    end
    object bbReportSendSUN: TdxBarButton
      Action = actReportSendSUN
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 352
    Top = 184
  end
  inherited PopupMenu: TPopupMenu
    Left = 144
  end
  inherited PeriodChoice: TPeriodChoice
    DateStart = nil
    DateEnd = nil
    Left = 416
    Top = 184
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = GuidesGoods
      end>
    Left = 480
    Top = 320
  end
  object rdUnit: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
      end>
    Left = 544
    Top = 32
  end
  object spGet_UserUnit: TdsdStoredProc
    StoredProcName = 'gpGet_UserUnit'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'UnitId'
        Value = ''
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 456
    Top = 32
  end
  object DBViewAddOn_Partion: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableViewPartion
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    Left = 632
    Top = 312
  end
  object PartionCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 488
    Top = 168
  end
  object PartionDS: TDataSource
    DataSet = PartionCDS
    Left = 552
    Top = 168
  end
  object DBViewAddOn_Result_child: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableViewResult_child
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    Left = 208
    Top = 528
  end
  object Result_childCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    IndexFieldNames = 'UnitId_from;GoodsId'
    MasterFields = 'UnitId_from;GoodsId'
    MasterSource = PartionDS
    PacketRecords = 0
    Params = <>
    Left = 320
    Top = 560
  end
  object Result_childDS: TDataSource
    DataSet = Result_childCDS
    Left = 432
    Top = 552
  end
  object spSendSUN_express2: TdsdStoredProc
    StoredProcName = 'gpInsert_Movement_Send_express2'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inOperDate'
        Value = 42370d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId_from'
        Value = Null
        Component = PartionCDS
        ComponentItem = 'UnitId_from'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId_to'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'UnitId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = PartionCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Amount_res'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountRemains_from'
        Value = Null
        Component = PartionCDS
        ComponentItem = 'AmountRemains'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountRemains_to'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountRemains'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMCS_from'
        Value = Null
        Component = PartionCDS
        ComponentItem = 'MCS'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMCS_to'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MCS'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 680
    Top = 176
  end
  object spSelectSend: TdsdStoredProc
    StoredProcName = 'gpReport_Send_by_express_v2'
    DataSet = Result_childCDS
    DataSets = <
      item
        DataSet = Result_childCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inOperDate'
        Value = 43466d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = GuidesGoods
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 72
    Top = 576
  end
  object GuidesGoods: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoods
    FormNameParam.Value = 'TGoodsLiteForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsLiteForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 572
    Top = 3
  end
end
