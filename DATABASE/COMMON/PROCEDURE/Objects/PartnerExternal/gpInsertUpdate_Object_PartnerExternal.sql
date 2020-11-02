-- Function: gpInsertUpdate_Object_PartnerExternal  ()

--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PartnerExternal (Integer,Integer,TVarChar,TVarChar,Integer,TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PartnerExternal (Integer,Integer,TVarChar,TVarChar,Integer,Integer,Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PartnerExternal(
 INOUT ioId                       Integer   ,    -- ключ объекта < > 
    IN inCode                     Integer   ,    -- Код объекта <>
    IN inName                     TVarChar  ,    -- Название объекта <>
    IN inObjectCode               TVarChar  ,    -- 
    IN inPartnerId                Integer   ,    --
    IN inContractId               Integer   ,    --
    IN inRetailId                 Integer   ,    --
    IN inSession                  TVarChar       -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_PartnerExternal());

   -- сохранили св-во <>
   ioId:= lpInsertUpdate_Object_PartnerExternal (ioId       := ioId
                                               , inCode       := inCode
                                               , inName       := inName
                                               , inObjectCode := inObjectCode
                                               , inPartnerId  := inPartnerId
                                               , inContractId := inContractId
                                               , inRetailId   := inRetailId
                                               , inUserId     := vbUserId
                                                );
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.10.20         *
*/

-- тест
--