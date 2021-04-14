-- Function: gpInsert_Object_FinalSUAProtocol()

DROP FUNCTION IF EXISTS gpInsert_Object_FinalSUAProtocol (TDateTime, TDateTime, Text, Text, TFloat, Integer, Integer, TFloat, boolean, boolean, boolean, boolean, boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Object_FinalSUAProtocol(
    IN inDateStart           TDateTime , -- Начало периода
    IN inDateEnd             TDateTime , -- Окончание периода
    IN inRecipientList       Text      , -- Аптеки получатели
    IN inAssortmentList      Text      , -- Аптеки ассортимента
    IN inThreshold           TFloat    , -- Порог минимальных продаж
    IN inDaysStock           Integer   , -- Дней запаса у получателя
    IN inCountPharmacies     Integer   , -- Мин. кол-во аптек ассортимента
    IN inResolutionParameter TFloat    , -- Гранич. параметр разрешения
    IN inisGoodsClose        boolean   , -- Не показывать Закрыт код
    IN inisMCSIsClose        boolean   , -- Не показывать Убит код 
    IN inisNotCheckNoMCS     boolean   , -- Не показывать Продажи не для НТЗ
    IN inisMCSValue          boolean   , -- Учитывать товар с НТЗ > 0
    IN inisRemains           boolean   , -- Остаток получателя > 0
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode   Integer;   
   DECLARE vbId     Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := inSession;
   
   IF COALESCE(inRecipientList, '') = '' OR COALESCE(inAssortmentList, '') = ''
   THEN
     RAISE EXCEPTION 'Не заполнен список подразделений';   
   END IF;

   -- Если код не установлен, определяем его как последний+1
   vbCode:=lfGet_ObjectCode (0, zc_Object_FinalSUAProtocol());
   
   -- сохранили <Объект>
   vbId := lpInsertUpdate_Object(0, zc_Object_FinalSUAProtocol(), vbCode, '');

   -- сохранили
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_FinalSUAProtocol_OperDate(), vbId, CURRENT_TIMESTAMP);
   -- сохранили
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_FinalSUAProtocol_DateStart(), vbId, inDateStart);
   -- сохранили
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_FinalSUAProtocol_DateEnd(), vbId, inDateEnd);

   -- сохранили
   PERFORM lpInsertUpdate_ObjectBlob (zc_objectBlob_FinalSUAProtocol_Recipient(), vbId, inRecipientList);
   -- сохранили
   PERFORM lpInsertUpdate_ObjectBlob (zc_objectBlob_FinalSUAProtocol_Assortment(), vbId, inAssortmentList);

   -- сохранили
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_FinalSUAProtocol_Threshold(), vbId, inThreshold);
   -- сохранили
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_FinalSUAProtocol_DaysStock(), vbId, inDaysStock);
   -- сохранили
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_FinalSUAProtocol_CountPharmacies(), vbId, inCountPharmacies);
   -- сохранили
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_FinalSUAProtocol_ResolutionParameter(), vbId, inResolutionParameter);


   -- сохранили
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_FinalSUAProtocol_GoodsClose(), vbId, inisGoodsClose);
   -- сохранили
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_FinalSUAProtocol_MCSIsClose(), vbId, inIsMCSIsClose);
   -- сохранили
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_FinalSUAProtocol_NotCheckNoMCS(), vbId, inIsNotCheckNoMCS);
   -- сохранили
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_FinalSUAProtocol_MCSValue(), vbId, inisMCSValue);
   -- сохранили
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_FinalSUAProtocol_Remains(), vbId, inisRemains);

   -- сохранили связь с <Пользователи>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_FinalSUAProtocol_User(), vbId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 24.03.21                                                       *
*/

-- select * from gpInsert_Object_FinalSUAProtocol(inDateStart := ('01.10.2020')::TDateTime , inDateEnd := ('31.10.2020')::TDateTime , inRecipientList := '183292' , inAssortmentList := '472116,1781716,6309262' , inThreshold := 1 , inDaysStock := 10, inPercentPharmacies := 75,  inSession := '3');