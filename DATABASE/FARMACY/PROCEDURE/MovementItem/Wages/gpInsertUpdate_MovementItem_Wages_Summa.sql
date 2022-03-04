-- Function: gpInsertUpdate_MovementItem_Wages_Summa()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Wages_Summa(INTEGER, INTEGER, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Wages_Summa(
    IN ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inHolidaysHospital    TFloat    , -- Отпуск / Больничный
    IN inMarketing           TFloat    , -- Маркетинг
    IN inDirector            TFloat    , -- Директор. премии / штрафы
    IN inIlliquidAssets      TFloat    , -- Неликвиды
    IN inPenaltySUN          TFloat    , -- Персональный штраф по СУН
    IN inPenaltyExam         TFloat    , -- Штраф по сдаче экзамена
    IN inAmountCard          TFloat    , -- На карту
    IN inisIssuedBy          Boolean   , -- Выдана
   OUT outAmountHand         TFloat    , -- На руки
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS TFloat
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbOperDate TDateTime;
   
   DECLARE vbisIssuedBy Boolean;
   DECLARE vbHolidaysHospital TFloat;
   DECLARE vbMarketing TFloat;
   DECLARE vbDirector TFloat;
   DECLARE vbIlliquidAssets TFloat;
   DECLARE vbPenaltySUN TFloat;
   DECLARE vbPenaltyExam TFloat;
   DECLARE vbAmountCard TFloat;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    vbUserId:= lpGetUserBySession (inSession);

    IF COALESCE (ioId, 0) = 0
    THEN
      RAISE EXCEPTION 'Ошибка. Документ не сохранен.';
    END IF;
    
    -- определяем <Статус>
    vbStatusId := (SELECT StatusId FROM Movement WHERE Id = inMovementId);
    -- проверка - проведенные/удаленные документы Изменять нельзя
    IF vbStatusId <> zc_Enum_Status_UnComplete()
    THEN
        RAISE EXCEPTION 'Ошибка.Изменение документа в статусе <%> не возможно.', lfGet_Object_ValueData (vbStatusId);
    END IF;
    
    IF COALESCE(inIlliquidAssets, 0) > 0
    THEN
        RAISE EXCEPTION 'Ошибка. Сумма нелеквидав должна быть меньше или равна нулю.';    
    END IF;
    
    IF EXISTS(SELECT 1 FROM MovementItem WHERE ID = ioId AND MovementItem.DescId = zc_MI_Sign())
    THEN

      vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Wages());

      IF COALESCE(inHolidaysHospital, 0) <> 0 OR
         COALESCE(inMarketing, 0) <> 0 OR
         COALESCE(inDirector, 0) <> 0  OR
         COALESCE(inIlliquidAssets, 0) <> 0 OR
         COALESCE(inPenaltySUN, 0) <> 0 OR
         COALESCE(inPenaltyExam, 0) <> 0 OR
         COALESCE(inAmountCard, 0) <> 0
      THEN
        RAISE EXCEPTION 'Ошибка. Для дополнительных расходов можно изменять только признак "Выдано".';      
      END IF;
    
       -- сохранили свойство <Дата выдачи>
      IF inisIssuedBy <> COALESCE ((SELECT ValueData FROM MovementItemBoolean WHERE DescID = zc_MIBoolean_isIssuedBy() AND MovementItemID = ioId), FALSE)
      THEN
        PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_IssuedBy(), ioId, CURRENT_TIMESTAMP);
      
         -- сохранили свойство <Выдано>
        PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_isIssuedBy(), ioId, inisIssuedBy);
      

        -- сохранили протокол
        PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, False);    
      END IF;

      SELECT MovementItem.Amount 
      INTO outAmountHand
      FROM  MovementItem
      WHERE MovementItem.Id = ioId;
    ELSE
    
      SELECT COALESCE (MIB_isIssuedBy.ValueData, FALSE)
           , COALESCE (MIFloat_HolidaysHospital.ValueData, 0)
           , COALESCE (MIFloat_Marketing.ValueData, 0)
           , COALESCE (MIFloat_Director.ValueData, 0)
           , COALESCE (MIFloat_IlliquidAssets.ValueData, 0)
           , COALESCE (MIFloat_PenaltySUN.ValueData, 0)
           , COALESCE (MIFloat_PenaltyExam.ValueData, 0)
           , COALESCE (MIF_AmountCard.ValueData, 0)
      INTO vbisIssuedBy
         , vbHolidaysHospital
         , vbMarketing
         , vbDirector
         , vbIlliquidAssets
         , vbPenaltySUN
         , vbPenaltyExam
         , vbAmountCard   
      FROM  MovementItem

            LEFT JOIN MovementItemFloat AS MIFloat_HolidaysHospital
                                        ON MIFloat_HolidaysHospital.MovementItemId = MovementItem.Id
                                       AND MIFloat_HolidaysHospital.DescId = zc_MIFloat_HolidaysHospital()

            LEFT JOIN MovementItemFloat AS MIFloat_Marketing
                                        ON MIFloat_Marketing.MovementItemId = MovementItem.Id
                                       AND MIFloat_Marketing.DescId = zc_MIFloat_Marketing()

            LEFT JOIN MovementItemFloat AS MIFloat_Director
                                        ON MIFloat_Director.MovementItemId = MovementItem.Id
                                       AND MIFloat_Director.DescId = zc_MIFloat_Director()

            LEFT JOIN MovementItemFloat AS MIFloat_IlliquidAssets
                                        ON MIFloat_IlliquidAssets.MovementItemId = MovementItem.Id
                                       AND MIFloat_IlliquidAssets.DescId = zc_MIFloat_SummaIlliquidAssets()

            LEFT JOIN MovementItemFloat AS MIFloat_PenaltySUN
                                        ON MIFloat_PenaltySUN.MovementItemId = MovementItem.Id
                                       AND MIFloat_PenaltySUN.DescId = zc_MIFloat_PenaltySUN()

            LEFT JOIN MovementItemFloat AS MIFloat_PenaltyExam
                                        ON MIFloat_PenaltyExam.MovementItemId = MovementItem.Id
                                       AND MIFloat_PenaltyExam.DescId = zc_MIFloat_PenaltyExam()

            LEFT JOIN MovementItemFloat AS MIF_AmountCard
                                        ON MIF_AmountCard.MovementItemId = MovementItem.Id
                                       AND MIF_AmountCard.DescId = zc_MIFloat_AmountCard()
                                         
            LEFT JOIN MovementItemBoolean AS MIB_isIssuedBy
                                          ON MIB_isIssuedBy.MovementItemId = MovementItem.Id
                                         AND MIB_isIssuedBy.DescId = zc_MIBoolean_isIssuedBy()

      WHERE MovementItem.Id = ioId;
                            
      IF vbisIssuedBy = TRUE AND 
         (vbHolidaysHospital <> COALESCE (inHolidaysHospital, 0) OR
          vbMarketing <>  COALESCE (inMarketing, 0) OR
          vbDirector <>  COALESCE (inDirector, 0) OR
          vbIlliquidAssets <>  COALESCE (inIlliquidAssets, 0) OR
          vbPenaltySUN <>  COALESCE (inPenaltySUN, 0) OR
          vbPenaltyExam <>  COALESCE (inPenaltyExam, 0) OR
          vbAmountCard <>  COALESCE (inAmountCard, 0))
      THEN
        RAISE EXCEPTION 'Ошибка. Зарплата выдана. Изменение сумм запрещено.';            
      END IF;
        
      IF vbisIssuedBy <> COALESCE (inisIssuedBy, False) OR
         vbHolidaysHospital <> COALESCE (inHolidaysHospital, 0) OR
         vbDirector <>  COALESCE (inDirector, 0) OR
         vbPenaltySUN <>  COALESCE (inPenaltySUN, 0) OR
         vbPenaltyExam <>  COALESCE (inPenaltyExam, 0) OR
         vbAmountCard <>  COALESCE (inAmountCard, 0)
      THEN
        vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Wages());
      END IF;        
            
      IF (vbMarketing <>  COALESCE (inMarketing, 0) OR
         vbIlliquidAssets <>  COALESCE (inIlliquidAssets, 0)) AND
         NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId in (zc_Enum_Role_Admin(), 12084491))
      THEN
        RAISE EXCEPTION 'Изменение сумм "Маркетинга" и "Нелеквидов" вам запрещено.';
      END IF;        

      
       -- сохранили свойство <Отпуск / Больничный>
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_HolidaysHospital(), ioId, inHolidaysHospital);
       -- сохранили свойство <Маркетинг>
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Marketing(), ioId, inMarketing);
       -- сохранили свойство <Директор. премии / штрафы>
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Director(), ioId, inDirector);
       -- сохранили свойство < Неликвиды >
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummaIlliquidAssets(), ioId, inIlliquidAssets);
       -- сохранили свойство <Персональный штраф по СУН>
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PenaltySUN(), ioId, inPenaltySUN);
       -- сохранили свойство <Штраф по сдаче экзамена>
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PenaltyExam(), ioId, inPenaltyExam);

       -- сохранили свойство <На карту>
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountCard(), ioId, inAmountCard);

       -- сохранили свойство <Дата выдачи>
      IF inisIssuedBy <> COALESCE ((SELECT ValueData FROM MovementItemBoolean WHERE DescID = zc_MIBoolean_isIssuedBy() AND MovementItemID = ioId), FALSE)
      THEN
      
        SELECT Movement.OperDate 
        INTO vbOperDate
        FROM MovementItem 
             INNER JOIN Movement ON Movement.Id = MovementItem.MovementId 
        WHERE MovementItem.ID = ioId;
      
