-- Function: gpGet_Movement_Cash_Last()

DROP FUNCTION IF EXISTS gpGet_Movement_Cash_Last (Integer, Integer, TVarChar);
 
CREATE OR REPLACE FUNCTION gpGet_Movement_Cash_Last(
    IN inUnitId            Integer  , -- отдел
    IN inInfoMoneyId       Integer  , -- статья
   OUT outMovementId       Integer  , -- ключ Документа  
   OUT outMI_Id            Integer  ,
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     
     
       SELECT Movement.Id
            , MovementItem.Id AS MI_Id
              INTO outMovementId, outMI_Id
       FROM Movement
            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                   AND MovementItem.DescId = zc_MI_Master()
      
            INNER JOIN MovementItemLinkObject AS MILinkObject_Unit
                                              ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                             AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                                             AND MILinkObject_Unit.ObjectId = inUnitId
      
            INNER JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                              ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                             AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                                             AND MILinkObject_InfoMoney.ObjectId = inInfoMoneyId
      
       WHERE Movement.DescId = zc_Movement_Cash()
          AND Movement.StatusId = zc_Enum_Status_Complete()
       ORDER BY Movement.OperDate DESC, Movement.Id DESC
       LIMIT 1
      ; 
       
       -- если не нашли ошибка
       IF COALESCE (outMovementId,0) = 0
       THEN   
           RAISE EXCEPTION 'Ошибка.Документ оплаты не найден.';
       END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.04.22         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_Cash_Last (inUnitId := 52595 , inInfoMoneyId := 76878 ,  inSession := '5');
