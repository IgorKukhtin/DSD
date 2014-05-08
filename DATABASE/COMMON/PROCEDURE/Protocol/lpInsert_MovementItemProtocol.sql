-- Function: lpInsert_MovementItemProtocol (Integer, Integer)

DROP FUNCTION IF EXISTS lpInsert_MovementItemProtocol (Integer, Integer, Boolean);

CREATE OR REPLACE FUNCTION lpInsert_MovementItemProtocol (inMovementItemId Integer, inUserId Integer, inIsInsert Boolean)
  RETURNS void AS
$BODY$
 DECLARE 
   vbProtocolXML TBlob;
BEGIN
  -- Подготавливаем XML для записи в протокол
  SELECT '<XML>' || STRING_AGG(FieldXML, '') || '</XML>' INTO vbProtocolXML FROM
  (
  SELECT '<Field FieldName = "ObjectId" FieldValue = "' || MovementItem.ObjectId || '"/>'||
         '<Field FieldName = "ValueData" FieldValue = "' || Object.ValueData || '"/>' AS FieldXML 
    FROM MovementItem
         INNER JOIN Object ON Object.Id = MovementItem.ObjectId
   WHERE MovementItem.Id = inMovementItemId    
  UNION SELECT '<Field FieldName = "' || MovementItemStringDesc.ItemName || '" FieldValue = "' || MovementItemString.ValueData || '"/>' AS FieldXML 
    FROM MovementItemString
    JOIN MovementItemStringDesc ON MovementItemStringDesc.Id = MovementItemString.DescId
   WHERE MovementItemString.MovementItemId = inMovementItemId
  UNION SELECT '<Field FieldName = "' || MovementItemFloatDesc.ItemName || '" FieldValue = "' || MovementItemFloat.ValueData || '"/>' AS FieldXML 
    FROM MovementItemFloat
    JOIN MovementItemFloatDesc ON MovementItemFloatDesc.Id = MovementItemFloat.DescId
   WHERE MovementItemFloat.MovementItemId = inMovementItemId
  UNION SELECT '<Field FieldName = "' || MovementItemDateDesc.ItemName || '" FieldValue = "' || MovementItemDate.ValueData || '"/>' AS FieldXML 
    FROM MovementItemDate
    JOIN MovementItemDateDesc ON MovementItemDateDesc.Id = MovementItemDate.DescId
   WHERE MovementItemDate.MovementItemId = inMovementItemId
  UNION SELECT '<Field FieldName = "' || MovementItemLinkObjectDesc.ItemName || '" FieldValue = "' || Object.ValueData || '"/>' AS FieldXML 
    FROM MovementItemLinkObject
    JOIN Object ON Object.Id = MovementItemLinkObject.ObjectId 
    JOIN MovementItemLinkObjectDesc ON MovementItemLinkObjectDesc.Id = MovementItemLinkObject.DescId
   WHERE MovementItemLinkObject.MovementItemId = inMovementItemId
  ) AS D;

  -- Сохранили
  INSERT INTO MovementItemProtocol (MovementItemId, OperDate, UserId, ProtocolData, isInsert)
                       VALUES (inMovementItemId, current_timestamp, inUserId, vbProtocolXML, inIsInsert);
  
END;           
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 07.05.14                                        *
*/
