object Form3: TForm3
  Left = 0
  Top = 0
  Caption = 'Form3'
  ClientHeight = 379
  ClientWidth = 684
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object dxBevel1: TdxBevel
    Left = 590
    Top = 208
    Width = 50
    Height = 50
  end
  object cxButton1: TcxButton
    Left = 547
    Top = 135
    Width = 75
    Height = 25
    Caption = 'cxButton1'
    TabOrder = 0
  end
  object cxGroupBox1: TcxGroupBox
    Left = 491
    Top = 8
    Caption = 'cxGroupBox1'
    TabOrder = 1
    Height = 105
    Width = 185
  end
  object cxGrid1: TcxGrid
    Left = 4
    Top = 8
    Width = 537
    Height = 273
    TabOrder = 2
    object cxGrid1DBTableView1: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
    end
    object cxGrid1Level1: TcxGridLevel
      GridView = cxGrid1DBTableView1
    end
  end
  object DataSource1: TDataSource
    DataSet = ClientDataSet1
    Left = 184
    Top = 160
  end
  object ClientDataSet1: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 248
    Top = 208
  end
end
