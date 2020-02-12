inherited WagesUserForm: TWagesUserForm
  Caption = #1047#1072#1088#1087#1083#1072#1090#1072
  ClientHeight = 449
  ClientWidth = 655
  AddOnFormData.isSingle = False
  AddOnFormData.ExecuteDialogAction = actDataDialog
  AddOnFormData.Params = FormParams
  ExplicitWidth = 671
  ExplicitHeight = 488
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 127
    Width = 655
    Height = 322
    TabOrder = 0
    ExplicitTop = 107
    ExplicitWidth = 655
    ExplicitHeight = 342
    ClientRectBottom = 322
    ClientRectRight = 655
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 655
      ExplicitHeight = 342
      inherited cxGrid: TcxGrid
        Width = 655
        Height = 207
        ExplicitWidth = 655
        ExplicitHeight = 227
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsView.Footer = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object UnitName: TcxGridDBColumn
            Caption = #1040#1087#1090#1077#1082#1072' '#1088#1072#1089#1095#1077#1090#1072
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 135
          end
          object PayrollTypeName: TcxGridDBColumn
            Caption = #1058#1080#1087#1099' '#1088#1072#1089#1095#1077#1090#1072' '
            DataBinding.FieldName = 'PayrollTypeName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 142
          end
          object DateCalculation: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1088#1072#1089#1095#1077#1090#1072
            DataBinding.FieldName = 'DateCalculation'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 93
          end
          object AmountAccrued: TcxGridDBColumn
            Caption = #1053#1072#1095#1080#1089#1083#1077#1085#1086
            DataBinding.FieldName = 'AmountAccrued'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 81
          end
          object Formula: TcxGridDBColumn
            Caption = #1054#1087#1080#1089#1072#1085#1080#1077' '#1088#1072#1089#1095#1077#1090#1072
            DataBinding.FieldName = 'Formula'
            PropertiesClassName = 'TcxMemoProperties'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 176
          end
        end
      end
      object PanelBottom: TPanel
        Left = 0
        Top = 207
        Width = 655
        Height = 115
        Align = alBottom
        ShowCaption = False
        TabOrder = 1
        ExplicitTop = 227
        object ceTotal: TcxCurrencyEdit
          Left = 157
          Top = 6
          ParentFont = False
          Properties.DecimalPlaces = 2
          Properties.DisplayFormat = ',0.00;-,0.00;;'
          Style.Font.Charset = DEFAULT_CHARSET
          Style.Font.Color = clWindowText
          Style.Font.Height = -16
          Style.Font.Name = 'Tahoma'
          Style.Font.Style = []
          Style.IsFontAssigned = True
          TabOrder = 0
          Width = 156
        end
        object cxLabel4: TcxLabel
          Left = 15
          Top = 6
          Caption = #1048#1090#1086#1075#1086' '#1085#1072#1095#1080#1089#1083#1077#1085#1086':'
          ParentFont = False
          Style.Font.Charset = DEFAULT_CHARSET
          Style.Font.Color = clWindowText
          Style.Font.Height = -16
          Style.Font.Name = 'Tahoma'
          Style.Font.Style = []
          Style.IsFontAssigned = True
        end
        object ceCard: TcxCurrencyEdit
          Left = 478
          Top = 39
          ParentFont = False
          Properties.DecimalPlaces = 2
          Properties.DisplayFormat = ',0.00;-,0.00;;'
          Style.Font.Charset = DEFAULT_CHARSET
          Style.Font.Color = clWindowText
          Style.Font.Height = -16
          Style.Font.Name = 'Tahoma'
          Style.Font.Style = []
          Style.IsFontAssigned = True
          TabOrder = 2
          Width = 156
        end
        object cxLabel1: TcxLabel
          Left = 327
          Top = 39
          Caption = #1047'/'#1055' '#1085#1072' '#1082#1072#1088#1090#1091' :'
          ParentFont = False
          Style.Font.Charset = DEFAULT_CHARSET
          Style.Font.Color = clWindowText
          Style.Font.Height = -16
          Style.Font.Name = 'Tahoma'
          Style.Font.Style = []
          Style.IsFontAssigned = True
        end
        object ceOnHand: TcxCurrencyEdit
          Left = 478
          Top = 72
          ParentFont = False
          Properties.DecimalPlaces = 2
          Properties.DisplayFormat = ',0.00;-,0.00;;'
          Style.Font.Charset = DEFAULT_CHARSET
          Style.Font.Color = clWindowText
          Style.Font.Height = -16
          Style.Font.Name = 'Tahoma'
          Style.Font.Style = []
          Style.IsFontAssigned = True
          TabOrder = 4
          Width = 156
        end
        object cxLabel3: TcxLabel
          Left = 327
          Top = 72
          Caption = #1048#1090#1086#1075#1086' '#1085#1072' '#1088#1091#1082#1080':'
          ParentFont = False
          Style.Font.Charset = DEFAULT_CHARSET
          Style.Font.Color = clWindowText
          Style.Font.Height = -16
          Style.Font.Name = 'Tahoma'
          Style.Font.Style = []
          Style.IsFontAssigned = True
        end
        object ceMarketing: TcxCurrencyEdit
          Left = 157
          Top = 72
          ParentFont = False
          Properties.DecimalPlaces = 2
          Properties.DisplayFormat = ',0.00;-,0.00;;'
          Style.Font.Charset = DEFAULT_CHARSET
          Style.Font.Color = clWindowText
          Style.Font.Height = -16
          Style.Font.Name = 'Tahoma'
          Style.Font.Style = []
          Style.IsFontAssigned = True
          TabOrder = 6
          Width = 156
        end
        object cxLabel5: TcxLabel
          Left = 15
          Top = 72
          Caption = #1052#1072#1088#1082#1077#1090#1080#1085#1075':'
          ParentFont = False
          Style.Font.Charset = DEFAULT_CHARSET
          Style.Font.Color = clWindowText
          Style.Font.Height = -16
          Style.Font.Name = 'Tahoma'
          Style.Font.Style = []
          Style.IsFontAssigned = True
        end
        object ceHolidaysHospital: TcxCurrencyEdit
          Left = 157
          Top = 39
          ParentFont = False
          Properties.DecimalPlaces = 2
          Properties.DisplayFormat = ',0.00;-,0.00;;'
          Style.Font.Charset = DEFAULT_CHARSET
          Style.Font.Color = clWindowText
          Style.Font.Height = -16
          Style.Font.Name = 'Tahoma'
          Style.Font.Style = []
          Style.IsFontAssigned = True
          TabOrder = 8
          Width = 156
        end
        object cxLabel6: TcxLabel
          Left = 15
          Top = 39
          Caption = #1041#1086#1083#1100#1085'. '#1086#1090#1087#1091#1089#1082':'
          ParentFont = False
          Style.Font.Charset = DEFAULT_CHARSET
          Style.Font.Color = clWindowText
          Style.Font.Height = -16
          Style.Font.Name = 'Tahoma'
          Style.Font.Style = []
          Style.IsFontAssigned = True
        end
        object ceDirector: TcxCurrencyEdit
          Left = 478
          Top = 6
          ParentFont = False
          Properties.DecimalPlaces = 2
          Properties.DisplayFormat = ',0.00;-,0.00;;'
          Style.Font.Charset = DEFAULT_CHARSET
          Style.Font.Color = clWindowText
          Style.Font.Height = -16
          Style.Font.Name = 'Tahoma'
          Style.Font.Style = []
          Style.IsFontAssigned = True
          TabOrder = 10
          Width = 156
        end
        object cxLabel7: TcxLabel
          Left = 327
          Top = 6
          Caption = #1044#1080#1088#1077#1082#1090#1086#1088' '#1076#1086#1087'. '#1091#1076'.:'
          ParentFont = False
          Style.Font.Charset = DEFAULT_CHARSET
          Style.Font.Color = clWindowText
          Style.Font.Height = -16
          Style.Font.Name = 'Tahoma'
          Style.Font.Style = []
          Style.IsFontAssigned = True
        end
      end
    end
  end
  object Panel: TPanel [1]
    Left = 0
    Top = 0
    Width = 655
    Height = 101
    Align = alTop
    ShowCaption = False
    TabOrder = 1
    object edOperDate: TcxDateEdit
      Left = 99
      Top = 5
      TabStop = False
      EditValue = 42132d
      Properties.DisplayFormat = 'mmmm yyyy'
      Properties.EditFormat = 'dd.mm.yyyy'
      Properties.ReadOnly = True
      TabOrder = 0
      Width = 100
    end
    object cxLabel2: TcxLabel
      Left = 14
      Top = 6
      Caption = #1047#1072#1088#1087#1083#1072#1090#1072' '#1079#1072
    end
    object cxLabel16: TcxLabel
      Left = 221
      Top = 6
      Caption = #1069#1082#1079#1072#1084#1077#1085'. '#1055#1088#1072#1074#1077#1083#1100#1085#1099#1093' '#1086#1090#1074#1077#1090#1086#1074
    end
    object edAttempts: TcxTextEdit
      Left = 523
      Top = 5
      Properties.ReadOnly = True
      TabOrder = 3
      Width = 41
    end
    object cxLabel8: TcxLabel
      Left = 455
      Top = 6
      Caption = '%  '#1055#1086#1087#1099#1090#1086#1082
    end
    object edStatus: TcxTextEdit
      Left = 385
      Top = 27
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 57
    end
    object cxLabel9: TcxLabel
      Left = 322
      Top = 28
      Caption = #1056#1077#1079#1091#1083#1100#1090#1072#1090
    end
    object edDateTimeTest: TcxDateEdit
      Left = 523
      Top = 27
      TabStop = False
      EditValue = 42132d
      Properties.DisplayFormat = 'dd.mm.yyyy hh:nn'
      Properties.EditFormat = 'dd.mm.yyyy hh:nn'
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 120
    end
    object cxLabel10: TcxLabel
      Left = 455
      Top = 28
      Caption = #1076#1072#1090#1072' '#1087#1088#1086#1074'.'
    end
    object ceResult: TcxCurrencyEdit
      Left = 385
      Top = 5
      Properties.DecimalPlaces = 2
      Properties.DisplayFormat = ',0.##'
      TabOrder = 9
      Width = 57
    end
    object ceSummaCleaning: TcxCurrencyEdit
      Left = 65
      Top = 55
      Properties.DecimalPlaces = 2
      Properties.DisplayFormat = ',0.00'
      TabOrder = 10
      Width = 65
    end
    object cxLabel11: TcxLabel
      Left = 14
      Top = 36
      Caption = #1044#1086#1087'. '#1088#1072#1089#1093#1086#1076#1099' ('#1085#1072' '#1072#1087#1090#1077#1082#1091'):'
    end
    object ceSummaSP: TcxCurrencyEdit
      Left = 156
      Top = 55
      Properties.DecimalPlaces = 2
      Properties.DisplayFormat = ',0.00'
      TabOrder = 12
      Width = 65
    end
    object cxLabel12: TcxLabel
      Left = 135
      Top = 56
      Caption = #1057#1055
    end
    object ceSummaOther: TcxCurrencyEdit
      Left = 266
      Top = 55
      Properties.DecimalPlaces = 2
      Properties.DisplayFormat = ',0.00'
      TabOrder = 14
      Width = 65
    end
    object cxLabel13: TcxLabel
      Left = 222
      Top = 56
      Caption = #1055#1088#1086#1095#1077#1077
    end
    object ceSummaValidationResults: TcxCurrencyEdit
      Left = 436
      Top = 55
      Properties.DecimalPlaces = 2
      Properties.DisplayFormat = ',0.00'
      TabOrder = 16
      Width = 65
    end
    object cxLabel14: TcxLabel
      Left = 335
      Top = 56
      Caption = #1056#1077#1079#1091#1083#1100#1090'. '#1087#1088#1086#1074#1077#1088#1082#1080
    end
    object ceSummaTotal: TcxCurrencyEdit
      Left = 578
      Top = 77
      Properties.DecimalPlaces = 2
      Properties.DisplayFormat = ',0.00'
      TabOrder = 18
      Width = 65
    end
    object cxLabel15: TcxLabel
      Left = 536
      Top = 78
      Caption = #1048#1090#1086#1075#1086':'
    end
    object cxLabel17: TcxLabel
      Left = 14
      Top = 56
      Caption = #1059#1073#1086#1088#1082#1072
    end
    object ceSUN1: TcxCurrencyEdit
      Left = 578
      Top = 55
      Properties.DecimalPlaces = 2
      Properties.DisplayFormat = ',0.00'
      TabOrder = 21
      Width = 65
    end
    object cxLabel18: TcxLabel
      Left = 506
      Top = 56
      Caption = #1064#1090#1088#1072#1092' '#1057#1059#1053'1'
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 235
    Top = 256
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 32
  end
  inherited ActionList: TActionList
    Left = 119
    Top = 191
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spGet
        end>
    end
    object actDataDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099
      ImageIndex = 35
      FormName = 'TDataDialogForm'
      FormNameParam.Value = 'TDataDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inOperDate'
          Value = 'NULL'
          Component = FormParams
          ComponentItem = 'inOperDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
  end
  inherited MasterDS: TDataSource
    Left = 32
    Top = 184
  end
  inherited MasterCDS: TClientDataSet
    Left = 32
    Top = 104
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_WagesUser'
    Params = <
      item
        Name = 'inOperDate'
        Value = 'NULL'
        Component = FormParams
        ComponentItem = 'inOperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 88
    Top = 104
  end
  inherited BarManager: TdxBarManager
    Left = 152
    Top = 104
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
          ItemName = 'bbGridToExcel'
        end>
    end
    inherited bbRefresh: TdxBarButton
      Left = 280
    end
    inherited dxBarStatic: TdxBarStatic
      Left = 208
      Top = 65528
    end
    inherited bbGridToExcel: TdxBarButton
      Left = 232
    end
    object bbOpen: TdxBarButton
      Caption = #1054#1090#1082#1088#1099#1090#1100
      Category = 0
      Visible = ivAlways
      ImageIndex = 1
      Left = 160
    end
    object dxBarButton1: TdxBarButton
      Caption = #1043#1088#1072#1092#1080#1082' '#1088#1072#1073#1086#1090#1099' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1086#1074' '#1087#1086' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1102
      Category = 0
      Hint = #1043#1088#1072#1092#1080#1082' '#1088#1072#1073#1086#1090#1099' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1086#1074' '#1087#1086' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1102
      Visible = ivAlways
      ImageIndex = 55
    end
    object dxBarButton2: TdxBarButton
      Action = actDataDialog
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    KeepSelectColor = True
    Left = 232
    Top = 184
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'inOperDate'
        Value = 'NULL'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    Left = 240
    Top = 104
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_MovementItem_WagesUser'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inOperDate'
        Value = 'NULL'
        Component = FormParams
        ComponentItem = 'inOperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = 'NULL'
        Component = edOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountAccrued'
        Value = Null
        Component = ceTotal
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'HolidaysHospital'
        Value = Null
        Component = ceHolidaysHospital
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Marketing'
        Value = Null
        Component = ceMarketing
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Director'
        Value = Null
        Component = ceDirector
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountCard'
        Value = Null
        Component = ceCard
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountHand'
        Value = Null
        Component = ceOnHand
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Result'
        Value = Null
        Component = ceResult
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Attempts'
        Value = Null
        Component = edAttempts
        MultiSelectSeparator = ','
      end
      item
        Name = 'Status'
        Value = Null
        Component = edStatus
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'DateTimeTest'
        Value = 'NULL'
        Component = edDateTimeTest
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummaCleaning'
        Value = Null
        Component = ceSummaCleaning
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummaSP'
        Value = Null
        Component = ceSummaSP
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummaOther'
        Value = Null
        Component = ceSummaOther
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummaValidationResults'
        Value = Null
        Component = ceSummaValidationResults
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummaSUN1'
        Value = Null
        Component = ceSUN1
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummaTotal'
        Value = Null
        Component = ceSummaTotal
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 328
    Top = 104
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <>
    Left = 328
    Top = 184
  end
end
