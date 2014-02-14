--DROP FUNCTION lpInsert_ObjectProtocol(IN inObjectId integer, IN inUserId integer);

CREATE OR REPLACE FUNCTION lpInsert_ObjectProtocol(
IN inObjectId integer, 
IN inUserId integer)
 RETURNS void
 AS $BODY$
 DECLARE 
   ProtocolXML TBlob;
BEGIN
  -- Подготавливаем XML для записи в протокол
  SELECT '<XML>' || STRING_AGG(FieldXML, '') || '</XML>' INTO ProtocolXML FROM
  (
  SELECT '<Field FieldName = "Name" FieldValue = "' || Object.ValueData || '"/>'||
         '<Field FieldName = "Code" FieldValue = "' || Object.ObjectCode || '"/>' AS FieldXML 
    FROM Object
   WHERE Object.Id = inObjectId 
  UNION SELECT '<Field FieldName = "' || ObjectStringDesc.ItemName || '" FieldValue = "' || ObjectString.ValueData || '"/>' AS FieldXML 
    FROM ObjectString
    JOIN ObjectStringDesc ON ObjectStringDesc.Id = ObjectString.DescId
   WHERE ObjectString.ObjectId = inObjectId
  UNION SELECT '<Field FieldName = "' || ObjectFloatDesc.ItemName || '" FieldValue = "' || ObjectFloat.ValueData || '"/>' AS FieldXML 
    FROM ObjectFloat
    JOIN ObjectFloatDesc ON ObjectFloatDesc.Id = ObjectFloat.DescId
   WHERE ObjectFloat.ObjectId = inObjectId
  UNION SELECT '<Field FieldName = "' || ObjectDateDesc.ItemName || '" FieldValue = "' || ObjectDate.ValueData || '"/>' AS FieldXML 
    FROM ObjectDate
    JOIN ObjectDateDesc ON ObjectDateDesc.Id = ObjectDate.DescId
   WHERE ObjectDate.ObjectId = inObjectId
  UNION SELECT '<Field FieldName = "' || ObjectLinkDesc.ItemName || '" FieldValue = "' || Object.ValueData || '"/>' AS FieldXML 
    FROM ObjectLink
    JOIN Object ON Object.Id = ObjectLink.ChildObjectId 
    JOIN ObjectLinkDesc ON ObjectLinkDesc.Id = ObjectLink.DescId
   WHERE ObjectLink.ObjectId = inObjectId
  ) AS D;

  INSERT INTO ObjectProtocol (ObjectId, OperDate, UserId, ProtocolData, isInsert)
       SELECT inObjectId, current_timestamp, inUserId, ProtocolXML, COALESCE((SELECT 1 FROM ObjectProtocol WHERE ObjectId = inObjectId LIMIT 1), 0) = 0;
  
END;           
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION lpInsert_ObjectProtocol(integer, integer)
  OWNER TO postgres; 