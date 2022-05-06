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
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Reestr());
     

    -- ищем строку Реестра с таким док продажи
    vbId_miSale:= (SELECT MF_MovementItemId.MovementId AS MIID_Sale
                   FROM MovementFloat AS MF_MovementItemId 
                   WHERE MF_MovementItemId.DescId = zc_MovementFloat_MovementItemId()
                     AND MF_MovementItemId.ValueData ::integer = inId
                   );

    IF inReestrKindId = zc_Enum_ReestrKind_Log() THEN 
       -- сохранили <когда сформирована виза "Отдел логистики">   
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Log(), inId, Null);
       -- сохранили связь с <кто сформировал визу "Логистики">
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Log(), inId, Null);
    END IF;
    
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

    IF inReestrKindId = zc_Enum_ReestrKind_TransferIn() THEN 
       -- сохранили <когда сформирована виза "Транзит получен">   
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_TransferIn(), inId, Null);
       -- сохранили связь с <кто сформировал визу "Транзит получен">
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_TransferIn(), inId, Null);
    END IF;
    
    IF inReestrKindId = zc_Enum_ReestrKind_TransferOut() THEN 
       -- сохранили <когда сформирована виза "Транзит возвращен">   
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_TransferOut(), inId, Null);
       -- сохранили связь с <кто сформировал визу "Транзит возвращен">
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_TransferOut(), inId, Null);
    END IF;

    IF inReestrKindId = zc_Enum_ReestrKind_Double() THEN 
       -- сохранили <когда сформирована виза "Выведен дубликат">   
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Double(), inId, Null);
       -- сохранили связь с <кто сформировал визу "Выведен дубликат">
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Double(), inId, Null);
    END IF;

    IF inReestrKindId = zc_Enum_ReestrKind_Scan() THEN 
       -- сохранили <когда сформирована виза "В наличии скан">   
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Scan(), inId, Null);
       -- сохранили связь с <кто сформировал визу "В наличии скан">
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Scan(), inId, Null);
    END IF;
    
    -- Находим предыдущее значение <Состояние по реестру> документа продажи
    vbReestrKindId := (SELECT CASE WHEN tmp.DescId = zc_MIDate_Log()         THEN zc_Enum_ReestrKind_Log()
                                   WHEN tmp.DescId = zc_MIDate_PartnerIn()   THEN zc_Enum_ReestrKind_PartnerIn()
                                   WHEN tmp.DescId = zc_MIDate_RemakeIn()    THEN zc_Enum_ReestrKind_RemakeIn()
                                   WHEN tmp.DescId = zc_MIDate_RemakeBuh()   THEN zc_Enum_ReestrKind_RemakeBuh()
                                   WHEN tmp.DescId = zc_MIDate_Remake()      THEN zc_Enum_ReestrKind_Remake()
                                   WHEN tmp.DescId = zc_MIDate_Econom()      THEN zc_Enum_ReestrKind_Econom()
                                   WHEN tmp.DescId = zc_MIDate_Double()      THEN zc_Enum_ReestrKind_Double()
                                   WHEN tmp.DescId = zc_MIDate_Scan()        THEN zc_Enum_ReestrKind_Scan()
                                   WHEN tmp.DescId = zc_MIDate_Buh()         THEN zc_Enum_ReestrKind_Buh()
                                   WHEN tmp.DescId = zc_MIDate_TransferIn()  THEN zc_Enum_ReestrKind_TransferIn()
                                   WHEN tmp.DescId = zc_MIDate_TransferOut() THEN zc_Enum_ReestrKind_TransferOut()
                              END 
                       FROM (SELECT ROW_NUMBER() OVER(ORDER BY MID.ValueData desc) AS Num, MID.DescId 
                             FROM MovementItemDate AS MID
                             WHERE MID.MovementItemId = inId
                               AND MID.DescId IN (zc_MIDate_Log(), zc_MIDate_PartnerIn(), zc_MIDate_RemakeIn(), zc_MIDate_RemakeBuh(), zc_MIDate_Econom()
                                                , zc_MIDate_Remake(), zc_MIDate_Buh(), zc_MIDate_TransferIn(), zc_MIDate_TransferOut()
                                                , zc_MIDate_Double(), zc_MIDate_Scan())
                               AND MID.ValueData IS NOT NULL
                       ) AS tmp
                       WHERE tmp.Num = 1);


    -- Изменили <Состояние по реестру> в документе продажи на предыдущее
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ReestrKind(), vbId_miSale, COALESCE (vbReestrKindId, zc_Enum_ReestrKind_PartnerOut()));

    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 05.05.22         *
 17.11.20         * _Log
 20.07.17         *
 29.11.16         *
 24.10.16         *
*/

-- тест
-- SELECT * FROM gpUpdate_MI_Reestr_ReestrKindErased (inBarCode := '4323306' , inOperDate := ('23.10.2016')::TDateTime , inCarId := 340655 , inPersonalDriverId := 0 , inMemberId := 0 , inDocumentId_Transport := 2298218 ,  inSession := '5');
