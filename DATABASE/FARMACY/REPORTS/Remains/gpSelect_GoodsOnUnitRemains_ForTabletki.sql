-- Function: gpSelect_GoodsOnUnitRemains_ForTabletki

DROP FUNCTION IF EXISTS gpSelect_GoodsOnUnitRemains_ForTabletki (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsOnUnitRemains_ForTabletki(
    IN inUnitId  Integer = 183292, -- Подразделение
    IN inSession TVarChar = '' -- сессия пользователя
)
RETURNS TABLE (RowData TBlob)
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbOperDate_Begin1 TDateTime;
BEGIN
    -- сразу запомнили время начала выполнения Проц.
    vbOperDate_Begin1:= CLOCK_TIMESTAMP();

    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpGetUserBySession (inSession);
    vbUserId:= inSession :: Integer;

    CREATE TEMP TABLE _Result(RowData TBlob) ON COMMIT DROP;

    --Шапка
    INSERT INTO _Result(RowData) Values ('<?xml version="1.0" encoding="utf-8"?>');
    INSERT INTO _Result(RowData) Values ('<Offers>');
    --Тело
    WITH
     tmpContainer AS
                   (SELECT Container.ObjectId
                         , Container.Id
                         , Container.Amount
                    FROM
                        Container
                    WHERE Container.DescId        = zc_Container_Count()
                      AND Container.WhereObjectId = inUnitId
                      AND Container.Amount        <> 0
                   )
   , tmpPartionMI AS
                   (SELECT CLO.ContainerId
                         , MILinkObject_Goods.ObjectId AS GoodsId_find
                    FROM ContainerLinkObject AS CLO
                        LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLO.ObjectId
                        LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                         ON MILinkObject_Goods.MovementItemId = Object_PartionMovementItem.ObjectCode
                                                        AND MILinkObject_Goods.DescId         = zc_MILinkObject_Goods()
                    WHERE CLO.ContainerId IN (SELECT DISTINCT tmpContainer.Id FROM tmpContainer)
                      AND CLO.DescId      = zc_ContainerLinkObject_PartionMovementItem()
                   )
   , tmpRemains AS (SELECT Container.ObjectId
                         , tmpPartionMI.GoodsId_find
                         , SUM (Container.Amount)  AS Amount
                    FROM tmpContainer AS Container
                        LEFT JOIN tmpPartionMI ON tmpPartionMI.ContainerId = Container.Id
                        LEFT JOIN ObjectBoolean AS ObjectBoolean_isNotUploadSites
                                                ON ObjectBoolean_isNotUploadSites.ObjectId = Container.ObjectId
                                               AND ObjectBoolean_isNotUploadSites.DescId   = zc_ObjectBoolean_Goods_isNotUploadSites()

                    WHERE COALESCE (ObjectBoolean_isNotUploadSites.ValueData, FALSE) = FALSE
                    GROUP BY Container.ObjectId
                           , tmpPartionMI.GoodsId_find
                   )
   /*, tmpGoods AS (SELECT Object_Goods_View.Id, Object_Goods_View.MakerName
                    FROM Object_Goods_View WHERE Object_Goods_View.Id IN (SELECT DISTINCT tmpRemains.GoodsId_find FROM tmpRemains)
                   )*/
     , tmpGoods AS (SELECT ObjectString.ObjectId AS GoodsId_find, ObjectString.ValueData AS MakerName
                    FROM ObjectString
                    WHERE ObjectString.ObjectId IN (SELECT DISTINCT tmpRemains.GoodsId_find FROM tmpRemains)
                      AND ObjectString.DescId   = zc_ObjectString_Goods_Maker()
                   )
      , Remains AS (SELECT
                         tmpRemains.ObjectId
                       , MAX (tmpGoods.MakerName) AS MakerName
                       , SUM (tmpRemains.Amount) AS Amount
                    FROM
                        tmpRemains
                        LEFT JOIN tmpGoods ON tmpGoods.GoodsId_find = tmpRemains.GoodsId_find
                    GROUP BY tmpRemains.ObjectId
                    HAVING SUM (tmpRemains.Amount) > 0
                   )

  , Reserve AS (SELECT MovementItem.ObjectId
                     , SUM (MovementItem.Amount) as ReserveAmount
                FROM Movement
                     INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                   ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                  AND MovementLinkObject_Unit.DescId     = zc_MovementLinkObject_Unit()
                                                  AND MovementLinkObject_Unit.ObjectID   = inUnitId
                     INNER JOIN Object AS Object_Unit ON Object_Unit.ID = MovementLinkObject_Unit.ObjectId
                     INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                       AND MovementItem.DescId     = zc_MI_Master()
                                                       AND MovementItem.isErased   = FALSE
                WHERE Movement.DescId   = zc_Movement_Check()
                  AND Movement.StatusId = zc_Enum_Status_UnComplete()
                GROUP BY MovementItem.ObjectId
               )
       , T1 AS (SELECT MIN (Remains.ObjectId) AS ObjectId
                FROM Remains
                     INNER JOIN Object AS Object_Goods ON Object_Goods.Id = Remains.ObjectId
                GROUP BY Object_Goods.ObjectCode
               )
 , tmpPrice AS (SELECT Object_Price_View.GoodsId, Object_Price_View.Price
                FROM Object_Price_View
                WHERE Object_Price_View.GoodsId IN (SELECT DISTINCT Remains.ObjectId FROM Remains)
                  AND Object_Price_View.UnitId  = inUnitId
               )

    -- Результат
    INSERT INTO _Result(RowData)
      SELECT
          '<Offer Code="'||CAST(Object_Goods.ObjectCode AS TVarChar)
             ||'" Name="'||replace(replace(replace(Object_Goods.ValueData, '"', ''),'&','&amp;'),'''','')
         ||'" Producer="'||replace(replace(replace(COALESCE(Remains.MakerName,''),'"',''),'&','&amp;'),'''','')
            ||'" Price="'||to_char(Object_Price.Price,'FM9999990.00')
         ||'" Quantity="'||CAST((Remains.Amount - coalesce(Reserve_Goods.ReserveAmount, 0)) AS TVarChar)
     ||'" PriceReserve="'||to_char(Object_Price.Price,'FM9999990.00')
     ||'" />'

      FROM Remains
           INNER JOIN T1 ON T1.ObjectId = Remains.ObjectId

           INNER JOIN Object AS Object_Goods ON Object_Goods.Id = Remains.ObjectId

           LEFT OUTER JOIN tmpPrice AS Object_Price ON Object_Price.GoodsId = Remains.ObjectId

           LEFT OUTER JOIN Reserve AS Reserve_Goods ON Reserve_Goods.ObjectId = Remains.ObjectId

      WHERE (Remains.Amount - COALESCE (Reserve_Goods.ReserveAmount, 0)) > 0
      ;

    -- подвал
    INSERT INTO _Result(RowData) Values ('</Offers>');


    -- Результат
    RETURN QUERY
        SELECT _Result.RowData FROM _Result;


     -- !!!временно - ПРОТОКОЛ - ЗАХАРДКОДИЛ!!!
     INSERT INTO ResourseProtocol (UserId
                                 , OperDate
                                 , Value1
                                 , Value2
                                 , Value3
                                 , Value4
                                 , Value5
                                 , Time1
                                 , Time2
                                 , Time3
                                 , Time4
                                 , Time5
                                 , ProcName
                                 , ProtocolData
                                  )
        WITH tmp_pg AS (SELECT * FROM pg_stat_activity WHERE state = 'active')
        SELECT vbUserId
               -- во сколько началась
             , CURRENT_TIMESTAMP
             , (SELECT COUNT (*) FROM tmp_pg)                                   AS Value1
             , (SELECT COUNT (*) FROM tmp_pg WHERE client_addr =  '172.17.2.4') AS Value2
             , (SELECT COUNT (*) FROM tmp_pg WHERE client_addr <> '172.17.2.4') AS Value3
             , 0 AS Value4
             , (SELECT COUNT (*) FROM _Result) AS Value5
               -- сколько всего выполнялась проц
             , (CLOCK_TIMESTAMP() - vbOperDate_Begin1) :: INTERVAL AS Time1
               -- сколько всего выполнялась проц
             , (CLOCK_TIMESTAMP() - vbOperDate_Begin1) :: INTERVAL AS Time2
               -- сколько всего выполнялась проц
             , (CLOCK_TIMESTAMP() - vbOperDate_Begin1) :: INTERVAL AS Time3
               -- сколько всего выполнялась проц
             , (CLOCK_TIMESTAMP() - vbOperDate_Begin1) :: INTERVAL AS Time4
               -- во сколько закончилась
             , CLOCK_TIMESTAMP() AS Time5
               -- ProcName
             , 'gpSelect_GoodsOnUnitRemains_ForTabletki'
               -- ProtocolData
             , inUnitId :: TVarChar
        WHERE vbUserId > 0
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_GoodsOnUnitRemains_ForTabletki (Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.  Шаблий О.В.
 23.07.18                                                                                      *
 24.05.18                                                                                      *
 29.03.18                                                                                      *
 15.01.16                                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_GoodsOnUnitRemains_ForTabletki (inUnitId := 183292, inSession:= '-3')

