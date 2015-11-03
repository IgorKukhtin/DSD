inherited PaymentForm: TPaymentForm
  Caption = #1054#1087#1083#1072#1090#1099' '#1087#1088#1080#1093#1086#1076#1086#1074
  ClientHeight = 614
  ClientWidth = 1005
  AddOnFormData.AddOnFormRefresh.ParentList = 'Payment'
  ExplicitWidth = 1021
  ExplicitHeight = 652
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 123
    Width = 1005
    Height = 491
    ExplicitTop = 123
    ExplicitWidth = 1005
    ExplicitHeight = 491
    ClientRectBottom = 491
    ClientRectRight = 1005
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1005
      ExplicitHeight = 467
      inherited cxGrid: TcxGrid
        Width = 1005
        Height = 467
        ExplicitWidth = 1005
        ExplicitHeight = 467
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
              Column = colIncome_TotalSumm
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colIncome_PaySumm
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colSummaPay
            end>
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colId: TcxGridDBColumn [0]
            DataBinding.FieldName = 'Id'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
          end
          inherited colIsErased: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          object colIncome_InvNumber: TcxGridDBColumn
            Caption = #8470' '#1055'/'#1053
            DataBinding.FieldName = 'Income_InvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 61
          end
          object colIncome_Operdate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1055'/'#1053
            DataBinding.FieldName = 'Income_Operdate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object colIncome_PaymentDate: TcxGridDBColumn
            AlternateCaption = #1044#1072#1090#1072' '#1086#1087#1083#1072#1090#1099
            Caption = #1044#1072#1090#1072' '#1086#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'Income_PaymentDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object colIncome_StatusName: TcxGridDBColumn
            Caption = #1057#1090#1072#1090#1091#1089' '#1055'/'#1053
            DataBinding.FieldName = 'Income_StatusName'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 3
            Properties.DisplayFormat = ',0.000'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object colIncome_JuridicalName: TcxGridDBColumn
            Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
            DataBinding.FieldName = 'Income_JuridicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 137
          end
          object colIncome_UnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'Income_UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 104
          end
          object colIncome_NDSKindName: TcxGridDBColumn
            Caption = #1053#1044#1057
            DataBinding.FieldName = 'Income_NDSKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 47
          end
          object colIncome_ContractName: TcxGridDBColumn
            Caption = #1044#1086#1075#1086#1074#1086#1088
            DataBinding.FieldName = 'Income_ContractName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 79
          end
          object colIncome_TotalSumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1055'/'#1053
            DataBinding.FieldName = 'Income_TotalSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
          object colIncome_PaySumm: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082
            DataBinding.FieldName = 'Income_PaySumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 56
          end
          object colSummaPay: TcxGridDBColumn
            Caption = #1050' '#1086#1087#1083#1072#1090#1077
            DataBinding.FieldName = 'SummaPay'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 61
          end
          object colNeedPay: TcxGridDBColumn
            Caption = #1055#1083#1072#1090#1080#1090#1100
            DataBinding.FieldName = 'NeedPay'
            PropertiesClassName = 'TcxCheckBoxProperties'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 59
          end
          object colBankAccountName: TcxGridDBColumn
            Caption = #1056'/'#1057
            DataBinding.FieldName = 'AccountName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actOpenBankAccount
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 85
          end
          object colBankName: TcxGridDBColumn
            Caption = #1041#1072#1085#1082
            DataBinding.FieldName = 'BankName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 77
          end
        end
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 1005
    Height = 97
    TabOrder = 3
    ExplicitWidth = 1005
    ExplicitHeight = 97
    inherited ceStatus: TcxButtonEdit
      ExplicitHeight = 22
    end
    object lblJuridical: TcxLabel
      Left = 8
      Top = 51
      Caption = #1070#1088#1083#1080#1094#1086' '#1087#1083#1072#1090#1077#1083#1100#1097#1080#1082
    end
    object edJuridical: TcxButtonEdit
      Left = 8
      Top = 69
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 7
      Width = 270
    end
    object cxLabel4: TcxLabel
      Left = 427
      Top = 51
      Caption = #1048#1090#1086#1075#1086' '#1089#1091#1084#1084#1072
    end
    object edTotalSumm: TcxCurrencyEdit
      Left = 428
      Top = 69
      Properties.DisplayFormat = ',0.00'
      Properties.ReadOnly = True
      TabOrder = 9
      Width = 66
    end
    object cxLabel5: TcxLabel
      Left = 306
      Top = 51
      Caption = #1048#1090#1086#1075#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074
    end
    object edTotalCount: TcxCurrencyEdit
      Left = 306
      Top = 69
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0'
      Properties.ReadOnly = True
      TabOrder = 11
      Width = 63
    end
  end
  object deDateStart: TcxDateEdit [2]
    Left = 462
    Top = 4
    EditValue = 42132d
    TabOrder = 6
    Width = 82
  end
  object deDateEnd: TcxDateEdit [3]
    Left = 550
    Top = 4
    EditValue = 42132d
    TabOrder = 7
    Width = 79
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = deDateEnd
        Properties.Strings = (
          'Date'
          'EditValue')
      end
      item
        Component = deDateStart
        Properties.Strings = (
          'Date'
          'EditValue')
      end>
  end
  inherited ActionList: TActionList
    inherited actPrint: TdsdPrintAction
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end
        item
          DataSet = PrintItemsVATCDS
          UserName = 'frxItemsVAT'
        end>
      ReportName = #1054#1087#1083#1072#1090#1099
      ReportNameParam.Value = #1054#1087#1083#1072#1090#1099
    end
    object actOpenBankAccount: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = #1042#1099#1073#1086#1088' '#1056'/'#1057
      FormName = 'TBankAccount_ObjectForm'
      FormNameParam.Value = 'TBankAccount_ObjectForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'AccountId'
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'AccountName'
          DataType = ftString
        end
        item
          Name = 'BankName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BankName'
          DataType = ftString
          ParamType = ptInput
        end>
      isShowModal = False
    end
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_Payment'
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inShowAll'
        Value = False
        Component = FormParams
        ComponentItem = 'ShowAll'
        DataType = ftBoolean
        ParamType = ptInput
      end
      item
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
      end
      item
        Name = 'inDateStart'
        Value = Null
        Component = deDateStart
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inDateEnd'
        Value = Null
        Component = deDateEnd
        DataType = ftDateTime
        ParamType = ptInput
      end>
  end
  inherited BarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbInsertUpdateMovement'
        end
        item
          Visible = True
          ItemName = 'bbShowErased'
        end
        item
          Visible = True
          ItemName = 'bbShowAll'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarControlContainerItem1'
        end
        item
          Visible = True
          ItemName = 'dxBarControlContainerItem2'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbAddMask'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbErased'
        end
        item
          Visible = True
          ItemName = 'bbUnErased'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
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
          ItemName = 'bbMovementItemContainer'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbMovementItemProtocol'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrint'
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
    inherited bbAddMask: TdxBarButton
      Visible = ivNever
    end
    inherited bbMovementItemContainer: TdxBarButton
      Visible = ivNever
    end
    object dxBarControlContainerItem1: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = deDateStart
    end
    object dxBarControlContainerItem2: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = deDateEnd
    end
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
      end
      item
        Name = 'Key'
        Value = Null
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'ShowAll'
        Value = False
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInputOutput
      end
      item
        Name = 'TotalCount'
        Value = Null
        Component = edTotalCount
        DataType = ftFloat
      end
      item
        Name = 'TotalSumm'
        Value = Null
        Component = edTotalSumm
        DataType = ftFloat
      end>
    Left = 40
    Top = 312
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_Payment'
    NeedResetData = True
    ParamKeyField = 'inMovementId'
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Payment'
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inDateStart'
        Value = Null
        Component = deDateStart
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inDateEnd'
        Value = Null
        Component = deDateEnd
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
        Name = 'InvNumber'
        Value = ''
        Component = edInvNumber
      end
      item
        Name = 'OperDate'
        Value = 0d
        Component = edOperDate
      end
      item
        Name = 'StatusCode'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'StatusName'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'TotalCount'
        Value = Null
        Component = edTotalCount
        DataType = ftString
      end
      item
        Name = 'TotalSumm'
        Value = Null
        Component = edTotalSumm
        DataType = ftString
      end
      item
        Name = 'JuridicalId'
        Value = Null
        Component = GuidesJuridical
        ComponentItem = 'Key'
      end
      item
        Name = 'JuridicalName'
        Value = Null
        Component = GuidesJuridical
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'DateStart'
        Value = Null
        Component = deDateStart
        DataType = ftDateTime
      end
      item
        Name = 'DateEnd'
        Value = Null
        Component = deDateEnd
        DataType = ftDateTime
      end>
    Left = 72
    Top = 224
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_Payment'
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inInvNumber'
        Value = ''
        Component = edInvNumber
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inOperDate'
        Value = 42132d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inJuridicalId'
        Value = Null
        Component = GuidesJuridical
        ComponentItem = 'Key'
        ParamType = ptInput
      end>
    NeedResetData = True
    ParamKeyField = 'ioId'
    Left = 282
    Top = 272
  end
  inherited GuidesFiller: TGuidesFiller
    GuidesList = <
      item
        Guides = GuidesJuridical
      end
      item
      end>
    ActionItemList = <
      item
        Action = actInsertUpdateMovement
      end
      item
        Action = actRefresh
      end>
  end
  inherited HeaderSaver: THeaderSaver
    ControlList = <
      item
        Control = edOperDate
      end
      item
      end
      item
        Control = edJuridical
      end
      item
      end>
    Left = 200
    Top = 177
  end
  inherited RefreshAddOn: TRefreshAddOn
    Left = 72
    Top = 312
  end
  inherited spErasedMIMaster: TdsdStoredProc
    Left = 550
    Top = 224
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    Left = 550
    Top = 256
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_Payment'
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inIncomeId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'IncomeId'
        ParamType = ptInput
      end
      item
        Name = 'ioBankAccountId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'BankAccountId'
        ParamType = ptInputOutput
      end
      item
        Name = 'ioAccountId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AccountId'
        ParamType = ptInputOutput
      end
      item
        Name = 'outAccountName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AccountName'
        DataType = ftString
      end
      item
        Name = 'outBankName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'BankName'
        DataType = ftString
      end
      item
        Name = 'inSummaPay'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SummaPay'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inNeedPay'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'NeedPay'
        DataType = ftBoolean
        ParamType = ptInput
      end>
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 400
    Top = 272
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    Left = 400
    Top = 320
  end
  inherited spGetTotalSumm: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Payment_TotalSumm'
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'TotalCount'
        Value = Null
        Component = FormParams
        ComponentItem = 'TotalCount'
        DataType = ftString
      end
      item
        Name = 'TotalSumm'
        Value = Null
        Component = FormParams
        ComponentItem = 'TotalSumm'
        DataType = ftString
      end>
    Left = 548
    Top = 172
  end
  object GuidesJuridical: TdsdGuides
    KeyField = 'Id'
    LookupControl = edJuridical
    FormNameParam.Value = 'TJuridicalCorporateForm'
    FormNameParam.DataType = ftString
    FormName = 'TJuridicalCorporateForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 64
    Top = 56
  end
  object spSelectPrint: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Payment_Print'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end
      item
        DataSet = PrintItemsCDS
      end
      item
        DataSet = PrintItemsVATCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 415
    Top = 208
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 476
    Top = 206
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 444
    Top = 209
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deDateStart
    DateEnd = deDateEnd
    Left = 120
    Top = 96
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = PeriodChoice
      end>
    Left = 152
    Top = 96
  end
  object PrintItemsVATCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 516
    Top = 206
  end
end
