-- Function: gpInsertUpdate_Object_BranchJuridical  (Integer,Integer,TVarChar,TVarChar,TVarChar,TVarChar,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_BranchJuridical (Integer,Integer,Integer,TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_BranchJuridical (Integer,Integer,Integer,Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_BranchJuridical(
 INOUT ioId                Integer   ,    -- ключ объекта < > 
    IN inBranchId          Integer   ,    --   
    IN inJuridicalId       Integer   ,    --  
    IN inUnitId            Integer   ,    -- 
    IN inSession           TVarChar       -- сессия пользователя
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_BranchJuridical());
   
   
   -- проверка уникальности
   IF EXISTS (SELECT ObjectLink_Branch.ObjectId        
              FROM ObjectLink AS ObjectLink_Branch
                   LEFT JOIN ObjectLink AS ObjectLink_Juridical
                                        ON ObjectLink_Juridical.ObjectId = ObjectLink_Branch.ObjectId 
                                       AND ObjectLink_Juridical.DescId = zc_ObjectLink_BranchJuridical_Juridical()

                   LEFT JOIN ObjectLink AS ObjectLink_Unit
                                        ON ObjectLink_Unit.ObjectId = ObjectLink_Branch.ObjectId 
                                       AND ObjectLink_Unit.DescId = zc_ObjectLink_BranchJuridical_Unit()
              WHERE ObjectLink_Branch.DescId = zc_ObjectLink_BranchJuridical_Branch()
                AND ObjectLink_Branch.ChildObjectId = inBranchId
                AND ObjectLink_Juridical.ChildObjectId = inJuridicalId
                AND ObjectLink_Unit.ChildObjectId = inUnitId
                AND ObjectLink_Branch.ObjectId <> COALESCE (ioId, 0)
              )
   THEN 
       RAISE EXCEPTION 'Ошибка.%Значение Филиал № <%> и Юр.лицо <%> уже есть в справочнике.%Дублирование запрещено.', CHR(13), lfGet_Object_ValueData (inBranchId), lfGet_Object_ValueData (inJuridicalId), CHR(13);
   END IF;   

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_BranchJuridical(), 0, '');
                       
   -- сохранили связь с < >
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_BranchJuridical_Branch(), ioId, inBranchId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_BranchJuridical_Juridical(), ioId, inJuridicalId);
   -- сохранили связь с < >
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_BranchJuridical_Unit(), ioId, inUnitId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 08.11.24         *
 31.01.16         *

*/

-- тест
-- select * from gpInsertUpdate_Object_BranchJuridical(ioId := 0 , inCode := 1 , inName := 'Белов' , inPhone := '4444' , Mail := 'выа@kjjkj' , Comment := '' , inJuridicalId := 258441 , inJuridicalId := 0 , inBranchId := 0 , inBranchJuridicalKindId := 153272 ,  inSession := '5');
