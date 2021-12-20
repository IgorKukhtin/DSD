inherited CalculationPartialSaleForm: TCalculationPartialSaleForm
  Caption = #1056#1072#1089#1095#1077#1090' '#1080#1079#1084#1077#1085#1077#1085#1080#1081' '#1076#1086#1083#1075#1072' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091' '#1087#1086' '#1095#1072#1089#1090#1080#1095#1085#1086#1081' '#1087#1088#1086#1076#1072#1078#1077
  ClientHeight = 375
  ClientWidth = 592
  AddOnFormData.Params = FormParams
  ExplicitWidth = 608
  ExplicitHeight = 414
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 65
    Width = 592
    Height = 310
    TabOrder = 3
    ExplicitTop = 65
    ExplicitWidth = 592
    ExplicitHeight = 310
    ClientRectBottom = 310
    ClientRectRight = 592
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 592
      ExplicitHeight = 310
      inherited cxGrid: TcxGrid
        Width = 592
        Height = 310
        ExplicitWidth = 592
        ExplicitHeight = 310
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.DetailKeyFieldNames = 'JuridicalId;FromId'
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object JuridicalName: TcxGridDBColumn
            Caption = #1053#1072#1096#1077' '#1102#1088'. '#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 225
          end
          object FromName: TcxGridDBColumn
            Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
            DataBinding.FieldName = 'FromName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 232
          end
          object Summa: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1076#1083#1103' '#1086#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'Summa'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 94
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 592
    Height = 39
    ExplicitWidth = 592
    ExplicitHeight = 39
    inherited deStart: TcxDateEdit
      Left = 212
      Top = 8
      ExplicitLeft = 212
      ExplicitTop = 8
    end
    inherited deEnd: TcxDateEdit
      Left = 446
      Top = 8
      Visible = False
      ExplicitLeft = 446
      ExplicitTop = 8
    end
    inherited cxLabel1: TcxLabel
      Left = 8
      Top = 9
      Caption = #1044#1072#1090#1072' '#1088#1072#1089#1095#1077#1090#1072' ('#1088#1072#1089#1095#1077#1090' '#1085#1072' '#1085#1072#1095#1072#1083#1086' '#1076#1085#1103'):'
      ExplicitLeft = 8
      ExplicitTop = 9
      ExplicitWidth = 200
    end
    inherited cxLabel2: TcxLabel
      Left = 336
      Top = 9
      Visible = False
      ExplicitLeft = 336
      ExplicitTop = 9
    end
  end
  inherited ActionList: TActionList
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_PeriodDialogForm'
      FormNameParam.Value = 'TReport_PeriodDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = Null
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = Null
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actFormPartialSale: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      ActionList = <
        item
          Action = actExecFormPartialSale
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1060#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1080#1079#1084#1077#1085#1077#1085#1080#1077' '#1076#1086#1083#1075#1072' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091' '#1087#1086' '#1095#1072#1089#1090#1080#1095#1085#1086#1081' '#1087#1088#1086#1076#1072#1078#1077'?'
      InfoAfterExecute = #1042#1099#1087#1086#1083#1085#1077#1085#1086
      Caption = #1060#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1077' '#1080#1079#1084#1077#1085#1077#1085#1080#1081' '#1076#1086#1083#1075#1072' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091' '#1087#1086' '#1095#1072#1089#1090#1080#1095#1085#1086#1081' '#1087#1088#1086#1076#1072#1078#1077
      Hint = #1060#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1077' '#1080#1079#1084#1077#1085#1077#1085#1080#1081' '#1076#1086#1083#1075#1072' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091' '#1087#1086' '#1095#1072#1089#1090#1080#1095#1085#1086#1081' '#1087#1088#1086#1076#1072#1078#1077
      ImageIndex = 8
    end
    object actExecFormPartialSale: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spFormPartialSale
      StoredProcList = <
        item
          StoredProc = spFormPartialSale
        end>
      Caption = 'actExecFormPartialSale'
    end
    object actReport_Sale_PartialSale: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1076#1072#1078#1080' '#1087#1086' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091' '#1079#1072' '#1085#1077#1076#1077#1083#1102
      Hint = #1055#1088#1086#1076#1072#1078#1080' '#1087#1086' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091' '#1079#1072' '#1085#1077#1076#1077#1083#1102
      ImageIndex = 29
      FormName = 'TReport_Sale_PartialSaleForm'
      FormNameParam.Value = 'TReport_Sale_PartialSaleForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'DateStart'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'DateEnd'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'FromId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'FromName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actReport_Sale_PartialSaleAll: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1076#1072#1078#1080' '#1087#1086' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091' '#1079#1072' '#1087#1077#1088#1080#1086#1076
      Hint = #1055#1088#1086#1076#1072#1078#1080' '#1087#1086' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091' '#1079#1072' '#1087#1077#1088#1080#1086#1076
      ImageIndex = 16
      FormName = 'TReport_Sale_PartialSaleAllForm'
      FormNameParam.Value = 'TReport_Sale_PartialSaleAllForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Income_PartialSale: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1042#1086#1079#1084#1086#1078#1085#1086#1089#1090#1100' '#1086#1087#1083#1072#1090#1099' '#1087#1088#1080#1093#1086#1076#1086#1074' '#1087#1088#1080' '#1086#1087#1083#1072#1090#1077' '#1095#1072#1089#1090#1103#1084#1080
      Hint = #1042#1086#1079#1084#1086#1078#1085#1086#1089#1090#1100' '#1086#1087#1083#1072#1090#1099' '#1087#1088#1080#1093#1086#1076#1086#1074' '#1087#1088#1080' '#1086#1087#1083#1072#1090#1077' '#1095#1072#1089#1090#1103#1084#1080
      ImageIndex = 19
      FormName = 'TReport_Income_PartialSaleForm'
      FormNameParam.Value = 'TReport_Income_PartialSaleForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Sale_PartialReturnInAll: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1042#1086#1079#1074#1088#1072#1090#1099' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1077#1081' '#1087#1086' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091' '#1079#1072' '#1087#1077#1088#1080#1086#1076
      Hint = #1042#1086#1079#1074#1088#1072#1090#1099' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1077#1081' '#1087#1086' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091' '#1079#1072' '#1087#1077#1088#1080#1086#1076
      ImageIndex = 21
      FormName = 'TReport_Sale_PartialReturnInAllForm'
      FormNameParam.Value = 'TReport_Sale_PartialReturnInAllForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
  end
  inherited MasterDS: TDataSource
    Left = 296
    Top = 152
  end
  inherited MasterCDS: TClientDataSet
    Left = 192
    Top = 144
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Calculation_PartialSale'
    Params = <
      item
        Name = 'inStartDate'
        Value = 41395d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 376
    Top = 160
  end
  inherited BarManager: TdxBarManager
    Left = 448
    Top = 168
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
          ItemName = 'dxBarButton2'
        end
        item
          Visible = True
          ItemName = 'bbReport_Sale_PartialSaleAll'
        end
        item
          Visible = True
          ItemName = 'dxBarButton3'
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
          ItemName = 'bbGridToExcel'
        end>
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object dxBarButton1: TdxBarButton
      Action = actFormPartialSale
      Category = 0
    end
    object dxBarButton2: TdxBarButton
      Action = actReport_Sale_PartialSale
      Category = 0
    end
    object bbReport_Sale_PartialSaleAll: TdxBarButton
      Action = actReport_Sale_PartialSaleAll
      Category = 0
    end
    object dxBarButton3: TdxBarButton
      Action = actReport_Income_PartialSale
      Category = 0
    end
    object dxBarButton4: TdxBarButton
      Action = actReport_Sale_PartialReturnInAll
      Category = 0
    end
  end
  inherited PeriodChoice: TPeriodChoice
    Top = 104
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    Left = 80
    Top = 152
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'OperDate'
        Value = Null
        Component = deStart
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    Left = 176
    Top = 264
  end
  object spFormPartialSale: TdsdStoredProc
    StoredProcName = 'gpInsert_ChangeIncomePayment_PartialSale'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inOperDate'
        Value = Null
        Component = deStart
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
        Name = 'inFromId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'FromId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSumma'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Summa'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 376
    Top = 216
  end
end
