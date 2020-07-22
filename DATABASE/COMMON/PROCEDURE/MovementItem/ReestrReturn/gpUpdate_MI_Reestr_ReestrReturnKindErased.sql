-- Function: gpUpdate_MI_Reestr_ReestrKindErased()

DROP FUNCTION IF EXISTS gpUpdate_MI_Reestr_ReestrReturnKindErased (Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_MI_ReestrReturn_ReestrKindErased (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_ReestrReturn_ReestrKindErased(
    IN inId                   Integer   , -- Ид строки реестра
    IN inReestrKindId         Integer   , -- Тип состояния по реестру
    IN inSession              TVarChar    -- сессия пользователя
)                              
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbReestrKindId Integer;
   DECLARE vbId_miReturn Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ReestrReturn());
     

    -- ищем строку Реестра с таким док продажи
    vbId_miReturn:= (SELECT MF_MovementItemId.MovementId AS MIID_Return
                   FROM MovementFloat AS MF_MovementItemId 
                   WHERE MF_MovementItemId.DescId = zc_MovementFloat_MovementItemId()
                     AND MF_MovementItemId.ValueData ::integer = inId
                   );

    IF inReestrKindId = zc_Enum_ReestrKind_PartnerIn() THEN 
       -- сохранили <когда сформирована виза "Получено от клиента">   
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartnerIn(), inId, Null);
    END IF;
  
    IF inReestrKindId = zc_Enum_ReestrKind_RemakeBuh() THEN 
       -- сохранили <когда сформирована виза "Бухгалтерия для исправления">   
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_RemakeBuh(), inId, Null);
       -- сохранили связь с <кто сформировал визу "Бухгалтерия для исправления">
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_RemakeBuh(), inId, Null);
    END IF;

    IF inReestrKindId = zc_Enum_ReestrKind_Econom() THEN 
       -- сохранили <когда сформирована виза "Экономисты">   
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Econom(), inId, Null);
       -- сохранили связь с <кто сформировал визу "Экономисты">
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Econom(), inId, Null);
    END IF;

    IF inReestrKindId = zc_Enum_ReestrKind_Buh() THEN 
       -- сохранили <когда сформирована виза "Бухгалтерия">   
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Buh(), inId, Null);
       -- сохранили связь с <кто сформировал визу "Бухгалтерия">
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Buh(), inId, Null);
    END IF;

    -- Находим предыдущее значение <Состояние по реестру> документа возврат
    vbReestrKindId := (SELECT CASE WHEN tmp.DescId = zc_MIDate_PartnerIn() THEN zc_Enum_ReestrKind_PartnerIn()
                                   WHEN tmp.DescId = zc_MIDate_RemakeBuh() THEN zc_Enum_ReestrKind_RemakeBuh()
                                   WHEN tmp.DescId = zc_MIDate_Econom()    THEN zc_Enum_ReestrKind_Econom()
                                   WHEN tmp.DescId = zc_MIDate_Buh()       THEN zc_Enum_ReestrKind_Buh()
                              END
                       FROM (SELECT ROW_NUMBER() OVER(ORDER BY MID.ValueData desc) AS Num, MID.DescId 
                             FROM MovementItemDate AS MID
                             WHERE MID.MovementItemId = inId
                               AND MID.DescId IN (zc_MIDate_PartnerIn(), zc_MIDate_RemakeBuh(), zc_MIDate_Econom(), zc_MIDate_Buh())
                               AND MID.ValueData IS NOT NULL
                       ) AS tmp
                       WHERE tmp.Num = 1);

    -- Изменили <Состояние по реестру> в документе возврата на предыдущее
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ReestrKind(), vbId_miReturn, COALESCE (vbReestrKindId, zc_Enum_ReestrKind_PartnerIn()));

    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.07.20         *
 18.04.17         *
*/

-- тест
-- SELECT * FROM gpUpdate_MI_Reestr_ReestrKindErased (inBarCode := '4323306' , inOperDate := ('23.10.2016')::TDateTime , inCarId := 340655 , inPersonalDriverId := 0 , inMemberId := 0 , inDocumentId_Transport := 2298218 ,  inSession := '5');
