-- Function: gpSelect_MI_BankAccount_Detail()

DROP FUNCTION IF EXISTS gpSelect_MI_BankAccount_Detail (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_BankAccount_Detail(
    IN inMovementId  Integer      , -- ключ Документа
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, LineNum Integer
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , Amount TFloat
             , isErased Boolean
             )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY
     WITH
         tmpMI AS (SELECT MovementItem.Id        AS Id
                        , MovementItem.ObjectId  AS InfoMoneyId
                        , COALESCE (MovementItem.Amount,0) AS Amount
                        , MovementItem.isErased  AS isErased
                   FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                        INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                               AND MovementItem.DescId     = zc_MI_Detail()
                                               AND MovementItem.isErased   = tmpIsErased.isErased
                  )

       --
       SELECT tmpMI.Id         :: Integer AS Id
            , CAST (ROW_NUMBER() OVER (ORDER BY tmpMI.Id) AS Integer) AS LineNum
            , View_InfoMoney.InfoMoneyId
            , View_InfoMoney.InfoMoneyCode
            , View_InfoMoney.InfoMoneyName_all  AS InfoMoneyName
            , tmpMI.Amount      :: TFloat AS Amount
            , tmpMI.isErased              AS isErased
       FROM tmpMI
            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = tmpMI.InfoMoneyId
     UNION
       SELECT 0  :: Integer AS Id
            , 0  :: Integer AS LineNum
            , View_InfoMoney.InfoMoneyId
            , View_InfoMoney.InfoMoneyCode
            , View_InfoMoney.InfoMoneyName_all  AS InfoMoneyName
            , (ABS(COALESCE (MovementItem.Amount,0)) - COALESCE ( (SELECT SUM (tmpMI.Amount) FROM tmpMI),0 )) ::TFloat AS Amount
            , FALSE         AS isErased
       FROM MovementItem
            LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                             ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                            AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney
                                            ON View_InfoMoney.InfoMoneyId = MILinkObject_InfoMoney.ObjectId
                                           AND COALESCE ((SELECT COUNT (*) FROM tmpMI),0) = 0
       WHERE MovementItem.MovementId = inMovementId
         AND MovementItem.DescId = zc_MI_Master() 
         AND  (ABS(COALESCE (MovementItem.Amount,0)) - COALESCE ( (SELECT SUM (tmpMI.Amount) FROM tmpMI),0 )) <> 0 
       ORDER BY 2
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.10.24         *
*/

-- тест
-- SELECT * FROM gpSelect_MI_BankAccount_Detail (inMovementId:= 29623396 , inIsErased:= TRUE, inSession:= '2')    --29623453      --29623396 
