inherited ReturnOutPharmacyForm: TReturnOutPharmacyForm
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
        end
      end
    end
  end
  inherited DataPanel: TPanel
    TabOrder = 2
    inherited edInvNumber: TcxTextEdit
      Enabled = False
      Properties.ReadOnly = True
    end
    inherited edOperDate: TcxDateEdit
      Enabled = False
      Properties.ReadOnly = True
    end
    inherited ceStatus: TcxButtonEdit
      Enabled = False
    end
    inherited edNDSKind: TcxButtonEdit
      Enabled = False
    end
    inherited ceTotalSummMVAT: TcxCurrencyEdit
      Style.IsFontAssigned = True
    end
    inherited ceTotalSummPVAT: TcxCurrencyEdit
      Style.IsFontAssigned = True
    end
    inherited cxLabel7: TcxLabel
      Style.IsFontAssigned = True
    end
    inherited cxLabel8: TcxLabel
      Style.IsFontAssigned = True
    end
    inherited edReturnType: TcxButtonEdit
      Enabled = False
      Properties.ReadOnly = True
    end
    inherited edInvNumberPartner: TcxTextEdit
      Enabled = False
      Properties.ReadOnly = True
    end
    inherited edOperDatePartner: TcxDateEdit
      Enabled = False
    end
    inherited edJuridicalLegalAddress: TcxButtonEdit
      Enabled = False
      Properties.ReadOnly = True
    end
    inherited edJuridicalActualAddress: TcxButtonEdit
      Enabled = False
      Properties.ReadOnly = True
    end
    inherited edAdjustingOurDate: TcxDateEdit
      Left = 8
      Enabled = False
      ExplicitLeft = 8
    end
    inherited edComment: TcxTextEdit
      Enabled = False
      Properties.ReadOnly = True
    end
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = ReturnOutForm.Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Tag'
          'Width')
      end>
  end
  inherited ActionList: TActionList
    inherited actMISetErased: TdsdUpdateErased
      ShortCut = 0
    end
    inherited actMISetUnErased: TdsdUpdateErased
      ShortCut = 0
    end
    inherited actPrintOptima: TdsdPrintAction
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
    end
    inherited actPrint: TdsdPrintAction
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
    end
    inherited actUnCompleteMovement: TChangeGuidesStatus
      StoredProc = nil
      StoredProcList = <
        item
        end>
    end
    inherited actCompleteMovement: TChangeGuidesStatus
      StoredProc = nil
      StoredProcList = <
        item
        end>
    end
    inherited actDeleteMovement: TChangeGuidesStatus
      StoredProc = nil
      StoredProcList = <>
    end
  end
  inherited BarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      26
      0)
    inherited bbErased: TdxBarButton
      Visible = ivNever
    end
    inherited bbUnErased: TdxBarButton
      Visible = ivNever
    end
    inherited bbRefreshGoodsCode: TdxBarButton
      Visible = ivNever
    end
    inherited dxBarButton1: TdxBarButton
      Visible = ivNever
    end
    inherited dxBarButton2: TdxBarButton
      Visible = ivNever
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    SummaryItemList = <
      item
        Param.Value = Null
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = 0
      end>
  end
  inherited spGet: TdsdStoredProc [10]
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber'
        Value = ''
        Component = edInvNumber
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = 42132d
        Component = edOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusCode'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'Key'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusName'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceWithVAT'
        Value = False
        Component = edPriceWithVAT
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isDeferred'
        Value = False
        Component = cbisDeferred
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'FromId'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'FromName'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToId'
        Value = '0'
        Component = GuidesTo
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToName'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'NDSKindId'
        Value = ''
        Component = NDSKindGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'NDSKindName'
        Value = ''
        Component = NDSKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'IncomeInvNumber'
        Value = ''
        Component = GuidesIncome
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'IncomeMovementId'
        Value = ''
        Component = GuidesIncome
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReturnTypeId'
        Value = ''
        Component = ReturnTypeGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReturnTypeName'
        Value = ''
        Component = ReturnTypeGuides
        ComponentItem = 'TextValue'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumberPartner'
        Value = ''
        Component = edInvNumberPartner
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDatePartner'
        Value = 43248d
        Component = edOperDatePartner
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalId'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'IncomeOperDate'
        Value = 42363d
        Component = deIncomeOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'LegalAddressId'
        Value = ''
        Component = GuidesJuridicalLegalAddress
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'LegalAddressName'
        Value = ''
        Component = GuidesJuridicalLegalAddress
        ComponentItem = 'TextValue'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ActualAddressId'
        Value = ''
        Component = GuidesJuridicalActualAddress
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ActualAddressName'
        Value = ''
        Component = GuidesJuridicalActualAddress
        ComponentItem = 'TextValue'
        MultiSelectSeparator = ','
      end
      item
        Name = 'AdjustingOurDate'
        Value = 43248d
        Component = edAdjustingOurDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment'
        Value = ''
        Component = edComment
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isShowMorion'
        Value = Null
        Component = FormParams
        ComponentItem = 'isShowMorion'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
  end
  inherited spInsertUpdateMovement: TdsdStoredProc [11]
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumber'
        Value = ''
        Component = edInvNumber
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 42132d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumberPartner'
        Value = ''
        Component = edInvNumberPartner
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceWithVAT'
        Value = False
        Component = edPriceWithVAT
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFromId'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = '0'
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inNDSKindId'
        Value = ''
        Component = NDSKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParentId'
        Value = ''
        Component = GuidesIncome
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReturnTypeId'
        Value = ''
        Component = ReturnTypeGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inLegalAddressId'
        Value = ''
        Component = GuidesJuridicalLegalAddress
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inActualAddressId'
        Value = ''
        Component = GuidesJuridicalActualAddress
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = ''
        Component = edComment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
  end
  inherited GuidesFiller: TGuidesFiller [12]
  end
  inherited HeaderSaver: THeaderSaver [13]
  end
  inherited RefreshAddOn: TRefreshAddOn [14]
    DataSet = 'ClientDataSet'
  end
  inherited spErasedMIMaster: TdsdStoredProc [15]
  end
  inherited spUnErasedMIMaster: TdsdStoredProc [16]
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc [17]
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc [18]
  end
  inherited spGetTotalSumm: TdsdStoredProc [19]
  end
  inherited RefreshDispatcher: TRefreshDispatcher [20]
  end
  inherited PrintHeaderCDS: TClientDataSet [21]
  end
  inherited PrintItemsCDS: TClientDataSet [22]
  end
  inherited PrintItemsSverkaCDS: TClientDataSet [23]
  end
  inherited spSelectPrint: TdsdStoredProc [24]
  end
  inherited GuidesFrom: TdsdGuides [25]
    DisableGuidesOpen = True
  end
  inherited GuidesTo: TdsdGuides [26]
    DisableGuidesOpen = True
  end
  inherited NDSKindGuides: TdsdGuides [27]
  end
  inherited ContractGuides: TdsdGuides [28]
  end
  inherited spIncome_GoodsId: TdsdStoredProc [29]
  end
  inherited GuidesIncome: TdsdGuides [30]
    DisableGuidesOpen = True
  end
  inherited ReturnTypeGuides: TdsdGuides [31]
    DisableGuidesOpen = True
  end
  inherited GuidesJuridical: TdsdGuides [32]
    DisableGuidesOpen = True
  end
  inherited spUpdateReturnOut_PartnerData: TdsdStoredProc [33]
  end
  inherited GuidesJuridicalLegalAddress: TdsdGuides [34]
    DisableGuidesOpen = True
    Left = 216
    Top = 80
  end
  inherited GuidesJuridicalActualAddress: TdsdGuides [35]
    DisableGuidesOpen = True
    Left = 488
  end
  inherited spMovementComplete: TdsdStoredProc [36]
  end
  inherited spUpdate_isDeferred_No: TdsdStoredProc [37]
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDeferred'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisDeferred'
        Value = False
        Component = cbisDeferred
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
  end
  inherited spUpdate_isDeferred_Yes: TdsdStoredProc [38]
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDeferred'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisDeferred'
        Value = False
        Component = cbisDeferred
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
  end
  inherited PopupMenu: TPopupMenu [39]
    inherited N2: TMenuItem
      Visible = False
    end
    inherited N3: TMenuItem
      Visible = False
    end
  end
  inherited FormParams: TdsdFormParams [40]
  end
  inherited StatusGuides: TdsdGuides [41]
  end
  inherited spChangeStatus: TdsdStoredProc [42]
  end
end
