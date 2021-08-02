-- Function: gpSelect_Unit_PauseDistribListDiff()

DROP FUNCTION IF EXISTS gpSelect_Unit_PauseDistribListDiff(Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Unit_PauseDistribListDiff(
    IN inisShowAll   Boolean,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, UnitCode Integer, UnitName TVarChar
             , isPauseDistribListDiff  Boolean, isRequestDistribListDiff Boolean  
) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Unit());


   RETURN QUERY 
    SELECT 
        Object_Unit.Id                                       AS Id
      , Object_Unit.ObjectCode                               AS UnitCode
      , Object_Unit.ValueData                                AS UnitName

      , COALESCE (ObjectBoolean_PauseDistribListDiff.ValueData, FALSE)    :: Boolean     AS isPauseDistribListDiff
      , COALESCE (ObjectBoolean_RequestDistribListDiff.ValueData, FALSE)  :: Boolean     AS isRequestDistribListDiff

    FROM Object AS Object_Unit

         INNER JOIN ObjectBoolean AS ObjectBoolean_ParticipDistribListDiff
                                 ON ObjectBoolean_ParticipDistribListDiff.ObjectId = Object_Unit.Id
                                AND ObjectBoolean_ParticipDistribListDiff.DescId = zc_ObjectBoolean_Unit_ParticipDistribListDiff()
                                AND ObjectBoolean_ParticipDistribListDiff.ValueData = True
         LEFT JOIN ObjectBoolean AS ObjectBoolean_PauseDistribListDiff
                                 ON ObjectBoolean_PauseDistribListDiff.ObjectId = Object_Unit.Id
                                AND ObjectBoolean_PauseDistribListDiff.DescId = zc_ObjectBoolean_Unit_PauseDistribListDiff()
         LEFT JOIN ObjectBoolean AS ObjectBoolean_RequestDistribListDiff
                                 ON ObjectBoolean_RequestDistribListDiff.ObjectId = Object_Unit.Id
                                AND ObjectBoolean_RequestDistribListDiff.DescId = zc_ObjectBoolean_Unit_RequestDistribListDiff()

    WHERE Object_Unit.DescId = zc_Object_Unit()
      AND Object_Unit.isErased = False
      AND (inisShowAll = True OR COALESCE (ObjectBoolean_PauseDistribListDiff.ValueData, FALSE) = True OR COALESCE (ObjectBoolean_RequestDistribListDiff.ValueData, FALSE) = True);
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpSelect_Object_Unit(TVarChar) OWNER TO postgres;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 29.07.21                                                       *
*/

-- тест
-- select * from gpSelect_Unit_PauseDistribListDiff(inisShowAll := 'True' ,  inSession := '3');