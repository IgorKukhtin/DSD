-- DROP FUNCTION lpInsert_ObjectProtocol (IN inObjectId Integer, IN inUserId Integer);

DROP FUNCTION IF EXISTS lpInsert_ObjectProtocol (Integer, Integer);
DROP FUNCTION IF EXISTS lpInsert_ObjectProtocol (Integer, Integer, Boolean);

CREATE OR REPLACE FUNCTION lpInsert_ObjectProtocol(
    IN inObjectId Integer, 
    IN inUserId   Integer,
    IN inIsUpdate Boolean DEFAULT NULL  -- �������
)
RETURNS void
AS
$BODY$
   DECLARE ProtocolXML TBlob;
BEGIN
     IF inIsUpdate = TRUE
     THEN
         -- ��������� �������� <���� �������������>
         PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Update(), inId, CURRENT_TIMESTAMP);
         -- ��������� �������� <������������ (�������������)>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Update(), inId, inUserId);
     ELSE
         IF inIsUpdate = FALSE
         THEN
             -- ��������� �������� <���� ��������>
             PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), inId, CURRENT_TIMESTAMP);
             -- ��������� �������� <������������ (��������)>
             PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), inId, inUserId);
         END IF;
     END IF;


  -- �������������� XML ��� ������ � ��������
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
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsert_ObjectProtocol (Integer, Integer, Boolean) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 24.02.14                                        *
*/


