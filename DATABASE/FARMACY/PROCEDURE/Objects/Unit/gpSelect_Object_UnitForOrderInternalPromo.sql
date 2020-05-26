-- Function: gpSelect_Object_UnitForOrderInternalPromo()

DROP FUNCTION IF EXISTS gpSelect_Object_UnitForOrderInternalPromo(Boolean,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_UnitForOrderInternalPromo(
    IN inisShowAll   Boolean,       -- выделить все подразделения
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (UnitId Integer, UnitCode Integer, UnitName TVarChar
             , JuridicalId Integer, JuridicalName TVarChar
             , isOrderPromo Boolean
             ) 
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Unit());

    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);
    -- определяется <Торговая сеть>
    vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);

    RETURN QUERY 
    WITH 
         tmpUnit  AS  (SELECT ObjectLink_Unit_Juridical.ObjectId AS UnitId
                       FROM ObjectLink AS ObjectLink_Unit_Juridical
                          INNER JOIN ObjectLink AS ObjectLink_Unit_Parent
                                                ON ObjectLink_Unit_Parent.ObjectId = ObjectLink_Unit_Juridical.ObjectId
                                               AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()
                                               AND ObjectLink_Unit_Parent.ChildObjectId > 0 -- исключили "группы"
                          INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                               AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                               AND ObjectLink_Juridical_Retail.ChildObjectId = vbObjectId
                       WHERE  ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                        )


    SELECT Object_Unit.Id                        AS UnitId
         , Object_Unit.ObjectCode                AS UnitCode 
         , Object_Unit.ValueData                 AS UnitName
         , Object_Juridical.Id                   AS JuridicalId
         , Object_Juridical.Valuedata            AS JuridicalName
         , COALESCE (ObjectBoolean_OrderPromo.ValueData, FALSE) :: Boolean AS isOrderPromo
    FROM tmpUnit
        LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpUnit.Unitid
        LEFT JOIN ObjectLink AS ObjectLinkJuridical 
                             ON Object_Unit.id = ObjectLinkJuridical.objectid 
                            AND ObjectLinkJuridical.descid = zc_ObjectLink_Unit_Juridical()
        LEFT JOIN Object AS Object_Juridical ON Object_Juridical.id = ObjectLinkJuridical.childobjectid
        
        LEFT JOIN ObjectBoolean AS ObjectBoolean_OrderPromo
                                ON ObjectBoolean_OrderPromo.ObjectId = Object_Unit.Id
                               AND ObjectBoolean_OrderPromo.DescId = zc_ObjectBoolean_Unit_OrderPromo()
    WHERE COALESCE (ObjectBoolean_OrderPromo.ValueData, FALSE) = TRUE
       OR inisShowAll = TRUE
    ;
            
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.05.20         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_UnitForOrderInternalPromo (false, '2')