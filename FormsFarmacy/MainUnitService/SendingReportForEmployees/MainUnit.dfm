object MainForm: TMainForm
  Left = 0
  Top = 0
  AutoSize = True
  Caption = 'O'#1090#1087#1088#1072#1074#1082#1072' '#1089#1086#1086#1073#1097#1077#1085#1080#1081' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072#1084
  ClientHeight = 638
  ClientWidth = 1025
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object grReport: TcxGrid
    Left = 0
    Top = 257
    Width = 1025
    Height = 381
    Align = alClient
    TabOrder = 0
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
      object Message: TcxGridDBColumn
        Caption = #1058#1077#1082#1089#1090' '#1089#1086#1086#1073#1097#1077#1085#1080#1103
        DataBinding.FieldName = 'Message'
        Width = 964
      end
    end
    object cxGridLevel1: TcxGridLevel
      GridView = cxGridDBTableView1
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1025
    Height = 257
    Align = alTop
    BevelOuter = bvNone
    Caption = 'Panel1'
    TabOrder = 1
    object Panel2: TPanel
      Left = 0
      Top = 0
      Width = 1025
      Height = 31
      Align = alTop
      TabOrder = 0
      object btnSendTelegram: TButton
        Left = 775
        Top = 0
        Width = 130
        Height = 25
        Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1089#1086#1086#1073#1097#1077#1085#1080#1077
        TabOrder = 3
        OnClick = btnSendTelegramClick
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
      object btnAllLine: TButton
        Left = 480
        Top = 0
        Width = 129
        Height = 25
        Caption = #1042#1089#1105' '#1087#1086' '#1089#1090#1088#1086#1082#1077
        TabOrder = 0
        OnClick = btnAllLineClick
      end
    end
    object grChatId: TcxGrid
      Left = 496
      Top = 31
      Width = 529
      Height = 226
      Align = alRight
      TabOrder = 1
      LookAndFeel.Kind = lfStandard
      LookAndFeel.NativeStyle = False
      LookAndFeel.SkinName = ''
      object grChatIdDBTableView: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = ChatIdDS
        DataController.Filter.Options = [fcoCaseInsensitive]
        DataController.Filter.Active = True
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <
          item
            Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
            Kind = skCount
            Column = ciLastName
          end>
        DataController.Summary.SummaryGroups = <>
        OptionsBehavior.IncSearch = True
        OptionsBehavior.IncSearchItem = ciLastName
        OptionsCustomize.ColumnHiding = True
        OptionsCustomize.ColumnsQuickCustomization = True
        OptionsData.Deleting = False
        OptionsData.DeletingConfirmation = False
        OptionsData.Inserting = False
        OptionsSelection.InvertSelect = False
        OptionsView.Footer = True
        OptionsView.GroupByBox = False
        OptionsView.Indicator = True
        object cidID: TcxGridDBColumn
          DataBinding.FieldName = 'ID'
          HeaderAlignmentHorz = taCenter
          Width = 90
        end
        object ciFirstName: TcxGridDBColumn
          DataBinding.FieldName = 'FirstName'
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Width = 147
        end
        object ciLastName: TcxGridDBColumn
          DataBinding.FieldName = 'LastName'
          HeaderAlignmentHorz = taCenter
          HeaderGlyphAlignmentHorz = taCenter
          Options.Editing = False
          Width = 145
        end
        object ciUserName: TcxGridDBColumn
          DataBinding.FieldName = 'UserName'
          GroupSummaryAlignment = taCenter
          HeaderAlignmentHorz = taCenter
          HeaderGlyphAlignmentHorz = taCenter
          Options.Editing = False
          Width = 154
        end
      end
      object grChatIdLevel: TcxGridLevel
        GridView = grChatIdDBTableView
      end
    end
    object cxGrid1: TcxGrid
      Left = 0
      Top = 31
      Width = 496
      Height = 226
      Align = alClient
      TabOrder = 2
      LookAndFeel.Kind = lfStandard
      LookAndFeel.NativeStyle = False
      LookAndFeel.SkinName = ''
      object cxGridDBTableView2: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = dsSendList
        DataController.Filter.Options = [fcoCaseInsensitive]
        DataController.Filter.Active = True
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <
          item
            Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
            Kind = skCount
          end>
        DataController.Summary.SummaryGroups = <>
        OptionsBehavior.IncSearch = True
        OptionsCustomize.ColumnHiding = True
        OptionsCustomize.ColumnsQuickCustomization = True
        OptionsData.Deleting = False
        OptionsData.DeletingConfirmation = False
        OptionsData.Inserting = False
        OptionsSelection.InvertSelect = False
        OptionsView.Footer = True
        OptionsView.GroupByBox = False
        OptionsView.Indicator = True
        object slId: TcxGridDBColumn
          DataBinding.FieldName = 'Id'
          Width = 29
        end
        object slDateSend: TcxGridDBColumn
          DataBinding.FieldName = 'DateSend'
          Width = 120
        end
        object slChatIDList: TcxGridDBColumn
          DataBinding.FieldName = 'ChatIDList'
          Width = 243
        end
        object slSQL: TcxGridDBColumn
          DataBinding.FieldName = 'SQL'
          Width = 189
        end
      end
      object cxGridLevel2: TcxGridLevel
        GridView = cxGridDBTableView2
      end
    end
  end
  object ZConnection1: TZConnection
    ControlsCodePage = cCP_UTF16
    Catalog = ''
    HostName = ''
    Port = 5432
    Database = ''
    User = ''
    Password = ''
    Protocol = 'postgresql-9'
    Left = 160
    Top = 88
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 64
    Top = 88
  end
  object qrySendList: TZQuery
    Connection = ZConnection1
    SQL.Strings = (
      
        'select * from gpSelect_TelegramBot_SendingReportForEmployees('#39'3'#39 +
        ');')
    Params = <>
    Left = 264
    Top = 88
  end
  object dsSendList: TDataSource
    DataSet = qrySendList
    Left = 376
    Top = 88
  end
  object qryReport_Upload: TZQuery
    Connection = ZConnection1
    Params = <>
    Properties.Strings = (
      '')
    Left = 428
    Top = 392
  end
  object dsReport_Upload: TDataSource
    DataSet = qryReport_Upload
    Left = 624
    Top = 392
  end
  object ChatIdDS: TDataSource
    AutoEdit = False
    Left = 552
    Top = 120
  end
end
