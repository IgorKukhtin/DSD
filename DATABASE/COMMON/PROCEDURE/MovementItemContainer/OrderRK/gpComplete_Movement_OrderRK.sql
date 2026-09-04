-- Function: gpComplete_Movement_OrderRK()

DROP FUNCTION IF EXISTS gpComplete_Movement_OrderRK (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_OrderRK(
    IN inMovementId        Integer                , -- ключ Документа
   OUT outPrinted          Boolean              ,
   OUT outMessageText      Text                 ,
    IN inSession           TVarChar DEFAULT ''      -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_OrderRK());
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_OrderRK());


      --  Документ
      PERFORM lpComplete_Movement_OrderRK_CreateTemp();


     -- меняем статус документа + сохранили протокол
     SELECT tmp.outPrinted, tmp.outMessageText
            INTO outPrinted, outMessageText
     FROM lpComplete_Movement_OrderRK (inMovementId:= inMovementId
                                     , inUserId    := vbUserId
                                      ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.08.26         *
 */

-- тест
--