-- Function: lpInsert_MovementProtocol(integer, integer)

DROP FUNCTION IF EXISTS lpInsert_MovementProtocol(integer, integer, boolean);

CREATE OR REPLACE FUNCTION lpInsert_MovementProtocol(inMovementId integer, inUserId integer, inisInsert boolean)
  RETURNS void AS
$BODY$
 DECLARE 
   ProtocolXML TBlob;
BEGIN
  -- Подготавливаем XML для записи в протокол
  SELECT '<XML>' || STRING_AGG(FieldXML, '') || '</XML>' INTO ProtocolXML FROM
  (
  SELECT '<Field FieldName = "InvNumber" FieldValue = "' || Movement.InvNumber || '"/>'||
         '<Field FieldName = "OperDate" FieldValue = "' || Movement.OperDate || '"/>' AS FieldXML 
    FROM Movement
   WHERE Movement.Id = inMovementId    
  UNION SELECT '<Field FieldName = "' || MovementStringDesc.ItemName || '" FieldValue = "' || MovementString.ValueData || '"/>' AS FieldXML 
    FROM MovementString
    JOIN MovementStringDesc ON MovementStringDesc.Id = MovementString.DescId
   WHERE MovementString.MovementId = inMovementId
  UNION SELECT '<Field FieldName = "' || MovementFloatDesc.ItemName || '" FieldValue = "' || MovementFloat.ValueData || '"/>' AS FieldXML 
    FROM MovementFloat
    JOIN MovementFloatDesc ON MovementFloatDesc.Id = MovementFloat.DescId
   WHERE MovementFloat.MovementId = inMovementId
  UNION SELECT '<Field FieldName = "' || MovementDateDesc.ItemName || '" FieldValue = "' || MovementDate.ValueData || '"/>' AS FieldXML 
    FROM MovementDate
    JOIN MovementDateDesc ON MovementDateDesc.Id = MovementDate.DescId
   WHERE MovementDate.MovementId = inMovementId
  UNION SELECT '<Field FieldName = "' || MovementLinkObjectDesc.ItemName || '" FieldValue = "' || Object.ValueData || '"/>' AS FieldXML 
    FROM MovementLinkObject
    JOIN Object ON Object.Id = MovementLinkObject.ObjectId 
    JOIN MovementLinkObjectDesc ON MovementLinkObjectDesc.Id = MovementLinkObject.DescId
   WHERE MovementLinkObject.MovementId = inMovementId
  ) AS D;

  INSERT INTO MovementProtocol (MovementId, OperDate, UserId, ProtocolData, isInsert)
                       VALUES (inMovementId, current_timestamp, inUserId, ProtocolXML, inisInsert);
  
END;           
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION lpInsert_MovementProtocol(integer, integer, boolean)
  OWNER TO postgres;