/*        IF inisIssuedBy = TRUE AND vbOperDate >= '01.10.2019' AND 
           NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin()) AND
           EXISTS(SELECT MovementItem.ObjectId 
                  FROM MovementItem 
                       INNER JOIN ObjectLink AS ObjectLink_User_Member
                                             ON ObjectLink_User_Member.ObjectId = MovementItem.ObjectId
                                            AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                       INNER JOIN ObjectLink AS ObjectLink_Member_Position
                                             ON ObjectLink_Member_Position.ObjectId = ObjectLink_User_Member.ChildObjectId
                                            AND ObjectLink_Member_Position.DescId = zc_ObjectLink_Member_Position()
                       INNER JOIN Object AS Object_Position ON Object_Position.Id = ObjectLink_Member_Position.ChildObjectId
                  WHERE MovementItem.ID = ioId
                    AND (Object_Position.ObjectCode = 1 OR Object_Position.ObjectCode = 2 AND vbOperDate >= '01.02.2022')) AND
           NOT EXISTS(SELECT 1
                      FROM Movement

                           LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                  AND MovementItem.DescId = zc_MI_Master()

                           LEFT JOIN MovementItemBoolean AS MIBoolean_Passed
                                                         ON MIBoolean_Passed.DescId = zc_MIBoolean_Passed()
                                                        AND MIBoolean_Passed.MovementItemId = MovementItem.Id
                                                        
                      WHERE Movement.DescId = zc_Movement_TestingUser()
                        AND Movement.OperDate = (SELECT Movement.OperDate 
                                                 FROM MovementItem 
                                                      INNER JOIN Movement ON Movement.Id = MovementItem.MovementId 
                                                 WHERE MovementItem.ID = ioId)
                        AND MovementItem.ObjectId = (SELECT MovementItem.ObjectId FROM MovementItem WHERE MovementItem.ID = ioId)
                        AND COALESCE(MIBoolean_Passed.ValueData, False) = True) AND
           (COALESCE((SELECT MovementItemBoolean.ValueData FROM MovementItemBoolean WHERE MovementItemBoolean.MovementItemID = ioId AND 
                     MovementItemBoolean.DescId = zc_MIBoolean_isTestingUser()), FALSE) = FALSE)
        THEN
          RAISE EXCEPTION 'Ошибка. Сотрудник не сдал экзамен. Выдача зарплаты запрещена.';            
        END IF;*/

        PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_IssuedBy(), ioId, CURRENT_TIMESTAMP);
      
         -- сохранили свойство <Выдано>
        PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_isIssuedBy(), ioId, inisIssuedBy);
      END IF;

      -- сохранили протокол
      PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, False);

      SELECT (MovementItem.Amount + 
              COALESCE (MIFloat_HolidaysHospital.ValueData, 0) + 
              CASE WHEN COALESCE(MIFloat_Marketing.ValueData, 0) > 0 THEN COALESCE(MIFloat_Marketing.ValueData, 0)
                   WHEN COALESCE(MIFloat_Marketing.ValueData, 0) + COALESCE(MIFloat_MarketingRepayment.ValueData, 0) > 0
                   THEN 0 ELSE COALESCE(MIFloat_Marketing.ValueData, 0) + COALESCE(MIFloat_MarketingRepayment.ValueData, 0)  END +
              COALESCE (MIFloat_Director.ValueData, 0) +
              CASE WHEN COALESCE(MIFloat_IlliquidAssets.ValueData, 0) > 0 THEN COALESCE(MIFloat_IlliquidAssets.ValueData, 0)
                   WHEN COALESCE(MIFloat_IlliquidAssets.ValueData, 0) + COALESCE(MIFloat_IlliquidAssetsRepayment.ValueData, 0) > 0
                   THEN 0 ELSE COALESCE(MIFloat_IlliquidAssets.ValueData, 0) + COALESCE(MIFloat_IlliquidAssetsRepayment.ValueData, 0)  END +
              COALESCE (MIFloat_PenaltySUN.ValueData, 0) +
              COALESCE (MIFloat_PenaltyExam.ValueData, 0) - 
              COALESCE (MIF_AmountCard.ValueData, 0))::TFloat AS AmountHand
      INTO outAmountHand
      FROM  MovementItem

            LEFT JOIN MovementItemFloat AS MIFloat_HolidaysHospital
                                        ON MIFloat_HolidaysHospital.MovementItemId = MovementItem.Id
                                       AND MIFloat_HolidaysHospital.DescId = zc_MIFloat_HolidaysHospital()

            LEFT JOIN MovementItemFloat AS MIFloat_Marketing
                                        ON MIFloat_Marketing.MovementItemId = MovementItem.Id
                                       AND MIFloat_Marketing.DescId = zc_MIFloat_Marketing()

            LEFT JOIN MovementItemFloat AS MIFloat_MarketingRepayment
                                        ON MIFloat_MarketingRepayment.MovementItemId = MovementItem.Id
                                       AND MIFloat_MarketingRepayment.DescId = zc_MIFloat_MarketingRepayment()

            LEFT JOIN MovementItemFloat AS MIFloat_Director
                                        ON MIFloat_Director.MovementItemId = MovementItem.Id
                                       AND MIFloat_Director.DescId = zc_MIFloat_Director()

            LEFT JOIN MovementItemFloat AS MIFloat_IlliquidAssets
                                        ON MIFloat_IlliquidAssets.MovementItemId = MovementItem.Id
                                       AND MIFloat_IlliquidAssets.DescId = zc_MIFloat_SummaIlliquidAssets()

            LEFT JOIN MovementItemFloat AS MIFloat_IlliquidAssetsRepayment
                                        ON MIFloat_IlliquidAssetsRepayment.MovementItemId = MovementItem.Id
                                       AND MIFloat_IlliquidAssetsRepayment.DescId = zc_MIFloat_IlliquidAssetsRepayment()

            LEFT JOIN MovementItemFloat AS MIFloat_PenaltySUN
                                        ON MIFloat_PenaltySUN.MovementItemId = MovementItem.Id
                                       AND MIFloat_PenaltySUN.DescId = zc_MIFloat_PenaltySUN()

            LEFT JOIN MovementItemFloat AS MIFloat_PenaltyExam
                                        ON MIFloat_PenaltyExam.MovementItemId = MovementItem.Id
                                       AND MIFloat_PenaltyExam.DescId = zc_MIFloat_PenaltyExam()

            LEFT JOIN MovementItemFloat AS MIF_AmountCard
                                        ON MIF_AmountCard.MovementItemId = MovementItem.Id
                                       AND MIF_AmountCard.DescId = zc_MIFloat_AmountCard()

      WHERE MovementItem.Id = ioId;
  END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 26.08.19                                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_Wages_Summa (, inSession:= '2')