-- Function: gpSelect_Object_WorkTimeKind_Holiday (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_WorkTimeKind_Holiday (Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_WorkTimeKind_Holiday(
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
             , isErased Boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_WorkTimeKind());

   RETURN QUERY 
   SELECT
        tmpWorkTimeKind.Id 
      , tmpWorkTimeKind.Code
      , tmpWorkTimeKind.Name
      , tmpWorkTimeKind.ShortName 
      , tmpWorkTimeKind.Value
      , tmpWorkTimeKind.EnumName
      , tmpWorkTimeKind.Tax
      , tmpWorkTimeKind.Summ
      , tmpWorkTimeKind.isNoSheetChoice
      , tmpWorkTimeKind.isErased
   FROM gpSelect_Object_WorkTimeKind (TRUE, inisErased, inSession) AS tmpWorkTimeKind
   WHERE tmpWorkTimeKind.Id IN (zc_Enum_WorkTimeKind_HolidayNoZp(), zc_Enum_WorkTimeKind_Holiday())
   ;
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.08.21         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_WorkTimeKind_Holiday(false, true, '2')