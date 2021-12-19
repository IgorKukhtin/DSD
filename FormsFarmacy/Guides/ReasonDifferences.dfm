inherited ReasonDifferencesForm: TReasonDifferencesForm
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1055#1088#1080#1095#1080#1085#1099' '#1088#1072#1079#1085#1086#1075#1083#1072#1089#1080#1103'>'
  ClientWidth = 471
  AddOnFormData.ChoiceAction = dsdChoiceGuides
  ExplicitWidth = 487
  ExplicitHeight = 347
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 471
    ExplicitWidth = 471
    ClientRectRight = 471
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 471
      inherited cxGrid: TcxGrid
        Width = 471
        ExplicitWidth = 471
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsData.Appending = True
          OptionsData.Inserting = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object Code: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'Code'
            Width = 46
          end
          object Name: TcxGridDBColumn
            Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'Name'
            Width = 275
          end
          object isDeficit: TcxGridDBColumn
            Caption = #1053#1077#1076#1086#1074#1086#1079
            DataBinding.FieldName = 'isDeficit'
            HeaderHint = #1053#1077#1076#1086#1089#1090#1072#1095#1072
            Width = 62
          end
          object isSurplus: TcxGridDBColumn
            Caption = #1048#1079#1083#1080#1096#1077#1082
            DataBinding.FieldName = 'isSurplus'
            HeaderHint = #1053#1077#1082#1086#1085#1076#1080#1094#1080#1103
            Width = 61
          end
          object isErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            Visible = False
            Width = 57
          end
        end
      end
    end
  end
  inherited ActionList: TActionList
    inherited actRefresh: TdsdDataSetRefresh
      AfterAction = actSetVisibleAction
      StoredProc = spGet_Visible
      StoredProcList = <
        item
          StoredProc = spGet_Visible
        end
        item
          StoredProc = spSelect
        end>
    end
    inherited dsdChoiceGuides: TdsdChoiceGuides
      Params = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Name'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Code'
          MultiSelectSeparator = ','
        end>
    end
    object actShowDel: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      ImageIndex = 64
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      ImageIndexTrue = 65
      ImageIndexFalse = 64
    end
    object actUpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate_Object_ReasonDifferences
      StoredProcList = <
        item
          StoredProc = spInsertUpdate_Object_ReasonDifferences
        end>
      Caption = 'actUpdateDataSet'
      DataSource = MasterDS
    end
    object actSetVisibleAction: TdsdSetVisibleAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actSetVisibleAction'
      SetVisibleParams = <
        item
          Component = isDeficit
          ValueParam.Value = Null
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'Visible'
          ValueParam.DataType = ftBoolean
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = isSurplus
          ValueParam.Value = Null
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'Visible'
          ValueParam.DataType = ftBoolean
          ValueParam.MultiSelectSeparator = ','
        end>
    end
  end
  inherited MasterDS: TDataSource
    Top = 88
  end
  inherited MasterCDS: TClientDataSet
    Top = 88
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_ReasonDifferences'
    Params = <
      item
        Name = 'inShowDel'
        Value = Null
        Component = actShowDel
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Top = 88
  end
  inherited BarManager: TdxBarManager
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
          ItemName = 'bbInsert'
        end
        item
          Visible = True
          ItemName = 'bbEdit'
        end
        item
          Visible = True
          ItemName = 'bbErased'
        end
        item
          Visible = True
          ItemName = 'bbUnErased'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarButton1'
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
          ItemName = 'bbGridToExcel'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbProtocolOpenForm'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbChoiceGuides'
        end>
    end
    inherited bbInsert: TdxBarButton
      Visible = ivNever
    end
    inherited bbEdit: TdxBarButton
      Visible = ivNever
    end
    object dxBarButton1: TdxBarButton
      Action = actShowDel
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 296
    Top = 200
  end
  inherited spErasedUnErased: TdsdStoredProc
    DataSet = MasterCDS
    DataSets = <
      item
        DataSet = MasterCDS
      end>
    Left = 80
    Top = 144
  end
  object spInsertUpdate_Object_ReasonDifferences: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_ReasonDifferences'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioCode'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Code'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Name'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDeficit'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isDeficit'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSurplus'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSurplus'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 240
    Top = 144
  end
  object spGet_Visible: TdsdStoredProc
    StoredProcName = 'gpGet_Object_ReasonDifferences_Visible'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'outVisible'
        Value = Null
        Component = FormParams
        ComponentItem = 'Visible'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 216
    Top = 88
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Visible'
        Value = Null
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    Left = 320
    Top = 96
  end
end
