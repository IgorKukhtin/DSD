inherited ReestrIncomeJournalForm: TReestrIncomeJournalForm
  Caption = #1046#1091#1088#1085#1072#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' <'#1056#1077#1077#1089#1090#1088' '#1085#1072#1082#1083#1072#1076#1085#1099#1093' ('#1087#1086#1089#1090#1072#1074#1097#1080#1082') ('#1074#1080#1079#1072')>'
  ClientHeight = 421
  ClientWidth = 838
  AddOnFormData.RefreshAction = actRefreshStart
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.Params = FormParams
  ExplicitWidth = 854
  ExplicitHeight = 460
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 59
    Width = 838
    Height = 362
    TabOrder = 3
    ExplicitTop = 59
    ExplicitWidth = 838
    ExplicitHeight = 362
    ClientRectBottom = 362
    ClientRectRight = 838
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 838
      ExplicitHeight = 362
      inherited cxGrid: TcxGrid
        Width = 838
        Height = 362
        ExplicitWidth = 838
        ExplicitHeight = 362
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Filter.Options = [fcoCaseInsensitive, fcoShowOperatorDescription]
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalCountPartner
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSumm
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = ToName
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalCountPartner
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSumm
            end>
          OptionsBehavior.GoToNextCellOnEnter = False
          OptionsBehavior.FocusCellOnCycle = False
          OptionsCustomize.DataRowSizing = False
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsView.GroupByBox = True
          OptionsView.HeaderHeight = 40
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          inherited colStatus: TcxGridDBColumn
            Caption = #1057#1090#1072#1090#1091#1089' ('#1088#1077#1077#1089#1090#1088')'
            Visible = False
            HeaderAlignmentHorz = taCenter
            Width = 70
          end
          inherited colOperDate: TcxGridDBColumn [1]
            Caption = #1044#1072#1090#1072' ('#1088#1077#1077#1089#1090#1088')'
            HeaderAlignmentHorz = taCenter
            Width = 70
          end
          inherited colInvNumber: TcxGridDBColumn [2]
            Caption = #8470' '#1076#1086#1082'. ('#1088#1077#1077#1089#1090#1088')'
            HeaderAlignmentHorz = taCenter
            Width = 70
          end
          object ReestrKindName: TcxGridDBColumn
            Caption = #1042#1080#1079#1072' '#1074' '#1085#1072#1082#1083#1072#1076#1085#1086#1081
            DataBinding.FieldName = 'ReestrKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object StatusCode_Sale: TcxGridDBColumn
            Caption = #1057#1090#1072#1090#1091#1089' ('#1085#1072#1082#1083#1072#1076#1085#1072#1103')'
            DataBinding.FieldName = 'StatusCode_Sale'
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
          object OperDate_Sale: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1089#1082#1083#1072#1076' ('#1085#1072#1082#1083#1072#1076#1085#1072#1103')'
            DataBinding.FieldName = 'OperDate_Sale'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object OperDatePartner: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086#1082'. '#1091' '#1087#1086#1082#1091#1087'.'
            DataBinding.FieldName = 'OperDatePartner'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object InvNumber_Sale: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. ('#1085#1072#1082#1083#1072#1076#1085#1072#1103')'
            DataBinding.FieldName = 'InvNumber_Sale'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object InvNumberPartner: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. '#1091' '#1087#1086#1082#1091#1087'.'
            DataBinding.FieldName = 'InvNumberPartner'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object FromName: TcxGridDBColumn
            Caption = #1054#1090' '#1082#1086#1075#1086
            DataBinding.FieldName = 'FromName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object ToName: TcxGridDBColumn
            Caption = #1050#1086#1084#1091
            DataBinding.FieldName = 'ToName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object JuridicalName_from: TcxGridDBColumn
            Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalName_from'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object OKPO_To: TcxGridDBColumn
            Caption = #1054#1050#1055#1054
            DataBinding.FieldName = 'OKPO_To'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 45
          end
          object TotalCountPartner: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' ('#1091' '#1087#1086#1089#1090'.)'
            DataBinding.FieldName = 'TotalCountPartner'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object TotalSumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089' '#1053#1044#1057' ('#1080#1090#1086#1075')'
            DataBinding.FieldName = 'TotalSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object PaidKindName: TcxGridDBColumn
            Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'PaidKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object ContractCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object ContractName: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object ContractTagName: TcxGridDBColumn
            Caption = #1055#1088#1080#1079#1085#1072#1082' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractTagName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object InvNumberOrder: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. '#1079#1072#1103#1074#1082#1072
            DataBinding.FieldName = 'InvNumberOrder'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object RouteGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1084'. / '#1052#1072#1088#1096#1088#1091#1090' ('#1079#1072#1103#1074#1082#1072')'
            DataBinding.FieldName = 'RouteGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object RouteName: TcxGridDBColumn
            Caption = #1052#1072#1088#1096#1088#1091#1090' ('#1079#1072#1103#1074#1082#1072')'
            DataBinding.FieldName = 'RouteName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object StatusCode_Transport: TcxGridDBColumn
            Caption = #1057#1090#1072#1090#1091#1089' ('#1055'.'#1083'.)'
            DataBinding.FieldName = 'StatusCode_Transport'
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
            Width = 70
          end
          object OperDate_Transport: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086#1082'. '#1055'.'#1083'.'
            DataBinding.FieldName = 'OperDate_Transport'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object InvNumber_Transport: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. '#1055'.'#1083'.'
            DataBinding.FieldName = 'InvNumber_Transport'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object CarModelName: TcxGridDBColumn
            Caption = #1052#1072#1088#1082'a '#1072#1074#1090#1086#1084#1086#1073#1080#1083#1103
            DataBinding.FieldName = 'CarModelName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 89
          end
          object CarName: TcxGridDBColumn
            Caption = #1040#1074#1090#1086#1084#1086#1073#1080#1083#1100
            DataBinding.FieldName = 'CarName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object PersonalDriverName: TcxGridDBColumn
            Caption = #1042#1086#1076#1080#1090#1077#1083#1100
            DataBinding.FieldName = 'PersonalDriverName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object MemberName: TcxGridDBColumn
            Caption = #1069#1082#1089#1087#1077#1076#1080#1090#1086#1088
            DataBinding.FieldName = 'MemberName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
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
    end
  end
  inherited Panel: TPanel
    Width = 838
    Height = 33
    ExplicitWidth = 838
    ExplicitHeight = 33
    inherited deStart: TcxDateEdit
      Left = 111
      EditValue = 43831d
      ExplicitLeft = 111
    end
    inherited deEnd: TcxDateEdit
      Left = 312
      EditValue = 43831d
      ExplicitLeft = 312
    end
    inherited cxLabel1: TcxLabel
      Left = 21
      ExplicitLeft = 21
    end
    inherited cxLabel2: TcxLabel
      Left = 202
      ExplicitLeft = 202
    end
  end
  object cxLabel27: TcxLabel [2]
    Left = 602
    Top = 6
    Caption = #1055#1088#1077#1076#1087#1088#1080#1103#1090#1080#1077':'
  end
  object edJuridicalBasis: TcxButtonEdit [3]
    Left = 680
    Top = 5
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 150
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 187
    Top = 219
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
    Left = 64
    Top = 219
  end
  inherited ActionList: TActionList
    Left = 31
    Top = 186
    inherited actInsert: TdsdInsertUpdateAction
      Enabled = False
      ShortCut = 0
      FormName = 'TReestrStartMovementForm'
      FormNameParam.Value = 'TReestrStartMovementForm'
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          MultiSelectSeparator = ','
        end>
    end
    inherited actUpdate: TdsdInsertUpdateAction
      FormName = 'TReestrIncomeStartMovementForm'
      FormNameParam.Value = 'TReestrIncomeStartMovementForm'
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
    end
    object actPrintForDriver: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100' <'#1052#1072#1088#1096#1088#1091#1090#1085#1099#1081' '#1083#1080#1089#1090' '#1076#1083#1103' '#1074#1086#1076#1080#1090#1077#1083#1103'>'
      Hint = #1055#1077#1095#1072#1090#1100' <'#1052#1072#1088#1096#1088#1091#1090#1085#1099#1081' '#1083#1080#1089#1090' '#1076#1083#1103' '#1074#1086#1076#1080#1090#1077#1083#1103'>'
      ImageIndex = 17
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
      ReportName = 'PrintMovement_ReestrIncomeDriver'
      ReportNameParam.Name = #1053#1072#1082#1083#1072#1076#1085#1072#1103' '#1056#1077#1077#1089#1090#1088#1072
      ReportNameParam.Value = 'PrintMovement_ReestrIncomeDriver'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint_User: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrint_User
      StoredProcList = <
        item
          StoredProc = spSelectPrint_User
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1087#1086' '#1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1102' <'#1056#1077#1077#1089#1090#1088' '#1085#1072#1082#1083#1072#1076#1085#1099#1093' ('#1087#1086#1089#1090#1072#1074#1097#1080#1082' '#1074#1080#1079#1072')>'
      Hint = #1055#1077#1095#1072#1090#1100' '#1087#1086' '#1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1102' <'#1056#1077#1077#1089#1090#1088' '#1085#1072#1082#1083#1072#1076#1085#1099#1093' ('#1087#1086#1089#1090#1072#1074#1097#1080#1082' '#1074#1080#1079#1072')>'
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
      ReportNameParam.Name = #1053#1072#1082#1083#1072#1076#1085#1072#1103' '#1056#1077#1077#1089#1090#1088#1072
      ReportNameParam.Value = 'PrintMovement_ReestrIncome'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100' <'#1056#1077#1077#1089#1090#1088' '#1085#1072#1082#1083#1072#1076#1085#1099#1093' ('#1087#1086#1089#1090#1072#1074#1097#1080#1082' '#1074#1080#1079#1072')>'
      Hint = #1055#1077#1095#1072#1090#1100' <'#1056#1077#1077#1089#1090#1088' '#1085#1072#1082#1083#1072#1076#1085#1099#1093' ('#1087#1086#1089#1090#1072#1074#1097#1080#1082' '#1074#1080#1079#1072')>'
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
      ReportNameParam.Name = #1053#1072#1082#1083#1072#1076#1085#1072#1103' '#1056#1077#1077#1089#1090#1088#1072
      ReportNameParam.Value = 'PrintMovement_ReestrIncome'
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
      FormName = 'TMovement_PeriodDialogForm'
      FormNameParam.Value = 'TMovement_PeriodDialogForm'
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
    object actShowMessage: TShowMessageAction
      Category = 'DSDLib'
      MoveParams = <>
    end
    object actRefreshStart: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet_UserJuridicalBasis
      StoredProcList = <
        item
          StoredProc = spGet_UserJuridicalBasis
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
  end
  inherited MasterDS: TDataSource
    Left = 64
    Top = 139
  end
  inherited MasterCDS: TClientDataSet
    Top = 139
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_ReestrIncome'
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
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 136
    Top = 163
  end
  inherited BarManager: TdxBarManager
    Left = 224
    Top = 155
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
          ItemName = 'bbEdit'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic'
        end
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
          ItemName = 'bbDelete'
        end
        item
          BeginGroup = True
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
          ItemName = 'bbPrint'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrint_User'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrintForDriver'
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
    object bbPrint: TdxBarButton
      Action = actPrint
      Category = 0
      ImageIndex = 3
    end
    object bbPrintForDriver: TdxBarButton
      Action = actPrintForDriver
      Category = 0
    end
    object bbPrint_User: TdxBarButton
      Action = actPrint_User
      Category = 0
      ImageIndex = 15
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 320
    Top = 224
  end
  inherited PopupMenu: TPopupMenu
    Left = 640
    Top = 152
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
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 288
    Top = 144
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = JuridicalBasisGuides
      end>
    Left = 496
    Top = 152
  end
  inherited spMovementComplete: TdsdStoredProc
    StoredProcName = 'gpComplete_Movement_ReestrIncome'
    Params = <
      item
        Name = 'inmovementid'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 40
    Top = 282
  end
  inherited spMovementUnComplete: TdsdStoredProc
    StoredProcName = 'gpUnComplete_Movement_ReestrIncome'
    Params = <
      item
        Name = 'inmovementid'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 72
    Top = 322
  end
  inherited spMovementSetErased: TdsdStoredProc
    StoredProcName = 'gpSetErased_Movement_ReestrIncome'
    Params = <
      item
        Name = 'inmovementid'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 152
    Top = 346
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
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameSale'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameSaleTax'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inChangePercentAmount'
        Value = Null
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isPrinted'
        Value = 'True'
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
      end>
    Left = 400
    Top = 200
  end
  inherited spMovementReComplete: TdsdStoredProc
    StoredProcName = 'gpReComplete_Movement_ReestrIncome'
    Left = 128
    Top = 288
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 708
    Top = 217
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 708
    Top = 270
  end
  object EDI: TEDI
    ConnectionParams.Host.Value = Null
    ConnectionParams.Host.DataType = ftString
    ConnectionParams.Host.MultiSelectSeparator = ','
    ConnectionParams.User.Value = Null
    ConnectionParams.User.Component = FormParams
    ConnectionParams.User.ComponentItem = 'UserName'
    ConnectionParams.User.DataType = ftString
    ConnectionParams.User.MultiSelectSeparator = ','
    ConnectionParams.Password.Value = Null
    ConnectionParams.Password.DataType = ftString
    ConnectionParams.Password.MultiSelectSeparator = ','
    Left = 784
    Top = 176
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
    Left = 623
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
    Left = 712
    Top = 32
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
        Value = '0'
        Component = MasterCDS
        ComponentItem = 'Id'
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
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 519
    Top = 264
  end
  object spSelectPrint_User: TdsdStoredProc
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
        ComponentItem = 'Id'
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
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 527
    Top = 312
  end
end
