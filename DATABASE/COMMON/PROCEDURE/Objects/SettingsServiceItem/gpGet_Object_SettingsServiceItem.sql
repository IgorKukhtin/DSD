-- Function: gpGet_Object_SettingsServiceItem(Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_SettingsServiceItem(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_SettingsServiceItem(
    IN inId                       Integer,       -- ключ объекта <Бизнесы>
/*
    IN inSettingsServiceId        Integer,       --
    IN inInfoMoneyDestinationId   Integer,       --
*/    
    IN inSession                  TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , SettingsServiceId Integer, SettingsServiceName TVarChar
             , InfoMoneyDestinationId Integer, InfoMoneyDestinationName TVarChar
             ) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());


   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id

           , CAST (0 as Integer)     AS SettingsServiceId
           , CAST ('' as TVarChar)   AS SettingsServiceName
 
           , CAST (0 as Integer)     AS InfoMoneyDestinationId
           , CAST ('' as TVarChar)   AS InfoMoneyDestinationName
       ;

   ELSE
       RETURN QUERY 
       SELECT 
             Object_SettingsServiceItem.Id

           , Object_SettingsService.Id         AS SettingsServiceId
           , Object_SettingsService.ValueData  AS SettingsServiceName

           , Object_InfoMoneyDestination.Id         AS InfoMoneyDestinationId
           , Object_InfoMoneyDestination.ValueData  AS InfoMoneyDestinationName
  
       FROM Object AS Object_SettingsServiceItem
            LEFT JOIN ObjectLink AS ObjectLink_SettingsService
                                 ON ObjectLink_SettingsService.ObjectId = Object_SettingsServiceItem.Id
                                AND ObjectLink_SettingsService.DescId = zc_ObjectLink_SettingsServiceItem_SettingsService()
            LEFT JOIN Object AS Object_SettingsService ON Object_SettingsService.Id = ObjectLink_SettingsService.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_InfoMoneyDestination
                                 ON ObjectLink_InfoMoneyDestination.ObjectId = Object_SettingsServiceItem.Id
                                AND ObjectLink_InfoMoneyDestination.DescId = zc_ObjectLink_SettingsServiceItem_InfoMoneyDestination()
            LEFT JOIN Object AS Object_InfoMoneyDestination ON Object_InfoMoneyDestination.Id = ObjectLink_InfoMoneyDestination.ChildObjectId

       WHERE Object_SettingsServiceItem.Id = inId;
   END IF;
     
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.01.19         *
*/

-- тест
-- SELECT * FROM gpGet_Object_SettingsServiceItem(1,'2')