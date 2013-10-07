object CrossAddOnViewTest: TCrossAddOnViewTest
  Left = 0
  Top = 0
  Caption = 'CrossAddOnViewTest'
  ClientHeight = 337
  ClientWidth = 730
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
    Width = 537
    Height = 321
    TabOrder = 0
    object cxGrid1DBTableView1: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = DataDataSource
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      object cxGrid1DBTableView1Column1: TcxGridDBColumn
        DataBinding.FieldName = 'Name'
        Width = 277
      end
      object colTemplate: TcxGridDBColumn
        DataBinding.FieldName = 'Template'
      end
    end
    object cxGrid1Level1: TcxGridLevel
      GridView = cxGrid1DBTableView1
    end
  end
  object DBGrid1: TDBGrid
    Left = 551
    Top = 8
    Width = 185
    Height = 313
    DataSource = HorDataSource
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object DataDataSource: TDataSource
    DataSet = DataDS
    Left = 288
    Top = 104
  end
  object DataDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 224
    Top = 88
    object DataDSName: TStringField
      FieldName = 'Name'
      Size = 250
    end
    object DataDSTemplate1: TStringField
      FieldName = 'Template1'
      Size = 250
    end
    object DataDSTemplate2: TStringField
      FieldName = 'Template2'
      Size = 250
    end
  end
  object HorDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 224
    Top = 152
    object HorDSColumnName: TStringField
      FieldName = 'ColumnName'
      Size = 250
    end
    object HorDSDocumentId: TIntegerField
      FieldName = 'DocumentId'
    end
  end
  object HorDataSource: TDataSource
    DataSet = HorDS
    Left = 232
    Top = 248
  end
  object CrossDBViewAddOn: TCrossDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGrid1DBTableView1
    OnDblClickActionList = <>
    ActionItemList = <>
    HeaderDataSet = HorDS
    HeaderColumnName = 'ColumnName'
    TemplateColumn = colTemplate
    Left = 440
    Top = 32
  end
end
