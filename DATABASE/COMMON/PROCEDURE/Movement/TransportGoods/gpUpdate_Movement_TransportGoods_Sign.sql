-- Function: gpUpdate_Movement_TransportGoods_Sign ()

DROP FUNCTION IF EXISTS gpUpdate_Movement_TransportGoods_Sign (Integer, Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_TransportGoods_Sign(
    IN inMovementId               Integer   , --
    IN inSignId                   Integer   , -- Іd подписи 1 - отправитель 2 - перевозчик
    IN inUserNameKey              TVarChar  , -- Сотрудник ключа
    IN inFileNameKey              TVarChar  , -- Файл ключа для поиска сотрудника
   OUT outMemberSignConsignorName TVarChar  ,
   OUT outSignConsignorDate       TDateTime , 
   OUT outMemberSignCarrierName   TVarChar  , 
   OUT outSignCarrierDate         TDateTime ,
   OUT outCommentError            TVarChar  ,
   OUT outisSignConsignor_eTTN    Boolean   ,
   OUT outisSignCarrier_eTTN      Boolean   ,
    IN inSession                  TVarChar    -- сессия пользователя

)                              
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId       Integer;
   DECLARE vbMeberId      Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);
     
    -- Ищем по сотруднику и файлу 
    SELECT Object_Member.Id
    INTO vbMeberId
    FROM ObjectString AS ObjectString_UserSign
         INNER JOIN Object AS Object_User ON Object_User.Id  = ObjectString_UserSign.ObjectId
         INNER JOIN ObjectLink AS ObjectLinkMeber
                               ON ObjectLinkMeber.ObjectId  = Object_User.Id
                              AND ObjectLinkMeber.DescId = zc_ObjectLink_User_Member()
         INNER JOIN Object AS Object_Member ON Object_Member.Id  = ObjectLinkMeber.ChildObjectId     
    WHERE ObjectString_UserSign.DescId = zc_ObjectString_User_Sign() 
      and ObjectString_UserSign.ValueData ILIKE '%'||inFileNameKey||'%'
      and Object_Member.ValueData ILIKE '%'||inUserNameKey||'%'
    LIMIT 1;
    
    -- Ищем по фамилии сотрудника и файлу 
    IF COALESCE(vbMeberId, 0) = 0
    THEN
      SELECT Object_Member.Id
      INTO vbMeberId
      FROM ObjectString AS ObjectString_UserSign
           INNER JOIN Object AS Object_User ON Object_User.Id  = ObjectString_UserSign.ObjectId
           INNER JOIN ObjectLink AS ObjectLinkMeber
                                 ON ObjectLinkMeber.ObjectId  = Object_User.Id
                                AND ObjectLinkMeber.DescId = zc_ObjectLink_User_Member()
           INNER JOIN Object AS Object_Member ON Object_Member.Id  = ObjectLinkMeber.ChildObjectId     
      WHERE ObjectString_UserSign.DescId = zc_ObjectString_User_Sign() 
        and ObjectString_UserSign.ValueData ILIKE '%'||inFileNameKey||'%'
        and Object_Member.ValueData ILIKE '%'||split_part(inUserNameKey, ' ', 1)||'%'
      LIMIT 1;    
    END IF;

    -- Ищем по файлу 
    IF COALESCE(vbMeberId, 0) = 0
    THEN
      SELECT Object_Member.Id
      INTO vbMeberId
      FROM ObjectString AS ObjectString_UserSign
           INNER JOIN Object AS Object_User ON Object_User.Id  = ObjectString_UserSign.ObjectId
           INNER JOIN ObjectLink AS ObjectLinkMeber
                                 ON ObjectLinkMeber.ObjectId  = Object_User.Id
                                AND ObjectLinkMeber.DescId = zc_ObjectLink_User_Member()
           INNER JOIN Object AS Object_Member ON Object_Member.Id  = ObjectLinkMeber.ChildObjectId     
      WHERE ObjectString_UserSign.DescId = zc_ObjectString_User_Sign() 
        and ObjectString_UserSign.ValueData ILIKE '%'||inFileNameKey||'%'
      LIMIT 1;    
    END IF;

    -- Ищем по сотруднику
    IF COALESCE(vbMeberId, 0) = 0
    THEN
      SELECT Object_Member.Id
      INTO vbMeberId
      FROM ObjectString AS ObjectString_UserSign
           INNER JOIN Object AS Object_User ON Object_User.Id  = ObjectString_UserSign.ObjectId
           INNER JOIN ObjectLink AS ObjectLinkMeber
                                 ON ObjectLinkMeber.ObjectId  = Object_User.Id
                                AND ObjectLinkMeber.DescId = zc_ObjectLink_User_Member()
           INNER JOIN Object AS Object_Member ON Object_Member.Id  = ObjectLinkMeber.ChildObjectId     
      WHERE ObjectString_UserSign.DescId = zc_ObjectString_User_Sign() 
        and Object_Member.ValueData ILIKE '%'||inUserNameKey||'%'
      LIMIT 1;    
    END IF;

    -- Ищем по фамилии сотрудника
    IF COALESCE(vbMeberId, 0) = 0
    THEN
      SELECT Object_Member.Id
      INTO vbMeberId
      FROM ObjectString AS ObjectString_UserSign
           INNER JOIN Object AS Object_User ON Object_User.Id  = ObjectString_UserSign.ObjectId
           INNER JOIN ObjectLink AS ObjectLinkMeber
                                 ON ObjectLinkMeber.ObjectId  = Object_User.Id
                                AND ObjectLinkMeber.DescId = zc_ObjectLink_User_Member()
           INNER JOIN Object AS Object_Member ON Object_Member.Id  = ObjectLinkMeber.ChildObjectId     
      WHERE ObjectString_UserSign.DescId = zc_ObjectString_User_Sign() 
        and Object_Member.ValueData ILIKE '%'||split_part(inUserNameKey, ' ', 1)||'%'
      LIMIT 1;    
    END IF;
    
    IF COALESCE (inSignId, 0) = 1
    THEN 
    
      -- сохранили менеджера
      PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_MemberSignConsignor(), inMovementId, vbMeberId);
      
      -- сохранили свойство <Дата подписи>
      PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_SignConsignor(), inMovementId, CURRENT_TIMESTAMP);

      -- очистили Текст ошибки
      PERFORM lpInsertUpdate_MovementString (zc_MovementString_CommentError(), inMovementId, '');
    
    ELSEIF COALESCE (inSignId, 0) = 2
    THEN 

      -- сохранили менеджера
      PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_MemberSignCarrier(), inMovementId, vbMeberId);
      
      -- сохранили свойство <Дата подписи>
      PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_SignCarrier(), inMovementId, CURRENT_TIMESTAMP);

      -- очистили Текст ошибки
      PERFORM lpInsertUpdate_MovementString (zc_MovementString_CommentError(), inMovementId, '');
    
    ELSE
      RAISE EXCEPTION 'Ошибка. Не описан тип подписи для сохранения сотрудника.';
    END IF;

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, False);


     SELECT Object_MemberSignConsignor.ValueData                               AS MemberSignConsignorName
          , MovementDate_SignConsignor.ValueData                               AS SignConsignorDate
          , Object_MemberSignCarrier.ValueData                                 AS MemberSignCarrierName
          , MovementDate_SignCarrier.ValueData                                 AS SignCarrierDate
          , MovementString_CommentError.ValueData                              AS CommentError
          , (COALESCE(Object_MemberSignConsignor.ValueData, '') <> '')::Boolean AS isSignConsignor_eTTN
          , (COALESCE(Object_MemberSignCarrier.ValueData, '') <> '')::Boolean   AS isSignCarrier_eTTN
     INTO outMemberSignConsignorName
        , outSignConsignorDate
        , outMemberSignCarrierName
        , outSignCarrierDate
        , outCommentError
        , outisSignConsignor_eTTN
        , outisSignCarrier_eTTN
     FROM Movement 

          LEFT JOIN MovementLinkObject AS MovementLinkObject_MemberSignConsignor
                                       ON MovementLinkObject_MemberSignConsignor.MovementId = Movement.Id
                                      AND MovementLinkObject_MemberSignConsignor.DescId = zc_MovementLinkObject_MemberSignConsignor()
          LEFT JOIN Object AS Object_MemberSignConsignor ON Object_MemberSignConsignor.Id = MovementLinkObject_MemberSignConsignor.ObjectId
          LEFT JOIN MovementDate AS MovementDate_SignConsignor
                                 ON MovementDate_SignConsignor.MovementId =  Movement.Id
                                AND MovementDate_SignConsignor.DescId = zc_MovementDate_SignConsignor()
                                
          LEFT JOIN MovementLinkObject AS MovementLinkObject_MemberSignCarrier
                                       ON MovementLinkObject_MemberSignCarrier.MovementId = Movement.Id
                                      AND MovementLinkObject_MemberSignCarrier.DescId = zc_MovementLinkObject_MemberSignCarrier()
          LEFT JOIN Object AS Object_MemberSignCarrier ON Object_MemberSignCarrier.Id = MovementLinkObject_MemberSignCarrier.ObjectId
          LEFT JOIN MovementDate AS MovementDate_SignCarrier
                                 ON MovementDate_SignCarrier.MovementId =  Movement.Id
                                AND MovementDate_SignCarrier.DescId = zc_MovementDate_SignCarrier()
                                  
          LEFT JOIN MovementString AS MovementString_CommentError
                                   ON MovementString_CommentError.MovementId =  Movement.Id
                                  AND MovementString_CommentError.DescId = zc_MovementString_CommentError()
                                
     WHERE Movement.Id = inMovementId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 02.05.23                                                       *
*/

-- тест
-- SELECT * FROM gpUpdate_Movement_TransportGoods_Sign (22086098 , 1, 'НАГОРНОВА ТЕТЯНА СЕРГІЇВНА', '24447183_2992217209_SU211210105333.ZS2', '3')