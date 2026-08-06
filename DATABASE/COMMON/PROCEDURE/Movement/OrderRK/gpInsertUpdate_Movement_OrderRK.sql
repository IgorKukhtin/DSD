-- Function: gpInsertUpdate_Movement_OrderRK()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderRK (Integer, TVarChar, TDateTime, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderRK (Integer, Integer, TVarChar, TDateTime, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_OrderRK(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ>
    IN inParentId            Integer  , --
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inComment             TVarChar  , -- Примечание
   OUT outRouteName          TVarChar  , --
   OUT outRetailName         TVarChar  , --
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Record AS
$BODY$
   DECLARE vbUserId Integer;
           vbFromId Integer;
           vbToId   Integer;
           vbRouteId  Integer;
           vbRetailId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderRK());

     --получаем по док. Заявка стороняя
     vbFromId := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.DescId = zc_MovementLinkObject_To() AND MLO.MovementId = inParentId);
     vbToId   := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.DescId = zc_MovementLinkObject_From() AND MLO.MovementId = inParentId);
     vbRouteId := (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.DescId = zc_ObjectLink_Partner_Route() AND OL.ObjectId = vbToId);
     vbRetailId:= (SELECT ObjectLink_Juridical_Retail.ChildObjectId
                   FROM ObjectLink AS OL_Juridical
                        LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                               ON ObjectLink_Juridical_Retail.ObjectId = OL_Juridical.ChildObjectId
                              AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                   WHERE OL_Juridical.DescId = zc_ObjectLink_Partner_Juridical() AND OL_Juridical.ObjectId = vbToId
                   ); 
     
     -- сохранили <Документ>
      SELECT tmp.ioId
    INTO ioId
      FROM lpInsertUpdate_Movement_OrderRK (ioId           := ioId
                                          , inParentId     := inParentId
                                          , inInvNumber    := inInvNumber
                                          , inOperDate     := inOperDate
                                          , inFromId       := vbFromId
                                          , inToId         := vbToId
                                          , inRouteId      := vbRouteId 
                                          , inRetailId     := vbRetailId
                                          , inComment      := inComment
                                          , inUserId       := vbUserId
                                           ) AS tmp;

    --
    outRouteName  := (SELECT Object.ValueData FROM Object WHERE Object.Id = vbRouteId);
    outRetailName := (SELECT Object.ValueData FROM Object WHERE Object.Id = vbRetailId);
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