-- Function:  gpReport_Check_CorrectMarketing()

DROP FUNCTION IF EXISTS gpReport_Check_SetErasedUser (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION  gpReport_Check_SetErasedUser(
    IN inDateStart        TDateTime,  -- Дата начала
    IN inDateFinal        TDateTime,  -- Дата окончания
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (
  Id                 Integer,
  UnitId             Integer,
  UnitCode           Integer,
  UnitName           TVarChar,
  JuridicalName      TVarChar,
  UserName           TVarChar,
  OperDate           TDateTime,
  InvNumber          TVarChar,
  DateErase          TDateTime,
  CashRegisterName   TVarChar,
  FiscalCheckNumber  TVarChar,
  JackdawsChecksName TVarChar,
  TotalSumm          TFloat,
  IdPierced          Integer,
  OperDatePierced    TDateTime,
  InvNumberPierced   TVarChar
)
AS
$BODY$
   DECLARE vbUserId      Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);


    -- Результат
    RETURN QUERY
    WITH tmpMovement AS (SELECT Movement.Id
                              , Movement.OperDate
                              , Movement.InvNumber
                              , MovementLinkObject_Unit.ObjectId           AS UnitId
                              , ObjectLink_Unit_Juridical.ChildObjectId    AS JuridicalId
                         FROM Movement 
                             
                              INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                           ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                          AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

                              INNER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                                    ON ObjectLink_Unit_Juridical.ObjectId = MovementLinkObject_Unit.ObjectId
                                                   AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                                                        
                          WHERE Movement.OperDate >= inDateStart
                            AND Movement.OperDate < inDateFinal + INTERVAL '1 DAY'
                            AND Movement.DescId = zc_Movement_Check()
                            AND Movement.StatusId = zc_Enum_Status_Erased())
       , tmpMovementItem AS (SELECT Movement.Id
                                  , MovementItem.ObjectId
                                  , SUM(MovementItem.Amount) AS Amount
                             FROM tmpMovement AS Movement 
                              
                                  INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                         AND MovementItem.DescId = zc_MI_Master()
                                                         AND MovementItem.Amount > 0 
                                                          
                              GROUP BY Movement.Id
                                     , MovementItem.ObjectId)
       , tmpMovementGoods AS (SELECT Movement.Id
                                   , string_agg(MovementItem.ObjectId::TVarChar||MovementItem.Amount::TVarChar, ';' order by MovementItem.ObjectId) AS GoodsList
                             FROM tmpMovementItem AS Movement 
                              
                                  INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                         AND MovementItem.DescId = zc_MI_Master()
                                                         AND MovementItem.Amount > 0 
                                                          
                              GROUP BY Movement.Id)
       , tmpMovementAll AS (SELECT MovementItemContainer.MovementId                    AS ID
                                 , MovementItemContainer.OperDate
                                 , MovementItemContainer.WhereObjectId_Analyzer           AS UnitId
                                 , MovementItemContainer.ObjectId_Analyzer                AS ObjectId
                                 , - MovementItemContainer.Amount                         AS Amount
                            FROM MovementItemContainer 
                            WHERE MovementItemContainer.OperDate >= inDateStart
                               AND MovementItemContainer.OperDate < inDateFinal + INTERVAL '4 DAY'
                               AND MovementItemContainer.MovementDescId = zc_Movement_Check()
                               AND MovementItemContainer.DescId = zc_MIContainer_Count())                                     
       , tmpMovementItemAll AS (SELECT Movement.Id
                                     , Movement.OperDate
                                     , Movement.UnitId 
                                     , Movement.ObjectId
                                     , SUM(Movement.Amount) AS Amount
                                FROM tmpMovementAll AS Movement 
                                 GROUP BY Movement.Id
                                        , Movement.OperDate
                                        , Movement.UnitId 
                                        , Movement.ObjectId)                                     
       , tmpMovementGoodsAll AS (SELECT Movement.Id
                                      , Movement.OperDate
                                      , Movement.UnitId 
                                      , string_agg(Movement.ObjectId::TVarChar||Movement.Amount::TVarChar, ';' order by Movement.ObjectId) AS GoodsList
                                FROM tmpMovementItemAll AS Movement 
                                 GROUP BY Movement.Id
                                        , Movement.OperDate
                                        , Movement.UnitId)                                     
       , tmpMovementProtocol AS (SELECT MovementProtocol.MovementId
                                      , MovementProtocol.OperDate
                                      , MovementProtocol.UserId
                                      , CASE WHEN SUBSTRING(MovementProtocol.ProtocolData, POSITION('Статус' IN MovementProtocol.ProtocolData) + 22, 1) = 'П'
                                             THEN TRUE ELSE FALSE END AS Status
                                      , ROW_NUMBER() OVER (Partition BY MovementProtocol.MovementId ORDER BY MovementProtocol.OperDate DESC) AS ord
                                 FROM tmpMovement AS Movement

                                      INNER JOIN MovementProtocol ON MovementProtocol.MovementId = Movement.ID
                                                                 AND COALESCE(MovementProtocol.UserId, 0) <> 0)
       , tmpMovementComplete AS (SELECT DISTINCT MovementProtocol.MovementId
                                 FROM tmpMovementProtocol AS MovementProtocol
                                 WHERE MovementProtocol.Status = TRUE)
       , tmpUser AS (SELECT DISTINCT Object_RoleUser.ID AS UserId  FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
                     WHERE Object_RoleUser.RoleId = zc_Enum_Role_CashierPharmacy()) 
   
    SELECT Movement.Id
         , Object_Unit.Id
         , Object_Unit.ObjectCode
         , Object_Unit.ValueData
         , Object_Juridical.ValueData
         , Object_User.ValueData
         , Movement.OperDate
         , Movement.InvNumber
         , tmpMovementProtocol.OperDate

         , Object_CashRegister.ValueData
         , MovementString_FiscalCheckNumber.ValueData
         , Object_JackdawsChecks.ValueData

         , MovementFloat_TotalSumm.ValueData

         , tmpMovementGoodsAll.Id
         , tmpMovementGoodsAll.OperDate
         , MovementPierced.InvNumber
    FROM tmpMovement AS Movement 
    
         INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                               ON ObjectLink_Juridical_Retail.ObjectId = Movement.JuridicalId
                              AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                              AND ObjectLink_Juridical_Retail.ChildObjectId = 4 
                              
         INNER JOIN tmpMovementProtocol ON tmpMovementProtocol.MovementId = Movement.Id
                                       AND tmpMovementProtocol.Ord = 1

         INNER JOIN tmpMovementComplete ON tmpMovementComplete.MovementId = Movement.Id
                                       
         INNER JOIN tmpUser ON tmpUser.UserId = tmpMovementProtocol.UserId
         
         LEFT JOIN tmpMovementGoods ON tmpMovementGoods.ID = Movement.Id
         
         LEFT JOIN tmpMovementGoodsAll ON tmpMovementGoodsAll.UnitId = Movement.UnitId
                                      AND tmpMovementGoodsAll.GoodsList = tmpMovementGoods.GoodsList
                                      AND tmpMovementGoodsAll.OperDate >= DATE_TRUNC ('DAY', Movement.OperDate)
                                      AND tmpMovementGoodsAll.OperDate < DATE_TRUNC ('DAY', Movement.OperDate) + INTERVAL '3 DAY'
         LEFT JOIN Movement AS MovementPierced
                            ON MovementPierced.ID = tmpMovementGoodsAll.Id

         LEFT JOIN Object AS Object_Unit ON Object_Unit.ID = Movement.UnitId
         LEFT JOIN Object AS Object_Juridical ON Object_Juridical.ID = Movement.JuridicalId
         LEFT JOIN Object AS Object_User ON Object_User.ID = tmpMovementProtocol.UserId

         LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                 ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
                                
         LEFT JOIN MovementLinkObject AS MovementLinkObject_CashRegister
                                      ON MovementLinkObject_CashRegister.MovementId = Movement.Id
                                     AND MovementLinkObject_CashRegister.DescId = zc_MovementLinkObject_CashRegister()
         LEFT JOIN Object AS Object_CashRegister ON Object_CashRegister.ID = MovementLinkObject_CashRegister.ObjectId
                                     
         LEFT JOIN MovementLinkObject AS MovementLinkObject_JackdawsChecks
                                      ON MovementLinkObject_JackdawsChecks.MovementId =  Movement.Id
                                     AND MovementLinkObject_JackdawsChecks.DescId = zc_MovementLinkObject_JackdawsChecks()
         LEFT JOIN Object AS Object_JackdawsChecks ON Object_JackdawsChecks.ID = MovementLinkObject_JackdawsChecks.ObjectId
                                     
         LEFT JOIN MovementString AS MovementString_FiscalCheckNumber
                                  ON MovementString_FiscalCheckNumber.MovementId = Movement.Id
                                 AND MovementString_FiscalCheckNumber.DescId = zc_MovementString_FiscalCheckNumber()
    
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 05.07.21                                                      *
*/

-- тест
-- 
select * from gpReport_Check_SetErasedUser(inDateStart := ('01.07.2021')::TDateTime , inDateFinal := ('30.07.2021')::TDateTime,  inSession := '3');
