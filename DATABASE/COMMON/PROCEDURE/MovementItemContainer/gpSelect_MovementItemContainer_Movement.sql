-- Function: gpSelect_MovementItemContainer_Movement()

--DROP FUNCTION gpSelect_MovementItemContainer_Movement();

-- Запрос возвращает все проводки по документу

CREATE OR REPLACE FUNCTION gpSelect_MovementItemContainer_Movement(
IN inMovementId          Integer,       /* Документ */
IN inSession             TVarChar       /* текущий пользователь */)
RETURNS TABLE (Amount TFloat, AccountName TVarChar) 
AS
$BODY$BEGIN

--   PERFORM lpCheckRight(inSession, zc_Object_Process_User());

RETURN QUERY 
    SELECT 
       CAST(AccountValue.Amount AS TFloat) AS Amount,
       Object_Account.ValueData            AS AccountName
     FROM 
      (SELECT 
             SUM(MovementItemContainer.Amount)  AS Amount,
             Container.AccountId
        FROM MovementItemContainer
   LEFT JOIN Container ON Container.Id = MovementItemContainer.ContainerId
         --AND Container.DescId = zc_ContainerLinkObject_Account()                
      WHERE MovementItemContainer.MovementId = inMovementId
      GROUP BY Container.AccountId) AS AccountValue  
   LEFT JOIN Object AS Object_Account ON Object_Account.Id = AccountValue.AccountId;
     
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION gpSelect_MovementItemContainer_Movement(Integer, TVarChar)
  OWNER TO postgres;

-- SELECT * FROM gpSelect_MovementItemContainer_Movement('2')