-- Function: gpComplete_Movement_Income()

-- DROP FUNCTION IF EXISTS gpComplete_Movement_Check_ver2 (Integer, TVarChar);
-- DROP FUNCTION IF EXISTS gpComplete_Movement_Check_ver2 (Integer,Integer, TVarChar);
-- DROP FUNCTION IF EXISTS gpComplete_Movement_Check_ver2 (Integer,Integer, Integer, TVarChar);
-- DROP FUNCTION IF EXISTS gpComplete_Movement_Check_ver2 (Integer,Integer, Integer, TVarChar, TVarChar);
-- DROP FUNCTION IF EXISTS gpComplete_Movement_Check_ver2 (Integer,Integer, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpComplete_Movement_Check_ver2_NoDiff (Integer,Integer, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Check_ver2_NoDiff (
    IN inMovementId        Integer              , -- ключ Документа
    IN inPaidType          Integer              , --Тип оплаты 0-деньги, 1-карта
    IN inCashRegister      TVarChar             , --№ кассового аппарата
    IN inCashSessionId     TVarChar             , --Сессия программы
    IN inUserSession	   TVarChar             , -- сессия пользователя под которой проводился чек в программе
--    IN inSession         TVarChar DEFAULT ''    -- сессия пользователя
    IN inSession           TVarChar               -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbPaidTypeId Integer;
  DECLARE vbUnitId Integer;
  DECLARE vbCashRegisterId Integer;
  DECLARE vbMessageText Text;
BEGIN
    if coalesce(inUserSession, '') <> '' then 
     inSession := inUserSession;
    end if;
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Check());
    vbUserId:= lpGetUserBySession (inSession);


    -- Если
    IF EXISTS (SELECT 1 FROM Movement WHERE Movement.ID = inMovementId AND Movement.DescId = zc_Movement_Check() AND Movement.StatusId <> zc_Enum_Status_Complete())
    THEN
        -- Перебили дату документа
        -- UPDATE Movement SET OperDate = CURRENT_TIMESTAMP WHERE Movement.Id = inMovementId; /*Дата проведения хранится в локальной базе и не должна перебиваться*/

        -- Определить
        vbUnitId:= (SELECT MLO_Unit.ObjectId FROM MovementLinkObject AS MLO_Unit WHERE MLO_Unit.MovementId = inMovementId AND MLO_Unit.DescId = zc_MovementLinkObject_Unit());
        
        -- сохранили тип оплаты
        IF inPaidType = 0
        THEN
            PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_PaidType(), inMovementId, zc_Enum_PaidType_Cash());
        ELSEIF inPaidType = 1
        THEN
            PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_PaidType() ,inMovementId, zc_Enum_PaidType_Card());
        ELSE
            RAISE EXCEPTION 'Ошибка.Не определен тип оплаты';
        END IF;

        -- Определить ид кассового аппарата
        IF COALESCE(inCashRegister,'') <> ''
        THEN
            vbCashRegisterId := gpGet_Object_CashRegister_By_Serial(inSerial := inCashRegister -- Серийный номер аппарата
                                                                  , inSession:= inSession);
        ELSE
            vbCashRegisterId := 0;
        END IF;
        -- Сохранили связь с кассовым аппаратом
        IF vbCashRegisterId <> 0
        THEN
            PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_CashRegister(), inMovementId, vbCashRegisterId);
        END IF;

        -- пересчитали Итоговые суммы
        PERFORM lpInsertUpdate_MovementFloat_TotalSummCheck (inMovementId);


        -- формируются проводки
        vbMessageText:= COALESCE (lpComplete_Movement_Check (inMovementId, vbUserId), '');


        -- доводим снапшет до текущего состояния на клиенте
        UPDATE CashSessionSnapShot
           SET Remains = CashSessionSnapShot.Remains - MovementItem.Amount
        FROM
             (SELECT MovementItem.ObjectId, SUM (MovementItem.Amount) AS Amount
              FROM MovementItem
              WHERE MovementItem.MovementId = inMovementId
                AND MovementItem.DescId = zc_MI_Master()
                AND MovementItem.isErased = FALSE
                AND MovementItem.Amount > 0
                AND vbMessageText = ''
              GROUP BY MovementItem.ObjectId
             ) AS MovementItem
        WHERE CashSessionSnapShot.CashSessionId = inCashSessionId
          AND CashSessionSnapShot.ObjectId = MovementItem.ObjectId
       ;            
        
    END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.  Подмогильный В.В.
 02.08.18                                                                                       * отгрузка без формирования Diff               
 10.09.15                                                                       *  CashSession
 06.07.15                                                                       *  Добавлен тип оплаты
 05.02.15                         *

*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 579, inSession:= '2')
-- SELECT * FROM gpComplete_Movement_Income (inMovementId:= 579, inIsLastComplete:= FALSE, inSession:= '2')
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 579, inSession:= '2')
