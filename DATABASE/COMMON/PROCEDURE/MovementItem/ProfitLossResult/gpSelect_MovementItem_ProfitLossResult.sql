-- Function: gpSelect_MovementItem_ProfitLossResult()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_ProfitLossResult (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_ProfitLossResult(
    IN inMovementId  Integer      , -- ключ Документа
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, AccountId Integer, AccountCode Integer, AccountName TVarChar
             , ContainerId TFloat
             , Amount TFloat, Amount_debet TFloat, Amount_kredit TFloat
             , BranchId Integer, BranchName TVarChar
             , BusinessId Integer, BusinessName TVarChar
             , JuridicalBasisId Integer, JuridicalBasisName TVarChar
             , ProfitLossId Integer, ProfitLossCode Integer, ProfitLossName TVarChar
             , ProfitLossGroupId Integer, ProfitLossGroupCode Integer, ProfitLossGroupName TVarChar
             , ProfitLossDirectionId Integer, ProfitLossDirectionCode Integer, ProfitLossDirectionName TVarChar
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_ProfitLossResult());
     vbUserId:= lpGetUserBySession (inSession);

    -- Результат
     RETURN QUERY
       WITH
       tmpMI AS (SELECT MovementItem.*
                 FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                      INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                             AND MovementItem.DescId     = zc_MI_Master()
                                             AND MovementItem.isErased   = tmpIsErased.isErased
                 )
     , tmpMovementItemFloat AS (SELECT MovementItemFloat.*
                                FROM MovementItemFloat
                                WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                  AND MovementItemFloat.DescId = zc_MIFloat_ContainerId()
                                )
     , tmpContainerLinkObject AS (SELECT ContainerLinkObject.*
                                  FROM ContainerLinkObject
                                  WHERE ContainerLinkObject.ContainerId IN (SELECT DISTINCT CAST (tmpMovementItemFloat.ValueData AS NUMERIC (16,0)) FROM tmpMovementItemFloat)
                                    AND ContainerLinkObject.DescId IN (zc_ContainerLinkObject_ProfitLoss()
                                                                     , zc_ContainerLinkObject_Branch()
                                                                     , zc_ContainerLinkObject_JuridicalBasis()
                                                                     , zc_ContainerLinkObject_Business())
                                  )

       -- Результат
       SELECT
             MovementItem.Id            AS Id
           , Object_Account.Id          AS AccountId
           , Object_Account.ObjectCode  AS AccountCode
           , Object_Account.ValueData   AS AccountName

           , MIFloat_ContainerId.ValueData :: TFloat AS ContainerId
           , COALESCE (MovementItem.Amount,0) :: TFloat AS Amount
           , CASE WHEN COALESCE (MovementItem.Amount,0) > 0 THEN MovementItem.Amount ELSE 0 END :: TFloat AS Amount_debet
           , CASE WHEN COALESCE (MovementItem.Amount,0) < 0 THEN MovementItem.Amount * (-1) ELSE 0 END :: TFloat AS Amount_kredit

           , Object_Branch.Id                :: Integer  AS BranchId
           , Object_Branch.ValueData         :: TVarChar AS BranchName
           , Object_Business.Id              :: Integer  AS BusinessId
           , Object_Business.ValueData       :: TVarChar AS BusinessName
           , Object_JuridicalBasis.Id        :: Integer  AS JuridicalBasisId
           , Object_JuridicalBasis.ValueData :: TVarChar AS JuridicalBasisName

           , Object_ProfitLoss.Id         :: Integer  AS ProfitLossId
           , Object_ProfitLoss.ObjectCode :: Integer  AS ProfitLossCode
           , Object_ProfitLoss.ValueData  :: TVarChar AS ProfitLossName

           , Object_ProfitLossGroup.Id          AS ProfitLossGroupId
           , Object_ProfitLossGroup.ObjectCode  AS ProfitLossGroupCode
           , Object_ProfitLossGroup.ValueData   AS ProfitLossGroupName
           
           , Object_ProfitLossDirection.Id          AS ProfitLossDirectionId
           , Object_ProfitLossDirection.ObjectCode  AS ProfitLossDirectionCode
           , Object_ProfitLossDirection.ValueData   AS ProfitLossDirectionName

           , MovementItem.isErased                  AS isErased

       FROM tmpMI AS MovementItem

            LEFT JOIN Object AS Object_Account ON Object_Account.Id = MovementItem.ObjectId
             
            LEFT JOIN tmpMovementItemFloat AS MIFloat_ContainerId
                                           ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                          AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()
            
            LEFT JOIN tmpContainerLinkObject AS CLO_ProfitLoss
                                             ON CLO_ProfitLoss.ContainerId = CAST (MIFloat_ContainerId.ValueData AS NUMERIC (16,0))
                                            AND CLO_ProfitLoss.DescId = zc_ContainerLinkObject_ProfitLoss()
            LEFT JOIN Object AS Object_ProfitLoss ON Object_ProfitLoss.Id = CLO_ProfitLoss.ObjectId

            LEFT JOIN tmpContainerLinkObject AS CLO_Branch
                                             ON CLO_Branch.ContainerId = CAST (MIFloat_ContainerId.ValueData AS NUMERIC (16,0))
                                            AND CLO_Branch.DescId = zc_ContainerLinkObject_Branch()
            LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = CLO_Branch.ObjectId

            LEFT JOIN tmpContainerLinkObject AS CLO_JuridicalBasis
                                             ON CLO_JuridicalBasis.ContainerId = CAST (MIFloat_ContainerId.ValueData AS NUMERIC (16,0))
                                            AND CLO_JuridicalBasis.DescId = zc_ContainerLinkObject_JuridicalBasis()
            LEFT JOIN Object AS Object_JuridicalBasis ON Object_JuridicalBasis.Id = CLO_JuridicalBasis.ObjectId

            LEFT JOIN tmpContainerLinkObject AS CLO_Business
                                             ON CLO_Business.ContainerId = CAST (MIFloat_ContainerId.ValueData AS NUMERIC (16,0))
                                            AND CLO_Business.DescId = zc_ContainerLinkObject_Business()
            LEFT JOIN Object AS Object_Business ON Object_Business.Id = CLO_Business.ObjectId

            ---
            LEFT JOIN ObjectLink AS ObjectLink_ProfitLoss_ProfitLossGroup
                                 ON ObjectLink_ProfitLoss_ProfitLossGroup.ObjectId = Object_ProfitLoss.Id
                                AND ObjectLink_ProfitLoss_ProfitLossGroup.DescId = zc_ObjectLink_ProfitLoss_ProfitLossGroup()
            LEFT JOIN Object AS Object_ProfitLossGroup ON Object_ProfitLossGroup.Id = ObjectLink_ProfitLoss_ProfitLossGroup.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_ProfitLoss_ProfitLossDirection
                                 ON ObjectLink_ProfitLoss_ProfitLossDirection.ObjectId = Object_ProfitLoss.Id
                                AND ObjectLink_ProfitLoss_ProfitLossDirection.DescId = zc_ObjectLink_ProfitLoss_ProfitLossDirection()
            LEFT JOIN Object AS Object_ProfitLossDirection ON Object_ProfitLossDirection.Id = ObjectLink_ProfitLoss_ProfitLossDirection.ChildObjectId
            ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.03.21         *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_ProfitLossResult (inMovementId:= 25173, inIsErased:= FALSE, inSession:= '9818')
-- SELECT * FROM gpSelect_MovementItem_ProfitLossResult (inMovementId:= 25173, inIsErased:= FALSE, inSession:= '2')