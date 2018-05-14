object Report_SaleOrderExtList_MobileDialogForm: TReport_SaleOrderExtList_MobileDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072' <'#1057#1088#1072#1074#1085#1077#1085#1080#1077' '#1079#1072#1103#1074#1086#1082' '#1080' '#1087#1088#1086#1076#1072#1078'>'
  ClientHeight = 277
  ClientWidth = 334
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = actRefreshStart
  AddOnFormData.isSingle = False
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxButton1: TcxButton
    Left = 55
    Top = 243
    Width = 75
    Height = 23
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 189
    Top = 243
    Width = 75
    Height = 23
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object deEnd: TcxDateEdit
    Left = 8
    Top = 75
    EditValue = 42005d
    Properties.ShowTime = False
    TabOrder = 2
    Width = 100
  end
  object deStart: TcxDateEdit
    Left = 8
    Top = 27
    EditValue = 42005d
    Properties.ShowTime = False
    TabOrder = 3
    Width = 100
  end
  object cxLabel6: TcxLabel
    Left = 8
    Top = 7
    Caption = #1044#1072#1090#1072' '#1089' :'
  end
  object cxLabel7: TcxLabel
    Left = 8
    Top = 55
    Caption = #1044#1072#1090#1072' '#1087#1086' :'
  end
  object cxLabel8: TcxLabel
    Left = 8
    Top = 118
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
  end
  object edUnit: TcxButtonEdit
    Left = 8
    Top = 141
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 313
  end
  object cbSale: TcxCheckBox
    Left = 131
    Top = 27
    Hint = #1086#1090#1075#1088#1091#1078#1077#1085#1085#1099#1077' '#1079#1072#1103#1074#1082#1080
    Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1086#1090#1075#1088#1091#1078#1077#1085#1085#1099#1077' '#1079#1072#1103#1074#1082#1080
    Properties.ReadOnly = False
    TabOrder = 8
    Width = 184
  end
  object cbNoSale: TcxCheckBox
    Left = 131
    Top = 75
    Hint = #1085#1077' '#1086#1090#1075#1088#1091#1078#1077#1085#1085#1099#1077' '#1079#1072#1103#1074#1082#1080
    Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1086#1090#1075#1088#1091#1078#1077#1085#1085#1099#1077' '#1079#1072#1103#1074#1082#1080
    Properties.ReadOnly = False
    TabOrder = 9
    Width = 198
  end
  object cxLabel3: TcxLabel
    Left = 8
    Top = 172
    Caption = #1058#1086#1088#1075#1086#1074#1099#1081' '#1072#1075#1077#1085#1090':'
  end
  object edPersonalTrade: TcxButtonEdit
    Left = 8
    Top = 195
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 11
    Width = 313
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 56
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 160
    Top = 231
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = Owner
        Properties.Strings = (
          'Left'
          'Top')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 36
    Top = 65
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'StartDate'
        Value = 41579d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndDate'
        Value = 41608d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitId'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isSale'
        Value = Null
        Component = cbSale
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isNoSale'
        Value = Null
        Component = cbNoSale
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalTradeId'
        Value = Null
        Component = GuidesPersonalTrade
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalTradeName'
        Value = Null
        Component = GuidesPersonalTrade
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 208
    Top = 120
  end
  object GuidesUnit: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnit
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 112
    Top = 119
  end
  object GuidesPersonalTrade: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPersonalTrade
    Key = '0'
    FormNameParam.Value = 'TMemberPosition_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMemberPosition_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GuidesPersonalTrade
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPersonalTrade
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterPositionId'
        Value = '149831'
        MultiSelectSeparator = ','
      end>
    Left = 151
    Top = 160
  end
  object spGet_PersonalTrade: TdsdStoredProc
    StoredProcName = 'gpGetMobile_Object_Const'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'MemberId'
        Value = '0'
        Component = GuidesPersonalTrade
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberName'
        Value = ''
        Component = GuidesPersonalTrade
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 32
    Top = 184
  end
  object ActionList: TActionList
    Left = 195
    Top = 65
    object actGet_PersonalTrade: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_PersonalTrade
      StoredProcList = <
        item
          StoredProc = spGet_PersonalTrade
        end>
      Caption = 'actGet_PersonalTrade'
    end
    object actRefreshStart: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet_PersonalTrade
      StoredProcList = <
        item
          StoredProc = spGet_PersonalTrade
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
  end
end
