inherited QualityParamsForm: TQualityParamsForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1050#1072#1095#1077#1089#1090#1074#1077#1085#1085#1086#1077' '#1091#1076#1086#1089#1090#1086#1074#1077#1088#1077#1085#1080#1077' - '#1087#1072#1088#1072#1084#1077#1090#1088#1099'>'
  ClientHeight = 616
  ClientWidth = 1004
  AddOnFormData.isSingle = False
  ExplicitWidth = 1010
  ExplicitHeight = 641
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 384
    Top = 573
    Height = 26
    ExplicitLeft = 384
    ExplicitTop = 573
    ExplicitHeight = 26
  end
  inherited bbCancel: TcxButton
    Left = 528
    Top = 573
    Height = 26
    ExplicitLeft = 528
    ExplicitTop = 573
    ExplicitHeight = 26
  end
  object cxLabel1: TcxLabel [2]
    Left = 104
    Top = 7
    Caption = #1044#1072#1090#1072
  end
  object Код: TcxLabel [3]
    Left = 8
    Top = 7
    Caption = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
  end
  object cxLabel4: TcxLabel [4]
    Left = 397
    Top = 7
    Caption = #1050#1072#1095#1077#1089#1090#1074#1077#1085#1085#1086#1077' '#1091#1076#1086#1089#1090#1086#1074#1077#1088#1077#1085#1080#1077
  end
  object edQuality: TcxButtonEdit [5]
    Left = 397
    Top = 27
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 3
    Width = 206
  end
  object ceOperDate: TcxDateEdit [6]
    Left = 104
    Top = 27
    EditValue = 42096d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 2
    Width = 97
  end
  object cxLabel9: TcxLabel [7]
    Left = 214
    Top = 57
    Caption = #1042#1077#1090#1077#1088#1080#1085#1072#1088#1085#1077' '#1089#1074#1110#1076#1086#1094#1090#1074#1086' <'#1044#1072#1090#1072'>'
  end
  object ceOperDateCertificate: TcxDateEdit [8]
    Left = 214
    Top = 77
    EditValue = 42096d
    Enabled = False
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 8
    Width = 168
  end
  object edCertificateNumber: TcxTextEdit [9]
    Left = 8
    Top = 77
    Enabled = False
    TabOrder = 9
    Width = 193
  end
  object cxLabel11: TcxLabel [10]
    Left = 8
    Top = 57
    Caption = #1042#1077#1090#1077#1088#1080#1085#1072#1088#1085#1077' '#1089#1074#1110#1076#1086#1094#1090#1074#1086' '#8470
  end
  object edInvNumber: TcxTextEdit [11]
    Left = 8
    Top = 27
    Properties.ReadOnly = True
    TabOrder = 11
    Text = '0'
    Width = 75
  end
  object ceComment: TcxMemo [12]
    Left = 8
    Top = 230
    TabOrder = 12
    Height = 327
    Width = 984
  end
  object cxLabel2: TcxLabel [13]
    Left = 8
    Top = 207
    Caption = #1054#1089#1086#1073#1083#1080#1074#1110' '#1074#1110#1076#1084#1110#1090#1082#1080
  end
  object cxLabel3: TcxLabel [14]
    Left = 397
    Top = 57
    Caption = #1042#1077#1090#1077#1088#1080#1085#1072#1088#1085#1077' '#1089#1074#1110#1076#1086#1094#1090#1074#1086' <'#1057#1077#1088#1110#1103'> '#1110' <'#8470'>'
  end
  object edCertificateSeries: TcxTextEdit [15]
    Left = 397
    Top = 77
    Enabled = False
    TabOrder = 15
    Width = 72
  end
  object edCertificateSeriesNumber: TcxTextEdit [16]
    Left = 503
    Top = 77
    Enabled = False
    TabOrder = 16
    Width = 100
  end
  object cxLabel6: TcxLabel [17]
    Left = 8
    Top = 107
    Caption = #1057#1090#1088#1086#1082#1072' <'#1045#1082#1089#1087#1077#1088#1090#1085#1080#1081' '#1074#1080#1089#1085#1086#1074#1086#1082'>'
  end
  object edExpertPrior: TcxTextEdit [18]
    Left = 8
    Top = 127
    TabOrder = 18
    Width = 984
  end
  object cxLabel7: TcxLabel [19]
    Left = 8
    Top = 157
    Caption = #1057#1090#1088#1086#1082#1072' <'#1045#1082#1089#1087#1077#1088#1090#1085#1080#1081' '#1074#1080#1089#1085#1086#1074#1086#1082' - '#1087#1086#1082#1072#1079#1085#1080#1082#1080'>'
  end
  object edExpertLast: TcxTextEdit [20]
    Left = 8
    Top = 177
    TabOrder = 20
    Width = 984
  end
  object cxLabel8: TcxLabel [21]
    Left = 214
    Top = 7
    Caption = #1044#1077#1082#1083#1072#1088#1072#1094#1110#1103' '#1074#1080#1088#1086#1073#1085#1080#1082#1072' '#8470
  end
  object edQualityNumber: TcxTextEdit [22]
    Left = 214
    Top = 27
    TabOrder = 22
    Width = 168
  end
  object cxLabel5: TcxLabel [23]
    Left = 482
    Top = 77
    Caption = '-'
  end
  object cxLabel22: TcxLabel [24]
    Left = 623
    Top = 7
    Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100
  end
  object edRetail: TcxButtonEdit [25]
    Left = 623
    Top = 27
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 25
    Width = 369
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 379
    Top = 440
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 512
    Top = 432
  end
  inherited ActionList: TActionList
    Left = 423
    Top = 333
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
    Left = 464
    Top = 392
  end
  inherited spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_QualityParams'
    Params = <
      item
        Name = 'ioid'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inInvNumber'
        Value = '0'
        Component = edInvNumber
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inOperDate'
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
        DataType = ftWideString
        ParamType = ptInput
      end
      item
        Name = 'inQualityId'
        Value = ''
        Component = GuidesQuality
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inRetailId'
        Value = Null
        Component = GuidesRetail
        ComponentItem = 'Key'
        ParamType = ptInput
      end>
    Left = 488
    Top = 340
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_QualityParams'
    Params = <
      item
        Name = 'inMovementId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inMovementId_Value'
        Value = ''
        Component = FormParams
        ComponentItem = 'inMovementId_Value'
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
        Name = 'QualityNumber'
        Value = ''
        Component = edQualityNumber
        DataType = ftString
      end
      item
        Name = 'QualityId'
        Value = ''
        Component = GuidesQuality
        ComponentItem = 'Key'
      end
      item
        Name = 'QualityName'
        Value = ''
        Component = GuidesQuality
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'RetailId'
        Value = Null
        Component = GuidesRetail
        ComponentItem = 'Key'
      end
      item
        Name = 'RetailName'
        Value = Null
        Component = GuidesRetail
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'CertificateNumber'
        Value = ''
        Component = edCertificateNumber
        DataType = ftString
      end
      item
        Name = 'OperDateCertificate'
        Value = 0d
        Component = ceOperDateCertificate
        DataType = ftDateTime
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
        Name = 'Comment'
        Value = Null
        Component = ceComment
        DataType = ftWideString
      end>
    Left = 544
    Top = 332
  end
  object GuidesQuality: TdsdGuides
    KeyField = 'Id'
    LookupControl = edQuality
    FormNameParam.Value = 'TQualityForm'
    FormNameParam.DataType = ftString
    FormName = 'TQualityForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesQuality
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesQuality
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 480
    Top = 9
  end
  object GuidesFiller: TGuidesFiller
    IdParam.Name = 'Id'
    IdParam.Value = '0'
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    GuidesList = <
      item
        Guides = GuidesQuality
      end>
    ActionItemList = <>
    Left = 248
    Top = 342
  end
  object GuidesRetail: TdsdGuides
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
        Component = GuidesRetail
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesRetail
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'PartnerId'
        Value = '0'
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'PartnerName'
        Value = ' '
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 842
    Top = 20
  end
end
