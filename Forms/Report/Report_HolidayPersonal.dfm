object Report_HolidayPersonalForm: TReport_HolidayPersonalForm
  Left = 0
  Top = 0
  Caption = #1054#1090#1095#1077#1090' <'#1055#1086' '#1086#1090#1087#1091#1089#1082#1072#1084'>'
  ClientHeight = 496
  ClientWidth = 915
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = actRefresh
  AddOnFormData.isSingle = False
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid: TcxGrid
    Left = 0
    Top = 91
    Width = 915
    Height = 405
    Align = alClient
    TabOrder = 0
    object cxGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = MasterDS
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Filter.Active = True
      DataController.Summary.DefaultGroupSummaryItems = <
        item
          Format = ',0.##'
          Kind = skSum
          Column = Day_holiday
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = Day_diff
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = Day_vacation
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = Day_calendar
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = Day_real
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = Day_Hol
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = Day_hol_NoZp
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = Day_holiday_NoZp
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = Day_vacation_NoZp
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = Day_diff_NoZp
        end>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = ',0.##'
          Kind = skSum
          Column = Day_holiday
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = Day_diff
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = Day_vacation
        end
        item
          Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
          Kind = skCount
          Column = PersonalName
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = Day_calendar
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = Day_real
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = Day_Hol
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = Day_hol_NoZp
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = Day_holiday_NoZp
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = Day_vacation_NoZp
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = Day_diff_NoZp
        end>
      DataController.Summary.SummaryGroups = <>
      Images = dmMain.SortImageList
      OptionsBehavior.GoToNextCellOnEnter = True
      OptionsBehavior.FocusCellOnCycle = True
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsCustomize.DataRowSizing = True
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsView.Footer = True
      OptionsView.GroupSummaryLayout = gslAlignWithColumns
      OptionsView.HeaderAutoHeight = True
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object BranchName: TcxGridDBColumn
        Caption = #1060#1080#1083#1080#1072#1083
        DataBinding.FieldName = 'BranchName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object UnitName: TcxGridDBColumn
        Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
        DataBinding.FieldName = 'UnitName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object PersonalCode: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'PersonalCode'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 40
      end
      object PersonalName: TcxGridDBColumn
        Caption = #1060#1048#1054
        DataBinding.FieldName = 'PersonalName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 169
      end
      object PositionName: TcxGridDBColumn
        Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
        DataBinding.FieldName = 'PositionName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 180
      end
      object PersonalServiceListName: TcxGridDBColumn
        Caption = #1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103' ('#1075#1083#1072#1074#1085#1072#1103')'
        DataBinding.FieldName = 'PersonalServiceListName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 111
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
      object IsDateOut: TcxGridDBColumn
        Caption = #1059#1074#1086#1083#1077#1085
        DataBinding.FieldName = 'isDateOut'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object IsMain: TcxGridDBColumn
        Caption = #1054#1089#1085#1086#1074#1085#1086#1077' '#1084#1077#1089#1090#1086' '#1088'.'
        DataBinding.FieldName = 'isMain'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object IsOfficial: TcxGridDBColumn
        Caption = #1054#1092#1086#1088#1084#1083#1077#1085' '#1086#1092#1080#1094#1080#1072#1083#1100#1085#1086
        DataBinding.FieldName = 'isOfficial'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object isNotCompensation: TcxGridDBColumn
        Caption = #1048#1089#1082#1083'. '#1080#1079' '#1082#1086#1084#1087#1077#1085#1089'.'
        DataBinding.FieldName = 'isNotCompensation'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1048#1089#1082#1083#1102#1095#1080#1090#1100' '#1080#1079' '#1082#1086#1084#1087#1077#1085#1089#1072#1094#1080#1080' '#1086#1090#1087#1091#1089#1082#1072
        Options.Editing = False
        Width = 70
      end
      object PositionName_old: TcxGridDBColumn
        Caption = #1055#1088#1077#1076#1099#1076#1091#1097#1072#1103' '#1076#1086#1083#1078#1085#1086#1089#1090#1100' '
        DataBinding.FieldName = 'PositionName_old'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 180
      end
      object Month_work: TcxGridDBColumn
        Caption = #1042#1089#1077#1075#1086' '#1086#1090#1088'. '#1084#1077#1089#1103#1094#1077#1074
        DataBinding.FieldName = 'Month_work'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.##;-,0.##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1042#1089#1077#1075#1086' '#1086#1090#1088#1072#1073#1086#1090#1072#1085#1086' '#1084#1077#1089#1103#1094#1077#1074
        Options.Editing = False
        Width = 80
      end
      object Day_vacation: TcxGridDBColumn
        Caption = #1055#1086#1083#1086#1078#1077#1085' '#1086#1090#1087#1091#1089#1082', '#1076#1085#1077#1081
        DataBinding.FieldName = 'Day_vacation'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.##;-,0.##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1055#1086#1083#1086#1078#1077#1085#1085#1086' '#1076#1085#1077#1081' '#1086#1090#1087#1091#1089#1082#1072' - '#1079#1072' '#1087#1077#1088#1080#1086#1076
        Options.Editing = False
        Width = 80
      end
      object Day_holiday: TcxGridDBColumn
        Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1085#1086', '#1076#1085#1077#1081
        DataBinding.FieldName = 'Day_holiday'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.##;-,0.##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1085#1086', '#1076#1085#1077#1081' - '#1079#1072' '#1087#1077#1088#1080#1086#1076
        Options.Editing = False
        Width = 80
      end
      object Day_holiday_NoZp: TcxGridDBColumn
        Caption = #1041#1077#1079' '#1089#1086#1093#1088'. '#1079#1087', '#1076#1085#1077#1081
        DataBinding.FieldName = 'Day_holiday_NoZp'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.##;-,0.##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1054#1090#1087#1091#1089#1082' '#1073#1077#1079' '#1089#1086#1093#1088#1072#1085#1077#1085#1080#1103' '#1047#1055', '#1076#1085#1077#1081' - '#1079#1072' '#1087#1077#1088#1080#1086#1076
        Options.Editing = False
        Width = 80
      end
      object Day_diff: TcxGridDBColumn
        Caption = #1053#1077#1080#1089#1087#1086#1083#1100#1079#1086#1074#1072#1085#1086', '#1076#1085#1077#1081
        DataBinding.FieldName = 'Day_diff'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.##;-,0.##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1053#1077#1080#1089#1087#1086#1083#1100#1079#1086#1074#1072#1085#1086', '#1076#1085#1077#1081' - '#1079#1072' '#1087#1077#1088#1080#1086#1076
        Options.Editing = False
        Width = 80
      end
      object Day_calendar: TcxGridDBColumn
        Caption = #1056#1072#1073#1086#1095'. '#1076#1085#1077#1081
        DataBinding.FieldName = 'Day_calendar'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.##;-,0.##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1072#1083#1077#1085#1076#1072#1088#1085#1099#1077' '#1076#1085#1080' '#1084#1080#1085#1091#1089' '#1076#1085#1080' '#1086#1090#1087#1091#1089#1082#1072' - '#1079#1072' '#1087#1077#1088#1080#1086#1076
        Width = 80
      end
      object Day_calendar_year: TcxGridDBColumn
        Caption = #1056#1072#1073#1086#1095'. '#1076#1085#1077#1081' ('#1075#1086#1076')'
        DataBinding.FieldName = 'Day_calendar_year'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.##;-,0.##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1072#1083#1077#1085#1076#1072#1088#1085#1099#1077' '#1076#1085#1080' '#1084#1080#1085#1091#1089' '#1076#1085#1080' '#1086#1090#1087#1091#1089#1082#1072' - '#1079#1072' '#1075#1086#1076
        Width = 80
      end
      object Day_real: TcxGridDBColumn
        Caption = #1050#1072#1083#1077#1085#1076'. '#1076#1085#1077#1081
        DataBinding.FieldName = 'Day_real'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.##;-,0.##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1072#1083#1077#1085#1076#1072#1088#1085#1099#1093' '#1076#1085#1077#1081' - '#1079#1072' '#1087#1077#1088#1080#1086#1076
        Width = 80
      end
      object Day_real_year: TcxGridDBColumn
        Caption = #1050#1072#1083#1077#1085#1076'. '#1076#1085#1077#1081' ('#1075#1086#1076')'
        DataBinding.FieldName = 'Day_real_year'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.##;-,0.##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1072#1083#1077#1085#1076#1072#1088#1085#1099#1093' '#1076#1085#1077#1081' - '#1079#1072' '#1075#1086#1076
        Width = 80
      end
      object Day_Hol: TcxGridDBColumn
        Caption = #1054#1090#1087#1091#1089#1082'. '#1076#1085#1077#1081
        DataBinding.FieldName = 'Day_Hol'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.##;-,0.##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1054#1090#1087#1091#1089#1082#1085#1099#1093' '#1076#1085#1077#1081' '#1087#1086' '#1090#1072#1073#1077#1083#1102' - '#1079#1072' '#1087#1077#1088#1080#1086#1076
        Width = 80
      end
      object Day_hol_NoZp: TcxGridDBColumn
        Caption = #1054#1090#1087#1091#1089#1082' '#1073#1077#1079' '#1089#1086#1093#1088'. '#1079#1087'., '#1076#1085#1077#1081
        DataBinding.FieldName = 'Day_hol_NoZp'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.##;-,0.##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1054#1090#1087#1091#1089#1082#1085#1099#1093' '#1076#1085#1077#1081' '#1073#1077#1079' '#1089#1086#1093#1088'. '#1079#1087' '#1087#1086' '#1090#1072#1073#1077#1083#1102'- '#1079#1072' '#1087#1077#1088#1080#1086#1076
        Width = 80
      end
      object Day_vacation_NoZp: TcxGridDBColumn
        Caption = #1055#1086#1083#1086#1078#1077#1085' '#1086#1090#1087#1091#1089#1082' '#1073#1077#1079' '#1089#1086#1093#1088'. , '#1076#1085#1077#1081
        DataBinding.FieldName = 'Day_vacation_NoZp'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.##;-,0.##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1055#1086#1083#1086#1078#1077#1085#1085#1086' '#1076#1085#1077#1081' '#1086#1090#1087#1091#1089#1082#1072' '#1073#1077#1079' '#1089#1086#1093#1088#1072#1085#1077#1085#1080#1103' '#1079#1087' - '#1079#1072' '#1087#1077#1088#1080#1086#1076
        Options.Editing = False
        Width = 80
      end
      object Day_diff_NoZp: TcxGridDBColumn
        Caption = #1053#1077#1080#1089#1087#1086#1083#1100#1079#1086#1074#1072#1085#1086' '#1073#1077#1079' '#1089#1086#1093#1088'., '#1076#1085#1077#1081
        DataBinding.FieldName = 'Day_diff_NoZp'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.##;-,0.##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1053#1077#1080#1089#1087#1086#1083#1100#1079#1086#1074#1072#1085#1086' '#1086#1090#1087#1091#1089#1082' '#1073#1077#1079' '#1089#1086#1093#1088#1072#1085#1077#1085#1080#1103', '#1076#1085#1077#1081' - '#1079#1072' '#1087#1077#1088#1080#1086#1076
        Options.Editing = False
        Width = 80
      end
      object Day_Hol_year: TcxGridDBColumn
        Caption = #1054#1090#1087#1091#1089#1082'. '#1076#1085#1077#1081' ('#1075#1086#1076')'
        DataBinding.FieldName = 'Day_Hol_year'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.##;-,0.##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1054#1090#1087#1091#1089#1082#1085#1099#1093' '#1076#1085#1077#1081' '#1087#1086' '#1090#1072#1073#1077#1083#1102' - '#1079#1072' '#1075#1086#1076
        Width = 80
      end
      object Day_Holiday_cl: TcxGridDBColumn
        Caption = #1055#1088#1072#1079#1076#1085'. '#1076#1085#1077#1081
        DataBinding.FieldName = 'Day_Holiday_cl'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.##;-,0.##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1055#1088#1072#1079#1076#1085#1080#1095#1085#1099#1093' '#1076#1085#1077#1081' '#1087#1086' '#1082#1072#1083#1077#1085#1076#1072#1088#1102' - '#1079#1072' '#1087#1077#1088#1080#1086#1076
      end
      object Day_Holiday_year_cl: TcxGridDBColumn
        Caption = #1055#1088#1072#1079#1076#1085'. '#1076#1085#1077#1081' ('#1075#1086#1076')'
        DataBinding.FieldName = 'Day_Holiday_year_cl'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.##;-,0.##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1055#1088#1072#1079#1076#1085#1080#1095#1085#1099#1093' '#1076#1085#1077#1081' '#1087#1086' '#1082#1072#1083#1077#1085#1076#1072#1088#1102' - '#1079#1072' '#1075#1086#1076
      end
      object InvNumber: TcxGridDBColumn
        Caption = #8470' '#1076#1086#1082'.  '#1086#1090#1087'.'
        DataBinding.FieldName = 'InvNumber'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object OperDate: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' '#1076#1086#1082'.'
        DataBinding.FieldName = 'OperDate'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 50
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
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 915
    Height = 65
    Align = alTop
    TabOrder = 2
    object deStart: TcxDateEdit
      Left = 65
      Top = 5
      EditValue = 43831d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 1
      Width = 85
    end
    object edMember: TcxButtonEdit
      Left = 247
      Top = 32
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 0
      Width = 203
    end
    object cxLabel3: TcxLabel
      Left = 183
      Top = 33
      Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082':'
    end
    object edPersonalServiceList: TcxButtonEdit
      Left = 529
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 3
      Width = 244
    end
    object cxLabel4: TcxLabel
      Left = 466
      Top = 6
      Hint = #1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103
      Caption = #1042#1077#1076#1086#1084#1086#1089#1090#1100':'
      ParentShowHint = False
      ShowHint = True
    end
    object cxLabel5: TcxLabel
      Left = 13
      Top = 6
      Caption = #1053#1072' '#1076#1072#1090#1091' :'
    end
    object cbDetail: TcxCheckBox
      Left = 13
      Top = 32
      Action = actIsDetail
      Properties.ReadOnly = False
      TabOrder = 6
      Width = 142
    end
  end
  object cxLabel1: TcxLabel
    Left = 159
    Top = 6
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
  end
  object edUnit: TcxButtonEdit
    Left = 247
    Top = 5
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 203
  end
  object MasterDS: TDataSource
    DataSet = MasterCDS
    Left = 48
    Top = 248
  end
  object MasterCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 96
    Top = 176
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = deStart
        Properties.Strings = (
          'Date')
      end
      item
        Component = GuidesMember
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesPersonalServiceList
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end
      item
        Component = GuidesUnit
        Properties.Strings = (
          'Key'
          'TextValue')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 312
    Top = 232
  end
  object dxBarManager: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    Categories.Strings = (
      'Default')
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    ImageOptions.Images = dmMain.ImageList
    NotDocking = [dsNone, dsLeft, dsTop, dsRight, dsBottom]
    PopupMenuLinks = <>
    ShowShortCutInHint = True
    UseSystemFont = True
    Left = 128
    Top = 264
    DockControlHeights = (
      0
      0
      26
      0)
    object dxBarManagerBar1: TdxBar
      Caption = 'Custom'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 2
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 671
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbDialogForm'
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
          ItemName = 'bbToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object bbRefresh: TdxBarButton
      Action = actRefresh
      Category = 0
    end
    object bbToExcel: TdxBarButton
      Action = actExportToExcel
      Category = 0
    end
    object bbDialogForm: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbPrintBy_Goods: TdxBarButton
      Action = actPrint1
      Category = 0
    end
    object dxBarStatic: TdxBarStatic
      Caption = '   '
      Category = 0
      Hint = '   '
      Visible = ivAlways
      ShowCaption = False
    end
    object bbPrint3: TdxBarButton
      Action = actPrint
      Category = 0
    end
    object bbIsDay: TdxBarControlContainerItem
      Caption = 'bbIsDay'
      Category = 0
      Hint = 'bbIsDay'
      Visible = ivAlways
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 256
    Top = 232
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spReport
      StoredProcList = <
        item
          StoredProc = spReport
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actExportToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      MoveParams = <>
      Grid = cxGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_HolidayPersonalDialogForm'
      FormNameParam.Value = 'TReport_HolidayPersonalDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MemberId'
          Value = ''
          Component = GuidesMember
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MemberName'
          Value = ''
          Component = GuidesMember
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PersonalServiceListId'
          Value = ''
          Component = GuidesPersonalServiceList
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PersonalServiceListName'
          Value = ''
          Component = GuidesPersonalServiceList
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inisDetail'
          Value = Null
          Component = cbDetail
          DataType = ftBoolean
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
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object SaleJournal: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'SaleJournal'
      FormName = 'TMovementGoodsJournalForm'
      FormNameParam.Value = 'TMovementGoodsJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 41640d
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 41640d
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsKindId'
          Value = 0
          Component = MasterCDS
          ComponentItem = 'GoodsKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsKindName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = ''
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartionGoodsId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartionGoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartionGoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartionGoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'LocationId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationName'
          Value = ''
          Component = MasterCDS
          ComponentItem = 'LocationName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'AccountGroupId'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'AccountGroupName'
          Value = Null
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InfoMoneyId_Detail'
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InfoMoneyName_Detail'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupId'
          Value = Null
          Component = GuidesMember
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupName'
          Value = Null
          Component = GuidesMember
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'DescSet'
          Value = Null
          Component = FormParams
          ComponentItem = 'SaleDesc'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actIsDetail: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spReport
      StoredProcList = <
        item
          StoredProc = spReport
        end>
      Caption = #1076#1077#1090#1072#1083#1100#1085#1086' '#1087#1086' '#1086#1090#1087#1091#1089#1082#1072#1084
      Hint = #1076#1077#1090#1072#1083#1100#1085#1086' '#1087#1086' '#1086#1090#1087#1091#1089#1082#1072#1084
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actPrint1: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1082#1083#1072#1076#1086#1074#1097#1080#1082#1072#1084
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1082#1083#1072#1076#1086#1074#1097#1080#1082#1072#1084
      ImageIndex = 16
      ShortCut = 16464
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'operDate;PersonalName'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42005d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42005d
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'PersonalName'
          Value = ''
          Component = GuidesMember
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PositionName'
          Value = ''
          Component = GuidesPersonalServiceList
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'inIsDay'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPrint'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1087#1086' '#1082#1086#1084#1087#1083#1077#1082#1090#1086#1074#1097#1080#1082#1072#1084
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1087#1086' '#1082#1086#1084#1087#1083#1077#1082#1090#1086#1074#1097#1080#1082#1072#1084
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1082#1086#1084#1087#1083#1077#1082#1090#1086#1074#1097#1080#1082#1072#1084
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1082#1086#1084#1087#1083#1077#1082#1090#1086#1074#1097#1080#1082#1072#1084
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'operDate;PersonalName'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42005d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42005d
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'PersonalName'
          Value = ''
          Component = GuidesMember
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PositionName'
          Value = ''
          Component = GuidesPersonalServiceList
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'inIsDay'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPrint'
          Value = True
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1087#1086' '#1082#1086#1084#1087#1083#1077#1082#1090#1086#1074#1097#1080#1082#1072#1084
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1087#1086' '#1082#1086#1084#1087#1083#1077#1082#1090#1086#1074#1097#1080#1082#1072#1084
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
  end
  object spReport: TdsdStoredProc
    StoredProcName = 'gpReport_HolidayPersonal'
    DataSet = MasterCDS
    DataSets = <
      item
        DataSet = MasterCDS
      end>
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
        Name = 'inUnitId'
        Value = '0'
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMemberId'
        Value = '0'
        Component = GuidesMember
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPositionId'
        Value = '0'
        Component = GuidesPersonalServiceList
        ComponentItem = 'Key'
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalServiceListId'
        Value = Null
        Component = GuidesPersonalServiceList
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDetail'
        Value = False
        Component = cbDetail
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 256
    Top = 176
  end
  object DBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <
      item
        Action = SaleJournal
        onExitColumn.Active = False
        onExitColumn.AfterEmptyValue = False
      end>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 432
    Top = 344
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 344
    Top = 288
  end
  object GuidesPersonalServiceList: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPersonalServiceList
    Key = '0'
    FormNameParam.Value = 'TPersonalServiceListForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPersonalServiceListForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPersonalServiceList
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPersonalServiceList
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 680
    Top = 8
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    Left = 176
    Top = 176
  end
  object GuidesMember: TdsdGuides
    KeyField = 'Id'
    LookupControl = edMember
    Key = '0'
    FormNameParam.Value = 'TMember_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMember_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesMember
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesMember
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionId'
        Value = Null
        Component = GuidesPersonalServiceList
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionName'
        Value = Null
        Component = GuidesPersonalServiceList
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 304
    Top = 16
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ShowDialogAction = ExecuteDialog
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = GuidesMember
      end
      item
        Component = GuidesPersonalServiceList
      end
      item
      end
      item
        Component = deStart
      end
      item
      end
      item
        Component = GuidesUnit
      end>
    Left = 144
    Top = 344
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'inIsDay'
        Value = Null
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 424
    Top = 224
  end
  object spGetDescSets: TdsdStoredProc
    StoredProcName = 'gpGetDescSets'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'IncomeDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'IncomeDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReturnOutDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'ReturnOutDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'SaleDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'SaleDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReturnInDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'ReturnInDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MoneyDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'MoneyDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ServiceDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'ServiceDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'SendDebtDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'SendDebtDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OtherDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'OtherDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'SaleRealDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'SaleRealDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReturnInRealDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'ReturnInRealDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'TransferDebtDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'TransferDebtDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceCorrectiveDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'PriceCorrectiveDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ServiceRealDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'ServiceRealDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ChangeCurrencyDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'ChangeCurrencyDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 528
    Top = 272
  end
  object GuidesUnit: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnit
    Key = '0'
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
    Left = 392
  end
end
