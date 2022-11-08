-- Function: gpInsert_mic_2022_11_03_Load()

DROP FUNCTION IF EXISTS gpUpdate_mic_2022_11_03_Load ();

CREATE OR REPLACE FUNCTION gpUpdate_mic_2022_11_03_Load()
RETURNS TABLE (res TVarChar, MovementId Integer, MovementItemId Integer, ContainerId Integer, Amount_curr TFloat, Amount_new TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Insert_mic_2022_11_03_load());
     --vbUserId := lpGetUserBySession (inSession);


     -- таблица
     CREATE TEMP TABLE _tmpNew (MovementId Integer, MovementItemId Integer, ContainerId Integer, Amount TFloat) ON COMMIT DROP;
     -- таблица
     CREATE TEMP TABLE _tmpCurr (MovementId Integer, MovementItemId Integer, ContainerId Integer, Amount TFloat) ON COMMIT DROP;
     -- таблица
     CREATE TEMP TABLE _tmpContainer (ContainerId Integer, Amount_diff TFloat) ON COMMIT DROP;

     -- new
     INSERT INTO _tmpNew (MovementId, MovementItemId, ContainerId, Amount)
       select MIC.MovementId, MIC.MovementItemId, MIC.ContainerId, SUM (MIC.Amount)
       from mic_2022_11_03 AS MIC
            JOIN Movement ON Movement.Id = MIC.MovementId AND Movement.OperDate < '01.02.2022'
            JOIN Container ON Container.Id = MIC.ContainerId
                          AND Container.DescId IN (zc_Container_Summ(), zc_Container_Count())
          --JOIN Container AS Container_goods ON Container_goods.Id     = Container.ParentId
          --                                 AND Container_goods.DescId = zc_Container_count()
          --JOIN ContainerLinkObject AS CLO ON CLO.ContainerId = Container.Id
          --                               AND CLO.DescId      = zc_ContainerLinkObject_goods()
            LEFT JOIN ContainerLinkObject AS CLO ON CLO.ContainerId = Container.Id
                                                AND CLO.DescId = zc_ContainerLinkObject_Juridical()
       WHERE CLO.ContainerId IS NULL
         --AND MIC.OperDate < '01.02.2022'
       GROUP BY MIC.MovementId, MIC.MovementItemId, MIC.ContainerId;

     -- current
     INSERT INTO _tmpCurr (MovementId, MovementItemId, ContainerId, Amount)
       select MIC.MovementId, MIC.MovementItemId, MIC.ContainerId, SUM (MIC.Amount)
       from MovementItemContainer AS MIC
            JOIN Container ON Container.Id = MIC.ContainerId
                          AND Container.DescId IN (zc_Container_Summ(), zc_Container_Count())
          --JOIN Container AS Container_goods ON Container_goods.Id     = Container.ParentId
          --                                 AND Container_goods.DescId = zc_Container_count()
          --JOIN ContainerLinkObject AS CLO ON CLO.ContainerId = Container.Id
          --                               AND CLO.DescId      = zc_ContainerLinkObject_goods()
            LEFT JOIN ContainerLinkObject AS CLO ON CLO.ContainerId = Container.Id
                                                AND CLO.DescId = zc_ContainerLinkObject_Juridical()
       WHERE MIC.MovementId IN (SELECT DISTINCT _tmpNew.MovementId FROM _tmpNew)
       --AND MIC.OperDate < '01.02.2022'
         AND CLO.ContainerId IS NULL
       GROUP BY MIC.MovementId, MIC.MovementItemId, MIC.ContainerId;
       
       
