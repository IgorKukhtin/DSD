inherited Report_WageForm: TReport_WageForm
  Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1047#1072#1088#1072#1073#1086#1090#1085#1086#1081' '#1087#1083#1072#1090#1077
  ClientHeight = 305
  ClientWidth = 982
  AddOnFormData.isSingle = False
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitLeft = -297
  ExplicitWidth = 998
  ExplicitHeight = 344
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 58
    Width = 982
    Height = 247
    TabOrder = 3
    ExplicitTop = 58
    ExplicitWidth = 982
    ExplicitHeight = 247
    ClientRectBottom = 247
    ClientRectRight = 982
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 982
      ExplicitHeight = 247
      inherited cxGrid: TcxGrid
        Width = 982
        Height = 247
        ExplicitWidth = 982
        ExplicitHeight = 247
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummaPersonal
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummaWage
            end
            item
              Format = ',0.00'
              Column = SummaSale
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummaPersonal
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummaWage
            end>
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object UnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 102
          end
          object DayOfWeekName: TcxGridDBColumn
            Caption = #1044#1077#1085#1100' '#1085#1077#1076#1077#1083#1080
            DataBinding.FieldName = 'DayOfWeekName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 63
          end
          object OperDate1: TcxGridDBColumn
            Caption = #1053#1072#1095#1072#1083#1086' '#1087#1077#1088#1080#1086#1076#1072
            DataBinding.FieldName = 'OperDate1'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'dd.mm.yyyy HH:MM'
            Properties.EditFormat = 'dd.mm.yy HH:MM'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object OperDate2: TcxGridDBColumn
            Caption = #1054#1082#1086#1085#1095#1072#1085#1080#1077' '#1087#1077#1088#1080#1086#1076#1072
            DataBinding.FieldName = 'OperDate2'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'dd.mm.yyyy HH:MM'
            Properties.EditFormat = 'dd.mm.yyyy HH:MM'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object PersonalName: TcxGridDBColumn
            Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082
            DataBinding.FieldName = 'PersonalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 114
          end
          object PositionName: TcxGridDBColumn
            Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
            DataBinding.FieldName = 'PositionName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 117
          end
          object SummaWage: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1047#1055
            DataBinding.FieldName = 'SummaWage'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object SummaPersonal: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078' ('#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1072')'
            DataBinding.FieldName = 'SummaPersonal'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object TaxServicePersonal: TcxGridDBColumn
            Caption = '% '#1074#1099#1087#1083#1072#1090#1099' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072
            DataBinding.FieldName = 'TaxServicePersonal'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 79
          end
          object TaxServicePosition: TcxGridDBColumn
            Caption = '% '#1074#1099#1087#1083#1072#1090#1099' '#1076#1086#1083#1078#1085#1086#1089#1090#1080
            DataBinding.FieldName = 'TaxServicePosition'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 79
          end
          object TaxService: TcxGridDBColumn
            Caption = '% '#1086#1090' '#1074#1099#1088#1091#1095#1082#1080' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103
            DataBinding.FieldName = 'TaxService'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object SummaSale: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078' ('#1080#1085#1092#1086#1088#1084#1072#1090#1080#1074#1085#1086')'
            DataBinding.FieldName = 'SummaSale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 110
          end
          object isVip: TcxGridDBColumn
            Caption = 'Vip'
            DataBinding.FieldName = 'isVip'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 40
          end
          object PersonalCount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1086#1074
            DataBinding.FieldName = 'PersonalCount'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            VisibleForCustomization = False
            Width = 70
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 982
    Height = 32
    ExplicitWidth = 982
    ExplicitHeight = 32
    inherited deStart: TcxDateEdit
      Left = 29
      ExplicitLeft = 29
    end
    inherited deEnd: TcxDateEdit
      Left = 142
      EditValue = 42400d
      ExplicitLeft = 142
    end
    inherited cxLabel1: TcxLabel
      Caption = #1057':'
      ExplicitWidth = 15
    end
    inherited cxLabel2: TcxLabel
      Left = 120
      Caption = #1087#1086':'
      ExplicitLeft = 120
      ExplicitWidth = 20
    end
    object cxLabel3: TcxLabel
      Left = 400
      Top = 7
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
    end
    object ceUnit: TcxButtonEdit
      Left = 490
      Top = 6
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.Nullstring = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
      Properties.ReadOnly = True
      Properties.UseNullString = True
      TabOrder = 5
      Text = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
      Width = 252
    end
    object sbisDay: TcxCheckBox
      Left = 243
      Top = 5
      Action = actinisDay
      TabOrder = 6
      Width = 66
    end
    object sbisVipCheck: TcxCheckBox
      Left = 318
      Top = 5
      Action = actisVipCheck
      TabOrder = 7
      Width = 59
    end
  end
  inherited ActionList: TActionList
    object actisVipCheck: TdsdDataSetRefresh [0]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1087#1086' '#1042#1048#1055
      Hint = #1074#1099#1076#1077#1083#1080#1090#1100' '#1042#1048#1055
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actinisDay: TdsdDataSetRefresh [1]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1087#1086' '#1044#1085#1103#1084
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actGet_UserUnit: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_UserUnit
      StoredProcList = <
        item
          StoredProc = spGet_UserUnit
        end>
      Caption = 'actGet_UserUnit'
    end
    object actRefreshStart: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet_UserUnit
      StoredProcList = <
        item
          StoredProc = spGet_UserUnit
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_WageDialogForm'
      FormNameParam.Value = 'TReport_WageDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 41395d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 41395d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitId'
          Value = ''
          Component = UnitGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = ''
          Component = UnitGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inIsDay'
          Value = Null
          Component = sbisDay
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inisVipCheck'
          Value = Null
          Component = sbisVipCheck
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
  end
  inherited MasterDS: TDataSource
    Left = 48
    Top = 160
  end
  inherited MasterCDS: TClientDataSet
    Left = 16
    Top = 160
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_Wage'
    Params = <
      item
        Name = 'inUnitId'
        Value = Null
        Component = UnitGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDateStart'
        Value = 42370d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDateEnd'
        Value = 42400d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsDay'
        Value = 'False'
        Component = sbisDay
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisVipCheck'
        Value = Null
        Component = sbisVipCheck
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        DataType = ftBoolean
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    Left = 80
    Top = 160
  end
  inherited BarManager: TdxBarManager
    Left = 120
    Top = 160
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
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
    end
    object dxBarButton1: TdxBarButton
      Caption = #1055#1086' '#1087#1072#1088#1090#1080#1103#1084
      Category = 0
      Hint = #1055#1086' '#1087#1072#1088#1090#1080#1103#1084
      Visible = ivAlways
      ImageIndex = 38
    end
    object dxBarControlContainerItem1: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = cxLabel1
    end
    object dxBarControlContainerItem2: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = deStart
    end
    object dxBarControlContainerItem3: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = cxLabel2
    end
    object dxBarControlContainerItem4: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = deEnd
    end
    object dxBarControlContainerItem5: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = cxLabel3
    end
    object dxBarControlContainerItem6: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = ceUnit
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbcbinIsDay: TdxBarControlContainerItem
      Caption = #1087#1086' '#1076#1085#1103#1084
      Category = 0
      Hint = #1087#1086' '#1076#1085#1103#1084
      Visible = ivAlways
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 536
    Top = 192
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 440
    Top = 16
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = UnitGuides
      end
      item
        Component = ceUnit
      end
      item
        Component = deStart
      end
      item
        Component = deEnd
      end
      item
      end>
    Left = 576
    Top = 112
  end
  object rdUnit: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = UnitGuides
      end>
    Left = 552
    Top = 32
  end
  object UnitGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceUnit
    FormNameParam.Value = 'TUnitTreeForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnitTreeForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 440
    Top = 56
  end
  object spGet_UserUnit: TdsdStoredProc
    StoredProcName = 'gpGet_UserUnit'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'UnitId'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 368
    Top = 128
  end
end
