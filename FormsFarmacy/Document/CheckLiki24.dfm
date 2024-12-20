inherited CheckLiki24Form: TCheckLiki24Form
  Caption = #1054#1090#1083#1086#1078#1077#1085#1085#1099#1077' '#1095#1077#1082#1080' '#1085#1072' '#1084#1086#1084#1077#1085#1090' '#1087#1086#1089#1083#1077#1076#1085#1077#1075#1086' '#1086#1085#1083#1072#1081#1085
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
  inherited spSelect: TdsdStoredProc [3]
    Params = <
      item
        Name = 'inType'
        Value = 3
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
  end
  inherited BarManager: TdxBarManager [4]
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
          ItemName = 'bbUpdateOperDate'
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
          ItemName = 'dxBarButton4'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton5'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel'
        end>
    end
  end
  inherited ActionList: TActionList [5]
    inherited actRefresh: TdsdDataSetRefresh
      StoredProc = spSelectLocal
      StoredProcList = <
        item
          StoredProc = spSelectLocal
        end>
    end
    inherited actShowErased: TBooleanStoredProcAction
      StoredProc = spSelectLocal
      StoredProcList = <
        item
          StoredProc = spSelectLocal
        end>
    end
    inherited dsdChoiceGuides: TdsdChoiceGuides
      Params = <
        item
          Name = 'Key'
          Component = MasterCDS
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Component = MasterCDS
          ComponentItem = 'Bayer'
          MultiSelectSeparator = ','
        end
        item
          Name = 'CashMemberId'
          Component = MasterCDS
          ComponentItem = 'CashMemberId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'CashMember'
          Component = MasterCDS
          ComponentItem = 'CashMember'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'DiscountExternalId'
          Component = MasterCDS
          ComponentItem = 'DiscountExternalId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'DiscountExternalName'
          Component = MasterCDS
          ComponentItem = 'DiscountExternalName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'DiscountCardNumber'
          Component = MasterCDS
          ComponentItem = 'DiscountCardNumber'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ConfirmedKindName'
          Component = MasterCDS
          ComponentItem = 'ConfirmedKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'BayerPhone'
          Component = MasterCDS
          ComponentItem = 'BayerPhone'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumberOrder'
          Component = MasterCDS
          ComponentItem = 'InvNumberOrder'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ConfirmedKindClientName'
          Component = MasterCDS
          ComponentItem = 'ConfirmedKindClientName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerMedicalId'
          Component = MasterCDS
          ComponentItem = 'PartnerMedicalId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerMedicalName'
          Component = MasterCDS
          ComponentItem = 'PartnerMedicalName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Ambulance'
          Component = MasterCDS
          ComponentItem = 'Ambulance'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MedicSP'
          Component = MasterCDS
          ComponentItem = 'MedicSP'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumberSP'
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
          Component = MasterCDS
          ComponentItem = 'SPKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'SPKindName'
          Component = MasterCDS
          ComponentItem = 'SPKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'SPTax'
          Component = MasterCDS
          ComponentItem = 'SPTax'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'ManualDiscount'
          Component = MasterCDS
          ComponentItem = 'ManualDiscount'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PromoCodeID'
          Component = MasterCDS
          ComponentItem = 'PromoCodeID'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PromoName'
          Component = MasterCDS
          ComponentItem = 'PromoName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PromoCodeGUID'
          Component = MasterCDS
          ComponentItem = 'PromoCodeGUID'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PromoCodeChangePercent'
          Component = MasterCDS
          ComponentItem = 'PromoCodeChangePercent'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'MemberSPId'
          Component = MasterCDS
          ComponentItem = 'MemberSPId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'SiteDiscount'
          Component = MasterCDS
          ComponentItem = 'SiteDiscount'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartionDateKindId'
          Component = MasterCDS
          ComponentItem = 'PartionDateKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartionDateKindName'
          Component = MasterCDS
          ComponentItem = 'PartionDateKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'AmountMonth'
          Component = MasterCDS
          ComponentItem = 'AmountMonth'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'LoyaltyChangeSumma'
          Component = MasterCDS
          ComponentItem = 'LoyaltyChangeSumma'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'SummCard'
          Component = MasterCDS
          ComponentItem = 'SummCard'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'isBanAdd'
          Component = MasterCDS
          ComponentItem = 'isBanAdd'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isDiscountCommit'
          Component = MasterCDS
          ComponentItem = 'isDiscountCommit'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isAutoVIPforSales'
          Component = MasterCDS
          ComponentItem = 'isAutoVIPforSales'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'MobileDiscount'
          Component = MasterCDS
          ComponentItem = 'MobileDiscount'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'isMobileFirstOrder'
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
    inherited acteSputnikSendSMS: TdsdeSputnikSendSMS
      UserNameParam.Value = ''
      PasswordParam.Value = ''
      FromParam.Value = ''
      TextParam.Value = ''
      PhoneParam.Value = ''
      SendParam.Value = True
    end
    object Action1: TAction
      Category = 'DSDLib'
      Caption = 'Action1'
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn [6]
  end
  inherited PopupMenu: TPopupMenu [7]
  end
  inherited ClientDataSet1: TClientDataSet [8]
  end
  inherited DataSource1: TDataSource [9]
  end
  inherited dsdDBViewAddOn1: TdsdDBViewAddOn [10]
  end
  inherited spMovementSetErased: TdsdStoredProc [11]
  end
  inherited spConfirmedKind_Complete: TdsdStoredProc [12]
  end
  inherited spConfirmedKind_UnComplete: TdsdStoredProc [13]
  end
  inherited spUpdateMovementItemAmount: TdsdStoredProc [14]
  end
  inherited spSmashCheck: TdsdStoredProc [15]
  end
  inherited spUpdateOperDate: TdsdStoredProc [16]
  end
  inherited MasterDS: TDataSource [17]
  end
  inherited MasterCDS: TClientDataSet [18]
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'CancelReasonId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'isSend'
        Value = True
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'UserName'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Password'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'FromName'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BayerPhone'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'SMSText'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end>
  end
  inherited speSputnikSMSParams: TdsdStoredProc
    Params = <
      item
        Name = 'inMovementId'
        Value = 0
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isSend'
        Value = Null
        Component = FormParams
        ComponentItem = 'isSend'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'UserName'
        Value = Null
        Component = FormParams
        ComponentItem = 'UserName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Password'
        Value = Null
        Component = FormParams
        ComponentItem = 'Password'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'FromName'
        Value = Null
        Component = FormParams
        ComponentItem = 'FromName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BayerPhone'
        Value = Null
        Component = FormParams
        ComponentItem = 'BayerPhone'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'SMSText'
        Value = Null
        Component = FormParams
        ComponentItem = 'SMSText'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
  end
  object spSelectLocal: TdsdStoredProcSQLite
    StoredProcName = 'gpSelect_Movement_CheckCashDeferred'
    DataSet = MasterCDS
    DataSets = <
      item
        DataSet = MasterCDS
      end
      item
        DataSet = ClientDataSet1
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inType'
        Value = '2'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    SQLList = <
      item
        SQL.Strings = (
          'select * from VIP')
      end
      item
        SQL.Strings = (
          'select * from VIPList')
      end>
    Left = 72
    Top = 200
  end
end
