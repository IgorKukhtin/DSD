-- Function: lpInsert_MovementProtocol (Integer, Integer)

DROP FUNCTION IF EXISTS lpInsert_MovementProtocol (Integer, Integer, Boolean);

CREATE OR REPLACE FUNCTION lpInsert_MovementProtocol (inMovementId Integer, inUserId Integer, inIsInsert Boolean)
  RETURNS void AS
$BODY$
 DECLARE 
   vbProtocolXML TBlob;
BEGIN
  -- Подготавливаем XML для записи в протокол
  SELECT '<XML>' || STRING_AGG (D.FieldXML, '') || '</XML>' INTO vbProtocolXML
  FROM
   (SELECT D.FieldXML
    FROM
   (SELECT '<Field FieldName = "InvNumber" FieldValue = "' || Movement.InvNumber || '"/>'
        || '<Field FieldName = "OperDate" FieldValue = "' || Movement.OperDate || '"/>'
        || '<Field FieldName = "Status" FieldValue = "' || COALESCE (Object.ValueData, 'NULL') || '"/>'
           AS FieldXML 
         , 1 AS GroupId
         , Movement.DescId
    FROM Movement
         LEFT JOIN Object ON Object.Id = Movement.StatusId
    WHERE Movement.Id = inMovementId    
   UNION
    SELECT '<Field FieldName = "' || MovementFloatDesc.ItemName || '" FieldValue = "' || COALESCE (MovementFloat.ValueData :: TVarChar, 'NULL') || '"/>' AS FieldXML 
         , 2 AS GroupId
         , MovementFloat.DescId
    FROM MovementFloat
         INNER JOIN MovementFloatDesc ON MovementFloatDesc.Id = MovementFloat.DescId
    WHERE MovementFloat.MovementId = inMovementId
   UNION
    SELECT '<Field FieldName = "' || MovementDateDesc.ItemName || '" FieldValue = "' || COALESCE (MovementDate.ValueData :: TVarChar, 'NULL') || '"/>' AS FieldXML 
         , 3 AS GroupId
         , MovementDate.DescId
    FROM MovementDate
         INNER JOIN MovementDateDesc ON MovementDateDesc.Id = MovementDate.DescId
    WHERE MovementDate.MovementId = inMovementId
   UNION
    SELECT '<Field FieldName = "' || MovementLinkObjectDesc.ItemName || '" FieldValue = "' || COALESCE (Object.ValueData, 'NULL') || '"/>' AS FieldXML 
         , 4 AS GroupId
         , MovementLinkObject.DescId
    FROM MovementLinkObject
         INNER JOIN MovementLinkObjectDesc ON MovementLinkObjectDesc.Id = MovementLinkObject.DescId
         LEFT JOIN Object ON Object.Id = MovementLinkObject.ObjectId 
    WHERE MovementLinkObject.MovementId = inMovementId
   UNION
    SELECT '<Field FieldName = "' || MovementStringDesc.ItemName || '" FieldValue = "' || COALESCE (MovementString.ValueData, 'NULL') || '"/>' AS FieldXML 
         , 5 AS GroupId
         , MovementString.DescId
    FROM MovementString
         INNER JOIN MovementStringDesc ON MovementStringDesc.Id = MovementString.DescId
    WHERE MovementString.MovementId = inMovementId
   UNION
    SELECT '<Field FieldName = "' || MovementBooleanDesc.ItemName || '" FieldValue = "' || COALESCE (MovementBoolean.ValueData :: TVarChar, 'NULL') || '"/>' AS FieldXML 
         , 6 AS GroupId
         , MovementBoolean.DescId
    FROM MovementBoolean
         INNER JOIN MovementBooleanDesc ON MovementBooleanDesc.Id = MovementBoolean.DescId
    WHERE MovementBoolean.MovementId = inMovementId
   UNION
    SELECT '<Field FieldName = "' || MovementLinkObjectDesc.ItemName || '" FieldValue = "' || COALESCE (MovementLinkObject.ObjectId :: TVarChar, 'NULL') || '"/>' AS FieldXML 
         , 7 AS GroupId
         , MovementLinkObject.DescId
    FROM MovementLinkObject
         INNER JOIN MovementLinkObjectDesc ON MovementLinkObjectDesc.Id = MovementLinkObject.DescId
    WHERE MovementLinkObject.MovementId = inMovementId
   UNION
    SELECT '<Field FieldName = "' || MovementLinkMovementDesc.ItemName || '" FieldValue = "' || COALESCE (MovementLinkMovement.MovementChildId :: TVarChar, 'NULL') || '"/>' AS FieldXML 
         , 8 AS GroupId
         , MovementLinkMovement.DescId
    FROM MovementLinkMovement
         INNER JOIN MovementLinkMovementDesc ON MovementLinkMovementDesc.Id = MovementLinkMovement.DescId
    WHERE MovementLinkMovement.MovementId = inMovementId
   ) AS D
    ORDER BY D.GroupId, D.DescId
   ) AS D
  ;

  -- Сохранили
  INSERT INTO MovementProtocol (MovementId, OperDate, UserId, ProtocolData, isInsert)
                        VALUES (inMovementId, current_timestamp, inUserId, vbProtocolXML, inIsInsert);
  
END;           
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 09.10.14                                        * add MovementLinkMovement
 07.06.14                                        * add MovementLinkObject
 10.05.14                                        * add ORDER BY
*/
