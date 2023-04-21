-- Function: gpSelect_Inventory_Remains()

DROP FUNCTION IF EXISTS gpSelect_Inventory_Remains(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Inventory_Remains(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (UnitId Integer, GoodsId Integer, Remains TFloat
              ) AS
$BODY$ 
  DECLARE vbUserId Integer;

BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_User());
   vbUserId:= lpGetUserBySession (inSession);


   RETURN QUERY 
   SELECT Container.WhereObjectId        AS UnitId
        , Container.ObjectId             AS GoodsId
        , SUM(Container.Amount)::TFloat  AS Remains
      FROM Container
      WHERE Container.DescId = zc_Container_Count()
        AND Container.Amount <> 0 
        AND Container.WhereObjectId in (SELECT ID FROM gpSelect_Object_Unit_Active(0, inSession))
      GROUP BY Container.WhereObjectId
             , Container.ObjectId;       
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 13.07.23                                                      *
*/

-- тест
--     

select * from gpSelect_Inventory_Remains (inSession := '3')