-- DROP FUNCTION lpInsert_ObjectProtocol (IN inObjectId Integer, IN inUserId Integer);

DROP FUNCTION IF EXISTS lpInsert_ObjectProtocol (Integer, Integer);
DROP FUNCTION IF EXISTS lpInsert_ObjectProtocol (Integer, Integer, Boolean);
DROP FUNCTION IF EXISTS lpInsert_ObjectProtocol (Integer, Integer, Boolean, Boolean);

CREATE OR REPLACE FUNCTION lpInsert_ObjectProtocol(
    IN inObjectId Integer, 
    IN inUserId   Integer,
    IN inIsUpdate Boolean DEFAULT NULL, -- Признак
    IN inIsErased Boolean DEFAULT NULL  -- Признак, если НЕ пустой тогда в протокол св-ва не пишутся
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
          (SELECT '<Field FieldName = "Значение" FieldValue = "' || zfStrToXmlStr(Object.ValueData) || '"/>'
               || '<Field FieldName = "Код" FieldValue = "' || Object.ObjectCode || '"/>'
               || '<Field FieldName = "Доступ" FieldValue = "' || CASE WHEN Object.AccessKeyId IS NULL THEN 'NULL' ELSE Object.AccessKeyId :: TVarChar END || '"/>'
               || '<Field FieldName = "Удален" FieldValue = "' || Object.isErased || '"/>' AS FieldXML
                , 1 AS GroupId
                , Object.DescId
           FROM Object
           WHERE Object.Id = inObjectId 

          UNION
           -- ObjectFloat
           SELECT '<Field FieldName = "' || zfStrToXmlStr(ObjectFloatDesc.ItemName) || '" FieldValue = "' || COALESCE (ObjectFloat.ValueData :: TVarChar, 'NULL') || '"/>' AS FieldXML 
                , 2 AS GroupId
                , ObjectFloat.DescId
           FROM ObjectFloat
                JOIN ObjectFloatDesc ON ObjectFloatDesc.Id = ObjectFloat.DescId
           WHERE ObjectFloat.ObjectId = inObjectId
             AND inIsErased IS NULL
             AND ObjectFloat.DescId <> zc_ObjectFloat_Member_ScalePSW()

          UNION
           -- ObjectDate
           SELECT '<Field FieldName = "' || zfStrToXmlStr (ObjectDateDesc.ItemName)
               || '" FieldValue = "' || COALESCE (CASE WHEN ObjectDate.DescId IN (zc_ObjectDate_ImportSettings_StartTime()
                                                                                , zc_ObjectDate_ImportSettings_EndTime()
                                                                                , zc_ObjectDate_User_UpdateMobileFrom()
                                                                                , zc_ObjectDate_User_UpdateMobileTo()
                                                                                , zc_ObjectDate_Protocol_Insert()
                                                                                , zc_ObjectDate_Protocol_Update()
                                                                                , zc_ObjectDate_User_GUID()
                                                                                , zc_ObjectDate_User_SMS()
                                                                                 )
                                                            THEN zfConvert_DateTimeShortToString (ObjectDate.ValueData)
                                                       ELSE zfConvert_DateToString (ObjectDate.ValueData)
                                                  END, 'NULL') || '"/>' :: TVarChar AS FieldXML 
                , 3 AS GroupId
                , ObjectDate.DescId
           FROM ObjectDate
                JOIN ObjectDateDesc ON ObjectDateDesc.Id = ObjectDate.DescId
           WHERE ObjectDate.ObjectId = inObjectId
             AND inIsErased IS NULL

          UNION
           -- ObjectLink
           SELECT '<Field FieldName = "' || zfStrToXmlStr(ObjectLinkDesc.ItemName) || '" FieldValue = "' || zfStrToXmlStr(COALESCE (Object.ValueData, 'NULL')) || '"/>' AS FieldXML 
                , 4 AS GroupId
                , ObjectLink.DescId
           FROM ObjectLink
                JOIN Object ON Object.Id = ObjectLink.ChildObjectId
                JOIN ObjectLinkDesc ON ObjectLinkDesc.Id = ObjectLink.DescId
           WHERE ObjectLink.ObjectId = inObjectId
             AND inIsErased IS NULL

          UNION
           -- String
           SELECT '<Field FieldName = "' || zfStrToXmlStr(ObjectStringDesc.ItemName)
               || '" FieldValue = "' || zfStrToXmlStr(COALESCE (CASE WHEN ObjectString.DescId IN (zc_ObjectString_User_SMS(), zc_ObjectString_User_Password())
                                                                      AND ObjectString.ValueData <> ''
                                                                     THEN '***'
                                                                     ELSE ObjectString.ValueData
                                                                END, 'NULL'))
               || '"/>' AS FieldXML 
                , 5 AS GroupId
                , ObjectString.DescId
           FROM ObjectString
                JOIN ObjectStringDesc ON ObjectStringDesc.Id = ObjectString.DescId
           WHERE ObjectString.ObjectId = inObjectId
             AND inIsErased IS NULL

          UNION
           -- ObjectBoolean
           SELECT '<Field FieldName = "' || zfStrToXmlStr(ObjectBooleanDesc.ItemName) || '" FieldValue = "' || COALESCE (ObjectBoolean.ValueData :: TVarChar, 'NULL') || '"/>' AS FieldXML 
                , 6 AS GroupId
                , ObjectBoolean.DescId
           FROM ObjectBoolean
                JOIN ObjectBooleanDesc ON ObjectBooleanDesc.Id = ObjectBoolean.DescId
           WHERE ObjectBoolean.ObjectId = inObjectId
             AND inIsErased IS NULL
          ) AS D
           ORDER BY D.GroupId, D.DescId
          ) AS D
         ;

     -- сохранили "стандартный" протокол
     INSERT INTO ObjectProtocol (ObjectId, OperDate, UserId, ProtocolData, isInsert)
          SELECT inObjectId, CURRENT_TIMESTAMP, inUserId, ProtocolXML, COALESCE ((SELECT 1 FROM ObjectProtocol WHERE ObjectId = inObjectId LIMIT 1), 0) = 0;


     -- !!!протокол через свойства конкретного объекта!!!
     IF inIsUpdate = TRUE
     THEN
         -- сохранили свойство <Дата корректировки>
         PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Update(), inObjectId, CURRENT_TIMESTAMP);
         -- сохранили свойство <Пользователь (корректировка)>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Update(), inObjectId, inUserId);
     ELSE
         IF inIsUpdate = FALSE
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
ALTER FUNCTION lpInsert_ObjectProtocol (Integer, Integer, Boolean, Boolean) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 09.02.15                         * add zfStrToXmlStr
 14.05.14                                        * add ObjectBoolean
 24.02.14                                        *
