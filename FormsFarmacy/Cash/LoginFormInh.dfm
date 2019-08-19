inherited LoginForm1: TLoginForm1
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  inherited cxLabel1: TcxLabel
    Left = 2
    Top = 3
    Style.IsFontAssigned = True
    ExplicitLeft = 2
    ExplicitTop = 3
    AnchorX = 230
    AnchorY = 123
  end
  inherited cxLabel2: TcxLabel
    Style.IsFontAssigned = True
    AnchorX = 153
  end
  inherited cxLabel3: TcxLabel
    Style.IsFontAssigned = True
    AnchorX = 153
  end
  object cxLabel4: TcxLabel [7]
    Left = 102
    Top = 5
    Caption = #1040#1087#1090#1077#1082#1072':'
    ParentFont = False
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -13
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = []
    Style.IsFontAssigned = True
  end
  object edFarmacyName: TcxComboBox [8]
    Left = 152
    Top = 5
    TabOrder = 8
    Width = 204
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 16
    Top = 8
  end
  object spChekFarmacyName: TdsdStoredProc
    StoredProcName = 'gpGet_CheckFarmacyName_byUser'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'outIsEnter'
        Value = Null
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'outUnitId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitName'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 56
    Top = 88
  end
end
