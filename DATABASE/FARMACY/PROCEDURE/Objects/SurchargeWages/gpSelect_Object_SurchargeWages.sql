-- Function: gpSelect_Object_SurchargeWages()

DROP FUNCTION IF EXISTS gpSelect_Object_SurchargeWages(Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_SurchargeWages(
    IN inShowAll       Boolean ,	  -- Показать все
    IN inSession       TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,
               UserId Integer, UserName TVarChar,
               UnitId Integer, UnitName TVarChar,
               DateStart TDateTime, DateEnd TDateTime, 
               Summa TFloat,
               Description TVarChar,
               isErased Boolean) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_SurchargeWages());

   RETURN QUERY 
       SELECT 
             Object_SurchargeWages.Id
           , Object_SurchargeWages.ObjectCode
           , Object_SurchargeWages.ValueData
         
           , Object_User.ID                  AS UserId
           , Object_User.ValueData           AS UserName 
           
           , Object_Unit.ID                  AS UnitId
           , Object_Unit.ValueData           AS UnitName 

           , ObjectDate_DateStart.ValueData  AS  DateStart
           , ObjectDate_DateEnd.ValueData    AS  DateEnd

           , ObjectFloat_Summa.ValueData     AS Summa       
           
           , ObjectString_Description.ValueData AS Description         
           
           , Object_SurchargeWages.isErased
           
       FROM Object AS Object_SurchargeWages
       
       
           LEFT JOIN ObjectLink AS ObjectLink_SurchargeWages_User
                                ON ObjectLink_SurchargeWages_User.ObjectId = Object_SurchargeWages.Id
                               AND ObjectLink_SurchargeWages_User.DescId = zc_ObjectLink_SurchargeWages_User()
           LEFT JOIN Object AS Object_User ON Object_User.Id = ObjectLink_SurchargeWages_User.ChildObjectId   
           
           LEFT JOIN ObjectLink AS ObjectLink_SurchargeWages_Unit
                                ON ObjectLink_SurchargeWages_Unit.ObjectId = Object_SurchargeWages.Id
                               AND ObjectLink_SurchargeWages_Unit.DescId = zc_ObjectLink_SurchargeWages_Unit()
           LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_SurchargeWages_Unit.ChildObjectId   

           LEFT JOIN ObjectDate AS ObjectDate_DateStart
                                ON ObjectDate_DateStart.ObjectId = Object_SurchargeWages.Id 
                               AND ObjectDate_DateStart.DescId = zc_ObjectDate_SurchargeWages_DateStart()
           LEFT JOIN ObjectDate AS ObjectDate_DateEnd
                                ON ObjectDate_DateEnd.ObjectId = Object_SurchargeWages.Id 
                               AND ObjectDate_DateEnd.DescId = zc_ObjectDate_SurchargeWages_DateEnd()

           LEFT JOIN ObjectFloat AS ObjectFloat_Summa
                                 ON ObjectFloat_Summa.ObjectId = Object_SurchargeWages.Id 
                                AND ObjectFloat_Summa.DescId = zc_ObjectFloat_SurchargeWages_Summa()
                                
           LEFT JOIN ObjectString AS ObjectString_Description
                                  ON ObjectString_Description.ObjectId = Object_SurchargeWages.Id 
                                 AND ObjectString_Description.DescId = zc_ObjectString_SurchargeWages_Description()
                                
       WHERE Object_SurchargeWages.DescId = zc_Object_SurchargeWages()
         AND (inShowAll = True OR Object_SurchargeWages.isErased = False)
       ORDER BY Object_SurchargeWages.Id
       ;
            
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_SurchargeWages (Boolean, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 25.11.21                                                       *
*/

-- тест
-- 
SELECT * FROM gpSelect_Object_SurchargeWages (True, '3')