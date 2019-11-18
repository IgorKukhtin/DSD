-- Function: gpSelect_Movement_LoyaltyCheck()

DROP FUNCTION IF EXISTS gpSelect_Movement_LoyaltyCheck (Integer, TDateTime, TFloat, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_LoyaltyCheck(
    IN inUnitId        Integer,    -- Подразделение
    IN inOperDate      TDateTime,  -- День
    IN inStartSummCash TFloat,     -- От суммы
    IN inMovementId    Integer,    -- Чек
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, 
               TotalCount TFloat, TotalSumm TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);
     
     IF COALESCE(inMovementId, 0) <> 0
     THEN
       RAISE EXCEPTION 'Ошибка. Промокод уже связан с чеком!';
     END IF;

     -- Результат
     RETURN QUERY
         SELECT       
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate
           , MovementFloat_TotalCount.ValueData                 AS TotalCount
           , MovementFloat_TotalSumm.ValueData                  AS TotalSumm

        FROM Movement
 
             LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                          ON MovementLinkObject_Unit.MovementId = Movement.Id
                                         AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()   
                                                               
             LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                     ON MovementFloat_TotalCount.MovementId = Movement.Id
                                    AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
 
             LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                     ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                    AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
                                    
             LEFT JOIN MovementItem ON MovementItem.ParentId =  Movement.Id

        WHERE Movement.DescId = zc_Movement_Check()
          AND Movement.StatusId = zc_Enum_Status_Complete()
          AND Movement.OperDate >= inOperDate
          AND Movement.OperDate < inOperDate + INTERVAL '1 DAY'
          AND MovementLinkObject_Unit.ObjectId  = inUnitId
          AND MovementFloat_TotalSumm.ValueData >= inStartSummCash
          AND COALESCE(MovementItem.ID, 0) = 0

      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.  Шаблий О.В. +
 19.07.19                                                                                    *
*/

-- тест
--
 SELECT * FROM gpSelect_Movement_LoyaltyCheck (inUnitId:= 377606, inOperDate := '17.11.2019', inStartSummCash := 1000, inMovementId := 1111, inSession:= '3')

