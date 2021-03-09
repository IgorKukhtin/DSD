-- Function: gpSelect_MovementItem_ProfitLossResult()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_ProfitLossResult (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_ProfitLossResult(
    IN inMovementId  Integer      , -- ключ Документа
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, AccountId Integer, AccountCode Integer, AccountName TVarChar
             , ContainerId TFloat
             , Amount TFloat
             , BranchId Integer, BranchName TVarChar
             , ProfitLossId Integer, ProfitLossName TVarChar
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

       -- Результат
       SELECT
             MovementItem.Id            AS Id
           , Object_Account.Id          AS AccountId
           , Object_Account.ObjectCode  AS AccountCode
           , Object_Account.ValueData   AS AccountName

           , MIFloat_ContainerId.ValueData :: TFloat AS ContainerId
           , MovementItem.Amount           :: TFloat AS Amount
           
           , Object_Branch.Id            :: Integer  AS BranchId
           , Object_Branch.ValueData     :: TVarChar AS BranchName
           , Object_ProfitLoss.Id        :: Integer  AS ProfitLossId
           , Object_ProfitLoss.ValueData :: TVarChar AS ProfitLossName
           , MovementItem.isErased                   AS isErased

       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
            INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                   AND MovementItem.DescId     = zc_MI_Master()
                                   AND MovementItem.isErased   = tmpIsErased.isErased

            LEFT JOIN Object AS Object_Account ON Object_Account.Id = MovementItem.ObjectId
             
            LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                        ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                       AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()
            
            LEFT JOIN ContainerLinkObject AS CLO_ProfitLoss
                                          ON CLO_ProfitLoss.ContainerId = CAST (MIFloat_ContainerId.ValueData AS NUMERIC (16,0))
                                         AND CLO_ProfitLoss.DescId = zc_ContainerLinkObject_ProfitLoss()
            LEFT JOIN Object AS Object_ProfitLoss ON Object_ProfitLoss.Id = CLO_ProfitLoss.ObjectId

            LEFT JOIN ContainerLinkObject AS CLO_Branch
                                          ON CLO_Branch.ContainerId = CAST (MIFloat_ContainerId.ValueData AS NUMERIC (16,0))
                                         AND CLO_Branch.DescId = zc_ContainerLinkObject_Branch()
            LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = CLO_Branch.ObjectId
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