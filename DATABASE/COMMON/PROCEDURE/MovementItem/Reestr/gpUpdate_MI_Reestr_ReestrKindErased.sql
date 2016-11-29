-- Function: gpUpdate_MI_Reestr_ReestrKindErased()

DROP FUNCTION IF EXISTS gpUpdate_MI_Reestr_ReestrKindErased (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_Reestr_ReestrKindErased(
    IN inId                   Integer   , -- Ид строки реестра
    IN inReestrKindId         Integer   , -- Тип состояния по реестру
    IN inSession              TVarChar    -- сессия пользователя
)                              
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbReestrKindId Integer;
   DECLARE vbId_miSale Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Reestr());
     

    -- ищем строку Реестра с таким док продажи
    vbId_miSale:= (SELECT MF_MovementItemId.MovementId AS MIID_Sale
                   FROM MovementFloat AS MF_MovementItemId 
                   WHERE MF_MovementItemId.DescId = zc_MovementFloat_MovementItemId()
                     AND MF_MovementItemId.ValueData ::integer = inId
                   );

    IF inReestrKindId = zc_Enum_ReestrKind_PartnerIn() THEN 
       -- сохранили <когда сформирована виза "Получено от клиента">   
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartnerIn(), inId, Null);
       -- сохранили связь с <кто сформировал визу "Получено от клиента">
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartnerInTo(), inId, Null);
       -- сохранили связь с <кто сдал документ для визы "Получено от клиента">
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartnerInFrom(), inId, Null);
    END IF;
  
    IF inReestrKindId = zc_Enum_ReestrKind_RemakeIn() THEN 
       -- сохранили <когда сформирована виза "Получено для переделки">   
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_RemakeIn(), inId, Null);
       -- сохранили связь с <кто сформировал визу "Получено для переделки">
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_RemakeInTo(), inId, Null);
       -- сохранили связь с <кто сдал документ для визы "Получено для переделки>
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_RemakeInFrom(), inId, Null);
    END IF;
    
    IF inReestrKindId = zc_Enum_ReestrKind_RemakeBuh() THEN 
       -- сохранили <когда сформирована виза "Бухгалтерия для исправления">   
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_RemakeBuh(), inId, Null);
       -- сохранили связь с <кто сформировал визу "Бухгалтерия для исправления">
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_RemakeBuh(), inId, Null);
    END IF;

    IF inReestrKindId = zc_Enum_ReestrKind_Remake() THEN 
       -- сохранили <когда сформирована виза "Документ исправлен">   
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Remake(), inId, Null);
       -- сохранили связь с <кто сформировал визу "Документ исправлен">
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Remake(), inId, Null);
    END IF;

    IF inReestrKindId = zc_Enum_ReestrKind_Buh() THEN 
       -- сохранили <когда сформирована виза "Бухгалтерия">   
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Buh(), inId, Null);
       -- сохранили связь с <кто сформировал визу "Бухгалтерия">
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Buh(), inId, Null);
    END IF;

    -- Находим предыдущее значение <Состояние по реестру> документа продажи
    vbReestrKindId := (SELECT CASE WHEN tmp.DescId = zc_MIDate_PartnerIn() THEN zc_Enum_ReestrKind_PartnerIn()
                                   WHEN tmp.DescId = zc_MIDate_RemakeIn()  THEN zc_Enum_ReestrKind_RemakeIn()
                                   WHEN tmp.DescId = zc_MIDate_RemakeBuh() THEN zc_Enum_ReestrKind_RemakeBuh()
                                   WHEN tmp.DescId = zc_MIDate_Remake()    THEN zc_Enum_ReestrKind_Remake()
                                   WHEN tmp.DescId = zc_MIDate_Buh()       THEN zc_Enum_ReestrKind_Buh()
                              END 
                       FROM (SELECT ROW_NUMBER() OVER(ORDER BY MID.ValueData desc) AS Num, MID.DescId 
                             FROM MovementItemDate AS MID
                             WHERE MID.MovementItemId = inId
                               AND MID.DescId IN (zc_MIDate_PartnerIn(), zc_MIDate_RemakeIn(), zc_MIDate_RemakeBuh(), zc_MIDate_Remake(), zc_MIDate_Buh())
                               AND MID.ValueData IS NOT NULL
                       ) AS tmp
                       WHERE tmp.Num = 1);

    -- Изменили <Состояние по реестру> в документе продажи на предыдущее
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ReestrKind(), vbId_miSale, COALESCE (vbReestrKindId, zc_Enum_ReestrKind_PartnerOut()));

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 29.11.16         *
 24.10.16         *
*/

-- тест
-- SELECT * FROM gpUpdate_MI_Reestr_ReestrKindErased (inBarCode := '4323306' , inOperDate := ('23.10.2016')::TDateTime , inCarId := 340655 , inPersonalDriverId := 0 , inMemberId := 0 , inDocumentId_Transport := 2298218 ,  inSession := '5');