object ListFrame: TListFrame
  Left = 0
  Top = 0
  Width = 679
  Height = 479
  TabOrder = 0
  object GridPanel: TGridPanel
    Left = 0
    Top = 0
    Width = 679
    Height = 479
    Align = alClient
    BevelKind = bkTile
    BevelOuter = bvNone
    Caption = 'GridPanel'
    ColumnCollection = <
      item
        Value = 50.000000000000000000
      end
      item
        Value = 50.000000000000000000
      end>
    ControlCollection = <
      item
        Column = 1
        Control = lblSlave
        Row = 0
      end
      item
        Column = 0
        Control = lblMaster
        Row = 0
      end
      item
        Column = 0
        Control = dgMaster
        Row = 2
      end
      item
        Column = 1
        Control = dgSlave
        Row = 2
      end
      item
        Column = 0
        Control = edMasterSearch
        Row = 1
      end
      item
        Column = 1
        Control = edSlaveSearch
        Row = 1
      end>
    RowCollection = <
      item
        SizeStyle = ssAuto
        Value = 50.000000000000000000
      end
      item
        SizeStyle = ssAuto
        Value = 50.000000000000000000
      end
      item
        Value = 100.000000000000000000
      end>
    TabOrder = 0
    object lblSlave: TLabel
      Left = 337
      Top = 0
      Width = 48
      Height = 22
      Align = alTop
      Alignment = taCenter
      Caption = 'Slave'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -18
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblMaster: TLabel
      Left = 0
      Top = 0
      Width = 62
      Height = 22
      Align = alTop
      Alignment = taCenter
      Caption = 'Master'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -18
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object dgMaster: TDrawGrid
      Left = 0
      Top = 46
      Width = 337
      Height = 429
      Align = alClient
      ColCount = 6
      Ctl3D = True
      DefaultColWidth = 45
      DefaultRowHeight = 20
      DrawingStyle = gdsGradient
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goColSizing, goFixedColClick]
      ParentCtl3D = False
      ScrollBars = ssVertical
      TabOrder = 0
      ColWidths = (
        45
        108
        167
        96
        93
        45)
    end
    object dgSlave: TDrawGrid
      Left = 337
      Top = 46
      Width = 338
      Height = 429
      Align = alClient
      ColCount = 6
      Ctl3D = True
      DefaultColWidth = 45
      DefaultRowHeight = 20
      DrawingStyle = gdsGradient
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goColSizing, goFixedColClick]
      ParentCtl3D = False
      ScrollBars = ssVertical
      TabOrder = 1
      ColWidths = (
        45
        108
        167
        96
        93
        45)
    end
    object edMasterSearch: TEdit
      Left = 0
      Top = 22
      Width = 337
      Height = 24
      Align = alClient
      TabOrder = 2
      TextHint = 'Type search ...'
      OnChange = edMasterSearchChange
    end
    object edSlaveSearch: TEdit
      Left = 337
      Top = 22
      Width = 338
      Height = 24
      Align = alClient
      TabOrder = 3
      TextHint = 'Type search ...'
      OnChange = edMasterSearchChange
    end
  end
end
