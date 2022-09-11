inherited CheckVIP_SearchForm: TCheckVIP_SearchForm
  Caption = #1055#1086#1080#1089#1082' '#1084#1077#1076#1080#1082#1072#1084#1077#1085#1090#1086#1074' '#1074' VIP '#1095#1077#1082#1072#1093'   '
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
    end
  end
  inherited ActionList: TActionList [1]
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
  end
  inherited MasterDS: TDataSource [3]
  end
  inherited spSelect: TdsdStoredProc [4]
    Params = <
      item
        Name = 'inType'
        Value = 1
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
  end
  inherited spMovementSetErasedSite: TdsdStoredProc [6]
  end
  inherited FormParams: TdsdFormParams [7]
  end
  inherited BarManager: TdxBarManager [8]
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton2'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton3'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbConfirmedKind_Complete'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbConfirmedKind_UnComplete'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn [9]
  end
  inherited DBViewAddOn: TdsdDBViewAddOn [11]
  end
  inherited DataSource1: TDataSource [12]
  end
  inherited PopupMenu: TPopupMenu [13]
  end
  inherited dsdDBViewAddOn1: TdsdDBViewAddOn [14]
  end
  inherited spMovementSetErased: TdsdStoredProc [15]
  end
  inherited spConfirmedKind_Complete: TdsdStoredProc [16]
  end
  inherited spConfirmedKind_UnComplete: TdsdStoredProc [17]
  end
end
