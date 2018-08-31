object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = #1045#1082#1089#1087#1086#1088#1090' '#1076#1083#1103' '#1089#1072#1081#1090#1072' neboley'
  ClientHeight = 421
  ClientWidth = 624
  Color = clBtnFace
  Constraints.MinHeight = 460
  Constraints.MinWidth = 640
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ButtonPanel: TPanel
    Left = 0
    Top = 0
    Width = 624
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object ExportButton: TButton
      Left = 111
      Top = 8
      Width = 97
      Height = 25
      Action = SaveAction
      TabOrder = 1
    end
    object RunButton: TButton
      Left = 8
      Top = 8
      Width = 97
      Height = 25
      Action = RunAction
      TabOrder = 0
    end
    object RunExportButton: TButton
      Left = 223
      Top = 10
      Width = 290
      Height = 25
      Action = RunAndExport
      TabOrder = 2
    end
  end
  object ExportGrid: TcxGrid
    Left = 0
    Top = 41
    Width = 624
    Height = 380
    Align = alClient
    TabOrder = 1
    object ExportGridDBTableView1: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = DataSource
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsData.Deleting = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsView.GroupByBox = False
      OptionsView.Indicator = True
      object colGoodsCode: TcxGridDBColumn
        DataBinding.FieldName = 'goodscode'
      end
      object colGoodsNameForSite: TcxGridDBColumn
        DataBinding.FieldName = 'goodsnameforsite'
        Width = 228
      end
      object colPrice: TcxGridDBColumn
        DataBinding.FieldName = 'price'
      end
      object colGoodsURL: TcxGridDBColumn
        DataBinding.FieldName = 'goodsurl'
        Width = 247
      end
    end
    object ExportGridLevel1: TcxGridLevel
      GridView = ExportGridDBTableView1
    end
  end
  object ZConnection: TZConnection
    ControlsCodePage = cCP_UTF16
    HostName = '91.210.37.210'
    Port = 5432
    Database = 'farmacy_test'
    User = 'postgres'
    Password = 'postgres'
    Protocol = 'postgresql-9'
    LibraryLocation = 'C:\DSD\DSD.GIT\BIN\libpq.dll'
    Left = 56
    Top = 108
  end
  object ZQuery: TZReadOnlyQuery
    Connection = ZConnection
    SQL.Strings = (
      
        'SELECT DISTINCT * FROM gpSelect_GoodsOnUnit_ForSite_NeBoley (0, ' +
        'zfCalc_UserSite())')
    Params = <>
    Left = 148
    Top = 108
    object ZQuerygoodscode: TIntegerField
      DisplayLabel = #1050#1086#1076
      FieldName = 'goodscode'
      ReadOnly = True
    end
    object ZQuerygoodsnameforsite: TWideMemoField
      DisplayLabel = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
      FieldName = 'goodsnameforsite'
      ReadOnly = True
      BlobType = ftWideMemo
    end
    object ZQueryprice: TFloatField
      DisplayLabel = #1062#1077#1085#1072
      FieldName = 'price'
      ReadOnly = True
    end
    object ZQuerygoodsurl: TWideMemoField
      DisplayLabel = 'url'
      FieldName = 'goodsurl'
      ReadOnly = True
      BlobType = ftWideMemo
    end
  end
  object DataSource: TDataSource
    DataSet = ZQuery
    Left = 236
    Top = 108
  end
  object ActionList: TActionList
    Left = 56
    Top = 168
    object RunAction: TAction
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100
      OnExecute = RunActionExecute
      OnUpdate = RunActionUpdate
    end
    object SaveAction: TAction
      Caption = #1045#1082#1089#1087#1086#1088#1090
      OnExecute = SaveActionExecute
      OnUpdate = SaveActionUpdate
    end
    object RunAndExport: TAction
      Caption = #1057#1092#1086#1088#1084#1080#1085#1088#1086#1074#1072#1090' '#1080' '#1077#1082#1089#1087#1086#1088#1090#1080#1088#1086#1074#1072#1090#1100' '#1074#1089#1077' '#1086#1089#1090#1072#1083#1100#1085#1099#1077
      OnExecute = RunAndExportExecute
    end
  end
  object Timer: TTimer
    Enabled = False
    Interval = 3000
    OnTimer = TimerTimer
    Left = 148
    Top = 172
  end
end
