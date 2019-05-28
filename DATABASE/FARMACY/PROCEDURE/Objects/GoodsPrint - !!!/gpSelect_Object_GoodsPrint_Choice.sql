-- Function: gpSelect_Object_GoodsPrint_Choice (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsPrint_Choice (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsPrint_Choice(
    IN inUnitId      Integer,       --  
    IN inSession     TVarChar       --  сессия пользователя
)
RETURNS TABLE (UnitId    Integer
             , GoodsId     Integer
             --, InsertDate TDateTime
 )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_GoodsPrint());
     vbUserId:= lpGetUserBySession (inSession);


     -- Результат
     RETURN QUERY
       SELECT DISTINCT
              Object_GoodsPrint.UnitId      AS UnitId
            , Object_GoodsPrint.GoodsId     AS GoodsId
            --, Object_GoodsPrint.InsertDate  AS InsertDate
       FROM Object_GoodsPrint
       WHERE Object_GoodsPrint.UserId = inUserId
         AND (Object_GoodsPrint.UnitId = inUnitId OR inUnitId  = 0)
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
28.05.19          *
*/

-- тест
-- SELECT * FROM gpSelect_Object_GoodsPrint_Choice (0, zfCalc_UserAdmin())
