inherited Report_GoodsMI_ProductionSeparateForm: TReport_GoodsMI_ProductionSeparateForm
  Caption = #1054#1090#1095#1077#1090' <'#1055#1088#1080#1093#1086#1076'/'#1056#1072#1089#1093#1086#1076' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' ('#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077')>'
  ClientHeight = 427
  ClientWidth = 1098
  AddOnFormData.isSingle = False
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.Params = FormParams
  ExplicitWidth = 1114
  ExplicitHeight = 465
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 99
    Width = 1098
    Height = 328
    TabOrder = 3
    ExplicitTop = 99
    ExplicitWidth = 1098
    ExplicitHeight = 328
    ClientRectBottom = 328
    ClientRectRight = 1098
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1098
      ExplicitHeight = 328
      inherited cxGrid: TcxGrid
        Width = 1098
        Height = 328
        ExplicitWidth = 1098
        ExplicitHeight = 328
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = clSumm
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clHeadCount
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clAmount
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
              Column = clChildSumm
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clChildAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = clSumm
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clHeadCount
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clAmount
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
              Column = clChildSumm
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clChildAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
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
          object clInvNumber: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'.'
            DataBinding.FieldName = 'InvNumber'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 46
          end
          object clOperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086#1082'.'
            DataBinding.FieldName = 'OperDate'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 49
          end
          object clPartionGoods: TcxGridDBColumn
            Caption = #1055#1072#1088#1090#1080#1103
            DataBinding.FieldName = 'PartionGoods'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 48
          end
          object clGoodsGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072' ('#1088#1072#1089#1093#1086#1076')'
            DataBinding.FieldName = 'GoodsGroupName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 103
          end
          object clGoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1090#1086#1074#1072#1088#1072' ('#1088#1072#1089#1093#1086#1076')'
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 79
          end
          object clGoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088' ('#1088#1072#1089#1093#1086#1076')'
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 76
          end
          object clHeadCount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1075#1086#1083#1086#1074
            DataBinding.FieldName = 'HeadCount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 68
          end
          object clAmount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' ('#1088#1072#1089#1093#1086#1076')'
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 65
          end
          object clSumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072'  ('#1088#1072#1089#1093#1086#1076')'
            DataBinding.FieldName = 'Summ'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 66
          end
          object clChildGoodsGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072' ('#1087#1088#1080#1093#1086#1076')'
            DataBinding.FieldName = 'ChildGoodsGroupName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 72
          end
          object clChildGoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1090#1086#1074#1072#1088#1072' ('#1087#1088#1080#1093#1086#1076')'
            DataBinding.FieldName = 'ChildGoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 71
          end
          object clChildGoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088' ('#1087#1088#1080#1093#1086#1076')'
            DataBinding.FieldName = 'ChildGoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 71
          end
          object clChildAmount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' ('#1087#1088#1080#1093#1086#1076')'
            DataBinding.FieldName = 'ChildAmount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object clChildSumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072'  ('#1087#1088#1080#1093#1086#1076')'
            DataBinding.FieldName = 'ChildSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object clPrice: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1087#1088#1072#1081#1089
            DataBinding.FieldName = 'Price'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object clChildPrice: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' ('#1087#1088#1080#1093#1086#1076')'
            DataBinding.FieldName = 'ChildPrice'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object clPercent: TcxGridDBColumn
            Caption = '% '#1074#1099#1093#1086#1076#1072
            DataBinding.FieldName = 'Percent'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1098
    Height = 73
    ExplicitWidth = 1098
    ExplicitHeight = 73
    inherited deStart: TcxDateEdit
      Left = 108
      EditValue = 41640d
      Properties.SaveTime = False
      ExplicitLeft = 108
    end
    inherited deEnd: TcxDateEdit
      Left = 108
      Top = 29
      EditValue = 41640d
      Properties.SaveTime = False
      ExplicitLeft = 108
      ExplicitTop = 29
    end
    inherited cxLabel1: TcxLabel
      Left = 19
      ExplicitLeft = 19
    end
    inherited cxLabel2: TcxLabel
      Left = 0
      Top = 30
      ExplicitLeft = 0
      ExplicitTop = 30
    end
    object cxLabel4: TcxLabel
      Left = 501
      Top = 6
      Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074'.'#1088#1072#1089#1093'.:'
    end
    object edGoodsGroup: TcxButtonEdit
      Left = 596
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 5
      Width = 147
    end
    object cxLabel3: TcxLabel
      Left = 194
      Top = 6
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1086#1090' '#1082#1086#1075#1086'):'
    end
    object edFromGroup: TcxButtonEdit
      Left = 328
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 169
    end
    object cxLabel5: TcxLabel
      Left = 208
      Top = 30
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1082#1086#1084#1091'):'
    end
    object edGoods: TcxButtonEdit
      Left = 812
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 9
      Width = 148
    end
    object edToGroup: TcxButtonEdit
      Left = 328
      Top = 29
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 10
      Width = 169
    end
    object cbGroupMovement: TcxCheckBox
      Left = 959
      Top = 5
      Caption = #1043#1088#1091#1087#1087#1080#1088#1086#1074#1082#1072' '#1087#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084
      TabOrder = 11
      Width = 172
    end
    object cbGroupPartion: TcxCheckBox
      Left = 959
      Top = 29
      Caption = #1043#1088#1091#1087#1087#1080#1088#1086#1074#1082#1072' '#1087#1086' '#1087#1072#1088#1090#1080#1103#1084
      TabOrder = 12
      Width = 156
    end
    object cxLabel6: TcxLabel
      Left = 501
      Top = 32
      Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074'.'#1087#1088#1080#1093':'
    end
    object cxLabel8: TcxLabel
      Left = 747
      Top = 6
      Caption = #1058#1086#1074#1072#1088' '#1088#1072#1089#1093':'
    end
    object edChildGoods: TcxButtonEdit
      Left = 812
      Top = 29
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 15
      Width = 148
    end
    object edChildGoodsGroup: TcxButtonEdit
      Left = 596
      Top = 29
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 16
      Width = 147
    end
  end
  object cxLabel7: TcxLabel [2]
    Left = 747
    Top = 30
    Caption = #1058#1086#1074#1072#1088' '#1087#1088#1080#1093':'
  end
  inherited ActionList: TActionList
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1054#1090#1095#1077#1090'_'#1055#1088#1080#1093#1086#1076'_'#1056#1072#1089#1093#1086#1076'_'#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086'_'#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'_'#1087#1086'_'#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084'_1'
      Hint = #1054#1090#1095#1077#1090'_'#1055#1088#1080#1093#1086#1076'_'#1056#1072#1089#1093#1086#1076'_'#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086'_'#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'_'#1087#1086'_'#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084'_1'
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
        end
        item
          Name = 'ReportType'
          Value = '0'
          ParamType = ptInput
        end
        item
          Name = 'UnitName'
          Value = ''
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'FromName'
          Value = Null
          Component = FromGroupGuides
          ComponentItem = 'TextValue'
          DataType = ftString
        end
        item
          Name = 'ToName'
          Value = Null
          Component = ToGroupGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'GoodsGroupName'
          Value = Null
          Component = GoodsGroupGuides
          ComponentItem = 'TextValue'
          DataType = ftString
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = GoodsGuides
          ComponentItem = 'TextValue'
          DataType = ftString
        end>
      ReportName = #1054#1090#1095#1077#1090'_'#1055#1088#1080#1093#1086#1076'_'#1056#1072#1089#1093#1086#1076'_'#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086'_'#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'_'#1087#1086'_'#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084'_1'
      ReportNameParam.Value = #1054#1090#1095#1077#1090'_'#1055#1088#1080#1093#1086#1076'_'#1056#1072#1089#1093#1086#1076'_'#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086'_'#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'_'#1087#1086'_'#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084'_1'
      ReportNameParam.DataType = ftString
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_GoodsMI_ProductionSeparateUnionDialogForm'
      FormNameParam.Value = 'TReport_GoodsMI_ProductionSeparateUnionDialogForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
        end
        item
          Name = 'FromGroupId'
          Value = ''
          Component = FromGroupGuides
          ComponentItem = 'Key'
          ParamType = ptInput
        end
        item
          Name = 'FromGroupName'
          Value = ''
          Component = FromGroupGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'ToGroupId'
          Value = ''
          Component = ToGroupGuides
          ComponentItem = 'Key'
          ParamType = ptInput
        end
        item
          Name = 'ToGroupName'
          Value = ''
          Component = ToGroupGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'GoodsGroupId'
          Value = ''
          Component = GoodsGroupGuides
          ComponentItem = 'Key'
          ParamType = ptInput
        end
        item
          Name = 'GoodsGroupName'
          Value = ''
          Component = GoodsGroupGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'ChildGoodsGroupId'
          Value = ''
          Component = ChildGoodsGroupGuides
          ComponentItem = 'Key'
          ParamType = ptInput
        end
        item
          Name = 'ChildGoodsGroupName'
          Value = ''
          Component = ChildGoodsGroupGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'GoodsId'
          Value = ''
          Component = GoodsGuides
          ComponentItem = 'Key'
          ParamType = ptInput
        end
        item
          Name = 'GoodsName'
          Value = ''
          Component = GoodsGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'ChildGoodsId'
          Value = ''
          Component = ChildGoodsGuides
          ComponentItem = 'Key'
          ParamType = ptInput
        end
        item
          Name = 'ChildGoodsName'
          Value = ''
          Component = ChildGoodsGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'isGroupMovement'
          Value = 'False'
          Component = cbGroupMovement
          DataType = ftBoolean
          ParamType = ptInputOutput
        end
        item
          Name = 'isGroupPartion'
          Value = 'False'
          Component = cbGroupPartion
          DataType = ftBoolean
          ParamType = ptInputOutput
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
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
    StoredProcName = 'gpReport_GoodsMI_ProductionSeparate'
    Params = <
      item
        Name = 'inStartDate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inEndDate'
        Value = 41640d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inGroupMovement'
        Value = Null
        Component = cbGroupMovement
        DataType = ftBoolean
        ParamType = ptInput
      end
      item
        Name = 'inGroupPartion'
        Value = Null
        Component = cbGroupPartion
        DataType = ftBoolean
        ParamType = ptInput
      end
      item
        Name = 'inGoodsGroupId'
        Value = ''
        Component = GoodsGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = GoodsGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inChildGoodsGroupId'
        Value = Null
        Component = ChildGoodsGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inChildGoodsId'
        Value = Null
        Component = ChildGoodsGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inFromId'
        Value = Null
        Component = FromGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inToId'
        Value = Null
        Component = ToGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end>
    Left = 112
    Top = 208
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
          ItemName = 'bbPrint'
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
      Action = actPrint
      Category = 0
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 320
    Top = 232
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 112
    Top = 128
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = cbGroupMovement
      end
      item
        Component = cbGroupPartion
      end
      item
        Component = ChildGoodsGroupGuides
      end
      item
        Component = ChildGoodsGuides
      end
      item
        Component = FromGroupGuides
      end
      item
        Component = ToGroupGuides
      end
      item
        Component = GoodsGuides
      end
      item
        Component = GoodsGroupGuides
      end
      item
      end>
    Left = 184
    Top = 136
  end
  object GoodsGroupGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoodsGroup
    FormNameParam.Value = 'TGoodsGroup_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TGoodsGroup_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GoodsGroupGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 616
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'InDescName'
        Value = ''
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inGroupMovement'
        Value = Null
        DataType = ftBoolean
        ParamType = ptInput
      end>
    Left = 328
    Top = 170
  end
  object FromGroupGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edFromGroup
    FormNameParam.Value = 'TUnitTreeForm'
    FormNameParam.DataType = ftString
    FormName = 'TUnitTreeForm'
    PositionDataSet = 'ClientDataSet'
    ParentDataSet = 'TreeDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = FromGroupGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = FromGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 408
  end
  object GoodsGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoods
    FormNameParam.Value = 'TGoodsFuel_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TGoodsFuel_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GoodsGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 848
    Top = 65531
  end
  object ToGroupGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edToGroup
    FormNameParam.Value = 'TUnitTreeForm'
    FormNameParam.DataType = ftString
    FormName = 'TUnitTreeForm'
    PositionDataSet = 'ClientDataSet'
    ParentDataSet = 'TreeDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ToGroupGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ToGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 464
    Top = 24
  end
  object ChildGoodsGroupGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edChildGoodsGroup
    FormNameParam.Value = 'TGoodsGroup_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TGoodsGroup_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ChildGoodsGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ChildGoodsGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 680
    Top = 24
  end
  object ChildGoodsGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edChildGoods
    FormNameParam.Value = 'TGoodsFuel_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TGoodsFuel_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ChildGoodsGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ChildGoodsGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 904
    Top = 19
  end
end
