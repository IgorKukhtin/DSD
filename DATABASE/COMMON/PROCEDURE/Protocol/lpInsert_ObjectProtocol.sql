-- DROP FUNCTION lpInsert_ObjectProtocol (IN inObjectId Integer, IN inUserId Integer);

DROP FUNCTION IF EXISTS lpInsert_ObjectProtocol (Integer, Integer);
DROP FUNCTION IF EXISTS lpInsert_ObjectProtocol (Integer, Integer, Boolean);
DROP FUNCTION IF EXISTS lpInsert_ObjectProtocol (Integer, Integer, Boolean, Boolean);

CREATE OR REPLACE FUNCTION lpInsert_ObjectProtocol(
    IN inObjectId Integer, 
    IN inUserId   Integer,
    IN inIsUpdate Boolean DEFAULT NULL, -- Признак
    IN inIsErased Boolean DEFAULT NULL  -- Признак
)
RETURNS void
AS
$BODY$
   DECLARE ProtocolXML TBlob;
BEGIN
     -- Подготавливаем XML для "стандартного" протокола
     SELECT '<XML>' || STRING_AGG(FieldXML, '') || '</XML>'
            INTO ProtocolXML
     FROM (SELECT '<Field FieldName = "Name" FieldValue = "' || Object.ValueData || '"/>'
               || '<Field FieldName = "Code" FieldValue = "' || Object.ObjectCode || '"/>'
               || '<Field FieldName = "isErased" FieldValue = "' || Object.isErased || '"/>' AS FieldXML
                , 1 AS Order1
                , 0 AS Order2
           FROM Object
           WHERE Object.Id = inObjectId 
          UNION
           SELECT '<Field FieldName = "' || ObjectStringDesc.ItemName || '" FieldValue = "' || ObjectString.ValueData || '"/>' AS FieldXML 
                , 2 AS Order1
                , ObjectString.DescId AS Order2
           FROM ObjectString
                JOIN ObjectStringDesc ON ObjectStringDesc.Id = ObjectString.DescId
           WHERE ObjectString.ObjectId = inObjectId
             AND inIsErased IS NULL
          UNION
           SELECT '<Field FieldName = "' || ObjectFloatDesc.ItemName || '" FieldValue = "' || ObjectFloat.ValueData || '"/>' AS FieldXML 
                , 3 AS Order1
                , ObjectFloat.DescId AS Order2
           FROM ObjectFloat
                JOIN ObjectFloatDesc ON ObjectFloatDesc.Id = ObjectFloat.DescId
           WHERE ObjectFloat.ObjectId = inObjectId
             AND inIsErased IS NULL
          UNION
           SELECT '<Field FieldName = "' || ObjectDateDesc.ItemName || '" FieldValue = "' || ObjectDate.ValueData || '"/>' AS FieldXML 
                , 4 AS Order1
                , ObjectDate.DescId AS Order2
           FROM ObjectDate
                JOIN ObjectDateDesc ON ObjectDateDesc.Id = ObjectDate.DescId
           WHERE ObjectDate.ObjectId = inObjectId
             AND inIsErased IS NULL
          UNION
           SELECT '<Field FieldName = "' || ObjectLinkDesc.ItemName || '" FieldValue = "' || Object.ValueData || '"/>' AS FieldXML 
                , 5 AS Order1
                , ObjectLink.DescId AS Order2
           FROM ObjectLink
                JOIN Object ON Object.Id = ObjectLink.ChildObjectId
                JOIN ObjectLinkDesc ON ObjectLinkDesc.Id = ObjectLink.DescId
           WHERE ObjectLink.ObjectId = inObjectId
             AND inIsErased IS NULL
          ORDER BY 2, 3
          ) AS D;

     -- сохранили "стандартный" протокол
     INSERT INTO ObjectProtocol (ObjectId, OperDate, UserId, ProtocolData, isInsert)
          SELECT inObjectId, current_timestamp, inUserId, ProtocolXML, COALESCE ((SELECT 1 FROM ObjectProtocol WHERE ObjectId = inObjectId LIMIT 1), 0) = 0;


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