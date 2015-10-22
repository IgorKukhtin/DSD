inherited Report_Movement_ByPartionGoodsForm: TReport_Movement_ByPartionGoodsForm
  Caption = #1055#1086#1080#1089#1082' '#1076#1077#1092#1077#1082#1090#1091#1088#1099
  ClientHeight = 459
  ClientWidth = 1118
  ExplicitWidth = 1134
  ExplicitHeight = 497
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Left = 145
    Top = 26
    Width = 973
    Height = 433
    TabOrder = 3
    ExplicitLeft = 145
    ExplicitTop = 26
    ExplicitWidth = 852
    ExplicitHeight = 282
    ClientRectBottom = 433
    ClientRectRight = 973
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 852
      ExplicitHeight = 282
      inherited cxGrid: TcxGrid
        Width = 973
        Height = 433
        ExplicitWidth = 852
        ExplicitHeight = 282
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.000'
              Kind = skSum
              Column = colIncomeAmount
            end
            item
              Format = ',0.000'
              Kind = skSum
              Column = colRemains
            end>
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colPartionGoods: TcxGridDBColumn
            Caption = #1055#1072#1088#1090#1080#1103
            DataBinding.FieldName = 'PartionGoods'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.CellMerging = True
            Width = 60
          end
          object colMovementId: TcxGridDBColumn
            Caption = #1042#1085'. '#1085#1086#1084#1077#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
            DataBinding.FieldName = 'MovementId'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          object colInvNumber: TcxGridDBColumn
            Caption = #8470' '#1087#1088#1080#1093#1086#1076#1072
            DataBinding.FieldName = 'InvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.CellMerging = True
            Width = 56
          end
          object colOperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1087#1088#1080#1093#1086#1076#1072
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.CellMerging = True
            Width = 59
          end
          object colStatusName: TcxGridDBColumn
            Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
            DataBinding.FieldName = 'StatusName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.CellMerging = True
            Width = 80
          end
          object colIncomeUnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' '#1087#1088#1080#1093#1086#1076#1072
            DataBinding.FieldName = 'IncomeUnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.CellMerging = True
            Width = 109
          end
          object colJuridicalName: TcxGridDBColumn
            Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.CellMerging = True
            Width = 109
          end
          object colGoodsId: TcxGridDBColumn
            Caption = #1048#1044' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsId'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          object colGoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 53
          end
          object colGoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 158
          end
          object colIncomeAmount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1074' '#1087#1088#1080#1093#1086#1076#1077
            DataBinding.FieldName = 'IncomeAmount'
            PropertiesClassName = 'TcxCalcEditProperties'
            Properties.DisplayFormat = ',0.000'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 58
          end
          object colRemains: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082' '#1087#1086' '#1087#1088#1080#1093#1086#1076#1091
            DataBinding.FieldName = 'Remains'
            PropertiesClassName = 'TcxCalcEditProperties'
            Properties.DisplayFormat = ',0.000'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          object colRemainsUnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' '#1086#1089#1090#1072#1090#1082#1072
            DataBinding.FieldName = 'RemainsUnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 138
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Top = 26
    Width = 145
    Height = 433
    Align = alLeft
    ExplicitTop = 26
    ExplicitWidth = 145
    ExplicitHeight = 282
    inherited deStart: TcxDateEdit
      Left = 13
      Top = 52
      EditValue = 42296d
      Visible = False
      ExplicitLeft = 13
      ExplicitTop = 52
    end
    inherited deEnd: TcxDateEdit
      Left = 13
      Top = 28
      Visible = False
      ExplicitLeft = 13
      ExplicitTop = 28
    end
    inherited cxLabel1: TcxLabel
      Left = 13
      Top = 53
      Visible = False
      ExplicitLeft = 13
      ExplicitTop = 53
    end
    inherited cxLabel2: TcxLabel
      Left = 13
      Top = 29
      Visible = False
      ExplicitLeft = 13
      ExplicitTop = 29
    end
    object mmoPartionGoods: TcxMemo
      Left = 1
      Top = 1
      Align = alClient
      Properties.ScrollBars = ssVertical
      TabOrder = 4
      ExplicitHeight = 205
      Height = 356
      Width = 143
    end
    object btnRefresh: TcxButton
      Left = 1
      Top = 357
      Width = 143
      Height = 25
      Align = alBottom
      Action = actRefresh
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
      ExplicitTop = 206
    end
    object btnRefreshOnlyComplete: TcxButton
      Left = 1
      Top = 382
      Width = 143
      Height = 25
      Align = alBottom
      Action = actRefreshOnlyComplete
      ParentShowHint = False
      ShowHint = True
      TabOrder = 6
      ExplicitTop = 231
    end
    object btnRefreshHaveRemains: TcxButton
      Left = 1
      Top = 407
      Width = 143
      Height = 25
      Align = alBottom
      Action = actRefreshHaveRemains
      ParentShowHint = False
      ShowHint = True
      TabOrder = 7
      ExplicitTop = 256
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 163
    Top = 192
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 136
    Top = 192
  end
  inherited ActionList: TActionList
    Left = 191
    Top = 191
    inherited actRefresh: TdsdDataSetRefresh
      MoveParams = <
        item
          FromParam.Value = False
          FromParam.DataType = ftBoolean
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'OnlyComplete'
          ToParam.DataType = ftBoolean
        end
        item
          FromParam.Value = False
          FromParam.DataType = ftBoolean
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'OnlyHaveRemains'
          ToParam.DataType = ftBoolean
        end>
      Caption = #1053#1072#1081#1090#1080' '#1074#1089#1077' '#1087#1088#1080#1093#1086#1076#1099
      Hint = #1053#1072#1081#1090#1080' '#1074#1089#1077' '#1087#1088#1080#1093#1086#1076#1099
    end
    object actRefreshOnlyComplete: TdsdDataSetRefresh [1]
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Value = True
          FromParam.DataType = ftBoolean
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'OnlyComplete'
          ToParam.DataType = ftBoolean
        end
        item
          FromParam.Value = False
          FromParam.DataType = ftBoolean
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'OnlyHaveRemains'
          ToParam.DataType = ftBoolean
        end>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1088#1086#1074#1077#1076#1077#1085#1085#1099#1077' '#1087#1088#1080#1093#1086#1076#1099
      Hint = #1053#1072#1081#1090#1080' '#1090#1086#1083#1100#1082#1086' '#1087#1088#1086#1074#1077#1076#1077#1085#1085#1099#1077' '#1087#1088#1080#1093#1086#1076#1099
      ImageIndex = 12
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actRefreshHaveRemains: TdsdDataSetRefresh [2]
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Value = True
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'OnlyComplete'
        end
        item
          FromParam.Value = True
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'OnlyHaveRemains'
        end>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1088#1080#1093#1086#1076#1099' '#1089' '#1086#1089#1090#1072#1090#1082#1086#1084
      Hint = #1053#1072#1081#1090#1080' '#1090#1086#1083#1100#1082#1086' '#1087#1088#1080#1093#1086#1076#1099' '#1089' '#1086#1089#1090#1072#1090#1082#1086#1084
      ImageIndex = 51
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actOpenDocument: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090
      FormNameParam.Name = 'FormClass'
      FormNameParam.Value = Null
      FormNameParam.Component = FormParams
      FormNameParam.ComponentItem = 'FormClass'
      FormNameParam.DataType = ftString
      FormNameParam.ParamType = ptInput
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId'
          ParamType = ptInput
        end>
      isShowModal = False
    end
    object actGet_MovementFormClass: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_MovementFormClass
      StoredProcList = <
        item
          StoredProc = spGet_MovementFormClass
        end>
      Caption = 'actGet_MovementFormClass'
    end
    object mactOpenDocument: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actGet_MovementFormClass
        end
        item
          Action = actOpenDocument
        end>
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090
      ImageIndex = 1
    end
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_ByPartionGoods'
    Params = <
      item
        Name = 'inPartionGoods'
        Value = Null
        Component = mmoPartionGoods
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inOnlyComplete'
        Value = Null
        Component = FormParams
        ComponentItem = 'OnlyComplete'
        DataType = ftBoolean
        ParamType = ptInput
      end
      item
        Name = 'inOnlyHaveRemains'
        Value = Null
        Component = FormParams
        ComponentItem = 'OnlyHaveRemains'
        DataType = ftBoolean
        ParamType = ptInput
      end>
  end
  inherited BarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      26
      0)
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnDblClickActionList = <
      item
        Action = mactOpenDocument
      end>
    Left = 560
    Top = 152
  end
  inherited PopupMenu: TPopupMenu
    Left = 232
    Top = 192
  end
  object spGet_MovementFormClass: TdsdStoredProc
    StoredProcName = 'gpGet_MovementFormClass'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId'
        ParamType = ptInput
      end
      item
        Name = 'outFormClass'
        Value = Null
        Component = FormParams
        ComponentItem = 'FormClass'
        DataType = ftString
      end>
    PackSize = 1
    Left = 376
    Top = 152
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'OnlyComplete'
        Value = False
        DataType = ftBoolean
      end
      item
        Name = 'OnlyHaveRemains'
        Value = False
        DataType = ftBoolean
      end
      item
        Name = 'FormClass'
        Value = Null
        DataType = ftString
      end>
    Left = 328
    Top = 216
  end
end
