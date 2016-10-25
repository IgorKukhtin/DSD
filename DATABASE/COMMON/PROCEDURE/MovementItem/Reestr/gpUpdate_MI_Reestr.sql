-- Function: gpUpdate_MI_Reestr()

DROP FUNCTION IF EXISTS gpUpdate_MI_Reestr (TVarChar, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_Reestr(
    IN inBarCode              TVarChar  , -- штрихкод документа продажи 
    IN inReestrKindId         Integer   , -- Тип состояния по реестру
    IN inMemberId             Integer   , -- Физические лица(водитель/экспедитор) кто сдал документ для визы
    IN inSession              TVarChar    -- сессия пользователя
)                              
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMIId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Reestr());
     
    IF COALESCE (inBarCode, '') = '' THEN 
	Return;
    END IF;

    -- ищем строку Реестра с таким док продажи
    vbMIId:= (SELECT MF_MovementItemId.ValueData ::integer AS Id
              FROM MovementFloat AS MF_MovementItemId 
              WHERE MF_MovementItemId.DescId = zc_MovementFloat_MovementItemId()
                AND MF_MovementItemId.MovementId = CAST (inBarCode AS integer) --saleid
              );

    IF inReestrKindId = zc_Enum_ReestrKind_PartnerIn() THEN 
       -- сохранили <когда сформирована виза "Получено от клиента">   
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartnerIn(), vbMIId, CURRENT_TIMESTAMP);
       -- сохранили связь с <кто сформировал визу "Получено от клиента">
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartnerInTo(), vbMIId, vbUserId);
       -- сохранили связь с <кто сдал документ для визы "Получено от клиента">
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartnerInFrom(), vbMIId, inMemberId);

       -- Изменили <Состояние по реестру> в документе продажи
       PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ReestrKind(), CAST (inBarCode AS integer), inReestrKindId);
    END IF;
  
    IF inReestrKindId = zc_Enum_ReestrKind_RemakeIn() THEN 
       -- сохранили <когда сформирована виза "Получено для переделки">   
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_RemakeIn(), vbMIId, CURRENT_TIMESTAMP);
       -- сохранили связь с <кто сформировал визу "Получено для переделки">
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_RemakeInTo(), vbMIId, vbUserId);
       -- сохранили связь с <кто сдал документ для визы "Получено для переделки">
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_RemakeInFrom(), vbMIId, inMemberId);

       -- Изменили <Состояние по реестру> в документе продажи
       PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ReestrKind(), CAST (inBarCode AS integer), inReestrKindId);
    END IF;
    
    IF inReestrKindId = zc_Enum_ReestrKind_RemakeBuh() THEN 
       -- сохранили <когда сформирована виза "ухгалтерия для исправления">   
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_RemakeBuh(), vbMIId, CURRENT_TIMESTAMP);
       -- сохранили связь с <кто сформировал визу "ухгалтерия для исправления">
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_RemakeBuh(), vbMIId, vbUserId);

       -- Изменили <Состояние по реестру> в документе продажи
       PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ReestrKind(), CAST (inBarCode AS integer), inReestrKindId);
    END IF;

    IF inReestrKindId = zc_Enum_ReestrKind_Remake() THEN 
       -- сохранили <когда сформирована виза "Документ исправлен">   
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Remake(), vbMIId, CURRENT_TIMESTAMP);
       -- сохранили связь с <кто сформировал визу "Документ исправлен">
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Remake(), vbMIId, vbUserId);

       -- Изменили <Состояние по реестру> в документе продажи
       PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ReestrKind(), CAST (inBarCode AS integer), inReestrKindId);
    END IF;

    IF inReestrKindId = zc_Enum_ReestrKind_Buh() THEN 
       -- сохранили <когда сформирована виза "Бухгалтерия">   
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Buh(), vbMIId, CURRENT_TIMESTAMP);
       -- сохранили связь с <кто сформировал визу "Бухгалтерия">
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Buh(), vbMIId, vbUserId);

       -- Изменили <Состояние по реестру> в документе продажи
       PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ReestrKind(), CAST (inBarCode AS integer), inReestrKindId);
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 23.10.16         *
*/

-- тест
----RAISE EXCEPTION 'Ошибка.%, %', outId, vbMIId;
--select * from gpUpdate_MI_Reestr(inBarCode := '4323306' , inOperDate := ('23.10.2016')::TDateTime , inCarId := 340655 , inPersonalDriverId := 0 , inMemberId := 0 , inDocumentId_Transport := 2298218 ,  inSession := '5');