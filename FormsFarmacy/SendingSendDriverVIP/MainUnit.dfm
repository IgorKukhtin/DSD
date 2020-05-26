object MainForm: TMainForm
  Left = 0
  Top = 0
  AutoSize = True
  Caption = 'O'#1090#1087#1088#1072#1074#1082#1072' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1081' '#1042#1086#1076#1080#1090#1077#1083#1103#1084' '#1057#1059#1053
  ClientHeight = 638
  ClientWidth = 961
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
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 961
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
      Caption = #1042#1089#1105' '#1087#1086' '#1074#1086#1076#1080#1090#1077#1083#1102
      TabOrder = 0
      OnClick = btnAllMakerClick
    end
  end
  object cxGrid: TcxGrid
    Left = 0
    Top = 31
    Width = 961
    Height = 204
    Align = alTop
    TabOrder = 1
    LookAndFeel.Kind = lfStandard
    LookAndFeel.NativeStyle = False
    LookAndFeel.SkinName = ''
    object cxGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = dsDriver
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
      object isAllLetters: TcxGridDBColumn
        Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1074#1089#1077' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103
        DataBinding.FieldName = 'isAllLetters'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object Code: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'Code'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 42
      end
      object Name: TcxGridDBColumn
        Caption = #1042#1086#1076#1080#1090#1077#1083#1100' '#1057#1059#1053
        DataBinding.FieldName = 'Name'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 274
      end
      object Email: TcxGridDBColumn
        Caption = #1069#1083#1077#1082#1090#1088#1086#1085#1085#1072#1103' '#1087#1086#1095#1090#1072
        DataBinding.FieldName = 'Email'
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 363
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object grReport: TcxGrid
    Left = 0
    Top = 235
    Width = 961
    Height = 403
    Align = alClient
    TabOrder = 2
    object cxGridDBTableView1: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = dsReport_Upload
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
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsView.Footer = True
      OptionsView.GroupSummaryLayout = gslAlignWithColumns
      OptionsView.HeaderAutoHeight = True
      OptionsView.Indicator = True
      object colOperDate: TcxGridDBColumn
        Caption = #1044#1072#1090#1072
        DataBinding.FieldName = 'OperDate'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 64
      end
      object colInvNumber: TcxGridDBColumn
        Caption = #8470' '#1076#1086#1082'.'
        DataBinding.FieldName = 'InvNumber'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
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
      object Comment: TcxGridDBColumn
        Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081
        DataBinding.FieldName = 'Comment'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 147
      end
    end
    object cxGridLevel1: TcxGridLevel
      GridView = cxGridDBTableView1
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
    Top = 136
  end
  object qryDriver: TZQuery
    Connection = ZConnection1
    SQL.Strings = (
      'select * from gpSelect_Object_DriverSend('#39'3'#39');')
    Params = <>
    Left = 144
    Top = 384
  end
  object dsDriver: TDataSource
    DataSet = qryDriver
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
    SQL.Strings = (
      'SELECT * FROM gpSelect_Movement_SendDriverSun (:Driver, '#39'3'#39');')
    Params = <
      item
        DataType = ftUnknown
        Name = 'Driver'
        ParamType = ptUnknown
      end>
    Left = 428
    Top = 392
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'Driver'
        ParamType = ptUnknown
      end>
  end
  object dsReport_Upload: TDataSource
    DataSet = qryReport_Upload
    Left = 624
    Top = 392
  end
end
