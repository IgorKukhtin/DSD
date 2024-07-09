-- Function: gpInsertUpdate_Object_ContractPriceList

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ContractPriceList (Integer, TVarChar, Integer, Integer, TDateTime, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ContractPriceList(
 INOUT ioId                        Integer   , -- ключ объекта <Условия договора>
    IN inComment                   TVarChar  , -- примечание
    IN inContractId                Integer   , -- Договор
    IN inPriceListId               Integer   , -- прайс
    IN inStartDate                 TDateTime , -- Дейстует с...
    IN inSession                   TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsUpdate Boolean;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ContractPriceList());
   
    -- проверка
   IF COALESCE (inContractId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Договор не установлен.';
   END IF;

   -- проверка на уникальность, нельзя добавить с существующим StartDate
   IF COALESCE (inStartDate, zc_DateStart()) > zc_DateStart()
   THEN
        IF EXISTS (SELECT 1
                   FROM ObjectLink AS ObjectLink_ContractPriceList_Contract
                       INNER JOIN ObjectLink AS ObjectLink_ContractPriceList_PriceList
                                             ON ObjectLink_ContractPriceList_PriceList.ObjectId = ObjectLink_ContractPriceList_Contract.ObjectId
                                            AND ObjectLink_ContractPriceList_PriceList.DescId = zc_ObjectLink_ContractPriceList_PriceList()
                                            AND ObjectLink_ContractPriceList_PriceList.ChildObjectId = inPriceListId
                       INNER JOIN ObjectDate AS ObjectDate_StartDate
                                             ON ObjectDate_StartDate.ObjectId = ObjectLink_ContractPriceList_Contract.ObjectId
                                            AND ObjectDate_StartDate.DescId = zc_ObjectDate_ContractPriceList_StartDate()
                                            AND ObjectDate_StartDate.ValueData = inStartDate

                       INNER JOIN Object AS Object_ContractPriceList
                                         ON Object_ContractPriceList.Id = ObjectLink_ContractPriceList_Contract.ObjectId
                                        AND Object_ContractPriceList.isErased = FALSE

                   WHERE ObjectLink_ContractPriceList_Contract.ChildObjectId = inContractId
                     AND ObjectLink_ContractPriceList_Contract.ObjectId <> ioId
                     AND ObjectLink_ContractPriceList_Contract.DescId = zc_ObjectLink_ContractPriceList_Contract())
        THEN
            RAISE EXCEPTION 'Ошибка.Дата начала действия прайса не уникальна. Дата <%>, Прайс <%>, Договор <%>', inStartDate, lfGet_Object_ValueData (inPriceListId), lfGet_Object_ValueData (inContractId);
        END IF;
   END IF;
   
   -- определили <Признак>
   vbIsUpdate:= COALESCE (ioId, 0) > 0;

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ContractPriceList(), 0, inComment);
   

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ContractPriceList_Contract(), ioId, inContractId);   
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ContractPriceList_PriceList(), ioId, inPriceListId);

   IF COALESCE (inStartDate, zc_DateStart()) >= zc_DateStart()
   THEN
       --
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_ContractPriceList_StartDate(), ioId, inStartDate);
       
       -- EndDate - апдейтим ВСЕМ
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_ContractPriceList_EndDate(), tmp.Id, tmp.EndDate)
       FROM (WITH tmpData AS (SELECT ObjectLink_Contract.ObjectId                          AS Id
                                   , COALESCE (ObjectDate_StartDate.ValueData,zc_DateStart()) AS StartDate
                                   , ROW_NUMBER() OVER (ORDER BY COALESCE (ObjectDate_StartDate.ValueData,zc_DateStart()) ASC) AS Ord
                              FROM ObjectLink AS ObjectLink_Contract
                                   LEFT JOIN ObjectLink AS ObjectLink_PriceList
                                                        ON ObjectLink_PriceList.ObjectId      = ObjectLink_Contract.ObjectId
                                                       AND ObjectLink_PriceList.DescId        = zc_ObjectLink_ContractPriceList_PriceList()
                                                      -- AND ObjectLink_PriceList.ChildObjectId = inPriceListId
                                   INNER JOIN Object AS Object_ContractPriceList ON Object_ContractPriceList.Id       = ObjectLink_Contract.ObjectId
                                                                                AND Object_ContractPriceList.isErased = FALSE
                                   INNER JOIN ObjectDate AS ObjectDate_StartDate
                                                         ON ObjectDate_StartDate.ObjectId  = ObjectLink_Contract.ObjectId
                                                        AND ObjectDate_StartDate.DescId    = zc_ObjectDate_ContractPriceList_StartDate()
                                                        --AND ObjectDate_StartDate.ValueData > zc_DateStart()
                              WHERE ObjectLink_Contract.ChildObjectId = inContractId
                                AND ObjectLink_Contract.DescId        = zc_ObjectLink_ContractPriceList_Contract()
                             )
             SELECT tmpData.Id, COALESCE (tmpData_next.StartDate - INTERVAL '1 DAY', zc_DateEnd()) AS EndDate
             FROM tmpData
                  LEFT JOIN tmpData AS tmpData_next ON tmpData_next.Ord = tmpData.Ord + 1
             ) AS tmp
      ;

   END IF;
   
   --если Выбран элемент УДАЛЕН нужно изменить дату окончания предыдущего условия договора,   у последнего №п/п всегда получится zc_DateEnd()
   -- текущие обнулим
   IF COALESCE (inPriceListId, 0) = 0
   THEN
       --
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_ContractPriceList_StartDate(), ioId, NULL);
       --
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_ContractPriceList_EndDate(), ioId, NULL);   

       -- EndDate - апдейтим ВСЕМ
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_ContractPriceList_EndDate(), tmp.Id, tmp.EndDate)
       FROM (WITH tmpData AS (SELECT ObjectLink_Contract.ObjectId                          AS Id
                                   , COALESCE (ObjectDate_StartDate.ValueData,zc_DateStart())                        AS StartDate
                                   , ROW_NUMBER() OVER (ORDER BY COALESCE (ObjectDate_StartDate.ValueData,zc_DateStart()) ASC) AS Ord
                              FROM ObjectLink AS ObjectLink_Contract
                                   LEFT JOIN ObjectLink AS ObjectLink_PriceList
                                                        ON ObjectLink_PriceList.ObjectId      = ObjectLink_Contract.ObjectId
                                                       AND ObjectLink_PriceList.DescId        = zc_ObjectLink_ContractPriceList_PriceList()
                                                       AND ObjectLink_PriceList.ChildObjectId = inPriceListId
                                   INNER JOIN Object AS Object_ContractPriceList ON Object_ContractPriceList.Id       = ObjectLink_Contract.ObjectId
                                                                                AND Object_ContractPriceList.isErased = FALSE
                                   INNER JOIN ObjectDate AS ObjectDate_StartDate
                                                         ON ObjectDate_StartDate.ObjectId  = ObjectLink_Contract.ObjectId
                                                        AND ObjectDate_StartDate.DescId    = zc_ObjectDate_ContractPriceList_StartDate()
                                                        AND ObjectDate_StartDate.ValueData > zc_DateStart()
                              WHERE ObjectLink_Contract.ChildObjectId = inContractId
                                AND ObjectLink_Contract.DescId        = zc_ObjectLink_ContractPriceList_Contract()
                             )
             SELECT tmpData.Id, COALESCE (tmpData_next.StartDate - INTERVAL '1 DAY', zc_DateEnd()) AS EndDate
             FROM tmpData
                  LEFT JOIN tmpData AS tmpData_next ON tmpData_next.Ord = tmpData.Ord + 1
             ) AS tmp
      ;
   END IF;
   
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inObjectId:= ioId, inUserId:= vbUserId, inIsUpdate:= vbIsUpdate, inIsErased:= NULL);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*---------------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.05.21         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_ContractPriceList (ioId:=0, inValue:=100, inContractId:=5, inPriceListId:=6, inSession:='2')
