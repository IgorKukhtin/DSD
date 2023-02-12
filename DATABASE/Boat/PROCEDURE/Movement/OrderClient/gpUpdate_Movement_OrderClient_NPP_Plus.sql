-- Function: gpInsertUpdate_Movement_OrderClient()

DROP FUNCTION IF EXISTS gpUpdate_Movement_OrderClient_NPP_Plus (Integer, TFloat, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_OrderClient_NPP_Plus(
    IN inId                  Integer   , -- Ключ объекта <Документ>
 INOUT ioNPP                 TFloat    , -- Очередность сборки
    IN inIsPlus              Boolean   , -- Увеличиваем или уменьшаем значение NPP
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS TFloat
AS
$BODY$
   DECLARE vbUserId  Integer;
   DECLARE vbNPP_old TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderClient());
     vbUserId := lpGetUserBySession (inSession);

     -- нашли
     vbNPP_old:= COALESCE ((SELECT MovementFloat.ValueData FROM MovementFloat WHERE MovementFloat.MovementId = inId AND MovementFloat.DescId = zc_MovementFloat_NPP()), 0);

     -- расчет нового значения
     IF inIsPlus = TRUE
     THEN -- если был без номера
          IF ioNPP = 0
          THEN -- будет "новым" последним
               ioNPP:= 1 + COALESCE ((SELECT MAX (MovementFloat.ValueData)
                                      FROM MovementFloat
                                           INNER JOIN Movement ON Movement.Id       = MovementFloat.MovementId
                                                              AND Movement.DescId   = zc_Movement_OrderClient()
                                                              AND Movement.StatusId <> zc_Enum_Status_Erased()
                                      WHERE MovementFloat.DescId    = zc_MovementFloat_NPP()
                                        AND MovementFloat.ValueData > 0
                                     ), 0);
          -- иначе ставим позже
          ELSE ioNPP:= ioNPP + 1;
          END IF;

     ELSE
         -- если NPP уже был
         IF ioNPP >= 1
         THEN -- ставим раньше
              ioNPP:= ioNPP - 1;
         ELSE
             -- будет "новым" последним
             ioNPP:= 1 + COALESCE ((SELECT MAX (MovementFloat.ValueData)
                                    FROM MovementFloat
                                         INNER JOIN Movement ON Movement.Id       = MovementFloat.MovementId
                                                            AND Movement.DescId   = zc_Movement_OrderClient()
                                                            AND Movement.StatusId <> zc_Enum_Status_Erased()
                                    WHERE MovementFloat.DescId    = zc_MovementFloat_NPP()
                                      AND MovementFloat.ValueData > 0
                                   ), 0);
         END IF;

     END IF;


     -- сохранили новое значение <NPP>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_NPP(), inId, ioNPP);

     -- Если стал = 0
     IF ioNPP = 0 AND vbNPP_old > 0
     THEN
         -- т.е. был 1-м, поэтому всем -1
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_NPP(), MovementFloat.MovementId
                                               -- так всех перенумеровать
                                             , MovementFloat.ValueData - 1
                                              )
         FROM MovementFloat
              INNER JOIN Movement ON Movement.Id       = MovementFloat.MovementId
                                 AND Movement.DescId   = zc_Movement_OrderClient()
                                 AND Movement.StatusId <> zc_Enum_Status_Erased()
         WHERE MovementFloat.DescId     = zc_MovementFloat_NPP()
           AND MovementFloat.ValueData  > 1
           AND MovementFloat.MovementId <> inId
          ;

     -- если с "новым" NPP есть другой, тогда меняем их местами
     ELSEIF EXISTS (SELECT 1
                FROM MovementFloat
                WHERE MovementFloat.DescId = zc_MovementFloat_NPP()
                  AND MovementFloat.ValueData  = ioNPP
                  AND MovementFloat.MovementId <> inId
               )
     THEN
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_NPP(), MovementFloat.MovementId
                                             , COALESCE (MovementFloat.ValueData,0)
                                               -- так меняем местами
                                             + CASE WHEN inIsPlus = TRUE THEN -1 ELSE 1 END
                                              )
         FROM MovementFloat
             INNER JOIN Movement ON Movement.Id       = MovementFloat.MovementId
                                AND Movement.DescId   = zc_Movement_OrderClient()
                                AND Movement.StatusId <> zc_Enum_Status_Erased()
         WHERE MovementFloat.DescId     = zc_MovementFloat_NPP()
           AND MovementFloat.ValueData  = ioNPP
           AND MovementFloat.MovementId <> inId
        ;

     END IF;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.02.23         *
*/

-- тест
--