-- Function: gpInsertUpdate_Object_ContactPerson  (Integer,Integer,TVarChar,TVarChar,TVarChar,TVarChar,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ContactPerson (Integer,Integer,TVarChar,TVarChar,TVarChar,TVarChar,Integer,Integer,Integer,Integer,Integer,Integer,Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ContactPerson(
 INOUT ioId                       Integer   ,    -- ключ объекта < Улица/проспект> 
    IN inCode                     Integer   ,    -- Код объекта <>
    IN inName                     TVarChar  ,    -- Название объекта <>
    IN inPhone                    TVarChar  ,    -- 
    IN inMail                     TVarChar  ,    --
    IN inComment                  TVarChar  ,    --
    IN inObjectId_Partner         Integer   ,    --   
    IN inObjectId_Juridical       Integer   ,    --   
    IN inObjectId_Contract        Integer   ,    --   
    IN inObjectId_Unit            Integer   ,    -- 
    IN inContactPersonKindId      Integer   ,    --
    IN inEmailId                  Integer   ,    --
    IN inRetailId                 Integer   ,    --
    IN inSession                  TVarChar       -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ContactPerson());

   -- сохранили св-во <>
   ioId:= lpInsertUpdate_Object_ContactPerson (ioId                 := ioId
                                             , inCode               := inCode
                                             , inName               := inName
                                             , inPhone              := inPhone
                                             , inMail               := inMail
                                             , inComment            := inComment
                                             , inObjectId_Partner   := inObjectId_Partner
                                             , inObjectId_Juridical := inObjectId_Juridical
                                             , inObjectId_Contract  := inObjectId_Contract
                                             , inObjectId_Unit      := inObjectId_Unit
                                             , inContactPersonKindId:= inContactPersonKindId
                                             , inEmailId            := inEmailId
                                             , inRetailId           := inRetailId
                                             , inUserId             := vbUserId
                                              );
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 07.07.16         *
 27.06.16         * Email
 18.04.16         *
 21.10.14         *
 19.06.14                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_ContactPerson(ioId := 0 , inCode := 1 , inName := 'Белов' , inPhone := '4444' , Mail := 'выа@kjjkj' , Comment := '' , inPartnerId := 258441 , inJuridicalId := 0 , inContractId := 0 , inContactPersonKindId := 153272 ,  inSession := '5');
