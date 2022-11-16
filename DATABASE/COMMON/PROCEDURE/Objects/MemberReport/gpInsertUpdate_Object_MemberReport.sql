-- Function: gpInsertUpdate_Object_MemberReport()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MemberReport (Integer, Integer, Integer, Integer, TVarchar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MemberReport(
 INOUT ioId             Integer   ,    -- ключ объекта <>
    IN inMemberId       Integer   ,    -- ссылка 
    IN inFromId         Integer   ,    -- ссылка
    IN inToId           Integer   ,    -- ссылка
    IN inComment        TVarChar  ,
    IN inSession        TVarChar       -- сессия пользователя
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbId Integer;  

BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpGetUserBySession (inSession); 

   -- проверка
   vbId := (SELECT Object_MemberReport.Id
            FROM Object AS Object_MemberReport
                 INNER JOIN ObjectLink AS ObjectLink_From
                                       ON ObjectLink_From.ObjectId = Object_MemberReport.Id
                                      AND ObjectLink_From.DescId = zc_ObjectLink_MemberReport_From()
                                      AND ObjectLink_From.ChildObjectId = inFromId
                 INNER JOIN ObjectLink AS ObjectLink_To
                                       ON ObjectLink_To.ObjectId = Object_MemberReport.Id
                                      AND ObjectLink_To.DescId = zc_ObjectLink_MemberReport_To()
                                      AND ObjectLink_To.ChildObjectId = inToId
 
                 INNER JOIN ObjectLink AS ObjectLink_Member
                                       ON ObjectLink_Member.ObjectId = Object_MemberReport.Id
                                      AND ObjectLink_Member.DescId = zc_ObjectLink_MemberReport_Member()
                                      AND ObjectLink_Member.ChildObjectId = inMemberId
            WHERE Object_MemberReport.DescId = zc_Object_MemberReport()
               AND Object_MemberReport.Id <> ioId
            );

   IF COALESCE (vbId,0) <> 0
   THEN 
       RAISE EXCEPTION 'Ошибка. Связка <%> - <%> - <%> уже существует.', lfGet_Object_ValueData_sh (inFromId), lfGet_Object_ValueData_sh (inToId), lfGet_Object_ValueData_sh (inMemberId);
   END IF;
   
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_MemberReport(), 0, '');
   
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_MemberReport_From(), ioId, inFromId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_MemberReport_To(), ioId, inToId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_MemberReport_Member(), ioId, inMemberId);
   
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_MemberReport_Comment(), ioId, inComment);
    

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
END;$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.11.22         * 
*/

-- тест
--