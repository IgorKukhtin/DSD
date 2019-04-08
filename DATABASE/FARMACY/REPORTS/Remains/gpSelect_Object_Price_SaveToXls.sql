-- Function: gpSelect_Object_Price_SaveToXls (TVarChar)
/*
  процедура вызывается в программе: SaveToXlsUnit
*/

DROP FUNCTION IF EXISTS gpSelect_Object_Price_SaveToXls(Integer, Integer, Boolean,Boolean,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Price_SaveToXls(
    IN inUnitId      Integer,       -- подразделение
    IN inGoodsId     Integer,       -- Товар
    IN inisShowAll   Boolean,       -- True - показать все товары, False - показать только с ценами
    IN inisShowDel   Boolean,       -- True - показать так же удаленные, False - показать только рабочие
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , GoodsCode Integer
             , GoodsName TVarChar
             , Price TFloat
             , DateChange TDateTime
             , MCSValue TFloat
             , MCSDateChange TDateTime
             , isErased boolean
             , MCSIsClose Boolean
             , MCSNotRecalc Boolean
             , Remains TFloat
             , Fix Boolean
             ) AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbObjectId Integer;
BEGIN

    vbUserId:= lpGetUserBySession (inSession);
    -- Ограничение на просмотр товарного справочника
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

    RETURN QUERY
    WITH
        tmpRemeins AS (SELECT container.objectid
                                     , Sum(COALESCE(container.Amount,0)) ::TFloat AS Remains
                                FROM Container
                                WHERE container.descid = zc_container_count()
                                  AND container.Amount<>0
                                  AND (container.objectid = inGoodsId OR inGoodsId = 0)
                                  AND Container.WhereObjectId = inUnitId
                                GROUP BY container.objectid
                                HAVING SUM(COALESCE (Container.Amount, 0)) <> 0
                                )

      ,  tmpPrice AS (SELECT ObjectLink_Price_Unit.ObjectId          AS Id
                           , Price_Goods.ChildObjectId               AS GoodsId
                      FROM ObjectLink AS ObjectLink_Price_Unit
                           INNER JOIN ObjectLink AS Price_Goods
                                                 ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                                AND (Price_Goods.ChildObjectId = inGoodsId OR inGoodsId = 0)

                           -- ограничение по торговой сети
                           INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                                 ON ObjectLink_Goods_Object.ObjectId = Price_Goods.ChildObjectId
                                                AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                                AND ObjectLink_Goods_Object.ChildObjectId = vbObjectId

                      WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                        AND ObjectLink_Price_Unit.ChildObjectId = inUnitId
                           )

      , tmpPrice_View AS (SELECT tmpPrice.Id          AS Id
                               , CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                                       AND ObjectFloat_Goods_Price.ValueData > 0
                                           THEN ROUND (ObjectFloat_Goods_Price.ValueData, 2)
                                      ELSE ROUND (Price_Value.ValueData, 2)
                                 END                           :: TFloat AS Price
                               , MCS_Value.ValueData                     AS MCSValue
                               , tmpPrice.GoodsId                        AS GoodsId
                               , price_datechange.valuedata              AS DateChange
                               , MCS_datechange.valuedata                AS MCSDateChange
                               , COALESCE(MCS_isClose.ValueData,False)   AS MCSIsClose
                               , COALESCE(MCS_NotRecalc.ValueData,False) AS MCSNotRecalc
                               , COALESCE(Price_Fix.ValueData,False)     AS Fix
                          FROM tmpPrice
                               LEFT JOIN ObjectFloat AS Price_Value
                                                     ON Price_Value.ObjectId = tmpPrice.Id
                                                    AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                               -- Фикс цена для всей Сети
                               LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_Price
                                                      ON ObjectFloat_Goods_Price.ObjectId = tmpPrice.GoodsId
                                                     AND ObjectFloat_Goods_Price.DescId   = zc_ObjectFloat_Goods_Price()
                               LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                                       ON ObjectBoolean_Goods_TOP.ObjectId = tmpPrice.GoodsId
                                                      AND ObjectBoolean_Goods_TOP.DescId   = zc_ObjectBoolean_Goods_TOP()

                               LEFT JOIN ObjectFloat AS MCS_Value
                                                     ON MCS_Value.ObjectId = tmpPrice.Id
                                                    AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()

                               LEFT JOIN ObjectDate AS Price_DateChange
                                                    ON Price_DateChange.ObjectId = tmpPrice.Id
                                                   AND Price_DateChange.DescId = zc_ObjectDate_Price_DateChange()

                               LEFT JOIN ObjectDate AS MCS_DateChange
                                                 ON MCS_DateChange.ObjectId = tmpPrice.Id
                                                AND MCS_DateChange.DescId = zc_ObjectDate_Price_MCSDateChange()

                               LEFT JOIN ObjectBoolean AS MCS_isClose
                                                       ON MCS_isClose.ObjectId = tmpPrice.Id
                                                      AND MCS_isClose.DescId = zc_ObjectBoolean_Price_MCSIsClose()
                               LEFT JOIN ObjectBoolean AS MCS_NotRecalc
                                                       ON MCS_NotRecalc.ObjectId = tmpPrice.Id
                                                      AND MCS_NotRecalc.DescId = zc_ObjectBoolean_Price_MCSNotRecalc()
                               LEFT JOIN ObjectBoolean AS Price_Fix
                                                       ON Price_Fix.ObjectId = tmpPrice.Id
                                                      AND Price_Fix.DescId = zc_ObjectBoolean_Price_Fix()
                        )

      -- объединяем товары прайса с товарами, которые есть на остатке. (если цена = 0, а остаток есть нужно показать такие товары)
      , tmpPrice_All AS (SELECT tmpPrice.Id
                              , tmpPrice.Price
                              , tmpPrice.MCSValue
                              , COALESCE (tmpPrice.GoodsId, tmpRemeins.ObjectId) AS GoodsId
                              , tmpPrice.DateChange
                              , tmpPrice.MCSDateChange
                              , COALESCE(tmpPrice.MCSIsClose, False)             AS MCSIsClose
                              , COALESCE(tmpPrice.MCSNotRecalc, False)           AS MCSNotRecalc
                              , COALESCE(tmpPrice.Fix, False)                    AS Fix
                              , tmpRemeins.Remains                               AS Remains
                        FROM tmpPrice_View AS tmpPrice
                             FULL JOIN tmpRemeins ON tmpRemeins.ObjectId = tmpPrice.GoodsId
                        )
   -- выбираем отложенные Чеки (как в кассе колонка VIP)
   , tmpMovementChek AS (SELECT Movement.Id
                         FROM MovementBoolean AS MovementBoolean_Deferred
                              INNER JOIN Movement ON Movement.Id     = MovementBoolean_Deferred.MovementId
                                                 AND Movement.DescId = zc_Movement_Check()
                                                 AND Movement.StatusId = zc_Enum_Status_UnComplete()
                              INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                            ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                           AND MovementLinkObject_Unit.ObjectId = inUnitId
                         WHERE MovementBoolean_Deferred.DescId    = zc_MovementBoolean_Deferred()
                           AND MovementBoolean_Deferred.ValueData = TRUE
                        UNION
                         SELECT Movement.Id
                         FROM MovementString AS MovementString_CommentError
                              INNER JOIN Movement ON Movement.Id     = MovementString_CommentError.MovementId
                                                 AND Movement.DescId = zc_Movement_Check()
                                                 AND Movement.StatusId = zc_Enum_Status_UnComplete()
                              INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                            ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                           AND MovementLinkObject_Unit.ObjectId = inUnitId
                        WHERE MovementString_CommentError.DescId = zc_MovementString_CommentError()
                          AND MovementString_CommentError.ValueData <> ''
                        )
   , tmpReserve AS (SELECT MovementItem.ObjectId             AS GoodsId
                         , SUM (MovementItem.Amount)::TFloat AS Amount
                    FROM tmpMovementChek
                         INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovementChek.Id
                                                AND MovementItem.DescId     = zc_MI_Master()
                                                AND MovementItem.isErased   = FALSE
                    GROUP BY MovementItem.ObjectId
                    )


    SELECT       tmpPrice_All.Id                             AS Id
               , Object_Goods.ObjectCode                     AS GoodsCode
               , Object_Goods.ValueData                      AS GoodsName
               , COALESCE (tmpPrice_All.Price,0)::TFloat     AS Price
               , tmpPrice_All.DateChange                     AS DateChange
               , COALESCE (tmpPrice_All.MCSValue,0)::TFloat  AS MCSValue
               , tmpPrice_All.MCSDateChange                  AS MCSDateChange
               , Object_Goods.isErased                       AS isErased
               , tmpPrice_All.MCSIsClose                     AS MCSIsClose
               , tmpPrice_All.MCSNotRecalc                   AS MCSNotRecalc
               , CASE WHEN (COALESCE (tmpPrice_All.Remains, 0) - COALESCE(Reserve_Goods.Amount, 0)) > 0
                 THEN COALESCE (tmpPrice_All.Remains, 0) - COALESCE(Reserve_Goods.Amount, 0)
                 ELSE Null END ::TFloat                      AS Remains
               , tmpPrice_All.Fix                            AS Fix
      from tmpPrice_All

           LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpPrice_All.GoodsId


           LEFT OUTER JOIN tmpReserve AS Reserve_Goods
                                      ON Reserve_Goods.GoodsId = Object_Goods.Id

           LEFT JOIN ObjectBoolean AS ObjectBoolean_isNotUploadSites
                                   ON ObjectBoolean_isNotUploadSites.ObjectId = Object_Goods.Id
                                  AND ObjectBoolean_isNotUploadSites.DescId = zc_ObjectBoolean_Goods_isNotUploadSites()
      WHERE COALESCE(ObjectBoolean_isNotUploadSites.ValueData, false) = False
      ORDER BY Object_Goods.ValueData;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpSelect_Object_Price_SaveToXls(Integer, Boolean,Boolean,TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Шаблий О.В.
 24.05.18         *
 26.04.18         *

*/
-- тест
--select * from gpSelect_Object_Price_SaveToXls(inUnitId := 183292 , inGoodsId := 0 , inisShowAll := 'False' , inisShowDel := 'False' ,  inSession := '3');
