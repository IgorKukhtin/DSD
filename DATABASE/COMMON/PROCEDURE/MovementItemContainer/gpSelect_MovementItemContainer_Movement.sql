-- Function: gpSelect_MovementItemContainer_Movement()

--DROP FUNCTION gpSelect_MovementItemContainer_Movement(Integer, TVarChar);

-- Запрос возвращает все проводки по документу

CREATE OR REPLACE FUNCTION gpSelect_MovementItemContainer_Movement(
IN inMovementId          Integer,       /* Документ */
IN inSession             TVarChar       /* текущий пользователь */)
RETURNS TABLE (DebetAmount TFloat, DebetAccountName TVarChar, KreditAmount TFloat, KreditAccountName TVarChar) 
AS
$BODY$BEGIN

--   PERFORM lpCheckRight(inSession, zc_Object_Process_User());

RETURN QUERY 
    SELECT 
       CAST(AccountValue.Amount AS TFloat) AS DebetAmount,
       Object_Account.ValueData            AS DebetAccountName,
       CAST(0 AS TFloat)                   AS KreditAmount,
       CAST('' AS TVarChar)                AS KreditAccountName
     FROM 
      (SELECT 
             SUM(MovementItemContainer.Amount)  AS Amount,
             Container.AccountId
        FROM MovementItemContainer
        JOIN Container ON Container.Id = MovementItemContainer.ContainerId
         AND Container.DescId = zc_Container_Summ()                
      WHERE MovementItemContainer.MovementId = inMovementId
        AND MovementItemContainer.Amount > 0
      GROUP BY Container.AccountId) AS AccountValue  
   LEFT JOIN Object AS Object_Account ON Object_Account.Id = AccountValue.AccountId
   UNION SELECT 
       CAST(0 AS TFloat)                   AS DebetAmount,
       CAST('' AS TVarChar)                AS DebetAccountName,
       CAST( - AccountValue.Amount AS TFloat) AS KreditAmount,
       Object_Account.ValueData            AS KreditAccountName
     FROM 
      (SELECT 
             SUM(MovementItemContainer.Amount)  AS Amount,
             Container.AccountId
        FROM MovementItemContainer
        JOIN Container ON Container.Id = MovementItemContainer.ContainerId
         AND Container.DescId = zc_Container_Summ()                
      WHERE MovementItemContainer.MovementId = inMovementId
        AND MovementItemContainer.Amount < 0
      GROUP BY Container.AccountId) AS AccountValue  
   LEFT JOIN Object AS Object_Account ON Object_Account.Id = AccountValue.AccountId;

     
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION gpSelect_MovementItemContainer_Movement(Integer, TVarChar)
  OWNER TO postgres;

-- SELECT * FROM gpSelect_MovementItemContainer_Movement('2')