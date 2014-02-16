-- Function: lfSelect_Object_ProfitLoss ()

-- DROP FUNCTION lfSelect_Object_ProfitLoss ();

CREATE OR REPLACE FUNCTION lfSelect_Object_ProfitLoss()

RETURNS TABLE (ProfitLossGroupId Integer, ProfitLossGroupCode Integer, ProfitLossGroupName TVarChar, 
               ProfitLossDirectionId Integer, ProfitLossDirectionCode Integer, ProfitLossDirectionName TVarChar, 
               ProfitLossId Integer, ProfitLossCode Integer, ProfitLossName TVarChar, onComplete boolean) AS
   
$BODY$
BEGIN

     -- Выбираем данные для справочника Статьи отчета о прибылях и убытках (на самом деле это три справочника)
     RETURN QUERY 
     SELECT 
           Object_ProfitLossGroup.Id            AS ProfitLossGroupId
          ,Object_ProfitLossGroup.ObjectCode    AS ProfitLossGroupCode
          ,Object_ProfitLossGroup.ValueData     AS ProfitLossGroupName
          
          ,Object_ProfitLossDirection.Id           AS ProfitLossDirectionId
          ,Object_ProfitLossDirection.ObjectCode   AS ProfitLossDirectionCode
          ,Object_ProfitLossDirection.ValueData    AS ProfitLossDirectionName
          
          ,Object_ProfitLoss.Id           AS ProfitLossId
          ,Object_ProfitLoss.ObjectCode   AS ProfitLossCode
          ,Object_ProfitLoss.ValueData    AS ProfitLossName
          
          ,ObjectBoolean_onComplete.ValueData AS onComplete

     FROM Object AS Object_ProfitLoss
          LEFT JOIN ObjectLink AS ObjectLink_ProfitLoss_ProfitLossGroup
                               ON ObjectLink_ProfitLoss_ProfitLossGroup.ObjectId = Object_ProfitLoss.Id 
                              AND ObjectLink_ProfitLoss_ProfitLossGroup.DescId = zc_ObjectLink_ProfitLoss_ProfitLossGroup()
          LEFT JOIN Object AS Object_ProfitLossGroup ON Object_ProfitLossGroup.Id = ObjectLink_ProfitLoss_ProfitLossGroup.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_ProfitLoss_ProfitLossDirection
                               ON ObjectLink_ProfitLoss_ProfitLossDirection.ObjectId = Object_ProfitLoss.Id 
                              AND ObjectLink_ProfitLoss_ProfitLossDirection.DescId = zc_ObjectLink_ProfitLoss_ProfitLossDirection()
          LEFT JOIN Object AS Object_ProfitLossDirection ON Object_ProfitLossDirection.Id = ObjectLink_ProfitLoss_ProfitLossDirection.ChildObjectId
       
          LEFT JOIN ObjectBoolean AS ObjectBoolean_onComplete
                                  ON ObjectBoolean_onComplete.ObjectId = Object_ProfitLoss.Id 
                                 AND ObjectBoolean_onComplete.DescId = zc_ObjectBoolean_ProfitLoss_onComplete()
     WHERE Object_ProfitLoss.DescId = zc_Object_ProfitLoss();
          
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lfSelect_Object_ProfitLoss () OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.07.13          * +  onComplete                         
 29.06.13          *                            
*/
-- тест
-- SELECT * FROM lfSelect_Object_ProfitLoss()
