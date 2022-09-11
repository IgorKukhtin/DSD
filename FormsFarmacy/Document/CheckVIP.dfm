inherited CheckVIPForm: TCheckVIPForm
  Caption = 'VIP '#1095#1077#1082#1080
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
          inherited TypeChech: TcxGridDBColumn
            Visible = False
            VisibleForCustomization = False
          end
        end
      end
      inherited Panel1: TPanel
        inherited cxGrid1: TcxGrid
          inherited cxGridDBTableView1: TcxGridDBTableView
            Styles.Content = nil
            Styles.Inactive = nil
            Styles.Selection = nil
            Styles.Footer = nil
            Styles.Header = nil
          end
        end
        inherited cxDBMemo1: TcxDBMemo
          Style.IsFontAssigned = True
        end
      end
    end
  end
  inherited SPUpdate_NotMCS: TdsdStoredProc [1]
  end
  inherited spMovementSetErased: TdsdStoredProc [2]
  end
  inherited spConfirmedKind_Complete: TdsdStoredProc [3]
  end
  inherited spConfirmedKind_UnComplete: TdsdStoredProc [4]
  end
  inherited spUpdateMovementItemAmount: TdsdStoredProc [5]
  end
  inherited PopupMenu: TPopupMenu [6]
  end
  inherited DBViewAddOn: TdsdDBViewAddOn [7]
  end
  inherited spSmashCheck: TdsdStoredProc [8]
  end
  inherited spUpdateOperDate: TdsdStoredProc [9]
  end
  inherited spMovementSetErasedSite: TdsdStoredProc [10]
  end
  inherited ClientDataSet1: TClientDataSet [11]
  end
  inherited DataSource1: TDataSource [12]
  end
  inherited dsdDBViewAddOn1: TdsdDBViewAddOn [13]
  end
  inherited FormParams: TdsdFormParams [14]
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn [15]
  end
  inherited cxPropertiesStore: TcxPropertiesStore [16]
  end
  inherited spSelect: TdsdStoredProc [17]
    Params = <
      item
        Name = 'inType'
        Value = 1
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
  end
  inherited BarManager: TdxBarManager [18]
    DockControlHeights = (
      0
      0
      26
      0)
  end
  inherited ActionList: TActionList [19]
    inherited dsdChoiceGuides: TdsdChoiceGuides
      Params = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Bayer'
          MultiSelectSeparator = ','
        end
        item
          Name = 'CashMemberId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'CashMemberId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'CashMember'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'CashMember'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'DiscountExternalId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'DiscountExternalId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'DiscountExternalName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'DiscountExternalName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'DiscountCardNumber'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'DiscountCardNumber'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ConfirmedKindName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ConfirmedKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'BayerPhone'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BayerPhone'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumberOrder'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InvNumberOrder'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ConfirmedKindClientName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ConfirmedKindClientName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerMedicalId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartnerMedicalId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerMedicalName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartnerMedicalName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Ambulance'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Ambulance'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MedicSP'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MedicSP'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumberSP'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InvNumberSP'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDateSP'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'OperDateSP'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'SPKindId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'SPKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'SPKindName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'SPKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'SPTax'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'SPTax'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'ManualDiscount'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ManualDiscount'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PromoCodeID'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PromoCodeID'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PromoName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PromoName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PromoCodeGUID'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PromoCodeGUID'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PromoCodeChangePercent'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PromoCodeChangePercent'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'MemberSPId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MemberSPId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'SiteDiscount'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'SiteDiscount'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartionDateKindId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartionDateKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartionDateKindName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartionDateKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'AmountMonth'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'AmountMonth'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'LoyaltyChangeSumma'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'LoyaltyChangeSumma'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'SummCard'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'SummCard'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'isBanAdd'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'isBanAdd'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isDiscountCommit'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'isDiscountCommit'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isAutoVIPforSales'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'isAutoVIPforSales'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'MobileDiscount'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MobileDiscount'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'isMobileFirstOrder'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'isMobileFirstOrder'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
    end
    inherited actCheckCash: TdsdOpenForm
      GuiParams = <
        item
          Name = 'Id'
          Component = MasterCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ShowAll'
          Value = False
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
    end
  end
  inherited MasterDS: TDataSource [20]
  end
  inherited MasterCDS: TClientDataSet [21]
  end
  inherited spPUSHSetErased: TdsdStoredProc [22]
  end
end
