object Report_Check_PromoBonusDiscoDialogForm: TReport_Check_PromoBonusDiscoDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072' <'#1044#1080#1089#1082#1086#1090#1077#1082#1072' '#1087#1086' '#1084#1072#1088#1082#1077#1090' '#1073#1086#1085#1091#1089#1072#1084'>'
  ClientHeight = 229
  ClientWidth = 332
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxButton1: TcxButton
    Left = 32
    Top = 188
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 208
    Top = 188
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object deStart: TcxDateEdit
    Left = 10
    Top = 38
    EditValue = 42370d
    Properties.DisplayFormat = 'mmmm yyyy'
    Properties.ShowTime = False
    TabOrder = 2
    Width = 127
  end
  object edGoods: TcxButtonEdit
    Left = 8
    Top = 149
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 3
    Width = 305
  end
  object cxLabel3: TcxLabel
    Left = 8
    Top = 129
    Caption = #1058#1086#1074#1072#1088':'
  end
  object cxLabel6: TcxLabel
    Left = 10
    Top = 18
    Caption = #1052#1077#1089#1103#1094' '#1088#1072#1089#1095#1077#1090#1072':'
  end
  object ceUnit: TcxButtonEdit
    Left = 8
    Top = 95
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    Properties.UseNullString = True
    TabOrder = 6
    Width = 305
  end
  object cxLabel1: TcxLabel
    Left = 6
    Top = 72
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
  end
  object deEnd: TcxDateEdit
    Left = 156
    Top = 38
    EditValue = 42370d
    Properties.DisplayFormat = 'mmmm yyyy'
    Properties.ShowTime = False
    TabOrder = 8
    Width = 112
  end
  object cxLabel2: TcxLabel
    Left = 156
    Top = 18
    Caption = #1052#1077#1089#1103#1094' '#1089#1088#1072#1074#1085#1077#1085#1080#1103' :'
  end
  object cxLabel5: TcxLabel
    Left = 12
    Top = 1
    Caption = #1055#1088#1086#1076#1072#1078#1080' '#1087#1086' '#1084#1072#1088#1082#1077#1090#1080#1085#1075#1086#1074#1099#1084' '#1073#1086#1085#1091#1089#1072' '#1087#1086#1096#1083#1080' '#1089'  23.02.21 '
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 159
    Top = 171
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 214
    Top = 57
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
    Left = 247
    Top = 207
  end
  object GoodsGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoods
    Key = '0'
    FormNameParam.Value = 'TGoodsLiteForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsLiteForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GoodsGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 182
    Top = 137
  end
  object ActionList: TActionList
    Left = 267
    Top = 34
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
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'StartDate'
        Value = 42370d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'DateComparison'
        Value = Null
        Component = deEnd
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitId'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsId'
        Value = '0'
        Component = GoodsGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsName'
        Value = ''
        Component = GoodsGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 30
    Top = 177
  end
  object UnitGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceUnit
    FormNameParam.Value = 'TUnitTreeForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnitTreeForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 136
    Top = 91
  end
end
