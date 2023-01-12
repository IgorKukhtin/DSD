inherited Report_Movement_WagesVIP_CalcMonthForm: TReport_Movement_WagesVIP_CalcMonthForm
  Caption = #1055#1086#1076#1088#1086#1073#1085#1086' '#1087#1086' '#1076#1085#1103#1084' '#1047'/'#1055' VIP '#1084#1077#1085#1077#1076#1078#1077#1088#1086#1074
  ClientHeight = 339
  ClientWidth = 825
  AddOnFormData.Params = FormParams
  ExplicitWidth = 843
  ExplicitHeight = 386
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 825
    Height = 312
    ExplicitTop = 27
    ExplicitWidth = 573
    ExplicitHeight = 312
    ClientRectBottom = 312
    ClientRectRight = 825
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 573
      ExplicitHeight = 312
      inherited cxGrid: TcxGrid
        Left = 3
        Width = 822
        Height = 312
        ExplicitLeft = 3
        ExplicitWidth = 570
        ExplicitHeight = 312
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = HoursWork
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = AmountAccrued
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = ApplicationAward
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = TotalAmount
            end>
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Inserting = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object OperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 83
          end
          object UserCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'UserCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object UserName: TcxGridDBColumn
            Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082
            DataBinding.FieldName = 'UserName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 165
          end
          object PayrollTypeVIPName: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1088#1072#1089#1095#1077#1090#1072
            DataBinding.FieldName = 'PayrollTypeVIPName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 129
          end
          object HoursWork: TcxGridDBColumn
            Caption = #1054#1090#1088#1072#1073#1086#1090#1072#1085#1086' '#1095#1072#1089#1086#1074
            DataBinding.FieldName = 'HoursWork'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 81
          end
          object AmountAccrued: TcxGridDBColumn
            Caption = #1053#1072#1095#1080#1089#1083#1077#1085#1086
            DataBinding.FieldName = 'AmountAccrued'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
          object ApplicationAward: TcxGridDBColumn
            Caption = #1055#1088#1077#1084#1080#1103' '#1079#1072' '#1087#1088#1080#1083#1086#1078#1077#1085#1080#1077
            DataBinding.FieldName = 'ApplicationAward'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
          object TotalAmount: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086
            DataBinding.FieldName = 'TotalAmount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
        end
      end
      object cxSplitter1: TcxSplitter
        Left = 0
        Top = 0
        Width = 3
        Height = 312
        Control = cxGrid
      end
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 99
    Top = 184
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = cxGrid
        Properties.Strings = (
          'Width')
      end>
  end
  inherited ActionList: TActionList
    object dsdUpdateMaster: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = 'dsdUpdate'
      DataSource = MasterDS
    end
    object dsdSetErased: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      StoredProcList = <
        item
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = MasterDS
      QuestionBeforeExecute = #1059#1076#1072#1083#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
    end
    object dsdUnErased: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <
        item
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 32776
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = MasterDS
    end
    object actOpenUnit: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actOpenUnit'
      FormName = 'TUnitTreeForm'
      FormNameParam.Value = 'TUnitTreeForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UnitId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UnitName'
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenUser: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actOpenUser'
      FormName = 'TUserNickForm'
      FormNameParam.Value = 'TUserNickForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UserId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UserName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
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
    Left = 104
    Top = 96
  end
  inherited MasterCDS: TClientDataSet
    FilterOptions = []
    Top = 96
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_Movement_WagesVIP_CalcMonthUser'
    Params = <
      item
        Name = 'inOperDate'
        Value = Null
        Component = FormParams
        ComponentItem = 'OperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 176
    Top = 96
  end
  inherited BarManager: TdxBarManager
    Left = 272
    Top = 96
    DockControlHeights = (
      0
      0
      27
      0)
    inherited Bar: TdxBar
      ItemLinks = <
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
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
    end
    inherited dxBarStatic: TdxBarStatic
      Left = 368
      Top = 112
    end
    object bbSetErased: TdxBarButton
      Action = dsdSetErased
      Category = 0
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1058#1080#1087' '#1080#1084#1087#1086#1088#1090#1072
    end
    object bbUnErased: TdxBarButton
      Action = dsdUnErased
      Category = 0
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1058#1080#1087' '#1080#1084#1087#1086#1088#1090#1072
    end
    object bbSetErasedChild: TdxBarButton
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088
      Category = 0
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      Visible = ivAlways
      ImageIndex = 2
      ShortCut = 46
    end
    object bbUnErasedChild: TdxBarButton
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088
      Category = 0
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      Visible = ivAlways
      ImageIndex = 8
      ShortCut = 32776
    end
    object bbdsdChoiceGuides: TdxBarButton
      Caption = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      Category = 0
      Hint = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      Visible = ivAlways
      ImageIndex = 7
    end
    object dxBarButton1: TdxBarButton
      Action = dsdUnErased
      Category = 0
    end
    object dxBarButton2: TdxBarButton
      Action = actShowAll
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 280
    Top = 192
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'OperDate'
        Value = Null
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    Left = 376
    Top = 96
  end
end
