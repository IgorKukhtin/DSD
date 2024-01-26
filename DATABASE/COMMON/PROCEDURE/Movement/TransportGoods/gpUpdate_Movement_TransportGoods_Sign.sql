-- Function: gpUpdate_Movement_TransportGoods_Sign ()

DROP FUNCTION IF EXISTS gpUpdate_Movement_TransportGoods_Sign (Integer, Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_TransportGoods_Sign(
    IN inMovementId               Integer   , --
    IN inSignId                   Integer   , -- �d ������� 1 - ����������� 2 - ����������
    IN inUserNameKey              TVarChar  , -- ��������� �����
    IN inFileNameKey              TVarChar  , -- ���� ����� ��� ������ ����������
   OUT outMemberSignConsignorName TVarChar  ,
   OUT outSignConsignorDate       TDateTime , 
   OUT outMemberSignCarrierName   TVarChar  , 
   OUT outSignCarrierDate         TDateTime ,
   OUT outCommentError            TVarChar  ,
   OUT outisSignConsignor_eTTN    Boolean   ,
   OUT outisSignCarrier_eTTN      Boolean   ,
    IN inSession                  TVarChar    -- ������ ������������

)                              
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId       Integer;
   DECLARE vbMeberId      Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpGetUserBySession (inSession);
     
    -- ���� �� ���������� � ����� 
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
    
    -- ���� �� ������� ���������� � ����� 
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

    -- ���� �� ����� 
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

    -- ���� �� ����������
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

    -- ���� �� ������� ����������
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
    
      -- ��������� ���������
      PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_MemberSignConsignor(), inMovementId, vbMeberId);
      
      -- ��������� �������� <���� �������>
      PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_SignConsignor(), inMovementId, CURRENT_TIMESTAMP);

      -- �������� ����� ������
      PERFORM lpInsertUpdate_MovementString (zc_MovementString_CommentError(), inMovementId, '');
    
    ELSEIF COALESCE (inSignId, 0) = 2
    THEN 

      -- ��������� ���������
      PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_MemberSignCarrier(), inMovementId, vbMeberId);
      
      -- ��������� �������� <���� �������>
      PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_SignCarrier(), inMovementId, CURRENT_TIMESTAMP);

      -- �������� ����� ������
      PERFORM lpInsertUpdate_MovementString (zc_MovementString_CommentError(), inMovementId, '');
    
    ELSE
      RAISE EXCEPTION '������. �� ������ ��� ������� ��� ���������� ����������.';
    END IF;

     -- ��������� ��������
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
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 02.05.23                                                       *
*/

-- ����
-- SELECT * FROM gpUpdate_Movement_TransportGoods_Sign (22086098 , 1, '��������� ������ ���ò����', '24447183_2992217209_SU211210105333.ZS2', '3')