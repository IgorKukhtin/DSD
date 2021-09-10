inherited Report_PromoInvoiceForm: TReport_PromoInvoiceForm
  Caption = #1054#1090#1095#1077#1090' <'#1055#1086' '#1089#1095#1077#1090#1072#1084' '#1076#1083#1103' '#1072#1082#1094#1080#1080'>'
  ClientHeight = 404
  ClientWidth = 1073
  AddOnFormData.isSingle = False
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.Params = FormParams
  ExplicitWidth = 1089
  ExplicitHeight = 442
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 91
    Width = 1073
    Height = 313
    TabOrder = 3
    ExplicitTop = 91
    ExplicitWidth = 1073
    ExplicitHeight = 313
    ClientRectBottom = 313
    ClientRectRight = 1073
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1073
      ExplicitHeight = 313
      inherited cxGrid: TcxGrid
        Width = 1073
        Height = 313
        ExplicitWidth = 1073
        ExplicitHeight = 313
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = ServiceSumma
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_ProfitLossService
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RemStart
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RemEnd
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = BankSumma
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = ServiceSumma
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_ProfitLossService
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RemStart
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RemEnd
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = BankSumma
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end>
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object Status_inv: TcxGridDBColumn
            Caption = #1057#1090#1072#1090#1091#1089' '#1076#1086#1082'. '#1057#1095#1077#1090
            DataBinding.FieldName = 'StatusCode'
            PropertiesClassName = 'TcxImageComboBoxProperties'
            Properties.Images = dmMain.ImageList
            Properties.Items = <
              item
                Description = #1053#1077' '#1087#1088#1086#1074#1077#1076#1077#1085
                ImageIndex = 11
                Value = 1
              end
              item
                Description = #1055#1088#1086#1074#1077#1076#1077#1085
                ImageIndex = 12
                Value = 2
              end
              item
                Description = #1059#1076#1072#1083#1077#1085
                ImageIndex = 13
                Value = 3
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 86
          end
          object OperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086#1082'. '#1057#1095#1077#1090
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 67
          end
          object InvNumber: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. '#1057#1095#1077#1090
            DataBinding.FieldName = 'InvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 72
          end
          object InvnumberPartner_inv: TcxGridDBColumn
            Caption = #8470' '#1074#1093'. '#1076#1086#1082'.'
            DataBinding.FieldName = 'InvnumberPartner'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1053#1086#1084#1077#1088' '#1074#1093#1086#1076#1103#1097#1077#1075#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
            Width = 95
          end
          object InvNumber_Full_inv: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. '#1089#1095#1077#1090' ('#1080#1085#1092'.)'
            DataBinding.FieldName = 'InvNumber_Full'
            Visible = False
            Width = 80
          end
          object PaidKindName_inv: TcxGridDBColumn
            Caption = #1060#1054
            DataBinding.FieldName = 'PaidKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
            Width = 67
          end
          object BonusKindName_inv: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1073#1086#1085#1091#1089#1072
            DataBinding.FieldName = 'BonusKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 131
          end
          object TotalSumm_inv: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1086' '#1089#1095#1077#1090#1091
            DataBinding.FieldName = 'TotalSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1089#1091#1084#1084#1072' '#1087#1086' '#1089#1095#1077#1090#1091
            Options.Editing = False
            Width = 79
          end
          object ServiceSumma: TcxGridDBColumn
            Caption = #1059#1089#1083#1091#1075#1080'-'#1072#1082#1090#1099
            DataBinding.FieldName = 'ServiceSumma'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 65
          end
          object BankSumma: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1086#1087#1083#1072#1090
            DataBinding.FieldName = 'BankSumma'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 69
          end
          object RemStart: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082' '#1085#1072#1095'. '#1089#1095#1077#1090
            DataBinding.FieldName = 'RemStart'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 73
          end
          object RemEnd: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082' '#1082#1086#1085'. '#1089#1095#1077#1090
            DataBinding.FieldName = 'RemEnd'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 77
          end
          object Amount_ProfitLossService: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1085#1072#1095'. '#1087#1086' '#1073#1086#1085#1091#1089#1072#1084' '
            DataBinding.FieldName = 'Amount_ProfitLossService'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1085#1072#1095'. '#1087#1086' '#1073#1086#1085#1091#1089#1072#1084' '
            Options.Editing = False
            Width = 66
          end
          object Comment_inv: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 210
          end
          object OperDate_promo: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086#1082'. '#1040#1082#1094#1080#1103
            DataBinding.FieldName = 'OperDate_promo'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 181
          end
          object InvNumber_promo: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. '#1040#1082#1094#1080#1103
            DataBinding.FieldName = 'InvNumber_promo'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 140
          end
          object UnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1040#1082#1094#1080#1103')'
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 107
          end
          object PromoKindName: TcxGridDBColumn
            Caption = #1059#1089#1083#1086#1074#1080#1103' '#1091#1095#1072#1089#1090#1080#1103' ('#1040#1082#1094#1080#1103')'
            DataBinding.FieldName = 'PromoKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 173
          end
          object MonthPromo_promo: TcxGridDBColumn
            Caption = #1052#1077#1089#1103#1094' '#1072#1082#1094#1080#1080
            DataBinding.FieldName = 'MonthPromo_promo'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'mmmm yyyy'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object StartPromo_promo: TcxGridDBColumn
            Caption = #1040#1082#1094#1080#1103' '#1089
            DataBinding.FieldName = 'StartPromo_promo'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          object EndPromo_promo: TcxGridDBColumn
            Caption = #1040#1082#1094#1080#1103' '#1087#1086
            DataBinding.FieldName = 'EndPromo_promo'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 74
          end
          object StartSale_promo: TcxGridDBColumn
            Caption = #1054#1090#1075#1088#1091#1079#1082#1072' '#1089
            DataBinding.FieldName = 'StartSale_promo'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          object EndSale_promo: TcxGridDBColumn
            Caption = #1054#1090#1075#1088#1091#1079#1082#1072' '#1087#1086
            DataBinding.FieldName = 'EndSale_promo'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 72
          end
          object MovementId: TcxGridDBColumn
            DataBinding.FieldName = 'MovementId_promo'
            Visible = False
            VisibleForCustomization = False
            Width = 30
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1073
    Height = 65
    ExplicitWidth = 1073
    ExplicitHeight = 65
    inherited deStart: TcxDateEdit
      Left = 116
      EditValue = 44197d
      Properties.SaveTime = False
      ExplicitLeft = 116
    end
    inherited deEnd: TcxDateEdit
      Left = 116
      Top = 32
      EditValue = 44197d
      Properties.SaveTime = False
      ExplicitLeft = 116
      ExplicitTop = 32
    end
    inherited cxLabel1: TcxLabel
      Left = 24
      ExplicitLeft = 24
    end
    inherited cxLabel2: TcxLabel
      Left = 5
      Top = 33
      ExplicitLeft = 5
      ExplicitTop = 33
    end
  end
  object cxLabel7: TcxLabel [2]
    Left = 741
    Top = 9
    Caption = #1070#1088'.'#1051#1080#1094#1086':'
    Visible = False
  end
  object edJuridical: TcxButtonEdit [3]
    Left = 800
    Top = 8
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 7
    Visible = False
    Width = 163
  end
  object cxLabel6: TcxLabel [4]
    Left = 499
    Top = 6
    Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099':'
  end
  object edPaidKind: TcxButtonEdit [5]
    Left = 584
    Top = 5
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 9
    Width = 101
  end
  object cxLabel3: TcxLabel [6]
    Left = 232
    Top = 6
    Caption = #1053#1072#1095#1072#1083#1086' '#1087#1077#1088#1080#1086#1076#1072' ('#1085#1072#1095'.'#1073#1086#1085#1091#1089#1086#1074'):'
  end
  object deStart2: TcxDateEdit [7]
    Left = 396
    Top = 5
    EditValue = 44197d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 11
    Width = 85
  end
  object cxLabel4: TcxLabel [8]
    Left = 213
    Top = 33
    Caption = #1054#1082#1086#1085#1095#1072#1085#1080#1077' '#1087#1077#1088#1080#1086#1076#1072' ('#1085#1072#1095'.'#1073#1086#1085#1091#1089#1086#1074'):'
  end
  object deEnd2: TcxDateEdit [9]
    Left = 396
    Top = 32
    EditValue = 44197d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 13
    Width = 85
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
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
        Component = JuridicalGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = PaidKindGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end>
  end
  inherited ActionList: TActionList
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_PromoInvoiceDialogForm'
      FormNameParam.Value = 'TReport_PromoInvoiceDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 42005d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42005d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'StartDate2'
          Value = Null
          Component = deStart2
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate2'
          Value = Null
          Component = deEnd2
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PaidKindId'
          Value = Null
          Component = PaidKindGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PaidKindName'
          Value = Null
          Component = PaidKindGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actPrint1: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100' <'#1044#1072#1085#1085#1099#1077' '#1090#1086#1083#1100#1082#1086' '#1087#1086' '#1089#1095#1077#1090#1072#1084'>'
      Hint = #1055#1077#1095#1072#1090#1100' <'#1044#1072#1085#1085#1099#1077' '#1090#1086#1083#1100#1082#1086' '#1087#1086' '#1089#1095#1077#1090#1072#1084'>'
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'MovementId;NameBeforeName'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42370d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42370d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'BranchName'
          Value = ''
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inNumStr'
          Value = '1'
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1087#1086' '#1089#1095#1077#1090#1072#1084
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1087#1086' '#1089#1095#1077#1090#1072#1084
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint2: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100' <'#1044#1072#1085#1085#1099#1077' '#1087#1086' '#1076#1086#1083#1075#1072#1084'>'
      Hint = #1055#1077#1095#1072#1090#1100' <'#1044#1072#1085#1085#1099#1077' '#1087#1086' '#1076#1086#1083#1075#1072#1084'>'
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'MovementId;NameBeforeName'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42370d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42370d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'BranchName'
          Value = ''
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inNumStr'
          Value = '3'
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1087#1086' '#1089#1095#1077#1090#1072#1084
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1087#1086' '#1089#1095#1077#1090#1072#1084
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100' <'#1054#1090#1095#1077#1090' '#1087#1086' '#1089#1095#1077#1090#1072#1084'>'
      Hint = #1055#1077#1095#1072#1090#1100' <'#1054#1090#1095#1077#1090' '#1087#1086' '#1089#1095#1077#1090#1072#1084'>'
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'JuridicalName;MovementId;NameBeforeName'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42005d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42005d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'BranchName'
          Value = ''
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inNumStr'
          Value = '2'
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1087#1086' '#1089#1095#1077#1090#1072#1084
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1087#1086' '#1089#1095#1077#1090#1072#1084
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actOpenReportForm: TdsdOpenForm
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      PostDataSetAfterExecute = True
      Caption = #1054#1090#1095#1077#1090' <'#1055#1086' '#1089#1095#1077#1090#1072#1084'> ('#1076#1077#1090#1072#1083#1100#1085#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1099')'
      Hint = #1054#1090#1095#1077#1090' <'#1055#1086' '#1089#1095#1077#1090#1072#1084'> ('#1076#1077#1090#1072#1083#1100#1085#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1099')'
      ImageIndex = 25
      FormName = 'TReport_InvoiceDetailForm'
      FormNameParam.Value = 'TReport_InvoiceDetailForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inStartDate'
          Value = 42370d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inEndDate'
          Value = 42370d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inJuridicalId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inJuridicalName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPaidKindName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PaidKindName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inMovementId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inInvNumber'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InvNumber_Full'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090
      FormName = 'NULL'
      FormNameParam.Value = ''
      FormNameParam.Component = FormParams
      FormNameParam.ComponentItem = 'FormName'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId_promo'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'OperDate_Promo'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenDocument: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actGetForm
        end
        item
          Action = actOpenForm
        end>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1040#1082#1094#1080#1103
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1040#1082#1094#1080#1103
      ImageIndex = 28
    end
    object actGetForm: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = getMovementForm
      StoredProcList = <
        item
          StoredProc = getMovementForm
        end>
      Caption = 'actGetForm'
    end
  end
  inherited MasterDS: TDataSource
    Left = 72
    Top = 208
  end
  inherited MasterCDS: TClientDataSet
    Left = 40
    Top = 208
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_PromoInvoice'
    Params = <
      item
        Name = 'inStartDate'
        Value = 42370d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 42370d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartDate2'
        Value = Null
        Component = deStart2
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate2'
        Value = Null
        Component = deEnd2
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPaidKindId'
        Value = Null
        Component = PaidKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 112
    Top = 208
  end
  inherited BarManager: TdxBarManager
    Left = 160
    Top = 208
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
          ItemName = 'bbExecuteDialog'
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
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbOpenDocument'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
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
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbPrint: TdxBarButton
      Action = actPrint
      Category = 0
    end
    object bbPrint1: TdxBarButton
      Action = actPrint1
      Category = 0
      ImageIndex = 19
    end
    object bbPrint2: TdxBarButton
      Action = actPrint2
      Category = 0
      ImageIndex = 21
    end
    object bbOpenReportForm: TdxBarButton
      Action = actOpenReportForm
      Category = 0
    end
    object bbOpenDocument: TdxBarButton
      Action = actOpenDocument
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 320
    Top = 232
  end
  inherited PopupMenu: TPopupMenu
    Left = 128
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 112
    Top = 168
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = JuridicalGuides
      end
      item
        Component = PaidKindGuides
      end>
    Left = 216
    Top = 168
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'FormName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 328
    Top = 170
  end
  object JuridicalGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edJuridical
    FormNameParam.Name = 'TJuridical_ObjectForm'
    FormNameParam.Value = 'TJuridical_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridical_ObjectForm'
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
    Left = 856
    Top = 8
  end
  object PaidKindGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPaidKind
    FormNameParam.Value = 'TPaidKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPaidKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PaidKindGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PaidKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 614
  end
  object getMovementForm: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Form'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId_promo'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'FormName'
        Value = Null
        Component = FormParams
        ComponentItem = 'FormName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 440
    Top = 160
  end
end
