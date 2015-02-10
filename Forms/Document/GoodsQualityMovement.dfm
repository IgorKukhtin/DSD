inherited GoodsQualityMovementForm: TGoodsQualityMovementForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1050#1072#1095#1077#1089#1090#1074#1077#1085#1085#1086#1077' '#1091#1076#1086#1089#1090#1086#1074#1077#1088#1077#1085#1080#1077'>'
  ClientHeight = 436
  ClientWidth = 777
  AddOnFormData.isSingle = False
  ExplicitWidth = 783
  ExplicitHeight = 468
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 264
    Top = 402
    Height = 26
    ExplicitLeft = 264
    ExplicitTop = 402
    ExplicitHeight = 26
  end
  inherited bbCancel: TcxButton
    Left = 408
    Top = 402
    Height = 26
    ExplicitLeft = 408
    ExplicitTop = 402
    ExplicitHeight = 26
  end
  object cxLabel1: TcxLabel [2]
    Left = 184
    Top = 5
    Caption = #1044#1072#1090#1072
  end
  object Код: TcxLabel [3]
    Left = 8
    Top = 5
    Caption = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
  end
  object cxLabel4: TcxLabel [4]
    Left = 9
    Top = 100
    Caption = #1050#1072#1095#1077#1089#1090#1074#1077#1085#1085#1086#1077' '#1091#1076#1086#1089#1090#1086#1074#1077#1088#1077#1085#1080#1077
  end
  object ceGoodsQualityForm: TcxButtonEdit [5]
    Left = 8
    Top = 119
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 3
    Width = 273
  end
  object ceOperDate: TcxDateEdit [6]
    Left = 184
    Top = 24
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 2
    Width = 97
  end
  object cxLabel9: TcxLabel [7]
    Left = 287
    Top = 5
    Caption = #1042#1077#1090#1077#1088#1080#1085#1072#1088#1085#1077' '#1089#1074#1110#1076#1086#1094#1090#1074#1086' '#1076#1072#1090#1072
  end
  object ceOperDateCertificate: TcxDateEdit [8]
    Left = 287
    Top = 24
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 8
    Width = 151
  end
  object edCertificateNumber: TcxTextEdit [9]
    Left = 444
    Top = 24
    TabOrder = 9
    Width = 152
  end
  object cxLabel11: TcxLabel [10]
    Left = 444
    Top = 5
    Caption = #1042#1077#1090#1077#1088#1080#1085#1072#1088#1085#1077' '#1089#1074#1110#1076#1086#1094#1090#1074#1086' '#8470
  end
  object edInvNumber: TcxTextEdit [11]
    Left = 8
    Top = 24
    Properties.ReadOnly = True
    TabOrder = 11
    Text = '0'
    Width = 156
  end
  object ceComment: TcxMemo [12]
    Left = 8
    Top = 168
    TabOrder = 12
    Height = 217
    Width = 760
  end
  object cxLabel2: TcxLabel [13]
    Left = 8
    Top = 145
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object cxLabel3: TcxLabel [14]
    Left = 602
    Top = 5
    Caption = #1042#1077#1090#1077#1088#1080#1085#1072#1088#1085#1077' '#1089#1074#1110#1076#1086#1094#1090#1074#1086' '#1057#1077#1088#1110#1103
  end
  object edCertificateSeries: TcxTextEdit [15]
    Left = 602
    Top = 24
    TabOrder = 15
    Width = 166
  end
  object cxLabel5: TcxLabel [16]
    Left = 8
    Top = 53
    Caption = #1042#1077#1090#1077#1088#1080#1085#1072#1088#1085#1077' '#1089#1074#1110#1076#1086#1094#1090#1074#1086' '#1057#1077#1088#1110#1103' '#8470
  end
  object edCertificateSeriesNumber: TcxTextEdit [17]
    Left = 8
    Top = 72
    TabOrder = 17
    Width = 169
  end
  object cxLabel6: TcxLabel [18]
    Left = 183
    Top = 53
    Caption = #1045#1082#1089#1087#1077#1088#1090#1085#1080#1081' '#1074#1080#1089#1085#1086#1074#1086#1082
  end
  object edExpertPrior: TcxTextEdit [19]
    Left = 183
    Top = 72
    TabOrder = 19
    Width = 169
  end
  object cxLabel7: TcxLabel [20]
    Left = 358
    Top = 53
    Caption = #1045#1082#1089#1087#1077#1088#1090#1085#1080#1081' '#1074#1080#1089#1085#1086#1074#1086#1082' ('#1087#1072#1088#1072#1084#1077#1090#1088#1099')'
  end
  object edExpertLast: TcxTextEdit [21]
    Left = 358
    Top = 72
    TabOrder = 21
    Width = 180
  end
  object cxLabel8: TcxLabel [22]
    Left = 544
    Top = 53
    Caption = #1044#1077#1082#1083#1072#1088#1072#1094#1110#1103' '#1074#1080#1088#1086#1073#1085#1080#1082#1072' '#8470
  end
  object edQualityNumber: TcxTextEdit [23]
    Left = 544
    Top = 72
    TabOrder = 23
    Width = 180
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 379
    Top = 324
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 512
    Top = 316
  end
  inherited ActionList: TActionList
    Left = 423
    Top = 217
    inherited InsertUpdateGuides: TdsdInsertUpdateGuides [0]
    end
    inherited actRefresh: TdsdDataSetRefresh [1]
    end
    inherited FormClose: TdsdFormClose [2]
    end
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = '0'
        ParamType = ptInput
      end
      item
        Name = 'inMovementId_Value'
        Value = '0'
        ParamType = ptInput
      end>
    Left = 488
    Top = 316
  end
  inherited spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_GoodsQuality'
    Params = <
      item
        Name = 'ioid'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'ininvnumber'
        Value = '0'
        Component = edInvNumber
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inoperdate'
        Value = 0d
        Component = ceOperDate
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inOperDateCertificate'
        Value = 0d
        Component = ceOperDateCertificate
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inCertificateNumber'
        Value = ''
        Component = edCertificateNumber
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inCertificateSeries'
        Value = 0.000000000000000000
        Component = edCertificateSeries
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inCertificateSeriesNumber'
        Value = 0.000000000000000000
        Component = edCertificateSeriesNumber
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inExpertPrior'
        Value = ''
        Component = edExpertPrior
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inExpertLast'
        Value = ''
        Component = edExpertLast
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inQualityNumber'
        Value = ''
        Component = edQualityNumber
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inComment'
        Value = ''
        Component = ceComment
        DataType = ftBlob
        ParamType = ptInput
      end
      item
        Name = 'inQualityId'
        Value = ''
        Component = GoodsQualityFormGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Value = ''
        ParamType = ptUnknown
      end
      item
        Value = ''
        ParamType = ptUnknown
      end
      item
        Value = ''
        ParamType = ptUnknown
      end
      item
        Value = ''
        Component = GoodsQualityFormGuides
        ComponentItem = 'Key'
        ParamType = ptUnknown
      end>
    Left = 488
    Top = 224
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_GoodsQuality'
    Params = <
      item
        Name = 'inMovementId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inOperDate'
        Value = Null
        Component = FormParams
        ComponentItem = 'inOperDate'
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'Id'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
      end
      item
        Name = 'InvNumber'
        Value = '0'
        Component = edInvNumber
      end
      item
        Name = 'OperDate'
        Value = 0d
        Component = ceOperDate
        DataType = ftDateTime
      end
      item
        Name = 'OperDateCertificate'
        Value = 0d
        Component = ceOperDateCertificate
        DataType = ftDateTime
      end
      item
        Name = 'CertificateNumber'
        Value = ''
        Component = edCertificateNumber
        DataType = ftString
      end
      item
        Name = 'CertificateSeries'
        Value = 0.000000000000000000
        Component = edCertificateSeries
        DataType = ftString
      end
      item
        Name = 'CertificateSeriesNumber'
        Value = 0.000000000000000000
        Component = edCertificateSeriesNumber
        DataType = ftString
      end
      item
        Name = 'ExpertPrior'
        Value = ''
        Component = edExpertPrior
        DataType = ftString
      end
      item
        Name = 'ExpertLast'
        Value = ''
        Component = edExpertLast
        DataType = ftString
      end
      item
        Name = 'QualityNumber'
        Value = ''
        Component = edQualityNumber
        DataType = ftString
      end
      item
        Name = 'Comment'
        Value = Null
        Component = ceComment
        DataType = ftBlob
      end
      item
        Name = 'QualityId'
        Value = ''
        Component = GoodsQualityFormGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'QualityName'
        Value = ''
        Component = GoodsQualityFormGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Value = ''
        ParamType = ptUnknown
      end
      item
        Value = ''
        DataType = ftString
        ParamType = ptUnknown
      end
      item
        Value = ''
        Component = GoodsQualityFormGuides
        ComponentItem = 'Key'
        ParamType = ptUnknown
      end
      item
        Value = ''
        Component = GoodsQualityFormGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptUnknown
      end
      item
        Value = ''
        ParamType = ptUnknown
      end
      item
        Value = ''
        DataType = ftString
        ParamType = ptUnknown
      end
      item
        Value = '0'
        ParamType = ptUnknown
      end
      item
        Value = ''
        ParamType = ptUnknown
      end
      item
        Value = ''
        ParamType = ptUnknown
      end
      item
        Value = ''
        DataType = ftString
        ParamType = ptUnknown
      end
      item
        Value = ''
        DataType = ftString
        ParamType = ptUnknown
      end
      item
        Value = ''
        DataType = ftString
        ParamType = ptUnknown
      end>
    Left = 544
    Top = 216
  end
  object GoodsQualityFormGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceGoodsQualityForm
    FormNameParam.Value = 'TGoodsQualityForm'
    FormNameParam.DataType = ftString
    FormName = 'TGoodsQualityForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GoodsQualityFormGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsQualityFormGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 192
    Top = 113
  end
  object GuidesFiller: TGuidesFiller
    IdParam.Name = 'Id'
    IdParam.Value = '0'
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    GuidesList = <
      item
      end
      item
      end
      item
      end
      item
      end>
    ActionItemList = <>
    Left = 248
    Top = 226
  end
end
