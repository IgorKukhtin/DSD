-- Function: gpSelect_Object_WorkTimeKind (TVarChar)

--DROP FUNCTION IF EXISTS gpSelect_Object_WorkTimeKind (TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_WorkTimeKind (Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_WorkTimeKind(
    IN inisShowAll      Boolean ,      -- 
    IN inisErased       Boolean ,      --
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , ShortName TVarChar
             , Value     TVarChar
             , EnumName  TVarChar
             , Tax       TFloat
             , Summ      TFloat
             , isNoSheetChoice Boolean
             , PairDayId Integer, PairDayName TVarChar
             , isErased Boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_WorkTimeKind());

   RETURN QUERY 
   SELECT
        Object_WorkTimeKind.Id           AS Id 
      , Object_WorkTimeKind.ObjectCode   AS Code
      , Object_WorkTimeKind.ValueData    AS Name
      
      , ObjectString_ShortName.ValueData AS ShortName 
      , zfCalc_ViewWorkHour (0, ObjectString_ShortName.ValueData) AS Value
      , ObjectString_Enum.ValueData      AS EnumName
      , ObjectFloat_Tax.ValueData        AS Tax
      , COALESCE (ObjectFloat_Summ.ValueData,0) ::TFloat AS Summ
      , COALESCE (ObjectBoolean_NoSheetChoice.ValueData, FALSE) ::Boolean AS isNoSheetChoice
      
      , Object_PairDay.Id        AS PairDayId
      , Object_PairDay.ValueData AS PairDayName

      , Object_WorkTimeKind.isErased     AS isErased
      
   FROM OBJECT AS Object_WorkTimeKind
        LEFT JOIN ObjectString AS ObjectString_Enum
                               ON ObjectString_Enum.ObjectId = Object_WorkTimeKind.Id
                              AND ObjectString_Enum.DescId = zc_ObjectString_Enum()

        LEFT JOIN ObjectString AS ObjectString_ShortName
                               ON ObjectString_ShortName.ObjectId = Object_WorkTimeKind.Id
                              AND ObjectString_ShortName.DescId = zc_objectString_WorkTimeKind_ShortName()
                              
        LEFT JOIN ObjectFloat AS ObjectFloat_Tax
                              ON ObjectFloat_Tax.ObjectId = Object_WorkTimeKind.Id
                             AND ObjectFloat_Tax.DescId = zc_ObjectFloat_WorkTimeKind_Tax()
        LEFT JOIN ObjectFloat AS ObjectFloat_Summ
                              ON ObjectFloat_Summ.ObjectId = Object_WorkTimeKind.Id
                             AND ObjectFloat_Summ.DescId = zc_ObjectFloat_WorkTimeKind_Summ()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_NoSheetChoice
                                ON ObjectBoolean_NoSheetChoice.ObjectId = Object_WorkTimeKind.Id
                               AND ObjectBoolean_NoSheetChoice.DescId = zc_ObjectBoolean_WorkTimeKind_NoSheetChoice()

        LEFT JOIN ObjectLink AS ObjectLink_WorkTimeKind_PairDay
                             ON ObjectLink_WorkTimeKind_PairDay.ObjectId = Object_WorkTimeKind.Id 
                            AND ObjectLink_WorkTimeKind_PairDay.DescId = zc_ObjectLink_WorkTimeKind_PairDay()
        LEFT JOIN Object AS Object_PairDay ON Object_PairDay.Id = ObjectLink_WorkTimeKind_PairDay.ChildObjectId

   WHERE Object_WorkTimeKind.DescId = zc_Object_WorkTimeKind()
     AND (COALESCE (ObjectBoolean_NoSheetChoice.ValueData, FALSE) = FALSE OR inisShowAll = TRUE)
     AND (Object_WorkTimeKind.isErased = FALSE OR inisErased = TRUE);
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpSelect_Object_WorkTimeKind (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.11.21         *
 19.08.21         *
 04.06.20         *
 05.12.17         *
 01.10.13         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_WorkTimeKind('2')
-- SELECT * FROM gpSelect_Object_WorkTimeKind(false, true, '2')
