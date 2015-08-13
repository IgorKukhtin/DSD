inherited MCSForm: TMCSForm
  Caption = #1053#1077#1089#1085#1080#1078#1072#1077#1084#1099#1081' '#1090#1086#1074#1072#1088#1085#1099#1081' '#1079#1072#1087#1072#1089
  ClientWidth = 698
  AddOnFormData.RefreshAction = actRefreshStart
  ExplicitWidth = 706
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 698
    TabOrder = 3
    ClientRectRight = 698
    inherited tsMain: TcxTabSheet
      inherited cxGrid: TcxGrid
        Width = 698
        inherited cxGridDBTableView: TcxGridDBTableView
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          inherited clPrice: TcxGridDBColumn
            Visible = False
            Options.Editing = False
          end
          inherited clDateChange: TcxGridDBColumn
            Visible = False
          end
        end
      end
    end
  end
  inherited ceUnit: TcxButtonEdit
    Left = 374
    Top = 80
    Enabled = False
    ExplicitLeft = 374
    ExplicitTop = 80
  end
  inherited ActionList: TActionList
    inherited actStartLoadPrice: TMultiAction
      Enabled = False
    end
    object actGet_UserUnit: TdsdExecStoredProc
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
    object actRefreshStart: TdsdDataSetRefresh
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
  end
  inherited BarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      26
      0)
    inherited dxBarButton4: TdxBarButton
      Action = nil
      Visible = ivNever
    end
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
      end
      item
        Name = 'UnitName'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    PackSize = 1
    Left = 432
    Top = 96
  end
end
