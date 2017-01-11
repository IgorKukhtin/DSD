-- View: Object_ProfitLoss_View
--DROP VIEW IF EXISTS Object_ProfitLoss_View CASCADE;

CREATE OR REPLACE VIEW Object_ProfitLoss_View
AS
      SELECT Object_ProfitLossGroup.Id            AS ProfitLossGroupId
           , Object_ProfitLossGroup.ObjectCode    AS ProfitLossGroupCode
           , CAST ((CASE WHEN Object_ProfitLossGroup.ObjectCode < 100000 THEN '' ELSE '' END || Object_ProfitLossGroup.ObjectCode || ' ' || Object_ProfitLossGroup.ValueData) AS TVarChar) AS ProfitLossGroupName
           , Object_ProfitLossGroup.ValueData     AS ProfitLossGroupName_original
          
           , Object_ProfitLossDirection.Id           AS ProfitLossDirectionId
           , Object_ProfitLossDirection.ObjectCode   AS ProfitLossDirectionCode
           , CAST ((CASE WHEN Object_ProfitLossDirection.ObjectCode < 100000 THEN '' ELSE '' END || Object_ProfitLossDirection.ObjectCode || ' ' || Object_ProfitLossDirection.ValueData) AS TVarChar) AS ProfitLossDirectionName
           , Object_ProfitLossDirection.ValueData    AS ProfitLossDirectionName_original

           , Object_ProfitLoss.Id           AS ProfitLossId
           , Object_ProfitLoss.ObjectCode   AS ProfitLossCode
           , CAST ((CASE WHEN Object_ProfitLoss.ObjectCode < 100000 THEN '' ELSE '' END || Object_ProfitLoss.ObjectCode || ' ' || Object_ProfitLoss.ValueData) AS TVarChar) AS ProfitLossName
           , Object_ProfitLoss.ValueData    AS ProfitLossName_original
          
           , ObjectBoolean_onComplete.ValueData AS onComplete

           , CAST (CASE WHEN Object_ProfitLoss.ObjectCode < 100000
                          THEN ''
                     ELSE ''
                   END
                || Object_ProfitLoss.ObjectCode || ' '
                || Object_ProfitLossGroup.ValueData
                || CASE WHEN Object_ProfitLossDirection.ValueData <> Object_ProfitLossGroup.ValueData
                             THEN ' ' || Object_ProfitLossDirection.ValueData
                        ELSE ''
                   END
                || CASE WHEN Object_ProfitLoss.ValueData <> Object_ProfitLossDirection.ValueData
                             THEN ' ' || Object_ProfitLoss.ValueData
                        ELSE ''
                   END
                   AS TVarChar) AS ProfitLossName_all

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

ALTER TABLE Object_ProfitLoss_View OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 12.01.17         *
 21.10.13                        *
*/

-- тест
-- SELECT * FROM Object_ProfitLoss_View ORDER BY ProfitLossCode