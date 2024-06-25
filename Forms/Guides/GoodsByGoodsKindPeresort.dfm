inherited GoodsByGoodsKindPeresortForm: TGoodsByGoodsKindPeresortForm
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1056#1072#1079#1088#1077#1096#1077#1085#1085#1099#1077' '#1087#1077#1088#1077#1089#1086#1088#1090#1099' '#1090#1086#1074#1072#1088#1072'+'#1074#1080#1076' '#1090#1086#1074#1072#1088#1072'>'
  ClientHeight = 420
  ClientWidth = 1030
  ExplicitWidth = 1046
  ExplicitHeight = 459
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 1030
    Height = 394
    ExplicitWidth = 1030
    ExplicitHeight = 394
    ClientRectBottom = 394
    ClientRectRight = 1030
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1030
      ExplicitHeight = 394
      inherited cxGrid: TcxGrid
        Width = 1030
        Height = 394
        ExplicitWidth = 1030
        ExplicitHeight = 394
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.FooterSummaryItems = <
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = GoodsName_in
            end>
          OptionsData.Appending = True
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Inserting = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object GoodsGroupNameFull_in: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')  ('#1087#1077#1088#1077#1089#1086#1088#1090'. - '#1087#1088#1080#1093#1086#1076')'
            DataBinding.FieldName = 'GoodsGroupNameFull_in'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 132
          end
          object GoodsCode_in: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1090#1086#1074'. ('#1087#1077#1088#1077#1089#1086#1088#1090'. - '#1087#1088#1080#1093#1086#1076')'
            DataBinding.FieldName = 'GoodsCode_in'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object GoodsName_in: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088' ('#1087#1077#1088#1077#1089#1086#1088#1090'.- '#1087#1088#1080#1093#1086#1076')'
            DataBinding.FieldName = 'GoodsName_in'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actChoiceFormGoods_in
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 171
          end
          object GoodsKindName_in: TcxGridDBColumn
            Caption = #1042#1080#1076' ('#1087#1077#1088#1077#1089#1086#1088#1090'. - '#1087#1088#1080#1093#1086#1076')'
            DataBinding.FieldName = 'GoodsKindName_in'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actChoiceFormGoodsKind_in
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' ('#1087#1077#1088#1077#1089#1086#1088#1090#1080#1094#1072'-'#1087#1088#1080#1093#1086#1076')'
            Width = 70
          end
          object MeasureName_in: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.  ('#1087#1077#1088#1077#1089#1086#1088#1090'. - '#1087#1088#1080#1093#1086#1076')'
            DataBinding.FieldName = 'MeasureName_in'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1045#1076'. '#1080#1079#1084'.  ('#1087#1077#1088#1077#1089#1086#1088#1090#1080#1094#1072' - '#1087#1088#1080#1093#1086#1076')'
            Options.Editing = False
            Width = 102
          end
          object Weight: TcxGridDBColumn
            Caption = #1042#1077#1089' ('#1087#1077#1088#1077#1089#1086#1088#1090'. - '#1087#1088#1080#1093#1086#1076')'
            DataBinding.FieldName = 'Weight_in'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1077#1089' '#1090#1086#1074#1072#1088#1072
            Options.Editing = False
            Width = 81
          end
          object GoodsCode_out: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1090#1086#1074'. ('#1087#1077#1088#1077#1089#1086#1088#1090'. - '#1088#1072#1089#1093#1086#1076')'
            DataBinding.FieldName = 'GoodsCode_out'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1076' '#1090#1086#1074#1072#1088#1072' ('#1087#1077#1088#1077#1089#1086#1088#1090#1080#1094#1072'-'#1088#1072#1089#1093#1086#1076')'
            Options.Editing = False
            Width = 79
          end
          object GoodsGroupNameFull_out: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')  ('#1087#1077#1088#1077#1089#1086#1088#1090'. - '#1087#1088#1080#1093#1086#1076')'
            DataBinding.FieldName = 'GoodsGroupNameFull_out'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 132
          end
          object GoodsName_out: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088' ('#1087#1077#1088#1077#1089#1086#1088#1090'. - '#1088#1072#1089#1093#1086#1076')'
            DataBinding.FieldName = 'GoodsName_out'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actChoiceFormGoods_out
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 155
          end
          object GoodsKindName_out: TcxGridDBColumn
            Caption = #1042#1080#1076' ('#1087#1077#1088#1077#1089#1086#1088#1090'. - '#1088#1072#1089#1093#1086#1076')'
            DataBinding.FieldName = 'GoodsKindName_out'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actChoiceFormGoodsKind_out
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' ('#1087#1077#1088#1077#1089#1086#1088#1090#1080#1094#1072'-'#1088#1072#1089#1093#1086#1076')'
            Width = 70
          end
          object MeasureName_out: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.  ('#1087#1077#1088#1077#1089#1086#1088#1090'. - '#1088#1072#1089#1093#1086#1076')'
            DataBinding.FieldName = 'MeasureName_out'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1076#1083#1103' '#1090#1086#1074#1072#1088#1072' ('#1087#1077#1088#1077#1089#1086#1088#1090'.-'#1088#1072#1089#1093#1086#1076')'
            Options.Editing = False
            Width = 62
          end
          object Weight_out: TcxGridDBColumn
            Caption = #1042#1077#1089' ('#1087#1077#1088#1077#1089#1086#1088#1090'. - '#1088#1072#1089#1093#1086#1076')'
            DataBinding.FieldName = 'WeightTotal'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 61
          end
          object InfoMoneyCode_in: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1059#1055'  ('#1087#1077#1088#1077#1089#1086#1088#1090'. - '#1087#1088#1080#1093#1086#1076')'
            DataBinding.FieldName = 'InfoMoneyCode_in'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 95
          end
          object InfoMoneyGroupName_in: TcxGridDBColumn
            Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103'  ('#1087#1077#1088#1077#1089#1086#1088#1090'. - '#1087#1088#1080#1093#1086#1076')'
            DataBinding.FieldName = 'InfoMoneyGroupName_in'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object InfoMoneyDestinationName_in: TcxGridDBColumn
            Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077'  ('#1087#1077#1088#1077#1089#1086#1088#1090'. - '#1087#1088#1080#1093#1086#1076')'
            DataBinding.FieldName = 'InfoMoneyDestinationName_in'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object InfoMoneyName_in: TcxGridDBColumn
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103'  ('#1087#1077#1088#1077#1089#1086#1088#1090'. - '#1087#1088#1080#1093#1086#1076')'
            DataBinding.FieldName = 'InfoMoneyName_in'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 138
          end
          object InfoMoneyCode_out: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1059#1055' ('#1087#1077#1088#1077#1089#1086#1088#1090'. - '#1088#1072#1089#1093#1086#1076')'
            DataBinding.FieldName = 'InfoMoneyCode_out'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 95
          end
          object InfoMoneyGroupName_out: TcxGridDBColumn
            Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103' ('#1087#1077#1088#1077#1089#1086#1088#1090'. - '#1088#1072#1089#1093#1086#1076')'
            DataBinding.FieldName = 'InfoMoneyGroupName_out'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object InfoMoneyDestinationName_out: TcxGridDBColumn
            Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077' ('#1087#1077#1088#1077#1089#1086#1088#1090'. - '#1088#1072#1089#1093#1086#1076')'
            DataBinding.FieldName = 'InfoMoneyDestinationName_out'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object InfoMoneyName_out: TcxGridDBColumn
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103' ('#1087#1077#1088#1077#1089#1086#1088#1090'. - '#1088#1072#1089#1093#1086#1076')'
            DataBinding.FieldName = 'InfoMoneyName_out'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 138
          end
          object IsErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            PropertiesClassName = 'TcxCheckBoxProperties'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 40
          end
        end
      end
    end
  end
  inherited ActionList: TActionList
    inherited ChoiceGuides: TdsdChoiceGuides
      Params = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Code'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Value = Null
          ParamType = ptUnknown
          MultiSelectSeparator = ','
        end
        item
          Value = Null
          DataType = ftString
          ParamType = ptUnknown
          MultiSelectSeparator = ','
        end>
    end
    object actUpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end
        item
        end>
      Caption = 'actUpdateDataSet'
      DataSource = MasterDS
    end
    object actChoiceFormGoods_in: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'Goods_ObjectForm'
      FormName = 'TGoods_ObjectForm'
      FormNameParam.Value = 'TGoods_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId_in'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName_in'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsCode_in'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MeasureName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MeasureName_in'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actChoiceFormGoodsKind_in: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'Goods_ObjectForm'
      FormName = 'TGoodsKindForm'
      FormNameParam.Value = 'TGoodsKindForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindId_in'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindName_in'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actChoiceFormGoods_out: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'Goods_ObjectForm'
      FormName = 'TGoods_ObjectForm'
      FormNameParam.Value = 'TGoods_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId_out'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName_out'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsCode_out'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MeasureName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MeasureName_out'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actChoiceFormGoodsKind_out: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'Goods_ObjectForm'
      FormName = 'TGoodsKindForm'
      FormNameParam.Value = 'TGoodsKindForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindId_out'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindName_out'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object ProtocolOpenForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072
      ImageIndex = 34
      FormName = 'TProtocolForm'
      FormNameParam.Value = 'TProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName_in'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object InsertRecord: TInsertRecord
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableView
      Action = actChoiceFormGoods_in
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1057#1074#1103#1079#1100'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1057#1074#1103#1079#1100'>'
      ImageIndex = 0
    end
    object actSetErased: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedUnErased
      StoredProcList = <
        item
          StoredProc = spErasedUnErased
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = MasterDS
    end
    object actSetUnErased: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedUnErased
      StoredProcList = <
        item
          StoredProc = spErasedUnErased
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 32776
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = MasterDS
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
    object actDoLoad: TExecuteImportSettingsAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ImportSettingsId.Value = Null
      ImportSettingsId.Component = FormParams
      ImportSettingsId.ComponentItem = 'ImportSettingId'
      ImportSettingsId.MultiSelectSeparator = ','
      ExternalParams = <>
    end
    object actGetImportSetting: TdsdExecStoredProc
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSettingId
      StoredProcList = <
        item
          StoredProc = spGetImportSettingId
        end>
      Caption = 'actGetImportSetting'
      Hint = 
        #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1058#1086#1074#1072#1088' ('#1087#1077#1088#1077#1089#1086#1088#1090'. '#1085#1072' '#1092#1080#1083'.- '#1088#1072#1089#1093#1086#1076') '#1080'  '#1042#1080#1076' '#1090'.('#1087#1077#1088#1077#1084'. '#1087#1077#1088 +
        #1077#1089#1086#1088#1090'. '#1085#1072' '#1092#1080#1083'.- '#1088#1072#1089#1093#1086#1076') '#1080#1079' '#1092#1072#1081#1083#1072
    end
    object macStartLoad: TMultiAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      TabSheet = tsMain
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSetting
        end
        item
          Action = actDoLoad
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1056#1072#1079#1088#1077#1096#1077#1085#1085#1099#1077' '#1087#1077#1088#1077#1089#1086#1088#1090#1099' '#1090#1086#1074#1072#1088#1072'+'#1074#1080#1076' '#1090#1086#1074#1072#1088#1072' '#1080#1079' '#1092#1072#1081#1083#1072'?'
      InfoAfterExecute = #1047#1072#1075#1088#1091#1079#1082#1072' '#1079#1072#1074#1077#1088#1096#1077#1085#1072
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1056#1072#1079#1088#1077#1096#1077#1085#1085#1099#1077' '#1087#1077#1088#1077#1089#1086#1088#1090#1099' '#1090#1086#1074#1072#1088#1072'+'#1074#1080#1076' '#1090#1086#1074#1072#1088#1072' '#1080#1079' '#1092#1072#1081#1083#1072
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1056#1072#1079#1088#1077#1096#1077#1085#1085#1099#1077' '#1087#1077#1088#1077#1089#1086#1088#1090#1099' '#1090#1086#1074#1072#1088#1072'+'#1074#1080#1076' '#1090#1086#1074#1072#1088#1072' '#1080#1079' '#1092#1072#1081#1083#1072
      ImageIndex = 41
      WithoutNext = True
    end
  end
  inherited MasterDS: TDataSource
    Left = 88
    Top = 104
  end
  inherited MasterCDS: TClientDataSet
    Left = 32
    Top = 104
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_GoodsByGoodsKindPeresort'
    Params = <
      item
        Name = 'inShowAll'
        Value = Null
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 200
    Top = 112
  end
  inherited BarManager: TdxBarManager
    Left = 48
    Top = 168
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbInsertRecord'
        end
        item
          Visible = True
          ItemName = 'bbSetErased'
        end
        item
          Visible = True
          ItemName = 'bbSetUnErased'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbShowAll'
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
          ItemName = 'bbStartLoad'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbProtocol'
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
    inherited dxBarStatic: TdxBarStatic
      ShowCaption = False
    end
    object bbInsertRecord: TdxBarButton
      Action = InsertRecord
      Category = 0
    end
    object bbProtocol: TdxBarButton
      Action = ProtocolOpenForm
      Category = 0
    end
    object bbStartLoad: TdxBarButton
      Action = macStartLoad
      Category = 0
    end
    object bbSetErased: TdxBarButton
      Action = actSetErased
      Category = 0
    end
    object bbSetUnErased: TdxBarButton
      Action = actSetUnErased
      Category = 0
    end
    object bbShowAll: TdxBarButton
      Action = actShowAll
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 200
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_GoodsByGoodsKindPeresort'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId_in'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId_in'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindId_in'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindId_in'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId_out'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId_out'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindId_out'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindId_out'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 304
    Top = 112
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'ImportSettingId'
        Value = Null
        MultiSelectSeparator = ','
      end>
    Left = 664
    Top = 136
  end
  object spGetImportSettingId: TdsdStoredProc
    StoredProcName = 'gpGet_DefaultValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inDefaultKey'
        Value = 
          'TGoodsByGoodsKindPeresortForm;zc_Object_ImportSetting_GoodsByGoo' +
          'dsKindPeresort'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserKeyId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'gpGet_DefaultValue'
        Value = Null
        Component = FormParams
        ComponentItem = 'ImportSettingId'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 840
    Top = 144
  end
  object spErasedUnErased: TdsdStoredProc
    StoredProcName = 'gpUpdateObjectIsErased'
    DataSet = MasterCDS
    DataSets = <
      item
        DataSet = MasterCDS
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 200
    Top = 184
  end
end
