inherited Report_TestingAttemptsUserForm: TReport_TestingAttemptsUserForm
  Caption = #1057#1088#1077#1076#1085#1080#1077' '#1087#1086#1082#1072#1079#1072#1090#1077#1083#1080' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1072' '#1087#1086#1087#1099#1090#1086#1082' '#1089#1088#1077#1076#1080' '#1089#1076#1072#1074#1096#1080#1093' '#1090#1077#1089#1090#1080#1088#1086#1074#1072#1085#1080#1077
  ClientHeight = 504
  ClientWidth = 770
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 786
  ExplicitHeight = 543
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 99
    Width = 770
    Height = 405
    ExplicitTop = 99
    ExplicitWidth = 770
    ExplicitHeight = 405
    ClientRectBottom = 405
    ClientRectRight = 770
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 770
      ExplicitHeight = 405
      inherited cxGrid: TcxGrid
        Width = 770
        Height = 405
        ExplicitWidth = 770
        ExplicitHeight = 405
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Column = Result
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = UserName
            end
            item
              Kind = skSum
              Column = Attempts
            end>
          OptionsData.Editing = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object Code: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'Code'
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
            DataBinding.FieldName = 'MemberName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 208
          end
          object PositionName: TcxGridDBColumn
            Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
            DataBinding.FieldName = 'PositionName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 83
          end
          object UnitName: TcxGridDBColumn
            Caption = #1040#1087#1090#1077#1082#1072
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 160
          end
          object Result: TcxGridDBColumn
            Caption = #1055#1088#1086#1094#1077#1085#1090' '#1087#1088#1072#1074#1077#1083#1085'. '#1086#1090#1074#1077#1090#1086#1074
            DataBinding.FieldName = 'Result'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 62
          end
          object Attempts: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1087#1086#1087#1099#1090#1086#1082
            DataBinding.FieldName = 'Attempts'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 63
          end
          object DateTimeTest: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1103
            DataBinding.FieldName = 'DateTimeTest'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 119
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 770
    Height = 73
    ExplicitWidth = 770
    ExplicitHeight = 73
    inherited deStart: TcxDateEdit
      Left = 129
      EditValue = 42491d
      TabOrder = 1
      ExplicitLeft = 129
    end
    inherited deEnd: TcxDateEdit
      Left = 129
      Top = 32
      EditValue = 42491d
      TabOrder = 0
      Visible = False
      ExplicitLeft = 129
      ExplicitTop = 32
    end
    inherited cxLabel1: TcxLabel
      Caption = #1052#1077#1089#1103#1094' '#1090#1077#1089#1090#1080#1088#1086#1074#1072#1085#1080#1103':'
      ExplicitWidth = 113
    end
    inherited cxLabel2: TcxLabel
      Left = 13
      Top = 33
      Visible = False
      ExplicitLeft = 13
      ExplicitTop = 33
    end
    object cxLabel16: TcxLabel
      Left = 324
      Top = 6
      Caption = #1050#1086#1083'-'#1074#1086' '#1087#1086#1087#1099#1090#1086#1082
    end
    object cxLabel3: TcxLabel
      Left = 416
      Top = 6
      Caption = #1050#1086#1083'-'#1074#1086' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1086#1074
    end
    object cxLabel4: TcxLabel
      Left = 551
      Top = 6
      Caption = #1057#1088#1077#1076#1085#1077#1077' '#1082#1086#1083'-'#1074#1086' '#1087#1086#1087#1099#1090#1086#1082
    end
    object cxLabel5: TcxLabel
      Left = 232
      Top = 26
      Caption = #1060#1072#1088#1084#1072#1094#1077#1074#1090#1099
    end
    object ceAttempts1: TcxDBCurrencyEdit
      Left = 324
      Top = 25
      DataBinding.DataField = 'Attempts1'
      DataBinding.DataSource = MasterDS
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0;-,0; ;'
      Properties.ReadOnly = True
      TabOrder = 8
      Width = 74
    end
    object ceAttempts2: TcxDBCurrencyEdit
      Left = 324
      Top = 48
      DataBinding.DataField = 'Attempts2'
      DataBinding.DataSource = MasterDS
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0;-,0; ;'
      Properties.ReadOnly = True
      TabOrder = 9
      Width = 74
    end
    object ceCount2: TcxDBCurrencyEdit
      Left = 416
      Top = 48
      DataBinding.DataField = 'Count2'
      DataBinding.DataSource = MasterDS
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0;-,0; ;'
      Properties.ReadOnly = True
      TabOrder = 10
      Width = 74
    end
    object ceCount1: TcxDBCurrencyEdit
      Left = 416
      Top = 25
      DataBinding.DataField = 'Count1'
      DataBinding.DataSource = MasterDS
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0;-,0; ;'
      Properties.ReadOnly = True
      TabOrder = 11
      Width = 74
    end
    object ceAverAttempts2: TcxDBCurrencyEdit
      Left = 551
      Top = 48
      DataBinding.DataField = 'AverAttempts2'
      DataBinding.DataSource = MasterDS
      Properties.DisplayFormat = ',0.00;-,0.00; ;'
      Properties.ReadOnly = True
      TabOrder = 12
      Width = 74
    end
    object ceAverAttempts1: TcxDBCurrencyEdit
      Left = 551
      Top = 25
      DataBinding.DataField = 'AverAttempts1'
      DataBinding.DataSource = MasterDS
      Properties.DisplayFormat = ',0.00;-,0.00; ;'
      Properties.ReadOnly = True
      TabOrder = 13
      Width = 74
    end
    object cxLabel6: TcxLabel
      Left = 232
      Top = 49
      Caption = #1050#1083#1072#1076#1086#1074#1097#1080#1082#1080
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 35
    Top = 192
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 32
    Top = 248
  end
  inherited ActionList: TActionList
    Left = 135
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
    Left = 64
    Top = 88
  end
  inherited MasterCDS: TClientDataSet
    Left = 8
    Top = 88
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_TestingAttemptsUser'
    Params = <
      item
        Name = 'inOperDate'
        Value = Null
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 112
    Top = 88
  end
  inherited BarManager: TdxBarManager
    Left = 168
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
    Top = 248
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 40
    Top = 136
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
      end>
    Left = 136
    Top = 136
  end
end
