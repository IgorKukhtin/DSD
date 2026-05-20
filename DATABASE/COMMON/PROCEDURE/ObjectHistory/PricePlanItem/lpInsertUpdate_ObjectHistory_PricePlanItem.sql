-- Function: lpInsertUpdate_ObjectHistory_PricePlanItem()

DROP FUNCTION IF EXISTS lpInsertUpdate_ObjectHistory_PricePlanItem (Integer,Integer,Integer,Integer,TDateTime,TFloat,Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_ObjectHistory_PricePlanItem(
 INOUT ioId                     Integer,    -- ключ объекта <Элемент прайс-листа>
    IN inPriceListId            Integer,    -- Прайс-лист
    IN inGoodsId                Integer,    -- Товар
    IN inGoodsKindId            Integer,    -- Вид Товара
    IN inOperDate               TDateTime,  -- Дата действия прайс-листа
    IN inValue                  TFloat,     -- Значение цены
    IN inUserId                 Integer    -- сессия пользователя
)
  RETURNS integer AS
$BODY$
DECLARE
   DECLARE vbPricePlanItemId Integer;
BEGIN

   -- если назначена роль <Прайс-лист - изменение в любом прайсе>
   IF EXISTS (SELECT 1 FROM Object_Role_Process_View WHERE ProcessId = zc_Enum_Process_Update_PricePlanItem() AND UserId = inUserId)
      OR inUserId = zc_Enum_Process_Auto_PrimeCost()
   THEN
       -- разрешено ВСЕ
       vbPricePlanItemId:= 0;
       
   ELSEIF EXISTS (SELECT 1 FROM Object_MemberPriceList_View AS MemberPriceList_View WHERE MemberPriceList_View.UserId = inUserId)
       OR 1=1
   THEN
       -- поиск в настройках "Доступ к прайсу"
       IF NOT EXISTS (SELECT 1 FROM Object_MemberPriceList_View AS MemberPriceList_View WHERE MemberPriceList_View.UserId = inUserId)
          AND inUserId <> 5
          AND inUserId <> 9457
       THEN
           RAISE EXCEPTION 'Ошибка. Нет прав корректировать прайс <%>', lfGet_Object_ValueData (inPriceListId);

       -- проверка в настройках "Доступ к прайсу" - что это именно тот Прайс
       ELSEIF NOT EXISTS (SELECT 1 FROM Object_MemberPriceList_View AS MemberPriceList_View WHERE MemberPriceList_View.UserId = inUserId AND MemberPriceList_View.PriceListId = inPriceListId)
          AND inUserId <> 5
          AND inUserId <> 9457
       THEN
           RAISE EXCEPTION 'Ошибка. У пользователя <%>.%Нет прав корректировать прайс <%>.%Можно корректировать только такие Прайсы:% %'
                         , lfGet_Object_ValueData (inUserId)
                         , CHR (13)
                         , lfGet_Object_ValueData (inPriceListId)
                         , CHR (13)
                         , CHR (13)
                         , (SELECT STRING_AGG ('< ' || MemberPriceList_View.PriceListName || ' >', '; ') FROM Object_MemberPriceList_View AS MemberPriceList_View WHERE MemberPriceList_View.UserId = inUserId)
                          ;
       END IF;
   END IF;

   -- Проверка
   IF COALESCE (inValue, 0) = 0
  AND EXISTS (SELECT 1
              FROM ObjectLink AS OL_Goods_InfoMoney
                  INNER JOIN Object_InfoMoney_View AS View_InfoMoney
                                                   ON View_InfoMoney.InfoMoneyId = OL_Goods_InfoMoney.ChildObjectId
                                                  AND View_InfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                                                                              , zc_Enum_InfoMoneyDestination_20900() -- Ирна
                                                                                               )
              WHERE OL_Goods_InfoMoney.ObjectId = inGoodsId
                AND OL_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
             )
   THEN
           RAISE EXCEPTION 'Ошибка.Нет прав вводить цену = %.%Прайс = <%>%Товар = <%>%Вид = <%>%Дата = <%>'
                         , zfConvert_FloatToString (COALESCE (inValue, 0)) || CASE WHEN inValue IS NULL THEN '*' ELSE '' END
                         , CHR (13) 
                         , lfGet_Object_ValueData (inPriceListId)
                         , CHR (13) 
                         , lfGet_Object_ValueData (inGoodsId)
                         , CHR (13) 
                         , lfGet_Object_ValueData (inGoodsKindId)
                         , CHR (13) 
                         , zfConvert_DateToString (inOperDate)
                          ;
   END IF;



   -- Получаем ссылку на объект цен
   vbPricePlanItemId := lpGetInsert_Object_PricePlanItem (inPriceListId, inGoodsId, inGoodsKindId, inUserId);
 
   -- Вставляем или меняем объект историю цен
   ioId := lpInsertUpdate_ObjectHistory (ioId, zc_ObjectHistory_PricePlanItem(), vbPricePlanItemId, inOperDate, inUserId);
   -- Устанавливаем цену
   PERFORM lpInsertUpdate_ObjectHistoryFloat (zc_ObjectHistoryFloat_PricePlanItem_Value(), ioId, inValue);

   -- сохранили протокол
   PERFORM lpInsert_ObjectHistoryProtocol (inObjectId:= ObjectHistory.ObjectId, inUserId:= inUserId, inStartDate:= StartDate, inEndDate:= EndDate, inPrice:= inValue, inAddXML:= '', inIsUpdate:= TRUE, inIsErased:= FALSE)
   FROM ObjectHistory WHERE Id = ioId;


END;$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  
 18.05.26         *
*/
