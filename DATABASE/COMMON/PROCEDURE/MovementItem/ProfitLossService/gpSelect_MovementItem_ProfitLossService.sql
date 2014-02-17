-- Function: gpSelect_MovementItem_ProfitLossService()
DROP FUNCTION IF EXISTS gpSelect_MovementItem_ProfitLossService (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_ProfitLossService(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inisErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, ObjectId Integer, ObjectCode Integer, ObjectName TVarChar, Amount TFloat
             , Comment TVarChar
             , ContractId Integer, ContractName TVarChar
             , ContractConditionKindId Integer, ContractConditionKindName TVarChar
             , InfoMoneyGroupCode Integer, InfoMoneyGroupName TVarChar
             , InfoMoneyDestinationCode Integer, InfoMoneyDestinationName TVarChar
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , UnitId Integer, UnitName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , BranchId Integer, BranchName TVarChar
             , isErased Boolean
             )
AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_ProfitLossService());

     -- inShowAll:= TRUE;

     IF inShowAll THEN

     RETURN QUERY
       SELECT
             0                          AS Id
           , tmpObject.ObjectId         AS ObjectId
           , tmpObject.ObjectCode       AS ObjectCode
           , tmpObject.ObjectName       AS ObjectName
           , CAST (NULL AS TFloat)      AS Amount
           , CAST (NULL AS TVarChar)    AS Comment
           , CAST (NULL AS Integer)     AS ContractId
           , CAST (NULL AS TVarChar)    AS ContractName
           , CAST (NULL AS Integer)     AS ContractConditionKindId
           , CAST (NULL AS TVarChar)    AS ContractConditionKindName
           , CAST (NULL AS Integer)     AS InfoMoneyGroupCode
           , CAST (NULL AS TVarChar)    AS InfoMoneyGroupName
           , CAST (NULL AS Integer)     AS InfoMoneyDestinationCode
           , CAST (NULL AS TVarChar)    AS InfoMoneyDestinationName
           , CAST (NULL AS Integer)     AS InfoMoneyId
           , CAST (NULL AS Integer)     AS InfoMoneyCode
           , CAST (NULL AS TVarChar)    AS InfoMoneyName
           , CAST (NULL AS Integer)     AS UnitId
           , CAST (NULL AS TVarChar)    AS UnitName
           , CAST (NULL AS Integer)     AS PaidKindId
           , CAST (NULL AS TVarChar)    AS PaidKindName
           , CAST (NULL AS Integer)     AS BranchId
           , CAST (NULL AS TVarChar)    AS BranchName
           , FALSE                      AS isErased

       FROM (SELECT Object_By.Id                                                   AS ObjectId
                  , Object_By.ObjectCode                                           AS ObjectCode
                  , Object_By.ValueData                                            AS ObjectName
             FROM Object AS Object_By
             WHERE Object_By.DescId IN (zc_Object_Juridical(), zc_Object_Member())
            ) AS tmpObject
            LEFT JOIN (SELECT MovementItem.ObjectId                         AS ObjectId
                       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                             AND MovementItem.DescId     = zc_MI_Master()
                                             AND MovementItem.isErased   = tmpIsErased.isErased
                      ) AS tmpMI ON tmpMI.ObjectId     = tmpObject.ObjectId
       WHERE tmpMI.ObjectId IS NULL
      UNION ALL
       SELECT
             MovementItem.Id					            AS Id
           , Object_By.Id          			                AS ObjectId
           , Object_By.ObjectCode  			                AS ObjectCode
           , Object_By.ValueData   			                AS ObjectName
           , MovementItem.Amount				            AS Amount
           , MIString_Comment.ValueData                     AS Comment
           , Object_Contract_View.ContractId                AS ContractId
           , Object_Contract_View.InvNumber                 AS ContractName
           , Object_ContractConditionKind.Id                AS ContractConditionKindId
           , Object_ContractConditionKind.ValueData         AS ContractConditionKindName
           , Object_InfoMoney_View.InfoMoneyGroupCode       AS InfoMoneyGroupCode
           , Object_InfoMoney_View.InfoMoneyGroupName       AS InfoMoneyGroupName
           , Object_InfoMoney_View.InfoMoneyDestinationCode AS InfoMoneyDestinationCode
           , Object_InfoMoney_View.InfoMoneyDestinationName AS InfoMoneyDestinationName
           , Object_InfoMoney_View.InfoMoneyId              AS InfoMoneyId
           , Object_InfoMoney_View.InfoMoneyCode            AS InfoMoneyCode
           , Object_InfoMoney_View.InfoMoneyName            AS InfoMoneyName
           , Object_Unit.Id                                 AS UnitId
           , Object_Unit.ValueData                          AS UnitName
           , Object_PaidKind.Id                             AS PaidKindId
           , Object_PaidKind.ValueData                      AS PaidKindName
           , Object_Branch.Id                               AS BranchId
           , Object_Branch.ValueData                        AS BranchName
           , MovementItem.isErased				            AS isErased

       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
            LEFT JOIN Object AS Object_By ON Object_By.Id = MovementItem.ObjectId
            LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId =  MovementItem.Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                             ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()

            LEFT JOIN Object_Contract_View AS Object_Contract_View
                                           ON Object_Contract_View.ContractId = MILinkObject_Contract.ObjectId


            LEFT JOIN MovementItemLinkObject AS MILinkObject_ContractConditionKind
                                             ON MILinkObject_ContractConditionKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_ContractConditionKind.DescId = zc_MILinkObject_ContractConditionKind()

            LEFT JOIN Object AS Object_ContractConditionKind ON Object_ContractConditionKind.Id = MILinkObject_ContractConditionKind.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                             ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                            AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()

            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = MILinkObject_InfoMoney.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                             ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()

            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MILinkObject_Unit.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PaidKind
                                             ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PaidKind.DescId = zc_MILinkObject_PaidKind()

            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MILinkObject_PaidKind.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Branch
                                             ON MILinkObject_Branch.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Branch.DescId = zc_MILinkObject_Branch()

            LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = MILinkObject_Branch.ObjectId


            ;

     ELSE

     RETURN QUERY
       SELECT
             MovementItem.Id					            AS Id
           , Object_By.Id          			                AS ObjectId
           , Object_By.ObjectCode  			                AS ObjectCode
           , Object_By.ValueData   			                AS ObjectName
           , MovementItem.Amount				            AS Amount
           , MIString_Comment.ValueData                     AS Comment
           , Object_Contract_View.ContractId                AS ContractId
           , Object_Contract_View.InvNumber                 AS ContractName
           , Object_ContractConditionKind.Id                AS ContractConditionKindId
           , Object_ContractConditionKind.ValueData         AS ContractConditionKindName
           , Object_InfoMoney_View.InfoMoneyGroupCode       AS InfoMoneyGroupCode
           , Object_InfoMoney_View.InfoMoneyGroupName       AS InfoMoneyGroupName
           , Object_InfoMoney_View.InfoMoneyDestinationCode AS InfoMoneyDestinationCode
           , Object_InfoMoney_View.InfoMoneyDestinationName AS InfoMoneyDestinationName
           , Object_InfoMoney_View.InfoMoneyId              AS InfoMoneyId
           , Object_InfoMoney_View.InfoMoneyCode            AS InfoMoneyCode
           , Object_InfoMoney_View.InfoMoneyName            AS InfoMoneyName
           , Object_Unit.Id                                 AS UnitId
           , Object_Unit.ValueData                          AS UnitName
           , Object_PaidKind.Id                             AS PaidKindId
           , Object_PaidKind.ValueData                      AS PaidKindName
           , Object_Branch.Id                               AS BranchId
           , Object_Branch.ValueData                        AS BranchName
           , MovementItem.isErased				            AS isErased

       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = tmpIsErased.isErased
            LEFT JOIN Object AS Object_By ON Object_By.Id = MovementItem.ObjectId
            LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId =  MovementItem.Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                             ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()

            LEFT JOIN Object_Contract_View AS Object_Contract_View
                                           ON Object_Contract_View.ContractId = MILinkObject_Contract.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_ContractConditionKind
                                             ON MILinkObject_ContractConditionKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_ContractConditionKind.DescId = zc_MILinkObject_ContractConditionKind()

            LEFT JOIN Object AS Object_ContractConditionKind ON Object_ContractConditionKind.Id = MILinkObject_ContractConditionKind.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                             ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                            AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()

            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = MILinkObject_InfoMoney.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                             ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()

            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MILinkObject_Unit.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PaidKind
                                             ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PaidKind.DescId = zc_MILinkObject_PaidKind()

            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MILinkObject_PaidKind.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Branch
                                             ON MILinkObject_Branch.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Branch.DescId = zc_MILinkObject_Branch()

            LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = MILinkObject_Branch.ObjectId


            ;

     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_ProfitLossService (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 17.02.14                                                        *

*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_ProfitLossService (inMovementId:= 25173, inShowAll:= TRUE, inisErased:=FALSE, inSession:= '2')
-- SELECT * FROM gpSelect_MovementItem_ProfitLossService (inMovementId:= 25173, inShowAll:= FALSE, inisErased:=FALSE, inSession:= '2')