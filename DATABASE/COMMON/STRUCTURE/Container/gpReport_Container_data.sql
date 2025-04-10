-- Function: gpReport_Container_data()

DROP FUNCTION IF EXISTS gpReport_Container_data (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Container_data(
    IN inStartDate           TDateTime , -- Дата партии
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS TABLE (ContainerId        Integer
             , Amount_1           TFloat
             , Amount_data_real_1 TFloat
             , VerId_1            Integer

             , Amount_2           TFloat
             , Amount_data_real_2 TFloat
             , VerId_2            Integer

             , Amount_3           TFloat
             , Amount_data_real_3 TFloat
             , VerId_3            Integer

             , Amount_4           TFloat
             , Amount_data_real_4 TFloat
             , VerId_4            Integer

             , Amount_5           TFloat
             , Amount_data_real_5 TFloat
             , VerId_5            Integer
              )
AS
$BODY$
   DECLARE vbUserId   Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_User());

     RETURN QUERY
     WITH tmpAll AS (SELECT * FROM Container_data WHERE Container_data.StartDate = inStartDate AND VerId IN (1,2,3,4,5))
      , tmp_list_all AS (SELECT DISTINCT VerId FROM tmpAll)
      , tmp_list AS (SELECT VerId, ROW_NUMBER() OVER (ORDER BY VerId ASC) AS Ord FROM tmp_list_all)
      , tmp_res AS (SELECT tmpAll.Id AS ContainerId
                         , SUM (CASE WHEN tmp_list.Ord = 1 THEN tmpAll.Amount           ELSE 0 END) AS Amount_1
                         , SUM (CASE WHEN tmp_list.Ord = 1 THEN tmpAll.Amount_data_real ELSE 0 END) AS Amount_data_real_1
                         , MAX (CASE WHEN tmp_list.Ord = 1 THEN tmp_list.Ord            ELSE 0 END) AS Ord_1
                         , MAX (CASE WHEN tmp_list.Ord = 1 THEN tmp_list.VerId          ELSE 0 END) AS VerId_1

                         , SUM (CASE WHEN tmp_list.Ord = 2 THEN tmpAll.Amount           ELSE 0 END) AS Amount_2
                         , SUM (CASE WHEN tmp_list.Ord = 2 THEN tmpAll.Amount_data_real ELSE 0 END) AS Amount_data_real_2
                         , MAX (CASE WHEN tmp_list.Ord = 2 THEN tmp_list.Ord            ELSE 0 END) AS Ord_2
                         , MAX (CASE WHEN tmp_list.Ord = 2 THEN tmp_list.VerId          ELSE 0 END) AS VerId_2

                         , SUM (CASE WHEN tmp_list.Ord = 3 THEN tmpAll.Amount           ELSE 0 END) AS Amount_3
                         , SUM (CASE WHEN tmp_list.Ord = 3 THEN tmpAll.Amount_data_real ELSE 0 END) AS Amount_data_real_3
                         , MAX (CASE WHEN tmp_list.Ord = 3 THEN tmp_list.Ord            ELSE 0 END) AS Ord_3
                         , MAX (CASE WHEN tmp_list.Ord = 3 THEN tmp_list.VerId          ELSE 0 END) AS VerId_3

                         , SUM (CASE WHEN tmp_list.Ord = 4 THEN tmpAll.Amount           ELSE 0 END) AS Amount_4
                         , SUM (CASE WHEN tmp_list.Ord = 4 THEN tmpAll.Amount_data_real ELSE 0 END) AS Amount_data_real_4
                         , MAX (CASE WHEN tmp_list.Ord = 4 THEN tmp_list.Ord            ELSE 0 END) AS Ord_4
                         , MAX (CASE WHEN tmp_list.Ord = 4 THEN tmp_list.VerId          ELSE 0 END) AS VerId_4

                         , SUM (CASE WHEN tmp_list.Ord = 5 THEN tmpAll.Amount           ELSE 0 END) AS Amount_5
                         , SUM (CASE WHEN tmp_list.Ord = 5 THEN tmpAll.Amount_data_real ELSE 0 END) AS Amount_data_real_5
                         , MAX (CASE WHEN tmp_list.Ord = 5 THEN tmp_list.Ord            ELSE 0 END) AS Ord_5
                         , MAX (CASE WHEN tmp_list.Ord = 55THEN tmp_list.VerId          ELSE 0 END) AS VerId_5

                    FROM tmp_list
                         LEFT JOIN tmpAll ON tmpAll.VerId = tmp_list.VerId
                    GROUP BY tmpAll.Id
                   )
        -- Результат
        SELECT tmp_res.ContainerId

             , tmp_res.Amount_1           :: TFloat
             , tmp_res.Amount_data_real_1 :: TFloat
             , tmp_res.VerId_1            :: Integer

             , tmp_res.Amount_2           :: TFloat
             , tmp_res.Amount_data_real_2 :: TFloat
             , tmp_res.VerId_2            :: Integer

             , tmp_res.Amount_3           :: TFloat
             , tmp_res.Amount_data_real_3 :: TFloat
             , tmp_res.VerId_3            :: Integer

             , tmp_res.Amount_4           :: TFloat
             , tmp_res.Amount_data_real_4 :: TFloat
             , tmp_res.VerId_4            :: Integer

             , tmp_res.Amount_5           :: TFloat
             , tmp_res.Amount_data_real_5 :: TFloat
             , tmp_res.VerId_5            :: Integer

        FROM tmp_res
        WHERE (tmp_res.Amount_1 <> tmp_res.Amount_2 AND tmp_res.Ord_2 > 0)
           OR (tmp_res.Amount_1 <> tmp_res.Amount_3 AND tmp_res.Ord_3 > 0)
           OR (tmp_res.Amount_1 <> tmp_res.Amount_4 AND tmp_res.Ord_4 > 0)
           OR (tmp_res.Amount_1 <> tmp_res.Amount_5 AND tmp_res.Ord_5 > 0)

       UNION ALL
        SELECT (-1 * tmp_list.VerId) :: Integer AS ContainerId
               -- 1
             , SUM (tmpAll.Amount)           :: TFloat
             , SUM (tmpAll.Amount_data_real) :: TFloat
             , COUNT (*)                     :: Integer
               -- 2
             , 0 :: TFloat
             , 0 :: TFloat
             , 0 :: Integer
               -- 3
             , 0 :: TFloat
             , 0 :: TFloat
             , 0 :: Integer
               -- 4
             , 0 :: TFloat
             , 0 :: TFloat
             , 0 :: Integer
               -- 5
             , 0 :: TFloat
             , 0 :: TFloat
             , 0 :: Integer

        FROM tmp_list
             JOIN tmpAll ON tmpAll.VerId = tmp_list.VerId
        WHERE tmp_list.Ord = 1
        GROUP BY tmp_list.VerId

       UNION ALL
        SELECT (-1 * tmp_list.VerId) :: Integer AS ContainerId
               -- 1
             , 0 :: TFloat
             , 0 :: TFloat
             , 0 :: Integer
               -- 2
             , SUM (tmpAll.Amount)           :: TFloat
             , SUM (tmpAll.Amount_data_real) :: TFloat
             , COUNT (*)                     :: Integer
               -- 3
             , 0 :: TFloat
             , 0 :: TFloat
             , 0 :: Integer
               -- 4
             , 0 :: TFloat
             , 0 :: TFloat
             , 0 :: Integer
               -- 5
             , 0 :: TFloat
             , 0 :: TFloat
             , 0 :: Integer

        FROM tmp_list
             JOIN tmpAll ON tmpAll.VerId = tmp_list.VerId
        WHERE tmp_list.Ord = 2
        GROUP BY tmp_list.VerId

       UNION ALL
        SELECT (-1 * tmp_list.VerId) :: Integer AS ContainerId
               -- 1
             , 0 :: TFloat
             , 0 :: TFloat
             , 0 :: Integer
               -- 2
             , 0 :: TFloat
             , 0 :: TFloat
             , 0 :: Integer
               -- 3
             , SUM (tmpAll.Amount)           :: TFloat
             , SUM (tmpAll.Amount_data_real) :: TFloat
             , COUNT (*)                     :: Integer
               -- 4
             , 0 :: TFloat
             , 0 :: TFloat
             , 0 :: Integer
               -- 5
             , 0 :: TFloat
             , 0 :: TFloat
             , 0 :: Integer

        FROM tmp_list
             JOIN tmpAll ON tmpAll.VerId = tmp_list.VerId
        WHERE tmp_list.Ord = 3
        GROUP BY tmp_list.VerId

       /*UNION ALL
        SELECT -1 :: Integer AS ContainerId
               -- 1
             , tmp_1.Amount           :: TFloat
             , tmp_1.Amount_data_real :: TFloat
             , tmp_1.Id               :: Integer
               -- 2
             , tmp_2.Amount           :: TFloat
             , tmp_2.Amount_data_real :: TFloat
             , tmp_2.Id               :: Integer
               -- 3
             , 0 :: TFloat
             , 0 :: TFloat
             , 0 :: Integer
               -- 4
             , 0 :: TFloat
             , 0 :: TFloat
             , 0 :: Integer
               -- 5
             , 0 :: TFloat
             , 0 :: TFloat
             , 0 :: Integer
        FROM (SELECT tmpAll.*
              FROM tmp_list
                   JOIN tmpAll ON tmpAll.VerId = tmp_list.VerId
              WHERE tmp_list.Ord = 1
             ) AS tmp_1

             FULL JOIN
            (SELECT tmpAll.*
              FROM tmp_list
                   JOIN tmpAll ON tmpAll.VerId = tmp_list.VerId
              WHERE tmp_list.Ord = 2
             ) AS tmp_2
               ON tmp_2.Id = tmp_1.Id

        WHERE tmp_1.Id IS NULL
           OR tmp_2.Id IS NULL*/

       ORDER BY 1
       LIMIT 100
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.01.24         *
*/

-- delete from Container_data WHERE Container_data.StartDate = '01.02.2025' AND Container_data.VerId in (1, 2)
-- тест
-- SELECT ContainerId, Amount_1, Amount_2, Amount_3, Amount_4, Amount_5, VerId_1, VerId_2, VerId_3, VerId_4, VerId_5, Amount_data_real_1, Amount_data_real_2, Amount_data_real_3, Amount_data_real_4, Amount_data_real_5 FROM gpReport_Container_data (inStartDate:= '01.01.2024', inSession:= '5')
-- SELECT ContainerId, Amount_1, Amount_2, Amount_3, Amount_4, Amount_5, VerId_1, VerId_2, VerId_3, VerId_4, VerId_5, Amount_data_real_1, Amount_data_real_2, Amount_data_real_3, Amount_data_real_4, Amount_data_real_5 FROM gpReport_Container_data (inStartDate:= '01.01.2023', inSession:= '5')
-- SELECT ContainerId, Amount_1, Amount_2, Amount_3, Amount_4, Amount_5, VerId_1, VerId_2, VerId_3, VerId_4, VerId_5, Amount_data_real_1, Amount_data_real_2, Amount_data_real_3, Amount_data_real_4, Amount_data_real_5 FROM gpReport_Container_data (inStartDate:= '01.01.2022', inSession:= '5')
-- SELECT ContainerId, Amount_1, Amount_2, Amount_3, Amount_4, Amount_5, VerId_1, VerId_2, VerId_3, VerId_4, VerId_5, Amount_data_real_1, Amount_data_real_2, Amount_data_real_3, Amount_data_real_4, Amount_data_real_5 FROM gpReport_Container_data (inStartDate:= '01.12.2024', inSession:= '5')
WITH tmp AS (SELECT ContainerId, Amount_1, Amount_2, Amount_3, Amount_4, Amount_5, VerId_1, VerId_2, VerId_3, VerId_4, VerId_5, Amount_data_real_1, Amount_data_real_2, Amount_data_real_3, Amount_data_real_4, Amount_data_real_5 FROM gpReport_Container_data (inStartDate:= '01.04.2025', inSession:= '5'))
   , rem AS (select tmp.ContainerId, Container.Amount,  Container.Amount - coalesce (sum (coalesce (MovementItemContainer.Amount, 0)), 0) as calcAmount
             from tmp
                  left join Container on Container.Id = tmp.ContainerId
                  left join MovementItemContainer on MovementItemContainer.ContainerId = tmp.ContainerId
                                                 and OperDate >= '01.04.2025'
             group by tmp.ContainerId, Container.Amount
            )
select tmp.ContainerId, rem.Amount, rem.calcAmount, Object_Goods.ValueData, Container.DescId, tmp.*
from tmp
     left join rem on rem.ContainerId = tmp.ContainerId
     left join Container on Container.Id = tmp.ContainerId
     LEFT JOIN ContainerLinkObject AS CLO_Goods ON CLO_Goods.ContainerId = tmp.ContainerId
                                               AND CLO_Goods.DescId = zc_ContainerLinkObject_Goods()
                                               AND CLO_Goods.ObjectId > 0
     left join Object AS Object_Goods on Object_Goods.Id = COALESCE (CLO_Goods.ObjectId, Container.ObjectId)
