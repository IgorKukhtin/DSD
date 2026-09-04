inherited Report_MotionGoods_CountVirtForm: TReport_MotionGoods_CountVirtForm
  Caption = #1054#1090#1095#1077#1090' <'#1044#1074#1080#1078#1077#1085#1080#1077'>'
  ClientHeight = 372
  ClientWidth = 1519
  AddOnFormData.isSingle = False
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.Params = FormParams
  ExplicitWidth = 1535
  ExplicitHeight = 411
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 59
    Width = 1519
    Height = 313
    TabOrder = 3
    ExplicitTop = 59
    ExplicitWidth = 1152
    ExplicitHeight = 313
    ClientRectBottom = 313
    ClientRectRight = 1519
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1152
      ExplicitHeight = 313
      inherited cxGrid: TcxGrid
        Width = 1519
        Height = 313
        ExplicitWidth = 1152
        ExplicitHeight = 313
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountItsOut_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountStart_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountStart
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountSendIn_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountSendIn
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountEnd_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountEnd
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountSendOut_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountProductionIn_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountSendOut
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountProductionIn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountItsIn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountItsOut
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountItsIn_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountOrderRKOut_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountProductionOut_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountOrderRKOut
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountProductionOut
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountItsOut_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountStart_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountStart
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountSendIn_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountSendIn
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountEnd_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountEnd
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountSendOut_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountProductionIn_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountSendOut
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountProductionIn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountItsIn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountItsOut
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountItsIn_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountOrderRKOut_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountProductionOut_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountOrderRKOut
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountProductionOut
            end
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = GoodsName
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
          object UnitCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1087#1086#1076#1088'.'
            DataBinding.FieldName = 'UnitCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object UnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object GoodsGroupNameFull: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072' ('#1074#1089#1077')'
            DataBinding.FieldName = 'GoodsGroupNameFull'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object GoodsGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072
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
            Width = 35
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object GoodsKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object MeasureName: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 35
          end
          object Weight: TcxGridDBColumn
            Caption = #1042#1077#1089
            DataBinding.FieldName = 'Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object CountStart: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082' '#1085#1072#1095'., '#1096#1090
            DataBinding.FieldName = 'CountStart'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object CountStart_Weight: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082' '#1085#1072#1095'., '#1074#1077#1089
            DataBinding.FieldName = 'CountStart_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object CountEnd: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082' '#1082#1086#1085#1077#1095#1085'., '#1096#1090
            DataBinding.FieldName = 'CountEnd'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object CountEnd_Weight: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082' '#1082#1086#1085#1077#1095#1085'., '#1074#1077#1089
            DataBinding.FieldName = 'CountEnd_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object CountSendIn: TcxGridDBColumn
            Caption = #1055#1088#1080#1093#1086#1076' '#1087#1077#1088#1077#1084#1077#1097'., '#1096#1090
            DataBinding.FieldName = 'CountSendIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object CountSendIn_Weight: TcxGridDBColumn
            Caption = #1055#1088#1080#1093#1086#1076' '#1087#1077#1088#1077#1084#1077#1097'., '#1074#1077#1089
            DataBinding.FieldName = 'CountSendIn_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 84
          end
          object CountSendOut: TcxGridDBColumn
            Caption = #1056#1072#1089#1093#1086#1076' '#1087#1077#1088#1077#1084#1077#1097'., '#1096#1090
            DataBinding.FieldName = 'CountSendOut'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object CountSendOut_Weight: TcxGridDBColumn
            Caption = #1056#1072#1089#1093#1086#1076' '#1087#1077#1088#1077#1084#1077#1097'., '#1074#1077#1089
            DataBinding.FieldName = 'CountSendOut_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object CountProductionIn: TcxGridDBColumn
            Caption = #1055#1088#1080#1093#1086#1076' '#1087#1088#1086#1080#1079#1074'., '#1096#1090
            DataBinding.FieldName = 'CountProductionIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object CountProductionIn_Weight: TcxGridDBColumn
            Caption = #1055#1088#1080#1093#1086#1076' '#1087#1088#1086#1080#1079#1074', '#1074#1077#1089
            DataBinding.FieldName = 'CountProductionIn_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object CountProductionOut: TcxGridDBColumn
            Caption = #1056#1072#1089#1093#1086#1076' '#1087#1088#1086#1080#1079#1074'., '#1096#1090
            DataBinding.FieldName = 'CountProductionOut'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object CountProductionOut_Weight: TcxGridDBColumn
            Caption = #1056#1072#1089#1093#1086#1076' '#1087#1088#1086#1080#1079#1074'., '#1074#1077#1089
            DataBinding.FieldName = 'CountProductionOut_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object CountOrderRKOut: TcxGridDBColumn
            Caption = #1056#1072#1089#1093#1086#1076' '#1079#1072#1076#1072#1085#1080#1077' '#1085#1072' '#1089#1073#1086#1088#1082#1091' '#1043#1055', '#1096#1090
            DataBinding.FieldName = 'CountOrderRKOut'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object CountOrderRKOut_Weight: TcxGridDBColumn
            Caption = #1056#1072#1089#1093#1086#1076' '#1079#1072#1076#1072#1085#1080#1077' '#1085#1072' '#1089#1073#1086#1088#1082#1091' '#1043#1055', '#1074#1077#1089
            DataBinding.FieldName = 'CountOrderRKOut_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object CountItsIn: TcxGridDBColumn
            Caption = #1055#1088#1080#1093#1086#1076' '#1076#1088#1091#1075#1086#1077', '#1096#1090
            DataBinding.FieldName = 'CountItsIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object CountItsIn_Weight: TcxGridDBColumn
            Caption = #1055#1088#1080#1093#1086#1076' '#1076#1088#1091#1075#1086#1077', '#1074#1077#1089
            DataBinding.FieldName = 'CountItsIn_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object CountItsOut: TcxGridDBColumn
            Caption = #1056#1072#1089#1093#1086#1076' '#1076#1088#1091#1075#1086#1077', '#1096#1090
            DataBinding.FieldName = 'CountItsOut'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object CountItsOut_Weight: TcxGridDBColumn
            Caption = #1056#1072#1089#1093#1086#1076' '#1076#1088#1091#1075#1086#1077', '#1074#1077#1089
            DataBinding.FieldName = 'CountItsOut_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1519
    Height = 33
    ExplicitWidth = 1152
    ExplicitHeight = 33
    inherited deStart: TcxDateEdit
      Left = 49
      EditValue = 41640d
      Properties.SaveTime = False
      ExplicitLeft = 49
      ExplicitWidth = 77
      Width = 77
    end
    inherited deEnd: TcxDateEdit
      Left = 187
      EditValue = 41640d
      Properties.SaveTime = False
      ExplicitLeft = 187
      ExplicitWidth = 80
      Width = 80
    end
    inherited cxLabel1: TcxLabel
      Left = 2
      Caption = #1044#1072#1090#1072' '#1089' :'
      ExplicitLeft = 2
      ExplicitWidth = 45
    end
    inherited cxLabel2: TcxLabel
      Left = 135
      Caption = #1044#1072#1090#1072' '#1087#1086' :'
      ExplicitLeft = 135
      ExplicitWidth = 52
    end
    object cxLabel4: TcxLabel
      Left = 587
      Top = 6
      Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1086#1074':'
    end
    object edGoodsGroup: TcxButtonEdit
      Left = 678
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 179
    end
    object cxLabel3: TcxLabel
      Left = 277
      Top = 6
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
    end
    object edUnit: TcxButtonEdit
      Left = 365
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 210
    end
    object cxLabel8: TcxLabel
      Left = 863
      Top = 6
      Caption = #1058#1086#1074#1072#1088':'
    end
    object edGoods: TcxButtonEdit
      Left = 903
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 9
      Width = 180
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
        Component = GuidesGoodsGroup
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesUnit
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
      FormName = 'TReport_MotionGoods_CountVirtDialogForm'
      FormNameParam.Value = 'TReport_MotionGoods_CountVirtDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupId'
          Value = ''
          Component = GuidesGoodsGroup
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = ''
          Component = GuidesGoodsGroup
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
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
          Name = 'GoodsId'
          Value = ''
          Component = GuidesGoods
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = ''
          Component = GuidesGoods
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100
      Hint = #1055#1077#1095#1072#1090#1100
      ImageIndex = 3
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'UnitName;GoodsGroupNameFull;GoodsName;GoodsKindName'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = Null
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = '2'
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = Null
          Component = GuidesUnit
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintReport_MotionGoods_CountVirt'
      ReportNameParam.Value = 'PrintReport_MotionGoods_CountVirt'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
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
    StoredProcName = 'gpReport_MotionGoods_CountVirt'
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
        Name = 'inUnitGroupId'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsGroupId'
        Value = ''
        Component = GuidesGoodsGroup
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = GuidesGoods
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 200
    Top = 240
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
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrint'
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
    object bb: TdxBarButton
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088'/'#1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1080#1089#1090#1086#1088#1080#1080
      Category = 0
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088'/'#1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1080#1089#1090#1086#1088#1080#1080
      Visible = ivAlways
      ImageIndex = 28
    end
    object bbErased: TdxBarControlContainerItem
      Caption = 'Erased'
      Category = 0
      Hint = 'Erased'
      Visible = ivAlways
    end
    object bbPrint: TdxBarButton
      Action = actPrint
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 320
    Top = 232
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 104
    Top = 160
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = GuidesUnit
      end
      item
      end
      item
        Component = GuidesGoodsGroup
      end
      item
        Component = GuidesGoods
      end
      item
      end
      item
      end>
    Left = 208
    Top = 168
  end
  object GuidesGoodsGroup: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoodsGroup
    FormNameParam.Value = 'TGoodsGroup_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsGroup_ObjectForm'
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
    Left = 776
    Top = 65528
  end
  object FormParams: TdsdFormParams
    Params = <
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
      end
      item
        Name = 'UnitGroupId'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitGroupName'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 328
    Top = 170
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
        DataType = ftString
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
    Left = 464
    Top = 8
  end
  object GuidesGoods: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoods
    FormNameParam.Value = 'TGoods_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoods_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 944
    Top = 3
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 532
    Top = 174
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 604
    Top = 209
  end
end
