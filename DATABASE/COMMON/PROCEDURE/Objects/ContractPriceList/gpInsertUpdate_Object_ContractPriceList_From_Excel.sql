-- Function: gpInsertUpdate_Object_Contract_From_Excel (Integer, Integer, TFloat, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ContractPriceList_From_Excel (Integer, TVarChar, TDateTime, TVarChar, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ContractPriceList_From_Excel(
    IN inContractCode       Integer   , -- 
    IN inPriceListName_old  TVarChar   , -- 
    IN inStartDate_old      TDateTime   , -- 
    IN inPriceListName_new  TVarChar   , --
    IN inStartDate_new      TDateTime   ,  
    IN inSession            TVarChar     -- сессия пользователя
)
RETURNS VOID AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbContractId Integer;
    DECLARE vbPriceListId Integer;
    DECLARE vbStartDate TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_ContractPriceList());

    -- Проверка
    IF COALESCE(inContractCode, 0) = 0 OR (COALESCE (inPriceListName_old,'') = '' AND COALESCE (inPriceListName_new,'') ='')
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
    IF vbStartDate > inStartDate_old OR vbStartDate > inStartDate_new
    THEN 
         RAISE EXCEPTION 'Ошибка.У договора с кодом <%> есть прайс позже даты загрузки.', inContractCode;
    END IF;
    
    IF COALESCE (TRIM (inPriceListName_old), '') <> ''
    THEN 
         -- поиск прайса
         vbPriceListId := (SELECT Object.Id FROM Object WHERE TRIM (UPPER (Object.ValueData)) = TRIM (UPPER (inPriceListName_old)) AND Object.DescId = zc_Object_PriceList() LIMIT 1);
         IF COALESCE (vbPriceListId, 0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Прайс-лист <%> не найден.', inPriceListName_old;
         END IF; 
         
         -- сохранили новый элемент
         PERFORM gpInsertUpdate_Object_ContractPriceList (ioId          := 0        
                                                        , inComment     := ''              ::TVarChar
                                                        , inContractId  := vbContractId    ::Integer
                                                        , inPriceListId := vbPriceListId   ::Integer 
                                                        , inStartDate   := inStartDate_old ::TDateTime
                                                        , inSession     := inSession       ::TVarChar
                                                        );
    END IF;

    IF COALESCE (TRIM (inPriceListName_new), '') <> ''
    THEN 
         -- поиск прайса
         vbPriceListId := (SELECT Object.Id FROM Object WHERE TRIM (UPPER (Object.ValueData)) = TRIM (UPPER (inPriceListName_new)) AND Object.DescId = zc_Object_PriceList() LIMIT 1);
         IF COALESCE (vbPriceListId, 0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Прайс-лист <%> не найден.', inPriceListName_new;
         END IF; 
         
         -- сохранили новый элемент
         PERFORM gpInsertUpdate_Object_ContractPriceList (ioId          := 0        
                                                        , inComment     := ''              ::TVarChar
                                                        , inContractId  := vbContractId    ::Integer
                                                        , inPriceListId := vbPriceListId   ::Integer 
                                                        , inStartDate   := inStartDate_new ::TDateTime
                                                        , inSession     := inSession       ::TVarChar
                                                        );
    END IF;

    IF vbUserId = 5 OR vbUserId = 9457
    THEN
        RAISE EXCEPTION 'Тест Oк.';
    END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.10.23         *
*/

-- тест
-- select * from gpInsertUpdate_Object_ContractPriceList_From_Excel (5555, 'dfsfdsf':: TVarChar, '10.10.2023'::TdateTime, 'dfcffgvbnnsf':: TVarChar, '10.10.2023'::TdateTime, '9457'::TVarChar)