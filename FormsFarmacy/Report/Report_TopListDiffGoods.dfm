inherited Report_TopListDiffGoodsForm: TReport_TopListDiffGoodsForm
  Caption = #1058#1086#1087' '#1090#1086#1074#1072#1088#1086#1074' '#1074' '#1083#1080#1089#1090#1072#1093' '#1086#1090#1082#1072#1079#1086#1074
  ClientHeight = 501
  ClientWidth = 712
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 728
  ExplicitHeight = 540
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 77
    Width = 712
    Height = 424
    ExplicitTop = 77
    ExplicitWidth = 712
    ExplicitHeight = 424
    ClientRectBottom = 424
    ClientRectRight = 712
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 712
      ExplicitHeight = 424
      inherited cxGrid: TcxGrid
        Width = 712
        Height = 416
        ExplicitWidth = 712
        ExplicitHeight = 416
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
              Column = Summa
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
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
            end
            item
              Format = ',0.##'
              Kind = skSum
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Column = Amount
            end>
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object Ord: TcxGridDBColumn
            Caption = #8470' '#1087'/'#1087
            DataBinding.FieldName = 'Ord'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 38
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 58
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 307
          end
          object Amount: TcxGridDBColumn
            Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 85
          end
          object Price: TcxGridDBColumn
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'ZeroingDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 85
          end
          object Summa: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072
            DataBinding.FieldName = 'Summa'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 85
          end
        end
      end
      object cxSplitter1: TcxSplitter
        Left = 0
        Top = 416
        Width = 712
        Height = 8
        AlignSplitter = salBottom
      end
    end
  end
  inherited Panel: TPanel
    Width = 712
    Height = 51
    ExplicitWidth = 712
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
      Width = 412
    end
    object cxLabel3: TcxLabel
      Left = 10
      Top = 29
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
    end
    object ceТop: TcxCurrencyEdit
      Left = 461
      Top = 5
      EditValue = 100.000000000000000000
      Properties.DecimalPlaces = 2
      Properties.DisplayFormat = ',0.'
      TabOrder = 6
      Width = 52
    end
    object cxLabel9: TcxLabel
      Left = 429
      Top = 6
      Hint = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1087#1088#1086#1096#1083#1086#1075#1086' '#1087#1077#1088#1080#1086#1076#1072', '#1084#1077#1089'.'
      Caption = #1058#1086#1087'.'
      ParentShowHint = False
      ShowHint = True
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 51
    Top = 248
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
        Component = UnitGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = ceТop
        Properties.Strings = (
          'Value')
      end>
    Left = 56
    Top = 312
  end
  inherited ActionList: TActionList
    Left = 127
    Top = 255
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
      FormName = 'TReport_TopListDiffGoodsDialogForm'
      FormNameParam.Value = 'TReport_TopListDiffGoodsDialogForm'
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
        end
        item
          Name = 'Top'
          Value = Null
          Component = ceТop
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actUpdate: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1095#1077#1082
      Hint = #1054#1090#1082#1088#1099#1090#1100' '#1095#1077#1082
      ShortCut = 115
      ImageIndex = 1
      FormName = 'TCheckForm'
      FormNameParam.Value = 'TCheckForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ShowAll'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = 42491d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      CheckIDRecords = True
      ActionType = acUpdate
      DataSource = MasterDS
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
  end
  inherited MasterDS: TDataSource
    Left = 40
    Top = 144
  end
  inherited MasterCDS: TClientDataSet
    Left = 8
    Top = 144
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_TopListDiffGoods'
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
      end
      item
        Name = 'in'#1058'op'
        Value = Null
        Component = ceТop
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 72
    Top = 144
  end
  inherited BarManager: TdxBarManager
    Left = 112
    Top = 144
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
          ItemName = 'dxBarButton2'
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
      Action = actUpdate
      Category = 0
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
        ColorValueList = <>
      end>
  end
  inherited PopupMenu: TPopupMenu
    Left = 168
    Top = 304
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 32
    Top = 208
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
        Component = ceТop
      end>
    Left = 128
    Top = 200
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
    Left = 232
    Top = 232
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
