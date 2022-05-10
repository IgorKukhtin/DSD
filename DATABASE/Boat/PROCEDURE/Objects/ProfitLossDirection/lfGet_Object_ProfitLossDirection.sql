-- Function: lfGet_Object_ProfitLossDirection ()

-- DROP FUNCTION lfGet_Object_ProfitLossDirection (Integer);

CREATE OR REPLACE FUNCTION lfGet_Object_ProfitLossDirection (IN inId Integer)

RETURNS TABLE (ProfitLossGroupId Integer, ProfitLossDirectionId Integer) AS
   
$BODY$
BEGIN

     RETURN QUERY 
       SELECT 
              ObjectLink_ProfitLoss_ProfitLossGroup.ChildObjectId AS ProfitLossGroupId
            , Object_ProfitLossDirection.Id AS ProfitLossDirectionId
       FROM Object AS Object_ProfitLossDirection
            LEFT JOIN ObjectLink AS ObjectLink_ProfitLoss_ProfitLossDirection
                                 ON ObjectLink_ProfitLoss_ProfitLossDirection.ChildObjectId = Object_ProfitLossDirection.Id
                                AND ObjectLink_ProfitLoss_ProfitLossDirection.DescId = zc_ObjectLink_ProfitLoss_ProfitLossDirection()
            LEFT JOIN ObjectLink AS ObjectLink_ProfitLoss_ProfitLossGroup
                                 ON ObjectLink_ProfitLoss_ProfitLossGroup.ObjectId = ObjectLink_ProfitLoss_ProfitLossDirection.ObjectId
                                AND ObjectLink_ProfitLoss_ProfitLossGroup.DescId = zc_ObjectLink_ProfitLoss_ProfitLossGroup()
       WHERE Object_ProfitLossDirection.DescId = zc_Object_ProfitLossDirection()
         AND Object_ProfitLossDirection.Id = inId

       GROUP BY ObjectLink_ProfitLoss_ProfitLossGroup.ChildObjectId
              , Object_ProfitLossDirection.Id
       ;

 
END;$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION lfGet_Object_ProfitLossDirection (Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».
 26.08.13                                        *
*/

-- ÚÂÒÚ
-- SELECT _tmp.ProfitLossGroupId, lfProfitLossGroup.ProfitLossGroupCode, lfProfitLossGroup.ProfitLossGroupName, _tmp.ProfitLossDirectionId, lfProfitLossDirection.ProfitLossDirectionCode, lfProfitLossDirection.ProfitLossDirectionName FROM (SELECT * FROM lfGet_Object_ProfitLossDirection (61886)) AS _tmp LEFT JOIN lfSelect_Object_ProfitLossDirection() AS lfProfitLossDirection ON lfProfitLossDirection.ProfitLossDirectionId = _tmp.ProfitLossDirectionId LEFT JOIN lfSelect_Object_ProfitLossGroup() AS lfProfitLossGroup ON lfProfitLossGroup.ProfitLossGroupId = _tmp.ProfitLossGroupId
