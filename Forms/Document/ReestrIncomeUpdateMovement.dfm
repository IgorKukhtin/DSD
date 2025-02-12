inherited ReestrIncomeUpdateMovementForm: TReestrIncomeUpdateMovementForm
  Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1074#1080#1079#1091' '#1074' <'#1056#1077#1077#1089#1090#1088' '#1085#1072#1082#1083#1072#1076#1085#1099#1093' <'#1055#1088#1080#1093#1086#1076' '#1086#1090' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072'>'
  ClientHeight = 400
  ClientWidth = 1007
  ObjectMenuItem = Excel1
  AddOnFormData.RefreshAction = actRefreshStart
  AddOnFormData.Params = FormParams
  ExplicitWidth = 1023
  ExplicitHeight = 439
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 115
    Width = 1007
    Height = 285
    TabOrder = 3
    ExplicitTop = 115
    ExplicitWidth = 1007
    ExplicitHeight = 285
    ClientRectBottom = 285
    ClientRectRight = 1007
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1007
      ExplicitHeight = 285
      inherited cxGrid: TcxGrid
        Top = 83
        Width = 1007
        Height = 202
        ExplicitTop = 83
        ExplicitWidth = 1007
        ExplicitHeight = 202
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Filter.Options = [fcoCaseInsensitive, fcoShowOperatorDescription]
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
              Column = TotalSumm
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
              Column = TotalCountKg
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
              Column = TotalSumm
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
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = InvNumber_Income
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalCountKg
            end>
          OptionsBehavior.GoToNextCellOnEnter = False
          OptionsBehavior.FocusCellOnCycle = False
          OptionsCustomize.DataRowSizing = False
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsView.HeaderHeight = 40
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object LineNum: TcxGridDBColumn [0]
            Caption = #8470' '#1087'.'#1087'.'
            DataBinding.FieldName = 'LineNum'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 37
          end
          object BarCode_Income: TcxGridDBColumn [1]
            Caption = #1064#1090#1088#1080#1093' '#1082#1086#1076
            DataBinding.FieldName = 'BarCode_Income'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object ReestrKindName: TcxGridDBColumn [2]
            Caption = #1042#1080#1079#1072' '#1074' '#1085#1072#1082#1083#1072#1076#1085#1086#1081
            DataBinding.FieldName = 'ReestrKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 74
          end
          object StatusCode_Income: TcxGridDBColumn [3]
            Caption = #1057#1090#1072#1090#1091#1089' ('#1085#1072#1082#1083#1072#1076#1085#1072#1103')'
            DataBinding.FieldName = 'StatusCode_Income'
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
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object OperDate_Income: TcxGridDBColumn [4]
            Caption = #1044#1072#1090#1072' '#1089#1082#1083#1072#1076' ('#1085#1072#1082#1083#1072#1076#1085#1072#1103')'
            DataBinding.FieldName = 'OperDate_Income'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object OperDatePartner: TcxGridDBColumn [5]
            Caption = #1044#1072#1090#1072' '#1076#1086#1082'. '#1091' '#1087#1086#1082#1091#1087'.'
            DataBinding.FieldName = 'OperDatePartner'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object InvNumber_Income: TcxGridDBColumn [6]
            Caption = #8470' '#1076#1086#1082'. ('#1085#1072#1082#1083#1072#1076#1085#1072#1103')'
            DataBinding.FieldName = 'InvNumber_Income'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object InvNumberPartner: TcxGridDBColumn [7]
            Caption = #8470' '#1076#1086#1082'. '#1091' '#1087#1086#1082#1091#1087'.'
            DataBinding.FieldName = 'InvNumberPartner'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object FromName: TcxGridDBColumn [8]
            Caption = #1054#1090' '#1082#1086#1075#1086
            DataBinding.FieldName = 'FromName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object ToName: TcxGridDBColumn [9]
            Caption = #1050#1086#1084#1091
            DataBinding.FieldName = 'ToName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object JuridicalName_To: TcxGridDBColumn [10]
            Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalName_To'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object OKPO_To: TcxGridDBColumn [11]
            Caption = #1054#1050#1055#1054
            DataBinding.FieldName = 'OKPO_To'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 45
          end
          object TotalCountKg: TcxGridDBColumn [12]
            Caption = #1050#1086#1083'-'#1074#1086' '#1074#1077#1089' ('#1091' '#1087#1086#1082#1091#1087'.)'
            DataBinding.FieldName = 'TotalCountKg'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object TotalSumm: TcxGridDBColumn [13]
            Caption = #1057#1091#1084#1084#1072' '#1089' '#1053#1044#1057' ('#1080#1090#1086#1075')'
            DataBinding.FieldName = 'TotalSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object PaidKindName: TcxGridDBColumn [14]
            Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'PaidKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object ContractCode: TcxGridDBColumn [15]
            Caption = #1050#1086#1076' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object ContractName: TcxGridDBColumn [16]
            Caption = #8470' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object ContractTagName: TcxGridDBColumn [17]
            Caption = #1055#1088#1080#1079#1085#1072#1082' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractTagName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          inherited colOperDate: TcxGridDBColumn [18]
            Caption = #1044#1072#1090#1072' ('#1088#1077#1077#1089#1090#1088')'
            HeaderAlignmentHorz = taCenter
            Width = 55
          end
          inherited colInvNumber: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. ('#1088#1077#1077#1089#1090#1088')'
            HeaderAlignmentHorz = taCenter
            Width = 77
          end
          inherited colStatus: TcxGridDBColumn [20]
            Caption = #1057#1090#1072#1090#1091#1089' ('#1088#1077#1077#1089#1090#1088')'
            HeaderAlignmentHorz = taCenter
            Width = 55
          end
          object PersonalName: TcxGridDBColumn
            Caption = #1060#1048#1054' '#1089#1086#1090#1088#1091#1076#1085#1080#1082' ('#1089#1091#1087#1077#1088#1074#1072#1081#1079#1077#1088')'
            DataBinding.FieldName = 'PersonalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object UnitName_Personal: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'  ('#1089#1091#1087#1077#1088#1074#1072#1081#1079#1077#1088')'
            DataBinding.FieldName = 'UnitName_Personal'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 128
          end
          object PersonalTradeName: TcxGridDBColumn
            Caption = #1060#1048#1054' '#1089#1086#1090#1088#1091#1076#1085#1080#1082' ('#1058#1055')'
            DataBinding.FieldName = 'PersonalTradeName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object UnitName_PersonalTrade: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1058#1055')'
            DataBinding.FieldName = 'UnitName_PersonalTrade'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 128
          end
          object UpdateDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1074' '#1088#1077#1077#1089#1090#1088#1077' '#1074#1080#1079#1072' '#1042#1099#1074#1077#1079#1077#1085#1086' '#1089#1086' '#1089#1082#1083#1072#1076#1072')'
            DataBinding.FieldName = 'UpdateDate'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object UpdateName: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1074' '#1088#1077#1077#1089#1090#1088#1077' '#1074#1080#1079#1072' '#1042#1099#1074#1077#1079#1077#1085#1086' '#1089#1086' '#1089#1082#1083#1072#1076#1072')'
            DataBinding.FieldName = 'UpdateName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object Date_Insert: TcxGridDBColumn
            Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1074#1080#1079#1072' '#1055#1086#1083#1091#1095#1077#1085#1086' '#1086#1090' '#1082#1083#1080#1077#1085#1090#1072')'
            DataBinding.FieldName = 'Date_Insert'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 150
          end
          object Member_Insert: TcxGridDBColumn
            Caption = #1060#1048#1054' ('#1074#1080#1079#1072' '#1055#1086#1083#1091#1095#1077#1085#1086' '#1086#1090' '#1082#1083#1080#1077#1085#1090#1072')'
            DataBinding.FieldName = 'Member_Insert'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 140
          end
          object Date_EconomIn: TcxGridDBColumn
            Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1074#1080#1079#1072' '#1069#1082#1086#1085#1086#1084#1080#1089#1090#1099' ('#1074' '#1088#1072#1073#1086#1090#1077'))'
            DataBinding.FieldName = 'Date_EconomIn'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 120
          end
          object Member_EconomIn: TcxGridDBColumn
            Caption = #1060#1048#1054' ('#1074#1080#1079#1072' '#1069#1082#1086#1085#1086#1084#1080#1089#1090#1099' ('#1074' '#1088#1072#1073#1086#1090#1077'))'
            DataBinding.FieldName = 'Member_EconomIn'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 120
          end
          object Date_EconomOut: TcxGridDBColumn
            Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1074#1080#1079#1072' '#1069#1082#1086#1085#1086#1084#1080#1089#1090#1099' ('#1076#1083#1103' '#1089#1085#1072#1073#1078#1077#1085#1080#1103'))'
            DataBinding.FieldName = 'Date_EconomOut'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 138
          end
          object Member_EconomOut: TcxGridDBColumn
            Caption = #1060#1048#1054' ('#1074#1080#1079#1072' '#1069#1082#1086#1085#1086#1084#1080#1089#1090#1099' ('#1076#1083#1103' '#1089#1085#1072#1073#1078#1077#1085#1080#1103'))'
            DataBinding.FieldName = 'Member_EconomOut'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 131
          end
          object Date_Snab: TcxGridDBColumn
            Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1074#1080#1079#1072' '#1057#1085#1072#1073#1078#1077#1085#1080#1077' ('#1074' '#1088#1072#1073#1086#1090#1077'))'
            DataBinding.FieldName = 'Date_Snab'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 170
          end
          object Member_Snab: TcxGridDBColumn
            Caption = #1060#1048#1054' ('#1086#1090' '#1082#1086#1075#1086' '#1076#1083#1103' '#1074#1080#1079#1099' '#1057#1085#1072#1073#1078#1077#1085#1080#1077' ('#1074' '#1088#1072#1073#1086#1090#1077'))'
            DataBinding.FieldName = 'Member_Snab'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 170
          end
          object Date_SnabRe: TcxGridDBColumn
            Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1074#1080#1079#1072' '#1057#1085#1072#1073#1078#1077#1085#1080#1077' ('#1076#1083#1103' '#1087#1077#1088#1077#1076#1077#1083#1082#1080'))'
            DataBinding.FieldName = 'Date_SnabRe'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 190
          end
          object Member_SnabRe: TcxGridDBColumn
            Caption = #1060#1048#1054' ('#1074#1080#1079#1072' '#1057#1085#1072#1073#1078#1077#1085#1080#1077' ('#1076#1083#1103' '#1087#1077#1088#1077#1076#1077#1083#1082#1080'))'
            DataBinding.FieldName = 'Member_SnabRe'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 190
          end
          object Date_Remake: TcxGridDBColumn
            Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1074#1080#1079#1072' '#1044#1086#1082#1091#1084#1077#1085#1090' '#1080#1089#1087#1088#1072#1074#1083#1077#1085')'
            DataBinding.FieldName = 'Date_Remake'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 140
          end
          object Member_Remake: TcxGridDBColumn
            Caption = #1060#1048#1054' ('#1074#1080#1079#1072' '#1044#1086#1082#1091#1084#1077#1085#1090' '#1080#1089#1087#1088#1072#1074#1083#1077#1085')'
            DataBinding.FieldName = 'Member_Remake'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 140
          end
          object Date_Econom: TcxGridDBColumn
            Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1074#1080#1079#1072' '#1069#1082#1086#1085#1086#1084#1080#1089#1090#1099')'
            DataBinding.FieldName = 'Date_Econom'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1085#1085#1099#1077' '#1080#1079' '#1056#1077#1077#1089#1090#1088#1072
            Width = 120
          end
          object Member_Econom: TcxGridDBColumn
            Caption = #1060#1048#1054' ('#1074#1080#1079#1072' '#1069#1082#1086#1085#1086#1084#1080#1089#1090#1099')'
            DataBinding.FieldName = 'Member_Econom'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1085#1085#1099#1077' '#1080#1079' '#1056#1077#1077#1089#1090#1088#1072
            Width = 120
          end
          object Date_Buh: TcxGridDBColumn
            Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1074#1080#1079#1072' '#1041#1091#1093#1075#1072#1083#1090#1077#1088#1080#1103')'
            DataBinding.FieldName = 'Date_Buh'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 120
          end
          object Member_Buh: TcxGridDBColumn
            Caption = #1060#1048#1054' ('#1074#1080#1079#1072' '#1041#1091#1093#1075#1072#1083#1090#1077#1088#1080#1103')'
            DataBinding.FieldName = 'Member_Buh'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 120
          end
          object Date_InBuh: TcxGridDBColumn
            Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1074#1080#1079#1072' '#1041#1091#1093#1075#1072#1083#1090#1077#1088#1080#1103' '#1074' '#1088#1072#1073#1086#1090#1077')'
            DataBinding.FieldName = 'Date_InBuh'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 120
          end
          object Member_InBuh: TcxGridDBColumn
            Caption = #1060#1048#1054' ('#1074#1080#1079#1072' '#1041#1091#1093#1075#1072#1083#1090#1077#1088#1080#1103' '#1074' '#1088#1072#1073#1086#1090#1077')'
            DataBinding.FieldName = 'Member_InBuh'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 120
          end
        end
      end
      object cxGrid1: TcxGrid
        Left = 0
        Top = 0
        Width = 1007
        Height = 75
        Align = alTop
        PopupMenu = PopupMenu
        TabOrder = 1
        object cxGridDBTableView1: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = DataSource
          DataController.Filter.Options = [fcoCaseInsensitive, fcoShowOperatorDescription]
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
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
            end>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Inserting = False
          OptionsView.GroupByBox = False
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.HeaderAutoHeight = True
          OptionsView.HeaderHeight = 40
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object BarCode: TcxGridDBColumn
            Caption = #1057#1082#1072#1085#1080#1088#1091#1077#1090#1089#1103' <'#1053#1072#1082#1083#1072#1076#1085#1072#1103'> '#1080#1083#1080' '#1074#1074#1086#1076' '#8470
            DataBinding.FieldName = 'BarCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 180
          end
        end
        object cxGridLevel1: TcxGridLevel
          GridView = cxGridDBTableView1
        end
      end
      object cxSplitter1: TcxSplitter
        Left = 0
        Top = 75
        Width = 1007
        Height = 8
        HotZoneClassName = 'TcxXPTaskBarStyle'
        HotZone.Visible = False
        AlignSplitter = salTop
        Control = cxGrid1
      end
    end
  end
  inherited Panel: TPanel
    Width = 1007
    Height = 89
    ExplicitWidth = 1007
    ExplicitHeight = 89
    inherited deStart: TcxDateEdit
      Left = 593
      Top = 22
      EditValue = 42667d
      ExplicitLeft = 593
      ExplicitTop = 22
      ExplicitWidth = 91
      Width = 91
    end
    inherited deEnd: TcxDateEdit
      Left = 698
      Top = 22
      EditValue = 42667d
      ExplicitLeft = 698
      ExplicitTop = 22
      ExplicitWidth = 91
      Width = 91
    end
    inherited cxLabel1: TcxLabel
      Left = 593
      Top = 4
      ExplicitLeft = 593
      ExplicitTop = 4
    end
    inherited cxLabel2: TcxLabel
      Left = 698
      Top = 4
      ExplicitLeft = 698
      ExplicitTop = 4
    end
    object cxLabel18: TcxLabel
      Left = 593
      Top = 44
      Caption = #1055#1077#1095#1072#1090#1100' '#1076#1083#1103' '#1057#1086#1090#1088#1091#1076#1085#1080#1082' ('#1089#1091#1087#1077#1088#1074#1072#1081#1079#1077#1088')'
    end
    object cePersonal: TcxButtonEdit
      Left = 593
      Top = 62
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 195
    end
    object cxLabel19: TcxLabel
      Left = 810
      Top = 44
      Caption = #1055#1077#1095#1072#1090#1100' '#1076#1083#1103' '#1057#1086#1090#1088#1091#1076#1085#1080#1082' ('#1090#1086#1088#1075#1086#1074#1099#1081')'
    end
    object cePersonalTrade: TcxButtonEdit
      Left = 810
      Top = 62
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 195
    end
  end
  object cxLabel27: TcxLabel [2]
    Left = 8
    Top = 4
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1074#1080#1079#1099
  end
  object edReestrKind: TcxButtonEdit [3]
    Left = 8
    Top = 22
    ParentFont = False
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clBlue
    Style.Font.Height = -11
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = [fsBold]
    Style.IsFontAssigned = True
    TabOrder = 7
    Text = #1055#1086#1083#1091#1095#1077#1085#1086' '#1086#1090' '#1082#1083#1080#1077#1085#1090#1072
    Width = 225
  end
  object edIsShowAll: TcxCheckBox [4]
    Left = 812
    Top = 22
    Caption = #1055#1077#1095#1072#1090#1100' '#1087#1086' '#1042#1089#1077#1084' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103#1084
    State = cbsChecked
    TabOrder = 8
    Width = 185
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 83
    Top = 283
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
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end>
    Left = 40
    Top = 235
  end
  inherited ActionList: TActionList
    Left = 327
    Top = 138
    object actPrintPeriodGroup: TdsdPrintAction [1]
      Category = 'Print'
      MoveParams = <>
      StoredProc = spSelectPrintPeriodGroup
      StoredProcList = <
        item
          StoredProc = spSelectPrintPeriodGroup
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1087#1086' '#1058#1055' - '#1042#1057#1045' '#1079#1072' '#1087#1077#1088#1080#1086#1076' '#1089' '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085#1085#1086#1081' '#1074#1080#1079#1086#1081
      Hint = #1055#1077#1095#1072#1090#1100' '#1087#1086' '#1058#1055' - '#1042#1057#1045' '#1079#1072' '#1087#1077#1088#1080#1086#1076' '#1089' '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085#1085#1086#1081' '#1074#1080#1079#1086#1081
      ImageIndex = 19
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'PersonalName_Group;FromName;OperDatePartner'
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42667d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42667d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'ReestrKindName'
          Value = ''
          Component = ReestrKindGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'IsShowAllPrint'
          Value = False
          Component = FormParams
          ComponentItem = 'IsShowAllPrint'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isGroup'
          Value = True
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_ReestrIncomePeriod'
      ReportNameParam.Name = #1056#1077#1077#1089#1090#1088' '#1079#1072' '#1087#1077#1088#1080#1086#1076
      ReportNameParam.Value = 'PrintMovement_ReestrIncomePeriod'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintGroup: TdsdPrintAction [2]
      Category = 'Print'
      MoveParams = <>
      StoredProc = spSelectPrintGroup
      StoredProcList = <
        item
          StoredProc = spSelectPrintGroup
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1087#1086' '#1058#1055' - '#1056#1077#1077#1089#1090#1088#1072' '#1089' '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085#1085#1086#1081' '#1074#1080#1079#1086#1081
      Hint = #1055#1077#1095#1072#1090#1100' '#1087#1086' '#1058#1055' - '#1056#1077#1077#1089#1090#1088#1072' '#1089' '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085#1085#1086#1081' '#1074#1080#1079#1086#1081
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'PersonalName_Group;FromName;OperDatePartner'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'isGroup'
          Value = True
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_ReestrIncome'
      ReportNameParam.Name = #1056#1077#1077#1089#1090#1088
      ReportNameParam.Value = 'PrintMovement_ReestrIncome'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object macPrintPeriodGroup: TMultiAction [5]
      Category = 'Print'
      MoveParams = <>
      ActionList = <
        item
          Action = actDialog_Print
        end
        item
          Action = actPrintPeriodGroup
        end>
      Caption = #1044#1086#1082#1091#1084#1077#1085#1090#1099' '#1089' '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085#1085#1086#1081' '#1074#1080#1079#1086#1081
      Hint = #1044#1086#1082#1091#1084#1077#1085#1090#1099' '#1089' '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085#1085#1086#1081' '#1074#1080#1079#1086#1081
      ImageIndex = 16
    end
    inherited actInsert: TdsdInsertUpdateAction
      FormName = 'TSale_OrderForm'
      FormNameParam.Value = 'TSale_OrderForm'
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'ShowAll'
          Value = True
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'inChangePercentAmount'
          Value = Null
          Component = FormParams
          ComponentItem = 'inChangePercentAmount'
          DataType = ftFloat
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end>
    end
    inherited actUpdate: TdsdInsertUpdateAction
      FormName = 'TSale_OrderForm'
      FormNameParam.Value = 'TSale_OrderForm'
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
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
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'inChangePercentAmount'
          Value = Null
          Component = FormParams
          ComponentItem = 'inChangePercentAmount'
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
    end
    inherited spErased: TdsdExecStoredProc
      StoredProcList = <
        item
          StoredProc = spMovementSetErased
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100' '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085#1085#1091#1102' '#1074#1080#1079#1091
      Hint = #1054#1090#1084#1077#1085#1080#1090#1100' '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085#1085#1091#1102' '#1074#1080#1079#1091
      ImageIndex = 2
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TMovement_DateDialogForm'
      FormNameParam.Value = 'TMovement_DateDialogForm'
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
        end
        item
          Name = 'IsPartnerDate'
          Value = False
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actUpdateDataSource: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateMI
      StoredProcList = <
        item
          StoredProc = spUpdateMI
        end
        item
          StoredProc = spSelectBarCode
        end
        item
          StoredProc = spSelect
        end>
      Caption = 'actUpdateDataSource'
      DataSource = DataSource
    end
    object MovementItemProtocolOpenForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1089#1090#1088#1086#1082' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1089#1090#1088#1086#1082' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      ImageIndex = 34
      FormName = 'TMovementItemProtocolForm'
      FormNameParam.Value = 'TMovementItemProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BarCode_Sale'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actRefreshStart: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectBarCode
      StoredProcList = <
        item
          StoredProc = spSelectBarCode
        end
        item
          StoredProc = spGet_Period
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = True
    end
    object macMISetErased: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = spErased
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1054#1090#1084#1077#1085#1080#1090#1100' '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085#1085#1091#1102' '#1074#1080#1079#1091'? '
      InfoAfterExecute = #1042#1080#1079#1072' '#1086#1090#1084#1077#1085#1077#1085#1072
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100' '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085#1085#1091#1102' '#1074#1080#1079#1091
      Hint = #1054#1090#1084#1077#1085#1080#1090#1100' '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085#1085#1091#1102' '#1074#1080#1079#1091
      ImageIndex = 2
    end
    object actPrintPeriod: TdsdPrintAction
      Category = 'Print'
      MoveParams = <>
      StoredProc = spSelectPrintPeriod
      StoredProcList = <
        item
          StoredProc = spSelectPrintPeriod
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1042#1057#1045' '#1079#1072' '#1087#1077#1088#1080#1086#1076' '#1089' '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085#1085#1086#1081' '#1074#1080#1079#1086#1081
      Hint = #1055#1077#1095#1072#1090#1100' '#1042#1057#1045' '#1079#1072' '#1087#1077#1088#1080#1086#1076' '#1089' '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085#1085#1086#1081' '#1074#1080#1079#1086#1081
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
      Params = <
        item
          Name = 'StartDate'
          Value = Null
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = Null
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'ReestrKindName'
          Value = Null
          Component = ReestrKindGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'IsShowAllPrint'
          Value = Null
          Component = FormParams
          ComponentItem = 'IsShowAllPrint'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isGroup'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_ReestrIncomePeriod'
      ReportNameParam.Name = #1056#1077#1077#1089#1090#1088' '#1079#1072' '#1087#1077#1088#1080#1086#1076
      ReportNameParam.Value = 'PrintMovement_ReestrIncomePeriod'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint: TdsdPrintAction
      Category = 'Print'
      MoveParams = <>
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1056#1077#1077#1089#1090#1088#1072' '#1089' '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085#1085#1086#1081' '#1074#1080#1079#1086#1081
      Hint = #1055#1077#1095#1072#1090#1100' '#1056#1077#1077#1089#1090#1088#1072' '#1089' '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085#1085#1086#1081' '#1074#1080#1079#1086#1081
      ShortCut = 16464
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
        end
        item
          Name = 'isGroup'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_ReestrIncome'
      ReportNameParam.Name = #1056#1077#1077#1089#1090#1088
      ReportNameParam.Value = 'PrintMovement_ReestrIncome'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actExternalDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1042#1086#1076#1080#1090#1077#1083#1103'/'#1069#1082#1089#1087#1077#1076#1080#1090#1086#1088#1072'/'#1040#1074#1090#1086
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1042#1086#1076#1080#1090#1077#1083#1103'/'#1069#1082#1089#1087#1077#1076#1080#1090#1086#1088#1072'/'#1040#1074#1090#1086
      ImageIndex = 43
      FormName = 'TReestrUpdateDialogForm'
      FormNameParam.Value = 'TReestrUpdateDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'DriverId'
          Value = 0
          MultiSelectSeparator = ','
        end
        item
          Name = 'DriverName'
          Value = ''
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actDialog_Print: TExecuteDialog
      Category = 'Print'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      Caption = 'actDialog_Print'
      ImageIndex = 16
      FormName = 'TReestrPrintDialogForm'
      FormNameParam.Value = 'TReestrPrintDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'IsShowAll'
          Value = False
          Component = FormParams
          ComponentItem = 'IsShowAllPrint'
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ReestrKindId'
          Value = 640042
          Component = ReestrKindGuides
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ReestrKindName'
          Value = #1042#1099#1074#1077#1079#1077#1085#1086' '#1089#1086' '#1089#1082#1083#1072#1076#1072
          Component = ReestrKindGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'StartDate'
          Value = Null
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = Null
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object macPrintPeriod: TMultiAction
      Category = 'Print'
      MoveParams = <>
      ActionList = <
        item
          Action = actDialog_Print
        end
        item
          Action = actPrintPeriod
        end>
      Caption = #1044#1086#1082#1091#1084#1077#1085#1090#1099' '#1089' '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085#1085#1086#1081' '#1074#1080#1079#1086#1081
      Hint = #1044#1086#1082#1091#1084#1077#1085#1090#1099' '#1089' '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085#1085#1086#1081' '#1074#1080#1079#1086#1081
      ImageIndex = 16
    end
  end
  inherited MasterDS: TDataSource
    Left = 248
    Top = 267
  end
  inherited MasterCDS: TClientDataSet
    Left = 288
    Top = 307
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MI_ReestrIncomeUser'
    Params = <
      item
        Name = 'instartdate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inenddate'
        Value = 41640d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReestrKindId'
        Value = Null
        Component = ReestrKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 168
    Top = 243
  end
  inherited BarManager: TdxBarManager
    Left = 392
    Top = 131
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
          ItemName = 'bbShowErased'
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
          ItemName = 'bbErased'
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
          ItemName = 'bbPrintPeriod'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrintGroup'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrintPeriodGroup'
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
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
    end
    inherited bbMovementProtocol: TdxBarButton
      Action = MovementItemProtocolOpenForm
    end
    object bbErased: TdxBarButton
      Action = macMISetErased
      Category = 0
    end
    object bbPrint: TdxBarButton
      Action = actPrint
      Category = 0
      ImageIndex = 3
    end
    object bbExternalDialog: TdxBarButton
      Action = actExternalDialog
      Category = 0
    end
    object bbPrintPeriod: TdxBarButton
      Action = actPrintPeriod
      Category = 0
    end
    object bbPrintGroup: TdxBarButton
      Action = actPrintGroup
      Category = 0
      ImageIndex = 20
    end
    object bbPrintPeriodGroup: TdxBarButton
      Action = actPrintPeriodGroup
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    ActionItemList = <
      item
        Action = actUpdateDataSource
        ShortCut = 13
      end>
    Left = 304
    Top = 208
  end
  inherited PopupMenu: TPopupMenu
    Left = 888
    Top = 240
    object miInvoice: TMenuItem [3]
      Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1042#1089#1077' <'#1057#1095#1077#1090' - Invoice>'
      Hint = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1042#1089#1077' <'#1057#1095#1077#1090' - Invoice>'
      ImageIndex = 47
    end
    object miOrdSpr: TMenuItem [4]
      Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1042#1089#1077'  <'#1055#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1080#1077' - Ordspr>'
      Hint = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1042#1089#1077'  <'#1055#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1080#1077' - Ordspr>'
      ImageIndex = 48
    end
    object miDesadv: TMenuItem [5]
      Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1042#1089#1077'  <'#1059#1074#1077#1076#1086#1084#1083#1077#1085#1080#1077' - Desadv>'
      Hint = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1042#1089#1077'  <'#1059#1074#1077#1076#1086#1084#1083#1077#1085#1080#1077' - Desadv>'
      ImageIndex = 49
    end
    object N13: TMenuItem [6]
      Caption = '-'
    end
    inherited Excel1: TMenuItem
      Enabled = False
    end
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 248
    Top = 208
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = ReestrKindGuides
      end>
    Left = 800
    Top = 240
  end
  inherited spMovementComplete: TdsdStoredProc
    StoredProcName = 'gpComplete_Movement'
    Params = <
      item
        Name = 'inmovementid'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inislastcomplete'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 440
    Top = 226
  end
  inherited spMovementUnComplete: TdsdStoredProc
    StoredProcName = 'gpUnComplete_Movement'
    Params = <
      item
        Name = 'inmovementid'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPrinted'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isPrinted'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    Left = 440
    Top = 290
  end
  inherited spMovementSetErased: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_ReestrIncome_ReestrKindErased'
    Params = <
      item
        Name = 'inid'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReestrKindId'
        Value = Null
        Component = ReestrKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 80
    Top = 330
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
        Name = 'inReestrKindId'
        Value = Null
        Component = ReestrKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReestrKindName'
        Value = Null
        Component = ReestrKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameTransport'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'IsShowAllPrint'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'IsShowAll'
        Value = True
        DataType = ftString
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    Left = 496
  end
  inherited spMovementReComplete: TdsdStoredProc
    StoredProcName = 'gpReComplete_Movement'
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inislastcomplete'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 552
    Top = 312
  end
  object spUpdateMI: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_ReestrIncome'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inBarCode'
        Value = 'NULL'
        Component = ClientDataSet
        ComponentItem = 'BarCode'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReestrKindId'
        Value = Null
        Component = ReestrKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 352
    Top = 259
  end
  object ReestrKindGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edReestrKind
    Key = '0'
    FormNameParam.Value = 'TReestrKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TReestrKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = ReestrKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ReestrKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 165
    Top = 7
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 552
    Top = 123
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 600
    Top = 99
  end
  object spSelectBarCode: TdsdStoredProc
    StoredProcName = 'gpSelect_MI_Reestr_BarCode'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <
      item
        Name = 'inBarCode_Transport'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 688
    Top = 96
  end
  object dsdDBViewAddOn1: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView1
    OnDblClickActionList = <
      item
      end>
    ActionItemList = <
      item
        Action = actUpdateDataSource
        ShortCut = 13
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = True
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <
      item
        Column = BarCode
      end>
    SummaryItemList = <>
    ShowFieldImageList = <>
    ViewDocumentList = <>
    PropertiesCellList = <>
    Left = 472
    Top = 96
  end
  object spGet_Period: TdsdStoredProc
    StoredProcName = 'gpGet_Period'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'StartDate'
        Value = Null
        Component = deStart
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndDate'
        Value = Null
        Component = deEnd
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 184
    Top = 323
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 708
    Top = 270
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 708
    Top = 217
  end
  object spSelectPrint: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_ReestrIncome_Print'
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
        Name = 'inPersonalId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalTradeId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReestrKindId'
        Value = '0'
        Component = ReestrKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsReestrKind'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisShowAll'
        Value = Null
        Component = edIsShowAll
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 567
    Top = 176
  end
  object spSelectPrintPeriod: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_ReestrIncomePeriod_Print'
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
        Name = 'inStartDate'
        Value = Null
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = Null
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReestrKindId'
        Value = Null
        Component = ReestrKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalTradeId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsReestrKind'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsShowAll'
        Value = True
        Component = edIsShowAll
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 615
    Top = 264
  end
  object spSelectPrintGroup: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_ReestrIncome_Print'
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
        Name = 'inPersonalId'
        Value = '0'
        Component = GuidesPersonal
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalTradeId'
        Value = '0'
        Component = GuidesPersonalTrade
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReestrKindId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'inReestrKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsReestrKind'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisShowAll'
        Value = Null
        Component = edIsShowAll
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 647
    Top = 168
  end
  object GuidesPersonal: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePersonal
    FormNameParam.Value = 'TPersonal_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPersonal_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPersonal
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPersonal
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 368
    Top = 45
  end
  object GuidesPersonalTrade: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePersonalTrade
    FormNameParam.Value = 'TPersonal_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPersonal_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPersonalTrade
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPersonalTrade
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 672
    Top = 37
  end
  object spSelectPrintPeriodGroup: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_ReestrIncomePeriod_Print'
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
        Name = 'inStartDate'
        Value = 42667d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 42667d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReestrKindId'
        Value = '0'
        Component = ReestrKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalId'
        Value = '0'
        Component = GuidesPersonal
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalTradeId'
        Value = '0'
        Component = GuidesPersonalTrade
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsReestrKind'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsShowAll'
        Value = True
        Component = edIsShowAll
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 695
    Top = 312
  end
end
