object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = #1058#1077#1089#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1087#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100#1085#1086#1089#1090#1080
  ClientHeight = 421
  ClientWidth = 899
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid1: TcxGrid
    Left = 8
    Top = 8
    Width = 699
    Height = 225
    TabOrder = 0
    object cxGrid1DBTableView1: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = DataSource1
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
    end
    object cxGrid1Level1: TcxGridLevel
      GridView = cxGrid1DBTableView1
    end
  end
  object cxGrid2: TcxGrid
    Left = 8
    Top = 239
    Width = 699
    Height = 161
    TabOrder = 1
    object cxGrid2DBTableView1: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = DataSource2
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
    end
    object cxGrid2Level1: TcxGridLevel
      GridView = cxGrid2DBTableView1
    end
  end
  object Button1: TButton
    Left = 721
    Top = 8
    Width = 170
    Height = 25
    Caption = 'gp_Test_Insert1'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 721
    Top = 48
    Width = 170
    Height = 25
    Caption = 'gp_Test_Insert2'
    TabOrder = 3
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 721
    Top = 79
    Width = 170
    Height = 49
    Caption = 'gp_Select_Master gp_Select_Child'
    TabOrder = 4
    WordWrap = True
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 721
    Top = 134
    Width = 170
    Height = 46
    Caption = 'gp_Select_Master_cur gp_Select_Child_cur'
    TabOrder = 5
    WordWrap = True
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 721
    Top = 186
    Width = 170
    Height = 25
    Caption = 'gp_Select_Master_Child_cur'
    TabOrder = 6
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 721
    Top = 340
    Width = 170
    Height = 25
    Caption = 'CreateTestData'
    TabOrder = 7
    OnClick = Button6Click
  end
  object Button7: TButton
    Left = 721
    Top = 239
    Width = 170
    Height = 25
    Caption = 'gp_Test_Insert3'
    TabOrder = 8
    OnClick = Button7Click
  end
  object Button8: TButton
    Left = 721
    Top = 286
    Width = 170
    Height = 25
    Caption = 'gp_Test_Insert4'
    TabOrder = 9
    OnClick = Button8Click
  end
  object cxProgressBar1: TcxProgressBar
    Left = 721
    Top = 216
    TabOrder = 10
    Width = 170
  end
  object DataSource1: TDataSource
    DataSet = ClientDataSet1
    Left = 56
    Top = 32
  end
  object DataSource2: TDataSource
    DataSet = ClientDataSet2
    Left = 48
    Top = 264
  end
  object ClientDataSet1: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 96
    Top = 40
  end
  object ClientDataSet2: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 104
    Top = 264
  end
  object ZConnection: TZConnection
    ControlsCodePage = cCP_UTF16
    UTF8StringsAsWideField = True
    HostName = 'localhost'
    Port = 5432
    Database = 'dsd'
    User = 'postgres'
    Password = 'postgres'
    Protocol = 'postgresql-9'
    Left = 224
    Top = 80
  end
  object ZQuery: TZQuery
    Connection = ZConnection
    Params = <>
    Left = 272
    Top = 96
  end
end
