-- Function: gpUpdate_Movement_Sent()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Sent(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Sent(
    IN inMovementId          Integer   ,    -- ���� ���������
    IN inisReceived          Boolean   ,    -- ��������-��
    IN inSession             TVarChar       -- ������� ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbUnitId     Integer;
   DECLARE vbUnitKey    TVarChar;
   DECLARE vbStatusId   Integer;
   DECLARE vbUnitIdFrom Integer;
   DECLARE vbisDeferred Boolean;
   DECLARE vbisSUN      Boolean;
   DECLARE vbisDefSUN   Boolean;
   DECLARE vbisSent     Boolean;
   DECLARE vbisReceived Boolean;
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
        , COALESCE (MovementBoolean_Deferred.ValueData, FALSE)::Boolean AS isDeferred
        , COALESCE (MovementBoolean_SUN.ValueData, FALSE)     ::Boolean AS isSUN
        , COALESCE (MovementBoolean_DefSUN.ValueData, FALSE)  ::Boolean AS isDefSUN
        , COALESCE (MovementBoolean_Sent.ValueData, FALSE)::Boolean AS isSent
        , COALESCE (MovementBoolean_Received.ValueData, FALSE)::Boolean AS isReceived
   INTO vbStatusId, vbUnitIdFrom, vbisDeferred, vbisSUN, vbisDefSUN, vbisSent, vbisReceived
   FROM Movement

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

            LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                      ON MovementBoolean_Deferred.MovementId = Movement.Id
                                     AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()

            LEFT JOIN MovementBoolean AS MovementBoolean_SUN
                                      ON MovementBoolean_SUN.MovementId = Movement.Id
                                     AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()

            LEFT JOIN MovementBoolean AS MovementBoolean_DefSUN
                                      ON MovementBoolean_DefSUN.MovementId = Movement.Id
                                     AND MovementBoolean_DefSUN.DescId = zc_MovementBoolean_DefSUN()

            LEFT JOIN MovementBoolean AS MovementBoolean_Sent
                                      ON MovementBoolean_Sent.MovementId = Movement.Id
                                     AND MovementBoolean_Sent.DescId = zc_MovementBoolean_Sent()

            LEFT JOIN MovementBoolean AS MovementBoolean_Received
                                      ON MovementBoolean_Received.MovementId = Movement.Id
                                     AND MovementBoolean_Received.DescId = zc_MovementBoolean_Received()

   WHERE Movement.Id = inMovementId;

   IF COALESCE(inisReceived, NOT vbisReceived) <> vbisReceived
   THEN
      RAISE EXCEPTION '������. ������� <����������-��> ��� �������. �������� ������ � ��������� ��������� ��������.';
   END IF;

   IF COALESCE (vbStatusId, 0) <> zc_Enum_Status_UnComplete()
   THEN
      RAISE EXCEPTION '������. ��������� ��������� � ������� <%> �� ��������.', lfGet_Object_ValueData (vbStatusId);
   END IF;
   
   IF vbUnitIdFrom <> vbUnitId AND 
      NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
   THEN
      RAISE EXCEPTION '������. ��������� <����������-��> ��������� ������ ���������� ������ �����������.';
   END IF;

   IF inisReceived = FALSE AND (vbisSUN <> TRUE OR vbisDeferred <> TRUE)
   THEN
      RAISE EXCEPTION '������. ��� ��������� <����������-��> �������� ������ ���� � ���������� <����������� �� ���> � <�������>.';
   END IF;

   IF vbisReceived = TRUE
   THEN
      RAISE EXCEPTION '������. ����������� <��������-��> ������ �������� <����������-��> ���������.';
   END IF;

   IF inisReceived = TRUE AND 
      NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
   THEN
      RAISE EXCEPTION '������. ������ �������� <����������-��> ��� ���������, ���������� � ���������� ��������������';
   END IF;

   -- ��������� �������
   PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Sent(), inMovementId, NOT inisSent);

   -- ��������� �������� <���� ��������� �������� ����������>
   PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Sent(), inMovementId, CURRENT_TIMESTAMP);

   -- ��������� ��������
   PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.  ������ �.�.
 06.08.19                                                                      *
*/