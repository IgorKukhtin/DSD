inherited BankAccountJournalFarmacyForm: TBankAccountJournalFarmacyForm
  Caption = #1046#1091#1088#1085#1072#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' <'#1056#1072#1089#1093#1086#1076' '#1087#1086' '#1088#1072#1089#1095#1077#1090#1085#1086#1084#1091' '#1089#1095#1077#1090#1091'>'
  ClientHeight = 463
  ClientWidth = 1149
  ExplicitWidth = 1165
  ExplicitHeight = 501
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 1149
    Height = 406
    ClientRectBottom = 406
    ClientRectRight = 1149
    inherited tsMain: TcxTabSheet
      inherited cxGrid: TcxGrid
        Width = 1149
        Height = 406
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
          object colIncome_JuridicalName: TcxGridDBColumn
            Caption = #1053#1072#1096#1077' '#1070#1088#1083#1080#1094#1086
            DataBinding.FieldName = 'Income_JuridicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object colIncome_OperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1055#1053' '#1087#1086#1089#1090'-'#1082#1072
            DataBinding.FieldName = 'Income_OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 78
          end
          object colIncome_InvNumber: TcxGridDBColumn
            Caption = #8470' '#1055#1053' '#1087#1086#1089#1090'-'#1082#1072
            DataBinding.FieldName = 'Income_InvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 75
          end
          object colIncome_NDSKindName: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1053#1044#1057' '#1055#1053
            DataBinding.FieldName = 'Income_NDSKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object colIncome_SummWithOutVAT: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1055#1053' '#1073'/'#1053#1044#1057
            DataBinding.FieldName = 'Income_SummWithOutVAT'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object colIncome_SummVAT: TcxGridDBColumn
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
      end>
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
          ToParam.Value = Null
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
          ToParam.Value = Null
        end>
      DataSets = <
        item
        end>
    end
    inherited actIsCopy: TdsdExecStoredProc
      MoveParams = <
        item
          FromParam.Value = Null
          ToParam.Value = Null
        end>
    end
    inherited actIsCopyTrue: TdsdExecStoredProc
      MoveParams = <
        item
          FromParam.Value = Null
          ToParam.Value = Null
        end>
    end
  end
  inherited MasterDS: TDataSource
    Top = 139
  end
  inherited MasterCDS: TClientDataSet
    Top = 139
  end
  inherited spSelect: TdsdStoredProc
    Top = 139
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
  inherited FormParams: TdsdFormParams
    Top = 224
  end
end
