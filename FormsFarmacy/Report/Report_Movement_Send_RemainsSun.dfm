inherited Report_Movement_Send_RemainsSunForm: TReport_Movement_Send_RemainsSunForm
  Caption = #1054#1090#1095#1077#1090' <'#1087#1086' '#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1102' '#1057#1059#1053'>'
  ClientHeight = 673
  ClientWidth = 960
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 976
  ExplicitHeight = 711
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 59
    Width = 960
    Height = 474
    TabOrder = 3
    ExplicitTop = 59
    ExplicitWidth = 960
    ExplicitHeight = 474
    ClientRectBottom = 474
    ClientRectRight = 960
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 960
      ExplicitHeight = 474
      inherited cxGrid: TcxGrid
        Width = 960
        Height = 264
        ExplicitWidth = 960
        ExplicitHeight = 264
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
              Column = AmountSun_summ
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountResult
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountResult_summ
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
              Column = AmountSend
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSun_unit
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSun_unit_save
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_min
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_max
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Unit_count
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_min_1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_max_1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_min_2
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_max_2
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
              Column = Amount_next_res
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_next_res
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSunOnly_summ
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_notSold_summ
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
              Column = AmountSun_real
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSun_summ_save
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
              Column = AmountSun_summ
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountResult
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountResult_summ
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
              Column = AmountSend
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSun_unit
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSun_unit_save
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_min
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_max
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Unit_count
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_min_1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_max_1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_min_2
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_max_2
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
              Column = Amount_next_res
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_next_res
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSunOnly_summ
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_notSold_summ
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
              Column = AmountSun_real
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSun_summ_save
            end>
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object UnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
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
            Caption = #1048#1090#1086#1075#1086' '#1082#1086#1083'-'#1074#1086' '#1088#1077#1079#1091#1083#1100#1090#1072#1090' '#1087#1088#1080#1093'.'
            DataBinding.FieldName = 'Amount_res'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1082#1086#1083'-'#1074#1086' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1086' - '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1088#1080#1093#1086#1076
            Width = 85
          end
          object Summ_res: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1089#1091#1084#1084#1072' '#1088#1077#1079#1091#1083#1100#1090#1072#1090' '#1087#1088#1080#1093'.'
            DataBinding.FieldName = 'Summ_res'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1089#1091#1084#1084#1072' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1086' - '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1088#1080#1093#1086#1076
            Width = 88
          end
          object Amount_next_res: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1082#1086#1083'-'#1074#1086' '#1088#1077#1079#1091#1083#1100#1090#1072#1090' '#1086#1090#1083#1086#1078'.'
            DataBinding.FieldName = 'Amount_next_res'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1082#1086#1083'-'#1074#1086' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1086' - '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1088#1080#1093#1086#1076' '#1086#1090#1083#1086#1078#1077#1085#1086
            Width = 85
          end
          object Summ_next_res: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1089#1091#1084#1084#1072' '#1088#1077#1079#1091#1083#1100#1090#1072#1090' '#1086#1090#1083#1086#1078'.'
            DataBinding.FieldName = 'Summ_next_res'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1089#1091#1084#1084#1072' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1086' - '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1088#1080#1093#1086#1076' '#1086#1090#1083#1086#1078#1077#1085#1086
            Width = 88
          end
          object AmountSun_summ_save: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1089#1088#1086#1082' + 100'#1076#1085'. '#1073#1077#1079' '#1091#1095'.'#1080#1079#1084'.'
            DataBinding.FieldName = 'AmountSun_summ_save'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = 
              #1048#1090#1086#1075#1086' '#1082#1086#1083'-'#1074#1086' '#1089#1088#1086#1082#1086#1074#1099#1093' + 100'#1076#1085#1077#1081' '#1073#1077#1079' '#1087#1088#1086#1076#1072#1078' '#1087#1086' '#1074#1089#1077#1084' '#1040#1087#1090#1077#1082#1072#1084', '#1073#1077#1079' ' +
              #1091#1095#1077#1090#1072' '#1080#1079#1084#1077#1085#1077#1085#1080#1103
            Options.Editing = False
            Width = 73
          end
          object AmountSun_summ: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1089#1088#1086#1082' + 100'#1076#1085'.'
            DataBinding.FieldName = 'AmountSun_summ'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = 
              #1048#1090#1086#1075#1086' '#1082#1086#1083'-'#1074#1086' '#1089#1088#1086#1082#1086#1074#1099#1093' + 100'#1076#1085#1077#1081' '#1073#1077#1079' '#1087#1088#1086#1076#1072#1078' '#1087#1086' '#1074#1089#1077#1084' '#1040#1087#1090#1077#1082#1072#1084', '#1082#1086#1090#1086 +
              #1088#1099#1077' '#1073#1091#1076#1077#1084' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1103#1090#1100
            Width = 80
          end
          object AmountSunOnly_summ: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1089#1088#1086#1082
            DataBinding.FieldName = 'AmountSunOnly_summ'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = 
              #1048#1090#1086#1075#1086' '#1082#1086#1083'-'#1074#1086' '#1090#1086#1083#1100#1082#1086' '#1089#1088#1086#1082#1086#1074#1099#1093' '#1087#1086' '#1074#1089#1077#1084' '#1040#1087#1090#1077#1082#1072#1084', '#1082#1086#1090#1086#1088#1099#1077' '#1073#1091#1076#1077#1084' '#1088#1072#1089#1087 +
              #1088#1077#1076#1077#1083#1103#1090#1100
            Width = 80
          end
          object Amount_notSold_summ: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' 100'#1076#1085#1077#1081
            DataBinding.FieldName = 'Amount_notSold_summ'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = 
              #1048#1090#1086#1075#1086' '#1082#1086#1083'-'#1074#1086' '#1090#1086#1083#1100#1082#1086' 100'#1076#1085#1077#1081' '#1073#1077#1079' '#1087#1088#1086#1076#1072#1078' '#1087#1086' '#1074#1089#1077#1084' '#1040#1087#1090#1077#1082#1072#1084', '#1082#1086#1090#1086#1088#1099#1077' ' +
              #1073#1091#1076#1077#1084' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1103#1090#1100
            Width = 80
          end
          object AmountResult: TcxGridDBColumn
            Caption = #1040#1074#1090#1086#1079#1072#1082#1072#1079
            DataBinding.FieldName = 'AmountResult'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 78
          end
          object AmountResult_summ: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1040#1074#1090#1086#1079#1072#1082#1072#1079
            DataBinding.FieldName = 'AmountResult_summ'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1080#1090#1086#1075#1086' '#1040#1074#1090#1086#1079#1072#1082#1072#1079' '#1087#1086' '#1074#1089#1077#1084' '#1040#1087#1090#1077#1082#1072#1084
            Width = 88
          end
          object AmountRemains: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082
            DataBinding.FieldName = 'AmountRemains'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 58
          end
          object AmountIncome: TcxGridDBColumn
            Caption = #1055#1088#1080#1093#1086#1076' ('#1086#1078#1080#1076#1072#1077#1084#1099#1081')'
            DataBinding.FieldName = 'AmountIncome'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1080#1093#1086#1076' ('#1086#1078#1080#1076#1072#1077#1084#1099#1081')'
            Width = 87
          end
          object AmountSend: TcxGridDBColumn
            Caption = #1055#1077#1088#1077#1084#1077#1097'. ('#1086#1078#1080#1076#1072#1077#1090#1089#1103')'
            DataBinding.FieldName = 'AmountSend'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' ('#1086#1078#1080#1076#1072#1077#1090#1089#1103')'
            Width = 87
          end
          object AmountOrderExternal: TcxGridDBColumn
            Caption = #1047#1072#1082#1072#1079' ('#1086#1078#1080#1076#1072#1077#1084#1099#1081')'
            DataBinding.FieldName = 'AmountOrderExternal'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
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
            Width = 87
          end
          object AmountSun_unit: TcxGridDBColumn
            Caption = #1054#1089#1090'. '#1089#1088#1086#1082' '#1074' '#1072#1087#1090'.'
            DataBinding.FieldName = 'AmountSun_unit'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = 
              #1089#1088#1086#1082#1086#1074#1099#1077' '#1085#1072' '#1101#1090#1086#1081' '#1072#1087#1090#1077#1082#1077', '#1090#1086#1075#1076#1072' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103' '#1089' '#1076#1088#1091#1075#1080#1093' '#1072#1087#1090#1077#1082' '#1085#1077' '#1073#1091#1076 +
              #1077#1090', '#1090'.'#1077'. '#1101#1090#1086#1090' '#1040#1074#1090#1086#1079#1072#1082#1072#1079' '#1085#1077' '#1091#1095#1080#1090#1099#1074#1072#1077#1084
            Width = 90
          end
          object AmountSun_unit_save: TcxGridDBColumn
            Caption = #1054#1089#1090'. '#1089#1088#1086#1082' '#1074' '#1072#1087#1090'. ('#1073#1077#1079' '#1080#1079#1084'.)'
            DataBinding.FieldName = 'AmountSun_unit_save'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = 
              #1089#1088#1086#1082#1086#1074#1099#1077' '#1085#1072' '#1101#1090#1086#1081' '#1072#1087#1090#1077#1082#1077', '#1073#1077#1079' '#1091#1095#1077#1090#1072' '#1080#1079#1084#1077#1085#1077#1085#1080#1103',  '#1090#1086#1075#1076#1072' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103 +
              ' '#1089' '#1076#1088#1091#1075#1080#1093' '#1072#1087#1090#1077#1082' '#1085#1077' '#1073#1091#1076#1077#1090', '#1090'.'#1077'. '#1101#1090#1086#1090' '#1040#1074#1090#1086#1079#1072#1082#1072#1079' '#1085#1077' '#1091#1095#1080#1090#1099#1074#1072#1077#1084
            Width = 90
          end
          object Amount_sale: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1087#1088#1086#1076#1072#1078
            DataBinding.FieldName = 'Amount_sale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1090#1072#1090#1080#1089#1090#1080#1082#1072' '#1079#1072' 1 '#1084#1077#1089
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
            HeaderHint = #1057#1090#1072#1090#1080#1089#1090#1080#1082#1072' '#1079#1072' 1 '#1084#1077#1089
            Width = 70
          end
          object AmountSun_real: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1089#1088#1086#1082'. + 100'#1076#1085'. '#1087#1086' '#1088#1077#1072#1083'. '#1086#1089#1090'.'
            DataBinding.FieldName = 'AmountSun_real'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = 
              #1048#1090#1086#1075#1086' '#1082#1086#1083'-'#1074#1086' '#1089#1088#1086#1082#1086#1074#1099#1093' + 100'#1076#1085#1077#1081' '#1073#1077#1079' '#1087#1088#1086#1076#1072#1078' '#1087#1086' '#1074#1089#1077#1084' '#1040#1087#1090#1077#1082#1072#1084', '#1088#1077#1072#1083 +
              #1100#1085#1099#1077' '#1086#1089#1090#1072#1090#1082#1080' - '#1076#1083#1103' '#1090#1077#1089#1090#1072
            Options.Editing = False
            Width = 73
          end
          object Summ_min: TcxGridDBColumn
            Caption = #1052#1080#1085'. '#1089#1091#1084#1084#1072', '#1087#1077#1088#1077#1084#1077#1097'. ('#1089#1090#1072#1088#1090')'
            DataBinding.FieldName = 'Summ_min'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = 
              #1089#1093#1077#1084#1072' '#1089#1090#1072#1088#1090' - '#1084#1080#1085#1080#1084#1072#1083#1100#1085#1072#1103' '#1089#1091#1084#1084#1072' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103', '#1077#1089#1083#1080' '#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084' '#1074#1089#1077 +
              ' '#1074' 1 '#1072#1087#1090'.'
            Width = 80
          end
          object Summ_max: TcxGridDBColumn
            Caption = #1052#1072#1082#1089'. '#1089#1091#1084#1084#1072', '#1087#1077#1088#1077#1084#1077#1097'. ('#1089#1090#1072#1088#1090')'
            DataBinding.FieldName = 'Summ_max'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = 
              #1089#1093#1077#1084#1072' '#1089#1090#1072#1088#1090' - '#1084#1072#1082#1089#1080#1084#1072#1083#1100#1085#1072#1103' '#1089#1091#1084#1084#1072' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103', '#1077#1089#1083#1080' '#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084' '#1074#1089 +
              #1077' '#1074' 1 '#1072#1087#1090'.'
            Width = 73
          end
          object Unit_count: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1085#1072#1082#1083'. ('#1089#1090#1072#1088#1090')'
            DataBinding.FieldName = 'Unit_count'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = 
              #1089#1093#1077#1084#1072' '#1089#1090#1072#1088#1090' - '#1080#1090#1086#1075#1086' '#1082#1086#1083'-'#1074#1086' '#1085#1072#1082#1083#1072#1076#1085#1099#1093' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103', '#1077#1089#1083#1080' '#1087#1077#1088#1077#1084#1077#1097#1072#1077 +
              #1084' '#1074#1089#1077' '#1074' 1 '#1072#1087#1090'.'
            Width = 70
          end
          object Summ_min_1: TcxGridDBColumn
            Caption = #1052#1080#1085'. '#1089#1091#1084#1084#1072', '#1087#1077#1088#1077#1084#1077#1097'. '#1087#1086#1083#1085#1086#1077
            DataBinding.FieldName = 'Summ_min_1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '>=1000 '#1075#1088#1085', '#1084#1080#1085#1080#1084#1072#1083#1100#1085#1072#1103' '#1089#1091#1084#1084#1072' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103
            Options.Editing = False
            Width = 108
          end
          object Summ_max_1: TcxGridDBColumn
            Caption = #1052#1072#1082#1089'. '#1089#1091#1084#1084#1072', '#1087#1077#1088#1077#1084#1077#1097'. '#1087#1086#1083#1085#1086#1077
            DataBinding.FieldName = 'Summ_max_1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '>=1000 '#1075#1088#1085', '#1084#1072#1082#1089'. '#1089#1091#1084#1084#1072' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103
            Width = 100
          end
          object Unit_count_1: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1085#1072#1082#1083', '#1087#1077#1088#1077#1084#1077#1097'. '#1087#1086#1083#1085#1086#1077
            DataBinding.FieldName = 'Unit_count_1'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '>=1000 '#1075#1088#1085', '#1080#1090#1086#1075#1086' '#1082#1086#1083'-'#1074#1086' '#1085#1072#1082#1083#1072#1076#1085#1099#1093' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103
            Options.Editing = False
            Width = 30
          end
          object Summ_min_2: TcxGridDBColumn
            Caption = #1052#1080#1085'. '#1089#1091#1084#1084#1072', '#1087#1077#1088#1077#1084#1077#1097'. '#1086#1090#1083#1086#1078'.'
            DataBinding.FieldName = 'Summ_min_2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1086#1090#1083#1086#1078#1077#1085#1085#1086#1077', '#1084#1080#1085#1080#1084#1072#1083#1100#1085#1072#1103' '#1089#1091#1084#1084#1072' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103
            Options.Editing = False
            Width = 108
          end
          object Summ_max_2: TcxGridDBColumn
            Caption = #1052#1072#1082#1089'. '#1089#1091#1084#1084#1072', '#1087#1077#1088#1077#1084#1077#1097'. '#1086#1090#1083#1086#1078'.'
            DataBinding.FieldName = 'Summ_max_2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1086#1090#1083#1086#1078#1077#1085#1085#1086#1077', '#1084#1072#1082#1089'. '#1089#1091#1084#1084#1072' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103
            Width = 100
          end
          object Unit_count_2: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1085#1072#1082#1083', '#1087#1077#1088#1077#1084#1077#1097'. '#1086#1090#1083#1086#1078'.'
            DataBinding.FieldName = 'Unit_count_2'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1086#1090#1083#1086#1078#1077#1085#1085#1086#1077', '#1080#1090#1086#1075#1086' '#1082#1086#1083'-'#1074#1086' '#1085#1072#1082#1083#1072#1076#1085#1099#1093' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103
            Options.Editing = False
            Width = 30
          end
          object Summ_str: TcxGridDBColumn
            Caption = #1089#1087#1080#1089#1086#1082' '#1089#1091#1084#1084' '#1087#1077#1088#1077#1084#1077#1097'. '#1087#1086#1083#1085#1086#1077
            DataBinding.FieldName = 'Summ_str'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '>=1000 '#1075#1088#1085', '#1089#1087#1080#1089#1086#1082' '#1089#1091#1084#1084' '#1087#1086' '#1085#1072#1082#1083#1072#1076#1085#1099#1084' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103
            Options.Editing = False
            Width = 100
          end
          object UnitName_str: TcxGridDBColumn
            Caption = #1089#1087#1080#1089#1086#1082' '#1072#1087#1090#1077#1082' '#1087#1077#1088#1077#1084#1077#1097'. '#1087#1086#1083#1085#1086#1077
            DataBinding.FieldName = 'UnitName_str'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '>=1000 '#1075#1088#1085', '#1089#1087#1080#1089#1086#1082' '#1072#1087#1090#1077#1082' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103
            Width = 100
          end
          object Summ_next_str: TcxGridDBColumn
            Caption = #1089#1087#1080#1089#1086#1082' '#1089#1091#1084#1084' '#1087#1077#1088#1077#1084#1077#1097'. '#1086#1090#1083#1086#1078'.'
            DataBinding.FieldName = 'Summ_next_str'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1086#1090#1083#1086#1078#1077#1085#1085#1086#1077', '#1089#1087#1080#1089#1086#1082' '#1089#1091#1084#1084' '#1087#1086' '#1085#1072#1082#1083#1072#1076#1085#1099#1084' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103
            Options.Editing = False
            Width = 100
          end
          object UnitName_next_str: TcxGridDBColumn
            Caption = #1089#1087#1080#1089#1086#1082' '#1072#1087#1090#1077#1082' '#1087#1077#1088#1077#1084#1077#1097'. '#1086#1090#1083#1086#1078'.'
            DataBinding.FieldName = 'UnitName_next_str'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1086#1090#1083#1086#1078#1077#1085#1085#1086#1077', '#1089#1087#1080#1089#1086#1082' '#1072#1087#1090#1077#1082' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103
            Options.Editing = False
            Width = 100
          end
        end
      end
      object cxGrid2: TcxGrid
        Left = 0
        Top = 384
        Width = 960
        Height = 90
        Align = alBottom
        PopupMenu = PopupMenu
        TabOrder = 1
        object GridDBTableViewResult_child: TcxGridDBTableView
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
            DataBinding.FieldName = 'FromName'
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
          object ch2OperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086#1082'. '#1087#1088#1080#1093#1086#1076
            DataBinding.FieldName = 'OperDate'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 78
          end
          object ch2Invnumber: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. '#1087#1088#1080#1093#1086#1076
            DataBinding.FieldName = 'Invnumber'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 93
          end
          object ContainerId: TcxGridDBColumn
            DataBinding.FieldName = 'ContainerId'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object MovementId: TcxGridDBColumn
            DataBinding.FieldName = 'MovementId'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object chExpirationDate_in: TcxGridDBColumn
            Caption = #1057#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080
            DataBinding.FieldName = 'ExpirationDate_in'
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 70
          end
          object chPartionDateKindName: TcxGridDBColumn
            Caption = #1058#1080#1087#1099' '#1089#1088#1086#1082'/'#1085#1077' '#1089#1088#1086#1082
            DataBinding.FieldName = 'PartionDateKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 112
          end
        end
        object cxGridLevel2: TcxGridLevel
          GridView = GridDBTableViewResult_child
        end
      end
      object cxGrid1: TcxGrid
        Left = 0
        Top = 272
        Width = 960
        Height = 104
        Align = alBottom
        PopupMenu = PopupMenu
        TabOrder = 2
        object GridDBTableViewPartion: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = PartionDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chSumm
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmount
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
              Column = chAmount_next
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chSumm_next
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmountSunOnly_summ
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmount_notSold_summ
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmountResult
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmountRemains
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmount_sale
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmountSun_summ_save
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmountSun_summ
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chSumm
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
              Column = chAmount
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
              Column = chAmount_next
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chSumm_next
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmountSunOnly_summ
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmount_notSold_summ
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmountResult
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmountRemains
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmount_sale
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmountSun_summ_save
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmountSun_summ
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
          object chFromName: TcxGridDBColumn
            Caption = #1054#1090' '#1082#1086#1075#1086
            DataBinding.FieldName = 'FromName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 200
          end
          object chToName: TcxGridDBColumn
            Caption = #1050#1086#1084#1091
            DataBinding.FieldName = 'ToName'
            Visible = False
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
          object chAmountRemains: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082
            DataBinding.FieldName = 'AmountRemains'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1089#1090#1072#1090#1086#1082' '#1074' '#1040#1087#1090#1077#1082#1077' "'#1054#1090' '#1082#1086#1075#1086'"'
            Width = 55
          end
          object chAmount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1088#1077#1079#1091#1083#1100#1090'. '#1088#1072#1089#1093'.'
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1077#1079#1091#1083#1100#1090#1072#1090' - '#1050#1086#1083'-'#1074#1086' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1086' - '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1088#1072#1089#1093#1086#1076
            Width = 75
          end
          object chSumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1088#1077#1079#1091#1083#1100#1090'. '#1088#1072#1089#1093'.'
            DataBinding.FieldName = 'Summ'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1077#1079#1091#1083#1100#1090#1072#1090' - '#1057#1091#1084#1084#1072' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1086' - '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1088#1072#1089#1093#1086#1076
            Width = 80
          end
          object chAmount_next: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1088#1077#1079#1091#1083#1100#1090'. '#1086#1090#1083#1086#1078'. '#1088#1072#1089#1093'.'
            DataBinding.FieldName = 'Amount_next'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1077#1079#1091#1083#1100#1090#1072#1090' - '#1050#1086#1083'-'#1074#1086' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1086' - '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1088#1072#1089#1093#1086#1076' '#1086#1090#1083#1086#1078#1077#1085#1086
            Width = 82
          end
          object chSumm_next: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1088#1077#1079#1091#1083#1100#1090'. '#1086#1090#1083#1086#1078'. '#1088#1072#1089#1093'.'
            DataBinding.FieldName = 'Summ_next'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1077#1079#1091#1083#1100#1090#1072#1090' - '#1057#1091#1084#1084#1072' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1086' - '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1088#1072#1089#1093#1086#1076' '#1086#1090#1083#1086#1078#1077#1085#1086
            Width = 88
          end
          object chAmountSun_summ_save: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1089#1088#1086#1082' + 100'#1076#1085'. '#1073#1077#1079' '#1091#1095'.'#1080#1079#1084'.'
            DataBinding.FieldName = 'AmountSun_summ_save'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = 
              #1082#1086#1083'-'#1074#1086' '#1089#1088#1086#1082#1086#1074#1099#1093' + 100'#1076#1085#1077#1081' '#1073#1077#1079' '#1087#1088#1086#1076#1072#1078' '#1074' '#1040#1087#1090#1077#1082#1077' "'#1054#1090' '#1082#1086#1075#1086'", '#1073#1077#1079' '#1091#1095#1077 +
              #1090#1072' '#1080#1079#1084#1077#1085#1077#1085#1080#1103
            Width = 100
          end
          object chAmountSun_summ: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1089#1088#1086#1082' + 100'#1076#1085'.'
            DataBinding.FieldName = 'AmountSun_summ'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = 
              #1082#1086#1083'-'#1074#1086' '#1089#1088#1086#1082#1086#1074#1099#1093' + 100'#1076#1085#1077#1081' '#1073#1077#1079' '#1087#1088#1086#1076#1072#1078' '#1074' '#1040#1087#1090#1077#1082#1077' "'#1054#1090' '#1082#1086#1075#1086'", '#1082#1086#1090#1086#1088#1099#1077 +
              ' '#1073#1091#1076#1077#1084' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1103#1090#1100
            Width = 80
          end
          object chAmountSunOnly_summ: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1089#1088#1086#1082
            DataBinding.FieldName = 'AmountSunOnly_summ'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = 
              #1082#1086#1083'-'#1074#1086' '#1090#1086#1083#1100#1082#1086' '#1089#1088#1086#1082#1086#1074#1099#1093' '#1074' '#1040#1087#1090#1077#1082#1077' "'#1054#1090' '#1082#1086#1075#1086'", '#1082#1086#1090#1086#1088#1099#1077' '#1073#1091#1076#1077#1084' '#1088#1072#1089#1087#1088#1077#1076 +
              #1077#1083#1103#1090#1100
            Width = 70
          end
          object chAmount_notSold_summ: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' 100'#1076#1085#1077#1081
            DataBinding.FieldName = 'Amount_notSold_summ'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = 
              #1082#1086#1083'-'#1074#1086' '#1090#1086#1083#1100#1082#1086' 100'#1076#1085#1077#1081' '#1073#1077#1079' '#1087#1088#1086#1076#1072#1078' '#1074' '#1040#1087#1090#1077#1082#1077' "'#1054#1090' '#1082#1086#1075#1086'", '#1082#1086#1090#1086#1088#1099#1077' '#1073#1091#1076 +
              #1077#1084' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1103#1090#1100
            Width = 70
          end
          object chAmountResult: TcxGridDBColumn
            Caption = #1040#1074#1090#1086#1079#1072#1082#1072#1079
            DataBinding.FieldName = 'AmountResult'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1040#1074#1090#1086#1079#1072#1082#1072#1079' '#1074' '#1040#1087#1090#1077#1082#1077' "'#1054#1090' '#1082#1086#1075#1086'"'
            Width = 60
          end
          object chAmount_sale: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1087#1088#1086#1076#1072#1078
            DataBinding.FieldName = 'Amount_sale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1090#1072#1090#1080#1089#1090#1080#1082#1072' '#1079#1072' 1 '#1084#1077#1089' '#1074' '#1040#1087#1090#1077#1082#1077' "'#1054#1090' '#1082#1086#1075#1086'"'
            Width = 60
          end
          object chPrice: TcxGridDBColumn
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1074' '#1040#1087#1090#1077#1082#1077' "'#1054#1090' '#1082#1086#1075#1086'"'
            Width = 70
          end
        end
        object cxGridLevel1: TcxGridLevel
          GridView = GridDBTableViewPartion
        end
      end
      object cxSplitter2: TcxSplitter
        Left = 0
        Top = 376
        Width = 960
        Height = 8
        HotZoneClassName = 'TcxMediaPlayer8Style'
        AlignSplitter = salBottom
        Control = cxGrid2
      end
      object cxSplitter1: TcxSplitter
        Left = 0
        Top = 264
        Width = 960
        Height = 8
        HotZoneClassName = 'TcxMediaPlayer8Style'
        AlignSplitter = salBottom
        Control = cxGrid1
      end
    end
  end
  inherited Panel: TPanel
    Width = 960
    Height = 33
    ExplicitWidth = 960
    ExplicitHeight = 33
    inherited deStart: TcxDateEdit
      Left = 29
      EditValue = 42736d
      ExplicitLeft = 29
    end
    inherited deEnd: TcxDateEdit
      Left = 173
      EditValue = 42736d
      TabOrder = 2
      Visible = False
      ExplicitLeft = 173
    end
    inherited cxLabel1: TcxLabel
      Caption = #1057':'
      ExplicitWidth = 15
    end
    inherited cxLabel2: TcxLabel
      Left = 149
      Caption = #1087#1086':'
      Visible = False
      ExplicitLeft = 149
      ExplicitWidth = 20
    end
  end
  object cxSplitter3: TcxSplitter [2]
    Left = 0
    Top = 533
    Width = 960
    Height = 8
    HotZoneClassName = 'TcxMediaPlayer8Style'
    AlignSplitter = salBottom
    Control = cxGrid3
  end
  object cxGrid3: TcxGrid [3]
    Left = 0
    Top = 541
    Width = 960
    Height = 132
    Align = alBottom
    PopupMenu = PopupMenu
    TabOrder = 7
    object cxGridDBTableView1: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = DefSUNDS
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
      object dsFromName: TcxGridDBColumn
        Caption = #1054#1090' '#1082#1086#1075#1086
        DataBinding.FieldName = 'FromName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = 
          #1077#1089#1083#1080' 2 '#1076#1085#1103' '#1077#1089#1090#1100' '#1074' '#1086#1090#1083#1086#1078#1077#1085#1085#1086#1084' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1080', '#1090#1086#1075#1076#1072' '#1080#1089#1082#1083#1102#1095#1072#1077#1084' '#1080#1079' '#1057#1059#1053 +
          ' '#1080' '#1079#1072#1082#1072#1079#1099#1074#1072#1077#1084' '#1091' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
        Options.Editing = False
        Width = 200
      end
      object dsToName: TcxGridDBColumn
        Caption = #1050#1086#1084#1091
        DataBinding.FieldName = 'ToName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = 
          #1077#1089#1083#1080' 2 '#1076#1085#1103' '#1077#1089#1090#1100' '#1074' '#1086#1090#1083#1086#1078#1077#1085#1085#1086#1084' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1080', '#1090#1086#1075#1076#1072' '#1080#1089#1082#1083#1102#1095#1072#1077#1084' '#1080#1079' '#1057#1059#1053 +
          ' '#1080' '#1079#1072#1082#1072#1079#1099#1074#1072#1077#1084' '#1091' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
        Options.Editing = False
        Width = 200
      end
      object dsGoodsCode: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'GoodsCode'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = 
          #1077#1089#1083#1080' 2 '#1076#1085#1103' '#1077#1089#1090#1100' '#1074' '#1086#1090#1083#1086#1078#1077#1085#1085#1086#1084' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1080', '#1090#1086#1075#1076#1072' '#1080#1089#1082#1083#1102#1095#1072#1077#1084' '#1080#1079' '#1057#1059#1053 +
          ' '#1080' '#1079#1072#1082#1072#1079#1099#1074#1072#1077#1084' '#1091' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
        Options.Editing = False
        Width = 70
      end
      object dfGoodsName: TcxGridDBColumn
        Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1090#1086#1074#1072#1088#1072
        DataBinding.FieldName = 'GoodsName'
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = 
          #1077#1089#1083#1080' 2 '#1076#1085#1103' '#1077#1089#1090#1100' '#1074' '#1086#1090#1083#1086#1078#1077#1085#1085#1086#1084' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1080', '#1090#1086#1075#1076#1072' '#1080#1089#1082#1083#1102#1095#1072#1077#1084' '#1080#1079' '#1057#1059#1053 +
          ' '#1080' '#1079#1072#1082#1072#1079#1099#1074#1072#1077#1084' '#1091' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
        Options.Editing = False
        Width = 291
      end
    end
    object cxGridLevel3: TcxGridLevel
      GridView = cxGridDBTableView1
    end
  end
  inherited ActionList: TActionList
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
    object actRefreshStart: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet_UserUnit
      StoredProcList = <
        item
          StoredProc = spGet_UserUnit
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_Movement_Send_RemainsSunDialogForm'
      FormNameParam.Value = 'TReport_Movement_Send_RemainsSunDialogForm'
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
    object actSendSUN: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSendSUN
      StoredProcList = <
        item
          StoredProc = spSendSUN
        end>
      Caption = 'actSendSUN'
      ImageIndex = 41
    end
    object macSendSUN: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actSendSUN
        end>
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' <'#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1086' '#1057#1059#1053'>? '
      InfoAfterExecute = #1044#1086#1082#1091#1084#1077#1085#1090#1099' <'#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1086' '#1057#1059#1053'> '#1089#1086#1079#1076#1072#1085#1099
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' <'#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1086' '#1057#1059#1053'>'
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
  end
  inherited MasterDS: TDataSource
    Left = 112
    Top = 200
  end
  inherited MasterCDS: TClientDataSet
    Left = 56
    Top = 200
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_Movement_Send_RemainsSun'
    DataSets = <
      item
        DataSet = MasterCDS
      end
      item
        DataSet = PartionCDS
      end
      item
        DataSet = Result_childCDS
      end
      item
        DataSet = DefSUNCDS
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
      end>
    Left = 216
    Top = 176
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
    Left = 248
    Top = 248
  end
  inherited PeriodChoice: TPeriodChoice
    DateStart = nil
    DateEnd = nil
    Left = 408
    Top = 168
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    Left = 464
    Top = 216
  end
  object rdUnit: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
      end>
    Left = 912
    Top = 208
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
    Left = 792
    Top = 208
  end
  object DBViewAddOn_Partion: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = GridDBTableViewPartion
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <
      item
        ColorColumn = Summ_next_str
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = UnitName_str
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = Amount_sale
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = MCS
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = UnitName
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = GoodsCode
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = GoodsName
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = AmountSun_real
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = AmountSun_summ_save
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = UnitName_next_str
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = AmountRemains
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = AmountResult_summ
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = AmountResult
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = AmountSun_unit
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = AmountSun_unit_save
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = Price
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = Summ_sale
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = AmountIncome
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = AmountOrderExternal
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = AmountReserve
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = AmountSend
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = Summ_min
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = Summ_max
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = Unit_count
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = Summ_max_1
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = AmountSun_summ
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = Summ_min_1
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    Left = 648
    Top = 384
  end
  object PartionCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    IndexFieldNames = 'UnitId_to;GoodsId'
    MasterFields = 'UnitId;GoodsId'
    MasterSource = MasterDS
    PacketRecords = 0
    Params = <>
    Left = 416
    Top = 368
  end
  object PartionDS: TDataSource
    DataSet = PartionCDS
    Left = 544
    Top = 376
  end
  object DBViewAddOn_Result_child: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = GridDBTableViewResult_child
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <
      item
        ColorColumn = Summ_next_str
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = UnitName_str
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = Amount_sale
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = MCS
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = UnitName
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = GoodsCode
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = GoodsName
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = AmountSun_real
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = AmountSun_summ_save
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = UnitName_next_str
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = AmountRemains
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = AmountResult_summ
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = AmountResult
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = AmountSun_unit
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = AmountSun_unit_save
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = Price
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = Summ_sale
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = AmountIncome
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = AmountOrderExternal
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = AmountReserve
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = AmountSend
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = Summ_min
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = Summ_max
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = Unit_count
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = Summ_max_1
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = AmountSun_summ
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = Summ_min_1
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    Left = 576
    Top = 592
  end
  object Result_childCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    IndexFieldNames = 'UnitId_from;UnitId_to;GoodsId'
    MasterFields = 'UnitId_from;UnitId_to;GoodsId'
    MasterSource = PartionDS
    PacketRecords = 0
    Params = <>
    Left = 656
    Top = 496
  end
  object Result_childDS: TDataSource
    DataSet = Result_childCDS
    Left = 760
    Top = 480
  end
  object spSendSUN: TdsdStoredProc
    StoredProcName = 'gpInsert_Movement_Send_RemainsSun'
    DataSets = <
      item
      end>
    OutputType = otMultiExecute
    Params = <
      item
        Name = 'inOperDate'
        Value = 42370d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1000
    Left = 624
    Top = 192
  end
  object DefSUNCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 88
    Top = 576
  end
  object DefSUNDS: TDataSource
    DataSet = DefSUNCDS
    Left = 152
    Top = 584
  end
end
