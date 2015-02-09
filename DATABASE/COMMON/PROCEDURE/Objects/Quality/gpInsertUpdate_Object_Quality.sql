-- Function: gpInsertUpdate_Object_Quality  (Integer,Integer,TVarChar,TVarChar,TVarChar,TVarChar,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Quality (Integer,TVarChar,Integer,TVarChar,Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Quality(
 INOUT ioId                Integer   ,    -- ключ объекта < Улица/проспект> 
    IN inName              TVarChar  ,
    IN inCode              Integer   ,    -- Код объекта <>
    IN inComment           TVarChar    ,
    IN inJuridicalId       Integer   ,    -- 
    IN inSession           TVarChar       -- сессия пользователя
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Quality());
   
   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его как последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_Quality()); 
   
   -- проверка прав уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Quality(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Quality(), vbCode_calc, inName);
                                --, inAccessKeyId:= COALESCE ((SELECT Object_Branch.AccessKeyId FROM ObjectLink LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink.ChildObjectId WHERE ObjectLink.ObjectId = inUnitId AND ObjectLink.DescId = zc_ObjectLink_Unit_Branch()), zc_Enum_Process_AccessKey_TrasportDnepr()));
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Quality_Juridical(), ioId, inJuridicalId);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Quality_Comment(), ioId, inComment);
 

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 09.02.15         *

*/

-- тест
-- select * from gpInsertUpdate_Object_Quality(ioId := 0 , inCode := 1 , inName := 'Белов' , inPhone := '4444' , Mail := 'выа@kjjkj' , Comment := '' , inJuridicalId := 258441 , inJuridicalId := 0 , inContractId := 0 , inQualityKindId := 153272 ,  inSession := '5');
