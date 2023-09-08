inherited MemberHolidayJournalForm: TMemberHolidayJournalForm
  Caption = #1046#1091#1088#1085#1072#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' <'#1055#1088#1080#1082#1072#1079#1099' '#1087#1086' '#1086#1090#1087#1091#1089#1082#1072#1084'>'
  ClientHeight = 537
  ClientWidth = 975
  AddOnFormData.RefreshAction = actRefreshStart
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 991
  ExplicitHeight = 576
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 975
    Height = 480
    TabOrder = 3
    ExplicitWidth = 975
    ExplicitHeight = 480
    ClientRectBottom = 480
    ClientRectRight = 975
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 975
      ExplicitHeight = 480
      inherited cxGrid: TcxGrid
        Width = 975
        Height = 480
        ExplicitWidth = 975
        ExplicitHeight = 480
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Filter.Options = [fcoCaseInsensitive, fcoShowOperatorDescription]
          DataController.Filter.TranslateBetween = True
          DataController.Filter.TranslateIn = True
          DataController.Filter.TranslateLike = True
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
              Column = Day_holiday
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummHoliday1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummHoliday2
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummHoliday
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummHoliday_calc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Day_holiday2
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Day_holiday1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Day_holiday1_calc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Day_holiday2_calc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummHoliday1_calc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummHoliday2_calc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_diff
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Day_holiday
            end
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = colInvNumber
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummHoliday1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummHoliday2
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummHoliday
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummHoliday_calc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Day_holiday2
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Day_holiday1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Day_holiday1_calc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Day_holiday2_calc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummHoliday1_calc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummHoliday2_calc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_diff
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
            HeaderAlignmentHorz = taCenter
            Width = 55
          end
          inherited colOperDate: TcxGridDBColumn [1]
            HeaderAlignmentHorz = taCenter
            Width = 60
          end
          inherited colInvNumber: TcxGridDBColumn [2]
            Caption = #8470' '#1076#1086#1082'.'
            HeaderAlignmentHorz = taCenter
            Width = 92
          end
          object OperDateStart: TcxGridDBColumn
            Caption = #1053#1072#1095'. '#1076#1072#1090#1072' '#1088#1072#1073'. '#1087#1077#1088#1080#1086#1076#1072
            DataBinding.FieldName = 'OperDateStart'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1053#1072#1095'. '#1076#1072#1090#1072' '#1088#1072#1073#1086#1095#1077#1075#1086' '#1087#1077#1088#1080#1086#1076#1072
            Width = 99
          end
          object OperDateEnd: TcxGridDBColumn
            Caption = #1050#1086#1085#1077#1095#1085'. '#1076#1072#1090#1072' '#1088#1072#1073'. '#1087#1077#1088#1080#1086#1076#1072
            DataBinding.FieldName = 'OperDateEnd'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1085#1077#1095#1085'. '#1076#1072#1090#1072' '#1088#1072#1073#1086#1095#1077#1075#1086' '#1087#1077#1088#1080#1086#1076#1072
            Width = 90
          end
          object Day_work: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1076#1085'. '#1088'.'
            DataBinding.FieldName = 'Day_work'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1076#1085#1077#1081' ('#1056#1072#1073#1086#1095#1080#1081' '#1087#1077#1088#1080#1086#1076')'
            Options.Editing = False
            Width = 80
          end
          object BeginDateStart: TcxGridDBColumn
            Caption = #1053#1072#1095'. '#1076#1072#1090#1072' '#1086#1090#1087#1091#1089#1082#1072
            DataBinding.FieldName = 'BeginDateStart'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object BeginDateEnd: TcxGridDBColumn
            Caption = #1050#1086#1085#1077#1095#1085'. '#1076#1072#1090#1072' '#1086#1090#1087#1091#1089#1082#1072
            DataBinding.FieldName = 'BeginDateEnd'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 87
          end
          object Day_holiday: TcxGridDBColumn
            Caption = #1054#1090#1087#1091#1089#1082', '#1076#1085#1077#1081
            DataBinding.FieldName = 'Day_holiday'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1076#1085#1077#1081' ('#1054#1090#1087#1091#1089#1082')'
            Options.Editing = False
            Width = 80
          end
          object WorkTimeKindName: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1086#1090#1087#1091#1089#1082#1072
            DataBinding.FieldName = 'WorkTimeKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object isLoad: TcxGridDBColumn
            Caption = #1054#1090#1087#1091#1089#1082' '#1079#1072#1087#1086#1083#1085#1077#1085
            DataBinding.FieldName = 'isLoad'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = 
              #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1072' '#1082#1086#1083#1086#1085#1082#1072' <'#1054#1090#1087#1091#1089#1082#1085#1099#1077'> '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090#1077'  <'#1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077 +
              #1085#1080#1103' '#1079#1072#1088#1087#1083#1072#1090#1099'>'
            Options.Editing = False
            Width = 70
          end
          object Day_holiday1: TcxGridDBColumn
            Caption = #1054#1087#1083'. '#1076#1085'. (1-'#1087#1077#1088#1080#1086#1076')'
            DataBinding.FieldName = 'Day_holiday1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1087#1083#1072#1095#1077#1085#1086' '#1076#1085#1077#1081' '#1086#1090#1087#1091#1089#1082#1072' ('#1087#1077#1088#1074#1099#1081' '#1087#1077#1088#1080#1086#1076')'
            Options.Editing = False
            Width = 75
          end
          object Day_holiday2: TcxGridDBColumn
            Caption = #1054#1087#1083'. '#1076#1085#1077#1081' (2-'#1087#1077#1088#1080#1086#1076')'
            DataBinding.FieldName = 'Day_holiday2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1087#1083#1072#1095#1077#1085#1086' '#1076#1085#1077#1081' '#1086#1090#1087#1091#1089#1082#1072' ('#1074#1090#1086#1088#1086#1081' '#1087#1077#1088#1080#1086#1076')'
            Options.Editing = False
            Width = 75
          end
          object Day_holiday1_calc: TcxGridDBColumn
            Caption = #1056#1072#1089#1095'. '#1076#1085'. (1-'#1087#1077#1088#1080#1086#1076')'
            DataBinding.FieldName = 'Day_holiday1_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1095#1077#1090' '#1076#1085#1077#1081' '#1086#1090#1087#1091#1089#1082#1072' ('#1087#1077#1088#1074#1099#1081' '#1087#1077#1088#1080#1086#1076')'
            Width = 70
          end
          object Day_holiday2_calc: TcxGridDBColumn
            Caption = #1056#1072#1089#1095'. '#1076#1085'. (2-'#1087#1077#1088#1080#1086#1076')'
            DataBinding.FieldName = 'Day_holiday2_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1095#1077#1090' '#1076#1085#1077#1081' '#1086#1090#1087#1091#1089#1082#1072' ('#1074#1090#1086#1088#1086#1081' '#1087#1077#1088#1080#1086#1076')'
            Width = 70
          end
          object SummHoliday1: TcxGridDBColumn
            Caption = #1054#1090#1087#1091#1089#1082#1085#1099#1077' (1-'#1087#1077#1088#1080#1086#1076')'
            DataBinding.FieldName = 'SummHoliday1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1087#1083#1072#1095#1077#1085#1085#1072#1103' '#1089#1091#1084#1084#1072' '#1086#1090#1087#1091#1089#1082#1085#1099#1093' ('#1087#1077#1088#1074#1099#1081' '#1087#1077#1088#1080#1086#1076')'
            Width = 77
          end
          object SummHoliday2: TcxGridDBColumn
            Caption = #1054#1090#1087#1091#1089#1082#1085#1099#1077' (2-'#1087#1077#1088#1080#1086#1076')'
            DataBinding.FieldName = 'SummHoliday2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1087#1083#1072#1095#1077#1085#1085#1072#1103' '#1089#1091#1084#1084#1072' '#1086#1090#1087#1091#1089#1082#1085#1099#1093' ('#1074#1090#1086#1088#1086#1081' '#1087#1077#1088#1080#1086#1076')'
            Width = 74
          end
          object TotalSummHoliday: TcxGridDBColumn
            Caption = #1054#1090#1087#1091#1089#1082#1085#1099#1077' '#1048#1090#1086#1075#1086
            DataBinding.FieldName = 'TotalSummHoliday'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1087#1083#1072#1095#1077#1085#1085#1072#1103' '#1089#1091#1084#1084#1072' '#1086#1090#1087#1091#1089#1082#1085#1099#1093' '#1048#1090#1086#1075#1086
            Width = 84
          end
          object SummHoliday1_calc: TcxGridDBColumn
            Caption = '***'#1054#1090#1087#1091#1089#1082#1085#1099#1077' (1-'#1087#1077#1088#1080#1086#1076')'
            DataBinding.FieldName = 'SummHoliday1_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1095#1077#1090#1085#1072#1103' '#1089#1091#1084#1084#1072' '#1086#1090#1087#1091#1089#1082#1085#1099#1093' ('#1087#1077#1088#1074#1099#1081' '#1087#1077#1088#1080#1086#1076')'
            Width = 70
          end
          object SummHoliday2_calc: TcxGridDBColumn
            Caption = '***'#1054#1090#1087#1091#1089#1082#1085#1099#1077' (2-'#1087#1077#1088#1080#1086#1076')'
            DataBinding.FieldName = 'SummHoliday2_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1095#1077#1090#1085#1072#1103' '#1089#1091#1084#1084#1072' '#1086#1090#1087#1091#1089#1082#1085#1099#1093' ('#1074#1090#1086#1088#1086#1081' '#1087#1077#1088#1080#1086#1076')'
            Width = 70
          end
          object TotalSummHoliday_calc: TcxGridDBColumn
            Caption = #1054#1090#1087#1091#1089#1082#1085#1099#1077' ('#1088#1072#1089#1095#1077#1090')'
            DataBinding.FieldName = 'TotalSummHoliday_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1095#1077#1090#1085#1072#1103' '#1089#1091#1084#1084#1072' '#1086#1090#1087#1091#1089#1082#1085#1099#1093' ('#1048#1090#1086#1075#1086')'
            Width = 74
          end
          object Summ_diff: TcxGridDBColumn
            Caption = #1056#1072#1079#1085#1080#1094#1072
            DataBinding.FieldName = 'Summ_diff'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1060#1072#1082#1090' "'#1084#1080#1085#1091#1089'" '#1056#1074#1089#1095#1077#1090
            Width = 74
          end
          object PersonalServiceListName: TcxGridDBColumn
            Caption = #1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103' ('#1075#1083#1072#1074#1085'.)'
            DataBinding.FieldName = 'PersonalServiceListName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103'('#1075#1083#1072#1074#1085#1072#1103')'
            Options.Editing = False
            Width = 130
          end
          object InvNumber_Full1: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082' '#1053#1072#1095'. '#1079#1087' (1-'#1087#1077#1088#1080#1086#1076')'
            DataBinding.FieldName = 'InvNumber_Full1'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #8470' '#1076#1086#1082' '#1053#1072#1095#1080#1089#1083#1077#1085#1080#1077' '#1079#1072#1088#1087#1083#1072#1090#1099'('#1087#1077#1088#1074#1099#1081' '#1087#1077#1088#1080#1086#1076')'
            Options.Editing = False
            Width = 100
          end
          object InvNumber_Full2: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082' '#1053#1072#1095'. '#1079#1087' (2-'#1087#1077#1088#1080#1086#1076')'
            DataBinding.FieldName = 'InvNumber_Full2'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #8470' '#1076#1086#1082' '#1053#1072#1095#1080#1089#1083#1077#1085#1080#1077' '#1079#1072#1088#1087#1083#1072#1090#1099'('#1074#1090#1086#1088#1086#1081' '#1087#1077#1088#1080#1086#1076')'
            Options.Editing = False
            Width = 100
          end
          object Amount: TcxGridDBColumn
            Caption = #1057#1088'.'#1047#1055' '#1079#1072' '#1076#1077#1085#1100
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 74
          end
          object UnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072
            Options.Editing = False
            Width = 106
          end
          object PositionName: TcxGridDBColumn
            Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
            DataBinding.FieldName = 'PositionName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1083#1078#1085#1086#1089#1090#1100' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072
            Options.Editing = False
            Width = 90
          end
          object MemberName: TcxGridDBColumn
            Caption = #1060#1048#1054' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072
            DataBinding.FieldName = 'MemberName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 102
          end
          object MemberMainName: TcxGridDBColumn
            Caption = #1060#1048#1054' '#1088#1091#1082#1086#1074#1086#1076#1080#1090#1077#1083#1103
            DataBinding.FieldName = 'MemberMainName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 147
          end
          object DateIn: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1087#1088#1080#1077#1084#1072
            DataBinding.FieldName = 'DateIn'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object DateOut: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1091#1074#1086#1083#1100#1085#1077#1085#1080#1103
            DataBinding.FieldName = 'DateOut'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 85
          end
          object InsertName: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076'.)'
            DataBinding.FieldName = 'InsertName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 101
          end
          object InsertDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' ('#1089#1086#1079#1076'.)'
            DataBinding.FieldName = 'InsertDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 78
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
          object Color_SummHoliday: TcxGridDBColumn
            DataBinding.FieldName = 'Color_SummHoliday'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            VisibleForCustomization = False
            Width = 70
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 975
    ExplicitWidth = 975
    inherited deStart: TcxDateEdit
      EditValue = 44927d
    end
    inherited deEnd: TcxDateEdit
      EditValue = 44927d
    end
  end
  object cxLabel27: TcxLabel [2]
    Left = 722
    Top = 6
    Caption = #1055#1088#1077#1076#1087#1088#1080#1103#1090#1080#1077':'
  end
  object edJuridicalBasis: TcxButtonEdit [3]
    Left = 800
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
    Left = 179
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 40
    Top = 243
  end
  inherited ActionList: TActionList
    Left = 23
    Top = 194
    inherited actMovementItemContainer: TdsdOpenForm
      Enabled = False
    end
    inherited actInsert: TdsdInsertUpdateAction
      FormName = 'TMemberHolidayForm'
      FormNameParam.Value = 'TMemberHolidayForm'
      GuiParams = <
        item
          Name = 'Id'
          Value = 0
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
    end
    inherited actUpdate: TdsdInsertUpdateAction
      FormName = 'TMemberHolidayForm'
      FormNameParam.Value = 'TMemberHolidayForm'
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDate'
          Value = 41640d
          Component = MasterCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
    end
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.Component = MasterCDS
          FromParam.ComponentItem = 'id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProc = spSelectPrint_Spec
      StoredProcList = <
        item
          StoredProc = spSelectPrint_Spec
        end>
      Caption = #1055#1088#1080#1082#1072#1079' '#1085#1072' '#1086#1090#1087#1091#1089#1082
      Hint = #1055#1088#1080#1082#1072#1079' '#1085#1072' '#1086#1090#1087#1091#1089#1082
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_MemberHoliday'
      ReportNameParam.Value = 'PrintMovement_MemberHoliday'
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
    object actOpenFormMemberHolidayEdit: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1087#1083#1072#1090#1080#1090#1100
      Hint = #1054#1087#1083#1072#1090#1080#1090#1100
      ImageIndex = 56
      FormName = 'TMemberHolidayEditForm'
      FormNameParam.Value = 'TMemberHolidayEditForm'
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
          Name = 'OperDate'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
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
  end
  inherited MasterDS: TDataSource
    Left = 64
    Top = 139
  end
  inherited MasterCDS: TClientDataSet
    Top = 139
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_MemberHoliday'
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
        Name = 'inJuridicalBasisId'
        Value = Null
        Component = JuridicalBasisGuides
        ComponentItem = 'Key'
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
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbOpenFormMemberHolidayEdit'
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
    object bbTax: TdxBarButton
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1085#1072#1083#1086#1075#1086#1074#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090
      Category = 0
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1085#1072#1083#1086#1075#1086#1074#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090
      Visible = ivNever
      ImageIndex = 41
    end
    object bbPrint: TdxBarButton
      Action = actPrint
      Category = 0
    end
    object bbPrintTax_Us: TdxBarButton
      Caption = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' ('#1087#1088#1086#1076#1072#1074#1077#1094')'
      Category = 0
      Hint = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' ('#1087#1088#1086#1076#1072#1074#1077#1094')'
      Visible = ivAlways
      ImageIndex = 16
    end
    object bbPrintTax_Client: TdxBarButton
      Caption = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' ('#1087#1086#1082#1091#1087#1072#1090#1077#1083#1100')'
      Category = 0
      Hint = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' ('#1087#1086#1082#1091#1087#1072#1090#1077#1083#1100')'
      Visible = ivAlways
      ImageIndex = 18
    end
    object bbPrint_Bill: TdxBarButton
      Caption = #1057#1095#1077#1090
      Category = 0
      Hint = #1057#1095#1077#1090
      Visible = ivAlways
      ImageIndex = 21
    end
    object bbOpenFormMemberHolidayEdit: TdxBarButton
      Action = actOpenFormMemberHolidayEdit
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    ColorRuleList = <
      item
        ColorColumn = SummHoliday1
        BackGroundValueColumn = Color_SummHoliday
        ColorValueList = <>
      end
      item
        ColorColumn = SummHoliday2
        BackGroundValueColumn = Color_SummHoliday
        ColorValueList = <>
      end>
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
        Component = JuridicalBasisGuides
      end>
    Left = 408
    Top = 344
  end
  inherited spMovementComplete: TdsdStoredProc
    StoredProcName = 'gpComplete_Movement_MemberHoliday'
    Left = 80
    Top = 320
  end
  inherited spMovementUnComplete: TdsdStoredProc
    StoredProcName = 'gpUnComplete_Movement_MemberHoliday'
    Left = 80
    Top = 384
  end
  inherited spMovementSetErased: TdsdStoredProc
    StoredProcName = 'gpSetErased_Movement_MemberHoliday'
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
        Name = 'ReportNameLoss'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameLossTax'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 400
    Top = 200
  end
  inherited spMovementReComplete: TdsdStoredProc
    StoredProcName = 'gpReComplete_Movement_MemberHoliday'
    Left = 176
    Top = 304
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    MasterSource = MasterDS
    PacketRecords = 0
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
    StoredProcName = 'gpSelect_Movement_MemberHoliday_Print'
    DataSet = PrintItemsCDS
    DataSets = <
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
    Left = 807
    Top = 8
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
  object spSelectPrint_Spec: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_MemberHoliday_Print'
    DataSet = PrintItemsCDS
    DataSets = <
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
    Left = 647
    Top = 360
  end
end
