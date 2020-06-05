-- Function: gpUpdate_Movement_Confirmed()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Confirmed(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Confirmed(
    IN inMovementId          Integer   ,    -- ���� ���������
    IN inisConfirmed         Boolean   ,    -- �����������
   OUT outisConfirmed        Boolean   ,    -- �����������
   OUT outConfirmedText      TVarChar  ,
    IN inSession             TVarChar       -- ������� ������������
)
RETURNS Record AS
$BODY$
   DECLARE vbUserId      Integer;
   DECLARE vbUnitId      Integer;
   DECLARE vbUnitKey     TVarChar;
   DECLARE vbStatusId    Integer;
   DECLARE vbUnitIdFrom  Integer;
   DECLARE vbisDeferred  Boolean;
   DECLARE vbisVIP       Boolean;
   DECLARE vbisConfirmed Boolean;
   DECLARE vbisSent      Boolean;
BEGIN

   IF COALESCE(inMovementId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);
   vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
   IF vbUnitKey = '' THEN
      vbUnitKey := '0';
   END IF;
   vbUnitId := vbUnitKey::Integer;

   SELECT Movement.StatusId, MovementLinkObject_From.ObjectId
        , COALESCE (MovementBoolean_Deferred.ValueData, FALSE)   ::Boolean AS isDeferred
        , COALESCE (MovementBoolean_VIP.ValueData, FALSE)        ::Boolean AS isVIP
        , COALESCE (MovementBoolean_Confirmed.ValueData, FALSE)  ::Boolean AS isConfirmed
        , COALESCE (MovementBoolean_Sent.ValueData, FALSE)       ::Boolean AS isSent
   INTO vbStatusId, vbUnitIdFrom, vbisDeferred, vbisVIP, vbisConfirmed, vbisSent
   FROM Movement

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

            LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                      ON MovementBoolean_Deferred.MovementId = Movement.Id
                                     AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()

            LEFT JOIN MovementBoolean AS MovementBoolean_VIP
                                      ON MovementBoolean_VIP.MovementId = Movement.Id
                                     AND MovementBoolean_VIP.DescId = zc_MovementBoolean_VIP()

            LEFT JOIN MovementBoolean AS MovementBoolean_Confirmed
                                      ON MovementBoolean_Confirmed.MovementId = Movement.Id
                                     AND MovementBoolean_Confirmed.DescId = zc_MovementBoolean_Confirmed()

            LEFT JOIN MovementBoolean AS MovementBoolean_Sent
                                      ON MovementBoolean_Sent.MovementId = Movement.Id
                                     AND MovementBoolean_Sent.DescId = zc_MovementBoolean_Sent()

   WHERE Movement.Id = inMovementId;

   IF COALESCE (vbStatusId, 0) <> zc_Enum_Status_UnComplete()
   THEN
      RAISE EXCEPTION '������. ��������� ��������� � ������� <%> �� ��������.', lfGet_Object_ValueData (vbStatusId);
   END IF;
   
   IF vbUnitIdFrom <> vbUnitId AND 
      NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
   THEN
      RAISE EXCEPTION '������. ��������� <�����������> ��������� ������ ���������� ������ �����������.';
   END IF;

   IF vbisVIP <> TRUE
   THEN
      RAISE EXCEPTION '������. ��� ��������� <�����������> �������� ������ ���� � ���������� <����������� ���>.';
   END IF;

   IF vbisSent = TRUE AND inisConfirmed = TRUE
   THEN
      RAISE EXCEPTION '������. ����������� <����������-��> ������ �������� <�����������> ���������.';
   END IF;

/*   IF inisConfirmed = TRUE AND 
      NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
   THEN
      RAISE EXCEPTION '������. ������ �������� <�����������> ��� ���������, ���������� � ���������� ��������������';
   END IF;
*/

   -- ��������� �������
   PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Confirmed(), inMovementId, inisConfirmed);

   -- ��������� ����
   PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_UserConfirmedKind(), inMovementId, CURRENT_TIMESTAMP);

   -- ��������� ��������
   PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

   outisConfirmed := inisConfirmed;
   outConfirmedText := CASE WHEN outisConfirmed = TRUE  THEN '�����������'   
                            ELSE '�� �����������' END;
                            
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.  ������ �.�.
 12.10.19                                                                      *
 06.08.19                                                                      *
*/

