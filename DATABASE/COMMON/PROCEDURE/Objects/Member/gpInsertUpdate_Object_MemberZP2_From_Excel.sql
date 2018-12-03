-- Function: gpInsertUpdate_Object_MemberZP2_From_Excel()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MemberZP2_From_Excel (Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MemberZP2_From_Excel(
    IN inBankId              Integer   ,    --
    IN inINN                 TVarChar  ,    -- Код ИНН
    IN inCard                TVarChar  ,    -- № карточного счета ЗП
    IN inSurName             TVarChar  ,    -- 
    IN inName                TVarChar  ,    -- 
    IN inFName               TVarChar  ,    -- 
    IN inSession             TVarChar       -- сессия пользователя
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMemberId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Member());
   
   -- пытаемся найти физ. лицо по ИНН
   vbMemberId := (SELECT MAX (ObjectString.ObjectId) AS MemberId
                  FROM ObjectString
                  WHERE ObjectString.DescId = zc_ObjectString_Member_INN()
                    AND TRIM (ObjectString.ValueData) = TRIM (inINN)
                  );

   -- получили ФИО
   inName := TRIM (inSurName) ||' '||TRIM (inName)||' '||TRIM (inFName) :: TVarChar;

   -- если не нашли создаем нового
   IF COALESCE (vbMemberId, 0) = 0 
   THEN 
       PERFORM gpInsertUpdate_Object_Member(ioId	       := 0        :: Integer     -- ключ объекта <Физические лица> 
                                          , inCode             := lfGet_ObjectCode(0, zc_Object_Member()) :: Integer     -- код объекта 
                                          , inName             := inName   :: TVarChar    -- Название объекта <
                                          , inIsOfficial       := TRUE     :: Boolean     -- Оформлен официально
                                          , inINN              := inINN    :: TVarChar    -- Код ИНН
                                          , inDriverCertificate:= ''       :: TVarChar    -- Водительское удостоверение 
                                          , inCard             := ''       :: TVarChar    -- № карточного счета ЗП
                                          , inCardSecond       := inCard   :: TVarChar   -- № карточного счета ЗП - вторая форма
                                          , inCardChild        := ''       :: TVarChar   -- № карточного счета ЗП - - алименты (удержание)
                                          , inComment          := 'создан при загрузке' :: TVarChar    -- Примечание 
                                          , inBankId           := 0        :: Integer
                                          , inBankSecondId     := inBankId :: Integer
                                          , inBankChildId      := 0        :: Integer
                                          , inInfoMoneyId      := 0        :: Integer
                                          , inSession          := inSession       -- сессия пользователя
                                          );
   ELSE
      -- сохранили свойство <>
      PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_CardSecond(), vbMemberId, inCard);
      -- сохранили свойство <>
      PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Member_BankSecond(), vbMemberId, inBankId);
      -- сохранили протокол
      PERFORM lpInsert_ObjectProtocol (vbMemberId, vbUserId);
   END IF;

   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.12.18         *
*/
