-- Function: gpInsert_Movement_Send_SmashSumSend()

DROP FUNCTION IF EXISTS gpInsert_Movement_Send_SmashSumSend(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_Send_SmashSumSend(
    IN inMovementId          Integer   ,    -- ключ документа
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbisDeferred Boolean;
   DECLARE vbSumma TFloat;
   DECLARE vbSmashSumSend TFloat;
   
   DECLARE vbRecord    Record;
   DECLARE vbOrd       Integer;
   DECLARE vbSummaCalc TFloat;
   
BEGIN

   IF COALESCE(inMovementId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);

   SELECT COALESCE(ObjectFloat_CashSettings_SmashSumSend.ValueData, 0) 
   INTO vbSmashSumSend
   FROM Object AS Object_CashSettings
        LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_SmashSumSend
                              ON ObjectFloat_CashSettings_SmashSumSend.ObjectId = Object_CashSettings.Id 
                             AND ObjectFloat_CashSettings_SmashSumSend.DescId = zc_ObjectFloat_CashSettings_SmashSumSend()
   WHERE Object_CashSettings.DescId = zc_Object_CashSettings()
   LIMIT 1;

   IF COALESCE (vbSmashSumSend, 0) < 10000
   THEN
       RAISE EXCEPTION 'Ошибка. Установленная сумма разбивка <%> мала.', vbSmashSumSend;   
   END IF;

   -- параметры документа
   SELECT
        Movement.StatusId,
        COALESCE (MovementBoolean_Deferred.ValueData, FALSE),
        COALESCE (MovementFloat_TotalSummFrom.ValueData, 0)
   INTO
        vbStatusId,
        vbisDeferred,
        vbSumma
   FROM Movement
        LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                  ON MovementBoolean_Deferred.MovementId = Movement.Id
                                 AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
        LEFT JOIN MovementFloat AS MovementFloat_TotalSummFrom
                                ON MovementFloat_TotalSummFrom.MovementId =  Movement.Id
                               AND MovementFloat_TotalSummFrom.DescId = zc_MovementFloat_TotalSummFrom()
   WHERE Movement.Id = inMovementId;
        
   IF vbisDeferred = TRUE 
   THEN
     RAISE EXCEPTION 'Ошибка. Перемещение отложено. Разбивка запрещена.';
   END IF;
   
   -- свойство не меняем у проведенных документов
   IF COALESCE (vbStatusId, 0) <> zc_Enum_Status_UnComplete()
   THEN
       RAISE EXCEPTION 'Ошибка. Разбивка документ в статусе <%> не возможно.', lfGet_Object_ValueData (vbStatusId);   
   END IF;
   
   IF COALESCE (vbSmashSumSend, 0) > vbSumma
   THEN
       RAISE EXCEPTION 'Ошибка. Сумма документа <%> меньше или равна установленная сумме разбивка <%>.', vbSumma, vbSmashSumSend;   
   END IF;
   
   vbSummaCalc := 0;
   vbOrd := 0;

   CREATE TEMP TABLE tmpMI ON COMMIT DROP AS
   SELECT MI.GoodsName
        , MI.Id
        , COALESCE (MI.SummaUnitFrom, 0)  AS SummaUnitFrom
        , 0::Integer                      AS Ord
        , 0::Integer                      AS MovementId
   FROM gpSelect_MovementItem_Send(inMovementId := inMovementId, inShowAll := 'False' , inIsErased := 'False', inSession := inSession) AS MI
   WHERE COALESCE (MI.SummaUnitFrom, 0) > 0
   ORDER BY MI.GoodsName;
   
   -- Распределим содержимле документа   
   FOR vbRecord IN SELECT tmpMI.* FROM tmpMI ORDER BY tmpMI.GoodsName
   LOOP
      
     IF vbSummaCalc + vbRecord.SummaUnitFrom >  vbSmashSumSend
     THEN
       vbOrd := vbOrd + 1;
       UPDATE tmpMI SET Ord = vbOrd WHERE tmpMI.Id = vbRecord.Id;
       vbSummaCalc := 0;
       --raise notice 'Value 1: % %', vbRecord.GoodsName, vbOrd;
     ELSE
       if vbOrd > 0
       THEN
         UPDATE tmpMI SET Ord = vbOrd WHERE tmpMI.Id = vbRecord.Id;
       END IF;    
     END IF;
     
     vbSummaCalc := vbSummaCalc + vbRecord.SummaUnitFrom;
                                         
   END LOOP;  
   
   -- создали документы
   UPDATE tmpMI SET MovementId = tmp.MovementId
   FROM (SELECT tmp.Ord
              , gpInsertUpdate_Movement_Send (ioId               := 0
                                            , inInvNumber        := CAST (NEXTVAL ('Movement_Send_seq') AS TVarChar)
                                            , inOperDate         := tmpMovement.OperDate
                                            , inFromId           := tmpMovement.FromId
                                            , inToId             := tmpMovement.ToId
                                            , inComment          := COALESCE(NullIf(tmpMovement.Comment, '')||'. ', '')||'Сформировано по разбивке '||tmpMovement.InvNumber
                                            , inChecked          := FALSE
                                            , inisComplete       := FALSE
                                            , inNumberSeats      := 1
                                            , inDriverSunId      := 0
                                            , inSession          := inSession
                                             ) AS MovementId

         FROM (SELECT DISTINCT tmpMI.Ord FROM tmpMI WHERE tmpMI.Ord > 0 ORDER BY 1) AS tmp
         
              INNER JOIN  gpGet_Movement_Send(inMovementId := inMovementId , inOperDate := CURRENT_DATE,  inSession := inSession) AS tmpMovement ON 1 = 1
              
        ) AS tmp
   WHERE tmpMI.Ord = tmp.Ord
        ;

   -- сохранили свойство <Перемещение по СУН> + isAuto + zc_Enum_PartionDateKind_6
   PERFORM CASE WHEN tmpMovement.IsSun    = TRUE THEN lpInsertUpdate_MovementBoolean (zc_MovementBoolean_SUN(),      tmp.MovementId, tmpMovement.IsSun) END
         , CASE WHEN tmpMovement.IsSun_v2 = TRUE THEN lpInsertUpdate_MovementBoolean (zc_MovementBoolean_SUN_v2(),   tmp.MovementId, tmpMovement.IsSun_v2) END
         , CASE WHEN tmpMovement.IsSun_v3 = TRUE THEN lpInsertUpdate_MovementBoolean (zc_MovementBoolean_SUN_v3(),   tmp.MovementId, tmpMovement.IsSun_v3) END
         , CASE WHEN tmpMovement.IsSun_v4 = TRUE THEN lpInsertUpdate_MovementBoolean (zc_MovementBoolean_SUN_v4(),   tmp.MovementId, tmpMovement.IsSun_v4) END
         , CASE WHEN tmpMovement.IsAuto   = TRUE THEN lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isAuto(),   tmp.MovementId, tmpMovement.IsAuto) END
   FROM (SELECT DISTINCT tmpMI.MovementId FROM tmpMI WHERE tmpMI.Ord > 0) AS tmp
     
        INNER JOIN  gpGet_Movement_Send(inMovementId := inMovementId , inOperDate := CURRENT_DATE,  inSession := inSession) AS tmpMovement ON 1 = 1;
          
   -- Перекинули содержимое   
   UPDATE MovementItem SET MovementId = tmp.MovementId
   FROM (SELECT tmpMI.Id, tmpMI.MovementId FROM tmpMI WHERE tmpMI.Ord > 0) AS tmp
   WHERE MovementItem.MovementId = inMovementId
     AND MovementItem.Id = tmp.Id;
   
   -- Перекинули содержимое если есть привязки к партиям
   UPDATE MovementItem SET MovementId = tmp.MovementId
   FROM (SELECT tmpMI.Id, tmpMI.MovementId FROM tmpMI WHERE tmpMI.Ord > 0) AS tmp
   WHERE MovementItem.MovementId = inMovementId
     AND MovementItem.ParentId = tmp.Id;
     
      -- пересчитали Итоговые суммы по накладным
   PERFORM lpInsertUpdate_MovementFloat_TotalSummSend (tmp.MovementId)
   FROM (SELECT DISTINCT COALESCE(NullIf(tmpMI.MovementId, 0), inMovementId) AS MovementId FROM tmpMI) AS tmp;


   /*RAISE EXCEPTION 'Тест прошел успешно для <%>', 
     (SELECT string_agg(DISTINCT COALESCE(NullIf(tmpMI.MovementId, 0), inMovementId)::TEXT||' '||MovementFloat_TotalSummFrom.ValueData::TEXT, ', ') 
      FROM tmpMI
      
           LEFT JOIN MovementFloat AS MovementFloat_TotalSummFrom
                                   ON MovementFloat_TotalSummFrom.MovementId = COALESCE(NullIf(tmpMI.MovementId, 0), inMovementId)
                                  AND MovementFloat_TotalSummFrom.DescId = zc_MovementFloat_TotalSummFrom()
      
           );*/


    -- !!!ВРЕМЕННО для ТЕСТА!!!
    /*IF inSession = zfCalc_UserAdmin()
    THEN
      RAISE EXCEPTION 'Тест прошел успешно для <%>', (SELECT COUNT(DISTINCT tmpMI.Ord) FROM tmpMI WHERE tmpMI.Ord > 0);
    END IF;*/

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 27.12.23                                                      *
*/

-- select * from gpInsert_Movement_Send_SmashSumSend(inMovementId := 34372097  ,  inSession := '3');