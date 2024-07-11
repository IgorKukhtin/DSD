-- Function: gpInsert_Object_ContractPriceList_NewLoad (Integer, Integer, TFloat, TVarChar)

DROP FUNCTION IF EXISTS gpInsert_Object_ContractPriceList_NewLoad (Integer, TVarChar, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Object_ContractPriceList_NewLoad(
    IN inContractCode       Integer   , -- 
    IN inPriceListName_new  TVarChar   , --
    IN inStartDate_new      TDateTime   ,  
    IN inSession            TVarChar     -- сессия пользователя
)
RETURNS VOID AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbContractId Integer;
    DECLARE vbPriceListId Integer;
    DECLARE vbContractPLId Integer;
    DECLARE vbStartDate TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_ContractPriceList());

    -- Проверка
    IF COALESCE(inContractCode, 0) = 0 OR COALESCE (inPriceListName_new,'') =''
    THEN
        RETURN;
    END IF;
    
    vbContractId := (SELECT Object.Id
                     FROM Object
                     WHERE Object.ObjectCode = inContractCode
                       AND Object.DescId = zc_Object_Contract()
                     LIMIT 1
                     );
    IF COALESCE (vbContractId, 0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка.Договор с кодом <%> не найден.', inContractCode;
    END IF;

    vbStartDate := (SELECT MAX (ObjectDate_StartDate.ValueData) :: TDateTime AS StartDate
                    FROM Object AS Object_ContractPriceList
                          INNER JOIN ObjectLink AS ObjectLink_ContractPriceList_Contract
                                                ON ObjectLink_ContractPriceList_Contract.ObjectId = Object_ContractPriceList.Id
                                               AND ObjectLink_ContractPriceList_Contract.DescId = zc_ObjectLink_ContractPriceList_Contract()
                                               AND ObjectLink_ContractPriceList_Contract.ChildObjectId = vbContractId
                          LEFT JOIN ObjectDate AS ObjectDate_StartDate
                                               ON ObjectDate_StartDate.ObjectId = Object_ContractPriceList.Id
                                              AND ObjectDate_StartDate.DescId = zc_ObjectDate_ContractPriceList_StartDate()
                     WHERE Object_ContractPriceList.DescId = zc_Object_ContractPriceList()
                       AND Object_ContractPriceList.isErased = FALSE
                    );
    IF vbStartDate > inStartDate_new
    THEN 
         RAISE EXCEPTION 'Ошибка.У договора с кодом <%> есть прайс с датой = <%> в загрузке установлена меньше дата = <%>.', inContractCode, zfConvert_DateToString (vbStartDate), zfConvert_DateToString (inStartDate_new);
    END IF;
    
    IF COALESCE (TRIM (inPriceListName_new), '') <> ''
    THEN 
         -- поиск прайса
         vbPriceListId := (SELECT Object.Id FROM Object WHERE TRIM (UPPER (Object.ValueData)) = TRIM (UPPER (inPriceListName_new)) AND Object.DescId = zc_Object_PriceList() LIMIT 1);
         IF COALESCE (vbPriceListId, 0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Прайс-лист <%> не найден.', inPriceListName_new;
         END IF; 
         
         --пробуем найти такую запись
         vbContractPLId:=(SELECT ObjectLink_ContractPriceList_Contract.ObjectId
                          FROM ObjectLink AS ObjectLink_ContractPriceList_Contract
                              INNER JOIN ObjectLink AS ObjectLink_ContractPriceList_PriceList
                                                    ON ObjectLink_ContractPriceList_PriceList.ObjectId = ObjectLink_ContractPriceList_Contract.ObjectId
                                                   AND ObjectLink_ContractPriceList_PriceList.DescId = zc_ObjectLink_ContractPriceList_PriceList()
                                                   AND ObjectLink_ContractPriceList_PriceList.ChildObjectId = vbPriceListId
                              INNER JOIN ObjectDate AS ObjectDate_StartDate
                                                    ON ObjectDate_StartDate.ObjectId = ObjectLink_ContractPriceList_Contract.ObjectId
                                                   AND ObjectDate_StartDate.DescId = zc_ObjectDate_ContractPriceList_StartDate()
                                                   AND ObjectDate_StartDate.ValueData = inStartDate_new
       
                              INNER JOIN Object AS Object_ContractPriceList
                                                ON Object_ContractPriceList.Id = ObjectLink_ContractPriceList_Contract.ObjectId
                                               AND Object_ContractPriceList.isErased = FALSE
       
                          WHERE ObjectLink_ContractPriceList_Contract.ChildObjectId = vbContractId
                            AND ObjectLink_ContractPriceList_Contract.DescId = zc_ObjectLink_ContractPriceList_Contract()
                          );
         
         -- сохранили новый элемент
         PERFORM gpInsertUpdate_Object_ContractPriceList (ioId          := COALESCE (vbContractPLId,0) ::Integer        
                                                        , inComment     := ''              ::TVarChar
                                                        , inContractId  := vbContractId    ::Integer
                                                        , inPriceListId := vbPriceListId   ::Integer 
                                                        , inStartDate   := inStartDate_new ::TDateTime
                                                        , inSession     := inSession       ::TVarChar
                                                        );
    END IF;

    /*IF vbUserId = 5 OR vbUserId = 9457
    THEN
        RAISE EXCEPTION 'Тест Oк.';
    END IF;*/
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.07.24         *
*/

-- тест
--