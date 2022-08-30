-- Function: gpUpdate_ScaleCeh_Movement_Status()

DROP FUNCTION IF EXISTS gpUpdate_ScaleCeh_Movement_Status (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_ScaleCeh_Movement_Status(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inStatusId            Integer   , --
    IN inBranchCode          Integer   , --
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Scale_Movement_check());
     vbUserId:= lpGetUserBySession (inSession);


     -- Проверка
     IF COALESCE (inMovementId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Документ <Перемещение> не выбран.';
     END IF;

     -- Проверка
     IF inBranchCode <> 101 OR NOT EXISTS (SELECT 1 FROM Object_Unit_Scale_upak_View)
     THEN
         RAISE EXCEPTION 'Ошибка.Нет прав % документ <%>.<%>'
                        , CASE WHEN inStatusId = zc_Enum_Status_Complete() THEN 'Проводить' ELSE 'Распроводить' END
                        , (SELECT MovementDesc.ItemName FROM Movement JOIN MovementDesc ON MovementDesc.Id = Movement.DescId WHERE Movement.Id = inMovementId)
                        , inBranchCode
         ;
     END IF;
     -- Проверка
     IF NOT EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inMovementId AND Movement.DescId = zc_Movement_Send())
     THEN
         RAISE EXCEPTION 'Ошибка.Нет прав % документ <%>.'
                        , CASE WHEN inStatusId = zc_Enum_Status_Complete() THEN 'Проводить' ELSE 'Распроводить' END
                        , (SELECT MovementDesc.ItemName FROM Movement JOIN MovementDesc ON MovementDesc.Id = Movement.DescId WHERE Movement.Id = inMovementId)
         ;
     END IF;
     -- Проверка
     IF NOT EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inMovementId AND Movement.OperDate >= CURRENT_DATE - INTERVAL '1 DAY')
     THEN
         RAISE EXCEPTION 'Ошибка.Нет прав % документ за <%>.'
                        , CASE WHEN inStatusId = zc_Enum_Status_Complete() THEN 'Проводить' ELSE 'Распроводить' END
                        , (SELECT zfConvert_DateToString (Movement.OperDate) FROM Movement WHERE Movement.Id = inMovementId)
         ;
     END IF;
     -- Проверка
     IF EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inMovementId AND Movement.StatusId = inStatusId)
     THEN
         RAISE EXCEPTION 'Ошибка.Документ уже в статусе <%>.'
                        , lfGet_Object_ValueData_sh (inStatusId)
         ;
     END IF;
     -- Проверка
     IF NOT EXISTS (SELECT 1
                    FROM Movement
                         INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                                      AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                                                      AND MovementLinkObject_From.ObjectId   = 8459 -- Розподільчий комплекс

                         INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                                      AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                                      AND MovementLinkObject_To.ObjectId   = 8451 -- ЦЕХ упаковки
                    WHERE Movement.Id = inMovementId
                   )
     THEN
         RAISE EXCEPTION 'Ошибка.Нет прав % документ <%> От кого = <%> Кому = <%>.'
                        , CASE WHEN inStatusId = zc_Enum_Status_Complete() THEN 'Проводить' ELSE 'Распроводить' END
                        , (SELECT MovementDesc.ItemName FROM Movement JOIN MovementDesc ON MovementDesc.Id = Movement.DescId WHERE Movement.Id = inMovementId)
                        , (SELECT Object_From.ValueData
                           FROM Movement
                                INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                              ON MovementLinkObject_From.MovementId = Movement.Id
                                                             AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                                LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
                           WHERE Movement.Id = inMovementId
                          )
                        , (SELECT Object_To.ValueData
                           FROM Movement
                                INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                              ON MovementLinkObject_To.MovementId = Movement.Id
                                                             AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
                           WHERE Movement.Id = inMovementId
                          )
         ;
     END IF;


     -- сохранили
     IF inStatusId = zc_Enum_Status_Complete()
     THEN
         -- Проводим Документ
         PERFORM gpComplete_Movement_Send (inMovementId     := inMovementId
                                         , inIsLastComplete := NULL
                                         , inSession        := inSession
                                          );
     ELSE
         -- Распроводим Документ !!!существующий!!!
         PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                      , inUserId     := vbUserId
                                       );
     END IF;

     -- Проверка
     IF 1=1 AND vbUserId = 5
     THEN
         RAISE EXCEPTION 'Ошибка.Test Admin - ok.';
     END IF;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 26.06.18                                        *
*/

-- тест
-- SELECT * FROM gpUpdate_ScaleCeh_Movement_Status (inMovementId:= 1, inStatusId:=zc_Enum_Status_Complete(), inBranchCode:= 101, inSession:= '5')
