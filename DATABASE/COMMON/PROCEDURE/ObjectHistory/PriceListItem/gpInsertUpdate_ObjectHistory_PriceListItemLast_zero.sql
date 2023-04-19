-- Function: gpInsertUpdate_ObjectHistory_PriceListItemLast_zero (Integer, Integer, Integer, TDateTime, TFloat, Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_PriceListItemLast_zero (Integer, Integer, Integer, Integer, TDateTime, TFloat, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_ObjectHistory_PriceListItemLast_zero(
 INOUT ioId                     Integer,    -- ключ объекта <Элемент прайс-листа>
    IN inPriceListId            Integer,    -- Прайс-лист
    IN inGoodsId                Integer,    -- Товар
    IN inGoodsKindId            Integer,    -- Вид Товара
    IN inOperDate               TDateTime,  -- Дата действия цены
   OUT outStartDate             TDateTime,  -- Дата действия цены
   OUT outEndDate               TDateTime,  -- Дата действия цены
    IN inValue                  TFloat,     -- Значение цены
   OUT outPriceNoVAT            TFloat,     -- Значение цены без НДС
   OUT outPriceWVAT             TFloat,     -- Значение цены с НДС
    IN inIsLast                 Boolean,    -- 
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
DECLARE
   DECLARE vbUserId Integer;
   DECLARE vbPriceListItemId Integer;
   DECLARE vbPriceWithVAT Boolean;
   DECLARE vbVATPercent TFloat;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_OH_PriceListItem_zero());


   -- если не назначена роль <Прайс-лист - изменение в любом прайсе>
   IF NOT EXISTS (SELECT 1 FROM Object_Role_Process_View WHERE ProcessId = zc_Enum_Process_Update_PriceListItem() AND UserId = vbUserId)
      OR EXISTS (SELECT 1 FROM Object_MemberPriceList_View AS MemberPriceList_View WHERE MemberPriceList_View.UserId = vbUserId)
   THEN
       -- поиск в настройках "Доступ к прайсу"
       IF NOT EXISTS (SELECT 1 FROM Object_MemberPriceList_View AS MemberPriceList_View WHERE MemberPriceList_View.UserId = vbUserId)
       THEN
           RAISE EXCEPTION 'Ошибка. Нет прав корректировать прайс <%>', lfGet_Object_ValueData (inPriceListId);

       -- проверка в настройках "Доступ к прайсу" - что это именно тот Прайс
       ELSEIF NOT EXISTS (SELECT 1 FROM Object_MemberPriceList_View AS MemberPriceList_View WHERE MemberPriceList_View.UserId = vbUserId AND MemberPriceList_View.PriceListId = inPriceListId)
       THEN
           RAISE EXCEPTION 'Ошибка. У пользователя <%>.%Нет прав корректировать прайс <%>.%Можно корректировать только такие Прайсы:% %'
                         , lfGet_Object_ValueData (vbUserId)
                         , CHR (13)
                         , lfGet_Object_ValueData (inPriceListId)
                         , CHR (13)
                         , CHR (13)
                         , (SELECT STRING_AGG ('< ' || MemberPriceList_View.PriceListName || ' >', '; ') FROM Object_MemberPriceList_View AS MemberPriceList_View WHERE MemberPriceList_View.UserId = vbUserId)
                          ;
       END IF;
   END IF;


   -- Ограничение - если роль Начисления транспорт-меню
   IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE RoleId = 78489 AND UserId = vbUserId)
      AND NOT EXISTS (SELECT 1 AS Id FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = vbUserId)
      AND COALESCE (inPriceListId, 0) NOT IN (SELECT zc_PriceList_Fuel()
                                             UNION
                                              SELECT DISTINCT ObjectLink_Contract_PriceList.ChildObjectId
                                              FROM ObjectLink AS ObjectLink_Contract_InfoMoney
                                                   INNER JOIN ObjectLink AS ObjectLink_Contract_PriceList
                                                                         ON ObjectLink_Contract_PriceList.ObjectId      = ObjectLink_Contract_InfoMoney.ObjectId
                                                                        AND ObjectLink_Contract_PriceList.DescId        = zc_ObjectLink_Contract_PriceList()
                                                                        AND ObjectLink_Contract_PriceList.ChildObjectId > 0
                                              WHERE ObjectLink_Contract_InfoMoney.DescId        = zc_ObjectLink_Contract_InfoMoney()
                                                AND ObjectLink_Contract_InfoMoney.ChildObjectId = zc_Enum_InfoMoney_20401() -- ГСМ
                                             UNION
                                              SELECT DISTINCT ObjectLink_Juridical_PriceList.ChildObjectId
                                              FROM ObjectLink AS ObjectLink_CardFuel_Juridical
                                                   INNER JOIN ObjectLink AS ObjectLink_Juridical_PriceList
                                                                         ON ObjectLink_Juridical_PriceList.ObjectId      = ObjectLink_CardFuel_Juridical.ObjectId
                                                                        AND ObjectLink_Juridical_PriceList.DescId        = zc_ObjectLink_Juridical_PriceList()
                                                                        AND ObjectLink_Juridical_PriceList.ChildObjectId > 0
                                              WHERE ObjectLink_CardFuel_Juridical.ObjectId > 0
                                                AND ObjectLink_CardFuel_Juridical.DescId   = zc_ObjectLink_CardFuel_Juridical()
                                             )
   THEN
       RAISE EXCEPTION 'Ошибка. Нет прав корректировать прайс <%>', lfGet_Object_ValueData (inPriceListId);
   END IF;

   -- !!!определяется!!!
   IF inIsLast = TRUE THEN ioId:= 0; END IF;

   -- Получаем ссылку на объект цен
   vbPriceListItemId := lpGetInsert_Object_PriceListItem (inPriceListId, inGoodsId, inGoodsKindId, vbUserId);
 
   -- Вставляем или меняем объект историю цен
   ioId := lpInsertUpdate_ObjectHistory (ioId, zc_ObjectHistory_PriceListItem(), vbPriceListItemId, inOperDate, vbUserId);
   -- Устанавливаем цену
   PERFORM lpInsertUpdate_ObjectHistoryFloat (zc_ObjectHistoryFloat_PriceListItem_Value(), ioId, inValue);

   --
   IF inIsLast = TRUE AND EXISTS (SELECT Id FROM ObjectHistory WHERE DescId = zc_ObjectHistory_PriceListItem() AND ObjectId = vbPriceListItemId AND StartDate > inOperDate)
   THEN
         -- сохранили протокол - "удаление"
         PERFORM lpInsert_ObjectHistoryProtocol (ObjectHistory.ObjectId, vbUserId, ObjectHistory.StartDate, ObjectHistory.EndDate, ObjectHistoryFloat_Value.ValueData, '', TRUE, TRUE)
         FROM ObjectHistory
              LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Value
                                           ON ObjectHistoryFloat_Value.ObjectHistoryId = ObjectHistory.Id
                                          AND ObjectHistoryFloat_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
         WHERE ObjectHistory.DescId = zc_ObjectHistory_PriceListItem() AND ObjectHistory.ObjectId = vbPriceListItemId AND ObjectHistory.StartDate > inOperDate;

         -- удалили
         DELETE FROM ObjectHistoryDate WHERE ObjectHistoryId IN (SELECT Id FROM ObjectHistory WHERE DescId = zc_ObjectHistory_PriceListItem() AND ObjectId = vbPriceListItemId AND StartDate > inOperDate);
         DELETE FROM ObjectHistoryFloat WHERE ObjectHistoryId IN (SELECT Id FROM ObjectHistory WHERE DescId = zc_ObjectHistory_PriceListItem() AND ObjectId = vbPriceListItemId AND StartDate > inOperDate);
         DELETE FROM ObjectHistoryString WHERE ObjectHistoryId IN (SELECT Id FROM ObjectHistory WHERE DescId = zc_ObjectHistory_PriceListItem() AND ObjectId = vbPriceListItemId AND StartDate > inOperDate);
         DELETE FROM ObjectHistoryLink WHERE ObjectHistoryId IN (SELECT Id FROM ObjectHistory WHERE DescId = zc_ObjectHistory_PriceListItem() AND ObjectId = vbPriceListItemId AND StartDate > inOperDate);
         DELETE FROM ObjectHistory WHERE Id IN (SELECT Id FROM ObjectHistory WHERE DescId = zc_ObjectHistory_PriceListItem() AND ObjectId = vbPriceListItemId AND StartDate > inOperDate);
         -- Здесь надо изменить св-во EndDate
         UPDATE ObjectHistory SET EndDate = zc_DateEnd() WHERE Id = ioId;
   END IF;


   -- вернули значения
   SELECT StartDate, EndDate INTO outStartDate, outEndDate FROM ObjectHistory WHERE Id = ioId;

       -- параметры прайс листа
       SELECT ObjectBoolean_PriceWithVAT.ValueData AS PriceWithVAT
            , ObjectFloat_VATPercent.ValueData     AS VATPercent
      INTO vbPriceWithVAT, vbVATPercent
       FROM ObjectBoolean AS ObjectBoolean_PriceWithVAT
            LEFT JOIN ObjectFloat AS ObjectFloat_VATPercent
                                  ON ObjectFloat_VATPercent.ObjectId = ObjectBoolean_PriceWithVAT.ObjectId
                                 AND ObjectFloat_VATPercent.DescId = zc_ObjectFloat_PriceList_VATPercent()
       WHERE ObjectBoolean_PriceWithVAT.ObjectId = inPriceListId
         AND ObjectBoolean_PriceWithVAT.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT();
   
   -- расчет цены без НДС, до 4 знаков
   outPriceNoVAT := CASE WHEN vbPriceWithVAT = TRUE
                         THEN CAST (inValue - inValue * (vbVATPercent / (vbVATPercent + 100)) AS NUMERIC (16, 2))
                         ELSE inValue
                    END ::TFloat;

   -- расчет цены с НДС, до 4 знаков
   outPriceWVAT := CASE WHEN vbPriceWithVAT <> TRUE
                        THEN CAST ((inValue + inValue * (vbVATPercent / 100)) AS NUMERIC (16, 2))
                        ELSE CAST (inValue AS NUMERIC (16, 4))
                   END ::TFloat;
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectHistoryProtocol (inObjectId:= vbPriceListItemId, inUserId:= vbUserId, inStartDate:= outStartDate, inEndDate:= outEndDate, inPrice:= inValue, inAddXML:= '', inIsUpdate:= TRUE, inIsErased:= FALSE);


END;$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.05.21         * add new отдельные права на обнуление цен
 28.11.19         * add inGoodsKindId
 24.07.19         *
 20.08.15         * lpInsert_ObjectHistoryProtocol
 09.12.14                                        *
*/
