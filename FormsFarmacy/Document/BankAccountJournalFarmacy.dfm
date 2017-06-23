inherited BankAccountJournalFarmacyForm: TBankAccountJournalFarmacyForm
  Caption = #1046#1091#1088#1085#1072#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' <'#1056#1072#1089#1093#1086#1076' '#1087#1086' '#1088#1072#1089#1095#1077#1090#1085#1086#1084#1091' '#1089#1095#1077#1090#1091'>'
  ClientHeight = 463
  ClientWidth = 1149
  ExplicitLeft = -402
  ExplicitWidth = 1165
  ExplicitHeight = 502
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 91
    Width = 1149
    Height = 372
    ExplicitTop = 91
    ExplicitWidth = 1149
    ExplicitHeight = 372
    ClientRectBottom = 372
    ClientRectRight = 1149
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1149
      ExplicitHeight = 372
      inherited cxGrid: TcxGrid
        Width = 1149
        Height = 372
        ExplicitWidth = 1149
        ExplicitHeight = 372
        inherited cxGridDBTableView: TcxGridDBTableView
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          inherited colAmountCurrency: TcxGridDBColumn
            Visible = False
            VisibleForCustomization = False
          end
          inherited colAmountSumm: TcxGridDBColumn
            Visible = False
            VisibleForCustomization = False
          end
          inherited CurrencyPartnerValue: TcxGridDBColumn
            Visible = False
            VisibleForCustomization = False
          end
          inherited ParPartnerValue: TcxGridDBColumn
            Visible = False
            VisibleForCustomization = False
          end
          inherited CurrencyValue: TcxGridDBColumn
            VisibleForCustomization = False
          end
          inherited ParValue: TcxGridDBColumn
            VisibleForCustomization = False
          end
          inherited colContractCode: TcxGridDBColumn
            VisibleForCustomization = False
          end
          inherited colContract: TcxGridDBColumn
            Visible = False
            VisibleForCustomization = False
          end
          inherited colContractTagName: TcxGridDBColumn
            Visible = False
            VisibleForCustomization = False
          end
          inherited clInfoMoneyCode: TcxGridDBColumn
            VisibleForCustomization = False
          end
          inherited clInfoMoneyGroupName: TcxGridDBColumn
            VisibleForCustomization = False
          end
          inherited clInfoMoneyDestinationName: TcxGridDBColumn
            VisibleForCustomization = False
          end
          inherited colInfoMoneyName: TcxGridDBColumn
            Visible = False
            VisibleForCustomization = False
          end
          inherited colInfoMoneyName_all: TcxGridDBColumn
            VisibleForCustomization = False
          end
          object Income_JuridicalName: TcxGridDBColumn
            Caption = #1053#1072#1096#1077' '#1070#1088#1083#1080#1094#1086
            DataBinding.FieldName = 'Income_JuridicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Income_OperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1055#1053' '#1087#1086#1089#1090'-'#1082#1072
            DataBinding.FieldName = 'Income_OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 78
          end
          object Income_InvNumber: TcxGridDBColumn
            Caption = #8470' '#1055#1053' '#1087#1086#1089#1090'-'#1082#1072
            DataBinding.FieldName = 'Income_InvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 75
          end
          object Income_NDSKindName: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1053#1044#1057' '#1055#1053
            DataBinding.FieldName = 'Income_NDSKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Income_SummWithOutVAT: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1055#1053' '#1073'/'#1053#1044#1057
            DataBinding.FieldName = 'Income_SummWithOutVAT'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Income_SummVAT: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1053#1044#1057' '#1085#1072#1082#1083#1072#1076#1085#1086#1081
            DataBinding.FieldName = 'Income_SummVAT'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1149
    Height = 65
    ExplicitWidth = 1149
    ExplicitHeight = 65
    inherited deStart: TcxDateEdit
      Left = 121
      ExplicitLeft = 121
    end
    inherited deEnd: TcxDateEdit
      Left = 121
      Top = 29
      ExplicitLeft = 121
      ExplicitTop = 29
    end
    inherited cxLabel1: TcxLabel
      Left = 29
      ExplicitLeft = 29
    end
    inherited cxLabel2: TcxLabel
      Left = 10
      Top = 30
      ExplicitLeft = 10
      ExplicitTop = 30
    end
  end
  object cxLabel4: TcxLabel [2]
    Left = 215
    Top = 6
    Caption = #1056#1072#1089#1095#1077#1090#1085#1099#1081' '#1089#1095#1077#1090
  end
  object ceBankAccount: TcxButtonEdit [3]
    Left = 301
    Top = 5
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 11
    Width = 260
  end
  object cxLabel6: TcxLabel [4]
    Left = 223
    Top = 30
    Caption = #1054#1090' '#1050#1086#1075#1086', '#1050#1086#1084#1091
  end
  object sbIsPartnerDate: TcxCheckBox [5]
    Left = 577
    Top = 29
    Action = actIsPartnerDate
    TabOrder = 9
    Width = 174
  end
  object ceObject: TcxButtonEdit [6]
    Left = 301
    Top = 29
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 10
    Width = 260
  end
  object cxLabel3: TcxLabel [7]
    Left = 577
    Top = 6
    Caption = #1053#1072#1096#1077' '#1070#1088'.'#1083#1080#1094#1086
  end
  object ceJuridicalCorporate: TcxButtonEdit [8]
    Left = 657
    Top = 5
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 12
    Width = 260
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 99
    Top = 235
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = BankAccountJournalForm.Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end
      item
        Component = deEnd
        Properties.Strings = (
          'Date')
      end
      item
        Component = deStart
        Properties.Strings = (
          'Date')
      end
      item
        Component = BankAccountGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = ObjectGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = JuridicalCorporateGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = sbIsPartnerDate
      end>
    Left = 88
    Top = 355
  end
  inherited ActionList: TActionList
    inherited actInsert: TdsdInsertUpdateAction
      FormName = 'TBankAccountMovementFarmacyForm'
      FormNameParam.Value = 'TBankAccountMovementFarmacyForm'
    end
    inherited actInsertMask: TdsdInsertUpdateAction
      FormName = 'TBankAccountMovementFarmacyForm'
      FormNameParam.Value = 'TBankAccountMovementFarmacyForm'
    end
    inherited actUpdate: TdsdInsertUpdateAction
      FormName = 'TBankAccountMovementFarmacyForm'
      FormNameParam.Value = 'TBankAccountMovementFarmacyForm'
    end
    inherited actPrint: TdsdPrintAction
      MoveParams = <
        item
          FromParam.Value = Null
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.MultiSelectSeparator = ','
        end>
      DataSets = <
        item
          DataSet = PrintItemsCDS
        end>
    end
    inherited actPrint1: TdsdPrintAction
      MoveParams = <
        item
          FromParam.Value = Null
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.MultiSelectSeparator = ','
        end>
      DataSets = <
        item
        end>
    end
    inherited actIsCopy: TdsdExecStoredProc
      MoveParams = <
        item
          FromParam.Value = Null
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.MultiSelectSeparator = ','
        end>
    end
    inherited actIsCopyTrue: TdsdExecStoredProc
      MoveParams = <
        item
          FromParam.Value = Null
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.MultiSelectSeparator = ','
        end>
    end
    inherited ExecuteDialog: TExecuteDialog
      FormName = 'TBankAccountJournalFarmacyDialogForm'
      FormNameParam.Value = 'TBankAccountJournalFarmacyDialogForm'
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'IsPartnerDate'
          Value = Null
          Component = sbIsPartnerDate
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'BankAccountId'
          Value = Null
          Component = BankAccountGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'BankAccountName'
          Value = Null
          Component = BankAccountGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ObjectId'
          Value = Null
          Component = ObjectGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ObjectName'
          Value = Null
          Component = ObjectGuides
          ComponentItem = 'TextValue'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalCorporateId'
          Value = Null
          Component = JuridicalCorporateGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalCorporateName'
          Value = Null
          Component = JuridicalCorporateGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
    end
    object actIsPartnerDate: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1080#1086#1076' '#1076#1083#1103' '#1044#1072#1090#1072' '#1055#1053' '#1087#1086#1089#1090'-'#1082#1072
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
  end
  inherited MasterDS: TDataSource
    Top = 171
  end
  inherited MasterCDS: TClientDataSet
    Top = 139
  end
  inherited spSelect: TdsdStoredProc
    Params = <
      item
        Name = 'inStartDate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 41640d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsPartnerDate'
        Value = Null
        Component = sbIsPartnerDate
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBankAccountId'
        Value = Null
        Component = BankAccountGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMoneyPlaceId'
        Value = Null
        Component = ObjectGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalCorporateId'
        Value = Null
        Component = JuridicalCorporateGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Top = 171
  end
  inherited BarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      26
      0)
    inherited bbAddBonus: TdxBarButton
      Visible = ivNever
    end
    inherited bbPrint: TdxBarButton
      Visible = ivNever
    end
    inherited bbPrint1: TdxBarButton
      Visible = ivNever
    end
    inherited bbisCopy: TdxBarButton
      Visible = ivNever
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 248
    Top = 192
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = BankAccountGuides
      end
      item
        Component = ObjectGuides
      end
      item
        Component = JuridicalCorporateGuides
      end>
  end
  inherited FormParams: TdsdFormParams
    Top = 224
  end
  object BankAccountGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceBankAccount
    FormNameParam.Value = 'TBankAccount_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBankAccount_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = BankAccountGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = BankAccountGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 42005d
        Component = deEnd
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    Left = 396
    Top = 65533
  end
  object ObjectGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceObject
    FormNameParam.Value = 'TMoneyPlace_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMoneyPlace_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ObjectGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ObjectGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 478
    Top = 12
  end
  object JuridicalCorporateGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceJuridicalCorporate
    FormNameParam.Value = 'TJuridicalCorporateForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridicalCorporateForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = JuridicalCorporateGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = JuridicalCorporateGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 798
    Top = 4
  end
end
