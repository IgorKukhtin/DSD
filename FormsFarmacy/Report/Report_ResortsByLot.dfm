inherited Report_ResortsByLotForm: TReport_ResortsByLotForm
  Caption = #1054#1090#1095#1077#1090' <'#1055#1077#1088#1077#1089#1086#1088#1090#1099' '#1087#1086' '#1087#1072#1088#1090#1080#1103#1084' '#1090#1086#1074#1072#1088#1072'>'
  ClientHeight = 509
  ClientWidth = 930
  AddOnFormData.isSingle = False
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 946
  ExplicitHeight = 548
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 59
    Width = 930
    Height = 450
    TabOrder = 3
    ExplicitTop = 59
    ExplicitWidth = 712
    ExplicitHeight = 450
    ClientRectBottom = 450
    ClientRectRight = 930
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 712
      ExplicitHeight = 450
      inherited cxGrid: TcxGrid
        Top = 8
        Width = 930
        Height = 442
        ExplicitTop = 8
        ExplicitWidth = 712
        ExplicitHeight = 442
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####; -,0.####;;'
              Kind = skSum
              Column = AmountRest
            end
            item
              Format = ',0.####; -,0.####;;'
              Kind = skSum
              Column = Amount
            end
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = GoodsName
            end
            item
              Format = ',0.####; -,0.####;;'
              Kind = skSum
              Column = AmountPD
            end>
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
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
            Options.Editing = False
            Width = 211
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 69
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 235
          end
          object TypeResorts: TcxGridDBColumn
            Caption = #1055#1077#1088#1077#1089#1086#1088#1090' '#1087#1086
            DataBinding.FieldName = 'TypeResorts'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 68
          end
          object Amount: TcxGridDBColumn
            Caption = #1042' '#1087#1077#1088#1077#1089#1086#1088#1090#1077
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####; -,0.####;;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object AmountRest: TcxGridDBColumn
            Caption = #1044#1086#1089#1090#1091#1087#1085#1099#1081' '#1086#1089#1090#1072#1090#1086#1082
            DataBinding.FieldName = 'AmountRest'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####; -,0.####;;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 84
          end
          object AmountPD: TcxGridDBColumn
            Caption = #1057#1088#1086#1082#1086#1074#1099#1081' '#1086#1089#1090#1072#1090#1086#1082
            DataBinding.FieldName = 'AmountPD'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####; -,0.####;;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 74
          end
          object CountPD: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1089#1088#1086#1082#1086#1074#1099#1093' '#1087#1072#1088#1090#1080#1081
            DataBinding.FieldName = 'CountPD'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
        end
      end
      object cxSplitter1: TcxSplitter
        Left = 0
        Top = 0
        Width = 930
        Height = 8
        AlignSplitter = salTop
        Control = cxGrid
        ExplicitWidth = 712
      end
    end
  end
  inherited Panel: TPanel
    Width = 930
    Height = 33
    ExplicitWidth = 712
    ExplicitHeight = 33
    inherited deStart: TcxDateEdit
      Left = 114
      Top = 29
      EditValue = 43739d
      Visible = False
      ExplicitLeft = 114
      ExplicitTop = 29
      ExplicitWidth = 80
      Width = 80
    end
    inherited deEnd: TcxDateEdit
      Left = 330
      Top = 29
      EditValue = 43739d
      Visible = False
      ExplicitLeft = 330
      ExplicitTop = 29
      ExplicitWidth = 80
      Width = 80
    end
    inherited cxLabel1: TcxLabel
      Left = 22
      Top = 30
      Visible = False
      ExplicitLeft = 22
      ExplicitTop = 30
    end
    inherited cxLabel2: TcxLabel
      Left = 214
      Top = 29
      Visible = False
      ExplicitLeft = 214
      ExplicitTop = 29
    end
    object cxLabel4: TcxLabel
      Left = 20
      Top = 6
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
    end
    object edUnit: TcxButtonEdit
      Left = 114
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 5
      Width = 279
    end
    object cbSUN: TcxCheckBox
      Left = 416
      Top = 6
      Hint = #1058#1086#1083#1100#1082#1086' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103' '#1087#1086' '#1057#1059#1053'1'
      Caption = #1058#1086#1083#1100#1082#1086' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103' '#1087#1086' '#1057#1059#1053'1'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 6
      Width = 191
    end
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
        Component = GuidesUnit
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Tag'
          'Width')
      end
      item
        Component = cbSUN
        Properties.Strings = (
          'Checked')
      end>
  end
  inherited ActionList: TActionList
    object actOpenPartionReport: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1072#1088#1090#1080#1103#1084
      ImageIndex = 39
      FormName = 'TReport_GoodsPartionMoveForm'
      FormNameParam.Value = 'TReport_GoodsPartionMoveForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'UnitId'
          Value = Null
          Component = GuidesUnit
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = Null
          Component = GuidesUnit
          ComponentItem = 'TextValue'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartyId'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartyName'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'RemainsDate'
          Value = Null
          Component = deStart
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actRefreshPartionPrice: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1087#1086#1082#1072#1079#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1087#1072#1088#1090#1080#1080' '#1094#1077#1085#1099
      Hint = #1087#1086' '#1055#1072#1088#1090#1080#1103#1084
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actRefreshJuridical: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1087#1086' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072#1084
      Hint = #1087#1086' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072#1084
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actRefreshIsPartion: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1087#1086' '#1055#1072#1088#1090#1080#1103#1084
      Hint = #1087#1086' '#1055#1072#1088#1090#1080#1103#1084
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_ResortsByLotDialogForm'
      FormNameParam.Value = 'TReport_ResortsByLotDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'UnitId'
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isSun'
          Value = False
          Component = cbSUN
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actRefreshList: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1058#1054#1051#1068#1050#1054' '#1055#1054' '#1057#1055#1048#1057#1050#1059
      Hint = #1058#1054#1051#1068#1050#1054' '#1055#1054' '#1057#1055#1048#1057#1050#1059
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actOpenDocForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actOpenDocForm'
      FormName = 'TReport_ResortsByLotDocForm'
      FormNameParam.Value = 'TReport_ResortsByLotDocForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'UnitId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UnitId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UnitName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'StartDate'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actResortCorrection: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      PostDataSetBeforeExecute = False
      StoredProc = spResortCorrection
      StoredProcList = <
        item
          StoredProc = spResortCorrection
        end>
      Caption = #1048#1089#1087#1088#1072#1074#1080#1090#1100' '#1087#1077#1088#1077#1089#1086#1088#1090' '#1087#1086' '#1087#1072#1088#1090#1080#1080
      Hint = #1048#1089#1087#1088#1072#1074#1080#1090#1100' '#1087#1077#1088#1077#1089#1086#1088#1090' '#1087#1086' '#1087#1072#1088#1090#1080#1080
      ImageIndex = 79
      QuestionBeforeExecute = #1048#1089#1087#1088#1072#1074#1080#1090#1100' '#1087#1077#1088#1077#1089#1086#1088#1090' '#1087#1086' '#1087#1072#1088#1090#1080#1080'?'
    end
  end
  inherited MasterDS: TDataSource
    Left = 16
    Top = 192
  end
  inherited MasterCDS: TClientDataSet
    Left = 280
    Top = 232
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_Resorts_By_Lot'
    Params = <
      item
        Name = 'inUnitId'
        Value = 41395d
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSUN'
        Value = False
        Component = cbSUN
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 136
    Top = 208
  end
  inherited BarManager: TdxBarManager
    Left = 200
    Top = 232
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
          ItemName = 'dxBarButton1'
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
    object bbGoodsPartyReport: TdxBarButton
      Action = actOpenPartionReport
      Category = 0
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object dxBarButton1: TdxBarButton
      Action = actResortCorrection
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 424
    Top = 256
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 272
    Top = 152
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = GuidesUnit
      end
      item
        Component = deStart
      end
      item
      end
      item
      end
      item
      end>
    Left = 88
    Top = 192
  end
  object GuidesUnit: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnit
    FormNameParam.Value = 'TUnitTreeForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnitTreeForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 216
  end
  object spResortCorrection: TdsdStoredProc
    StoredProcName = 'gpSelect_ResortCorrection'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inContainerId'
        Value = ''
        Component = MasterCDS
        ComponentItem = 'ContainerId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContainerPDId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ContainerPDId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 40
    Top = 320
  end
end
