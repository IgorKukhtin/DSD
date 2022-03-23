-- Function: gpInsertUpdate_Object_ContractConditionPartner  (Integer,Integer,TVarChar,TVarChar,TVarChar,TVarChar,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ContractConditionPartner (Integer,Integer,Integer,Integer,TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ContractConditionPartner(
 INOUT ioId                      Integer   ,    -- ключ объекта < > 
    IN inCode                    Integer   ,    -- Код объекта <>
    IN inContractConditionId     Integer   ,    --   
    IN inPartnerId               Integer   ,    --   
    IN inSession                 TVarChar       -- сессия пользователя
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
   DECLARE vbContractConditionKindName TVarChar;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ContractConditionPartner());
   
   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его как последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_ContractConditionPartner()); 
   
   -- проверка уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_ContractConditionPartner(), vbCode_calc);

   -- проверка
   IF COALESCE (inPartnerId, 0) = 0
   THEN 
       RAISE EXCEPTION 'Ошибка.Контрагент не установлен.';
   END IF;   
   -- проверка
   IF COALESCE (inContractConditionId, 0) = 0
   THEN 
       RAISE EXCEPTION 'Ошибка.Условие договора не установлено.';
   END IF;   

   -- проверка уникальности
   IF EXISTS (SELECT 1
              FROM Object AS Object_ContractConditionPartner
                   INNER JOIN ObjectLink AS ObjectLink_ContractConditionPartner_ContractCondition
                                         ON ObjectLink_ContractConditionPartner_ContractCondition.ObjectId = Object_ContractConditionPartner.Id
                                        AND ObjectLink_ContractConditionPartner_ContractCondition.DescId = zc_ObjectLink_ContractConditionPartner_ContractCondition()
                                        AND ObjectLink_ContractConditionPartner_ContractCondition.ChildObjectId = inContractConditionId
            
                   INNER JOIN ObjectLink AS ObjectLink_ContractConditionPartner_Partner
                                         ON ObjectLink_ContractConditionPartner_Partner.ObjectId = Object_ContractConditionPartner.Id
                                        AND ObjectLink_ContractConditionPartner_Partner.DescId = zc_ObjectLink_ContractConditionPartner_Partner()
                                        AND ObjectLink_ContractConditionPartner_Partner.ChildObjectId = inPartnerId

     WHERE Object_ContractConditionPartner.DescId = zc_Object_ContractConditionPartner()
       AND Object_ContractConditionPartner.Id <> COALESCE (ioId, 0))
   THEN
       vbContractConditionKindName := (SELECT Object_ContractConditionKind.ValueData AS ContractConditionKindName
                                       FROM ObjectLink AS ObjectLink_ContractCondition_ContractConditionKind
                                            LEFT JOIN Object AS Object_ContractConditionKind ON Object_ContractConditionKind.Id = ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId
                                       WHERE ObjectLink_ContractCondition_ContractConditionKind.ObjectId = inContractConditionId
                                        AND ObjectLink_ContractCondition_ContractConditionKind.DescId = zc_ObjectLink_ContractCondition_ContractConditionKind()
                                      );
          
       RAISE EXCEPTION 'Ошибка.%Значение Условие договора <%> и контрагент <%> уже есть в справочнике.%Дублирование запрещено.', CHR(13), vbContractConditionKindName, lfGet_Object_ValueData (inPartnerId), CHR(13);
   END IF;   


   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ContractConditionPartner(), vbCode_calc, '');

   -- сохранили связь с < >
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ContractConditionPartner_ContractCondition(), ioId, inContractConditionId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ContractConditionPartner_Partner(), ioId, inPartnerId);
 

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.11.20         *

*/

-- тест
--