inherited BankAccountJournalFarmacyForm: TBankAccountJournalFarmacyForm
  ExplicitHeight = 394
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    inherited tsMain: TcxTabSheet
      inherited cxGrid: TcxGrid
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
        end
      end
    end
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
  inherited BarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      26
      0)
    inherited bbPrint: TdxBarButton
      Visible = ivNever
    end
    inherited bbPrint1: TdxBarButton
      Visible = ivNever
    end
  end
  inherited FormParams: TdsdFormParams
    Top = 224
  end
end
