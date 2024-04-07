-- DROP FUNCTION lpInsert_ObjectProtocol (IN inObjectId Integer, IN inUserId Integer);

-- DROP FUNCTION IF EXISTS lpInsert_ObjectHistoryProtocol (Integer, Integer, Boolean, Boolean);
DROP FUNCTION IF EXISTS lpInsert_ObjectHistoryProtocol (Integer, Integer, TDateTime, TDateTime, TFloat, Boolean, Boolean);
DROP FUNCTION IF EXISTS lpInsert_ObjectHistoryProtocol (Integer, Integer, TDateTime, TDateTime, TFloat, TBlob, Boolean, Boolean);

CREATE OR REPLACE FUNCTION lpInsert_ObjectHistoryProtocol(
    IN inObjectId   Integer, 
    IN inUserId     Integer,
    IN inStartDate  TDateTime,
    IN inEndDate    TDateTime,
    IN inPrice      TFloat,
    IN inAddXML     TBlob DEFAULT '',
    IN inIsUpdate   Boolean DEFAULT NULL, -- Признак
    IN inIsErased   Boolean DEFAULT NULL  -- Признак, если НЕ пустой тогда в протокол св-ва не пишутся
)
RETURNS VOID
AS
$BODY$
   DECLARE ProtocolXML TBlob;
BEGIN

     -- Просмотр - без прав корректировки + Только просмотр Аудитор
     IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE UserId = inUserId AND RoleId IN (7797111, 10597056))
     THEN
         RAISE EXCEPTION 'Ошибка.У пользователя <%> нет прав для изменения данных.', lfGet_Object_ValueData_sh (inUserId);
     END IF;


     -- Подготавливаем XML для "стандартного" протокола
     SELECT '<XML>' || STRING_AGG (D.FieldXML, '') || '</XML>' INTO ProtocolXML
     FROM
          (SELECT D.FieldXML
           FROM 
          (SELECT '<Field FieldName = "Начальная дата" FieldValue = "' || COALESCE (DATE (inStartDate) :: TVarChar, 'NULL') || '"/>'
               || '<Field FieldName = "Конечная дата" FieldValue = "' || COALESCE (DATE (inEndDate) :: TVarChar, 'NULL') || '"/>'
               || '<Field FieldName = "Цена" FieldValue = "' || inPrice || '"/>' AS FieldXML
                , 1 AS GroupId
                , Object.DescId
           FROM Object
           WHERE Object.Id = inObjectId 

          UNION ALL
           SELECT inAddXML AS FieldXML
                , 2        AS GroupId
                , 0        AS DescId
           WHERE inAddXML <> ''
           

          /*UNION
           SELECT '<Field FieldName = "' || zfStrToXmlStr(ObjectFloatDesc.ItemName) || '" FieldValue = "' || COALESCE (ObjectFloat.ValueData :: TVarChar, 'NULL') || '"/>' AS FieldXML 
                , 2 AS GroupId
                , ObjectFloat.DescId
           FROM ObjectFloat
                JOIN ObjectFloatDesc ON ObjectFloatDesc.Id = ObjectFloat.DescId
           WHERE ObjectFloat.ObjectId = inObjectId
             AND inIsErased IS NULL
          UNION
           SELECT '<Field FieldName = "' || zfStrToXmlStr(ObjectDateDesc.ItemName) || '" FieldValue = "' || COALESCE (DATE (ObjectDate.ValueData) :: TVarChar, 'NULL') || '"/>' AS FieldXML 
                , 3 AS GroupId
                , ObjectDate.DescId
           FROM ObjectDate
                JOIN ObjectDateDesc ON ObjectDateDesc.Id = ObjectDate.DescId
           WHERE ObjectDate.ObjectId = inObjectId
             AND inIsErased IS NULL
          UNION
           SELECT '<Field FieldName = "' || zfStrToXmlStr(ObjectLinkDesc.ItemName) || '" FieldValue = "' || zfStrToXmlStr(COALESCE (Object.ValueData, 'NULL')) || '"/>' AS FieldXML 
                , 4 AS GroupId
                , ObjectLink.DescId
           FROM ObjectLink
                JOIN Object ON Object.Id = ObjectLink.ChildObjectId
                JOIN ObjectLinkDesc ON ObjectLinkDesc.Id = ObjectLink.DescId
           WHERE ObjectLink.ObjectId = inObjectId
             AND inIsErased IS NULL
          UNION
           SELECT '<Field FieldName = "' || zfStrToXmlStr(ObjectStringDesc.ItemName) || '" FieldValue = "' || zfStrToXmlStr(COALESCE (ObjectString.ValueData, 'NULL')) || '"/>' AS FieldXML 
                , 5 AS GroupId
                , ObjectString.DescId
           FROM ObjectString
                JOIN ObjectStringDesc ON ObjectStringDesc.Id = ObjectString.DescId
           WHERE ObjectString.ObjectId = inObjectId
             AND inIsErased IS NULL
          UNION
           SELECT '<Field FieldName = "' || zfStrToXmlStr(ObjectBooleanDesc.ItemName) || '" FieldValue = "' || COALESCE (ObjectBoolean.ValueData :: TVarChar, 'NULL') || '"/>' AS FieldXML 
                , 6 AS GroupId
                , ObjectBoolean.DescId
           FROM ObjectBoolean
                JOIN ObjectBooleanDesc ON ObjectBooleanDesc.Id = ObjectBoolean.DescId
           WHERE ObjectBoolean.ObjectId = inObjectId
             AND inIsErased IS NULL*/
          ) AS D
           ORDER BY D.GroupId, D.DescId
          ) AS D
         ;

     -- сохранили "стандартный" протокол
     INSERT INTO ObjectProtocol (ObjectId, OperDate, UserId, ProtocolData, isInsert)
          SELECT inObjectId, CURRENT_TIMESTAMP, inUserId, ProtocolXML, CASE WHEN inIsErased = TRUE THEN NULL ELSE COALESCE ((SELECT 1 FROM ObjectProtocol WHERE ObjectId = inObjectId LIMIT 1), 0) = 0 END;


     -- !!!протокол через свойства конкретного объекта!!!
     IF inIsUpdate = TRUE AND COALESCE (inIsErased, FALSE) = FALSE
     THEN
         -- сохранили свойство <Дата корректировки>
         PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Update(), inObjectId, CURRENT_TIMESTAMP);
         -- сохранили свойство <Пользователь (корректировка)>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Update(), inObjectId, inUserId);
     ELSE
         IF inIsUpdate = FALSE AND COALESCE (inIsErased, FALSE) = FALSE
         THEN
             -- сохранили свойство <Дата создания>
             PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), inObjectId, CURRENT_TIMESTAMP);
             -- сохранили свойство <Пользователь (создание)>
             PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), inObjectId, inUserId);
         END IF;
     END IF;
  
END;           
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION lpInsert_ObjectHistoryProtocol (Integer, Integer, Boolean, Boolean) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 20.08.15         * 

*/
