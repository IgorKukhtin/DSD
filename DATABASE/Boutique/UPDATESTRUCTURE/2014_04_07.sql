 -- Добавить у проводок тип документа
DO $$ 
    BEGIN
      IF NOT (EXISTS(Select table_name From INFORMATION_SCHEMA.tables Where Table_Name = lower('ContainerKey'))) THEN
          CREATE TABLE ContainerKey(
                 ContainerId           INTEGER NOT NULL, 
                 Key                   TVarChar NOT NULL, 

                 CONSTRAINT pk_ContainerKey             PRIMARY KEY (ContainerId),
                 CONSTRAINT fk_ContainerKey_ContainerId FOREIGN KEY(ContainerId) REFERENCES Container(Id)
               );


          CREATE UNIQUE INDEX idx_ContainerKey_Key_ContainerId ON ContainerKey (Key, ContainerId);

          INSERT INTO containerkey(KEY , containerid)
               SELECT containerdescid::TEXT||';'||containerobjectid::TEXT||';'||STRING_AGG(objectid::text, ';'), Id FROM 
                   (SELECT containerlinkobject.objectid, container.id, containerlinkobject.descid, container.objectid AS containerobjectid, container.descid AS containerdescid
                      FROM container 
                 LEFT JOIN containerlinkobject ON containerlinkobject.containerid = container.id
                  ORDER BY container.id, containerlinkobject.descid) AS dd
                  GROUP BY id, containerdescid, containerobjectid;

      END IF;
      IF NOT (EXISTS(Select table_name From INFORMATION_SCHEMA.tables Where Table_Name = lower('UserProtocol'))) THEN
          CREATE TABLE ObjectCostKey(
                 ObjectCostId          INTEGER  NOT NULL,
                 Key                   TVarChar NOT NULL, 

                 CONSTRAINT pk_ObjectCostKey                     PRIMARY KEY (ObjectCostId)
               );

          CREATE INDEX idx_ObjectCostKey_Key_ObjectCostId  ON ObjectCostKey (Key, ObjectCostId);

      END IF;
    END;
$$;