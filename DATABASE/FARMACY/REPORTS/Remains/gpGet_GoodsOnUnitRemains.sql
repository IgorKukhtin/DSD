-- Function: gpSelect_Movement_Income()

DROP FUNCTION IF EXISTS gpGet_GoodsOnUnitRemains (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_GoodsOnUnitRemains(
    IN inGoodsId       Integer  ,  -- Товар
   OUT outRemains      TFloat   ,  -- Остаток
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TFloat
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


     outRemains := COALESCE((SELECT SUM(Amount) FROM container  
               JOIN containerlinkobject AS CLO_Unit
                 ON CLO_Unit.containerid = container.id AND CLO_Unit.descid = zc_ContainerLinkObject_Unit()
                AND CLO_Unit.objectid = vbUnitId 
              WHERE container.descid = zc_container_count()
                AND container.ObjectId = inGoodsId), 0);
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_GoodsOnUnitRemains (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 26.05.15                        *

*/

-- тест
-- SELECT * FROM gpSelect_CashRemains (inSession:= '2')