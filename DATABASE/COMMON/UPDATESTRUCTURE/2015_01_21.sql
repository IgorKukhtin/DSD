-- Добавить для расчета с/с - возможные связи контейнеров (!!!надо что б не делать нулевые проводки!!!)
DO $$ 
    BEGIN
     
      IF NOT (EXISTS(Select table_name From INFORMATION_SCHEMA.tables Where Table_Name = lower ('HistoryCostContainerLink'))) THEN
         CREATE TABLE HistoryCostContainerLink
         (
          MasterContainerId_Count Integer NOT NULL,
          ChildContainerId_Count Integer NOT NULL,
          MasterContainerId_Summ Integer NOT NULL,
          ChildContainerId_Summ Integer NOT NULL,
          CONSTRAINT pk_HistoryCostContainerLink PRIMARY KEY (MasterContainerId_Count, ChildContainerId_Count, MasterContainerId_Summ, ChildContainerId_Summ)
         )
        WITH (
             OIDS=FALSE
         );
         ALTER TABLE HistoryCostContainerLink OWNER TO postgres;

         -- и еще индекс
         CREATE UNIQUE INDEX idx_HistoryCostContainerLink_Master_Child_Master_Child ON HistoryCostContainerLink (MasterContainerId_Count, ChildContainerId_Count,MasterContainerId_Summ, ChildContainerId_Summ);
         CREATE INDEX idx_HistoryCostContainerLink_Master_Child ON HistoryCostContainerLink (MasterContainerId_Count, ChildContainerId_Count);

      END IF;
    END;
$$;