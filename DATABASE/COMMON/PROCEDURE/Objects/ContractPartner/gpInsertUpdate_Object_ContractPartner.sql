-- Function: gpInsertUpdate_Object_ContractPartner  (Integer,Integer,TVarChar,TVarChar,TVarChar,TVarChar,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ContractPartner (Integer,Integer,Integer,Integer,TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ContractPartner(
 INOUT ioId                Integer   ,    -- ключ объекта < Улица/проспект> 
    IN inCode              Integer   ,    -- Код объекта <>
    IN inContractId        Integer   ,    --   
    IN inPartnerId         Integer   ,    --   
    IN inSession           TVarChar       -- сессия пользователя
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ContractPartner());
   
   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его как последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_ContractPartner()); 
   
   -- проверка прав уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_ContractPartner(), vbCode_calc);

   -- проверка
   IF COALESCE (inPartnerId, 0) = 0
   THEN 
       RAISE EXCEPTION 'Ошибка.Контрагент не установлен.';
   END IF;   

   -- проверка уникальности
   IF EXISTS (SELECT Object_ContractPartner_View.ContractId
              FROM Object_ContractPartner_View
              WHERE Object_ContractPartner_View.ContractId = inContractId
                AND Object_ContractPartner_View.PartnerId = inPartnerId
                AND Object_ContractPartner_View.Id <> COALESCE (ioId, 0))
   THEN 
       RAISE EXCEPTION 'Ошибка.%Значение договор № <%> и контрагент <%> уже есть в справочнике.%Дублирование запрещено.', CHR(13), lfGet_Object_ValueData (inContractId), lfGet_Object_ValueData (inPartnerId), CHR(13);
   END IF;   


   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ContractPartner(), vbCode_calc, '');
                                --, inAccessKeyId:= COALESCE ((SELECT Object_Branch.AccessKeyId FROM ObjectLink LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink.ChildObjectId WHERE ObjectLink.ObjectId = inUnitId AND ObjectLink.DescId = zc_ObjectLink_Unit_Branch()), zc_Enum_Process_AccessKey_TrasportDnepr()));
   -- сохранили связь с < >
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ContractPartner_Contract(), ioId, inContractId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ContractPartner_Partner(), ioId, inPartnerId);
 

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 16.01.15         *

*/

-- тест
-- select * from gpInsertUpdate_Object_ContractPartner(ioId := 0 , inCode := 1 , inName := 'Белов' , inPhone := '4444' , Mail := 'выа@kjjkj' , Comment := '' , inPartnerId := 258441 , inJuridicalId := 0 , inContractId := 0 , inContractPartnerKindId := 153272 ,  inSession := '5');
