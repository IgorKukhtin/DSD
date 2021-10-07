object MainForm: TMainForm
  Left = 0
  Top = 0
  AutoSize = True
  Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1076#1072#1085#1085#1099#1093' '#1076#1083#1103' '#1087#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1077#1081
  ClientHeight = 566
  ClientWidth = 909
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object grReportMaker: TcxGrid
    Left = 0
    Top = 235
    Width = 909
    Height = 331
    Align = alClient
    TabOrder = 1
    object grtvMaker: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = dsReport_Upload
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsData.CancelOnExit = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsView.CellTextMaxLineCount = 100
      OptionsView.Footer = True
      OptionsView.GroupByBox = False
      OptionsView.HeaderAutoHeight = True
    end
    object grReportMakerLevel1: TcxGridLevel
      GridView = grtvMaker
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 909
    Height = 31
    Align = alTop
    TabOrder = 0
    object btnSendMail: TButton
      Left = 775
      Top = 0
      Width = 113
      Height = 25
      Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' Email'
      TabOrder = 3
      OnClick = btnSendMailClick
    end
    object btnExport: TButton
      Left = 711
      Top = 0
      Width = 58
      Height = 25
      Caption = #1069#1082#1089#1087#1086#1088#1090
      TabOrder = 2
      OnClick = btnExportClick
    end
    object btnExecute: TButton
      Left = 615
      Top = 0
      Width = 90
      Height = 25
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100
      TabOrder = 1
      OnClick = btnExecuteClick
    end
    object btnAll: TButton
      Left = 16
      Top = 0
      Width = 97
      Height = 25
      Caption = #1042#1089#1105' '#1087#1086' '#1074#1089#1077#1084'!'
      TabOrder = 4
      OnClick = btnAllClick
    end
    object btnAllMaker: TButton
      Left = 480
      Top = 0
      Width = 129
      Height = 25
      Caption = #1042#1089#1105' '#1087#1086' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091
      TabOrder = 0
      OnClick = btnAllMakerClick
    end
  end
  object cxGrid: TcxGrid
    Left = 0
    Top = 31
    Width = 909
    Height = 204
    Align = alTop
    TabOrder = 2
    LookAndFeel.Kind = lfStandard
    LookAndFeel.NativeStyle = False
    LookAndFeel.SkinName = ''
    object cxGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = dsMaker
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Filter.Active = True
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
          Kind = skCount
          Column = Name
        end>
      DataController.Summary.SummaryGroups = <>
      OptionsBehavior.IncSearch = True
      OptionsBehavior.IncSearchItem = Name
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsSelection.InvertSelect = False
      OptionsView.Footer = True
      OptionsView.GroupByBox = False
      OptionsView.HeaderHeight = 60
      OptionsView.Indicator = True
      object Code: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'Code'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 42
      end
      object Name: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'Name'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 168
      end
      object Mail: TcxGridDBColumn
        Caption = #1069#1083#1077#1082#1090#1088#1086#1085#1085#1072#1103' '#1087#1086#1095#1090#1072' ('#1082#1086#1085#1090'. '#1083#1080#1094#1086')'
        DataBinding.FieldName = 'Mail'
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 114
      end
      object SendPlan: TcxGridDBColumn
        Caption = #1050#1086#1075#1076#1072' '#1087#1083#1072#1085#1080#1088#1091#1077#1084' '#1086#1090#1087#1088#1072#1074#1080#1090#1100' ('#1076#1072#1090#1072'/'#1074#1088#1077#1084#1103')'
        DataBinding.FieldName = 'SendPlan'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1075#1076#1072' '#1087#1083#1072#1085#1080#1088#1091#1077#1084' '#1086#1090#1087#1088#1072#1074#1080#1090#1100'('#1076#1072#1090#1072'/'#1074#1088#1077#1084#1103')'
        Options.Editing = False
        Width = 85
      end
      object AmountMonth: TcxGridDBColumn
        Caption = #1055#1077#1088#1080#1086#1076'. '#1084#1077#1089#1103#1094#1077#1074
        DataBinding.FieldName = 'AmountMonth'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1087#1077#1088#1080#1086#1076#1080#1095#1085#1086#1089#1090#1100' '#1086#1090#1087#1088#1072#1074#1082#1080'  '#1074' '#1084#1077#1089#1103#1094#1072#1093
        Options.Editing = False
        Width = 53
      end
      object AmountDay: TcxGridDBColumn
        Caption = #1055#1077#1088#1080#1086#1076'. '#1076#1085#1077#1081
        DataBinding.FieldName = 'AmountDay'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1087#1077#1088#1080#1086#1076#1080#1095#1085#1086#1089#1090#1100' '#1086#1090#1087#1088#1072#1074#1082#1080' '#1074' '#1076#1085#1103#1093
        Options.Editing = False
        Width = 52
      end
      object isCurrMonth: TcxGridDBColumn
        Caption = #1058#1077#1082'. '#1084#1077#1089#1103#1094
        DataBinding.FieldName = 'isCurrMonth'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 56
      end
      object isUnPlanned: TcxGridDBColumn
        Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1074#1085#1077#1087#1083#1072#1085#1086#1074#1099#1077' '#1086#1090#1095#1077#1090#1099
        DataBinding.FieldName = 'isUnPlanned'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 81
      end
      object isQuarterAdd: TcxGridDBColumn
        Caption = #1044#1086#1087#1086#1083#1085'. '#1082#1074#1072#1088#1090#1072#1083
        DataBinding.FieldName = 'isQuarterAdd'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 62
      end
      object is4MonthAdd: TcxGridDBColumn
        Caption = #1044#1086#1087#1086#1083#1085'. 4 '#1084#1077#1089#1103#1094#1072
        DataBinding.FieldName = 'is4MonthAdd'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object StartDateUnPlanned: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072' '#1076#1083#1103' '#1042#1054
        DataBinding.FieldName = 'StartDateUnPlanned'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072' '#1076#1083#1103' '#1074#1085#1077#1087#1083#1072#1085#1086#1074#1086#1075#1086' '#1086#1090#1095#1077#1090#1072
        Options.Editing = False
        Width = 68
      end
      object EndDateUnPlanned: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1076#1083#1103' '#1042#1054
        DataBinding.FieldName = 'EndDateUnPlanned'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1076#1083#1103' '#1074#1085#1077#1087#1083#1072#1085#1086#1074#1086#1075#1086' '#1086#1090#1095#1077#1090#1072
        Options.Editing = False
        Width = 70
      end
      object isReport1: TcxGridDBColumn
        Caption = #1054#1090#1087#1088#1072#1074#1083#1103#1090#1100' "'#1086#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1080#1093#1086#1076#1072#1084'"'
        DataBinding.FieldName = 'isReport1'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1086#1090#1087#1088#1072#1074#1083#1103#1090#1100' "'#1086#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1080#1093#1086#1076#1072#1084'"'
        Options.Editing = False
        Width = 62
      end
      object isReport2: TcxGridDBColumn
        Caption = #1054#1090#1087#1088#1072#1074#1083#1103#1090#1100' "'#1086#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084'"'
        DataBinding.FieldName = 'isReport2'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1086#1090#1087#1088#1072#1074#1083#1103#1090#1100' "'#1086#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084'"'
        Options.Editing = False
        Width = 68
      end
      object isReport3: TcxGridDBColumn
        Caption = #1054#1090#1087#1088#1072#1074#1083#1103#1090#1100' "'#1088#1077#1072#1083#1080#1079#1072#1094#1080#1103' '#1079#1072' '#1087#1077#1088#1080#1086#1076' '#1089' '#1086#1089#1090#1072#1090#1082#1072#1084#1080' '#1085#1072' '#1082#1086#1085#1077#1094' '#1087#1077#1088#1080#1086#1076#1072'"'
        DataBinding.FieldName = 'isReport3'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1086#1090#1087#1088#1072#1074#1083#1103#1090#1100' "'#1088#1077#1072#1083#1080#1079#1072#1094#1080#1103' '#1079#1072' '#1087#1077#1088#1080#1086#1076' '#1089' '#1086#1089#1090#1072#1090#1082#1072#1084#1080' '#1085#1072' '#1082#1086#1085#1077#1094' '#1087#1077#1088#1080#1086#1076#1072'"'
        Options.Editing = False
        Width = 121
      end
      object isReport4: TcxGridDBColumn
        Caption = #1054#1090#1087#1088#1072#1074#1083#1103#1090#1100' "'#1087#1088#1080#1093#1086#1076' '#1088#1072#1089#1093#1086#1076' '#1086#1089#1090#1072#1090#1086#1082'"'
        DataBinding.FieldName = 'isReport4'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1086#1090#1087#1088#1072#1074#1083#1103#1090#1100' "'#1087#1088#1080#1093#1086#1076' '#1088#1072#1089#1093#1086#1076' '#1086#1089#1090#1072#1090#1086#1082'"'
        Options.Editing = False
        Width = 80
      end
      object isReport6: TcxGridDBColumn
        Caption = #1054#1090#1087#1088#1072#1074#1083#1103#1090#1100' "'#1080#1089#1090#1077#1082#1096#1080#1081' '#1089#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080'"'
        DataBinding.FieldName = 'isReport6'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 87
      end
      object isReport7: TcxGridDBColumn
        Caption = #1054#1090#1087#1088#1072#1074#1083#1103#1090#1100' "'#1086#1090#1095#1077#1090' '#1087#1086' '#1086#1087#1083#1072#1090#1077' '#1087#1088#1080#1093#1086#1076#1086#1074'"'
        DataBinding.FieldName = 'isReport7'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 88
      end
      object isQuarter: TcxGridDBColumn
        Caption = #1054#1090#1087#1088#1072#1074#1083#1103#1090#1100' '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086' '#1082#1074#1072#1088#1090#1072#1083#1100#1085#1099#1077' '#1086#1090#1095#1077#1090#1099
        DataBinding.FieldName = 'isQuarter'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object is4Month: TcxGridDBColumn
        Caption = #1054#1090#1087#1088#1072#1074#1083#1103#1090#1100' '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086' '#1086#1090#1095#1077#1090#1099' '#1079#1072' 4 '#1084#1077#1089#1103#1094#1072
        DataBinding.FieldName = 'is4Month'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 94
      end
      object ContactPersonName: TcxGridDBColumn
        Caption = #1050#1086#1085#1090#1072#1082#1090#1085#1086#1077' '#1083#1080#1094#1086
        DataBinding.FieldName = 'ContactPersonName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object CountryName: TcxGridDBColumn
        Caption = #1057#1090#1088#1072#1085#1072
        DataBinding.FieldName = 'CountryName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 147
      end
      object Phone: TcxGridDBColumn
        Caption = #1058#1077#1083#1077#1092#1086#1085' ('#1082#1086#1085#1090'. '#1083#1080#1094#1086')'
        DataBinding.FieldName = 'Phone'
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 109
      end
      object SendReal: TcxGridDBColumn
        Caption = #1050#1086#1075#1076#1072' '#1091#1089#1087#1077#1096#1085#1086' '#1087#1088#1086#1096#1083#1072' '#1086#1090#1087#1088#1072#1074#1082#1072' ('#1076#1072#1090#1072'/'#1074#1088#1077#1084#1103')'
        DataBinding.FieldName = 'SendReal'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1075#1076#1072' '#1091#1089#1087#1077#1096#1085#1086' '#1087#1088#1086#1096#1083#1072' '#1086#1090#1087#1088#1072#1074#1082#1072' ('#1076#1072#1090#1072' / '#1074#1088#1077#1084#1103')'
        Options.Editing = False
        Width = 97
      end
      object SendLast: TcxGridDBColumn
        Caption = #1057#1083'. '#1086#1090#1087#1088#1072#1074#1082#1072' ('#1076#1072#1090#1072'/'#1074#1088#1077#1084#1103')'
        DataBinding.FieldName = 'SendLast'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1076#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1089#1083#1077#1076#1091#1102#1097#1077#1081' '#1086#1090#1087#1088#1072#1074#1082#1080
        Options.Editing = False
        Width = 85
      end
      object isErased: TcxGridDBColumn
        Caption = #1059#1076#1072#1083#1077#1085
        DataBinding.FieldName = 'isErased'
        PropertiesClassName = 'TcxCheckBoxProperties'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 53
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object ZConnection1: TZConnection
    ControlsCodePage = cCP_UTF16
    Port = 5432
    Protocol = 'postgresql-9'
    Left = 136
    Top = 136
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 48
    Top = 128
  end
  object qryMaker: TZQuery
    Connection = ZConnection1
    SQL.Strings = (
      'SELECT *'
      
        '     , CASE WHEN COALESCE(AmountDay, 0) <> 25 THEN COALESCE(Amou' +
        'ntDay, 0) ELSE 0 END  AS AmountDaySend'
      
        '     , CASE WHEN COALESCE(AmountDay, 0) = 25 THEN 1 ELSE COALESC' +
        'E(AmountMonth, 0) END AS AmountMonthSend'
      
        '     , COALESCE(AmountDay, 0) = 25                              ' +
        '                      AS isCurrMonth'
      
        '     , COALESCE (isQuarter, FALSE) = TRUE AND date_part('#39'MONTH'#39',' +
        ' CURRENT_DATE) IN (12, 3, 6, 9) AND'
      
        '       DATE_PART('#39'DAY'#39',  CURRENT_DATE + INTERVAL '#39'3 DAY'#39') = 1   ' +
        '                      AS isQuarterAdd'
      
        '     , COALESCE (isQuarter, FALSE) = TRUE AND date_part('#39'MONTH'#39',' +
        ' CURRENT_DATE) IN (12, 4, 8) AND'
      
        '       DATE_PART('#39'DAY'#39',  CURRENT_DATE + INTERVAL '#39'3 DAY'#39') = 1   ' +
        '                      AS is4MonthAdd'
      'FROM gpSelect_Object_Maker( '#39'3'#39')'
      'WHERE'
      
        '(SendPlan <= CURRENT_TIMESTAMP AND (COALESCE(AmountDay, 0) NOT I' +
        'N (0, 25) OR COALESCE(AmountMonth, 0) <> 0) OR'
      
        'SendReal < CURRENT_DATE AND COALESCE(AmountDay, 0) = 25 AND DATE' +
        '_PART('#39'DAY'#39',  CURRENT_DATE + INTERVAL '#39'5 DAY'#39') = 1 OR'
      
        '(COALESCE (isQuarter, FALSE) = TRUE AND date_part('#39'MONTH'#39', CURRE' +
        'NT_DATE) IN (12, 3, 6, 9) OR'
      
        ' COALESCE (is4Month, FALSE) = TRUE) AND date_part('#39'MONTH'#39', CURRE' +
        'NT_DATE) IN (12, 4, 8) AND'
      ' DATE_PART('#39'DAY'#39',  CURRENT_DATE + INTERVAL '#39'3 DAY'#39') = 1 OR'
      'COALESCE (isUnPlanned, FALSE) = TRUE) AND'
      
        '(COALESCE (isReport1, FALSE) = TRUE OR COALESCE (isReport2, FALS' +
        'E) = TRUE OR'
      
        'COALESCE (isReport3, FALSE) = TRUE OR COALESCE (isReport4, FALSE' +
        ') = TRUE  OR'
      
        'COALESCE (isReport5, FALSE) = TRUE OR COALESCE (isReport6, FALSE' +
        ') = TRUE OR'
      'COALESCE (isReport7, FALSE) = TRUE OR'
      'COALESCE (isUnPlanned, FALSE) = TRUE) AND'
      'COALESCE (Mail, '#39#39') <> '#39#39';')
    Params = <>
    Left = 144
    Top = 384
  end
  object dsMaker: TDataSource
    DataSet = qryMaker
    Left = 224
    Top = 384
  end
  object qryMailParam: TZQuery
    Connection = ZConnection1
    SQL.Strings = (
      'SELECT'
      '    zc_Mail_From() AS Mail_From,'
      '    zc_Mail_Host() AS Mail_Host,'
      '    zc_Mail_Port() AS Mail_Port,'
      '    zc_Mail_User() AS Mail_User,'
      '    zc_Mail_Password() AS Mail_Password')
    Params = <>
    Left = 144
    Top = 328
  end
  object qryReport_Upload: TZQuery
    Connection = ZConnection1
    Params = <>
    Left = 556
    Top = 336
  end
  object dsReport_Upload: TDataSource
    DataSet = qryReport_Upload
    Left = 680
    Top = 336
  end
  object pmExecute: TPopupMenu
    Left = 216
    Top = 136
    object N1: TMenuItem
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1080#1093#1086#1076#1072#1084
      OnClick = pmClick
    end
    object N2: TMenuItem
      Tag = 1
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084
      OnClick = pmClick
    end
    object N3: TMenuItem
      Tag = 2
      Caption = #1054#1090#1095#1077#1090' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1103' '#1079#1072' '#1087#1077#1088#1080#1086#1076' '#1089' '#1086#1089#1090#1072#1090#1082#1086#1084' '#1085#1072' '#1082#1086#1085#1077#1094' '#1087#1077#1088#1080#1086#1076#1072
      OnClick = pmClick
    end
    object N4: TMenuItem
      Tag = 3
      Caption = #1054#1090#1095#1077#1090' '#1087#1088#1080#1093#1086#1076' '#1088#1072#1089#1093#1086#1076' '#1086#1089#1090#1072#1090#1086#1082
      OnClick = pmClick
    end
    object N5: TMenuItem
      Tag = 4
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1089#1088#1086#1082#1072#1084
      OnClick = pmClick
    end
    object N6: TMenuItem
      Tag = 5
      Caption = #1054#1090#1095#1077#1090' '#1080#1089#1090#1077#1082#1096#1080#1081' '#1089#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080
      OnClick = pmClick
    end
    object N7: TMenuItem
      Tag = 6
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1086#1087#1083#1072#1090#1077' '#1087#1088#1080#1093#1086#1076#1086#1074
      OnClick = pmClick
    end
  end
  object qrySetDateSend: TZQuery
    Connection = ZConnection1
    SQL.Strings = (
      
        'select * from gpUpdate_Object_Maker_SendDate (:inMaker, :inAddMo' +
        'nth, :inAddDay, :inisCurrMonth, '#39'3'#39');')
    Params = <
      item
        DataType = ftUnknown
        Name = 'inMaker'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'inAddMonth'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'inAddDay'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'inisCurrMonth'
        ParamType = ptUnknown
      end>
    Left = 144
    Top = 448
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'inMaker'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'inAddMonth'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'inAddDay'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'inisCurrMonth'
        ParamType = ptUnknown
      end>
  end
  object qryClearUnPlanned: TZQuery
    Connection = ZConnection1
    SQL.Strings = (
      
        'select * from gpUpdate_Object_Maker_ClearUnPlanned (:inMaker, '#39'3' +
        #39');')
    Params = <
      item
        DataType = ftUnknown
        Name = 'inMaker'
        ParamType = ptUnknown
      end>
    Left = 224
    Top = 448
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'inMaker'
        ParamType = ptUnknown
      end>
  end
end
