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
  PixelsPerInch = 96
  TextHeight = 13
  object ButtonPanel: TPanel
    Left = 0
    Top = 0
    Width = 624
    Height = 41
    Align = alTop
    TabOrder = 0
    object ExportButton: TButton
      Left = 111
      Top = 8
      Width = 97
      Height = 25
      Caption = #1045#1082#1089#1087#1086#1088#1090
      TabOrder = 1
    end
    object RunButton: TButton
      Left = 8
      Top = 8
      Width = 97
      Height = 25
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100
      TabOrder = 0
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
      DataController.DataSource = DataSource1
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
    end
    object ExportGridLevel1: TcxGridLevel
      GridView = ExportGridDBTableView1
    end
  end
  object ZConnection1: TZConnection
    ControlsCodePage = cCP_UTF16
    Port = 0
    Left = 56
    Top = 108
  end
  object ZReadOnlyQuery1: TZReadOnlyQuery
    Connection = ZConnection1
    Params = <>
    Left = 152
    Top = 108
  end
  object DataSource1: TDataSource
    DataSet = ZReadOnlyQuery1
    Left = 256
    Top = 108
  end
end
