-- Function: lpInsert_MovementProtocol (Integer, Integer)

DROP FUNCTION IF EXISTS lpInsert_MovementProtocol (Integer, Integer, Boolean);

CREATE OR REPLACE FUNCTION lpInsert_MovementProtocol (inMovementId Integer, inUserId Integer, inIsInsert Boolean)
RETURNS VOID
AS
$BODY$
  DECLARE vbMovementDescId Integer;
  DECLARE vbProtocolXML TBlob;
BEGIN

  -- Просмотр - без прав корректировки + Только просмотр Аудитор
  IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE UserId = inUserId AND RoleId IN (7797111, 10597056))
  THEN
      RAISE EXCEPTION 'Ошибка.У пользователя <%> нет прав для изменения данных.', lfGet_Object_ValueData_sh (inUserId);
  END IF;
  
  --
  vbMovementDescId:= (SELECT Movement.DescId FROM Movement WHERE Movement.Id = inMovementId);

  -- Подготавливаем XML для записи в протокол
  SELECT '<XML>' || STRING_AGG (D.FieldXML, '') || '</XML>' INTO vbProtocolXML
  FROM
   (SELECT D.FieldXML
    FROM
   (SELECT '<Field FieldName = "№ документа" FieldValue = "' || zfStrToXmlStr (Movement.InvNumber) || '"/>'
        || '<Field FieldName = "Дата документа" FieldValue = "' || zfConvert_DateToString (Movement.OperDate) || '"/>'
        || '<Field FieldName = "Статус" FieldValue = "' || COALESCE (Object_Status.ValueData, 'NULL') || '"/>'
        || '<Field FieldName = "***Статус" FieldValue = "' || COALESCE (Object_Status_next.ValueData, Object_Status.ValueData, 'NULL') || '"/>'
        || CASE WHEN Movement.AccessKeyId <> 0 THEN '<Field FieldName = "Доступ" FieldValue = "' || Movement.AccessKeyId :: TVarChar || '"/>' ELSE '' END
        || CASE WHEN Movement.ParentId <> 0 THEN '<Field FieldName = "Главный" FieldValue = "' || COALESCE (Movement_parent.InvNumber, 'NULL') || '"/>' ELSE '' END
           AS FieldXML
         , 1 AS GroupId
         , Movement.DescId
    FROM Movement
         LEFT JOIN Object   AS Object_Status      ON Object_Status.Id = Movement.StatusId
         LEFT JOIN Object   AS Object_Status_next ON Object_Status_next.Id = Movement.StatusId_next
         LEFT JOIN Movement AS Movement_parent    ON Movement_parent.Id = Movement.ParentId
    WHERE Movement.Id = inMovementId    
   UNION
    SELECT '<Field FieldName = "' || zfStrToXmlStr(MovementFloatDesc.ItemName) || '" FieldValue = "' || COALESCE (MovementFloat.ValueData :: TVarChar, 'NULL') || '"/>' AS FieldXML 
         , 2 AS GroupId
         , MovementFloat.DescId
    FROM MovementFloat
         INNER JOIN MovementFloatDesc ON MovementFloatDesc.Id = MovementFloat.DescId
    WHERE MovementFloat.MovementId = inMovementId
   UNION
    SELECT '<Field FieldName = "' || zfStrToXmlStr(MovementDateDesc.ItemName)
        || '" FieldValue = "' || COALESCE (CASE WHEN MovementDate.DescId IN (zc_MovementDate_Insert()
                                                                           , zc_MovementDate_Update()
                                                                           , zc_MovementDate_CarInfo()
                                                                            )
                                                     THEN zfConvert_DateTimeShortToString (MovementDate.ValueData)
                                                ELSE zfConvert_DateToString (MovementDate.ValueData)
                                           END, 'NULL') || '"/>'  AS FieldXML 

         , 3 AS GroupId
         , MovementDate.DescId
    FROM MovementDate
         INNER JOIN MovementDateDesc ON MovementDateDesc.Id = MovementDate.DescId
    WHERE MovementDate.MovementId = inMovementId
   UNION
    SELECT '<Field FieldName = "' || zfStrToXmlStr (COALESCE (ObjectDesc.ItemName, MovementLinkObjectDesc.ItemName)) || '" FieldValue = "' || zfStrToXmlStr(COALESCE (Object.ValueData, 'NULL')) || '"/>' AS FieldXML 
         , 4 AS GroupId
         , MovementLinkObject.DescId
    FROM MovementLinkObject
         INNER JOIN MovementLinkObjectDesc ON MovementLinkObjectDesc.Id = MovementLinkObject.DescId
         LEFT JOIN Object ON Object.Id = MovementLinkObject.ObjectId 
         LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object.DescId AND 1=0
    WHERE MovementLinkObject.MovementId = inMovementId
   UNION
    SELECT '<Field FieldName = "' || zfStrToXmlStr(MovementStringDesc.ItemName) || '" FieldValue = "' || zfStrToXmlStr(COALESCE (MovementString.ValueData, 'NULL')) || '"/>' AS FieldXML 
         , 5 AS GroupId
         , MovementString.DescId
    FROM MovementString
         INNER JOIN MovementStringDesc ON MovementStringDesc.Id = MovementString.DescId
    WHERE MovementString.MovementId = inMovementId
   UNION
    SELECT '<Field FieldName = "' || zfStrToXmlStr (CASE WHEN vbMovementDescId = zc_Movement_MemberHoliday() AND MovementBoolean.DescId = zc_MovementBoolean_isLoad()
                                                         THEN 'Отпуск заполнен'
                                                         ELSE MovementBooleanDesc.ItemName
                                                    END)
        || '" FieldValue = "' || COALESCE (MovementBoolean.ValueData :: TVarChar, 'NULL') || '"/>' AS FieldXML 
         , 6 AS GroupId
         , MovementBoolean.DescId
    FROM MovementBoolean
         INNER JOIN MovementBooleanDesc ON MovementBooleanDesc.Id = MovementBoolean.DescId
    WHERE MovementBoolean.MovementId = inMovementId
   UNION
    SELECT '<Field FieldName = "' || zfStrToXmlStr (COALESCE (MovementDesc.ItemName, MovementLinkMovementDesc.ItemName)) || '" FieldValue = "' || COALESCE (CASE WHEN Movement.InvNumber <> '' THEN Movement.InvNumber ELSE MovementLinkMovement.MovementChildId :: TVarChar END, 'NULL') || '"/>' AS FieldXML 
         , 8 AS GroupId
         , MovementLinkMovement.DescId
    FROM MovementLinkMovement
         INNER JOIN MovementLinkMovementDesc ON MovementLinkMovementDesc.Id = MovementLinkMovement.DescId
         LEFT JOIN Movement ON Movement.Id = MovementLinkMovement.MovementChildId
         LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
    WHERE MovementLinkMovement.MovementId = inMovementId
   ) AS D
    ORDER BY D.GroupId, D.DescId
   ) AS D
  ;

  -- Сохранили
  INSERT INTO MovementProtocol (MovementId, OperDate, UserId, ProtocolData, isInsert)
                        VALUES (inMovementId, CURRENT_TIMESTAMP, inUserId, vbProtocolXML, inIsInsert);
  
END;           
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 09.02.15                         * add zfStrToXmlStr
 09.10.14                                        * add MovementLinkMovement
 07.06.14                                        * add MovementLinkObject
 10.05.14                                        * add ORDER BY
*/
