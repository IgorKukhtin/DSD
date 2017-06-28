inherited Report_Check_OrderInternalBySendForm: TReport_Check_OrderInternalBySendForm
  Caption = #1054#1090#1095#1077#1090' <'#1057#1088#1072#1074#1085#1077#1085#1080#1077' '#1079#1072#1082#1072#1079#1072' '#1089' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077#1084'>'
  ClientHeight = 483
  ClientWidth = 1077
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.Params = FormParams
  ExplicitLeft = -440
  ExplicitTop = -29
  ExplicitWidth = 1093
  ExplicitHeight = 522
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 91
    Width = 1077
    Height = 392
    TabOrder = 3
    ExplicitTop = 91
    ExplicitWidth = 1077
    ExplicitHeight = 392
    ClientRectBottom = 392
    ClientRectRight = 1077
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1077
      ExplicitHeight = 392
      inherited cxGrid: TcxGrid
        Width = 1077
        Height = 392
        ExplicitWidth = 1077
        ExplicitHeight = 392
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = OrderAmount
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
              Column = SendAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountDiff
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = OrderAmount
            end
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = GoodsName
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
              Column = SendAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountDiff
            end>
          OptionsData.Editing = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object GoodsGroupNameFull: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072' ('#1074#1089#1077')'
            DataBinding.FieldName = 'GoodsGroupNameFull'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object GoodsGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 68
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 221
          end
          object GoodsKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object MeasureName: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object OrderAmount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1074' '#1079#1072#1103#1074#1082#1077
            DataBinding.FieldName = 'OrderAmount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object SendAmount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1074' '#1087#1077#1088#1077#1084#1077#1097'.'
            DataBinding.FieldName = 'SendAmount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object AmountDiff: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1088#1072#1079#1085#1080#1094#1072
            DataBinding.FieldName = 'AmountDiff'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object isUnder: TcxGridDBColumn
            Caption = #1054#1090#1082#1083'. '#1084#1077#1085#1100#1096#1077
            DataBinding.FieldName = 'isUnder'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object isOver: TcxGridDBColumn
            Caption = #1054#1090#1082#1083'. '#1073#1086#1083#1100#1096#1077
            DataBinding.FieldName = 'isOver'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1077
    Height = 65
    ExplicitWidth = 1077
    ExplicitHeight = 65
    inherited deStart: TcxDateEdit
      Left = 118
      EditValue = 42826d
      Properties.SaveTime = False
      ExplicitLeft = 118
    end
    inherited deEnd: TcxDateEdit
      Left = 118
      Top = 34
      EditValue = 42826d
      Properties.SaveTime = False
      ExplicitLeft = 118
      ExplicitTop = 34
    end
    inherited cxLabel1: TcxLabel
      Left = 25
      ExplicitLeft = 25
    end
    inherited cxLabel2: TcxLabel
      Left = 6
      Top = 35
      ExplicitLeft = 6
      ExplicitTop = 35
    end
    object cxLabel13: TcxLabel
      Left = 209
      Top = 35
      Caption = #1050#1086#1084#1091' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077
    end
    object edFrom: TcxButtonEdit
      Left = 371
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 5
      Width = 220
    end
    object cxLabel3: TcxLabel
      Left = 209
      Top = 6
      Caption = #1054#1090' '#1082#1086#1075#1086' '#1087#1077#1088#1077#1084#1077#1097'./ '#1050#1086#1084#1091' '#1079#1072#1082#1072#1079
    end
    object edTo: TcxButtonEdit
      Left = 316
      Top = 34
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 7
      Width = 275
    end
    object cxLabel4: TcxLabel
      Left = 602
      Top = 6
      Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1086#1074
    end
    object edGoodsGroup: TcxButtonEdit
      Left = 689
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 9
      Width = 228
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 59
    Top = 320
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
        Component = GuidesFrom
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesTo
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesGoodsGroup
        Properties.Strings = (
          'Key'
          'TextValue')
      end>
    Left = 48
  end
  inherited ActionList: TActionList
    Left = 623
    Top = 279
    inherited actRefresh: TdsdDataSetRefresh
      TabSheet = tsMain
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_Check_OrderInternalBySendDialogForm'
      FormNameParam.Value = 'TReport_Check_OrderInternalBySendDialogForm'
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
          Name = 'FromId'
          Value = ''
          Component = GuidesFrom
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromName'
          Value = ''
          Component = GuidesFrom
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToId'
          Value = ''
          Component = GuidesTo
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToName'
          Value = ''
          Component = GuidesTo
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupId'
          Value = 'False'
          Component = GuidesGoodsGroup
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = Null
          Component = GuidesGoodsGroup
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actisDataAll: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1087#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077' '#1076#1072#1085#1085#1099#1077
      Hint = #1042#1089#1077' '#1040#1074#1090#1086
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
  end
  inherited MasterDS: TDataSource
    Left = 112
    Top = 200
  end
  inherited MasterCDS: TClientDataSet
    Left = 40
    Top = 208
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_Check_OrderInternalBySend'
    DataSets = <
      item
        DataSet = MasterCDS
      end
      item
      end
      item
      end>
    Params = <
      item
        Name = 'inStartDate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 41640d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFromId'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsGroupId'
        Value = '0'
        Component = GuidesGoodsGroup
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisShowAll'
        Value = 'False'
        DataType = ftBoolean
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    Left = 176
    Top = 200
  end
  inherited BarManager: TdxBarManager
    Left = 408
    Top = 272
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
    object bbPrint: TdxBarButton
      Caption = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1087#1086' '#1055#1086#1082#1091#1087#1072#1090#1077#1083#1103#1084'-'#1074#1089#1077')'
      Category = 0
      Hint = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1087#1086' '#1055#1086#1082#1091#1087#1072#1090#1077#1083#1103#1084'-'#1074#1089#1077')'
      Visible = ivAlways
      ImageIndex = 18
      ShortCut = 16464
    end
    object bbPrint_byPack: TdxBarButton
      Caption = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1076#1083#1103' '#1059#1087#1072#1082#1086#1074#1082#1080')'
      Category = 0
      Hint = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1076#1083#1103' '#1059#1087#1072#1082#1086#1074#1082#1080')'
      Visible = ivAlways
      ImageIndex = 19
      ShortCut = 16464
    end
    object bbPrint_byProduction: TdxBarButton
      Caption = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1085#1072' '#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086')'
      Category = 0
      Hint = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1085#1072' '#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086')'
      Visible = ivAlways
      ImageIndex = 20
      ShortCut = 16464
    end
    object bbPrint_byType: TdxBarButton
      Caption = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1087#1086' '#1074#1080#1076#1091' '#1090#1086#1074#1072#1088#1072')'
      Category = 0
      Hint = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1087#1086' '#1074#1080#1076#1091' '#1090#1086#1074#1072#1088#1072')'
      Visible = ivAlways
      ImageIndex = 21
      ShortCut = 16464
    end
    object bbPrint_byRoute: TdxBarButton
      Caption = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1087#1086' '#1052#1072#1088#1096#1088#1091#1090#1072#1084'-'#1076#1077#1090#1072#1083#1100#1085#1086')'
      Category = 0
      Hint = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1087#1086' '#1052#1072#1088#1096#1088#1091#1090#1072#1084'-'#1076#1077#1090#1072#1083#1100#1085#1086')'
      Visible = ivAlways
      ImageIndex = 22
      ShortCut = 16464
    end
    object bbPrint_byRouteItog: TdxBarButton
      Caption = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1087#1086' '#1052#1072#1088#1096#1088#1091#1090#1072#1084'-'#1080#1090#1086#1075#1086')'
      Category = 0
      Hint = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1087#1086' '#1052#1072#1088#1096#1088#1091#1090#1072#1084'-'#1080#1090#1086#1075#1086')'
      Visible = ivAlways
      ImageIndex = 16
      ShortCut = 16464
    end
    object bbPrint_byCross: TdxBarButton
      Caption = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1082#1088#1086#1089#1089')'
      Category = 0
      Hint = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1082#1088#1086#1089#1089')'
      Visible = ivAlways
      ImageIndex = 18
      ShortCut = 16464
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbPrint_Dozakaz: TdxBarButton
      Caption = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1044#1086#1079#1072#1082#1072#1079')'
      Category = 0
      Hint = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1044#1086#1079#1072#1082#1072#1079')'
      Visible = ivAlways
      ImageIndex = 17
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 648
    Top = 208
  end
  inherited PopupMenu: TPopupMenu
    Left = 144
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 56
    Top = 24
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = deStart
      end
      item
        Component = deEnd
      end
      item
        Component = GuidesFrom
      end
      item
        Component = GuidesTo
      end
      item
        Component = GuidesGoodsGroup
      end
      item
      end
      item
      end
      item
      end>
    Left = 560
    Top = 208
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'inStartDate'
        Value = 'NULL'
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 'NULL'
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFromId'
        Value = Null
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFromName'
        Value = Null
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = Null
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToName'
        Value = Null
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsGroupId'
        Value = '0'
        Component = GuidesGoodsGroup
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsGroupName'
        Value = Null
        Component = GuidesGoodsGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 352
    Top = 186
  end
  object HeaderCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 256
    Top = 208
  end
  object GuidesFrom: TdsdGuides
    KeyField = 'Id'
    LookupControl = edFrom
    FormNameParam.Value = 'TUnitForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnitForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 400
    Top = 65528
  end
  object GuidesTo: TdsdGuides
    KeyField = 'Id'
    LookupControl = edTo
    FormNameParam.Value = 'TUnitForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnitForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 440
    Top = 32
  end
  object GuidesGoodsGroup: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoodsGroup
    FormNameParam.Value = 'TGoodsGroupForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsGroupForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGoodsGroup
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGoodsGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 736
    Top = 65527
  end
end
