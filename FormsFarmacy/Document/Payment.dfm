inherited PaymentForm: TPaymentForm
  Caption = #1054#1087#1083#1072#1090#1099' '#1087#1088#1080#1093#1086#1076#1086#1074
  ClientHeight = 513
  ClientWidth = 1005
  AddOnFormData.AddOnFormRefresh.ParentList = 'Payment'
  ExplicitWidth = 1021
  ExplicitHeight = 552
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 67
    Width = 1005
    Height = 446
    ExplicitTop = 67
    ExplicitWidth = 1005
    ExplicitHeight = 446
    ClientRectBottom = 446
    ClientRectRight = 1005
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1005
      ExplicitHeight = 422
      inherited cxGrid: TcxGrid
        Top = 61
        Width = 1005
        Height = 361
        ExplicitTop = 61
        ExplicitWidth = 1005
        ExplicitHeight = 361
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
              Column = Income_TotalSumm
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = Income_PaySumm
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummaPay
            end
            item
              Format = '+,0.00;-,0.00; ;'
              Kind = skSum
              Column = SummaCorrBonus
            end
            item
              Format = '+,0.00;-,0.00; ;'
              Kind = skSum
              Column = SummaCorrReturnOut
            end
            item
              Format = '+,0.00;-,0.00; ;'
              Kind = skSum
              Column = SummaCorrOther
            end>
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object Id: TcxGridDBColumn [0]
            DataBinding.FieldName = 'Id'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
          end
          inherited colIsErased: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          object Income_InvNumber: TcxGridDBColumn
            Caption = #8470' '#1055'/'#1053
            DataBinding.FieldName = 'Income_InvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 61
          end
          object Income_Operdate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1055'/'#1053
            DataBinding.FieldName = 'Income_Operdate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object Income_PaymentDate: TcxGridDBColumn
            AlternateCaption = #1044#1072#1090#1072' '#1086#1087#1083#1072#1090#1099
            Caption = #1044#1072#1090#1072' '#1086#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'Income_PaymentDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Income_StatusName: TcxGridDBColumn
            Caption = #1057#1090#1072#1090#1091#1089' '#1055'/'#1053
            DataBinding.FieldName = 'Income_StatusName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object Income_JuridicalName: TcxGridDBColumn
            Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
            DataBinding.FieldName = 'Income_JuridicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 137
          end
          object Income_UnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'Income_UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 104
          end
          object Income_NDS: TcxGridDBColumn
            Caption = #1053#1044#1057
            DataBinding.FieldName = 'Income_NDS'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 47
          end
          object Income_ContractName: TcxGridDBColumn
            Caption = #1044#1086#1075#1086#1074#1086#1088
            DataBinding.FieldName = 'Income_ContractName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 79
          end
          object Income_TotalSumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1055'/'#1053
            DataBinding.FieldName = 'Income_TotalSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
          object Income_PaySumm: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082
            DataBinding.FieldName = 'Income_PaySumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 56
          end
          object SummaCorrBonus: TcxGridDBColumn
            Caption = #1054#1087#1083#1072#1090#1072' '#1073#1086#1085#1091#1089#1086#1084
            DataBinding.FieldName = 'SummaCorrBonus'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 67
          end
          object SummaCorrReturnOut: TcxGridDBColumn
            Caption = #1054#1087#1083#1072#1090#1072' '#1074#1086#1079#1074#1088#1072#1090#1086#1084
            DataBinding.FieldName = 'SummaCorrReturnOut'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 78
          end
          object SummaCorrOther: TcxGridDBColumn
            Caption = #1054#1087#1083#1072#1090#1072' '#1087#1088#1086#1095#1080#1084#1080' '#1082#1086#1088#1088'.'
            DataBinding.FieldName = 'SummaCorrOther'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 71
          end
          object SummaPay: TcxGridDBColumn
            Caption = #1050' '#1086#1087#1083#1072#1090#1077
            DataBinding.FieldName = 'SummaPay'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 61
          end
          object NeedPay: TcxGridDBColumn
            Caption = #1055#1083#1072#1090#1080#1090#1100
            DataBinding.FieldName = 'NeedPay'
            PropertiesClassName = 'TcxCheckBoxProperties'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 59
          end
          object isPartialPay: TcxGridDBColumn
            Caption = #1063#1072#1089#1090#1080#1095#1085'. '#1086#1087#1083#1072#1090#1072
            DataBinding.FieldName = 'isPartialPay'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1063#1072#1089#1090#1080#1095#1085#1072#1103' '#1086#1087#1083#1072#1090#1072
            Width = 60
          end
          object BankAccountName: TcxGridDBColumn
            Caption = #1056'/'#1057
            DataBinding.FieldName = 'BankAccountName'
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
          object BankName: TcxGridDBColumn
            Caption = #1041#1072#1085#1082
            DataBinding.FieldName = 'BankName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 77
          end
          object Income_PayOrder: TcxGridDBColumn
            Caption = #1054#1095#1077#1088#1077#1076#1100' '#1087#1083#1072#1090#1077#1078#1072
            DataBinding.FieldName = 'Income_PayOrder'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
          object ContractNumber: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object ContractStartDate: TcxGridDBColumn
            Caption = #1044#1077#1081#1089#1090#1074'. '#1089
            DataBinding.FieldName = 'ContractStartDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object ContractEndDate: TcxGridDBColumn
            Caption = #1044#1077#1081#1089#1090#1074'. '#1076#1086
            DataBinding.FieldName = 'ContractEndDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
        end
      end
      object cxGrid1: TcxGrid
        Left = 0
        Top = 0
        Width = 1005
        Height = 53
        Align = alTop
        PopupMenu = PopupMenu
        TabOrder = 1
        object cxGridDBTableView1: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = PaymentCorrSummDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsBehavior.GoToNextCellOnEnter = True
          OptionsBehavior.FocusCellOnCycle = True
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsCustomize.DataRowSizing = True
          OptionsData.CancelOnExit = False
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsData.Inserting = False
          OptionsView.GroupByBox = False
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object ContainerAmountBonus: TcxGridDBColumn
            Caption = #1041#1086#1085#1091#1089
            DataBinding.FieldName = 'ContainerAmountBonus'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 75
          end
          object ContainerAmountReturnOut: TcxGridDBColumn
            Caption = #1042#1086#1079#1074#1088#1072#1090
            DataBinding.FieldName = 'ContainerAmountReturnOut'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 75
          end
          object ContainerAmountOther: TcxGridDBColumn
            Caption = #1055#1088#1086#1095#1077#1077
            DataBinding.FieldName = 'ContainerAmountOther'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 75
          end
          object ContainerAmountPartialSale: TcxGridDBColumn
            Caption = #1054#1087#1083'. '#1095#1072#1089#1090#1103#1084#1080
            DataBinding.FieldName = 'ContainerAmountPartialSale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 75
          end
          object CorrBonus: TcxGridDBColumn
            Caption = #1048#1089#1087'. '#1073#1086#1085#1091#1089
            DataBinding.FieldName = 'CorrBonus'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1085#1099#1081' '#1073#1086#1085#1091#1089' '#1074' '#1090#1077#1082#1091#1097#1077#1084' '#1076#1086#1082#1091#1084#1077#1085#1090#1077
            Width = 75
          end
          object CorrReturnOut: TcxGridDBColumn
            Caption = #1048#1089#1087'. '#1074#1086#1079#1074#1088#1072#1090
            DataBinding.FieldName = 'CorrReturnOut'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1085#1099#1081' '#1074#1086#1079#1074#1088#1072#1090' '#1074' '#1090#1077#1082#1091#1097#1077#1084' '#1076#1086#1082#1091#1084#1077#1085#1090#1077
            Width = 75
          end
          object CorrOther: TcxGridDBColumn
            Caption = #1048#1089#1087'. '#1087#1088#1086#1095#1077#1077
            DataBinding.FieldName = 'CorrOther'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1085#1072' '#1087#1088#1086#1095#1072#1103' '#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1074' '#1090#1077#1082#1091#1097#1077#1084' '#1076#1086#1082#1091#1084#1077#1085#1090#1077
            Width = 75
          end
          object CorrPartialSale: TcxGridDBColumn
            Caption = #1048#1089#1087'. '#1086#1087#1083'. '#1095#1072#1089#1090#1103#1084#1080
            DataBinding.FieldName = 'CorrPartialSale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 75
          end
          object LeftCorrBonus: TcxGridDBColumn
            Caption = #1054#1089#1090'. '#1073#1086#1085#1091#1089
            DataBinding.FieldName = 'LeftCorrBonus'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1089#1090#1072#1090#1086#1082' '#1073#1086#1085#1091#1089#1072' '#1087#1086#1089#1083#1077' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1103' '#1090#1077#1082#1091#1097#1077#1075#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
            Width = 75
          end
          object LeftCorrReturnOut: TcxGridDBColumn
            Caption = #1054#1089#1090'. '#1074#1086#1079#1074#1088#1072#1090
            DataBinding.FieldName = 'LeftCorrReturnOut'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1089#1090#1072#1090#1086#1082' '#1074#1086#1079#1074#1088#1072#1090#1072' '#1087#1086#1089#1083#1077' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1103' '#1090#1077#1082#1091#1097#1077#1075#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
            Width = 75
          end
          object LeftCorrOther: TcxGridDBColumn
            Caption = #1054#1089#1090'. '#1087#1088#1086#1095#1077#1077
            DataBinding.FieldName = 'LeftCorrOther'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1089#1090#1072#1090#1086#1082' '#1087#1088#1086#1095#1077#1081' '#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1080' '#1087#1086#1089#1083#1077' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1103' '#1090#1077#1082#1091#1097#1077#1075#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
            Width = 75
          end
          object LeftCorrPartialSale: TcxGridDBColumn
            Caption = #1054#1089#1090'.  '#1086#1087#1083'. '#1095#1072#1089#1090#1103#1084#1080
            DataBinding.FieldName = 'LeftCorrPartialSale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 75
          end
        end
        object cxGridLevel1: TcxGridLevel
          GridView = cxGridDBTableView1
        end
      end
      object cxSplitter1: TcxSplitter
        Left = 0
        Top = 53
        Width = 1005
        Height = 8
        HotZoneClassName = 'TcxMediaPlayer8Style'
        AlignSplitter = salTop
        Control = cxGrid1
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 1005
    Height = 41
    TabOrder = 3
    ExplicitWidth = 1005
    ExplicitHeight = 41
    inherited edInvNumber: TcxTextEdit
      Left = 165
      Top = 17
      ExplicitLeft = 165
      ExplicitTop = 17
    end
    inherited cxLabel1: TcxLabel
      Left = 165
      Top = 2
      ExplicitLeft = 165
      ExplicitTop = 2
    end
    inherited edOperDate: TcxDateEdit
      Left = 265
      Top = 17
      ExplicitLeft = 265
      ExplicitTop = 17
    end
    inherited cxLabel2: TcxLabel
      Left = 265
      Top = 2
      ExplicitLeft = 265
      ExplicitTop = 2
    end
    inherited cxLabel15: TcxLabel
      Left = 3
      Top = 2
      ExplicitLeft = 3
      ExplicitTop = 2
    end
    inherited ceStatus: TcxButtonEdit
      Left = 3
      Top = 17
      ExplicitLeft = 3
      ExplicitTop = 17
      ExplicitHeight = 22
    end
    object lblJuridical: TcxLabel
      Left = 371
      Top = 2
      Caption = #1070#1088#1083#1080#1094#1086' '#1087#1083#1072#1090#1077#1083#1100#1097#1080#1082
    end
    object edJuridical: TcxButtonEdit
      Left = 371
      Top = 17
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 7
      Width = 252
    end
    object cxLabel4: TcxLabel
      Left = 739
      Top = 2
      Caption = #1048#1090#1086#1075#1086' '#1089#1091#1084#1084#1072
    end
    object edTotalSumm: TcxCurrencyEdit
      Left = 740
      Top = 17
      Properties.DisplayFormat = ',0.00'
      Properties.ReadOnly = True
      TabOrder = 9
      Width = 66
    end
    object cxLabel5: TcxLabel
      Left = 633
      Top = 2
      Caption = #1048#1090#1086#1075#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074
    end
    object edTotalCount: TcxCurrencyEdit
      Left = 629
      Top = 17
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0'
      Properties.ReadOnly = True
      TabOrder = 11
      Width = 63
    end
    object cbPaymentFormed: TcxCheckBox
      Left = 811
      Top = 17
      Hint = #1055#1083#1072#1090#1077#1078' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085
      Caption = #1055#1083#1072#1090#1077#1078' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085
      ParentShowHint = False
      ShowHint = True
      TabOrder = 12
      Width = 142
    end
  end
  object deDateStart: TcxDateEdit [2]
    Left = 812
    Top = 8
    EditValue = 42132d
    TabOrder = 6
    Width = 82
  end
  object deDateEnd: TcxDateEdit [3]
    Left = 894
    Top = 8
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
    Left = 87
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spGetTotalSumm
        end
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelect_PaymentCorrSumm
        end>
    end
    object actRefreshLite: TdsdDataSetRefresh [1]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spGetTotalSumm
        end
        item
          StoredProc = spSelect_PaymentCorrSumm
        end>
      Caption = 'actRefreshLite'
      Hint = 'actRefreshLite'
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    inherited actMISetErased: TdsdUpdateErased
      StoredProcList = <
        item
          StoredProc = spErasedMIMaster
        end
        item
          StoredProc = spInsertUpdate_MovementFloat_TotalSummPayment
        end
        item
          StoredProc = spGetTotalSumm
        end>
    end
    inherited actMISetUnErased: TdsdUpdateErased
      StoredProcList = <
        item
          StoredProc = spUnErasedMIMaster
        end
        item
          StoredProc = spInsertUpdate_MovementFloat_TotalSummPayment
        end
        item
          StoredProc = spGetTotalSumm
        end>
    end
    inherited actUpdateMainDS: TdsdUpdateDataSet
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIMaster
        end
        item
          StoredProc = spGetTotalSumm
        end
        item
          StoredProc = spSelect_PaymentCorrSumm
        end>
    end
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
    inherited MovementItemProtocolOpenForm: TdsdOpenForm
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Income_InvNumber'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
    end
    object actOpenBankAccount: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = #1042#1099#1073#1086#1088' '#1056'/'#1057
      FormName = 'TBankAccountForm'
      FormNameParam.Value = 'TBankAccountForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BankAccountId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BankAccountName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'BankName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BankName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actSelectAllAndRefresh: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actGet_Payment_Detail
        end
        item
          Action = mactSelectAll
        end
        item
          Action = actInsertUpdate_MovementFloat_TotalSummPayment
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1042#1099#1076#1077#1083#1080#1090#1100' '#1074#1089#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1076#1083#1103' '#1086#1087#1083#1072#1090#1099'?'
      Caption = #1042#1099#1076#1077#1083#1080#1090#1100' '#1074#1089#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1076#1083#1103' '#1086#1087#1083#1072#1090#1099
      Hint = #1042#1099#1076#1077#1083#1080#1090#1100' '#1074#1089#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1076#1083#1103' '#1086#1087#1083#1072#1090#1099
      ImageIndex = 28
    end
    object mactSelectAll: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actInsertUpdate_MovementItem_Payment_NeedPay
        end>
      View = cxGridDBTableView
      Caption = #1042#1099#1076#1077#1083#1080#1090#1100' '#1074#1089#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1076#1083#1103' '#1086#1087#1083#1072#1090#1099
      Hint = #1042#1099#1076#1077#1083#1080#1090#1100' '#1074#1089#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1076#1083#1103' '#1086#1087#1083#1072#1090#1099
      ImageIndex = 28
    end
    object macUpdateMI_NeedPay: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateMI_NeedPay
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1057#1085#1103#1090#1100' '#1086#1090#1084#1077#1090#1082#1091' '#1086#1073' '#1086#1087#1083#1072#1090#1077' '#1089' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074'?'
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100' '#1086#1087#1083#1072#1090#1091' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074
      Hint = #1054#1090#1084#1077#1085#1080#1090#1100' '#1086#1087#1083#1072#1090#1091' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074
      ImageIndex = 58
    end
    object actUpdateMI_NeedPay: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateMI_NeedPay
      StoredProcList = <
        item
          StoredProc = spUpdateMI_NeedPay
        end>
      Caption = 'UpdateMI_NeedPay'
    end
    object actInsertUpdate_MovementItem_Payment_NeedPay: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = gpInsertUpdate_MovementItem_Payment_NeedPay
      StoredProcList = <
        item
          StoredProc = gpInsertUpdate_MovementItem_Payment_NeedPay
        end>
      Caption = 'actInsertUpdate_MovementItem_Payment_NeedPay'
    end
    object actGet_Payment_Detail: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_Payment_Detail
      StoredProcList = <
        item
          StoredProc = spGet_Payment_Detail
        end>
      Caption = 'actGet_Payment_Detail'
    end
    object actSelect_PaymentCorrSumm: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSelect_PaymentCorrSumm
      StoredProcList = <
        item
          StoredProc = spSelect_PaymentCorrSumm
        end>
      Caption = 'spSelect_PaymentCorrSumm'
    end
    object actInsertUpdate_MovementFloat_TotalSummPayment: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate_MovementFloat_TotalSummPayment
      StoredProcList = <
        item
          StoredProc = spInsertUpdate_MovementFloat_TotalSummPayment
        end>
      Caption = 'actInsertUpdate_MovementFloat_TotalSummPayment'
    end
    object actExportToXLSPrivat: TdsdExportToXLS
      Category = 'DSDLib'
      MoveParams = <>
      BeforeAction = actExecStoredProcPrivat
      ItemsDataSet = ExportBankCDS
      FileNameParam.Value = ''
      FileNameParam.Component = FormParams
      FileNameParam.ComponentItem = 'FileName'
      FileNameParam.DataType = ftString
      FileNameParam.MultiSelectSeparator = ','
      TitleHeight = 1.000000000000000000
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      HeaderFont.Charset = DEFAULT_CHARSET
      HeaderFont.Color = clWindowText
      HeaderFont.Height = -11
      HeaderFont.Name = 'Tahoma'
      HeaderFont.Style = []
      Footer = False
      ColumnParams = <
        item
          Caption = 'N_D'
          FieldName = 'Number'
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = 'SUMMA'
          FieldName = 'SummaPay'
          DataType = ftCurrency
          DecimalPlace = 2
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Width = 15
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = 'COUNT_A'
          FieldName = 'PayerAccount'
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Width = 30
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = 'NAME_B'
          FieldName = 'CBName'
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Width = 50
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = 'MFO_B'
          FieldName = 'CBMFO'
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Width = 15
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = 'COUNT_B'
          FieldName = 'CBAccount'
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Width = 30
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = 'N_P'
          FieldName = 'CBPurposePayment'
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Width = 60
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = 'OKPO_B'
          FieldName = 'OKPO'
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Width = 15
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = 'SER_PAS_B'
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = 'NOM_PAS_B'
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          CalcColumnLists = <>
          DetailedTexts = <>
        end>
      FileType = ftExcel8
      Caption = #1069#1082#1089#1087#1086#1090#1088' '#1087#1083#1072#1090#1077#1078#1077#1081' '#1074' '#1087#1088#1080#1074#1072#1090' '#1073#1072#1085#1082
      Hint = #1069#1082#1089#1087#1086#1090#1088' '#1087#1083#1072#1090#1077#1078#1077#1081' '#1074' '#1087#1088#1080#1074#1072#1090' '#1073#1072#1085#1082
      ImageIndex = 56
    end
    object actExecStoredProcPrivat: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spExportBankPrivat
      StoredProcList = <
        item
          StoredProc = spExportBankPrivat
        end
        item
          StoredProc = spExportBankPrivatFileName
        end>
      Caption = 'actExecStoredProcPrivat'
    end
    object actExportToXLSUkrxim: TdsdExportToXLS
      Category = 'DSDLib'
      MoveParams = <>
      BeforeAction = actExecStoredProcUkrxim
      ItemsDataSet = ExportBankCDS
      FileNameParam.Value = Null
      FileNameParam.Component = FormParams
      FileNameParam.ComponentItem = 'FileName'
      FileNameParam.DataType = ftString
      FileNameParam.MultiSelectSeparator = ','
      TitleHeight = 1.000000000000000000
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      HeaderFont.Charset = DEFAULT_CHARSET
      HeaderFont.Color = clWindowText
      HeaderFont.Height = -11
      HeaderFont.Name = 'Tahoma'
      HeaderFont.Style = []
      Footer = False
      ColumnParams = <
        item
          Caption = #1044#1072#1090#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
          FieldName = 'OperDate'
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Width = 15
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = #1053#1086#1084#1077#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
          FieldName = 'Number'
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = #1057#1091#1084#1084#1072
          FieldName = 'SummaPay'
          DataType = ftLargeint
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Width = 15
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = #1052#1060#1054
          FieldName = 'PayerMFO'
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Width = 15
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = #1057#1095#1077#1090
          FieldName = 'PayerAccount'
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Width = 30
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = 'IBAN '#1087#1083#1072#1090#1077#1083#1100#1097#1080#1082#1072
          FieldName = 'PayerIBAN'
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Width = 30
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = #1052#1060#1054' '#1073#1072#1085#1082#1072'  '#1082#1086#1088#1088#1077#1089#1087#1086#1085#1076#1077#1085#1090#1072
          FieldName = 'CBMFO'
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Width = 15
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = #1057#1095#1077#1090' '#1082#1086#1088#1088#1077#1089#1087#1086#1085#1076#1077#1085#1090#1072
          FieldName = 'CBAccount'
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Width = 30
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = 'IBAN '#1082#1086#1088#1088#1077#1089#1087#1086#1085#1076#1077#1085#1090#1072
          FieldName = 'CBIBAN'
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Width = 30
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = #1048#1076'. '#1082#1086#1076' '#1082#1086#1088#1088#1077#1089#1087#1086#1085#1076#1077#1085#1090#1072
          FieldName = 'CBID'
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = #1050#1086#1076' '#1089#1090#1088#1072#1085#1080' '#1082#1086#1088#1088#1077#1089#1087#1086#1085#1076#1077#1085#1090#1072
          FieldName = 'CountryCode'
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = #1050#1086#1088#1088#1077#1089#1087#1086#1085#1076#1077#1085#1090
          FieldName = 'CBName'
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Width = 50
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = #1044#1072#1090#1072' '#1074#1072#1083#1102#1090#1080#1088#1086#1074#1072#1085#1080#1103
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = #1055#1088#1080#1086#1088#1080#1090#1077#1090
          FieldName = 'Priority'
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Width = 15
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = #1053#1072#1079#1085#1072#1095#1077#1085#1080#1077' '#1087#1083#1072#1090#1077#1078#1072
          FieldName = 'CBPurposePayment'
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Width = 60
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = #1044#1086#1087'. '#1056#1077#1082#1074#1080#1079#1080#1090#1099
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          CalcColumnLists = <>
          DetailedTexts = <>
        end>
      FileType = ftExcel8
      SheetName = 'cbdocument'
      Caption = #1069#1082#1089#1087#1086#1090#1088' '#1087#1083#1072#1090#1077#1078#1077#1081' '#1074' '#1059#1082#1088#1077#1082#1089#1080#1084#1073#1072#1085#1082' '#1073#1072#1085#1082
      Hint = #1069#1082#1089#1087#1086#1090#1088' '#1087#1083#1072#1090#1077#1078#1077#1081' '#1074' '#1059#1082#1088#1077#1082#1089#1080#1084#1073#1072#1085#1082' '#1073#1072#1085#1082
      ImageIndex = 56
    end
    object actExecStoredProcUkrxim: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spExportBankUkrxim
      StoredProcList = <
        item
          StoredProc = spExportBankUkrxim
        end
        item
          StoredProc = spExportBankUkrximFileName
        end>
      Caption = 'actExecStoredProcUkrxim'
    end
    object actExportToXLSConcord: TdsdExportToXLS
      Category = 'DSDLib'
      MoveParams = <>
      BeforeAction = actExecStoredProcConcord
      ItemsDataSet = ExportBankCDS
      FileNameParam.Value = Null
      FileNameParam.Component = FormParams
      FileNameParam.ComponentItem = 'FileName'
      FileNameParam.DataType = ftString
      FileNameParam.MultiSelectSeparator = ','
      TitleHeight = 1.000000000000000000
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      HeaderFont.Charset = DEFAULT_CHARSET
      HeaderFont.Color = clWindowText
      HeaderFont.Height = -11
      HeaderFont.Name = 'Tahoma'
      HeaderFont.Style = []
      Footer = False
      ColumnParams = <
        item
          Caption = 'ND'
          FieldName = 'ND'
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = 'SUMMA'
          FieldName = 'SUMMA'
          DataType = ftCurrency
          DecimalPlace = 2
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Width = 15
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = 'CUR_TAG'
          FieldName = 'CUR_TAG'
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = 'N_P'
          FieldName = 'N_P'
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Width = 80
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = 'KL_CHK'
          FieldName = 'KL_CHK'
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Width = 30
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = 'KL_OKP'
          FieldName = 'KL_OKP'
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Width = 15
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = 'MFO_K'
          FieldName = 'MFO_K'
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Width = 15
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = 'KL_CHK_K'
          FieldName = 'KL_CHK_K'
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Width = 30
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = 'KL_OKP_K'
          FieldName = 'KL_OKP_K'
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Width = 15
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = 'KL_NM_K'
          FieldName = 'KL_NM_K'
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Width = 60
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = 'PassportS'
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = 'PassportN'
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = 'DB_IBAN'
          FieldName = 'DB_IBAN'
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Width = 30
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = 'CR_IBAN'
          FieldName = 'CR_IBAN'
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Width = 30
          CalcColumnLists = <>
          DetailedTexts = <>
        end>
      FileType = ftExcel8
      Caption = #1069#1082#1089#1087#1086#1090#1088' '#1087#1083#1072#1090#1077#1078#1077#1081' '#1074' '#1082#1086#1085#1082#1086#1088#1076' '#1073#1072#1085#1082
      Hint = #1069#1082#1089#1087#1086#1090#1088' '#1087#1083#1072#1090#1077#1078#1077#1081' '#1074' '#1082#1086#1085#1082#1086#1088#1076' '#1073#1072#1085#1082
      ImageIndex = 56
    end
    object actExecStoredProcConcord: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spExportBankConcord
      StoredProcList = <
        item
          StoredProc = spExportBankConcord
        end
        item
          StoredProc = spExportBankConcordFileName
        end>
      Caption = 'actExecStoredProcPrivat'
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
        MultiSelectSeparator = ','
      end
      item
        Name = 'inShowAll'
        Value = False
        Component = FormParams
        ComponentItem = 'ShowAll'
        DataType = ftBoolean
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
        Name = 'inDateStart'
        Value = 'NULL'
        Component = deDateStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDateEnd'
        Value = 'NULL'
        Component = deDateEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
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
          ItemName = 'bbUpdateMI_NeedPay'
        end
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
          ItemName = 'dxBarButton3'
        end
        item
          Visible = True
          ItemName = 'dxBarButton4'
        end>
    end
    inherited dxBarStatic: TdxBarStatic
      ShowCaption = False
    end
    inherited bbStatic: TdxBarStatic
      ShowCaption = False
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
    object dxBarButton1: TdxBarButton
      Action = actSelectAllAndRefresh
      Category = 0
    end
    object bbUpdateMI_NeedPay: TdxBarButton
      Action = macUpdateMI_NeedPay
      Category = 0
    end
    object dxBarButton2: TdxBarButton
      Action = actExportToXLSPrivat
      Category = 0
    end
    object dxBarButton3: TdxBarButton
      Action = actExportToXLSUkrxim
      Category = 0
    end
    object dxBarButton4: TdxBarButton
      Action = actExportToXLSConcord
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Top = 201
  end
  inherited PopupMenu: TPopupMenu
    Left = 144
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Key'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ShowAll'
        Value = False
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalCount'
        Value = Null
        Component = edTotalCount
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSumm'
        Value = Null
        Component = edTotalSumm
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'BankAccountId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalId'
        Value = Null
        Component = GuidesJuridical
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'FileName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
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
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDateStart'
        Value = 'NULL'
        Component = deDateStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDateEnd'
        Value = 'NULL'
        Component = deDateEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Id'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
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
        Value = 0d
        Component = edOperDate
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusCode'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'Key'
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
        Name = 'TotalCount'
        Value = Null
        Component = edTotalCount
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSumm'
        Value = Null
        Component = edTotalSumm
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalId'
        Value = Null
        Component = GuidesJuridical
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName'
        Value = Null
        Component = GuidesJuridical
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'DateStart'
        Value = 'NULL'
        Component = deDateStart
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'DateEnd'
        Value = 'NULL'
        Component = deDateEnd
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'isPaymentFormed'
        Value = Null
        Component = cbPaymentFormed
        DataType = ftBoolean
        MultiSelectSeparator = ','
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
        Name = 'inJuridicalId'
        Value = Null
        Component = GuidesJuridical
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPaymentFormed'
        Value = Null
        Component = cbPaymentFormed
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    NeedResetData = True
    ParamKeyField = 'ioId'
    Left = 250
    Top = 280
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
    Top = 200
  end
  inherited HeaderSaver: THeaderSaver
    ControlList = <
      item
        Control = edOperDate
      end
      item
        Control = edJuridical
      end
      item
        Control = cbPaymentFormed
      end>
    Left = 200
    Top = 177
  end
  inherited RefreshAddOn: TRefreshAddOn
    Left = 72
    Top = 312
  end
  inherited spErasedMIMaster: TdsdStoredProc
    Params = <
      item
        Name = 'inMovementItemId'
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = False
        Component = MasterCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    Left = 550
    Top = 224
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    Params = <
      item
        Name = 'inMovementItemId'
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = False
        Component = MasterCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
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
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIncomeId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'IncomeId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioBankAccountId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'BankAccountId'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outBankAccountName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'BankAccountName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outBankName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'BankName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIncome_PaySumm'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Income_PaySumm'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioSummaPay'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SummaPay'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummaCorrBonus'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SummaCorrBonus'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummaCorrReturnOut'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SummaCorrReturnOut'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummaCorrOther'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SummaCorrOther'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioNeedPay'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'NeedPay'
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPartialPay'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isPartialPay'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
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
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalCount'
        Value = Null
        Component = FormParams
        ComponentItem = 'TotalCount'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSumm'
        Value = Null
        Component = FormParams
        ComponentItem = 'TotalSumm'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 548
    Top = 172
  end
  object GuidesJuridical: TdsdGuides
    KeyField = 'Id'
    LookupControl = edJuridical
    FormNameParam.Value = 'TJuridicalCorporateForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridicalCorporateForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 504
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
        MultiSelectSeparator = ','
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
    IdParam.MultiSelectSeparator = ','
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
  object gpInsertUpdate_MovementItem_Payment_NeedPay: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_PaymentMulti'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIncomeId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'IncomeId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBankAccountId'
        Value = Null
        Component = FormParams
        ComponentItem = 'BankAccountId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyId'
        Value = Null
        Component = FormParams
        ComponentItem = 'CurrencyId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummaPay'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SummaPay'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummaCorrBonus'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SummaCorrBonus'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummaCorrReturnOut'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SummaCorrReturnOut'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummaCorrOther'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SummaCorrOther'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 25
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 400
    Top = 368
  end
  object spGet_Payment_Detail: TdsdStoredProc
    StoredProcName = 'gpGet_Payment_Detail'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inJuridicalId'
        Value = Null
        Component = FormParams
        ComponentItem = 'JuridicalId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'BankAccountId'
        Value = Null
        Component = FormParams
        ComponentItem = 'BankAccountId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyId'
        Value = Null
        Component = FormParams
        ComponentItem = 'CurrencyId'
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 584
    Top = 344
  end
  object spInsertUpdate_MovementFloat_TotalSummPayment: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementFloat_TotalSummPayment'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = ''
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 584
    Top = 392
  end
  object spSelect_PaymentCorrSumm: TdsdStoredProc
    StoredProcName = 'gpSelect_PaymentCorrSumm'
    DataSet = PaymentCorrSummCDS
    DataSets = <
      item
        DataSet = PaymentCorrSummCDS
      end>
    Params = <
      item
        Name = 'inMovementId'
        Value = ''
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalId'
        Value = Null
        Component = FormParams
        ComponentItem = 'JuridicalId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 752
    Top = 320
  end
  object PaymentCorrSummCDS: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'ObjectId'
    MasterFields = 'Income_JuridicalId'
    MasterSource = MasterDS
    PacketRecords = 0
    Params = <>
    Left = 756
    Top = 361
  end
  object PaymentCorrSummDS: TDataSource
    DataSet = PaymentCorrSummCDS
    Left = 760
    Top = 408
  end
  object spUpdateMI_NeedPay: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_Payment_NeedPay'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inNeedPay'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outNeedPay'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'NeedPay'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 208
    Top = 376
  end
  object ExportBankCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 756
    Top = 217
  end
  object spExportBankPrivat: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Payment_ExportPrivat'
    DataSet = ExportBankCDS
    DataSets = <
      item
        DataSet = ExportBankCDS
      end>
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 879
    Top = 208
  end
  object spExportBankPrivatFileName: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Payment_ExportPrivatFileName'
    DataSet = ExportBankCDS
    DataSets = <
      item
        DataSet = ExportBankCDS
      end>
    OutputType = otResult
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
        Name = 'outFileName'
        Value = Null
        Component = FormParams
        ComponentItem = 'FileName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 879
    Top = 264
  end
  object spExportBankUkrximFileName: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Payment_ExportUkrximFileName'
    DataSet = ExportBankCDS
    DataSets = <
      item
        DataSet = ExportBankCDS
      end>
    OutputType = otResult
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
        Name = 'outFileName'
        Value = Null
        Component = FormParams
        ComponentItem = 'FileName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 879
    Top = 376
  end
  object spExportBankUkrxim: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Payment_ExportUkrxim'
    DataSet = ExportBankCDS
    DataSets = <
      item
        DataSet = ExportBankCDS
      end>
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 879
    Top = 320
  end
  object spExportBankConcordFileName: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Payment_ExportConcordFileName'
    DataSet = ExportBankCDS
    DataSets = <
      item
        DataSet = ExportBankCDS
      end>
    OutputType = otResult
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
        Name = 'outFileName'
        Value = Null
        Component = FormParams
        ComponentItem = 'FileName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 927
    Top = 392
  end
  object spExportBankConcord: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Payment_ExportConcord'
    DataSet = ExportBankCDS
    DataSets = <
      item
        DataSet = ExportBankCDS
      end>
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 927
    Top = 336
  end
end
