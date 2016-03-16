inherited QualityNumberForm: TQualityNumberForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1050#1072#1095#1077#1089#1090#1074#1077#1085#1085#1086#1077' '#1091#1076#1086#1089#1090#1086#1074#1077#1088#1077#1085#1080#1077' ('#1085#1086#1084#1077#1088#1072')>'
  ClientHeight = 211
  ClientWidth = 540
  AddOnFormData.isSingle = False
  ExplicitWidth = 546
  ExplicitHeight = 239
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 165
    Top = 167
    Height = 26
    ExplicitLeft = 165
    ExplicitTop = 167
    ExplicitHeight = 26
  end
  inherited bbCancel: TcxButton
    Left = 306
    Top = 167
    Height = 26
    ExplicitLeft = 306
    ExplicitTop = 167
    ExplicitHeight = 26
  end
  object cxLabel5: TcxLabel [2]
    Left = 8
    Top = 57
    Caption = #1044#1077#1082#1083#1072#1088#1072#1094#1110#1103' '#1074#1080#1088#1086#1073#1085#1080#1082#1072' '#8470
  end
  object edQualityNumber: TcxTextEdit [3]
    Left = 8
    Top = 80
    TabOrder = 3
    Width = 247
  end
  object cxLabel11: TcxLabel [4]
    Left = 270
    Top = 57
    Caption = #1042#1077#1090#1077#1088#1080#1085#1072#1088#1085#1077' '#1089#1074#1110#1076#1086#1094#1090#1074#1086' '#8470
  end
  object edCertificateNumber: TcxTextEdit [5]
    Left = 270
    Top = 80
    TabOrder = 5
    Width = 247
  end
  object cxLabel7: TcxLabel [6]
    Left = 8
    Top = 107
    Caption = #1042#1077#1090#1077#1088#1080#1085#1072#1088#1085#1077' '#1089#1074#1110#1076#1086#1094#1090#1074#1086' <'#1044#1072#1090#1072'>'
  end
  object ceOperDateCertificate: TcxDateEdit [7]
    Left = 8
    Top = 130
    EditValue = 42125d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 7
    Width = 247
  end
  object cxLabel12: TcxLabel [8]
    Left = 270
    Top = 107
    Caption = #1042#1077#1090#1077#1088#1080#1085#1072#1088#1085#1077' '#1089#1074#1110#1076#1086#1094#1090#1074#1086' <'#1057#1077#1088#1110#1103'> '#1110' <'#8470'>'
  end
  object edCertificateSeries: TcxTextEdit [9]
    Left = 270
    Top = 130
    TabOrder = 9
    Width = 72
  end
  object cxLabel13: TcxLabel [10]
    Left = 353
    Top = 134
    Caption = '-'
  end
  object edCertificateSeriesNumber: TcxTextEdit [11]
    Left = 376
    Top = 130
    TabOrder = 11
    Width = 100
  end
  object cxLabel1: TcxLabel [12]
    Left = 8
    Top = 5
    Caption = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
  end
  object edInvNumber: TcxTextEdit [13]
    Left = 8
    Top = 23
    Properties.ReadOnly = True
    TabOrder = 13
    Width = 247
  end
  object cxLabel2: TcxLabel [14]
    Left = 270
    Top = 5
    Caption = #1044#1072#1090#1072' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1072
  end
  object edOperDate: TcxDateEdit [15]
    Left = 270
    Top = 23
    EditValue = 42430d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 15
    Width = 104
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 78
    Top = 148
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 115
    Top = 162
  end
  inherited ActionList: TActionList
    Left = 250
    Top = 150
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
        Name = 'Operdate'
        Value = '0'
        DataType = ftDateTime
        ParamType = ptInput
      end>
    Left = 31
    Top = 163
  end
  inherited spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_QualityNumber'
    Params = <
      item
        Name = 'ioId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inInvNumber'
        Value = Null
        Component = edInvNumber
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inOperDate'
        Value = 'NULL'
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inQualityNumber'
        Value = Null
        Component = edQualityNumber
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inCertificateNumber'
        Value = Null
        Component = edCertificateNumber
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inOperDateCertificate'
        Value = 'NULL'
        Component = ceOperDateCertificate
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inCertificateSeries'
        Value = Null
        Component = edCertificateSeries
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inCertificateSeriesNumber'
        Value = Null
        Component = edCertificateSeriesNumber
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 395
    Top = 157
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_QualityNumber'
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inOperdate'
        Value = 'NULL'
        Component = FormParams
        ComponentItem = 'Operdate'
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'Id'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
      end
      item
        Name = 'OperDate'
        Value = 42430d
        Component = edOperDate
        DataType = ftDateTime
      end
      item
        Name = 'InvNumber'
        Value = Null
        Component = edInvNumber
      end
      item
        Name = 'QualityNumber'
        Value = Null
        Component = edQualityNumber
        DataType = ftString
      end
      item
        Name = 'CertificateNumber'
        Value = Null
        Component = edCertificateNumber
        DataType = ftString
      end
      item
        Name = 'CertificateSeries'
        Value = Null
        Component = edCertificateSeries
        DataType = ftString
      end
      item
        Name = 'CertificateSeriesNumber'
        Value = Null
        Component = edCertificateSeriesNumber
        DataType = ftString
      end
      item
        Name = 'OperDateCertificate'
        Value = 42125d
        Component = ceOperDateCertificate
        DataType = ftDateTime
      end>
    Left = 499
    Top = 117
  end
  object GuidesFiller: TGuidesFiller
    IdParam.Name = 'Id'
    IdParam.Value = '0'
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    GuidesList = <
      item
      end>
    ActionItemList = <>
    Left = 475
    Top = 157
  end
end
