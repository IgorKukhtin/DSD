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
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartnerIn(), inId, CURRENT_TIMESTAMP);
       -- сохранили связь с <кто сформировал визу "Получено от клиента">
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartnerInTo(), inId, vbUserId);
       -- сохранили связь с <кто сдал документ для визы "Получено от клиента">
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartnerInFrom(), inId, Null);

       -- Изменили <Состояние по реестру> в документе продажи
       PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ReestrKind(), vbId_miSale, Null);
    END IF;
  
    IF inReestrKindId = zc_Enum_ReestrKind_RemakeIn() THEN 
       -- сохранили <когда сформирована виза "Получено для переделки">   
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_RemakeIn(), inId, CURRENT_TIMESTAMP);
       -- сохранили связь с <кто сформировал визу "Получено для переделки">
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_RemakeInTo(), inId, vbUserId);
       -- сохранили связь с <кто сдал документ для визы "Получено для переделки>
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_RemakeInFrom(), inId, Null);

       -- Изменили <Состояние по реестру> в документе продажи
       PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ReestrKind(), vbId_miSale, Null);
    END IF;
    
    IF inReestrKindId = zc_Enum_ReestrKind_RemakeBuh() THEN 
       -- сохранили <когда сформирована виза "Бухгалтерия для исправления">   
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_RemakeBuh(), inId, CURRENT_TIMESTAMP);
       -- сохранили связь с <кто сформировал визу "Бухгалтерия для исправления">
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_RemakeBuh(), inId, vbUserId);

       -- Изменили <Состояние по реестру> в документе продажи
       PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ReestrKind(), vbId_miSale, Null);
    END IF;

    IF inReestrKindId = zc_Enum_ReestrKind_Remake() THEN 
       -- сохранили <когда сформирована виза "Документ исправлен">   
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Remake(), inId, CURRENT_TIMESTAMP);
       -- сохранили связь с <кто сформировал визу "Документ исправлен">
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Remake(), inId, vbUserId);

       -- Изменили <Состояние по реестру> в документе продажи
       PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ReestrKind(), vbId_miSale, Null);
    END IF;

    IF inReestrKindId = zc_Enum_ReestrKind_Buh() THEN 
       -- сохранили <когда сформирована виза "Бухгалтерия">   
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Buh(), inId, CURRENT_TIMESTAMP);
       -- сохранили связь с <кто сформировал визу "Бухгалтерия">
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Buh(), inId, vbUserId);

    END IF;

    -- Изменили <Состояние по реестру> в документе продажи
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ReestrKind(), vbId_miSale, Null);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 24.10.16         *
*/

-- тест
-- SELECT * FROM gpUpdate_MI_Reestr_ReestrKindErased (inBarCode := '4323306' , inOperDate := ('23.10.2016')::TDateTime , inCarId := 340655 , inPersonalDriverId := 0 , inMemberId := 0 , inDocumentId_Transport := 2298218 ,  inSession := '5');
