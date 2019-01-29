-- Function: gpSelect_Object_SettingsServiceItem()

DROP FUNCTION IF EXISTS gpSelect_Object_SettingsServiceItem (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_SettingsServiceItem (
    IN inSettingsServiceId    Integer,
    IN inisShowAll            Boolean, 
    IN inSession              TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , SettingsServiceId Integer
             , InfoMoneyGroupId Integer
             , InfoMoneyGroupCode Integer
             , InfoMoneyGroupName TVarChar
             , InfoMoneyDestinationId Integer
             , InfoMoneyDestinationCode Integer
             , InfoMoneyDestinationName TVarChar
             , InfoMoneyId Integer
             , InfoMoneyCode Integer
             , InfoMoneyName TVarChar
             , isSave Boolean
             , isErased Boolean
              )
AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_SettingsServiceItem());

   IF inisShowAll THEN
    
   RETURN QUERY 
   WITH
   tmpInfoMoney AS (SELECT Object_InfoMoney_View.InfoMoneyGroupId
                         , Object_InfoMoney_View.InfoMoneyGroupCode
                         , Object_InfoMoney_View.InfoMoneyGroupName
                         , Object_InfoMoney_View.InfoMoneyDestinationId
                         , Object_InfoMoney_View.InfoMoneyDestinationCode
                         , Object_InfoMoney_View.InfoMoneyDestinationName
                         , Object_InfoMoney_View.InfoMoneyId
                         , Object_InfoMoney_View.InfoMoneyCode
                         , Object_InfoMoney_View.InfoMoneyName
                    FROM Object_InfoMoney_View
                    GROUP BY Object_InfoMoney_View.InfoMoneyGroupId
                           , Object_InfoMoney_View.InfoMoneyGroupCode
                           , Object_InfoMoney_View.InfoMoneyGroupName
                           , Object_InfoMoney_View.InfoMoneyDestinationId
                         , Object_InfoMoney_View.InfoMoneyDestinationCode
                         , Object_InfoMoney_View.InfoMoneyDestinationName
                         , Object_InfoMoney_View.InfoMoneyId
                         , Object_InfoMoney_View.InfoMoneyCode
                         , Object_InfoMoney_View.InfoMoneyName
                   )

    SELECT COALESCE (Object_SettingsServiceItem.Id,0)    AS Id
         , Object_SettingsService.Id      AS SettingsServiceId
         , tmpInfoMoney.InfoMoneyGroupId
         , tmpInfoMoney.InfoMoneyGroupCode
         , tmpInfoMoney.InfoMoneyGroupName
         , tmpInfoMoney.InfoMoneyDestinationId
         , tmpInfoMoney.InfoMoneyDestinationCode
         , tmpInfoMoney.InfoMoneyDestinationName
         , tmpInfoMoney.InfoMoneyId
         , tmpInfoMoney.InfoMoneyCode
         , tmpInfoMoney.InfoMoneyName
         , CASE WHEN Object_SettingsServiceItem.Id IS NULL OR Object_SettingsServiceItem.isErased = TRUE THEN FALSE ELSE TRUE END AS isSave
         , Object_SettingsServiceItem.isErased         AS isErased
        
    FROM Object AS Object_SettingsService
        LEFT JOIN tmpInfoMoney ON 1 = 1
        
        LEFT JOIN ObjectLink AS ObjectLink_InfoMoneyDestination
                             ON ObjectLink_InfoMoneyDestination.DescId = zc_ObjectLink_SettingsServiceItem_InfoMoneyDestination()
                            AND ObjectLink_InfoMoneyDestination.ChildObjectId = tmpInfoMoney.InfoMoneyDestinationId 

        LEFT JOIN ObjectLink AS ObjectLink_SettingsService
                             ON ObjectLink_SettingsService.ChildObjectId = Object_SettingsService.Id
                            AND ObjectLink_SettingsService.DescId = zc_ObjectLink_SettingsServiceItem_SettingsService()
                            AND ObjectLink_SettingsService.ObjectId = ObjectLink_InfoMoneyDestination.ObjectId

        LEFT JOIN Object AS Object_SettingsServiceItem 
                         ON Object_SettingsServiceItem.Id = ObjectLink_SettingsService.ObjectId
        
    WHERE Object_SettingsService.DescId = zc_Object_SettingsService()
      AND (Object_SettingsService.Id = inSettingsServiceId OR inSettingsServiceId = 0)
    ;

   ELSE
   -- Результат другой
   RETURN QUERY
   WITH
   tmpInfoMoney AS (SELECT Object_InfoMoney_View.InfoMoneyGroupId
                         , Object_InfoMoney_View.InfoMoneyGroupCode
                         , Object_InfoMoney_View.InfoMoneyGroupName
                         , Object_InfoMoney_View.InfoMoneyDestinationId
                         , Object_InfoMoney_View.InfoMoneyDestinationCode
                         , Object_InfoMoney_View.InfoMoneyDestinationName
                         , Object_InfoMoney_View.InfoMoneyId
                         , Object_InfoMoney_View.InfoMoneyCode
                         , Object_InfoMoney_View.InfoMoneyName
                    FROM Object_InfoMoney_View
                    GROUP BY Object_InfoMoney_View.InfoMoneyGroupId
                           , Object_InfoMoney_View.InfoMoneyGroupCode
                           , Object_InfoMoney_View.InfoMoneyGroupName
                           , Object_InfoMoney_View.InfoMoneyDestinationId
                         , Object_InfoMoney_View.InfoMoneyDestinationCode
                         , Object_InfoMoney_View.InfoMoneyDestinationName
                         , Object_InfoMoney_View.InfoMoneyId
                         , Object_InfoMoney_View.InfoMoneyCode
                         , Object_InfoMoney_View.InfoMoneyName
                   )

        SELECT Object_SettingsServiceItem.Id             AS Id
             , ObjectLink_SettingsService.ChildObjectId  AS SettingsServiceId
             , tmpInfoMoney.InfoMoneyGroupId
             , tmpInfoMoney.InfoMoneyGroupCode
             , tmpInfoMoney.InfoMoneyGroupName
             , tmpInfoMoney.InfoMoneyDestinationId
             , tmpInfoMoney.InfoMoneyDestinationCode
             , tmpInfoMoney.InfoMoneyDestinationName
             , tmpInfoMoney.InfoMoneyId
             , tmpInfoMoney.InfoMoneyCode
             , tmpInfoMoney.InfoMoneyName
             , CASE WHEN Object_SettingsServiceItem.isErased = TRUE THEN FALSE ELSE TRUE END AS isSave
             , Object_SettingsServiceItem.isErased       AS isErased
            
        FROM Object AS Object_SettingsServiceItem

            INNER JOIN ObjectLink AS ObjectLink_SettingsService
                                  ON ObjectLink_SettingsService.ObjectId = Object_SettingsServiceItem.Id
                                 AND ObjectLink_SettingsService.DescId = zc_ObjectLink_SettingsServiceItem_SettingsService()
                                 AND (ObjectLink_SettingsService.ChildObjectId = inSettingsServiceId OR inSettingsServiceId = 0)

            INNER JOIN ObjectLink AS ObjectLink_InfoMoneyDestination
                                  ON ObjectLink_InfoMoneyDestination.ObjectId = Object_SettingsServiceItem.Id
                                 AND ObjectLink_InfoMoneyDestination.DescId = zc_ObjectLink_SettingsServiceItem_InfoMoneyDestination()
            LEFT JOIN tmpInfoMoney ON tmpInfoMoney.InfoMoneyDestinationId = ObjectLink_InfoMoneyDestination.ChildObjectId

        WHERE Object_SettingsServiceItem.DescId = zc_Object_SettingsServiceItem()
           AND (Object_SettingsServiceItem.Id = inSettingsServiceId OR inSettingsServiceId = 0);
        END IF;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.01.19         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_SettingsServiceItem (0, true, '2'::TVarChar)
