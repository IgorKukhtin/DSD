inherited SendJournalForm: TSendJournalForm
  Caption = #1046#1091#1088#1085#1072#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' <'#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077'>'
  ClientHeight = 535
  ClientWidth = 826
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 842
  ExplicitHeight = 574
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 826
    Height = 478
    TabOrder = 3
    ExplicitWidth = 826
    ExplicitHeight = 478
    ClientRectBottom = 478
    ClientRectRight = 826
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 826
      ExplicitHeight = 478
      inherited cxGrid: TcxGrid
        Width = 826
        Height = 478
        ExplicitWidth = 826
        ExplicitHeight = 478
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Filter.Options = [fcoCaseInsensitive, fcoShowOperatorDescription]
          DataController.Filter.TranslateBetween = True
          DataController.Filter.TranslateIn = True
          DataController.Filter.TranslateLike = True
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalCount
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
              Column = TotalSumm
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummMVAT
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummPVAT
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummFrom
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummTo
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalCount
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
              Column = TotalSumm
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummMVAT
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummPVAT
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummFrom
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummTo
            end>
          OptionsBehavior.GoToNextCellOnEnter = False
          OptionsBehavior.FocusCellOnCycle = False
          OptionsCustomize.DataRowSizing = False
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
          inherited colStatus: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            Width = 55
          end
          inherited colOperDate: TcxGridDBColumn [1]
            HeaderAlignmentHorz = taCenter
            Width = 64
          end
          inherited colInvNumber: TcxGridDBColumn [2]
            Caption = #8470' '#1076#1086#1082'.'
            HeaderAlignmentHorz = taCenter
            Width = 65
          end
          object FromName: TcxGridDBColumn
            Caption = #1054#1090' '#1082#1086#1075#1086
            DataBinding.FieldName = 'FromName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 176
          end
          object ProvinceCityName_From: TcxGridDBColumn
            Caption = #1056#1072#1081#1086#1085' ('#1054#1090' '#1082#1086#1075#1086')'
            DataBinding.FieldName = 'ProvinceCityName_From'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 109
          end
          object ToName: TcxGridDBColumn
            Caption = #1050#1086#1084#1091
            DataBinding.FieldName = 'ToName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 165
          end
          object ProvinceCityName_To: TcxGridDBColumn
            Caption = #1056#1072#1081#1086#1085' ('#1050#1086#1084#1091')'
            DataBinding.FieldName = 'ProvinceCityName_To'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 95
          end
          object DriverSunName: TcxGridDBColumn
            Caption = #1042#1086#1076#1080#1090#1077#1083#1100' '#1087#1086#1083#1091#1095#1080#1074#1096#1080#1081' '#1090#1086#1074#1072#1088
            DataBinding.FieldName = 'DriverSunName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1086#1076#1080#1090#1077#1083#1100' '#1076#1083#1103' '#1088#1072#1079#1074#1086#1079#1082#1080' '#1090#1086#1074#1072#1088#1072
            Options.Editing = False
            Width = 146
          end
          object TotalCount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'TotalCount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object TotalSumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1091#1089#1088#1077#1076'. '#1079#1072#1082#1091#1087'. '#1094#1077#1085' ('#1073#1077#1079' '#1053#1044#1057')'
            DataBinding.FieldName = 'TotalSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 96
          end
          object TotalSummMVAT: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1079#1072#1082#1091#1087#1082#1080' '#1074' '#1091#1089#1088#1077#1076'. '#1094#1077#1085#1072#1093' '#1089' '#1091#1095'. % '#1082#1086#1088'-'#1082#1080' ('#1089' '#1053#1044#1057')'
            DataBinding.FieldName = 'TotalSummMVAT'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object TotalSummPVAT: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1079#1072#1082#1091#1087#1082#1080' '#1074' '#1091#1089#1088#1077#1076'. '#1094#1077#1085#1072#1093' ('#1089' '#1053#1044#1057')'
            DataBinding.FieldName = 'TotalSummPVAT'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 96
          end
          object TotalSummFrom: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1074' '#1094#1077#1085#1072#1093' '#1086#1090#1087#1088#1072#1074#1080#1090#1077#1083#1103
            DataBinding.FieldName = 'TotalSummFrom'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 96
          end
          object TotalSummTo: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1074' '#1094#1077#1085#1072#1093' '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1103
            DataBinding.FieldName = 'TotalSummTo'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 96
          end
          object isAuto: TcxGridDBColumn
            Caption = #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080
            DataBinding.FieldName = 'isAuto'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080' '#1087#1088#1080' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1080' '#1080#1079#1083#1080#1096#1082#1086#1074
            Options.Editing = False
            Width = 32
          end
          object Checked: TcxGridDBColumn
            Caption = #1055#1088#1086#1074#1077#1088#1077#1085#1086' '#1092#1072#1088#1084'.- '#1087#1086#1083#1091#1095'.'
            DataBinding.FieldName = 'Checked'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1086#1074#1077#1088#1077#1085#1086' '#1092#1072#1088#1084#1072#1094#1077#1074#1090#1086#1084'-'#1087#1086#1083#1091#1095#1072#1090#1077#1083#1077#1084
            Options.Editing = False
            Width = 72
          end
          object isComplete: TcxGridDBColumn
            Caption = #1057#1086#1073#1088#1072#1085#1086' '#1092#1072#1088#1084'.- '#1086#1090#1087#1088#1072#1074'.'
            DataBinding.FieldName = 'isComplete'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1086#1073#1088#1072#1085#1086' '#1092#1072#1088#1084#1072#1094#1077#1074#1090#1086#1084'-'#1086#1090#1087#1088#1072#1074#1080#1090#1077#1083#1077#1084
            Width = 59
          end
          object isDeferred: TcxGridDBColumn
            Caption = #1054#1090#1083#1086#1078#1077#1085
            DataBinding.FieldName = 'isDeferred'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object isSUN_v2: TcxGridDBColumn
            Caption = #1057#1059#1053' v.2'
            DataBinding.FieldName = 'isSUN_v2'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object isSUN_v3: TcxGridDBColumn
            Caption = #1069'-'#1057#1059#1053
            DataBinding.FieldName = 'isSUN_v3'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1086' '#1069'-'#1057#1059#1053
            Width = 55
          end
          object isSUN_v4: TcxGridDBColumn
            Caption = #1057#1059#1053'2-'#1055#1048
            DataBinding.FieldName = 'isSUN_v4'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1086' '#1057#1059#1053'2-'#1055#1048
            Options.Editing = False
            Width = 55
          end
          object isSUN: TcxGridDBColumn
            Caption = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1086' '#1057#1059#1053' v.1'
            DataBinding.FieldName = 'isSUN'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1086' '#1057#1059#1053
            Options.Editing = False
            Width = 58
          end
          object isDefSUN: TcxGridDBColumn
            Caption = #1054#1090#1083#1086#1078#1077#1085#1085#1086' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1086' '#1057#1059#1053' v.1'
            DataBinding.FieldName = 'isDefSUN'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = ' '#9#1054#1090#1083#1086#1078#1077#1085#1085#1086' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1086' '#1057#1059#1053
            Options.Editing = False
            Width = 77
          end
          object isSent: TcxGridDBColumn
            Caption = #1054#1090#1087#1088#1072#1074#1083#1077#1085#1086'-'#1076#1072
            DataBinding.FieldName = 'isSent'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 74
          end
          object isReceived: TcxGridDBColumn
            Caption = #1055#1086#1083#1091#1095#1077#1085#1086'-'#1076#1072
            DataBinding.FieldName = 'isReceived'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 69
          end
          object isOverdueSUN: TcxGridDBColumn
            Caption = #1055#1088#1086#1089#1088#1086#1095#1077#1085#1086' '#1087#1086' '#1057#1059#1053
            DataBinding.FieldName = 'isOverdueSUN'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object isNotDisplaySUN: TcxGridDBColumn
            Caption = #1053#1077' '#1086#1090#1086#1073#1088#1072#1078#1072#1090#1100' '#1076#1083#1103' '#1089#1073#1086#1088#1072' '#1057#1059#1053
            DataBinding.FieldName = 'isNotDisplaySUN'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 93
          end
          object isVIP: TcxGridDBColumn
            Caption = #1042#1048#1055
            DataBinding.FieldName = 'isVIP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 48
          end
          object isUrgently: TcxGridDBColumn
            Caption = #1057#1088#1086#1095#1085#1086
            DataBinding.FieldName = 'isUrgently'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 53
          end
          object isConfirmed: TcxGridDBColumn
            Caption = #1055#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1080#1077
            DataBinding.FieldName = 'ConfirmedText'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 104
          end
          object MCSPeriod: TcxGridDBColumn
            Caption = #1055#1077#1088#1080#1086#1076' '#1088#1072#1089#1095#1077#1090#1072' '#1053#1058#1047
            DataBinding.FieldName = 'MCSPeriod'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object MCSDay: TcxGridDBColumn
            Caption = #1053#1072' '#1089#1082#1086#1083#1100#1082#1086' '#1076#1085#1077#1081' '#1053#1058#1047
            DataBinding.FieldName = 'MCSDay'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object PartionDateKindName: TcxGridDBColumn
            Caption = #1058#1080#1087#1099' '#1089#1088#1086#1082'/'#1085#1077' '#1089#1088#1086#1082
            DataBinding.FieldName = 'PartionDateKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object Comment: TcxGridDBColumn
            Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 147
          end
          object lInsertName: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076'.)'
            DataBinding.FieldName = 'InsertName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 101
          end
          object lInsertDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' ('#1089#1086#1079#1076'.)'
            DataBinding.FieldName = 'InsertDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 78
          end
          object InsertDateDiff: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1076#1085#1077#1081' '#1088#1072#1079#1085#1080#1094#1072' '#1089#1086#1079#1076#1072#1085#1080#1103
            DataBinding.FieldName = 'InsertDateDiff'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0;-,0; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 71
          end
          object UpdateName: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1082#1086#1088#1088'.)'
            DataBinding.FieldName = 'UpdateName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 101
          end
          object UpdateDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' ('#1082#1086#1088#1088'.)'
            DataBinding.FieldName = 'UpdateDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 78
          end
          object UpdateDateDiff: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1076#1085#1077#1081' '#1088#1072#1079#1085#1080#1094#1072' '#1080#1079#1084#1077#1085#1077#1085#1080#1081
            DataBinding.FieldName = 'UpdateDateDiff'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0;-,0; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 77
          end
          object ReportInvNumber_full: TcxGridDBColumn
            Caption = #1044#1086#1082#1091#1084#1077#1085#1090' '#1054#1090#1095'. '#1087#1086' '#1085#1077#1083#1080#1082#1074'.'
            DataBinding.FieldName = 'ReportInvNumber_full'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1054#1090#1095#1077#1090' '#1087#1086' '#1085#1077#1083#1080#1082#1074#1080#1076#1085#1086#1084#1091' '#1090#1086#1074#1072#1088#1091
            Options.Editing = False
            Width = 70
          end
          object NumberSeats: TcxGridDBColumn
            Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1084#1077#1089#1090
            DataBinding.FieldName = 'NumberSeats'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 84
          end
          object isBanFiscalSale: TcxGridDBColumn
            Caption = #1047#1072#1087#1088'. '#1082' '#1092#1080#1089#1082'. '#1087#1088#1086#1076#1072#1078#1077
            DataBinding.FieldName = 'isBanFiscalSale'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1077#1088#1077#1084#1077#1097#1072#1090#1100' '#1090#1086#1074#1072#1088' '#1090#1086#1083#1100#1082#1086' '#1079#1072#1087#1088#1077#1097#1077#1085#1085#1099#1081' '#1082' '#1092#1080#1089#1082#1072#1083#1100#1085#1086#1081' '#1087#1088#1086#1076#1072#1078#1077
            Options.Editing = False
            Width = 60
          end
          object isSendLoss: TcxGridDBColumn
            Caption = #1042' '#1087#1086#1083#1085#1086#1077' '#1089#1087#1080#1089#1072#1085#1080#1077
            DataBinding.FieldName = 'isSendLoss'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 71
          end
          object isSendLossFrom: TcxGridDBColumn
            Caption = #1042' '#1087#1086#1083#1085#1086#1077' '#1089#1087#1080#1089#1072#1085#1080#1077' '#1085#1072' '#1086#1090#1087#1088#1072#1074#1080#1090#1077#1083#1103
            DataBinding.FieldName = 'isSendLossFrom'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 81
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 826
    ExplicitWidth = 826
    inherited deStart: TcxDateEdit
      EditValue = 42005d
    end
    inherited deEnd: TcxDateEdit
      EditValue = 42005d
    end
    object cxLabel3: TcxLabel
      Left = 610
      Top = 6
      Caption = #1044#1072#1090#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072':'
    end
    object deOperDate: TcxDateEdit
      Left = 701
      Top = 5
      EditValue = 42887d
      Properties.DateButtons = [btnClear, btnNow, btnToday]
      Properties.PostPopupValueOnTab = True
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 5
      Width = 80
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 179
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 40
    Top = 203
  end
  inherited ActionList: TActionList
    Left = 31
    Top = 266
    object macUpdateisDeferredNo: TMultiAction [0]
      Category = 'Deferred'
      MoveParams = <>
      ActionList = <
        item
          Action = spUpdateisDeferredNo
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1054#1090#1083#1086#1078#1077#1085' '#1053#1077#1090' '#1042#1057#1045#1052' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084'?'
      Caption = #1054#1090#1083#1086#1078#1077#1085' - '#1053#1077#1090
      Hint = #1054#1090#1083#1086#1078#1077#1085' - '#1053#1077#1090
      ImageIndex = 77
    end
    inherited actInsert: TdsdInsertUpdateAction
      FormName = 'TSendForm'
    end
    inherited actUpdate: TdsdInsertUpdateAction
      FormName = 'TSendForm'
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
        end>
    end
    inherited actComplete: TdsdChangeMovementStatus
      QuestionBeforeExecute = 
        #1042#1053#1048#1052#1040#1053#1048#1045'! '#1042' '#1050#1040#1057#1057#1059' '#1041#1059#1044#1059#1058' '#1047#1040#1043#1056#1059#1046#1045#1053#1067' '#1082#1086#1083'-'#1074#1072' '#1080#1079' '#1082#1086#1083#1086#1085#1082#1080' "'#1050#1086#1083'-'#1074#1086' '#1087#1086#1083#1091 +
        #1095#1072#1090#1077#1083#1103'". '#1055#1056#1054#1042#1045#1056#1068#1058#1045' '#1048#1061'.'
    end
    object actPrint: TdsdPrintAction [17]
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.Component = MasterCDS
          FromParam.ComponentItem = 'Id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'Id'
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100
      Hint = #1055#1077#1095#1072#1090#1100
      ImageIndex = 3
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
        end>
      ReportName = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077
      ReportNameParam.Value = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077
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
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actUpdate_OperDate: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Movement_OperDate
      StoredProcList = <
        item
          StoredProc = spUpdate_Movement_OperDate
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1090#1091' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1090#1091' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 67
    end
    object macUpdateisDeferredYes: TMultiAction
      Category = 'Deferred'
      MoveParams = <>
      ActionList = <
        item
          Action = spUpdateisDeferredYes
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1054#1090#1083#1086#1078#1077#1085' '#1044#1072' '#1042#1057#1045#1052' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084'?'
      Caption = #1054#1090#1083#1086#1078#1077#1085' - '#1044#1072
      Hint = #1054#1090#1083#1086#1078#1077#1085' - '#1044#1072
      ImageIndex = 79
    end
    object macUpdate_OperDate: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_OperDate
        end
        item
          Action = spCompete
        end>
      View = cxGridDBTableView
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1090#1091' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1090#1091' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 67
    end
    object macUpdate_OperDateList: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = macUpdate_OperDate
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1080#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1090#1091' '#1080' '#1087#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090'?'
      InfoAfterExecute = #1044#1072#1090#1072' '#1076#1086#1082#1091#1084#1077#1085#1072' '#1080#1079#1084#1077#1085#1077#1085#1072', '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1087#1088#1086#1074#1077#1076#1077#1085#1099
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1090#1091' '#1080' '#1087#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1090#1091' '#1080' '#1087#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090
      ImageIndex = 67
    end
    object spUpdateisDeferredYes: TdsdExecStoredProc
      Category = 'Deferred'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isDeferred_Yes
      StoredProcList = <
        item
          StoredProc = spUpdate_isDeferred_Yes
        end>
      Caption = #1054#1090#1083#1086#1078#1077#1085' - '#1044#1072
      Hint = #1054#1090#1083#1086#1078#1077#1085' - '#1044#1072
      ImageIndex = 52
    end
    object spUpdateisDeferredNo: TdsdExecStoredProc
      Category = 'Deferred'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isDeferred_No
      StoredProcList = <
        item
          StoredProc = spUpdate_isDeferred_No
        end>
      Caption = #1054#1090#1083#1086#1078#1077#1085' - '#1053#1077#1090
      Hint = #1054#1090#1083#1086#1078#1077#1085' - '#1053#1077#1090
      ImageIndex = 77
    end
    object actUpdate_isSun: TdsdExecStoredProc
      Category = 'Deferred'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isSun
      StoredProcList = <
        item
          StoredProc = spUpdate_isSun
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1086' '#1057#1059#1053' ('#1044#1072'/'#1053#1077#1090')'
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1086' '#1057#1059#1053' ('#1044#1072'/'#1053#1077#1090')'
      ImageIndex = 76
    end
    object actUpdate_isDefSun: TdsdExecStoredProc
      Category = 'Deferred'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isDefSun
      StoredProcList = <
        item
          StoredProc = spUpdate_isDefSun
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1054#1090#1083#1086#1078#1077#1085#1085#1086' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1086' '#1057#1059#1053' ('#1044#1072'/'#1053#1077#1090')'
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1054#1090#1083#1086#1078#1077#1085#1085#1086' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1086' '#1057#1059#1053' ('#1044#1072'/'#1053#1077#1090')'
      ImageIndex = 58
    end
    object actSetReceived: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      ActionList = <
        item
          Action = actExecSetReceived
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1083#1091#1095#1077#1085#1086'-'#1076#1072'"?'
      InfoAfterExecute = #1042#1099#1087#1086#1083#1085#1077#1085#1086
      Caption = #1052#1072#1089#1089#1086#1074#1086#1077' '#1087#1088#1086#1089#1090#1072#1074#1083#1077#1085#1080#1077' '#1087#1088#1080#1079#1085#1072#1082#1072' "'#1055#1086#1083#1091#1095#1077#1085#1086'-'#1076#1072'"'
      Hint = #1052#1072#1089#1089#1086#1074#1086#1077' '#1087#1088#1086#1089#1090#1072#1074#1083#1077#1085#1080#1077'  '#1087#1088#1080#1079#1085#1072#1082#1072' "'#1055#1086#1083#1091#1095#1077#1085#1086'-'#1076#1072'"'
      ImageIndex = 61
    end
    object actExecSetReceived: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Movement_Received
      StoredProcList = <
        item
          StoredProc = spUpdate_Movement_Received
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1083#1091#1095#1077#1085#1086'-'#1076#1072'"'
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1083#1091#1095#1077#1085#1086'-'#1076#1072'"'
    end
    object actSetSent: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      ActionList = <
        item
          Action = actExecSetSent
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1052#1072#1089#1089#1086#1074#1086' '#1087#1088#1086#1089#1090#1072#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' " '#1054#1090#1087#1088#1072#1074#1083#1077#1085#1086'-'#1076#1072'"?'
      InfoAfterExecute = #1042#1099#1087#1086#1083#1085#1077#1085#1086
      Caption = #1052#1072#1089#1089#1086#1074#1086#1077' '#1087#1088#1086#1089#1090#1072#1074#1083#1077#1085#1080#1077' '#1087#1088#1080#1079#1085#1072#1082#1072' " '#1054#1090#1087#1088#1072#1074#1083#1077#1085#1086' -'#1076#1072'"'
      Hint = #1052#1072#1089#1089#1086#1074#1086#1077' '#1087#1088#1086#1089#1090#1072#1074#1083#1077#1085#1080#1077' '#1087#1088#1080#1079#1085#1072#1082#1072' " '#1054#1090#1087#1088#1072#1074#1083#1077#1085#1086' -'#1076#1072'"'
      ImageIndex = 43
    end
    object actExecSetSent: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Movement_Sent
      StoredProcList = <
        item
          StoredProc = spUpdate_Movement_Sent
        end>
      Caption = 'actExecSetSent'
    end
    object actUnCompleteView: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      ActionList = <
        item
          Action = actExecUnCompleteView
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = 
        #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' '#1085#1077' '#1087#1088#1086#1074#1077#1076#1077#1085' '#1085#1072' '#1074#1089#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103' '#1087#1086#1076' ' +
        #1092#1080#1083#1100#1090#1088#1086#1084'?'
      InfoAfterExecute = #1042#1099#1087#1086#1083#1085#1077#1085#1086
      Caption = 
        #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' '#1085#1077' '#1087#1088#1086#1074#1077#1076#1077#1085' '#1085#1072' '#1074#1089#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103' '#1087#1086#1076' ' +
        #1092#1080#1083#1100#1090#1088#1086#1084
      Hint = 
        #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' '#1085#1077' '#1087#1088#1086#1074#1077#1076#1077#1085' '#1085#1072' '#1074#1089#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103' '#1087#1086#1076' ' +
        #1092#1080#1083#1100#1090#1088#1086#1084
      ImageIndex = 10
    end
    object actExecUnCompleteView: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUnCompleteView
      StoredProcList = <
        item
          StoredProc = spUnCompleteView
        end>
      Caption = 'actExecUnCompleteView'
    end
    object actUpdate_NotDisplaySUN_Yes: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      ActionList = <
        item
          Action = actExecUpdate_NotDisplaySUN_Yes
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1053#1077' '#1086#1090#1086#1073#1088#1072#1078#1072#1090#1100' '#1076#1083#1103' '#1089#1073#1086#1088#1072' '#1057#1059#1053'"?'
      InfoAfterExecute = #1042#1099#1087#1086#1083#1085#1077#1085#1086
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1053#1077' '#1086#1090#1086#1073#1088#1072#1078#1072#1090#1100' '#1076#1083#1103' '#1089#1073#1086#1088#1072' '#1057#1059#1053'"'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1053#1077' '#1086#1090#1086#1073#1088#1072#1078#1072#1090#1100' '#1076#1083#1103' '#1089#1073#1086#1088#1072' '#1057#1059#1053'"'
      ImageIndex = 44
    end
    object actExecUpdate_NotDisplaySUN_Yes: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_NotDisplaySUN_Yes
      StoredProcList = <
        item
          StoredProc = spUpdate_NotDisplaySUN_Yes
        end>
      Caption = 'actExecUpdate_NotDisplaySUN_Yes'
    end
    object actCompileFilter: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      ActionList = <
        item
          Action = actExecComplete_Filter
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1055#1088#1086#1074#1077#1089#1090#1080' '#1074#1089#1077' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1087#1086#1076' '#1092#1080#1083#1100#1090#1088#1086#1084'?'
      Caption = #1055#1088#1086#1074#1077#1089#1090#1080' '#1074#1089#1077' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1087#1086#1076' '#1092#1080#1083#1100#1090#1088#1086#1084
      Hint = #1055#1088#1086#1074#1077#1089#1090#1080' '#1074#1089#1077' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1087#1086#1076' '#1092#1080#1083#1100#1090#1088#1086#1084
      ImageIndex = 66
    end
    object actExecComplete_Filter: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spComplete_Filter
      StoredProcList = <
        item
          StoredProc = spComplete_Filter
        end>
      Caption = 'actExecComplete_Filter'
    end
    object actSetErasedFilter: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      ActionList = <
        item
          Action = actExecSetErased_Filter
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1059#1076#1072#1083#1080#1090#1100' '#1074#1089#1077' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1087#1086#1076' '#1092#1080#1083#1100#1090#1088#1086#1084'?'
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1074#1089#1077' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1087#1086#1076' '#1092#1080#1083#1100#1090#1088#1086#1084
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1074#1089#1077' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1087#1086#1076' '#1092#1080#1083#1100#1090#1088#1086#1084
      ImageIndex = 13
    end
    object actExecSetErased_Filter: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSetErased_Filter
      StoredProcList = <
        item
          StoredProc = spSetErased_Filter
        end>
      Caption = 'actExecSetErased_Filter'
    end
    object macSetDriverSun: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      BeforeAction = actOpenChoiceDriverSun
      ActionList = <
        item
          Action = actExecSPDriverSun
        end>
      View = cxGridDBTableView
      Caption = #1084#1072#1089#1089#1086#1074#1086#1077' '#1087#1088#1086#1089#1090#1072#1074#1083#1077#1085#1080#1077' "'#1042#1086#1076#1080#1090#1077#1083#1103' '#1087#1086#1083#1091#1095#1080#1074#1096#1077#1075#1086' '#1090#1086#1074#1072#1088'"'
      Hint = #1084#1072#1089#1089#1086#1074#1086#1077' '#1087#1088#1086#1089#1090#1072#1074#1083#1077#1085#1080#1077' "'#1042#1086#1076#1080#1090#1077#1083#1103' '#1087#1086#1083#1091#1095#1080#1074#1096#1077#1075#1086' '#1090#1086#1074#1072#1088'"'
      ImageIndex = 55
    end
    object actOpenChoiceDriverSun: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actOpenChoiceDriverSun'
      FormName = 'TDriverSunForm'
      FormNameParam.Value = 'TDriverSunForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = FormParams
          ComponentItem = 'DriverSunId'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actExecSPDriverSun: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Movement_DriverSun
      StoredProcList = <
        item
          StoredProc = spUpdate_Movement_DriverSun
        end>
      Caption = 'actExecSPDriverSun'
    end
    object actPrintFilter: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.Component = MasterCDS
          FromParam.ComponentItem = 'Id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'Id'
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1087#1086#1076' '#1092#1080#1083#1100#1090#1088#1086#1084
      Hint = #1055#1077#1095#1072#1090#1100' '#1087#1086#1076' '#1092#1080#1083#1100#1090#1088#1086#1084
      ImageIndex = 3
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
          Name = 'frxPDFExport_find'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'frxPDFExport1_ShowDialog'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'ExportDirectory'
          Value = Null
          Component = FormParams
          ComponentItem = 'FileDirectory'
          MultiSelectSeparator = ','
        end
        item
          Name = 'FileNameExport'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InvNumber'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PrefixFileNameExport'
          Value = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' - '
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077
      ReportNameParam.Value = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object macPrintFilter: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      BeforeAction = actDirectoryDialog
      ActionList = <
        item
          Action = actPrintFilter
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1100' '#1101#1082#1089#1087#1086#1088#1090' '#1074#1089#1077#1093' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1081' '#1074' PDF?'
      InfoAfterExecute = #1042#1099#1087#1086#1083#1085#1077#1085#1086
      Caption = #1069#1082#1089#1087#1086#1088#1090' '#1074#1089#1077#1093' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1081' '#1074' PDF'
      Hint = #1069#1082#1089#1087#1086#1088#1090' '#1074#1089#1077#1093' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1081' '#1074' PDF'
      ImageIndex = 21
    end
    object actDirectoryDialog: TFileDialogAction
      Category = 'DSDLib'
      MoveParams = <>
      FileOpenDialog.FavoriteLinks = <>
      FileOpenDialog.FileTypes = <>
      FileOpenDialog.Options = [fdoPickFolders]
      Param.Value = Null
      Param.Component = FormParams
      Param.ComponentItem = 'FileDirectory'
      Param.DataType = ftString
      Param.MultiSelectSeparator = ','
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
    StoredProcName = 'gpSelect_Movement_Send'
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
      end
      item
        Name = 'inisVip'
        Value = False
        Component = FormParams
        ComponentItem = 'inisVip'
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
          ItemName = 'bbInsert'
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
          ItemName = 'bbMovementItemContainer'
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
          ItemName = 'bbUpdate_OperDateList'
        end
        item
          Visible = True
          ItemName = 'dxBarButton5'
        end
        item
          Visible = True
          ItemName = 'dxBarButton6'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbDeferredYes'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbDeferredNo'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_isSun'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_isDefSun'
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
          ItemName = 'bbSetSent'
        end
        item
          Visible = True
          ItemName = 'bbSetReceived'
        end
        item
          Visible = True
          ItemName = 'bbSetDriverSun'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton3'
        end
        item
          Visible = True
          ItemName = 'dxBarButton4'
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
        end
        item
          Visible = True
          ItemName = 'bbPrintFilter'
        end>
    end
    inherited dxBarStatic: TdxBarStatic
      Width = 15
    end
    object bbPrint: TdxBarButton
      Action = actPrint
      Category = 0
    end
    object bbUpdate_OperDateList: TdxBarButton
      Action = macUpdate_OperDateList
      Category = 0
    end
    object bbDeferredYes: TdxBarButton
      Action = macUpdateisDeferredYes
      Category = 0
    end
    object bbDeferredNo: TdxBarButton
      Action = macUpdateisDeferredNo
      Category = 0
      ImageIndex = 52
    end
    object bbSetReceived: TdxBarButton
      Action = actSetReceived
      Category = 0
    end
    object bbSetSent: TdxBarButton
      Action = actSetSent
      Category = 0
    end
    object bbUpdate_isDefSun: TdxBarButton
      Action = actUpdate_isDefSun
      Category = 0
    end
    object bbUpdate_isSun: TdxBarButton
      Action = actUpdate_isSun
      Category = 0
    end
    object dxBarButton3: TdxBarButton
      Action = actUnCompleteView
      Category = 0
    end
    object dxBarButton4: TdxBarButton
      Action = actUpdate_NotDisplaySUN_Yes
      Category = 0
    end
    object dxBarButton5: TdxBarButton
      Action = actCompileFilter
      Category = 0
    end
    object dxBarButton6: TdxBarButton
      Action = actSetErasedFilter
      Category = 0
    end
    object bbSetDriverSun: TdxBarButton
      Action = macSetDriverSun
      Category = 0
    end
    object bbPrintFilter: TdxBarButton
      Action = macPrintFilter
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 320
    Top = 224
  end
  inherited PopupMenu: TPopupMenu
    Left = 640
    Top = 152
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
      end>
    Left = 408
    Top = 256
  end
  inherited spMovementComplete: TdsdStoredProc
    StoredProcName = 'gpComplete_Movement_Send'
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
        Name = 'inIsCurrentData'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outOperDate'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'OperDate'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    Left = 80
    Top = 320
  end
  inherited spMovementUnComplete: TdsdStoredProc
    StoredProcName = 'gpUnComplete_Movement_Send'
    Params = <
      item
        Name = 'inmovementid'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 80
    Top = 384
  end
  inherited spMovementSetErased: TdsdStoredProc
    StoredProcName = 'gpSetErased_Movement_Send'
    Params = <
      item
        Name = 'inmovementid'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 208
    Top = 376
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
        Name = 'ReportNameSend'
        Value = Null
        DataType = ftString
        ParamType = ptInput
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
        Name = 'inisVip'
        Value = False
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'DriverSunId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'FileDirectory'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 400
    Top = 200
  end
  inherited spMovementReComplete: TdsdStoredProc
    StoredProcName = 'gpReComplete_Movement_Send'
    Left = 496
    Top = 184
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
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 535
    Top = 248
  end
  object PrintItemsSverkaCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 628
    Top = 294
  end
  object spUpdate_Movement_OperDate: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_OperDate'
    DataSets = <>
    OutputType = otResult
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
        Name = 'inOperDate'
        Value = 42887d
        Component = deOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 568
    Top = 347
  end
  object spUpdate_isDeferred_No: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Send_Deferred'
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
        Name = 'inisDeferred'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisDeferred'
        Value = False
        Component = MasterCDS
        ComponentItem = 'isDeferred'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 312
    Top = 435
  end
  object spUpdate_isDeferred_Yes: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Send_Deferred'
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
        Name = 'inisDeferred'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisDeferred'
        Value = False
        Component = MasterCDS
        ComponentItem = 'isDeferred'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 400
    Top = 443
  end
  object spUpdate_Movement_Received: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_ReceivedList'
    DataSets = <>
    OutputType = otResult
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
        Name = 'inisReceived'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isReceived'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 720
    Top = 323
  end
  object spUpdate_Movement_Sent: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_SentList'
    DataSets = <>
    OutputType = otResult
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
        Name = 'inisSent'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSent'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 720
    Top = 371
  end
  object spUpdate_isDefSun: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Send_isDefSUN'
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
        Name = 'inisDefSUN'
        Value = False
        Component = MasterCDS
        ComponentItem = 'isDefSUN'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisDefSUN'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isDefSUN'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 320
    Top = 355
  end
  object spUpdate_isSun: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Send_isSUN'
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
        Name = 'inisSUN'
        Value = True
        Component = MasterCDS
        ComponentItem = 'isSUN'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisSUN'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSUN'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 408
    Top = 339
  end
  object spUnCompleteView: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Send_UnCompleteView'
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
      end>
    PackSize = 1
    Left = 528
    Top = 403
  end
  object spUpdate_NotDisplaySUN_Yes: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_NotDisplaySUN'
    DataSets = <>
    OutputType = otResult
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
        Name = 'inisNotDisplaySUN'
        Value = False
        Component = MasterCDS
        ComponentItem = 'isNotDisplaySUN'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 72
    Top = 443
  end
  object spComplete_Filter: TdsdStoredProc
    StoredProcName = 'gpComplete_Movement_Send_Filter'
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
      end>
    PackSize = 1
    Left = 528
    Top = 451
  end
  object spSetErased_Filter: TdsdStoredProc
    StoredProcName = 'gpSetErased_Movement_Send_Filter'
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
      end>
    PackSize = 1
    Left = 600
    Top = 451
  end
  object spUpdate_Movement_DriverSun: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_DriverSun'
    DataSets = <>
    OutputType = otResult
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
        Name = 'inDriverSunId'
        Value = Null
        Component = FormParams
        ComponentItem = 'DriverSunId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 720
    Top = 403
  end
end
