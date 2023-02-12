-- Function: gpInsertUpdate_Movement_OrderClient()

DROP FUNCTION IF EXISTS gpUpdate_Movement_OrderClient_NPP (Integer, Integer, TDateTime, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_OrderClient_NPP(
    IN inId                  Integer   , -- Ключ объекта <Документ>
    IN inProductId           Integer   , -- Лодка
    IN inDateBegin           TDateTime ,
    IN inNPP                 TFloat    , -- Очередность сборки
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId  Integer;
   DECLARE vbNPP_old TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderClient());
     vbUserId := lpGetUserBySession (inSession);


     -- нашли
     vbNPP_old:= (SELECT MovementFloat.ValueData FROM MovementFloat WHERE MovementFloat.MovementId = inId AND MovementFloat.DescId = zc_MovementFloat_NPP());

     -- сохранили новое значение <NPP>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_NPP(), inId, inNPP);

     -- Если стал = 0
     IF ioNPP = 0 AND vbNPP_old > 0
     THEN
         -- тогда всех подтягиваем к этому номеру
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_NPP(), MovementFloat.MovementId, MovementFloat.ValueData - 1)
         FROM MovementFloat
             INNER JOIN Movement ON Movement.Id = MovementFloat.MovementId
                                AND Movement.DescId = zc_Movement_OrderClient()
                                AND Movement.StatusId <> zc_Enum_Status_Erased()
         WHERE MovementFloat.DescId = zc_MovementFloat_NPP()
           AND MovementFloat.ValueData  >= vbNPP_old
           AND MovementFloat.MovementId <> inId
          ;

     -- если с "новым" NPP есть другой, тогда всех сдвигаем на +1
     ELSEIF EXISTS (SELECT 1
                    FROM MovementFloat
                    WHERE MovementFloat.DescId = zc_MovementFloat_NPP()
                      AND COALESCE (MovementFloat.ValueData,0) = inNPP
                      AND MovementFloat.MovementId <> inId
                   )
     THEN
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_NPP(), MovementFloat.MovementId, MovementFloat.ValueData + 1)
         FROM MovementFloat
             INNER JOIN Movement ON Movement.Id = MovementFloat.MovementId
                                AND Movement.DescId = zc_Movement_OrderClient()
                                AND Movement.StatusId <> zc_Enum_Status_Erased()
         WHERE MovementFloat.DescId = zc_MovementFloat_NPP()
           AND MovementFloat.ValueData  >= inNPP
           AND MovementFloat.MovementId <> inId
          ;

     END IF; 
 
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Product_DateBegin(), inProductId, inDateBegin);     

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