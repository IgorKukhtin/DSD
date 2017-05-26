-- Function: gpUpdate_Object_PersonalServiceList_Member()

DROP FUNCTION IF EXISTS gpUpdate_Object_PersonalServiceList_Member (Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_PersonalServiceList_Member (Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_PersonalServiceList_Member(
    IN inId                    Integer   ,     -- ключ объекта <> 
    IN inMemberId              Integer   ,     -- Физ лица(пользователь) 
    IN inMemberHeadManagerId   Integer   ,     -- Физ лица(исполнительный директор)
    IN inMemberManagerId       Integer   ,     -- Физ лица(директор)
    IN inMemberBookkeeperId    Integer   ,     -- Физ лица(бухгалтер)
    IN inSession               TVarChar        -- сессия пользователя
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_PersonalServiceList_Member());


   -- сохранили св-во 
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PersonalServiceList_Member(), inId, inMemberId);
   -- сохранили св-во 
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PersonalServiceList_MemberHeadManager(), inId, inMemberHeadManagerId);
   -- сохранили св-во 
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PersonalServiceList_MemberManager(), inId, inMemberManagerId);
   -- сохранили св-во 
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PersonalServiceList_MemberBookkeeper(), inId, inMemberBookkeeperId);
        
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpUpdate_Object_PersonalServiceList_Member (Integer, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.12.15         * add MemberHeadManager, MemberManager, MemberBookkeeper
 26.08.15         *
*/

-- тест
-- SELECT * FROM gpUpdate_Object_PersonalServiceList_Member(ioId:=null, inCode:=null, inName:='Торговая сеть 1', inSession:='2')