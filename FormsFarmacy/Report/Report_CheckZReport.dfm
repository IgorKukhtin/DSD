inherited Report_CheckZReportForm: TReport_CheckZReportForm
  Caption = #1055#1088#1086#1074#1077#1088#1082#1072' Z '#1086#1090#1095#1077#1090#1077#1090#1086#1074
  ClientHeight = 437
  ClientWidth = 1164
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 1180
  ExplicitHeight = 476
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 77
    Width = 1164
    Height = 360
    ExplicitTop = 77
    ExplicitWidth = 1164
    ExplicitHeight = 360
    ClientRectBottom = 360
    ClientRectRight = 1164
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1164
      ExplicitHeight = 360
      inherited cxGrid: TcxGrid
        Width = 1164
        Height = 360
        ExplicitWidth = 1164
        ExplicitHeight = 360
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
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
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = SummaCash
            end
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
            end
            item
              Format = ',0.##'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = SummaCard
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = SummaTotal
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = SummCashCheck
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = SummCardCheck
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = SummaTotalCheck
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = SummCashDelta
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = SummCardDelta
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = SummaTotalDelta
            end>
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object OperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 79
          end
          object UnitCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'UnitCode'
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
          object UnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 135
          end
          object ZReport: TcxGridDBColumn
            Caption = #8470' Z '#1086#1090#1095#1077#1090#1072
            DataBinding.FieldName = 'ZReport'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 59
          end
          object FiscalNumber: TcxGridDBColumn
            Caption = #1060#1080#1089#1082'. '#1085#1086#1084#1077#1088
            DataBinding.FieldName = 'FiscalNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 86
          end
          object SummaCash: TcxGridDBColumn
            Caption = #1054#1073#1086#1088#1086#1090' '#1085#1072#1083' '
            DataBinding.FieldName = 'SummaCash'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object SummaCard: TcxGridDBColumn
            Caption = #1054#1073#1086#1088#1086#1090' '#1082#1072#1088#1090#1072
            DataBinding.FieldName = 'SummaCard'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object SummaTotal: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086
            DataBinding.FieldName = 'SummaTotal'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object SummCashCheck: TcxGridDBColumn
            Caption = #1054#1073#1086#1088#1086#1090' '#1085#1072#1083' '#1087#1086' '#1095#1077#1082#1072#1084
            DataBinding.FieldName = 'SummCashCheck'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object SummCardCheck: TcxGridDBColumn
            Caption = #1054#1073#1086#1088#1086#1090' '#1082#1072#1088#1090#1072' '#1087#1086' '#1095#1077#1082#1072#1084
            DataBinding.FieldName = 'SummCardCheck'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object SummaTotalCheck: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1087#1086' '#1095#1077#1082#1072#1084
            DataBinding.FieldName = 'SummaTotalCheck'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object SummCashDelta: TcxGridDBColumn
            Caption = #1056#1072#1079#1085#1080#1094#1072' '#1085#1072#1083
            DataBinding.FieldName = 'SummCashDelta'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object SummCardDelta: TcxGridDBColumn
            Caption = #1056#1072#1079#1085#1080#1094#1072'  '#1082#1072#1088#1090#1072
            DataBinding.FieldName = 'SummCardDelta'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object SummaTotalDelta: TcxGridDBColumn
            Caption = #1056#1072#1079#1085#1080#1094#1072' '#1080#1090#1086#1075#1086
            DataBinding.FieldName = 'SummaTotalDelta'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object ColorRA_calc: TcxGridDBColumn
            DataBinding.FieldName = 'ColorRA_calc'
            Visible = False
            VisibleForCustomization = False
            Width = 90
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1164
    Height = 51
    ExplicitWidth = 1164
    ExplicitHeight = 51
    inherited deStart: TcxDateEdit
      EditValue = 42491d
      TabOrder = 1
    end
    inherited deEnd: TcxDateEdit
      EditValue = 42491d
      TabOrder = 0
    end
    object ceUnit: TcxButtonEdit
      Left = 101
      Top = 29
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.Nullstring = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
      Properties.ReadOnly = True
      Properties.UseNullString = True
      TabOrder = 4
      Text = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
      Width = 288
    end
    object cxLabel3: TcxLabel
      Left = 10
      Top = 29
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 59
    Top = 216
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 64
    Top = 280
  end
  inherited ActionList: TActionList
    Left = 135
    Top = 223
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
        end>
    end
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
      FormNameParam.Value = Null
      FormNameParam.Component = FormParams
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
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_CheckZReportDialogForm'
      FormNameParam.Value = 'TReport_CheckZReportDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 42491d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42491d
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
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
  end
  inherited MasterDS: TDataSource
    Left = 48
    Top = 112
  end
  inherited MasterCDS: TClientDataSet
    Left = 16
    Top = 112
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_CheckZReport'
    Params = <
      item
        Name = 'inStartDate'
        Value = Null
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = Null
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = UnitGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 80
    Top = 112
  end
  inherited BarManager: TdxBarManager
    Left = 120
    Top = 112
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
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
    end
    object bbOpenDocument: TdxBarButton
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      Category = 0
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      Visible = ivAlways
      ImageIndex = 28
      ShortCut = 115
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbUpdateDateCompensation: TdxBarButton
      Caption = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1076#1072#1090#1091' '#1082#1086#1084#1087#1077#1085#1089#1072#1094#1080#1080
      Category = 0
      Hint = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1076#1072#1090#1091' '#1082#1086#1084#1087#1077#1085#1089#1072#1094#1080#1080
      Visible = ivAlways
      ImageIndex = 43
    end
    object dxBarButton1: TdxBarButton
      Caption = #1053#1077#1076#1086#1082#1086#1084#1077#1085#1089#1072#1094#1080#1080' '#1087#1086' '#1044#1055
      Category = 0
      Hint = #1053#1077#1076#1086#1082#1086#1084#1077#1085#1089#1072#1094#1080#1080' '#1087#1086' '#1044#1055
      Visible = ivAlways
      ImageIndex = 29
    end
    object dxBarButton2: TdxBarButton
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1095#1077#1082
      Category = 0
      Hint = #1054#1090#1082#1088#1099#1090#1100' '#1095#1077#1082
      Visible = ivAlways
      ImageIndex = 1
      ShortCut = 115
    end
    object dxBarButton3: TdxBarButton
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' <'#1055#1086#1083#1091#1095#1077#1085#1086' '#1073#1091#1093#1075#1072#1083#1090#1077#1088#1080#1077#1081'>'
      Category = 0
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' <'#1055#1086#1083#1091#1095#1077#1085#1086' '#1073#1091#1093#1075#1072#1083#1090#1077#1088#1080#1077#1081'>'
      Visible = ivAlways
      ImageIndex = 79
    end
    object dxBarButton4: TdxBarButton
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1057#1091#1084#1084#1072' '#1087#1086#1083#1091#1095#1077#1085#1086' '#1087#1086' '#1092#1072#1082#1090#1091'>'
      Category = 0
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1057#1091#1084#1084#1072' '#1087#1086#1083#1091#1095#1077#1085#1086' '#1087#1086' '#1092#1072#1082#1090#1091'>'
      Visible = ivAlways
      ImageIndex = 56
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    ColorRuleList = <
      item
        BackGroundValueColumn = ColorRA_calc
        ColorValueList = <>
      end>
  end
  inherited PopupMenu: TPopupMenu
    Left = 176
    Top = 272
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 40
    Top = 176
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
      end>
    Left = 136
    Top = 168
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'SummaReceivedFact'
        Value = 0.000000000000000000
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummaReceivedFactLabel'
        Value = #1057#1091#1084#1084#1072' '#1087#1086#1083#1091#1095#1077#1085#1086' '#1087#1086' '#1092#1072#1082#1090#1091
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    Left = 240
    Top = 200
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
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 360
    Top = 24
  end
end
