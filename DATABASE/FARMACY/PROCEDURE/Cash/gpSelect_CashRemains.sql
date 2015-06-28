-- Function: gpSelect_Movement_Income()

DROP FUNCTION IF EXISTS gpSelect_CashRemains (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_CashRemains(
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsName TVarChar, GoodsCode Integer,
               Remains TFloat, Price TFloat, Reserved TFloat, MCSValue TFloat)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
     vbUserId:= lpGetUserBySession (inSession);
     vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
     IF vbUnitKey = '' THEN
        vbUnitKey := '0';
     END IF;
     vbUnitId := vbUnitKey::Integer;

     RETURN QUERY

       SELECT Goods.Id,
              Goods.ValueData,
              Goods.ObjectCode,
              GoodsRemains.Remains::TFloat,
              object_Price_view.price,
              10::TFloat,
              object_Price_view.mcsvalue
       FROM (SELECT SUM(Amount) AS Remains, container.objectid FROM container
               JOIN containerlinkobject AS CLO_Unit
                 ON CLO_Unit.containerid = container.id AND CLO_Unit.descid = zc_ContainerLinkObject_Unit()
                AND CLO_Unit.objectid = vbUnitId
              WHERE container.descid = zc_container_count() AND Amount<>0
           GROUP BY container.objectid) AS GoodsRemains

       JOIN OBJECT AS Goods ON Goods.Id = GoodsRemains.ObjectId
       LEFT OUTER JOIN object_Price_view ON GoodsRemains.ObjectId = object_Price_view.goodsid
                                        AND object_Price_view.unitid = vbUnitId;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_CashRemains (TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 05.05.15                        *

*/

-- тест
-- SELECT * FROM gpSelect_CashRemains (inSession:= '3')