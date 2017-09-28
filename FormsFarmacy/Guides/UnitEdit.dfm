﻿object UnitEditForm: TUnitEditForm
  Left = 0
  Top = 0
  Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103
  ClientHeight = 389
  ClientWidth = 488
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = DataSetRefresh
  AddOnFormData.Params = dsdFormParams
  PixelsPerInch = 96
  TextHeight = 13
  object edName: TcxTextEdit
    Left = 255
    Top = 26
    TabOrder = 0
    Width = 209
  end
  object cxLabel1: TcxLabel
    Left = 255
    Top = 3
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077
  end
  object cxButton1: TcxButton
    Left = 72
    Top = 356
    Width = 75
    Height = 25
    Action = InsertUpdateGuides
    Default = True
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 266
    Top = 356
    Width = 75
    Height = 25
    Action = FormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 3
  end
  object Код: TcxLabel
    Left = 15
    Top = 3
    Caption = #1050#1086#1076
  end
  object ceCode: TcxCurrencyEdit
    Left = 15
    Top = 26
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 5
    Width = 209
  end
  object cxLabel3: TcxLabel
    Left = 15
    Top = 50
    Caption = #1043#1088#1091#1087#1087#1072
  end
  object ceParent: TcxButtonEdit
    Left = 15
    Top = 73
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 7
    Width = 209
  end
  object cxLabel5: TcxLabel
    Left = 255
    Top = 49
    Caption = #1043#1083#1072#1074#1085#1086#1077' '#1102#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
  end
  object ceJuridical: TcxButtonEdit
    Left = 255
    Top = 72
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 9
    Width = 209
  end
  object cxLabel2: TcxLabel
    Left = 15
    Top = 102
    Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1076#1083#1103' '#1087#1077#1088#1077#1086#1094#1077#1085#1082#1080
  end
  object edMarginCategory: TcxButtonEdit
    Left = 15
    Top = 121
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 11
    Width = 209
  end
  object cxLabel4: TcxLabel
    Left = 15
    Top = 156
    Caption = '% '#1086#1090' '#1074#1099#1088#1091#1095#1082#1080
  end
  object ceTaxService: TcxCurrencyEdit
    Left = 15
    Top = 175
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 13
    Width = 90
  end
  object cbRepriceAuto: TcxCheckBox
    Left = 255
    Top = 121
    Hint = #1059#1095#1072#1089#1090#1074#1091#1077#1090' '#1074' '#1072#1074#1090#1086#1087#1077#1088#1077#1086#1094#1077#1085#1082#1077
    Caption = #1040#1074#1090#1086' '#1087#1077#1088#1077#1086#1094#1077#1085#1082#1072
    TabOrder = 14
    Width = 113
  end
  object cxLabel6: TcxLabel
    Left = 134
    Top = 156
    Caption = '% '#1074' '#1085#1086#1095#1085'. '#1089#1084'.'
  end
  object ceTaxServiceNigth: TcxCurrencyEdit
    Left = 134
    Top = 175
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 16
    Width = 90
  end
  object cxLabel7: TcxLabel
    Left = 255
    Top = 156
    Caption = #1053#1072#1095'. '#1085#1086#1095'. '#1089#1084#1077#1085#1099
  end
  object cxLabel8: TcxLabel
    Left = 367
    Top = 156
    Caption = #1054#1082#1086#1085'. '#1085#1086#1095'. '#1089#1084#1077#1085#1099
  end
  object edEndServiceNigth: TcxDateEdit
    Left = 364
    Top = 175
    Properties.ArrowsForYear = False
    Properties.AssignedValues.EditFormat = True
    Properties.DateButtons = [btnNow]
    Properties.DisplayFormat = 'HH:MM'
    Properties.Kind = ckDateTime
    TabOrder = 19
    Width = 100
  end
  object edStartServiceNigth: TcxDateEdit
    Left = 255
    Top = 175
    Properties.ArrowsForYear = False
    Properties.AssignedValues.EditFormat = True
    Properties.DateButtons = [btnNow]
    Properties.DateOnError = deNull
    Properties.DisplayFormat = 'HH:MM'
    Properties.Kind = ckDateTime
    Properties.Nullstring = ' '
    Properties.YearsInMonthList = False
    TabOrder = 20
    Width = 100
  end
  object cxLabel9: TcxLabel
    Left = 15
    Top = 203
    Caption = #1040#1076#1088#1077#1089
  end
  object edAddress: TcxTextEdit
    Left = 15
    Top = 220
    TabOrder = 22
    Width = 449
  end
  object cxLabel10: TcxLabel
    Left = 255
    Top = 249
    Caption = #1056#1072#1081#1086#1085
  end
  object ceProvinceCity: TcxButtonEdit
    Left = 255
    Top = 266
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 24
    Width = 209
  end
  object cxLabel11: TcxLabel
    Left = 15
    Top = 299
    Caption = #1044#1077#1081#1089#1090#1074#1091#1077#1090' '#1089
  end
  object edCreateDate: TcxDateEdit
    Left = 15
    Top = 319
    EditValue = 42993d
    Properties.ReadOnly = False
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 26
    Width = 90
  end
  object edCloseDate: TcxDateEdit
    Left = 134
    Top = 319
    EditValue = 42993d
    Properties.ReadOnly = False
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 27
    Width = 90
  end
  object cxLabel12: TcxLabel
    Left = 134
    Top = 299
    Caption = #1044#1077#1081#1089#1090#1074#1091#1077#1090' '#1076#1086
  end
  object cxLabel13: TcxLabel
    Left = 255
    Top = 299
    Caption = #1052#1077#1085#1077#1076#1078#1077#1088
  end
  object edUserManager: TcxButtonEdit
    Left = 255
    Top = 319
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 30
    Width = 209
  end
  object cxLabel14: TcxLabel
    Left = 16
    Top = 250
    Caption = #1056#1077#1075#1080#1086#1085
  end
  object edArea: TcxButtonEdit
    Left = 15
    Top = 266
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 32
    Width = 209
  end
  object ActionList: TActionList
    Left = 396
    Top = 334
    object DataSetRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
        end
        item
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object InsertUpdateGuides: TdsdInsertUpdateGuides
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = 'Ok'
    end
    object FormClose: TdsdFormClose
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_Unit'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCode'
        Value = 0.000000000000000000
        Component = ceCode
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inName'
        Value = ''
        Component = edName
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAddress'
        Value = Null
        Component = edAddress
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTaxService'
        Value = Null
        Component = ceTaxService
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTaxServiceNigth'
        Value = Null
        Component = ceTaxServiceNigth
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartServiceNigth'
        Value = '0'
        Component = edStartServiceNigth
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndServiceNigth'
        Value = 'NULL'
        Component = edEndServiceNigth
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCreateDate'
        Value = 'NULL'
        Component = edCreateDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCloseDate'
        Value = 'NULL'
        Component = edCloseDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisRepriceAuto'
        Value = Null
        Component = cbRepriceAuto
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAreaId'
        Value = Null
        Component = GuidesArea
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParentId'
        Value = ''
        Component = ParentGuides
        ComponentItem = 'ParentId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalId'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMarginCategoryId'
        Value = Null
        Component = MarginCategoryGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inProvinceCityId'
        Value = Null
        Component = GuidesProvinceCity
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserManagerId'
        Value = Null
        Component = GuidesUserManager
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 180
    Top = 342
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 452
    Top = 342
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Unit'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Name'
        Value = ''
        Component = edName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = 0.000000000000000000
        Component = ceCode
        MultiSelectSeparator = ','
      end
      item
        Name = 'ParentId'
        Value = ''
        Component = ParentGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ParentName'
        Value = ''
        Component = ParentGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalId'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MarginCategoryId'
        Value = Null
        Component = MarginCategoryGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MarginCategoryName'
        Value = Null
        Component = MarginCategoryGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'TaxService'
        Value = Null
        Component = ceTaxService
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'TaxServiceNigth'
        Value = Null
        Component = ceTaxServiceNigth
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'StartServiceNigth'
        Value = 'NULL'
        Component = edStartServiceNigth
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndServiceNigth'
        Value = 'NULL'
        Component = edEndServiceNigth
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'isRepriceAuto'
        Value = Null
        Component = cbRepriceAuto
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'Address'
        Value = Null
        Component = edAddress
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProvinceCityId'
        Value = Null
        Component = GuidesProvinceCity
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProvinceCityName'
        Value = Null
        Component = GuidesProvinceCity
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CreateDate'
        Value = 'NULL'
        Component = edCreateDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'CloseDate'
        Value = 'NULL'
        Component = edCloseDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'UserManagerId'
        Value = Null
        Component = GuidesUserManager
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UserManagerName'
        Value = Null
        Component = GuidesUserManager
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'AreaId'
        Value = Null
        Component = GuidesArea
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'AreaName'
        Value = Null
        Component = GuidesArea
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 20
    Top = 350
  end
  object ParentGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceParent
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ParentGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ParentGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 64
  end
  object JuridicalGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceJuridical
    FormNameParam.Value = 'TJuridicalForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridicalForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 384
    Top = 48
  end
  object MarginCategoryGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edMarginCategory
    FormNameParam.Value = 'TMarginCategoryForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMarginCategoryForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = MarginCategoryGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = MarginCategoryGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 152
    Top = 104
  end
  object GuidesProvinceCity: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceProvinceCity
    FormNameParam.Value = 'TProvinceCityForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TProvinceCityForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesProvinceCity
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesProvinceCity
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 336
    Top = 254
  end
  object GuidesUserManager: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUserManager
    FormNameParam.Value = 'TUserForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUserForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUserManager
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUserManager
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 368
    Top = 306
  end
  object GuidesArea: TdsdGuides
    KeyField = 'Id'
    LookupControl = edArea
    FormNameParam.Value = 'TAreaForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TAreaForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesArea
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesArea
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 104
    Top = 256
  end
end
