-- Function: gpSelect_Object_Warehouse_effie

DROP FUNCTION IF EXISTS gpSelect_Object_Warehouse_effie ( TVarChar);
                  
CREATE OR REPLACE FUNCTION gpSelect_Object_Warehouse_effie(
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS TABLE (extId            TVarChar   -- Уникальный идентификатор склада
             , Name             TVarChar   -- Название склада
             , warehouseTypeId  TVarChar  -- "Тип склада:1 - Stationary 2 - Mobile , по умолчанию 1"
             , isDeleted        Boolean    -- Признак активности: false = активен / true = не активен
) AS

$BODY$
   DECLARE vbUserId Integer;
 BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY
     SELECT Object_Unit.Id               ::TVarChar AS extId
          , TRIM (Object_Unit.ValueData) ::TVarChar AS Name 
          , 1                            ::TVarChar AS warehouseTypeId
          , Object_Unit.isErased         ::Boolean  AS isDeleted
     FROM Object AS Object_Unit 
           INNER JOIN ObjectLink AS ObjectLink_Unit_Branch
                                 ON ObjectLink_Unit_Branch.ObjectId       = Object_Unit.Id
                                AND ObjectLink_Unit_Branch.DescId         = zc_ObjectLink_Unit_Branch()
                                AND ObjectLink_Unit_Branch.ChildObjectId  > 0
     WHERE Object_Unit.DescId = zc_Object_Unit() 
       AND ObjectLink_Unit_Branch.ChildObjectId NOT IN (10895481 -- Фірмова торгівля
                                                      , 13257082 -- Казахстан
                                                      , 13261282 -- Европа
                                                      , 8380     -- филиал Днепр
                                                      , 8109544  -- Ирна
                                                       )

   UNION 
    SELECT Object_Unit.Id               ::TVarChar AS extId
          , TRIM (Object_Unit.ValueData) ::TVarChar AS Name 
          , 1                            ::TVarChar AS warehouseTypeId
          , Object_Unit.isErased         ::Boolean  AS isDeleted
     FROM Object AS Object_Unit 
     WHERE Object_Unit.DescId = zc_Object_Unit() 
       AND Object_Unit.Id = zc_Unit_RK()

   UNION 
    SELECT Object_Unit.Id               ::TVarChar AS extId
          , TRIM (Object_Unit.ValueData) ::TVarChar AS Name 
          , 1                            ::TVarChar AS warehouseTypeId
          , Object_Unit.isErased         ::Boolean  AS isDeleted
     FROM (SELECT UnitId FROM lfSelect_Object_Unit_byGroup (8460)) AS tmp
          LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmp.UnitId
    ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.03.26         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Warehouse_effie (zfCalc_UserAdmin()::TVarChar);


/*
 возвращает только склады филиалов юнион zc_Unit_RK юнион все что в группе 8460
*/