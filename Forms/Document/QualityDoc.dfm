inherited QualityDocForm: TQualityDocForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1050#1072#1095#1077#1089#1090#1074#1077#1085#1085#1086#1077' '#1091#1076#1086#1089#1090#1086#1074#1077#1088#1077#1085#1080#1077'>'
  ClientHeight = 304
  ClientWidth = 561
  AddOnFormData.isSingle = False
  ExplicitWidth = 567
  ExplicitHeight = 332
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 165
    Top = 268
    Height = 26
    ExplicitLeft = 165
    ExplicitTop = 268
    ExplicitHeight = 26
  end
  inherited bbCancel: TcxButton
    Left = 306
    Top = 268
    Height = 26
    ExplicitLeft = 306
    ExplicitTop = 268
    ExplicitHeight = 26
  end
  object cxLabel1: TcxLabel [2]
    Left = 165
    Top = 7
    Caption = #1044#1072#1090#1072' '#1086#1090#1075#1088#1091#1079#1082#1080
  end
  object edOperDateOut: TcxDateEdit [3]
    Left = 165
    Top = 27
    EditValue = 42092d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 2
    Width = 90
  end
  object edInvNumber_Sale: TcxButtonEdit [4]
    Left = 270
    Top = 27
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 3
    Width = 145
  end
  object cxLabel6: TcxLabel [5]
    Left = 270
    Top = 7
    Caption = #8470' '#1076#1086#1082'. ('#1089#1082#1083#1072#1076')'
  end
  object edOperDate_Sale: TcxDateEdit [6]
    Left = 427
    Top = 27
    EditValue = 42092d
    Properties.ReadOnly = True
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 6
    Width = 90
  end
  object cxLabel2: TcxLabel [7]
    Left = 427
    Top = 7
    Caption = #1044#1072#1090#1072' ('#1089#1082#1083#1072#1076')'
  end
  object edFrom: TcxButtonEdit [8]
    Left = 270
    Top = 77
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 8
    Width = 247
  end
  object cxLabel3: TcxLabel [9]
    Left = 270
    Top = 57
    Caption = #1054#1090' '#1082#1086#1075#1086
  end
  object cxLabel9: TcxLabel [10]
    Left = 8
    Top = 107
    Caption = #1040#1074#1090#1086#1084#1086#1073#1080#1083#1100
  end
  object edCar: TcxButtonEdit [11]
    Left = 8
    Top = 127
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 11
    Width = 247
  end
  object cxLabel4: TcxLabel [12]
    Left = 8
    Top = 57
    Caption = #1052#1072#1088#1082#1072' '#1072#1074#1090#1086#1084#1086#1073#1080#1083#1103
  end
  object edCarModel: TcxButtonEdit [13]
    Left = 8
    Top = 77
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 13
    Width = 247
  end
  object cxLabel10: TcxLabel [14]
    Left = 270
    Top = 107
    Caption = #1050#1086#1084#1091
  end
  object edTo: TcxButtonEdit [15]
    Left = 270
    Top = 127
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 15
    Width = 247
  end
  object cxLabel8: TcxLabel [16]
    Left = 8
    Top = 7
    Caption = #1044#1072#1090#1072' '#1080' '#1074#1088'. '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1072
  end
  object edOperDateIn: TcxDateEdit [17]
    Left = 8
    Top = 27
    EditValue = 42145d
    Properties.DateButtons = [btnClear, btnToday]
    Properties.DisplayFormat = 'dd.mm.yyyy hh:mm'
    Properties.EditFormat = 'dd.mm.yyyy hh:mm'
    Properties.InputKind = ikMask
    Properties.Kind = ckDateTime
    TabOrder = 17
    Width = 145
  end
  object cxLabel5: TcxLabel [18]
    Left = 8
    Top = 158
    Caption = #1044#1077#1082#1083#1072#1088#1072#1094#1110#1103' '#1074#1080#1088#1086#1073#1085#1080#1082#1072' '#8470
  end
  object edQualityNumber: TcxTextEdit [19]
    Left = 8
    Top = 181
    TabOrder = 19
    Width = 247
  end
  object cxLabel11: TcxLabel [20]
    Left = 270
    Top = 158
    Caption = #1042#1077#1090#1077#1088#1080#1085#1072#1088#1085#1077' '#1089#1074#1110#1076#1086#1094#1090#1074#1086' '#8470
  end
  object edCertificateNumber: TcxTextEdit [21]
    Left = 270
    Top = 181
    TabOrder = 21
    Width = 247
  end
  object cxLabel7: TcxLabel [22]
    Left = 8
    Top = 208
    Caption = #1042#1077#1090#1077#1088#1080#1085#1072#1088#1085#1077' '#1089#1074#1110#1076#1086#1094#1090#1074#1086' <'#1044#1072#1090#1072'>'
  end
  object ceOperDateCertificate: TcxDateEdit [23]
    Left = 8
    Top = 231
    EditValue = 42125d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 23
    Width = 247
  end
  object cxLabel12: TcxLabel [24]
    Left = 270
    Top = 208
    Caption = #1042#1077#1090#1077#1088#1080#1085#1072#1088#1085#1077' '#1089#1074#1110#1076#1086#1094#1090#1074#1086' <'#1057#1077#1088#1110#1103'> '#1110' <'#8470'>'
  end
  object edCertificateSeries: TcxTextEdit [25]
    Left = 270
    Top = 231
    TabOrder = 25
    Width = 72
  end
  object cxLabel13: TcxLabel [26]
    Left = 353
    Top = 235
    Caption = '-'
  end
  object edCertificateSeriesNumber: TcxTextEdit [27]
    Left = 376
    Top = 231
    TabOrder = 27
    Width = 100
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 78
    Top = 249
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 115
    Top = 263
  end
  inherited ActionList: TActionList
    Left = 250
    Top = 251
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
        Name = 'MovementId_Sale'
        Value = '0'
        ParamType = ptInput
      end>
    Left = 31
    Top = 264
  end
  inherited spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_QualityDoc'
    Params = <
      item
        Name = 'ioId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inMovementId_Sale'
        Value = ''
        Component = GuideSaleJournalChoice
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inOperDateIn'
        Value = Null
        Component = edOperDateIn
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inOperDateOut'
        Value = Null
        Component = edOperDateOut
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inCarId'
        Value = ''
        Component = GuideCar
        ComponentItem = 'Key'
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
        Value = Null
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
    Top = 258
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_QualityDoc'
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inMovementId_Sale'
        Value = ''
        Component = FormParams
        ComponentItem = 'MovementId_Sale'
        ParamType = ptInput
      end
      item
        Name = 'Id'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
      end
      item
        Name = 'MovementId_Sale'
        Value = 0d
        Component = GuideSaleJournalChoice
        ComponentItem = 'Key'
      end
      item
        Name = 'InvNumber_Sale'
        Value = ''
        Component = GuideSaleJournalChoice
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'OperDate_Sale'
        Value = ''
        Component = edOperDate_Sale
        DataType = ftDateTime
      end
      item
        Name = 'OperDateIn'
        Value = 0d
        Component = edOperDateIn
        DataType = ftDateTime
      end
      item
        Name = 'OperDateOut'
        Value = 0d
        Component = edOperDateOut
        DataType = ftDateTime
      end
      item
        Name = 'FromName'
        Value = 0.000000000000000000
        Component = edFrom
        DataType = ftString
      end
      item
        Name = 'ToId'
        Value = Null
        Component = GuidesTo
        ComponentItem = 'Key'
      end
      item
        Name = 'ToName'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'CarId'
        Value = ''
        Component = GuideCar
        ComponentItem = 'Key'
      end
      item
        Name = 'CarName'
        Value = ''
        Component = GuideCar
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'CarModelId'
        Value = ''
        Component = GuideCarModel
        ComponentItem = 'Key'
      end
      item
        Name = 'CarModelName'
        Value = ''
        Component = GuideCarModel
        ComponentItem = 'TextValue'
        DataType = ftString
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
    Top = 218
  end
  object GuideSaleJournalChoice: TdsdGuides
    KeyField = 'Id'
    LookupControl = edInvNumber_Sale
    FormNameParam.Value = 'TSaleJournalChoiceForm'
    FormNameParam.DataType = ftString
    FormName = 'TSaleJournalChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuideSaleJournalChoice
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuideSaleJournalChoice
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'OperDate'
        Value = Null
        Component = edOperDate_Sale
        DataType = ftDateTime
      end
      item
        Name = 'FromName'
        Value = Null
        Component = edFrom
      end
      item
        Name = 'ToId'
        Value = Null
        Component = GuidesTo
        ComponentItem = 'Key'
      end
      item
        Name = 'ToName'
        Value = Null
        Component = GuidesTo
        ComponentItem = 'TextValue'
      end
      item
        Name = 'inStartDate'
        Value = Null
        Component = edOperDate_Sale
        DataType = ftDateTime
      end
      item
        Name = 'inEndDate'
        Value = Null
        Component = edOperDate_Sale
        DataType = ftDateTime
      end
      item
        Name = 'PartnerId'
        Value = Null
        Component = GuidesTo
        ComponentItem = 'Key'
      end
      item
        Name = 'PartnerName'
        Value = Null
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 96
    Top = 23
  end
  object GuidesFiller: TGuidesFiller
    IdParam.Name = 'Id'
    IdParam.Value = '0'
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    GuidesList = <
      item
        Guides = GuideSaleJournalChoice
      end>
    ActionItemList = <>
    Left = 475
    Top = 258
  end
  object GuideCar: TdsdGuides
    KeyField = 'Id'
    LookupControl = edCar
    FormNameParam.Value = 'TCarForm'
    FormNameParam.DataType = ftString
    FormName = 'TCarForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuideCar
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuideCar
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'CarModelName'
        Value = Null
        Component = GuideCarModel
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 408
    Top = 106
  end
  object GuideCarModel: TdsdGuides
    KeyField = 'Id'
    LookupControl = edCarModel
    FormNameParam.Value = 'TCarForm'
    FormNameParam.DataType = ftString
    FormName = 'TCarForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuideCar
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuideCar
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'CarModelName'
        Value = Null
        Component = GuideCarModel
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 344
    Top = 52
  end
  object GuidesTo: TdsdGuides
    KeyField = 'Id'
    LookupControl = edTo
    FormNameParam.Value = 'TForm_NULL'
    FormNameParam.DataType = ftString
    FormName = 'TForm_NULL'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'CarModelName'
        Value = ''
        Component = GuideCarModel
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 128
    Top = 90
  end
end
