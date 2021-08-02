object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'O'#1090#1087#1088#1072#1074#1082#1072' '#1089#1086#1086#1073#1097#1077#1085#1080#1081' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072#1084
  ClientHeight = 702
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
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1025
    Height = 257
    Align = alTop
    BevelOuter = bvNone
    Caption = 'Panel1'
    TabOrder = 0
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
          Options.Editing = False
          Width = 29
        end
        object slDateSend: TcxGridDBColumn
          DataBinding.FieldName = 'DateSend'
          Options.Editing = False
          Width = 120
        end
        object slChatIDList: TcxGridDBColumn
          DataBinding.FieldName = 'ChatIDList'
          Options.Editing = False
          Width = 243
        end
        object slSQL: TcxGridDBColumn
          DataBinding.FieldName = 'SQL'
          Options.Editing = False
          Width = 189
        end
      end
      object cxGridLevel2: TcxGridLevel
        GridView = cxGridDBTableView2
      end
    end
  end
  object cxPageControl1: TcxPageControl
    Left = 0
    Top = 257
    Width = 1025
    Height = 445
    Align = alClient
    TabOrder = 1
    Properties.ActivePage = cxTabSheet4
    Properties.CustomButtons.Buttons = <>
    ClientRectBottom = 441
    ClientRectLeft = 4
    ClientRectRight = 1021
    ClientRectTop = 24
    object cxTabSheet1: TcxTabSheet
      Caption = #1057#1086#1086#1073#1097#1077#1085#1080#1103
      ImageIndex = 0
      object grReport: TcxGrid
        Left = 0
        Top = 0
        Width = 1017
        Height = 417
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
          OptionsView.CellEndEllipsis = True
          OptionsView.CellAutoHeight = True
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
    end
    object cxTabSheet2: TcxTabSheet
      Caption = #1044#1080#1085#1072#1084#1080#1082#1072' '#1079#1072#1082#1072#1079#1086#1074' '#1087#1086' '#1045#1048#1062
      ImageIndex = 1
      object grChart2: TcxGrid
        Left = 0
        Top = 0
        Width = 1017
        Height = 417
        Hint = #1044#1080#1085#1072#1084#1080#1082#1072
        Align = alClient
        TabOrder = 0
        object cxGridDBChartView1: TcxGridDBChartView
          DiagramLine.Active = True
          DiagramLine.Values.LineWidth = 2
          ToolBox.CustomizeButton = True
          ToolBox.DiagramSelector = True
          object cxGridDBChartDataGroup2: TcxGridDBChartDataGroup
            DataBinding.FieldName = 'OperDate'
            DisplayText = #1044#1072#1090#1072
          end
          object cxGridDBChartSeries10: TcxGridDBChartSeries
            DataBinding.FieldName = 'CountAll'
            DisplayText = #1048#1090#1086#1075#1086
          end
          object cxGridDBChartSeries7: TcxGridDBChartSeries
            DataBinding.FieldName = 'CountNeBoley'
            DisplayText = #1057#1072#1081#1090' "'#1053#1077' '#1073#1086#1083#1077#1081'"'
          end
          object cxGridDBChartSeries8: TcxGridDBChartSeries
            DataBinding.FieldName = 'CountTabletki'
            DisplayText = #1057#1072#1081#1090' "Tabletki"'
          end
          object cxGridDBChartSeries9: TcxGridDBChartSeries
            DataBinding.FieldName = 'CountLiki24'
            DisplayText = #1057#1072#1081#1090' "Liki24"'
          end
        end
        object cxGridLevel3: TcxGridLevel
          GridView = cxGridDBChartView1
        end
      end
    end
    object cxTabSheet3: TcxTabSheet
      Caption = #1044#1080#1085#1072#1084#1080#1082#1072' '#1080#1079#1084#1077#1085#1077#1085#1080#1103' '#1087#1086' '#1076#1085#1103#1084' '#1085#1077#1076#1077#1083#1080' '#1074' %'
      ImageIndex = 1
      object cxGrid2: TcxGrid
        Left = 0
        Top = 0
        Width = 1017
        Height = 417
        Hint = #1044#1080#1085#1072#1084#1080#1082#1072
        Align = alClient
        TabOrder = 0
        object cxGridDBChartView2: TcxGridDBChartView
          DiagramLine.Values.LineWidth = 2
          DiagramStackedArea.Active = True
          ToolBox.CustomizeButton = True
          ToolBox.DiagramSelector = True
          object cxGridDBChartDataGroup1: TcxGridDBChartDataGroup
            DataBinding.FieldName = 'OperDate'
            DisplayText = #1044#1072#1090#1072
          end
          object cxGridDBChartSeries1: TcxGridDBChartSeries
            DataBinding.FieldName = 'DeltaAll'
            DisplayText = #1048#1090#1086#1075#1086
          end
        end
        object cxGridLevel4: TcxGridLevel
          GridView = cxGridDBChartView2
        end
      end
    end
    object cxTabSheet4: TcxTabSheet
      Caption = #1056#1086#1089#1090'/'#1087#1072#1076#1077#1085#1080#1077' '#1079#1072#1082#1072#1079#1086#1074' '#1084#1077#1089#1103#1094#1072' '#1082' '#1087#1088#1077#1076#1099#1076#1091#1097#1077#1084#1091' '#1084#1077#1089#1103#1094#1091' '#1074' %'
      ImageIndex = 3
      object cxGrid3: TcxGrid
        Left = 0
        Top = 0
        Width = 1017
        Height = 417
        Hint = #1044#1080#1085#1072#1084#1080#1082#1072
        Align = alClient
        TabOrder = 0
        object cxGridDBChartView3: TcxGridDBChartView
          DiagramLine.Active = True
          DiagramLine.Values.LineWidth = 2
          ToolBox.CustomizeButton = True
          ToolBox.DiagramSelector = True
          object cxGridDBChartDataGroup3: TcxGridDBChartDataGroup
            DataBinding.FieldName = 'OperDate'
            DisplayText = #1044#1072#1090#1072
          end
          object cxGridDBChartSeries2: TcxGridDBChartSeries
            DataBinding.FieldName = 'CountAll'
            DisplayText = #1048#1090#1086#1075#1086
          end
        end
        object cxGridLevel5: TcxGridLevel
          GridView = cxGridDBChartView3
        end
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
  object dsReport: TDataSource
    DataSet = qryReport
    Left = 624
    Top = 472
  end
  object qryReport: TZQuery
    Connection = ZConnection1
    Params = <>
    Properties.Strings = (
      '')
    Left = 428
    Top = 472
  end
end