/*
    RAISE EXCEPTION 'Ошибка.<%> '
    , (select MIC.MovementId
       from MovementItemContainer AS MIC
            JOIN Movement ON Movement.Id = MIC.MovementId
            JOIN Container ON Container.Id = MIC.ContainerId
                          AND Container.DescId IN (zc_Container_Summ(), zc_Container_Count())
            LEFT JOIN ContainerLinkObject AS CLO ON CLO.ContainerId = Container.Id
                                                AND CLO.DescId = zc_ContainerLinkObject_Juridical()
       WHERE MIC.MovementId IN (SELECT DISTINCT _tmpNew.MovementId FROM _tmpNew)
       --AND MIC.OperDate < '01.02.2022'
         AND CLO.ContainerId IS NULL
         and Movement.OperDate <> MIC.OperDate
       LIMIT 1
       )

;*/


       -- tmp Insert
       INSERT INTO _tmpContainer (ContainerId, Amount_diff)
        SELECT tmp.ContainerId,  SUM (tmp.Amount) AS Amount
        FROM (SELECT _tmpNew.ContainerId,   1 * SUM (_tmpNew.Amount) AS Amount FROM _tmpNew GROUP BY _tmpNew.ContainerId
             UNION ALL
              SELECT _tmpCurr.ContainerId, -1 * SUM (_tmpCurr.Amount) AS Amount FROM _tmpCurr GROUP BY _tmpCurr.ContainerId
             ) AS tmp
        GROUP BY tmp.ContainerId;
        
       ANALYZE _tmpContainer;



       DELETE FROM MovementItemContainer
       WHERE MovementItemContainer.MovementId  IN (SELECT DISTINCT _tmpCurr.MovementId  FROM _tmpCurr)
         AND MovementItemContainer.ContainerId IN (SELECT DISTINCT _tmpCurr.ContainerId FROM _tmpCurr)
      ;

       INSERT INTO MovementItemContainer (id,
                                          descid ,
                                          movementid ,
                                          containerid,
                                          amount,
                                          operdate,
                                          movementitemid,
                                          parentid,
                                          isactive,
                                          movementdescid,
                                          analyzerid,
                                          accountid,
                                          objectid_analyzer,
                                          whereobjectid_analyzer,
                                          containerid_analyzer,
                                          objectintid_analyzer,
                                          objectextid_analyzer,
                                          containerintid_analyzer,
                                          accountid_analyzer
                                         )
                                   SELECT MIC.id,
                                          MIC.descid ,
                                          MIC.movementid ,
                                          MIC.containerid,
                                          MIC.amount,
                                        --MIC.operdate,
                                          Movement.operdate,
                                          NULLIF (MIC.movementitemid, 0),
                                          NULLIF (MIC.parentid, 0),
                                          MIC.isactive,
                                          MIC.movementdescid,
                                          NULLIF (MIC.analyzerid, 0),
                                          NULLIF (MIC.accountid, 0),
                                          NULLIF (MIC.objectid_analyzer, 0),
                                          NULLIF (MIC.whereobjectid_analyzer, 0),
                                          NULLIF (MIC.containerid_analyzer, 0),
                                          NULLIF (MIC.objectintid_analyzer, 0),
                                          NULLIF (MIC.objectextid_analyzer, 0),
                                          NULLIF (MIC.containerintid_analyzer, 0),
                                          NULLIF (MIC.accountid_analyzer, 0)
       from mic_2022_11_03 AS MIC
            JOIN Movement ON Movement.Id = MIC.MovementId AND Movement.OperDate < '01.02.2022'
            JOIN Container ON Container.Id = MIC.ContainerId
                          AND Container.DescId IN (zc_Container_Summ(), zc_Container_Count())
          --JOIN Container AS Container_goods ON Container_goods.Id     = Container.ParentId
          --                                 AND Container_goods.DescId = zc_Container_count()
          --JOIN ContainerLinkObject AS CLO ON CLO.ContainerId = Container.Id
          --                               AND CLO.DescId      = zc_ContainerLinkObject_goods()
            LEFT JOIN ContainerLinkObject AS CLO ON CLO.ContainerId = Container.Id
                                                AND CLO.DescId = zc_ContainerLinkObject_Juridical()
       WHERE CLO.ContainerId IS NULL
     ;
     

