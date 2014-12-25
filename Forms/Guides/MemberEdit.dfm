inherited MemberEditForm: TMemberEditForm
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1060#1080#1079#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086'>'
  ClientHeight = 351
  ClientWidth = 287
  ExplicitWidth = 293
  ExplicitHeight = 376
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 45
    Top = 313
    TabOrder = 1
    ExplicitLeft = 45
    ExplicitTop = 313
  end
  inherited bbCancel: TcxButton
    Left = 177
    Top = 313
    TabOrder = 2
    ExplicitLeft = 177
    ExplicitTop = 313
  end
  object cxPageControl1: TcxPageControl [2]
    Left = 0
    Top = 0
    Width = 287
    Height = 309
    Align = alTop
    TabOrder = 0
    Properties.ActivePage = tsCommon
    Properties.CustomButtons.Buttons = <>
    ClientRectBottom = 309
    ClientRectRight = 287
    ClientRectTop = 24
    object tsCommon: TcxTabSheet
      Caption = #1054#1073#1097#1080#1077' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 0
      object edMeasureName: TcxTextEdit
        Left = 7
        Top = 77
        TabOrder = 1
        Width = 273
      end
      object cxLabel1: TcxLabel
        Left = 7
        Top = 54
        Caption = #1060#1048#1054
      end
      object Код: TcxLabel
        Left = 7
        Top = 4
        Caption = #1050#1086#1076
      end
      object ceCode: TcxCurrencyEdit
        Left = 7
        Top = 27
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = '0'
        TabOrder = 0
        Width = 273
      end
      object ceINN: TcxTextEdit
        Left = 7
        Top = 153
        TabOrder = 3
        Width = 273
      end
      object cxLabel2: TcxLabel
        Left = 7
        Top = 134
        Caption = #1048#1053#1053
      end
      object cxLabel3: TcxLabel
        Left = 7
        Top = 182
        Caption = #1042#1086#1076#1080#1090#1077#1083#1100#1089#1082#1086#1077' '#1091#1076#1086#1089#1090#1086#1074#1077#1088#1077#1085#1080#1077
      end
      object cxLabel4: TcxLabel
        Left = 7
        Top = 230
        Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
      end
      object ceDriverCertificate: TcxTextEdit
        Left = 7
        Top = 205
        TabOrder = 4
        Width = 273
      end
      object ceComment: TcxTextEdit
        Left = 7
        Top = 253
        TabOrder = 5
        Width = 273
      end
      object cbOfficial: TcxCheckBox
        Left = 7
        Top = 108
        Hint = #1054#1092#1086#1088#1084#1083#1077#1085' '#1086#1092#1080#1094#1080#1072#1083#1100#1085#1086
        Caption = #1054#1092#1086#1088#1084#1083#1077#1085' '#1086#1092#1080#1094#1080#1072#1083#1100#1085#1086
        TabOrder = 2
        Width = 141
      end
    end
    object tsContact: TcxTabSheet
      Caption = #1050#1086#1085#1090#1072#1082#1090#1085#1099#1077' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 1
      object cxLabel5: TcxLabel
        Left = 7
        Top = 4
        Caption = 'E-mail'
      end
      object edEmail: TcxTextEdit
        Left = 7
        Top = 25
        TabOrder = 1
        Width = 273
      end
      object cxLabel6: TcxLabel
        Left = 7
        Top = 55
        Caption = 'E-mail '#1087#1086#1076#1087#1080#1089#1100
      end
      object EMailSign: TcxMemo
        Left = 7
        Top = 76
        TabOrder = 3
        Height = 145
        Width = 273
      end
    end
  end
  inherited ActionList: TActionList
    Images = dmMain.ImageList
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spGetMemberContact
        end>
    end
    inherited InsertUpdateGuides: TdsdInsertUpdateGuides
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end
        item
          StoredProc = spInsertUpdateContact
        end>
    end
  end
  inherited FormParams: TdsdFormParams
    Left = 24
  end
  inherited spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_Member'
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
        Value = ''
        Component = edMeasureName
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inIsOfficial'
        Value = 'False'
        Component = cbOfficial
        DataType = ftBoolean
        ParamType = ptInput
      end
      item
        Name = 'inINN'
        Value = ''
        Component = ceINN
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inDriverCertificate'
        Value = ''
        Component = ceDriverCertificate
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inComment'
        Value = ''
        Component = ceComment
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 224
    Top = 48
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Member'
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
        Value = ''
        Component = edMeasureName
        DataType = ftString
      end
      item
        Name = 'IsOfficial'
        Value = 'False'
        Component = cbOfficial
        DataType = ftBoolean
      end
      item
        Name = 'INN'
        Value = ''
        Component = ceINN
        DataType = ftString
      end
      item
        Name = 'DriverCertificate'
        Value = ''
        Component = ceDriverCertificate
        DataType = ftString
      end
      item
        Name = 'Comment'
        Value = ''
        Component = ceComment
        DataType = ftString
      end>
    Top = 136
  end
  object spInsertUpdateContact: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_MemberContact'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inEmail'
        Value = 0.000000000000000000
        Component = edEmail
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inEmailSign'
        Value = Null
        Component = EMailSign
        DataType = ftWideString
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 144
    Top = 48
  end
  object spGetMemberContact: TdsdStoredProc
    StoredProcName = 'gpGet_Object_MemberContact'
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
        Name = 'EMail'
        Value = ''
        Component = edEmail
        DataType = ftString
      end
      item
        Name = 'EMailSign'
        Value = Null
        Component = EMailSign
        DataType = ftString
      end>
    PackSize = 1
    Left = 136
    Top = 136
  end
end
