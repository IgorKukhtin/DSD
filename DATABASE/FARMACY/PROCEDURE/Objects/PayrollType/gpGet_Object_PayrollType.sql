-- Function: gpGet_Object_PayrollType()

DROP FUNCTION IF EXISTS gpGet_Object_PayrollType(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_PayrollType(
    IN inId          Integer,       -- ключ объекта <>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, ShortName TVarChar
             , PayrollGroupID Integer, PayrollGroupName TVarChar
             , Percent TFloat, MinAccrualAmount TFloat
             , PayrollTypeID Integer, PayrollTypeName TVarChar
             , isErased boolean) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PayrollType());
   
   IF inId < 0
   THEN
     RAISE EXCEPTION 'Ошибка. Изменение служебных записей  запрещено.';
   END IF;

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_PayrollType()) AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST ('' as TVarChar)  AS ShortName
           
           , CAST (0 as Integer)    AS PayrollGroupID
           , CAST ('' as TVarChar)  AS PayrollGroupName
           , CAST (Null as TFloat)  AS Percent
           , CAST (Null as TFloat)  AS MinAccrualAmount 

           , CAST (0 as Integer)    AS PayrollTypeID
           , CAST ('' as TVarChar)  AS PayrollTypeName

           , CAST (NULL AS Boolean) AS isErased;
   ELSE
       RETURN QUERY
       SELECT
             Object_PayrollType.Id                       AS Id
           , Object_PayrollType.ObjectCode               AS Code
           , Object_PayrollType.ValueData                AS Name

           , ObjectString_ShortName.ValueData            AS ShortName

           , Object_PayrollGroup.ID                      AS PayrollGroupID
           , Object_PayrollGroup.ValueData               AS PayrollGroupName
           , ObjectFloat_Percent.ValueData               AS Percent
           , ObjectFloat_MinAccrualAmount.ValueData      AS MinAccrualAmount 

           , Object_AddPayrollType.ID                    AS PayrollTypeID
           , Object_AddPayrollType.ValueData             AS PayrollTypeName

           , Object_PayrollType.isErased                 AS isErased

       FROM Object AS Object_PayrollType
            LEFT JOIN ObjectLink AS ObjectLink_PayrollGroup
                                 ON ObjectLink_PayrollGroup.ObjectId = Object_PayrollType.Id
                                AND ObjectLink_PayrollGroup.DescId = zc_ObjectLink_PayrollType_PayrollGroup()
            LEFT JOIN Object AS Object_PayrollGroup ON Object_PayrollGroup.Id = ObjectLink_PayrollGroup.ChildObjectId
   
            LEFT JOIN ObjectLink AS ObjectLink_AddPayrollType
                                 ON ObjectLink_AddPayrollType.ObjectId = Object_PayrollType.Id
                                AND ObjectLink_AddPayrollType.DescId = zc_ObjectLink_PayrollType_PayrollType()
            LEFT JOIN Object AS Object_AddPayrollType ON Object_AddPayrollType.Id = ObjectLink_AddPayrollType.ChildObjectId

            LEFT JOIN ObjectFloat AS ObjectFloat_Percent
                                  ON ObjectFloat_Percent.ObjectId = Object_PayrollType.Id
                                 AND ObjectFloat_Percent.DescId = zc_ObjectFloat_PayrollType_Percent()

            LEFT JOIN ObjectFloat AS ObjectFloat_MinAccrualAmount
                                  ON ObjectFloat_MinAccrualAmount.ObjectId = Object_PayrollType.Id
                                 AND ObjectFloat_MinAccrualAmount.DescId = zc_ObjectFloat_PayrollType_MinAccrualAmount()

            LEFT JOIN ObjectString AS ObjectString_ShortName
                                   ON ObjectString_ShortName.ObjectId = Object_PayrollType.Id 
                                  AND ObjectString_ShortName.DescId = zc_ObjectString_PayrollType_ShortName()

       WHERE Object_PayrollType.Id = inId;
   END IF;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 02.09.19                                                        *
 22.08.19                                                        *

*/

-- тест
-- SELECT * FROM gpGet_Object_PayrollType (17737396 , '3')