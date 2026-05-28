DO $$ 
BEGIN

      IF NOT (EXISTS (SELECT table_name FROM INFORMATION_SCHEMA.tables WHERE table_name = lower ('MI_PartionCell'))) 
      THEN
           -- drop TABLE MI_PartionCell;
           CREATE TABLE MI_PartionCell (
              Id                    BIGSERIAL NOT NULL, 
              MovementId            Integer,
              MovementItemId        Integer,
              DescId_MILO           Integer,
              PartionCellId         Integer,
              UserId                Integer,
              OperDate              TDateTime
             );

           CREATE UNIQUE INDEX idx_MI_PartionCell_MovementItemId_DescId_MILO ON MI_PartionCell (MovementItemId, DescId_MILO);
           CREATE INDEX idx_MI_PartionCell_PartionCellId ON MI_PartionCell (PartionCellId);
      END IF;

END;
$$;

