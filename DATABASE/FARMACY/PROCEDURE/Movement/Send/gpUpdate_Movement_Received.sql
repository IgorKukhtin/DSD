-- Function: gpUpdate_Movement_Received()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Received(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Received(
    IN inMovementId          Integer   ,    -- ���� ���������
    IN inisReceived          Boolean   ,    -- ��������-��
   OUT outisReceived         Boolean   ,    -- ��������-��
    IN inSession             TVarChar       -- ������� ������������
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbUnitId     Integer;
   DECLARE vbUnitKey    TVarChar;
   DECLARE vbStatusId   Integer;
   DECLARE vbUnitIdTo   Integer;
   DECLARE vbisDeferred Boolean;
   DECLARE vbisSUN      Boolean;
   DECLARE vbisDefSUN   Boolean;
   DECLARE vbisSent     Boolean;
   DECLARE vbisReceived Boolean;
   DECLARE vbNumberSeats Integer;
   DECLARE vbisVIP       Boolean;
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

   SELECT Movement.StatusId, MovementLinkObject_To.ObjectId
        , COALESCE (MovementBoolean_Deferred.ValueData, FALSE)::Boolean AS isDeferred
        , COALESCE (MovementBoolean_SUN.ValueData, FALSE)     ::Boolean AS isSUN
        , COALESCE (MovementBoolean_DefSUN.ValueData, FALSE)  ::Boolean AS isDefSUN
        , COALESCE (MovementBoolean_Sent.ValueData, FALSE)::Boolean     AS isSent
        , COALESCE (MovementBoolean_Received.ValueData, FALSE)::Boolean AS isReceived
        , MovementFloat_NumberSeats.ValueData::Integer                  AS NumberSeats
        , COALESCE (MovementBoolean_VIP.ValueData, FALSE)        ::Boolean AS isVIP
   INTO vbStatusId, vbUnitIdTo, vbisDeferred, vbisSUN, vbisDefSUN, vbisSent, vbisReceived, vbNumberSeats, vbisVIP
   FROM Movement

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

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

            LEFT JOIN MovementFloat AS MovementFloat_NumberSeats
                                    ON MovementFloat_NumberSeats.MovementId =  Movement.Id
                                   AND MovementFloat_NumberSeats.DescId = zc_MovementFloat_NumberSeats()

            LEFT JOIN MovementBoolean AS MovementBoolean_VIP
                                      ON MovementBoolean_VIP.MovementId = Movement.Id
                                     AND MovementBoolean_VIP.DescId = zc_MovementBoolean_VIP()

   WHERE Movement.Id = inMovementId;

   IF COALESCE(inisReceived, NOT vbisReceived) <> vbisReceived
   THEN
      RAISE EXCEPTION '������. ������� <��������-��> ��� �������. �������� ������ � ��������� ��������� ��������.';
   END IF;

   IF COALESCE (vbStatusId, 0) <> zc_Enum_Status_UnComplete()
   THEN
      RAISE EXCEPTION '������. ��������� ��������� � ������� <%> �� ��������.', lfGet_Object_ValueData (vbStatusId);
   END IF;
   
   IF vbUnitIdTo <> vbUnitId AND 
      NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
   THEN
      RAISE EXCEPTION '������. ��������� <��������-��> ��������� ������ ���������� ������ ����������.';
   END IF;

   IF inisReceived = FALSE AND (vbisSUN <> TRUE AND vbisVIP <> TRUE OR vbisDeferred <> TRUE OR vbisSent <> TRUE)
   THEN
      RAISE EXCEPTION '������. ��� ��������� <��������-��> �������� ������ ���� � ���������� <����������� �� ���> ��� <����������� �� VIP>, <�������> � <����������-��>.';
   END IF;

   IF inisReceived = TRUE AND 
      NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
   THEN
      RAISE EXCEPTION '������. ������ �������� <��������-��> ��� ���������, ���������� � ���������� ��������������';
   END IF;

   IF inisReceived = FALSE AND COALESCE (vbNumberSeats, 0) = 0 AND CURRENT_DATE >= '11.03.2020'::TDateTime
   THEN
      RAISE EXCEPTION '������. �� ��������� <���������� ����>';
   END IF;

   -- ��������� �������
   PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Received(), inMovementId, NOT inisReceived);

   -- ��������� ��������
   PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);
   
   outisReceived := not inisReceived;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.  ������ �.�.
 12.10.19                                                                      *
 06.08.19                                                                      *
*/