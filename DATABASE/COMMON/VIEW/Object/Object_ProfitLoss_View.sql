-- View: Object_ProfitLoss_View

-- DROP VIEW IF EXISTS Object_ProfitLoss_View;

CREATE OR REPLACE VIEW Object_ProfitLoss_View AS
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

ALTER TABLE Object_ProfitLoss_View  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».
 21.10.13                        *
*/

-- ÚÂÒÚ
-- SELECT * FROM Object_Contract_View