object QualityEditForm: TQualityEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1050#1072#1095#1077#1089#1090#1074#1077#1085#1085#1086#1077' '#1091#1076#1086#1089#1090#1086#1074#1077#1088#1077#1085#1080#1077'>'
  ClientHeight = 416
  ClientWidth = 358
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = dsdDataSetRefresh
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxButton1: TcxButton
    Left = 69
    Top = 386
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 1
  end
  object cxButton2: TcxButton
    Left = 213
    Top = 386
    Width = 75
    Height = 25
    Action = dsdFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 8
    TabOrder = 2
  end
  object Код: TcxLabel
    Left = 40
    Top = 7
    Caption = #1050#1086#1076
  end
  object ceCode: TcxCurrencyEdit
    Left = 40
    Top = 26
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 0
    Width = 120
  end
  object cxLabel5: TcxLabel
    Left = 40
    Top = 324
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object cxLabel6: TcxLabel
    Left = 40
    Top = 99
    Caption = #1070#1088' '#1083#1080#1094#1086
  end
  object edJuridical: TcxButtonEdit
    Left = 40
    Top = 117
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 6
    Width = 273
  end
  object ceComment: TcxTextEdit
    Left = 40
    Top = 342
    TabOrder = 7
    Width = 273
  end
  object edName: TcxTextEdit
    Left = 40
    Top = 73
    TabOrder = 8
    Width = 273
  end
  object cxLabel1: TcxLabel
    Left = 40
    Top = 56
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077
  end
  object cxLabel2: TcxLabel
    Left = 40
    Top = 144
    Caption = #1047#1072#1089#1090#1091#1087#1085#1080#1082' '#1076#1080#1088#1077#1082#1090#1086#1088#1072' '#1087#1110#1076#1087#1088#1080#1108#1084#1089#1090#1074#1072
  end
  object cxLabel3: TcxLabel
    Left = 40
    Top = 188
    Caption = #1058#1077#1093#1085#1086#1083#1086#1075' '#1074#1080#1088#1086#1073#1085#1080#1094#1090#1074#1072
  end
  object ceMemberMain: TcxTextEdit
    Left = 40
    Top = 164
    TabOrder = 12
    Width = 273
  end
  object ceMemberTech: TcxTextEdit
    Left = 40
    Top = 207
    TabOrder = 13
    Width = 273
  end
  object cxLabel4: TcxLabel
    Left = 40
    Top = 231
    Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100
  end
  object edRetail: TcxButtonEdit
    Left = 40
    Top = 249
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 15
    Width = 273
  end
  object cxLabel7: TcxLabel
    Left = 40
    Top = 276
    Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072
  end
  object edTradeMark: TcxButtonEdit
    Left = 40
    Top = 295
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 17
    Width = 273
  end
  object ceNumberPrint: TcxCurrencyEdit
    Left = 184
    Top = 26
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 18
    Width = 129
  end
  object cxLabel8: TcxLabel
    Left = 184
    Top = 7
    Caption = #1053#1086#1084#1077#1088' '#1087#1077#1095#1072#1090#1080
  end
  object ActionList: TActionList
    Left = 8
    Top = 77
    object dsdDataSetRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object dsdFormClose: TdsdFormClose
      MoveParams = <>
      PostDataSetBeforeExecute = False
    end
    object dsdInsertUpdateGuides: TdsdInsertUpdateGuides
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = #1054#1082
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_Quality'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = FormParams
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
        Value = Null
        Component = edName
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inNumberPrint'
        Value = Null
        Component = ceNumberPrint
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inMemberMain'
        Value = Null
        Component = ceMemberMain
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inMemberTech'
        Value = Null
        Component = ceMemberTech
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inComment'
        Value = Null
        Component = ceComment
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inJuridicalId'
        Value = ''
        Component = dsdJuridicalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inRetailId'
        Value = Null
        Component = RetailGuides
        ParamType = ptInput
      end
      item
        Name = 'inTradeMarkId'
        Value = Null
        Component = TradeMarkGuides
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 304
    Top = 93
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
      end>
    Left = 192
    Top = 40
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Quality'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'Id'
        Value = Null
        Component = FormParams
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
        Value = Null
        Component = edName
        DataType = ftString
      end
      item
        Name = 'NumberPrint'
        Value = Null
        Component = ceNumberPrint
        DataType = ftFloat
      end
      item
        Name = 'MemberMain'
        Value = Null
        Component = ceMemberMain
        DataType = ftString
      end
      item
        Name = 'MemberTech'
        Value = Null
        Component = ceMemberTech
        DataType = ftString
      end
      item
        Name = 'Comment'
        Value = Null
        Component = ceComment
        DataType = ftString
      end
      item
        Name = 'JuridicalId'
        Value = ''
        Component = dsdJuridicalGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'JuridicalName'
        Value = ''
        Component = dsdJuridicalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'RetailId'
        Value = Null
        Component = RetailGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'RetailName'
        Value = Null
        Component = RetailGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'TradeMarkId'
        Value = Null
        Component = TradeMarkGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TradeMarkName'
        Value = Null
        Component = TradeMarkGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    PackSize = 1
    Left = 288
    Top = 149
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
    Left = 312
    Top = 37
  end
  object dsdJuridicalGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edJuridical
    FormNameParam.Value = 'TJuridical_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TJuridical_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = dsdJuridicalGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = dsdJuridicalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 168
    Top = 112
  end
  object RetailGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edRetail
    FormNameParam.Value = 'TRetailForm'
    FormNameParam.DataType = ftString
    FormName = 'TRetailForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = RetailGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = RetailGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 176
    Top = 232
  end
  object TradeMarkGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edTradeMark
    FormNameParam.Value = 'TTradeMarkForm'
    FormNameParam.DataType = ftString
    FormName = 'TTradeMarkForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = TradeMarkGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = TradeMarkGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 168
    Top = 280
  end
end
