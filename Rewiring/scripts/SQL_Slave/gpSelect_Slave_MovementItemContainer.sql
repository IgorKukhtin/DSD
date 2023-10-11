-- Function: _replica.gpSelect_Slave_RewiringProtocol()

DROP FUNCTION IF EXISTS _replica.gpSelect_Slave_MovementItemContainer (TVarChar);

CREATE OR REPLACE FUNCTION _replica.gpSelect_Slave_MovementItemContainer (
  IN inSession   TVarChar
)
RETURNS TABLE (Id             BIGINT

             , DescId         INTEGER
             , MovementId     INTEGER
             , ContainerId    INTEGER
             , Amount         TFloat 
             , OperDate       TDateTime
             , MovementItemId Integer
             , ParentId       BigInt
             , isActive       Boolean  

             , MovementDescId integer
             , AnalyzerId integer
             , AccountId integer
             , ObjectId_analyzer integer
             , WhereObjectId_analyzer integer
             , ContainerId_analyzer integer

             , ObjectIntId_analyzer integer
             , ObjectExtId_analyzer integer
               
             , ContainerIntId_analyzer integer
             , AccountId_analyzer integer
) AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   vbUserId:= inSession::Integer;


   -- Результат
   RETURN QUERY 
   SELECT MovementItemContainer_Rewiring.Id

        , MovementItemContainer_Rewiring.DescId
        , MovementItemContainer_Rewiring.MovementId
        , MovementItemContainer_Rewiring.ContainerId
        , MovementItemContainer_Rewiring.Amount
        , MovementItemContainer_Rewiring.OperDate
        , MovementItemContainer_Rewiring.MovementItemId
        , MovementItemContainer_Rewiring.ParentId
        , MovementItemContainer_Rewiring.isActive

        , MovementItemContainer_Rewiring.MovementDescId
        , MovementItemContainer_Rewiring.AnalyzerId
        , MovementItemContainer_Rewiring.AccountId
        , MovementItemContainer_Rewiring.ObjectId_analyzer
        , MovementItemContainer_Rewiring.WhereObjectId_analyzer
        , MovementItemContainer_Rewiring.ContainerId_analyzer

        , MovementItemContainer_Rewiring.ObjectIntId_analyzer
        , MovementItemContainer_Rewiring.ObjectExtId_analyzer
       
        , MovementItemContainer_Rewiring.ContainerIntId_analyzer
        , MovementItemContainer_Rewiring.AccountId_analyzer

   FROM _replica.RewiringProtocol
        LEFT JOIN _replica.MovementItemContainer_Rewiring ON MovementItemContainer_Rewiring.Transaction_Id = RewiringProtocol.Transaction_Id
                                                         AND MovementItemContainer_Rewiring.MovementId = RewiringProtocol.MovementId
   WHERE RewiringProtocol.isErrorRewiring = FALSE
     AND RewiringProtocol.isProcessed = FALSE
   ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

-- 
SELECT * FROM _replica.gpSelect_Slave_MovementItemContainer (zfCalc_UserAdmin());

