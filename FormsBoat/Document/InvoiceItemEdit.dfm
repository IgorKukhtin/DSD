object InvoiceItemEditForm: TInvoiceItemEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090' '#1057#1095#1077#1090#1072'>'
  ClientHeight = 267
  ClientWidth = 420
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = actRefresh
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxLabel1: TcxLabel
    Left = 8
    Top = 56
    Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077
  end
  object cxButtonOK: TcxButton
    Left = 196
    Top = 234
    Width = 90
    Height = 25
    Action = actInsertUpdate
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
  end
  object cxButtonCancel: TcxButton
    Left = 313
    Top = 234
    Width = 90
    Height = 25
    Action = actFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
  end
  object edGoodsName: TcxButtonEdit
    Left = 8
    Top = 79
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 3
    Width = 401
  end
  object cxLabel18: TcxLabel
    Left = 8
    Top = 116
    Caption = #1050#1086#1083'-'#1074#1086
  end
  object ceAmount: TcxCurrencyEdit
    Left = 8
    Top = 136
    ParentFont = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.EditFormat = ',0.####'
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clBlue
    Style.Font.Height = -11
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = [fsBold]
    Style.TextColor = clBlack
    Style.IsFontAssigned = True
    TabOrder = 0
    Width = 120
  end
  object cxLabel14: TcxLabel
    Left = 8
    Top = 8
    Caption = 'Interne Nr'
  end
  object edGoodsCode: TcxTextEdit
    Left = 8
    Top = 26
    Properties.ReadOnly = True
    TabOrder = 8
    Width = 120
  end
  object cxLabel3: TcxLabel
    Left = 146
    Top = 8
    Caption = 'Artikel Nr'
  end
  object edArticle: TcxTextEdit
    Left = 146
    Top = 26
    Properties.ReadOnly = True
    TabOrder = 10
    Width = 103
  end
  object cxLabel5: TcxLabel
    Left = 146
    Top = 116
    Hint = #1062#1077#1085#1072' '#1073#1077#1079' '#1053#1044#1057
    Caption = #1062#1077#1085#1072' '#1073#1077#1079' '#1053#1044#1057
  end
  object ceOperPrice: TcxCurrencyEdit
    Left = 146
    Top = 136
    Hint = #1042#1093'. '#1094#1077#1085#1072' '#1089' '#1091#1095#1077#1090#1086#1084' '#1089#1082#1080#1076#1082#1080
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.EditFormat = ',0.####'
    ShowHint = True
    TabOrder = 1
    Width = 128
  end
  object ceComment: TcxTextEdit
    Left = 8
    Top = 197
    TabOrder = 12
    Width = 401
  end
  object cxLabel16: TcxLabel
    Left = 8
    Top = 174
    Caption = #1054#1087#1080#1089#1072#1085#1080#1077
  end
  object btnGoodsChoiceForm: TcxButton
    Left = 8
    Top = 234
    Width = 150
    Height = 25
    Hint = #1042#1099#1073#1086#1088' '#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077
    Action = actGoodsChoiceForm
    ParentShowHint = False
    ShowHint = True
    TabOrder = 14
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 196
    Top = 213
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end>
      Caption = 'actRefresh'
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actInsertUpdate: TdsdInsertUpdateGuides
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = #1054#1082
      ImageIndex = 80
    end
    object actFormClose: TdsdFormClose
      MoveParams = <>
      PostDataSetBeforeExecute = False
      ImageIndex = 52
    end
    object actRefresh_Price: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <
        item
        end>
      Caption = 'actRefresh_Price'
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actGoodsChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077
      ImageIndex = 7
      FormName = 'TGoodsForm'
      FormNameParam.Value = 'TGoodsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = GuidesGoods
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = GuidesGoods
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = edGoodsCode
          MultiSelectSeparator = ','
        end
        item
          Name = 'Article'
          Value = Null
          Component = edArticle
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'EKPrice'
          Value = Null
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'BasisPrice'
          Value = Null
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'EmpfPrice'
          Value = Null
          DataType = ftFloat
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_Invoice'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = GuidesGoods
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = 2.000000000000000000
        Component = ceAmount
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperPrice'
        Value = Null
        Component = ceOperPrice
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = ceComment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 260
    Top = 49
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsId'
        Value = Null
        Component = GuidesGoods
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end>
    Left = 184
    Top = 16
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_MovementItem_Invoice'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsId'
        Value = Null
        Component = GuidesGoods
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsName'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsCode'
        Value = Null
        Component = edGoodsCode
        MultiSelectSeparator = ','
      end
      item
        Name = 'Article'
        Value = Null
        Component = edArticle
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Amount'
        Value = Null
        Component = ceAmount
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperPrice'
        Value = Null
        Component = ceOperPrice
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment'
        Value = Null
        Component = ceComment
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 264
    Top = 1
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
    Left = 352
    Top = 169
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 208
    Top = 192
  end
  object GuidesGoods: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoodsName
    FormNameParam.Value = 'TGoodsForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsForm'
    PositionDataSet = 'ClientDataSet'
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
      end
      item
        Name = 'Code'
        Value = Null
        Component = edGoodsCode
        MultiSelectSeparator = ','
      end
      item
        Name = 'Article'
        Value = Null
        Component = edArticle
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 201
    Top = 63
  end
  object HeaderExit: THeaderExit
    ExitList = <
      item
        Control = ceAmount
      end
      item
      end
      item
      end
      item
        Control = ceOperPrice
      end
      item
      end>
    Action = actRefresh_Price
    Left = 276
    Top = 221
  end
  object GuidesFiller: TGuidesFiller
    IdParam.Value = Null
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    IdParam.MultiSelectSeparator = ','
    GuidesList = <>
    ActionItemList = <>
    Left = 352
    Top = 112
  end
  object EnterMoveNext: TEnterMoveNext
    EnterMoveNextList = <
      item
        Control = ceAmount
      end
      item
      end
      item
      end
      item
        Control = ceOperPrice
      end
      item
      end
      item
      end
      item
        Control = cxButtonOK
      end>
    Left = 28
    Top = 214
  end
end
