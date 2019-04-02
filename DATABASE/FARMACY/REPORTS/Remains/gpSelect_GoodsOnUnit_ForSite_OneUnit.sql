-- Function: gpSelect_GoodsOnUnit_ForSite_OneUnit

DROP FUNCTION IF EXISTS gpSelect_GoodsOnUnit_ForSite_OneUnit (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsOnUnit_ForSite_OneUnit (
    IN inUnitId  Integer  ,
    IN inSession TVarChar   -- сессия пользователя
)
RETURNS TABLE (GoodsId          Integer   -- идентификатор товара нашей сети
             , GoodsCode        Integer   -- код товара нашей сети
             , GoodsNameForSite TBlob     -- наименование товара для сайта
             , Price            TFloat    -- минимальная цена среди поставщиков и аптек
             , GoodsURL         TBlob     -- URL товара
              )
AS $BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
     vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY
       WITH tmpUnitPrice AS (SELECT Price_Goods.ChildObjectId                 AS GoodsId
                                  , MIN (CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                                               AND ObjectFloat_Goods_Price.ValueData > 0
                                                   THEN ROUND (ObjectFloat_Goods_Price.ValueData, 2)
                                              ELSE ROUND (Price_Value.ValueData, 2)
                                    END) :: TFloat AS Price
                      FROM ObjectLink AS ObjectLink_Price_Unit
                           LEFT JOIN ObjectLink AS Price_Goods
                                                ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                               AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                           LEFT JOIN ObjectFloat AS Price_Value
                                                 ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                           LEFT JOIN ObjectFloat AS MCS_Value
                                                 ON MCS_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()
                           -- Фикс цена для всей Сети
                           LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_Price
                                                  ON ObjectFloat_Goods_Price.ObjectId = Price_Goods.ChildObjectId
                                                 AND ObjectFloat_Goods_Price.DescId   = zc_ObjectFloat_Goods_Price()   
                           LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                                   ON ObjectBoolean_Goods_TOP.ObjectId = Price_Goods.ChildObjectId
                                                  AND ObjectBoolean_Goods_TOP.DescId   = zc_ObjectBoolean_Goods_TOP()  
                      WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                         AND ObjectLink_Price_Unit.ChildObjectId = inUnitId
                      GROUP BY Price_Goods.ChildObjectId
                            )
          , tmpMov AS (SELECT Movement.Id
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
          , tmpReserve AS (SELECT MovementItem.ObjectId            AS GoodsId
                                , Sum(MovementItem.Amount)::TFloat AS Amount
                           FROM tmpMov
                                INNER JOIN MovementItem ON MovementItem.MovementId = tmpMov.Id
                                                       AND MovementItem.DescId     = zc_MI_Master()
                                                       AND MovementItem.isErased   = FALSE
                           GROUP BY MovementItem.ObjectId 
                        )
          , tmpRemains AS (SELECT Container.ObjectId               AS GoodsId
                                , Sum (Container.Amount)::TFloat   AS Amount
                           FROM Container
                                JOIN tmpUnitPrice ON Container.WhereObjectId = inUnitId
                                                 AND tmpUnitPrice.GoodsId = Container.ObjectId
                           WHERE Container.DescId = zc_Container_Count()
                             AND Container.Amount <> 0
                           GROUP BY Container.ObjectId
                          )
          , tmpGoods AS (SELECT Remains.GoodsId               AS GoodsId
                         FROM tmpRemains AS Remains
                              LEFT JOIN tmpReserve AS Reserve 
                                                   ON Reserve.GoodsId = Remains.GoodsId
                         WHERE Remains.Amount - COALESCE (Reserve.Amount, 0) > 0
                          )
                          
       SELECT UnitPrice.GoodsId
            , Object_Goods.ObjectCode AS GoodsCode
            , COALESCE (ObjectBlob_Goods_Site.ValueData, Object_Goods.ValueData)::TBlob AS GoodsNameForSite
            , UnitPrice.Price
            , ('http://neboley.dp.ua/products/instruction/' || COALESCE (ObjectFloat_Goods_Site.ValueData::Integer, ObjectLink_Child_ALL.ChildObjectId))::TBlob AS GoodsURL
       FROM tmpUnitPrice AS UnitPrice

            INNER JOIN Object AS Object_Goods ON Object_Goods.Id = UnitPrice.GoodsId

            INNER JOIN tmpGoods AS Goods
                                  ON Goods.GoodsId = UnitPrice.GoodsId

            INNER JOIN ObjectLink AS ObjectLink_Child
                                  ON ObjectLink_Child.ChildObjectId = UnitPrice.GoodsId
                                 AND ObjectLink_Child.DescId        = zc_ObjectLink_LinkGoods_Goods()
            INNER JOIN  ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                  AND ObjectLink_Main.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()
            INNER JOIN ObjectLink AS ObjectLink_Main_ALL ON ObjectLink_Main_ALL.ChildObjectId = ObjectLink_Main.ChildObjectId
                                 AND ObjectLink_Main_ALL.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
            INNER JOIN ObjectLink AS ObjectLink_Child_ALL ON ObjectLink_Child_ALL.ObjectId = ObjectLink_Main_ALL.ObjectId
                                 AND ObjectLink_Child_ALL.DescId   = zc_ObjectLink_LinkGoods_Goods()
            INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                  ON ObjectLink_Goods_Object.ObjectId = ObjectLink_Child_ALL.ChildObjectId
                                 AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                 AND ObjectLink_Goods_Object.ChildObjectId = 4

            INNER JOIN ObjectBlob AS ObjectBlob_Goods_Site
                                 ON ObjectBlob_Goods_Site.ObjectId = ObjectLink_Child_ALL.ChildObjectId
                                AND ObjectBlob_Goods_Site.DescId = zc_ObjectBlob_Goods_Site()

            LEFT JOIN ObjectFloat AS ObjectFloat_Goods_Site
                                  ON ObjectFloat_Goods_Site.ObjectId = ObjectLink_Child_ALL.ChildObjectId
                                 AND ObjectFloat_Goods_Site.DescId = zc_ObjectFloat_Goods_Site()

            LEFT JOIN ObjectBoolean AS ObjectBoolean_isNotUploadSites
                                    ON ObjectBoolean_isNotUploadSites.ObjectId = ObjectLink_Child_ALL.ChildObjectId
                                   AND ObjectBoolean_isNotUploadSites.DescId = zc_ObjectBoolean_Goods_isNotUploadSites()
       WHERE COALESCE(ObjectBoolean_isNotUploadSites.ValueData, false) = False;

END; $BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 03.09.18        *
 29.08.18        *
*/

-- тест
-- SELECT * FROM gpSelect_GoodsOnUnit_ForSite_OneUnit (inUnitId:= 8301448, inSession:= zfCalc_UserSite());
