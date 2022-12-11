object Report_GeneralMovementGoodsDialogForm: TReport_GeneralMovementGoodsDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072' <'#1044#1086#1093#1086#1076#1085#1086#1089#1090#1080'>'
  ClientHeight = 315
  ClientWidth = 333
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = actRefreshStart
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxButton1: TcxButton
    Left = 41
    Top = 271
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 6
  end
  object cxButton2: TcxButton
    Left = 215
    Top = 271
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 7
  end
  object deEnd: TcxDateEdit
    Left = 121
    Top = 27
    EditValue = 42400d
    Properties.ShowTime = False
    TabOrder = 1
    Width = 90
  end
  object deStart: TcxDateEdit
    Left = 10
    Top = 27
    EditValue = 42370d
    Properties.ShowTime = False
    TabOrder = 0
    Width = 90
  end
  object edUnit: TcxButtonEdit
    Left = 8
    Top = 80
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 2
    Width = 305
  end
  object cxLabel3: TcxLabel
    Left = 8
    Top = 60
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
  end
  object cxLabel6: TcxLabel
    Left = 10
    Top = 7
    Caption = #1044#1072#1090#1072' '#1089' :'
  end
  object cxLabel7: TcxLabel
    Left = 121
    Top = 7
    Caption = #1044#1072#1090#1072' '#1087#1086' :'
  end
  object edGoodsSearch: TcxTextEdit
    Left = 8
    Top = 212
    Hint = #1053#1072#1078#1084#1080#1090#1077' Ctrl+Enter '#1076#1083#1103' '#1087#1086#1080#1089#1082#1072
    TabOrder = 5
    Width = 305
  end
  object cxLabel2: TcxLabel
    Left = 8
    Top = 148
    Caption = #1060#1080#1083#1100#1090#1088' '#1087#1086' '#1082#1086#1076#1091
  end
  object edCodeSearch: TcxTextEdit
    Left = 8
    Top = 168
    Hint = #1053#1072#1078#1084#1080#1090#1077' Enter '#1076#1083#1103' '#1087#1086#1080#1089#1082#1072
    TabOrder = 4
    Width = 305
  end
  object cxLabel1: TcxLabel
    Left = 8
    Top = 191
    Caption = #1060#1080#1083#1100#1090#1088' '#1090#1086#1074#1072#1088#1072
  end
  object edGoods: TcxButtonEdit
    Left = 8
    Top = 123
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 3
    Width = 305
  end
  object cxLabel4: TcxLabel
    Left = 10
    Top = 105
    Caption = #1058#1086#1074#1072#1088
  end
  object cbNeBoley: TcxCheckBox
    Left = 16
    Top = 240
    Caption = #1085#1072#1096' '#1089#1072#1081#1090
    TabOrder = 14
    Width = 80
  end
  object cbMobile: TcxCheckBox
    Left = 121
    Top = 239
    Caption = #1087#1088#1080#1083#1086#1078#1077#1085#1080#1077
    TabOrder = 15
    Width = 80
  end
  object cbTabletki: TcxCheckBox
    Left = 233
    Top = 239
    Caption = #1090#1072#1073#1083#1077#1090#1082#1080
    TabOrder = 16
    Width = 80
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 39
    Top = 27
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 230
    Top = 25
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
    Left = 215
    Top = 71
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
        Name = 'GoodsId'
        Value = Null
        Component = GuidesGoods
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsName'
        Value = Null
        Component = GuidesGoods
        ComponentItem = 'TextValue'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'CodeSearch'
        Value = Null
        Component = edCodeSearch
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsSearch'
        Value = Null
        Component = edGoodsSearch
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isNeBoley'
        Value = Null
        Component = cbNeBoley
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isMobile'
        Value = Null
        Component = cbMobile
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isTabletki'
        Value = Null
        Component = cbTabletki
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    Left = 38
    Top = 105
  end
  object GuidesUnit: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnit
    Key = '0'
    FormNameParam.Value = 'TUnitTreeForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnitTreeForm'
    PositionDataSet = 'ClientDataSet'
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
    Left = 118
    Top = 73
  end
  object ActionList: TActionList
    Left = 155
    Top = 26
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actGet_UserUnit: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = 'actGet_UserUnit'
    end
    object actRefreshStart: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <
        item
        end
        item
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
  end
  object GuidesGoods: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoods
    FormNameParam.Value = 'TGoodsLiteForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsLiteForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 152
    Top = 112
  end
end
