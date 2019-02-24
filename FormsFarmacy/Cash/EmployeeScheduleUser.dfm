inherited EmployeeScheduleUserForm: TEmployeeScheduleUserForm
  Caption = #1047#1072#1087#1086#1083#1085#1077#1085#1080#1077' '#1074#1088#1077#1084#1077#1085#1080' '#1087#1088#1080#1093#1086#1076#1072' '#1085#1072' '#1088#1072#1073#1086#1090#1091' '#1089#1086#1075#1083#1072#1089#1085#1086' '#1075#1088#1072#1092#1080#1082#1072
  ClientHeight = 423
  ClientWidth = 525
  AddOnFormData.isSingle = False
  AddOnFormData.Params = FormParams
  ExplicitWidth = 541
  ExplicitHeight = 462
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 75
    Width = 525
    Height = 348
    TabOrder = 5
    ExplicitTop = 75
    ExplicitWidth = 525
    ExplicitHeight = 348
    ClientRectBottom = 348
    ClientRectRight = 525
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 525
      ExplicitHeight = 348
      inherited cxGrid: TcxGrid
        Width = 525
        Height = 348
        ExplicitWidth = 525
        ExplicitHeight = 348
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsView.Footer = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
        end
        object cxGridDBBandedTableView1: TcxGridDBBandedTableView [1]
          Navigator.Buttons.CustomButtons = <>
          Navigator.Buttons.First.Visible = True
          Navigator.Buttons.PriorPage.Visible = True
          Navigator.Buttons.Prior.Visible = True
          Navigator.Buttons.Next.Visible = True
          Navigator.Buttons.NextPage.Visible = True
          Navigator.Buttons.Last.Visible = True
          Navigator.Buttons.Insert.Visible = True
          Navigator.Buttons.Append.Visible = False
          Navigator.Buttons.Delete.Visible = True
          Navigator.Buttons.Edit.Visible = True
          Navigator.Buttons.Post.Visible = True
          Navigator.Buttons.Cancel.Visible = True
          Navigator.Buttons.Refresh.Visible = True
          Navigator.Buttons.SaveBookmark.Visible = True
          Navigator.Buttons.GotoBookmark.Visible = True
          Navigator.Buttons.Filter.Visible = True
          DataController.DataSource = MasterDS
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          OptionsSelection.CellSelect = False
          OptionsView.GroupByBox = False
          Styles.Content = dmMain.cxContentStyle
          Styles.Inactive = dmMain.cxSelection
          Styles.Selection = dmMain.cxSelection
          Styles.Header = dmMain.cxContentStyle
          Bands = <
            item
              Width = 106
            end
            item
              Caption = #1044#1085#1080' '#1085#1077#1076#1077#1083#1080
              Width = 383
            end>
          object Range: TcxGridDBBandedColumn
            Caption = #1055#1077#1088#1080#1086#1076
            DataBinding.FieldName = 'Range'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Position.BandIndex = 0
            Position.ColIndex = 0
            Position.RowIndex = 0
          end
          object Value1: TcxGridDBBandedColumn
            Caption = #1055#1085
            DataBinding.FieldName = 'Value1'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 65
            Position.BandIndex = 1
            Position.ColIndex = 0
            Position.RowIndex = 0
          end
          object Value2: TcxGridDBBandedColumn
            Caption = #1042#1090
            DataBinding.FieldName = 'Value2'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 65
            Position.BandIndex = 1
            Position.ColIndex = 1
            Position.RowIndex = 0
          end
          object Value3: TcxGridDBBandedColumn
            Caption = #1057#1088
            DataBinding.FieldName = 'Value3'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 65
            Position.BandIndex = 1
            Position.ColIndex = 2
            Position.RowIndex = 0
          end
          object Value4: TcxGridDBBandedColumn
            Caption = #1063#1090
            DataBinding.FieldName = 'Value4'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 65
            Position.BandIndex = 1
            Position.ColIndex = 3
            Position.RowIndex = 0
          end
          object Value5: TcxGridDBBandedColumn
            Caption = #1055#1090
            DataBinding.FieldName = 'Value5'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 65
            Position.BandIndex = 1
            Position.ColIndex = 4
            Position.RowIndex = 0
          end
          object Value6: TcxGridDBBandedColumn
            Caption = #1057#1073
            DataBinding.FieldName = 'Value6'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 65
            Position.BandIndex = 1
            Position.ColIndex = 5
            Position.RowIndex = 0
          end
          object Value7: TcxGridDBBandedColumn
            Caption = #1042#1089
            DataBinding.FieldName = 'Value7'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 65
            Position.BandIndex = 1
            Position.ColIndex = 6
            Position.RowIndex = 0
          end
          object ValuePlan1: TcxGridDBBandedColumn
            DataBinding.FieldName = 'ValuePlan1'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 65
            Position.BandIndex = 1
            Position.ColIndex = 0
            Position.RowIndex = 1
            IsCaptionAssigned = True
          end
          object ValuePlan2: TcxGridDBBandedColumn
            DataBinding.FieldName = 'ValuePlan2'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 65
            Position.BandIndex = 1
            Position.ColIndex = 2
            Position.RowIndex = 1
            IsCaptionAssigned = True
          end
          object ValuePlan3: TcxGridDBBandedColumn
            DataBinding.FieldName = 'ValuePlan3'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 65
            Position.BandIndex = 1
            Position.ColIndex = 1
            Position.RowIndex = 1
            IsCaptionAssigned = True
          end
          object ValuePlan4: TcxGridDBBandedColumn
            DataBinding.FieldName = 'ValuePlan4'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 65
            Position.BandIndex = 1
            Position.ColIndex = 3
            Position.RowIndex = 1
            IsCaptionAssigned = True
          end
          object ValuePlan5: TcxGridDBBandedColumn
            DataBinding.FieldName = 'ValuePlan5'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 65
            Position.BandIndex = 1
            Position.ColIndex = 4
            Position.RowIndex = 1
            IsCaptionAssigned = True
          end
          object ValuePlan6: TcxGridDBBandedColumn
            DataBinding.FieldName = 'ValuePlan6'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 65
            Position.BandIndex = 1
            Position.ColIndex = 5
            Position.RowIndex = 1
            IsCaptionAssigned = True
          end
          object ValuePlan7: TcxGridDBBandedColumn
            DataBinding.FieldName = 'ValuePlan7'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 65
            Position.BandIndex = 1
            Position.ColIndex = 6
            Position.RowIndex = 1
            IsCaptionAssigned = True
          end
          object Color1: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color1'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Position.BandIndex = 1
            Position.ColIndex = 7
            Position.RowIndex = 0
          end
          object Color2: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color2'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Position.BandIndex = 1
            Position.ColIndex = 8
            Position.RowIndex = 0
          end
          object Color3: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color3'
            Visible = False
            Options.Editing = False
            Position.BandIndex = 1
            Position.ColIndex = 9
            Position.RowIndex = 0
          end
          object Color4: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color4'
            Visible = False
            Options.Editing = False
            Position.BandIndex = 1
            Position.ColIndex = 10
            Position.RowIndex = 0
          end
          object Color5: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color5'
            Visible = False
            Options.Editing = False
            Position.BandIndex = 1
            Position.ColIndex = 11
            Position.RowIndex = 0
          end
          object Color6: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color6'
            Visible = False
            Options.Editing = False
            Position.BandIndex = 1
            Position.ColIndex = 12
            Position.RowIndex = 0
          end
          object Color7: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color7'
            Visible = False
            Options.Editing = False
            Position.BandIndex = 1
            Position.ColIndex = 13
            Position.RowIndex = 0
          end
        end
        inherited cxGridLevel: TcxGridLevel
          GridView = cxGridDBBandedTableView1
        end
      end
    end
  end
  object Panel: TPanel [1]
    Left = 0
    Top = 0
    Width = 525
    Height = 49
    Align = alTop
    ShowCaption = False
    TabOrder = 0
    object edOperDate: TcxDateEdit
      Left = 79
      Top = 15
      TabStop = False
      EditValue = 42132d
      Properties.DisplayFormat = 'dd.mm.yyyy'
      Properties.EditFormat = 'dd.mm.yyyy'
      Properties.ReadOnly = True
      TabOrder = 1
      Width = 100
    end
    object cxLabel2: TcxLabel
      Left = 26
      Top = 16
      Caption = #1057#1077#1075#1086#1076#1085#1103
    end
    object cxLabel1: TcxLabel
      Left = 194
      Top = 16
      Caption = #1042#1088#1077#1084#1103' '#1087#1088#1080#1093#1086#1076#1072' '#1089#1086#1075#1083#1072#1089#1085#1086' '#1075#1088#1072#1092#1080#1082#1072
    end
    object cbValueUser: TcxComboBox
      Left = 384
      Top = 15
      Properties.Items.Strings = (
        ''
        '8:00'
        '9:00'
        '10:00'
        '21:00'
        #1042)
      TabOrder = 0
      Text = 'cbValueUser'
      Width = 121
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 243
    Top = 256
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 32
  end
  inherited ActionList: TActionList
    Left = 119
    Top = 191
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spGet
        end>
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
    StoredProcName = 'gpSelect_MovementItem_EmployeeSchedule_User'
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
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    View = cxGridDBBandedTableView1
    ColorRuleList = <
      item
        ColorColumn = Value1
        BackGroundValueColumn = Color1
        ColorValueList = <>
      end
      item
        ColorColumn = Value2
        BackGroundValueColumn = Color2
        ColorValueList = <>
      end
      item
        ColorColumn = Value3
        BackGroundValueColumn = Color3
        ColorValueList = <>
      end
      item
        ColorColumn = Value4
        BackGroundValueColumn = Color4
        ColorValueList = <>
      end
      item
        ColorColumn = Value5
        BackGroundValueColumn = Color5
        ColorValueList = <>
      end
      item
        ColorColumn = Value6
        BackGroundValueColumn = Color6
        ColorValueList = <>
      end
      item
        ColorColumn = Value7
        BackGroundValueColumn = Color7
        ColorValueList = <>
      end
      item
        ColorColumn = ValuePlan1
        BackGroundValueColumn = Color1
        ColorValueList = <>
      end
      item
        ColorColumn = ValuePlan2
        BackGroundValueColumn = Color2
        ColorValueList = <>
      end
      item
        ColorColumn = ValuePlan3
        BackGroundValueColumn = Color3
        ColorValueList = <>
      end
      item
        ColorColumn = ValuePlan4
        BackGroundValueColumn = Color4
        ColorValueList = <>
      end
      item
        ColorColumn = ValuePlan5
        BackGroundValueColumn = Color5
        ColorValueList = <>
      end
      item
        ColorColumn = ValuePlan6
        BackGroundValueColumn = Color6
        ColorValueList = <>
      end
      item
        ColorColumn = ValuePlan7
        BackGroundValueColumn = Color7
        ColorValueList = <>
      end>
    KeepSelectColor = True
    Left = 352
    Top = 256
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = '1'
        MultiSelectSeparator = ','
      end>
    Left = 256
    Top = 104
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_MovementItem_EmployeeSchedule_User'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'OperDate'
        Value = 'NULL'
        Component = edOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'ValueUser'
        Value = Null
        Component = cbValueUser
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 344
    Top = 144
  end
  object spUpdateEmployeeScheduleUser: TdsdStoredProc
    StoredProcName = 'gpUpdate_MovementItem_EmployeeSchedule_User'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inOperDate'
        Value = 'NULL'
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValueUser'
        Value = ''
        Component = cbValueUser
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    NeedResetData = True
    ParamKeyField = 'ioId'
    Left = 346
    Top = 200
  end
  object HeaderSaver: THeaderSaver
    IdParam.Value = Null
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    IdParam.MultiSelectSeparator = ','
    StoredProc = spUpdateEmployeeScheduleUser
    ControlList = <
      item
        Control = cbValueUser
      end>
    GetStoredProc = spGet
    ActionAfterExecute = actRefresh
    Left = 424
    Top = 145
  end
end
