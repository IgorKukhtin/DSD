﻿object RouteEditForm: TRouteEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1052#1072#1088#1096#1088#1091#1090'>'
  ClientHeight = 397
  ClientWidth = 382
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = dsdDataSetRefresh
  AddOnFormData.Params = dsdFormParams
  PixelsPerInch = 96
  TextHeight = 13
  object edRouteName: TcxTextEdit
    Left = 32
    Top = 88
    TabOrder = 0
    Width = 273
  end
  object cxLabel1: TcxLabel
    Left = 32
    Top = 63
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077
  end
  object cxButton1: TcxButton
    Left = 72
    Top = 346
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 216
    Top = 346
    Width = 75
    Height = 25
    Action = dsdFormClose1
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 8
    TabOrder = 3
  end
  object Код: TcxLabel
    Left = 32
    Top = 19
    Caption = #1050#1086#1076
  end
  object ceCode: TcxCurrencyEdit
    Left = 32
    Top = 42
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 5
    Width = 273
  end
  object ceUnit: TcxButtonEdit
    Left = 32
    Top = 196
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 6
    Width = 273
  end
  object cxLabel7: TcxLabel
    Left = 32
    Top = 173
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
  end
  object cxLabel2: TcxLabel
    Left = 32
    Top = 223
    Caption = #1058#1080#1087' '#1084#1072#1088#1096#1088#1091#1090#1072
  end
  object ceRouteKind: TcxButtonEdit
    Left = 32
    Top = 246
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 9
    Width = 273
  end
  object cxLabel3: TcxLabel
    Left = 32
    Top = 279
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1075#1088#1091#1079#1072
  end
  object ceFreight: TcxButtonEdit
    Left = 32
    Top = 302
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 11
    Width = 273
  end
  object cxLabel4: TcxLabel
    Left = 32
    Top = 125
    Caption = #1060#1080#1083#1080#1072#1083
  end
  object ceBranch: TcxButtonEdit
    Left = 32
    Top = 145
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 13
    Width = 273
  end
  object ActionList: TActionList
    Left = 328
    Top = 10
    object dsdDataSetRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object dsdFormClose1: TdsdFormClose
      MoveParams = <>
    end
    object dsdInsertUpdateGuides: TdsdInsertUpdateGuides
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = #1054#1082
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_Route'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inCode'
        Value = 0.000000000000000000
        Component = ceCode
        ParamType = ptInput
      end
      item
        Name = 'inName'
        Value = ''
        Component = edRouteName
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inUnit'
        Value = ''
        Component = UnitGuides
        ParamType = ptInput
      end
      item
        Name = 'inBranch'
        Value = ''
        Component = BranchGuides
        ParamType = ptInput
      end
      item
        Name = 'inRouteKind'
        Value = ''
        Component = RouteKindGuides
        ParamType = ptInput
      end
      item
        Name = 'inFreight'
        Value = ''
        Component = FreightGuides
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 328
    Top = 72
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
      end>
    Left = 248
    Top = 104
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Route'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'Id'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'Code'
        Value = 0.000000000000000000
        Component = ceCode
      end
      item
        Name = 'Name'
        Value = ''
        Component = edRouteName
        DataType = ftString
      end
      item
        Name = 'UnitId'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'UnitName'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'BranchId'
        Value = ''
        Component = BranchGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'BranchName'
        Value = ''
        Component = BranchGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'RouteKindId'
        Value = ''
        Component = RouteKindGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'RouteKindName'
        Value = ''
        Component = RouteKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'FreightId'
        Value = ''
        Component = FreightGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'FreightName'
        Value = ''
        Component = FreightGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    PackSize = 1
    Left = 328
    Top = 130
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 96
    Top = 72
  end
  object dsdUserSettingsStorageAddOn1: TdsdUserSettingsStorageAddOn
    Left = 128
  end
  object UnitGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceUnit
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 127
    Top = 193
  end
  object RouteKindGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceRouteKind
    FormNameParam.Value = 'TRouteKindForm'
    FormNameParam.DataType = ftString
    FormName = 'TRouteKindForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = RouteKindGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = RouteKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 175
    Top = 241
  end
  object FreightGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceFreight
    FormNameParam.Value = 'TFreightForm'
    FormNameParam.DataType = ftString
    FormName = 'TFreightForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = FreightGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = FreightGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 167
    Top = 297
  end
  object BranchGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceBranch
    FormNameParam.Value = 'TBranchForm'
    FormNameParam.DataType = ftString
    FormName = 'TBranchForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = BranchGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = BranchGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 130
    Top = 132
  end
end
