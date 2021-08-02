inherited Unit_PauseDistribListDiffForm: TUnit_PauseDistribListDiffForm
  Caption = #1056#1072#1079#1088#1077#1096#1077#1085#1080#1077' '#1079#1072#1082#1072#1079' '#1073#1077#1079' '#1082#1086#1085#1090#1088#1086#1083#1103' '#1086#1089#1090#1072#1090#1082#1072' '#1087#1086' '#1089#1077#1090#1080
  ClientHeight = 407
  ClientWidth = 644
  AddOnFormData.isSingle = False
  ExplicitWidth = 660
  ExplicitHeight = 446
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 644
    Height = 381
    ExplicitWidth = 644
    ExplicitHeight = 381
    ClientRectBottom = 381
    ClientRectRight = 644
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 644
      ExplicitHeight = 381
      inherited cxGrid: TcxGrid
        Width = 644
        Height = 381
        ExplicitWidth = 644
        ExplicitHeight = 381
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object UnitCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'UnitCode'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object UnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 336
          end
          object isRequestDistribListDiff: TcxGridDBColumn
            Caption = #1047#1072#1087#1088#1086#1089' '#1085#1072' '#1088#1072#1079#1088#1077#1096#1077#1085#1080#1103' '#1079#1072#1082#1072#1079' '#1073#1077#1079' '#1082#1086#1085#1090#1088#1086#1083#1103
            DataBinding.FieldName = 'isRequestDistribListDiff'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1087#1088#1086#1089' '#1085#1072' '#1088#1072#1079#1088#1077#1096#1077#1085#1080#1103' '#1079#1072#1082#1072#1079' '#1073#1077#1079' '#1082#1086#1085#1090#1088#1086#1083#1103' '#1086#1089#1090#1072#1090#1082#1072' '#1087#1086' '#1089#1077#1090#1080
            Options.Editing = False
            Width = 115
          end
          object isPauseDistribListDiff: TcxGridDBColumn
            Caption = #1056#1072#1079#1088#1077#1096#1080#1090#1100' '#1079#1072#1082#1072#1079' '#1073#1077#1079' '#1082#1086#1085#1090#1088#1086#1083#1103
            DataBinding.FieldName = 'isPauseDistribListDiff'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1079#1088#1077#1096#1080#1090#1100' '#1079#1072#1082#1072#1079' '#1073#1077#1079' '#1082#1086#1085#1090#1088#1086#1083#1103' '#1086#1089#1090#1072#1090#1082#1072' '#1087#1086' '#1089#1077#1090#1080
            Options.Editing = False
            Width = 91
          end
        end
      end
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 219
    Top = 216
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 32
  end
  inherited ActionList: TActionList
    Left = 119
    Top = 191
    object actisPauseDistribListDiff: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      PostDataSetBeforeExecute = False
      StoredProc = spUnit_isPauseDistribListDiff
      StoredProcList = <
        item
          StoredProc = spUnit_isPauseDistribListDiff
        end>
      Caption = #1056#1072#1079#1088#1077#1096#1080#1090#1100' '#1079#1072#1082#1072#1079' '#1073#1077#1079' '#1082#1086#1085#1090#1088#1086#1083#1103' '#1086#1089#1090#1072#1090#1082#1072' '#1087#1086' '#1089#1077#1090#1080
      Hint = #1054#1089#1090#1072#1074#1080#1090#1100' '#1079#1072#1103#1074#1082#1091' '#1085#1072' '#1074#1086#1079#1084#1086#1078#1085#1086#1089#1090#1100' '#1079#1072#1082#1072#1079#1072' '#1073#1072#1079' '#1082#1086#1085#1090#1088#1086#1083#1103
      ImageIndex = 80
      QuestionBeforeExecute = #1056#1072#1079#1088#1077#1096#1080#1090#1100' '#1079#1072#1082#1072#1079' '#1073#1077#1079' '#1082#1086#1085#1090#1088#1086#1083#1103' '#1086#1089#1090#1072#1090#1082#1072' '#1087#1086' '#1089#1077#1090#1080'?'
    end
    object actShowAll: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndex = 63
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndexTrue = 62
      ImageIndexFalse = 63
    end
  end
  inherited MasterDS: TDataSource
    Left = 32
    Top = 184
  end
  inherited MasterCDS: TClientDataSet
    Left = 32
    Top = 104
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Unit_PauseDistribListDiff'
    Params = <
      item
        Name = 'inisShowAll'
        Value = Null
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 88
    Top = 104
  end
  inherited BarManager: TdxBarManager
    Left = 168
    Top = 104
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
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton3'
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
        end>
    end
    inherited bbRefresh: TdxBarButton
      Left = 280
    end
    inherited dxBarStatic: TdxBarStatic
      Left = 208
      Top = 65528
    end
    inherited bbGridToExcel: TdxBarButton
      Left = 232
    end
    object bbOpen: TdxBarButton
      Caption = #1054#1090#1082#1088#1099#1090#1100
      Category = 0
      Visible = ivAlways
      ImageIndex = 1
      Left = 160
    end
    object dxBarButton1: TdxBarButton
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1072#1083#1080#1095#1080#1077' '#1087#1086' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103#1084
      Category = 0
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1072#1083#1080#1095#1080#1077' '#1087#1086' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103#1084
      Visible = ivAlways
      ImageIndex = 28
      ShortCut = 13
    end
    object dxBarButton2: TdxBarButton
      Action = actisPauseDistribListDiff
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxBarButton3: TdxBarButton
      Action = actShowAll
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnDblClickActionList = <
      item
      end>
    Left = 368
    Top = 208
  end
  object spUnit_isPauseDistribListDiff: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isPauseDistribListDiff'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPauseDistribListDiff'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isPauseDistribListDiff'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 368
    Top = 107
  end
end
