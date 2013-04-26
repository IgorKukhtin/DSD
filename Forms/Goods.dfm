object GoodsForm: TGoodsForm
  Left = 0
  Top = 0
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' '#1090#1086#1074#1072#1088#1086#1074
  ClientHeight = 376
  ClientWidth = 645
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid: TcxGrid
    Left = 0
    Top = 0
    Width = 645
    Height = 376
    Align = alClient
    TabOrder = 0
    object cxGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = DataSource
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      object clName: TcxGridDBColumn
        Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
        DataBinding.FieldName = 'Name'
        Width = 374
      end
      object clLogin: TcxGridDBColumn
        DataBinding.FieldName = 'Login'
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 96
    Top = 96
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 136
    Top = 144
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = clLogin
        Properties.Strings = (
          'Width')
      end
      item
        Component = clName
        Properties.Strings = (
          'Width')
      end>
    StorageName = 'cxPropertiesStore'
    Left = 272
    Top = 128
  end
end
