-- Function: lpUpdate_Movement_ContractGoods_EndBegin()

DROP FUNCTION IF EXISTS lpUpdate_Movement_ContractGoods_EndBegin (Integer, TDateTime, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_Movement_ContractGoods_EndBegin(
    IN inId                  Integer   , -- Ключ объекта <Документ Перемещение>
    IN inOperDate            TDateTime , -- Дата документа / С какой даты действует
   OUT outEndBeginDate       TDateTime , -- По какую дату действует
    IN inContractId          Integer   , --
    IN inCurrencyId          Integer   , -- Валюта
    IN inUserId              Integer     -- пользователь
)
RETURNS TDateTime
AS
$BODY$
   DECLARE vbMovementId_old  Integer;
   DECLARE vbMovementId_next Integer;
   DECLARE vbOperDate_next   TDateTime;
BEGIN

     -- проверка
     IF COALESCE (inContractId, 0) = 0
     THEN
         RETURN;
     END IF;

     -- находим предыдущий документ,ему устанавливаем дату окончания EndBeginDate  = inOperDate-1 день
     vbMovementId_old:= (SELECT tmp.Id
                         FROM (SELECT Movement.Id
                                      -- По убыванию, нужен первый предыдущий
                                    , ROW_NUMBER() OVER (ORDER BY Movement.OperDate DESC) AS Ord
                               FROM (SELECT *
                                     FROM Movement
                               WHERE Movement.DescId = zc_Movement_ContractGoods()
                                  AND Movement.OperDate < inOperDate
                                  AND Movement.StatusId <> zc_Enum_Status_Erased()  --zc_Enum_Status_Complete() 
                                  AND Movement.Id <> inId ) AS Movement
                                    INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                                  ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                                 AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                                                 AND MovementLinkObject_Contract.ObjectId = inContractId
                                    INNER JOIN MovementLinkObject AS MovementLinkObject_Currency
                                                                  ON MovementLinkObject_Currency.MovementId = Movement.Id
                                                                 AND MovementLinkObject_Currency.DescId = zc_MovementLinkObject_Currency()
                                                                 AND MovementLinkObject_Currency.ObjectId = inCurrencyId
                               
                               ) AS tmp
                         WHERE tmp.Ord = 1
                         LIMIT 1
                        );
    -- RAISE EXCEPTION 'Ошибка.<%> <%>.', vbMovementId_old,(select InvNumber from Movement where id = vbMovementId_old);
     -- пробуем найти следующий док.
     SELECT tmp.Id, tmp.OperDate
            INTO vbMovementId_next, vbOperDate_next
     FROM (SELECT Movement.Id, Movement.OperDate
                  -- По возрастанию, нужен первый следующий
                , ROW_NUMBER() OVER (ORDER BY Movement.OperDate ASC) AS Ord
           FROM (SELECT *
                 FROM Movement
       WHERE Movement.DescId = zc_Movement_ContractGoods()
              AND Movement.OperDate > inOperDate
              AND Movement.StatusId <> zc_Enum_Status_Erased()--zc_Enum_Status_Complete()
              AND Movement.Id <> inId
                 ) AS Movement
               INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                             ON MovementLinkObject_Contract.MovementId = Movement.Id
                                            AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                            AND MovementLinkObject_Contract.ObjectId = inContractId
               INNER JOIN MovementLinkObject AS MovementLinkObject_Currency
                                             ON MovementLinkObject_Currency.MovementId = Movement.Id
                                            AND MovementLinkObject_Currency.DescId = zc_MovementLinkObject_Currency()
                                            AND MovementLinkObject_Currency.ObjectId = inCurrencyId

          ) AS tmp
     WHERE tmp.Ord = 1
     LIMIT 1;
     --RAISE EXCEPTION 'Ошибка.<%> <%>.', vbMovementId_next,(select InvNumber from Movement where id = vbMovementId_next);

     -- конечная дата у текущего документа
     outEndBeginDate := (CASE WHEN vbMovementId_next > 0 THEN vbOperDate_next - INTERVAL '1 DAY' ELSE zc_DateEnd() END);

     -- сохранили свойство <Дата окончания> текущего документа
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndBegin(), inId, outEndBeginDate);

     -- сохранили свойство <Дата окончания> предыдущего документа
     IF COALESCE (vbMovementId_old,0) > 0
     THEN
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndBegin(), vbMovementId_old, (inOperDate - INTERVAL '1 day')::TDateTime);
     END IF;
                          
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.02.25         *
*/

-- тест
-- select * from lpUpdate_Movement_ContractGoods_EndBegin(30173945 , '06.01.2025'::TDateTime, 11672448, 14461, 9457)
 
/*
--пересчет параметра за период


SELECT tt.Id,  tt.OperDate, lpUpdate_Movement_ContractGoods_EndBegin (tt.Id, tt.OperDate, tt.ContractId, tt.CurrencyId, 9457)
FROM (
        SELECT  Movement.Id, Movement.OperDate, MovementLinkObject_Contract.ObjectId AS ContractId, MovementLinkObject_Currency.ObjectId AS CurrencyId 
        FROM Movement
               INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                             ON MovementLinkObject_Contract.MovementId = Movement.Id
                                            AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                          --  AND MovementLinkObject_Contract.ObjectId = 11672448
               INNER JOIN MovementLinkObject AS MovementLinkObject_Currency
                                             ON MovementLinkObject_Currency.MovementId = Movement.Id
                                            AND MovementLinkObject_Currency.DescId = zc_MovementLinkObject_Currency()
                                           -- AND MovementLinkObject_Currency.ObjectId = 14461
WHERE Movement.DescId = zc_Movement_ContractGoods()
     
     AND Movement.OperDate >= '01.11.2024' AND Movement.OperDate < '11.11.2024'--
     -- AND Movement.OperDate >= '11.11.2024' AND Movement.OperDate < '21.11.2024'--
     --AND Movement.OperDate >= '21.11.2024' AND Movement.OperDate < '01.12.2024'--

              AND Movement.StatusId <> zc_Enum_Status_Erased()
--and Movement.Id = 30115650
) AS tt

--SELECT * FROM Movement WHERE Id = 27973035


*/