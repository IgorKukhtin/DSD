-- Function: gpInsertUpdate_Object_MakerReport (Integer,Integer,TVarChar, TFloat,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MakerReport (Integer,Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MakerReport(
 INOUT ioId              Integer   ,    -- ключ объекта <>
    IN inMakerId         Integer   ,    -- 
    IN inJuridicalId     Integer   ,    -- 
    IN inSession         TVarChar       -- сессия пользователя
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_MakerReport());
   vbUserId := inSession; 

   -- проверка уникальности
    IF EXISTS (SELECT 1 
               FROM Object AS Object_MakerReport
                    LEFT JOIN ObjectLink AS ObjectLink_Maker 
                                         ON ObjectLink_Maker.ObjectId = Object_MakerReport.Id 
                                        AND ObjectLink_Maker.DescId = zc_ObjectLink_MakerReport_Maker()
                    LEFT JOIN ObjectLink AS ObjectLink_Juridical 
                                         ON ObjectLink_Juridical.ObjectId = Object_MakerReport.Id 
                                        AND ObjectLink_Juridical.DescId = zc_ObjectLink_MakerReport_Juridical()
              WHERE Object_MakerReport.DescId = zc_Object_MakerReport()
                AND COALESCE (ObjectLink_Maker.ChildObjectId, 0) = inMakerId
                AND COALESCE (ObjectLink_Juridical.ChildObjectId, 0) = inJuridicalId
                AND Object_MakerReport.Id <> ioId
              )
   THEN
       RAISE EXCEPTION 'Ошибка.Связь <%> - <%> не уникально для справочника' , lfGet_Object_ValueData (inMakerId), lfGet_Object_ValueData (inJuridicalId);
   END IF;  
 
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_MakerReport(), 0, '');

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_MakerReport_Maker(), ioId, inMakerId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_MakerReport_Juridical(), ioId, inJuridicalId);


   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$ LANGUAGE plpgsql;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.01.19         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_MakerReport()