-- RAISE EXCEPTION 'ok';
      
      UPDATE Container SET Amount = Container.Amount + _tmpContainer.Amount_diff
      FROM _tmpContainer
      WHERE _tmpContainer.ContainerId = Container.Id
     ;
     
     
     if exists (select MIC.MovementId from MovementItemContainer AS MIC
                WHERE MIC.MovementId  IN (SELECT DISTINCT _tmpCurr.MovementId FROM _tmpCurr
                                    UNION SELECT DISTINCT _tmpNew.MovementId FROM _tmpNew)
                    AND MIC.DescId = 2
                GROUP BY MIC.MovementId HAVING SUM (MIC.Amount) <> 0)
     then RAISE EXCEPTION 'сумма <> 0 MovementId = <%>'
                                 , (select MIC.MovementId from MovementItemContainer AS MIC
                                    WHERE MIC.MovementId  IN (SELECT DISTINCT _tmpCurr.MovementId FROM _tmpCurr
                                                        UNION SELECT DISTINCT _tmpNew.MovementId FROM _tmpNew)
                                      AND MIC.DescId = 2
                                    GROUP BY MIC.MovementId HAVING SUM (MIC.Amount) <> 0
                                    ORDER BY 1 
                                    LIMIT 1
                                   );
     end if;
  /*   
     --
     RAISE EXCEPTION 'ok  <%>  <%>'
   , (select SUM (MIC.Amount)
      from MovementItemContainer AS MIC
           JOIN (SELECT _tmpCurr.MovementId, _tmpCurr.ContainerId FROM _tmpCurr ORDER BY _tmpCurr.MovementId, _tmpCurr.ContainerId LIMIT 1
                ) as _tmpCurr ON _tmpCurr.MovementId  = MIC.MovementId
                             AND _tmpCurr.ContainerId = MIC.ContainerId
     )
   , (select _tmpCurr.MovementId
      from (SELECT _tmpCurr.MovementId, _tmpCurr.ContainerId FROM _tmpCurr ORDER BY _tmpCurr.MovementId, _tmpCurr.ContainerId LIMIT 1
                ) as _tmpCurr
     )
     ;


    RAISE EXCEPTION 'Ошибка.<%>  <%>  <%>'
, (select sum (mic.Amount) from MovementItemContainer As mic where mic.Descid = 2 and mic.MovementId = 129781)
, (select sum (mic.Amount) from _tmpNew As mic where mic.MovementId = 129781)
, (select sum (mic.Amount) from _tmpCurr As mic where mic.MovementId = 129781)
;
*/

       RETURN QUERY
       /*SELECT '1' :: TvarChar, tmp.MovementId, tmp.MovementItemId, tmp.ContainerId, tmp.Amount AS Amount_curr, 0 :: TFloat AS Amount_new
         FROM _tmpCurr AS tmp
              LEFT JOIN _tmpNew ON _tmpNew.MovementId     = tmp.MovementId
                               AND _tmpNew.MovementItemId = tmp.MovementItemId
         WHERE _tmpNew.MovementItemId IS NULL

        UNION ALL 
         SELECT '2' :: TvarChar, tmp.MovementId, tmp.MovementItemId, tmp.ContainerId, 0 :: TFloat AS Amount_curr, tmp.Amount AS Amount_new
         FROM _tmpNew AS tmp
              LEFT JOIN _tmpCurr ON _tmpCurr.MovementId     = tmp.MovementId
                                AND _tmpCurr.MovementItemId = tmp.MovementItemId
         WHERE _tmpCurr.MovementItemId IS NULL

        UNION ALL 
         SELECT '3' :: TvarChar, tmp.MovementId, tmp.MovementItemId, tmp.ContainerId, _tmpCurr.Amount AS Amount_curr, tmp.Amount AS Amount_new
         FROM _tmpNew AS tmp
              INNER JOIN _tmpCurr ON _tmpCurr.MovementId     = tmp.MovementId
                                 AND _tmpCurr.MovementItemId = tmp.MovementItemId
                                 AND _tmpCurr.ContainerId    = tmp.ContainerId
         WHERE tmp.Amount <> _tmpCurr.Amount

        UNION ALL */
         SELECT '4' :: TvarChar
              , COALESCE (_tmpNew.MovementId, _tmpCurr.MovementId) AS MovementId
              , 0 :: Integer AS MovementItemId
              , 0 :: Integer AS ContainerId
              , _tmpCurr.Amount :: TFloat AS Amount_curr, _tmpNew.Amount :: TFloat AS Amount_new
         FROM (SELECT _tmpNew.MovementId, SUM (_tmpNew.Amount) AS Amount FROM _tmpNew GROUP BY _tmpNew.MovementId
              ) AS _tmpNew
              FULL JOIN (SELECT _tmpCurr.MovementId, SUM (_tmpCurr.Amount) AS Amount FROM _tmpCurr GROUP BY _tmpCurr.MovementId
                        ) AS _tmpCurr ON _tmpCurr.MovementId     = _tmpNew.MovementId
         WHERE COALESCE (_tmpNew.Amount, 0) <> COALESCE (_tmpCurr.Amount, 0)
         AND 1=0
        ;
     

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.11.22         *
*/

-- тест
-- select * from gpUpdate_mic_2022_11_03_Load() order by 1
