inherited StaffListMovementForm: TStaffListMovementForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1064#1090#1072#1090#1085#1086#1077' '#1088#1072#1089#1087#1080#1089#1072#1085#1080#1077' ('#1080#1079#1084#1077#1085#1077#1085#1080#1103')>'
  ClientHeight = 564
  ClientWidth = 1153
  ExplicitWidth = 1169
  ExplicitHeight = 603
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 142
    Width = 1153
    Height = 422
    ExplicitTop = 142
    ExplicitWidth = 1153
    ExplicitHeight = 422
    ClientRectBottom = 422
    ClientRectRight = 1153
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1153
      ExplicitHeight = 398
      inherited cxGrid: TcxGrid
        Width = 1153
        Height = 398
        ExplicitWidth = 1153
        ExplicitHeight = 398
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
              Column = WageFund
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
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
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
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = PositionName
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = WageFund
            end>
          OptionsBehavior.FocusCellOnCycle = False
          OptionsCustomize.DataRowSizing = False
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsView.GroupSummaryLayout = gslStandard
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object PositionName: TcxGridDBColumn [0]
            Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
            DataBinding.FieldName = 'PositionName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actPositionChoice
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 222
          end
          object PositionLevelName: TcxGridDBColumn [1]
            Caption = #1056#1072#1079#1088#1103#1076
            DataBinding.FieldName = 'PositionLevelName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actPositionLevelChoice
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object StaffHoursDayName: TcxGridDBColumn [2]
            Caption = #1043#1088#1072#1092#1080#1082' '#1088#1072#1073#1086#1090#1099
            DataBinding.FieldName = 'StaffHoursDayName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actStaffHoursDayChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 79
          end
          object AmountReport: TcxGridDBColumn [3]
            Caption = #1064#1056' '#1076#1083#1103' '#1086#1090#1095#1077#1090#1072
            DataBinding.FieldName = 'AmountReport'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          object Amount: TcxGridDBColumn [4]
            Caption = #1064#1056' '#1076#1083#1103' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.;-,0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1110#1083#1100#1082#1110#1089#1090#1100' '#1096#1090#1072#1090#1085#1080#1093' '#1086#1076#1080#1085#1080#1094#1100
            Width = 70
          end
          object StaffHoursName: TcxGridDBColumn [5]
            Caption = #1063#1072#1089#1099' '#1088#1072#1073#1086#1090#1099
            DataBinding.FieldName = 'StaffHoursName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actStaffHoursChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 83
          end
          object StaffHoursLengthName: TcxGridDBColumn [6]
            Caption = #1055#1088#1086#1076'. '#1089#1084#1077#1085#1099', '#1095#1072#1089#1099' '#9
            DataBinding.FieldName = 'StaffHoursLengthName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actStaffHoursLengthChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1086#1076#1086#1083#1078#1080#1090#1077#1083#1100#1085#1086#1089#1090#1100' '#1089#1084#1077#1085#1099', '#1095#1072#1089#1099' '#9
            Width = 59
          end
          object StaffCount_1: TcxGridDBColumn [7]
            Caption = '1.'#1087#1085'.'
            DataBinding.FieldName = 'StaffCount_1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.;-,0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1110#1083#1100#1082#1110#1089#1090#1100' '#1096#1090#1072#1090#1085#1080#1093' '#1086#1076#1080#1085#1080#1094#1100' '#1074' '#1089#1084#1077#1085#1091' '#1087#1085'.'
            Width = 38
          end
          object StaffCount_2: TcxGridDBColumn [8]
            Caption = '2.'#1087#1085'.'
            DataBinding.FieldName = 'StaffCount_2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1110#1083#1100#1082#1110#1089#1090#1100' '#1096#1090#1072#1090#1085#1080#1093' '#1086#1076#1080#1085#1080#1094#1100' '#1074' '#1089#1084#1077#1085#1091' '#1074#1090'.'
            Width = 38
          end
          object StaffCount_3: TcxGridDBColumn [9]
            Caption = '3.'#1087#1085'.'
            DataBinding.FieldName = 'StaffCount_3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1110#1083#1100#1082#1110#1089#1090#1100' '#1096#1090#1072#1090#1085#1080#1093' '#1086#1076#1080#1085#1080#1094#1100' '#1074' '#1089#1084#1077#1085#1091' '#1089#1088'.'
            Width = 38
          end
          object StaffCount_4: TcxGridDBColumn [10]
            Caption = '4.'#1087#1085'.'
            DataBinding.FieldName = 'StaffCount_4'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1110#1083#1100#1082#1110#1089#1090#1100' '#1096#1090#1072#1090#1085#1080#1093' '#1086#1076#1080#1085#1080#1094#1100' '#1074' '#1089#1084#1077#1085#1091' '#1095#1090'.'
            Width = 38
          end
          object StaffCount_5: TcxGridDBColumn [11]
            Caption = '5.'#1087#1085'.'
            DataBinding.FieldName = 'StaffCount_5'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1110#1083#1100#1082#1110#1089#1090#1100' '#1096#1090#1072#1090#1085#1080#1093' '#1086#1076#1080#1085#1080#1094#1100' '#1074' '#1089#1084#1077#1085#1091' '#1087#1090'.'
            Width = 38
          end
          object StaffCount_6: TcxGridDBColumn [12]
            Caption = '6.'#1087#1085'.'
            DataBinding.FieldName = 'StaffCount_6'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1110#1083#1100#1082#1110#1089#1090#1100' '#1096#1090#1072#1090#1085#1080#1093' '#1086#1076#1080#1085#1080#1094#1100' '#1074' '#1089#1084#1077#1085#1091' '#1089#1073'.'
            Width = 38
          end
          object StaffCount_7: TcxGridDBColumn [13]
            Caption = '7.'#1087#1085'.'
            DataBinding.FieldName = 'StaffCount_7'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1110#1083#1100#1082#1110#1089#1090#1100' '#1096#1090#1072#1090#1085#1080#1093' '#1086#1076#1080#1085#1080#1094#1100' '#1074' '#1089#1084#1077#1085#1091' '#1074#1089'.'
            Width = 38
          end
          object StaffCount_Invent: TcxGridDBColumn [14]
            Caption = #1048#1085#1074#1077#1085#1090'.'
            DataBinding.FieldName = 'StaffCount_Invent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1110#1083#1100#1082#1110#1089#1090#1100' '#1096#1090#1072#1090#1085#1080#1093' '#1086#1076#1080#1085#1080#1094#1100' '#1074' '#1089#1084#1077#1085#1091' '#1048#1085#1072#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1103
            Width = 54
          end
          object TotalStaffCount: TcxGridDBColumn [15]
            Caption = #1042#1089#1100#1086#1075#1086' '#1079#1084#1110#1085' '#1079#1072' '#1084#1110#1089#1103#1094#1100' '#1076#1083#1103' '#1087#1086#1089#1072#1076#1080
            DataBinding.FieldName = 'TotalStaffCount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1089#1100#1086#1075#1086' '#1079#1084#1110#1085' '#1079#1072' '#1084#1110#1089#1103#1094#1100' '#1076#1083#1103' '#1087#1086#1089#1072#1076#1080
            Options.Editing = False
            Width = 70
          end
          object TotalStaffHoursLength: TcxGridDBColumn [16]
            Caption = #1060#1056#1063' ('#1092#1086#1085#1076' '#1088#1086#1073#1086#1095#1086#1075#1086' '#1095#1072#1089#1091')'
            DataBinding.FieldName = 'TotalStaffHoursLength'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1060#1056#1063' ('#1092#1086#1085#1076' '#1088#1086#1073#1086#1095#1086#1075#1086' '#1095#1072#1089#1091') '#1076#1083#1103' '#1087#1086#1089#1072#1076#1080' '
            Options.Editing = False
            Width = 70
          end
          object NormCount: TcxGridDBColumn [17]
            Caption = #1053#1086#1088#1084#1072' '#1079#1084#1110#1085' '#1076#1083#1103' 1-'#1108#1111' '#1096#1090'.'#1086#1076
            DataBinding.FieldName = 'NormCount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1053#1086#1088#1084#1072' '#1079#1084#1110#1085' '#1076#1083#1103' 1-'#1108#1111' '#1096#1090'.'#1086#1076
            Options.Editing = False
            Width = 70
          end
          object NormHours: TcxGridDBColumn [18]
            Caption = #1053#1086#1088#1084#1072' '#1095#1072#1089#1091' '#1076#1083#1103' 1-'#1108#1111' '#1096#1090'.'#1086#1076
            DataBinding.FieldName = 'NormHours'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1053#1086#1088#1084#1072' '#1095#1072#1089#1091' '#1076#1083#1103' 1-'#1108#1111' '#1096#1090'.'#1086#1076
            Options.Editing = False
            Width = 70
          end
          object StaffPaidKindName: TcxGridDBColumn [19]
            Caption = #1042#1080#1076' '#1086#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'StaffPaidKindName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actStaffPaidKindChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 66
          end
          object Staff_Price: TcxGridDBColumn [20]
            Caption = #1058#1072#1088#1080#1092#1080#1082#1072#1094#1080#1103
            DataBinding.FieldName = 'Staff_Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 64
          end
          object Staff_Summ_MK: TcxGridDBColumn [21]
            Caption = #1052#1050
            DataBinding.FieldName = 'Staff_Summ_MK'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 65
          end
          object Staff_Summ_real: TcxGridDBColumn [22]
            Caption = #1057#1076#1077#1083#1100#1085#1072#1103' '#1086#1087#1083#1072#1090#1072
            DataBinding.FieldName = 'Staff_Summ_real'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Staff_Summ_add: TcxGridDBColumn [23]
            Caption = #1055#1088#1077#1084#1080#1072#1083#1100#1085#1080#1081' '#1092#1086#1085#1076
            DataBinding.FieldName = 'Staff_Summ_add'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object WageFund: TcxGridDBColumn [24]
            Caption = #1060#1054#1055' '#1079#1072' '#1084#1110#1089#1103#1094#1100
            DataBinding.FieldName = 'WageFund'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1060#1054#1055' '#1079#1072' '#1084#1110#1089#1103#1094#1100
            Options.Editing = False
            Width = 70
          end
          object WageFund_byOne: TcxGridDBColumn [25]
            Caption = #1047#1055' '#1076#1083#1103' 1-'#1108#1111' '#1096#1090'.'#1086#1076' '#1076#1086' '#1086#1087#1086#1076#1072#1090#1082#1091#1072#1085#1085#1103
            DataBinding.FieldName = 'WageFund_byOne'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1055' '#1076#1083#1103' 1-'#1108#1111' '#1096#1090'.'#1086#1076' '#1076#1086' '#1086#1087#1086#1076#1072#1090#1082#1091#1072#1085#1085#1103
            Options.Editing = False
            Width = 77
          end
          object PersonalName: TcxGridDBColumn [26]
            Caption = #1052#1077#1085#1077#1076#1078#1077#1088' '#1087#1086' '#1087#1077#1088#1089#1086#1085#1072#1083#1091
            DataBinding.FieldName = 'PersonalName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actPersonalChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 112
          end
          inherited colIsErased: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          object Comment: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
        end
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 1153
    Height = 116
    TabOrder = 3
    ExplicitTop = -4
    ExplicitWidth = 1153
    ExplicitHeight = 116
    inherited edInvNumber: TcxTextEdit
      Left = 8
      ExplicitLeft = 8
      ExplicitWidth = 74
      Width = 74
    end
    inherited cxLabel1: TcxLabel
      Left = 8
      ExplicitLeft = 8
    end
    inherited edOperDate: TcxDateEdit
      Left = 89
      Properties.SaveTime = False
      Properties.ShowTime = False
      ExplicitLeft = 89
      ExplicitWidth = 84
      Width = 84
    end
    inherited cxLabel2: TcxLabel
      Left = 89
      ExplicitLeft = 89
    end
    inherited cxLabel15: TcxLabel
      Top = 45
      ExplicitTop = 45
    end
    inherited ceStatus: TcxButtonEdit
      Top = 63
      ExplicitTop = 63
      ExplicitWidth = 165
      ExplicitHeight = 22
      Width = 165
    end
    object cxLabel3: TcxLabel
      Left = 348
      Top = 5
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
    end
    object edUnit: TcxButtonEdit
      Left = 348
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 7
      Width = 209
    end
    object cxLabel22: TcxLabel
      Left = 570
      Top = 45
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
    end
    object ceComment: TcxTextEdit
      Left = 570
      Top = 63
      TabOrder = 9
      Width = 243
    end
    object cxLabel8: TcxLabel
      Left = 186
      Top = 45
      Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1089#1086#1079#1076'.)'
    end
    object edInsertDate: TcxDateEdit
      Left = 186
      Top = 63
      EditValue = 42132d
      Properties.DisplayFormat = 'dd.mm.yyyy hh:mm'
      Properties.EditFormat = 'dd.mm.yyyy hh:mm'
      Properties.Kind = ckDateTime
      Properties.ReadOnly = True
      TabOrder = 11
      Width = 148
    end
    object cxLabel7: TcxLabel
      Left = 831
      Top = 45
      Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076'.)'
    end
    object edInsertName: TcxButtonEdit
      Left = 830
      Top = 63
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 13
      Width = 187
    end
    object cxLabel24: TcxLabel
      Left = 348
      Top = 45
      Caption = #1044#1077#1087#1072#1088#1090#1072#1084#1077#1085#1090' 1 '#1088#1110#1074#1085#1103
    end
    object edDepartment: TcxButtonEdit
      Left = 348
      Top = 63
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 15
      Width = 209
    end
    object cxLabel14: TcxLabel
      Left = 570
      Top = 5
      Caption = #1056#1091#1082#1086#1074#1086#1076#1080#1090#1077#1083#1100' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103
    end
    object cePersonalHead: TcxButtonEdit
      Left = 570
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 17
      Width = 243
    end
    object edCount_1: TcxCurrencyEdit
      Left = 28
      Top = 91
      Properties.Alignment.Horz = taRightJustify
      Properties.Alignment.Vert = taVCenter
      Properties.DecimalPlaces = 3
      Properties.DisplayFormat = ',0.###'
      Properties.ReadOnly = True
      TabOrder = 18
      Width = 28
    end
    object cxLabel6: TcxLabel
      Left = 8
      Top = 92
      Hint = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100#1085#1086#1089#1090#1100', '#1082#1075
      Caption = #1055#1053
      ParentShowHint = False
      ShowHint = True
    end
    object cxLabel11: TcxLabel
      Left = 116
      Top = 92
      Hint = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100#1085#1086#1089#1090#1100', '#1082#1075
      Caption = #1057#1056
      ParentShowHint = False
      ShowHint = True
    end
    object edCount_3: TcxCurrencyEdit
      Left = 136
      Top = 91
      Properties.Alignment.Horz = taRightJustify
      Properties.Alignment.Vert = taVCenter
      Properties.DecimalPlaces = 3
      Properties.DisplayFormat = ',0.###'
      Properties.ReadOnly = True
      TabOrder = 21
      Width = 28
    end
    object cxLabel12: TcxLabel
      Left = 170
      Top = 92
      Hint = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100#1085#1086#1089#1090#1100', '#1082#1075
      Caption = #1063#1058
      ParentShowHint = False
      ShowHint = True
    end
    object edCount_4: TcxCurrencyEdit
      Left = 190
      Top = 91
      Properties.Alignment.Horz = taRightJustify
      Properties.Alignment.Vert = taVCenter
      Properties.DecimalPlaces = 3
      Properties.DisplayFormat = ',0.###'
      Properties.ReadOnly = True
      TabOrder = 23
      Width = 28
    end
    object cxLabel17: TcxLabel
      Left = 332
      Top = 92
      Hint = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100#1085#1086#1089#1090#1100', '#1082#1075
      Caption = #1042#1057
      ParentShowHint = False
      ShowHint = True
    end
    object edCount_7: TcxCurrencyEdit
      Left = 355
      Top = 91
      Properties.Alignment.Horz = taRightJustify
      Properties.Alignment.Vert = taVCenter
      Properties.DecimalPlaces = 3
      Properties.DisplayFormat = ',0.###'
      Properties.ReadOnly = True
      TabOrder = 25
      Width = 28
    end
  end
  object edUpdateName: TcxButtonEdit [2]
    Left = 830
    Top = 23
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 6
    Width = 187
  end
  object cxLabel4: TcxLabel [3]
    Left = 830
    Top = 5
    Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1082#1086#1088#1088'.)'
  end
  object edUpdateDate: TcxDateEdit [4]
    Left = 186
    Top = 23
    EditValue = 42132d
    Properties.DisplayFormat = 'dd.mm.yyyy hh:mm'
    Properties.EditFormat = 'dd.mm.yyyy hh:mm'
    Properties.Kind = ckDateTime
    Properties.ReadOnly = True
    TabOrder = 8
    Width = 148
  end
  object cxLabel5: TcxLabel [5]
    Left = 186
    Top = 5
    Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1082#1086#1088#1088'./'#1087#1088#1086#1074#1077#1076'.)'
  end
  object edCount_2: TcxCurrencyEdit [6]
    Left = 82
    Top = 91
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    Properties.ReadOnly = True
    TabOrder = 10
    Width = 28
  end
  object cxLabel9: TcxLabel [7]
    Left = 62
    Top = 92
    Hint = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100#1085#1086#1089#1090#1100', '#1082#1075
    Caption = #1042#1058
    ParentShowHint = False
    ShowHint = True
  end
  object cxLabel13: TcxLabel [8]
    Left = 224
    Top = 92
    Hint = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100#1085#1086#1089#1090#1100', '#1082#1075
    Caption = #1055#1058
    ParentShowHint = False
    ShowHint = True
  end
  object edCount_5: TcxCurrencyEdit [9]
    Left = 244
    Top = 91
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    Properties.ReadOnly = True
    TabOrder = 13
    Width = 28
  end
  object cxLabel16: TcxLabel [10]
    Left = 278
    Top = 92
    Hint = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100#1085#1086#1089#1090#1100', '#1082#1075
    Caption = #1057#1041
    ParentShowHint = False
    ShowHint = True
  end
  object edCount_6: TcxCurrencyEdit [11]
    Left = 298
    Top = 91
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    Properties.ReadOnly = True
    TabOrder = 15
    Width = 28
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 187
    Top = 448
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 40
    Top = 640
  end
  inherited ActionList: TActionList
    Left = 55
    Top = 303
    inherited actRefresh: TdsdDataSetRefresh
      RefreshOnTabSetChanges = True
    end
    object InsertRecord: TInsertRecord [2]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableView
      Action = actPositionChoice
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090'>'
      ImageIndex = 0
    end
    inherited actInsertUpdateMovement: TdsdExecStoredProc
      StoredProc = nil
      StoredProcList = <
        item
        end
        item
          StoredProc = spInsertUpdateMovement
        end>
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
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_OrderReturnTare'
      ReportNameParam.Value = 'PrintMovement_OrderReturnTare'
    end
    inherited actUnCompleteMovement: TChangeGuidesStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
        end>
    end
    inherited actCompleteMovement: TChangeGuidesStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
        end>
    end
    object actPositionLevelChoice: TOpenChoiceForm [14]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'PositionLevelorm'
      FormName = 'TPositionLevelForm'
      FormNameParam.Value = 'TPositionLevelForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PositionLevelId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PositionLevelName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actStaffPaidKindChoiceForm: TOpenChoiceForm [15]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'StaffPaidKindForm'
      FormName = 'TStaffPaidKindForm'
      FormNameParam.Value = 'TStaffPaidKindForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'StaffPaidKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'StaffPaidKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actStaffHoursDayChoiceForm: TOpenChoiceForm [16]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'StaffHoursDayForm'
      FormName = 'TStaffHoursDayForm'
      FormNameParam.Value = 'TStaffHoursDayForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'StaffHoursDayId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'StaffHoursDayName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actStaffHoursChoiceForm: TOpenChoiceForm [17]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'StaffHoursForm'
      FormName = 'TStaffHoursForm'
      FormNameParam.Value = 'TStaffHoursForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'StaffHoursId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'StaffHoursName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actStaffHoursLengthChoiceForm: TOpenChoiceForm [18]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'StaffHoursLengthForm'
      FormName = 'TStaffHoursLengthForm'
      FormNameParam.Value = 'TStaffHoursLengthForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'StaffHoursLengthId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'StaffHoursLengthName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actPersonalChoiceForm: TOpenChoiceForm [19]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'PersonalForm'
      FormName = 'TPersonalForm'
      FormNameParam.Value = 'TPersonalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PersonalId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PersonalName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actPositionChoice: TOpenChoiceForm [20]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'PositionForm'
      FormName = 'TPositionForm'
      FormNameParam.Value = 'TPositionForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PositionId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PositionName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
  end
  inherited MasterDS: TDataSource
    Left = 24
    Top = 424
  end
  inherited MasterCDS: TClientDataSet
    Left = 80
    Top = 448
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_StaffList'
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
        Name = 'inShowAll'
        Value = Null
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 248
  end
  inherited BarManager: TdxBarManager
    Left = 80
    Top = 207
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
          ItemName = 'bbInsertRecord'
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
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbMovementItemContainer'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbMovementItemProtocol'
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
    object bbPrintNoGroup: TdxBarButton
      Caption = #1055#1077#1095#1072#1090#1100' ('#1076#1077#1090#1072#1083#1100#1085#1086')'
      Category = 0
      Hint = #1055#1077#1095#1072#1090#1100' ('#1076#1077#1090#1072#1083#1100#1085#1086')'
      Visible = ivAlways
      ImageIndex = 16
      ShortCut = 16464
    end
    object bbPrintSaleOrder: TdxBarButton
      Caption = #1047#1072#1103#1074#1082#1072'/'#1086#1090#1075#1088#1091#1079#1082#1072
      Category = 0
      Hint = #1047#1072#1103#1074#1082#1072'/'#1086#1090#1075#1088#1091#1079#1082#1072
      Visible = ivAlways
      ImageIndex = 21
    end
    object bbPrintSaleOrderTax: TdxBarButton
      Caption = #1054#1090#1082#1083#1086#1085#1077#1085#1080#1077' '#1085#1072' %'
      Category = 0
      Hint = #1047#1072#1103#1074#1082#1072'/'#1086#1090#1075#1088#1091#1079#1082#1072' '#1086#1090#1082#1083#1086#1085#1077#1085#1080#1077' '#1085#1072' %'
      Visible = ivAlways
      ImageIndex = 18
    end
    object bbPersonalGroupChoiceForm: TdxBarButton
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#8470' '#1073#1088#1080#1075#1072#1076#1099
      Category = 0
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#8470' '#1073#1088#1080#1075#1072#1076#1099
      Visible = ivAlways
      ImageIndex = 76
    end
    object bbInsertRecord: TdxBarButton
      Action = InsertRecord
      Category = 0
    end
    object bb: TdxBarButton
      Caption = #1057#1087#1080#1089#1086#1082' '#1053#1072#1082#1083#1072#1076#1085#1099#1093' '#1087#1086' '#1074#1086#1079#1074#1088#1072#1090#1085#1086#1081' '#1090#1072#1088#1077
      Category = 0
      Hint = #1057#1087#1080#1089#1086#1082' '#1053#1072#1082#1083#1072#1076#1085#1099#1093' '#1087#1086' '#1074#1086#1079#1074#1088#1072#1090#1085#1086#1081' '#1090#1072#1088#1077
      Visible = ivAlways
      ImageIndex = 26
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    SummaryItemList = <
      item
        Param.Value = Null
        Param.Component = FormParams
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = 5
      end>
    Left = 750
    Top = 225
  end
  inherited PopupMenu: TPopupMenu
    Left = 800
    Top = 464
    object N2: TMenuItem
      Action = actMISetErased
    end
    object N3: TMenuItem
      Action = actMISetUnErased
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
        Name = 'inMask'
        Value = False
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameSendTax'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameSendBill'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 352
    Top = 440
  end
  inherited StatusGuides: TdsdGuides
    Left = 80
    Top = 48
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_StaffList'
    Left = 128
    Top = 16
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_StaffList'
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
        Name = 'inMask'
        Value = Null
        Component = FormParams
        ComponentItem = 'inMask'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Id'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber'
        Value = ''
        Component = edInvNumber
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
        DataType = ftString
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
        Name = 'UnitId'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
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
        Name = 'Comment'
        Value = 0.000000000000000000
        Component = ceComment
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InsertName'
        Value = Null
        Component = edInsertName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InsertDate'
        Value = Null
        Component = edInsertDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'UpdateDate'
        Value = 0d
        Component = edUpdateDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'UpdateName'
        Value = 'False'
        Component = edUpdateName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalHeadId'
        Value = Null
        Component = GuidesPersonalHead
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalHeadName'
        Value = Null
        Component = GuidesPersonalHead
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'DepartmentName'
        Value = Null
        Component = edDepartment
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Count_1'
        Value = Null
        Component = edCount_1
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Count_2'
        Value = Null
        Component = edCount_2
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Count_3'
        Value = Null
        Component = edCount_3
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Count_4'
        Value = Null
        Component = edCount_4
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Count_5'
        Value = Null
        Component = edCount_5
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Count_6'
        Value = Null
        Component = edCount_6
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Count_7'
        Value = Null
        Component = edCount_7
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'isMask'
        Value = Null
        Component = FormParams
        ComponentItem = 'inMask'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    Left = 216
    Top = 248
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_StaffList'
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
        Name = 'inUnitId'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = 'False'
        Component = ceComment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 162
    Top = 312
  end
  inherited GuidesFiller: TGuidesFiller
    GuidesList = <
      item
      end
      item
      end>
    Left = 128
    Top = 240
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
        Control = ceComment
      end
      item
        Control = edUnit
      end
      item
        Control = cePersonalHead
      end
      item
        Control = edDepartment
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
      end
      item
      end
      item
      end
      item
      end
      item
      end>
    Left = 272
    Top = 201
  end
  inherited RefreshAddOn: TRefreshAddOn
    DataSet = ''
    Left = 800
    Top = 328
  end
  inherited spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_OrderReturnTare_SetErased'
    Left = 710
    Top = 440
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_OrderReturnTare_SetUnErased'
    Left = 718
    Top = 384
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_StaffList'
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
        Name = 'inPositionId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PositionId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPositionLevelId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PositionLevelId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStaffPaidKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'StaffPaidKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStaffHoursDayId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'StaffHoursDayId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStaffHoursId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'StaffHoursId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStaffHoursLengthId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'StaffHoursLengthId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PersonalId'
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
        Name = 'inAmountReport'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountReport'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStaffCount_1'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'StaffCount_1'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStaffCount_2'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'StaffCount_2'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStaffCount_3'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'StaffCount_3'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStaffCount_4'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'StaffCount_4'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStaffCount_5'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'StaffCount_5'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStaffCount_6'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'StaffCount_6'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStaffCount_7'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'StaffCount_7'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStaffCount_Invent'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'StaffCount_Invent'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStaff_Price'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Staff_Price'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStaff_Summ_MK'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Staff_Summ_MK'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStaff_Summ_real'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Staff_Summ_real'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStaff_Summ_add'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Staff_Summ_add'
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
    Left = 160
    Top = 368
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
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
        Name = 'inGoodsKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 368
    Top = 272
  end
  inherited spGetTotalSumm: TdsdStoredProc
    Left = 332
    Top = 260
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    ComponentList = <
      item
      end>
    Left = 512
    Top = 328
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 436
    Top = 265
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 508
    Top = 246
  end
  object spSelectPrint: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_StaffList_Print'
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
    Left = 367
    Top = 376
  end
  object HeaderExit: THeaderExit
    ExitList = <
      item
        Control = edUnit
      end
      item
      end
      item
      end
      item
      end
      item
      end>
    Left = 624
    Top = 264
  end
  object GuidesPersonalHead: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePersonalHead
    DisableGuidesOpen = True
    FormNameParam.Value = 'TPersonal_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPersonal_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPersonalHead
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPersonalHead
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 655
    Top = 7
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
      end
      item
        Name = 'DepartmentName'
        Value = Null
        Component = edDepartment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalHeadId'
        Value = Null
        Component = GuidesPersonalHead
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalHeadName'
        Value = Null
        Component = GuidesPersonalHead
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 440
    Top = 48
  end
end
