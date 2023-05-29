/*
-- vacuum full MovementItemProtocol_arc;
-- vacuum ANALYZE MovementItemProtocol_arc;

-- select min (Id) , max (Id), count(*) from movementprotocol where Id < 409608474
-- select min (Id) , max (Id), count(*) from movementprotocol_arc where Id < 409608474
-- 
-- 

-- select  max (Id) from movementprotocol
-- select count(*) from movementprotocol where Id > 525891470

-- select last_value from movementitemprotocol_id_seq
-- select last_value from movementprotocol_id_seq

         insert into movementprotocol_arc
            select * from movementprotocol where Id >= 123
-- truncate table movementprotocol;

         insert into movementitemprotocol_arc
            select * from movementitemprotocol where Id >= 123
-- truncate table movementitemprotocol;

--       select max(Id), count(*) from movementprotocol 
--       insert into movementprotocol_arc
--          select * from movementprotocol order by Id limit 1000000;
         insert into movementprotocol_arc
            select * from movementprotocol where Id > (select max(Id) from movementprotocol_arc ) and Id < 12345 order by Id limit 2000000;

--       select max(Id), count(*) from movementitemprotocol 
--       insert into movementitemprotocol_arc
--          select * from movementitemprotocol order by Id limit 1000000;
         insert into movementitemprotocol_arc
            select * from movementitemprotocol where Id > (select max(Id) from movementitemprotocol_arc ) and Id < 12345 order by Id limit 2000000;

*/
-- 
DO $$ 
    BEGIN
     
      IF NOT (EXISTS(Select table_name From INFORMATION_SCHEMA.tables Where Table_Name = lower ('MovementItemProtocol_arc')))
      THEN
          CREATE TABLE MovementItemProtocol_arc(
             Id                    SERIAL NOT NULL PRIMARY KEY, 
             MovementItemId        INTEGER,
             UserId                INTEGER,
             OperDate              TDateTime,
             ProtocolData          TBlob, 
             isInsert              Boolean,
          
             CONSTRAINT fk_MovementItemProtocol_arc_MovementItemId FOREIGN KEY(MovementItemId) REFERENCES MovementItem(Id),
             CONSTRAINT fk_MovementItemProtocol_arc_UserId FOREIGN KEY(UserId) REFERENCES Object(Id)
          );
          ALTER TABLE MovementItemProtocol_arc OWNER TO postgres;

         -- и еще индекс
         CREATE INDEX idx_MovementItemProtocol_arc_MovementItemId ON MovementItemProtocol_arc (MovementItemId);
         CREATE INDEX idx_MovementItemProtocol_arc_UserId ON MovementItemProtocol_arc (UserId);
         CREATE INDEX idx_MovementItemProtocol_arc_OperDate ON MovementItemProtocol_arc (OperDate);

      END IF;


      IF NOT (EXISTS(Select table_name From INFORMATION_SCHEMA.tables Where Table_Name = lower ('MovementProtocol_arc')))
      THEN
          CREATE TABLE MovementProtocol_arc(
             Id                    SERIAL NOT NULL PRIMARY KEY, 
             MovementId            INTEGER,
             UserId                INTEGER,
             OperDate              TDateTime,
             ProtocolData          TBlob, 
             isInsert              Boolean,

             CONSTRAINT fk_MovementProtocol_arc_MovementId FOREIGN KEY(MovementId) REFERENCES Movement(Id),
             CONSTRAINT fk_MovementProtocol_arc_UserId FOREIGN KEY(UserId) REFERENCES Object(Id)
          );
          ALTER TABLE MovementProtocol_arc OWNER TO postgres;

         -- и еще индекс
         CREATE INDEX idx_MovementProtocol_arc_MovementId ON MovementProtocol_arc (MovementId);
         CREATE INDEX idx_MovementProtocol_arc_UserId ON MovementProtocol_arc (UserId);
         CREATE INDEX idx_MovementProtocol_arc_OperDate ON MovementProtocol_arc (OperDate);

      END IF;

    END;
