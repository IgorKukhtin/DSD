object RepriceUnitForm: TRepriceUnitForm
  Left = 0
  Top = 0
  Caption = #1055#1077#1088#1077#1086#1094#1077#1085#1082#1072' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1081
  ClientHeight = 339
  ClientWidth = 421
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
    OnClick = Button1Click
  end
  object CheckListBox: TCheckListBox
    Left = 8
    Top = 8
    Width = 249
    Height = 321
    ItemHeight = 13
    TabOrder = 1
  end
  object cePercentDifference: TcxCurrencyEdit
    Left = 288
    Top = 78
    EditValue = 30.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0.'
    TabOrder = 2
    Width = 121
  end
  object cxLabel1: TcxLabel
    Left = 288
    Top = 56
    Caption = '% '#1088#1072#1079#1085#1080#1094#1099' '#1094#1077#1085#1099
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
    Left = 184
    Top = 64
  end
  object UnitsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 112
    Top = 56
  end
  object UnitsDS: TDataSource
    DataSet = UnitsCDS
    Left = 112
    Top = 128
  end
  object ADOQuery: TADOQuery
    Connection = ADOConnection
    Parameters = <>
    Left = 120
    Top = 16
  end
  object ADOConnection: TADOConnection
    KeepConnection = False
    LoginPrompt = False
    Left = 184
    Top = 32
  end
  object spSelectPrice: TdsdStoredProc
    StoredProcName = 'gpSelect_GoodsPrice'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inGoodsCode'
        Value = Null
        ParamType = ptInput
      end
      item
        Name = 'inUnitId'
        Value = Null
        ParamType = ptInput
      end
      item
        Name = 'NewPrice'
        Value = Null
        DataType = ftFloat
      end>
    PackSize = 1
    Left = 192
    Top = 120
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 176
    Top = 184
  end
  object spInsertUpdate: TADOStoredProc
    Connection = ADOConnection
    ProcedureName = 'dba.InsertUpdateLastPriceList'
    Parameters = <
      item
        Name = '@CategoriesId'
        DataType = ftInteger
        Value = Null
      end
      item
        Name = '@LastPrice'
        DataType = ftFloat
        Value = Null
      end
      item
        Name = '@GoodsPropertyID'
        DataType = ftInteger
        Value = Null
      end
      item
        Name = '@StartDate'
        DataType = ftDateTime
        Value = Null
      end>
    Left = 280
    Top = 200
  end
end
