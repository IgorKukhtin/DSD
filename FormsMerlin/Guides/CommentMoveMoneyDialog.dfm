object CommentMoveMoneyDialogForm: TCommentMoveMoneyDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1042#1099#1073#1086#1088
  ClientHeight = 142
  ClientWidth = 340
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.Params = FormParams
  DesignSize = (
    340
    142)
  PixelsPerInch = 96
  TextHeight = 13
  object cxButton1: TcxButton
    Left = 42
    Top = 96
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 216
    Top = 96
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object edCommentMoveMoney: TcxButtonEdit
    Left = 8
    Top = 43
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 2
    Width = 315
  end
  object cxLabel3: TcxLabel
    Left = 10
    Top = 20
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' '#1044#1074#1080#1078#1077#1085#1080#1077' '#1076#1077#1085#1077#1075':'
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 206
    Top = 28
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
    Left = 271
    Top = 61
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'CommentMoveMoneyName'
        Value = ''
        Component = edCommentMoveMoney
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 142
    Top = 65531
  end
  object GuidesCommentMoveMoney: TdsdGuides
    KeyField = 'Id'
    LookupControl = edCommentMoveMoney
    Key = '0'
    FormNameParam.Value = 'TCommentInfoMoneyForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TCommentInfoMoneyForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesCommentMoveMoney
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesCommentMoveMoney
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'AreaName'
        Value = Null
        Component = FormParams
        ComponentItem = 'AreaName'
        MultiSelectSeparator = ','
      end>
    Left = 86
    Top = 43
  end
end
