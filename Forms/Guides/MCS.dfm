inherited MCSForm: TMCSForm
  Caption = #1053#1077#1089#1085#1080#1078#1072#1077#1084#1099#1081' '#1090#1086#1074#1072#1088#1085#1099#1081' '#1079#1072#1087#1072#1089
  ClientHeight = 419
  ClientWidth = 758
  AddOnFormData.RefreshAction = actRefreshStart
  ExplicitWidth = 774
  ExplicitHeight = 457
  PixelsPerInch = 96
  TextHeight = 13
  inherited Panel: TPanel
    Width = 758
    ExplicitWidth = 758
  end
  inherited PageControl: TcxPageControl
    Width = 758
    Height = 336
    TabOrder = 2
    ExplicitWidth = 758
    ExplicitHeight = 336
    ClientRectBottom = 336
    ClientRectRight = 758
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 758
      ExplicitHeight = 336
      inherited cxGrid: TcxGrid
        Width = 758
        Height = 336
        ExplicitWidth = 758
        ExplicitHeight = 336
        inherited cxGridDBTableView: TcxGridDBTableView
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          inherited DateChange: TcxGridDBColumn
            Visible = False
          end
          inherited Price: TcxGridDBColumn
            Visible = False
            Options.Editing = False
          end
          inherited Fix: TcxGridDBColumn
            Options.Editing = False
          end
        end
      end
    end
  end
  inherited ceUnit: TcxButtonEdit
    Enabled = False
    TabOrder = 4
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = PriceForm.Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end
      item
        Component = UnitGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end>
  end
  inherited ActionList: TActionList
    inherited actStartLoadPrice: TMultiAction
      Enabled = False
    end
    object actGet_UserUnit: TdsdExecStoredProc [12]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_UserUnit
      StoredProcList = <
        item
          StoredProc = spGet_UserUnit
        end>
      Caption = 'actGet_UserUnit'
    end
    object actRefreshStart: TdsdDataSetRefresh [13]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet_UserUnit
      StoredProcList = <
        item
          StoredProc = spGet_UserUnit
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    inherited actRecalcMCSDialog: TExecuteDialog
      FormName = ''
      FormNameParam.Value = ''
    end
  end
  inherited BarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      26
      0)
    inherited dxBarButton4: TdxBarButton
      Action = nil
      Enabled = False
      Visible = ivNever
    end
    inherited dxBarButton6: TdxBarButton
      Enabled = False
    end
  end
  inherited spInsertUpdate: TdsdStoredProc
    Left = 264
  end
  object spGet_UserUnit: TdsdStoredProc
    StoredProcName = 'gpGet_UserUnit'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'UnitId'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 432
    Top = 96
  end
end