*/
/*
insert into ObjectDate (DescId, ObjectId, ValueData) 
select zc_ObjectDate_Protocol_Insert(), Object.Id, ObjectProtocol.OperDate
from Object join (select ObjectId, min(Id) as minId, max(Id) as maxId, min (OperDate) as minOperDate,  max (OperDate) as maxOperDate from ObjectProtocol group by ObjectId
                 ) as ObjecProtocol_find on ObjecProtocol_find.ObjectId = Object.Id
            join ObjectProtocol on ObjectProtocol.Id = ObjecProtocol_find.minId
            left join ObjectDate on ObjectDate.DescId = zc_ObjectDate_Protocol_Insert() and ObjectDate.ObjectId = Object.Id
where Object.DescId in (zc_Object_Contract(), zc_Object_ContractCondition())
     and ObjectDate.ObjectId is null;

insert into ObjectDate (DescId, ObjectId, ValueData) 
select zc_ObjectDate_Protocol_Update(), Object.Id, ObjectProtocol.OperDate
from Object join (select ObjectId, min(Id) as minId, max(Id) as maxId, min (OperDate) as minOperDate,  max (OperDate) as maxOperDate from ObjectProtocol group by ObjectId
                 ) as ObjecProtocol_find on ObjecProtocol_find.ObjectId = Object.Id and ObjecProtocol_find.minId <> ObjecProtocol_find.maxId
            join ObjectProtocol on ObjectProtocol.Id = ObjecProtocol_find.maxId
            left join ObjectDate on ObjectDate.DescId = zc_ObjectDate_Protocol_Update() and ObjectDate.ObjectId = Object.Id
where Object.DescId in (zc_Object_Contract(), zc_Object_ContractCondition())
     and ObjectDate.ObjectId is null;




insert into ObjectLink (DescId, ObjectId, ChildObjectId) 
select zc_ObjectLink_Protocol_Insert(), Object.Id, ObjectProtocol.UserId
from Object join (select ObjectId, min(Id) as minId, max(Id) as maxId, min (OperDate) as minOperDate,  max (OperDate) as maxOperDate from ObjectProtocol group by ObjectId
                 ) as ObjecProtocol_find on ObjecProtocol_find.ObjectId = Object.Id
            join ObjectProtocol on ObjectProtocol.Id = ObjecProtocol_find.minId
            left join ObjectLink on ObjectLink.DescId = zc_ObjectLink_Protocol_Insert() and ObjectLink.ObjectId = Object.Id
where Object.DescId in (zc_Object_Contract(), zc_Object_ContractCondition())
     and ObjectLink.ObjectId is null;

insert into ObjectLink (DescId, ObjectId, ChildObjectId) 
select zc_ObjectLink_Protocol_Update(), Object.Id, ObjectProtocol.UserId
from Object join (select ObjectId, min(Id) as minId, max(Id) as maxId, min (OperDate) as minOperDate,  max (OperDate) as maxOperDate from ObjectProtocol group by ObjectId
                 ) as ObjecProtocol_find on ObjecProtocol_find.ObjectId = Object.Id and ObjecProtocol_find.minId <> ObjecProtocol_find.maxId
            join ObjectProtocol on ObjectProtocol.Id = ObjecProtocol_find.maxId
            left join ObjectLink on ObjectLink.DescId = zc_ObjectLink_Protocol_Update() and ObjectLink.ObjectId = Object.Id
where Object.DescId in (zc_Object_Contract(), zc_Object_ContractCondition())
     and ObjectLink.ObjectId is null;
*/