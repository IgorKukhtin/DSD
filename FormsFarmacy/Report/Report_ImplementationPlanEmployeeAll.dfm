inherited Report_ImplementationPlanEmployeeAllForm: TReport_ImplementationPlanEmployeeAllForm
  Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1102' '#1087#1083#1072#1085#1072' '#1087#1088#1086#1076#1072#1078' '#1087#1086' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072#1084
  ClientHeight = 504
  ClientWidth = 824
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 840
  ExplicitHeight = 543
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 824
    Height = 447
    ExplicitWidth = 824
    ExplicitHeight = 447
    ClientRectBottom = 447
    ClientRectRight = 824
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 824
      ExplicitHeight = 447
      inherited cxGrid: TcxGrid
        Width = 824
        Height = 447
        ExplicitLeft = 101
        ExplicitTop = 16
        ExplicitWidth = 824
        ExplicitHeight = 447
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Column = Total
            end
            item
              Kind = skSum
              Position = spFooter
              Column = Total
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Total
            end
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = UserName
            end>
          OptionsData.Editing = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object ID: TcxGridDBColumn
            Caption = #8470' '#1087'/'#1087
            DataBinding.FieldName = 'Orders'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Caption = 'mactChoiceGoodsForm'
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 39
          end
          object UserName: TcxGridDBColumn
            Caption = #1060#1072#1084#1080#1083#1080#1103' '#1048'.'#1054'.'
            DataBinding.FieldName = 'UserName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 188
          end
          object PositionName: TcxGridDBColumn
            Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
            DataBinding.FieldName = 'PositionName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object DaysWorked: TcxGridDBColumn
            Caption = #1044#1085#1077#1081' '#1088#1072#1073#1086#1090#1072#1077#1090
            DataBinding.FieldName = 'DaysWorked'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
          object UnitName: TcxGridDBColumn
            Caption = #1040#1087#1090#1077#1082#1072' ('#1086#1089#1085#1086#1074#1085#1072#1103')'
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 220
          end
          object UnitCategoryName: TcxGridDBColumn
            Caption = #1050#1072#1090#1077'- '#1075#1086#1088#1080#1103
            DataBinding.FieldName = 'UnitCategoryName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 49
          end
          object NormOfManDays: TcxGridDBColumn
            Caption = #1053#1086#1088#1084#1072' '#1095#1077#1083#1086#1074#1077#1082#1086#1076#1085#1077#1081
            DataBinding.FieldName = 'NormOfManDays'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object FactOfManDays: TcxGridDBColumn
            Caption = #1060#1072#1082#1090' '#1095#1077#1083#1086#1074#1077#1082#1086#1076#1085#1077#1081
            DataBinding.FieldName = 'FactOfManDays'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object TotalExecutionLine: TcxGridDBColumn
            Caption = #1054#1073#1097#1080#1081' % '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1103'  '#1087#1086#1089#1090#1088#1086#1095#1085#1086
            DataBinding.FieldName = 'TotalExecutionLine'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 89
          end
          object AmountTheFineTab: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1096#1090#1088#1072#1092#1072
            DataBinding.FieldName = 'AmountTheFineTab'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 72
          end
          object BonusAmountTab: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1088#1077#1084#1080#1080
            DataBinding.FieldName = 'BonusAmountTab'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 84
          end
          object Total: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086
            DataBinding.FieldName = 'Total'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 76
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 824
    ExplicitWidth = 824
    inherited deStart: TcxDateEdit
      EditValue = 43344d
      Properties.DisplayFormat = 'mmmm yyyy'
      Properties.EditFormat = 'dd.mm.yyyy'
      TabOrder = 1
      ExplicitWidth = 115
      Width = 115
    end
    inherited deEnd: TcxDateEdit
      Left = 334
      EditValue = 42491d
      TabOrder = 0
      Visible = False
      ExplicitLeft = 334
    end
    inherited cxLabel1: TcxLabel
      Caption = #1052#1077#1089#1103#1094' '#1088#1072#1089#1095#1077#1090#1072':'
      ExplicitWidth = 83
    end
    inherited cxLabel2: TcxLabel
      Left = 218
      Visible = False
      ExplicitLeft = 218
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 51
    Top = 192
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
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end>
    Left = 48
    Top = 240
  end
  inherited ActionList: TActionList
    Left = 103
    Top = 191
    object actRefreshSearch: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = 'actRefreshSearch'
      ShortCut = 13
    end
    object actOpenForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090
      FormName = 'NULL'
      FormNameParam.Value = ''
      FormNameParam.ComponentItem = 'FormName'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId'
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
      isShowModal = False
    end
    object actGetForm: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = 'actGetForm'
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TDataDialogForm'
      FormNameParam.Value = 'TDataDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inOperDate'
          Value = 42491d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
  end
  inherited MasterDS: TDataSource
    Left = 40
    Top = 88
  end
  inherited MasterCDS: TClientDataSet
    Left = 8
    Top = 88
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_ImplementationPlanEmployeeAll'
    Params = <
      item
        Name = 'inStartDate'
        Value = Null
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 72
    Top = 88
  end
  inherited BarManager: TdxBarManager
    Left = 112
    Top = 88
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
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnDblClickActionList = <
      item
      end>
  end
  inherited PopupMenu: TPopupMenu
    Left = 136
    Top = 232
  end
  inherited PeriodChoice: TPeriodChoice
    Top = 136
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
      end>
    Left = 104
    Top = 136
  end
end
