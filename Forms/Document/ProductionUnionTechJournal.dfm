inherited ProductionUnionTechJournalForm: TProductionUnionTechJournalForm
  Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' - '#1089#1084#1077#1096#1080#1074#1072#1085#1080#1077
  ClientHeight = 685
  ClientWidth = 1097
  ExplicitWidth = 1113
  ExplicitHeight = 720
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 98
    Width = 1097
    Height = 587
    TabOrder = 2
    ExplicitTop = 98
    ExplicitWidth = 1097
    ExplicitHeight = 587
    ClientRectBottom = 587
    ClientRectRight = 1097
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1097
      ExplicitHeight = 563
      inherited cxGrid: TcxGrid
        Width = 1097
        Height = 205
        ExplicitWidth = 1097
        ExplicitHeight = 205
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Column = colAmount
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Column = colCount
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Column = colAmount
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Column = colCount
            end>
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colStatus: TcxGridDBColumn [0]
            Caption = #1057#1090#1072#1090#1091#1089
            DataBinding.FieldName = 'StatusCode'
            PropertiesClassName = 'TcxImageComboBoxProperties'
            Properties.Images = dmMain.ImageList
            Properties.Items = <
              item
                Description = #1053#1077' '#1087#1088#1086#1074#1077#1076#1077#1085
                ImageIndex = 11
                Value = 1
              end
              item
                Description = #1055#1088#1086#1074#1077#1076#1077#1085
                ImageIndex = 12
                Value = 2
              end
              item
                Description = #1059#1076#1072#1083#1077#1085
                ImageIndex = 13
                Value = 3
              end>
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object colInvNumber: TcxGridDBColumn [1]
            Caption = #8470' '#1044#1086#1082
            DataBinding.FieldName = 'InvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object colOperDate: TcxGridDBColumn [2]
            Caption = #1044#1072#1090#1072
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          inherited colGoodsCode: TcxGridDBColumn
            Options.Editing = False
            Width = 45
          end
          inherited colGoodsName: TcxGridDBColumn
            Options.Editing = False
            Width = 150
          end
          object colMeasureName: TcxGridDBColumn [5]
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object colGoodsKindName: TcxGridDBColumn [6]
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object colGoodsKindCompleteName: TcxGridDBColumn [7]
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' '#1043#1055
            DataBinding.FieldName = 'GoodsKindCompleteName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actGoodsKindChoiceMaster
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          inherited colAmount: TcxGridDBColumn
            Properties.DecimalPlaces = 4
            Options.Editing = False
          end
          object colRealWeight: TcxGridDBColumn [9]
            Caption = #1060#1072#1082#1090' '#1074#1077#1089
            DataBinding.FieldName = 'RealWeight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object colCuterCount: TcxGridDBColumn [10]
            Caption = #1050#1091#1090#1077#1088#1086#1074' '#1092#1072#1082#1090
            DataBinding.FieldName = 'CuterCount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object colCount: TcxGridDBColumn [11]
            Caption = #1050#1086#1083'-'#1074#1086' '#1073#1072#1090#1086#1085#1086#1074
            DataBinding.FieldName = 'Count'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object colAmount_order: TcxGridDBColumn [12]
            Caption = #1050#1086#1083'-'#1074#1086' '#1079#1072#1103#1074#1082#1072
            DataBinding.FieldName = 'Amount_order'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object colCuterCount_order: TcxGridDBColumn [13]
            Caption = #1050#1091#1090#1077#1088#1086#1074' '#1079#1072#1103#1074#1082#1072
            DataBinding.FieldName = 'CuterCount_order'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object colReceiptCode: TcxGridDBColumn [14]
            Caption = #1050#1086#1076' '#1088#1077#1094#1077#1087#1090'.'
            DataBinding.FieldName = 'ReceiptCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object colReceiptName: TcxGridDBColumn [15]
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1088#1077#1094#1077#1087#1090#1091#1088#1099
            DataBinding.FieldName = 'ReceiptName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
          object colPartionClose: TcxGridDBColumn [16]
            Caption = #1055#1072#1088#1090#1080#1103' '#1079#1072#1082#1088#1099#1090#1072' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'PartionClose'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object colPartionGoods: TcxGridDBColumn [17]
            Caption = #1055#1072#1088#1090#1080#1103' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'PartionGoods'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object colComment: TcxGridDBColumn [18]
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          inherited colIsErased: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
        end
      end
      inherited cxGridChild: TcxGrid
        Top = 205
        Width = 1097
        ExplicitTop = 205
        ExplicitWidth = 1097
        inherited cxGridDBTableViewChild: TcxGridDBTableView
          Styles.Content = nil
          object colChildGroupNumber: TcxGridDBColumn [0]
            Caption = #1043#1088#1091#1087#1087#1072' '#8470
            DataBinding.FieldName = 'GroupNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          inherited colChildGoodsCode: TcxGridDBColumn
            Options.Editing = False
            Width = 55
          end
          object colChildGoodsName: TcxGridDBColumn [2]
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'GoodsName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actGoodsChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 150
          end
          object colChildMeasureName: TcxGridDBColumn [3]
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object colChildGoodsKindName: TcxGridDBColumn [4]
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actGoodsKindChoiceChild
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          inherited colChildAmountReceipt: TcxGridDBColumn [5]
            Caption = #1050#1086#1083'-'#1074#1086' 1 '#1082#1091#1090#1077#1088' '
            Visible = True
            Options.Editing = False
            Width = 80
          end
          inherited colChildAmount: TcxGridDBColumn [6]
            Caption = #1050#1086#1083'-'#1074#1086' '#1092#1072#1082#1090
            Options.Editing = False
            Width = 70
          end
          object colChildAmountCalc: TcxGridDBColumn [7]
            Caption = #1050#1086#1083'-'#1074#1086' '#1088#1072#1089#1095#1077#1090
            DataBinding.FieldName = 'AmountCalc'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object colChildPartionGoodsDate: TcxGridDBColumn [8]
            Caption = #1044#1072#1090#1072' '#1087#1072#1088#1090#1080#1080
            DataBinding.FieldName = 'PartionGoodsDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 76
          end
          inherited colChildPartionGoods: TcxGridDBColumn
            Options.Editing = False
            Width = 80
          end
          inherited colChildComment: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            Visible = True
            Options.Editing = False
            Width = 100
          end
          inherited colChildIsErased: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
        end
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 1097
    Height = 72
    ExplicitWidth = 1097
    ExplicitHeight = 72
    inherited edInvNumber: TcxTextEdit
      Left = 619
      Top = 25
      Visible = False
      ExplicitLeft = 619
      ExplicitTop = 25
      ExplicitWidth = 75
      Width = 75
    end
    inherited cxLabel1: TcxLabel
      Left = 619
      Top = 6
      Visible = False
      ExplicitLeft = 619
      ExplicitTop = 6
    end
    inherited edOperDate: TcxDateEdit
      Left = 700
      Top = 25
      Visible = False
      ExplicitLeft = 700
      ExplicitTop = 25
      ExplicitWidth = 61
      Width = 61
    end
    inherited cxLabel2: TcxLabel
      Left = 704
      Top = 7
      Visible = False
      ExplicitLeft = 704
      ExplicitTop = 7
    end
    inherited cxLabel15: TcxLabel
      Left = 767
      Top = 6
      Visible = False
      ExplicitLeft = 767
      ExplicitTop = 6
    end
    inherited ceStatus: TcxButtonEdit
      Left = 767
      Top = 25
      Visible = False
      ExplicitLeft = 767
      ExplicitTop = 25
      ExplicitWidth = 100
      Width = 100
    end
    inherited cxLabel3: TcxLabel
      Left = 209
      Top = 6
      ExplicitLeft = 209
      ExplicitTop = 6
    end
    inherited cxLabel4: TcxLabel
      Left = 224
      Top = 30
      ExplicitLeft = 224
      ExplicitTop = 30
    end
    inherited edFrom: TcxButtonEdit
      Left = 259
      Top = 5
      ExplicitLeft = 259
      ExplicitTop = 5
      ExplicitWidth = 200
      Width = 200
    end
    inherited edTo: TcxButtonEdit
      Left = 259
      Top = 30
      ExplicitLeft = 259
      ExplicitTop = 30
      ExplicitWidth = 200
      Width = 200
    end
    object cxLabel5: TcxLabel
      Left = 19
      Top = 6
      Caption = #1053#1072#1095#1072#1083#1086' '#1087#1077#1088#1080#1086#1076#1072':'
    end
    object deStart: TcxDateEdit
      Left = 112
      Top = 5
      EditValue = 41791d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 11
      Width = 85
    end
    object cxLabel6: TcxLabel
      Left = 0
      Top = 30
      Caption = #1054#1082#1086#1085#1095#1072#1085#1080#1077' '#1087#1077#1088#1080#1086#1076#1072':'
    end
    object deEnd: TcxDateEdit
      Left = 112
      Top = 29
      EditValue = 41791d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 13
      Width = 85
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
      end>
  end
  inherited ActionList: TActionList
    inherited actRefresh: TdsdDataSetRefresh
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      RefreshOnTabSetChanges = True
    end
    inherited actMISetErased: TdsdUpdateErased
      Enabled = False
    end
    inherited actMISetUnErased: TdsdUpdateErased
      Enabled = False
    end
    inherited actInsertUpdateMovement: TdsdExecStoredProc
      Enabled = False
      StoredProc = nil
      StoredProcList = <>
    end
    inherited actShowErased: TBooleanStoredProcAction
      Enabled = False
    end
    inherited actShowAll: TBooleanStoredProcAction
      Enabled = False
    end
    object actUpdateChildDS: TdsdUpdateDataSet [9]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spInsertUpdateMIChild
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIChild
        end>
      Caption = 'actUpdateChildDS'
      DataSource = ChildDS
    end
    inherited actAddMask: TdsdExecStoredProc
      Enabled = False
    end
    object actGoodsKindChoiceChild: TOpenChoiceForm [18]
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'GoodsKindForm'
      FormName = 'TGoodsKindForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ChildCDS
          ComponentItem = 'GoodsKindId'
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ChildCDS
          ComponentItem = 'GoodsKindName'
          DataType = ftString
        end>
      isShowModal = True
    end
    object actGoodsKindChoiceMaster: TOpenChoiceForm [19]
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'GoodsKindForm'
      FormName = 'TGoodsKindForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindCompleteId'
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindCompleteName'
          DataType = ftString
        end>
      isShowModal = True
    end
    object actUpdate: TdsdInsertUpdateAction [23]
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100
      ShortCut = 115
      ImageIndex = 1
      FormName = 'TProductionUnionTechEditForm'
      FormNameParam.Value = 'TProductionUnionTechEditForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          ParamType = ptInput
        end
        item
          Name = 'OperDate'
          Value = 41791d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
        end
        item
          Name = 'FromId'
          Value = Null
          Component = GuidesFrom
          ComponentItem = 'Key'
          ParamType = ptInput
        end
        item
          Name = 'ToId'
          Value = Null
          Component = GuidesTo
          ComponentItem = 'Key'
          ParamType = ptInput
        end
        item
          Name = 'MIOrderId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MIOrderId'
          ParamType = ptInput
        end>
      isShowModal = False
      ActionType = acUpdate
      DataSource = MasterDS
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actInsert: TdsdInsertUpdateAction [24]
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      ShortCut = 45
      ImageIndex = 0
      FormName = 'TProductionUnionTechEditForm'
      FormNameParam.Value = 'TProductionUnionTechEditForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          ParamType = ptInput
        end
        item
          Name = 'OperDate'
          Value = Null
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
        end
        item
          Name = 'FromId'
          Value = Null
          Component = GuidesFrom
          ComponentItem = 'Key'
          ParamType = ptInput
        end
        item
          Name = 'ToId'
          Value = Null
          Component = GuidesTo
          ComponentItem = 'Key'
          ParamType = ptInput
        end
        item
          Name = 'MIOrderId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MIOrderId'
          ParamType = ptInput
        end>
      isShowModal = True
      DataSource = MasterDS
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    inherited actUnComplete: TdsdChangeMovementStatus
      Enabled = True
    end
    inherited actComplete: TdsdChangeMovementStatus
      Enabled = True
    end
    inherited actSetErased: TdsdChangeMovementStatus
      Enabled = True
    end
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_ProductionUnionTech'
    Params = <
      item
        Name = 'inStartDate'
        Value = 41791d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inEndDate'
        Value = 41791d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inFromId'
        Value = Null
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inToId'
        Value = False
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
      end>
  end
  inherited BarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbComplete'
        end
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end
        item
          Visible = True
          ItemName = 'dxBarButton2'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsert'
        end
        item
          Visible = True
          ItemName = 'bbEdit'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbAddChild'
        end
        item
          Visible = True
          ItemName = 'bbErasedChild'
        end
        item
          Visible = True
          ItemName = 'bbUnErasedChild'
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
          ItemName = 'bbPrint'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbMovementItemProtocol'
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
    inherited bbPrint: TdxBarButton
      Visible = ivNever
    end
    object bbEdit: TdxBarButton [18]
      Action = actUpdate
      Category = 0
    end
    object bbInsert: TdxBarButton [19]
      Action = actInsert
      Category = 0
    end
  end
  inherited PopupMenu: TPopupMenu
    Left = 152
    Top = 240
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
      end
      item
        Name = 'Key'
        Value = Null
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'ShowAll'
        Value = False
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInputOutput
      end
      item
        Name = 'TotalSumm'
        Value = Null
        DataType = ftString
      end
      item
        Name = 'MIOrderId'
        Value = Null
        ParamType = ptInput
      end
      item
        Name = 'FromId'
        Value = Null
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'FromName'
        Value = Null
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'ToId'
        Value = Null
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'ToName'
        Value = Null
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
  end
  inherited StatusGuides: TdsdGuides
    Left = 880
    Top = 56
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_ProductionUnion'
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inStatusCode'
        Value = ''
        Component = MasterCDS
        ComponentItem = 'StatusCode'
        ParamType = ptInput
      end>
    Left = 808
  end
  inherited spGet: TdsdStoredProc
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inOperDate'
        Value = Null
        Component = FormParams
        ComponentItem = 'inOperDate'
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'InvNumber'
        Value = ''
        Component = edInvNumber
        DataType = ftString
      end
      item
        Name = 'OperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
      end
      item
        Name = 'StatusCode'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'StatusName'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'FromId'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
      end
      item
        Name = 'FromName'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'ToId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
      end
      item
        Name = 'ToName'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Value = ''
        DataType = ftString
        ParamType = ptUnknown
      end
      item
        Value = Null
        ParamType = ptUnknown
      end>
    Left = 288
    Top = 168
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inInvNumber'
        Value = ''
        Component = edInvNumber
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inOperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inFromId'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inToId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Value = ''
        DataType = ftString
        ParamType = ptUnknown
      end>
    Left = 442
    Top = 136
  end
  inherited GuidesFiller: TGuidesFiller
    ActionItemList = <
      item
        Action = actRefresh
      end>
  end
  inherited HeaderSaver: THeaderSaver
    Left = 328
    Top = 137
  end
  object RefreshDispatcher: TRefreshDispatcher [18]
    IdParam.Value = Null
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = GuidesFrom
      end
      item
        Component = GuidesTo
      end>
    Left = 288
    Top = 232
  end
  inherited spErasedMIMaster: TdsdStoredProc
    StoredProcName = ''
    Left = 694
    Top = 512
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = ''
    Left = 646
    Top = 528
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_ProductionUnion_Master'
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inPartionClose'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionClose'
        DataType = ftBoolean
        ParamType = ptInput
      end
      item
        Name = 'inCount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Count'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inRealWeight'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'RealWeight'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inCuterCount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CuterCount'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inPartionGoods'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionGoods'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inComment'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inGoodsKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
      end
      item
        Name = 'inGoodsKindCompleteId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindCompleteId'
        ParamType = ptInput
      end
      item
        Name = 'inReceiptId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ReceiptId'
        ParamType = ptInput
      end>
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    Left = 376
    Top = 256
  end
  inherited spGetTotalSumm: TdsdStoredProc
    StoredProcName = ''
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId'
        ParamType = ptInput
      end
      item
        Name = 'TotalSumm'
        Value = Null
        Component = FormParams
        ComponentItem = 'TotalSumm'
        DataType = ftString
      end>
  end
  inherited spErasedMIChild: TdsdStoredProc
    StoredProcName = 'gpMovementItem_ProductionUnion_Child_SetErased'
  end
  inherited spUnErasedMIChild: TdsdStoredProc
    StoredProcName = 'gpMovementItem_ProductionUnion_Child_SetUnErased'
  end
  inherited GuidesTo: TdsdGuides
    Left = 280
    Top = 32
  end
  inherited GuidesFrom: TdsdGuides
    Left = 344
    Top = 0
  end
  inherited spInsertUpdateMIChild: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_ProductionUnion_Child'
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inParentId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'ParentId'
        ParamType = ptInput
      end
      item
        Name = 'inAmountReceipt'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'AmountReceipt'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inPartionGoodsDate'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'PartionGoodsDate'
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inPartionGoods'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'PartionGoods'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inComment'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inGoodsKindId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
      end>
  end
  inherited spMovementSetErased: TdsdStoredProc
    Top = 248
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 56
    Top = 8
  end
end