$$;
/*
DO $$ 
    DECLARE vbTmp Integer;
    BEGIN
            -- select 1, count(*), min (OperDate), max (OperDate) from movementprotocol_arc union all select 2, count(*), min (OperDate), max (OperDate) from movementitemprotocol_arc;
            -- select 1, count(*), min (OperDate), max (OperDate) from movementprotocol union all select 2, count(*), min (OperDate), max (OperDate) from movementitemprotocol;
         vbTmp:= (select max (Id) from movementprotocol);	
         insert into movementprotocol_arc
            select * from movementprotocol where Id < vbTmp;
         delete from movementprotocol where Id < vbTmp;

         vbTmp:= (select max (Id) from movementitemprotocol);	
         insert into movementitemprotocol_arc
            select * from movementitemprotocol where Id < vbTmp;
         delete from movementitemprotocol where Id < vbTmp;
    END;
$$;


     -- NEW - 1
     DELETE FROM MovementProtocol_arc
     -- SELECT * FROM MovementProtocol_arc
     WHERE OperDate < DATE_TRUNC ('MONTH', CURRENT_DATE) - INTERVAL '6 MONTH'
       AND MovementId IN (WITH tmp1 AS (SELECT DISTINCT MovementId
                                        FROM
                                       (SELECT MovementId
                                        FROM MovementProtocol_arc
                                        ORDER BY Id
                                        LIMIT 100000) AS tmp
                                       )
                             , tmp2 AS (SELECT tmp.MovementId, MAX (tmp.OperDate) AS OperDate
                                        FROM (SELECT tmp1.MovementId, MAX (MovementProtocol.OperDate) AS OperDate
                                              FROM tmp1
                                                   JOIN MovementProtocol_arc AS MovementProtocol ON MovementProtocol.MovementId = tmp1.MovementId
                                              GROUP BY tmp1.MovementId
                                             UNION ALL
                                              SELECT tmp1.MovementId, MAX (MovementProtocol.OperDate) AS OperDate
                                              FROM tmp1
                                                   JOIN MovementProtocol ON MovementProtocol.MovementId = tmp1.MovementId
                                              GROUP BY tmp1.MovementId
                                              ) AS tmp
                                        GROUP BY tmp.MovementId
                                       )
                             , tmpRes AS (SELECT tmp2.MovementId
                                          FROM tmp2
                                               INNER JOIN Movement ON Movement.Id = tmp2.MovementId AND Movement.OperDate < DATE_TRUNC ('MONTH', CURRENT_DATE) - INTERVAL '6 MONTH'
                                          WHERE tmp2.OperDate < DATE_TRUNC ('MONTH', CURRENT_DATE) - INTERVAL '6 MONTH')
                          SELECT tmpRes.MovementId FROM tmpRes
                         )
     -- ORDER BY Id DESC
    ;
    
     -- NEW - 2
     DELETE FROM MovementItemProtocol_arc
     -- SELECT * FROM MovementItemProtocol_arc
     WHERE OperDate < DATE_TRUNC ('MONTH', CURRENT_DATE) - INTERVAL '6 MONTH'
       AND MovementItemId
                      IN (WITH tmp1 AS (SELECT DISTINCT MovementItemId
                                        FROM
                                       (SELECT MovementItemId
                                        FROM MovementItemProtocol_arc
                                        ORDER BY Id
                                        LIMIT 1000000) AS tmp
                                       )
                           , tmpRes AS (SELECT tmp1.MovementItemId
                                        FROM tmp1
                                             INNER JOIN MovementItem ON MovementItem.Id = tmp1.MovementItemId
                                             INNER JOIN Movement ON Movement.Id = MovementItem.MovementId AND Movement.OperDate < DATE_TRUNC ('MONTH', CURRENT_DATE) - INTERVAL '6 MONTH'
                                             LEFT JOIN MovementProtocol_arc ON MovementProtocol_arc.MovementId = MovementItem.MovementId
                                             LEFT JOIN MovementProtocol     ON MovementProtocol.MovementId     = MovementItem.MovementId
                                        WHERE MovementProtocol_arc.MovementId IS NULL AND MovementProtocol.MovementId IS NULL
                                       )
                          SELECT tmpRes.MovementItemId FROM tmpRes
                         )
     -- ORDER BY Id DESC
    ;
*/
