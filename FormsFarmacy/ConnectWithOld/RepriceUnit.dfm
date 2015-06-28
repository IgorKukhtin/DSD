object RepriceUnitForm: TRepriceUnitForm
  Left = 0
  Top = 0
  Caption = #1055#1077#1088#1077#1086#1094#1077#1085#1082#1072' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1081
  ClientHeight = 339
  ClientWidth = 455
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 328
    Top = 16
    Width = 81
    Height = 25
    Caption = #1055#1077#1088#1077#1086#1094#1077#1085#1080#1090#1100
    TabOrder = 0
  end
  object CheckListBox: TCheckListBox
    Left = 8
    Top = 8
    Width = 249
    Height = 321
    ItemHeight = 13
    TabOrder = 1
  end
  object GetUnitsList: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_UnitForReprice'
    DataSet = UnitsCDS
    DataSets = <
      item
        DataSet = UnitsCDS
      end>
    Params = <>
    PackSize = 1
    Left = 336
    Top = 64
  end
  object UnitsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 280
    Top = 64
  end
  object UnitsDS: TDataSource
    DataSet = UnitsCDS
    Left = 288
    Top = 120
  end
end
