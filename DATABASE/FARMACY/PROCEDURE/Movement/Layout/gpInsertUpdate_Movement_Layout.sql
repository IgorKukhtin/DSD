-- Function: gpInsertUpdate_Movement_Layout()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Layout (Integer, TVarChar, TDateTime, Integer, TVarChar, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Layout(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Списания>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inLayoutId            Integer   , -- название выкладки
    IN inComment             TVarChar  , -- Примечание
    IN inisPharmacyItem      Boolean   , -- Для аптечных пунктов
    IN inisNotMoveRemainder6 Boolean   , -- Не перемещать остаток менее 6 мес.
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Layout());
     vbUserId:= lpGetUserBySession (inSession);


     -- проверка по одному документу для каждого наименования выкладки и если удалили то можно новый создать но при этом старый запретить распроводить если есть новый
     IF EXISTS (SELECT 1
                FROM Movement
                     INNER JOIN MovementLinkObject AS MovementLinkObject_Layout
                                                   ON MovementLinkObject_Layout.MovementId = Movement.Id
                                                  AND MovementLinkObject_Layout.DescId = zc_MovementLinkObject_Layout()
                                                  AND MovementLinkObject_Layout.ObjectId = inLayoutId
                WHERE Movement.DescId = zc_Movement_Layout()
                  AND Movement.StatusId <> zc_Enum_Status_Erased()
                  AND Movement.Id <> ioId)
     THEN
          RAISE EXCEPTION 'Ошибка.Документ для выкладки <%> уже существует.', lfGet_Object_ValueData (inLayoutId);
     END IF;
     
     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement_Layout (ioId                  := ioId
                                           , inInvNumber           := inInvNumber
                                           , inOperDate            := inOperDate
                                           , inLayoutId            := inLayoutId
                                           , inComment             := inComment
                                           , inisPharmacyItem      := inisPharmacyItem
                                           , inisNotMoveRemainder6 := inisNotMoveRemainder6
                                           , inUserId              := vbUserId
                                            );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 27.08.20         *
 */

-- тест
--