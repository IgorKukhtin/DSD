-- Function: gpGet_Object_Education (Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_Accommodation_Unit (Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Accommodation_Unit(
    IN inId          Integer,        --
    IN inSession     TVarChar        -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Education());

    vbUserId:= lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
        RAISE EXCEPTION 'Не определено подразделение';
    END IF;
    vbUnitId := vbUnitKey::Integer;

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_Accommodation()) AS Code
           , CAST ('' as TVarChar)  AS NAME
           , CAST (NULL AS Boolean) AS isErased;
   ELSE
     RETURN QUERY
     SELECT
           Object_Accommodation.Id             AS Id
         , Object_Accommodation.ObjectCode     AS Code
         , Object_Accommodation.ValueData      AS Name
         , Object_Accommodation.isErased       AS isErased
     FROM OBJECT AS Object_Accommodation
     WHERE Object_Accommodation.Id = inId;
   END IF;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Accommodation_Unit(integer, TVarChar) OWNER TO postgres;


------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 17.08.18         *

*/

-- тест
-- SELECT * FROM gpGet_Object_Accommodation_Unit(0, '3')