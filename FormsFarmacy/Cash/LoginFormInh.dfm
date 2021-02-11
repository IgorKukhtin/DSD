inherited LoginForm1: TLoginForm1
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  inherited cxLabel1: TcxLabel
    Left = 2
    Top = 3
    ExplicitLeft = 2
    ExplicitTop = 3
    AnchorX = 230
    AnchorY = 123
  end
  inherited cxLabel2: TcxLabel
    AnchorX = 153
  end
  inherited cxLabel3: TcxLabel
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
    Left = 48
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
        Name = 'outUnitCode'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'outUnitName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitCode'
        Value = Null
        ParamType = ptInput
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
    Left = 48
    Top = 56
  end
  object spGetUnitName: TdsdStoredProc
    StoredProcName = 'gpGet_FarmacyUnitName'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'outUnitCode'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'outUnitName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitCode'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 48
    Top = 104
  end
  object ActionList1: TActionList
    Left = 104
    Top = 104
    object actLoginAdmin: TAction
      Caption = 'actLoginAdmin'
      ShortCut = 16469
      OnExecute = actLoginAdminExecute
    end
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'UnitId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 152
    Top = 104
  end
  object spGet_User_IsAdmin: TdsdStoredProc
    StoredProcName = 'gpGet_User_IsAdmin'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'gpGet_User_IsAdmin'
        Value = Null
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 232
    Top = 7
  end
end
