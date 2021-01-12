-- Function: gpUpdate_MI_ReestrReturnOut()

DROP FUNCTION IF EXISTS gpUpdate_MI_ReestrReturnOut (TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_ReestrReturnOut(
    IN inBarCode              TVarChar  , -- �������� ��������� ������� 
    IN inReestrKindId         Integer   , -- ��� ��������� �� �������
    --IN inMemberId             Integer   , -- ���������� ����(��������/����������) ��� ���� �������� ��� ����
    IN inSession              TVarChar    -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbMemberId_user Integer;
   DECLARE vbId_mi Integer;
   DECLARE vbMovementId_ReturnOut Integer;
   DECLARE vbMovementId_ReestrReturnOut Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ReestrReturnOut());
     

     -- ������ � ���� ������ - ������ �� ������, �.�. �� ������ ���������� "������" ���
     IF COALESCE (TRIM (inBarCode), '') = ''
     THEN
         RETURN; -- !!!�����!!!
     END IF;


     -- ���� 
     IF NOT EXISTS (SELECT 1 FROM Object WHERE Object.Id = inReestrKindId AND Object.DescId = zc_Object_ReestrKind())
     THEN
          RAISE EXCEPTION '������.zc_Object_ReestrKind = <%> �� ��������� ��������.', lfGet_Object_ValueData (inReestrKindId);
     END IF;


     -- ������������ <���������� ����> - ��� ����������� ���� inReestrKindId
     vbMemberId_user:= CASE WHEN vbUserId = 5 THEN 9457 ELSE
                       (SELECT ObjectLink_User_Member.ChildObjectId
                        FROM ObjectLink AS ObjectLink_User_Member
                        WHERE ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                          AND ObjectLink_User_Member.ObjectId = vbUserId)
                       END
                      ;
     -- ��������
     IF COALESCE (vbMemberId_user, 0) = 0
     THEN 
          RAISE EXCEPTION '������.� ������������ <%> �� ��������� �������� <���.����>.', lfGet_Object_ValueData (vbUserId);
     END IF;


     -- ��������
  /*   IF inMemberId = 0 AND inReestrKindId IN (zc_Enum_ReestrKind_PartnerIn(), zc_Enum_ReestrKind_RemakeIn())
     THEN
         -- ������ ���� ��� ���� �������� ��� ����
         RAISE EXCEPTION '������.��� ���� <%> �� ��������� <���������� / �������� (�� ���� �������� ���������)>.', lfGet_Object_ValueData (inReestrKindId);
     ELSEIF inMemberId <> 0 AND inReestrKindId NOT IN (zc_Enum_ReestrKind_PartnerIn(), zc_Enum_ReestrKind_RemakeIn())
     THEN
         -- �� ������ ���� ��� ���� �������� ��� ����
         RAISE EXCEPTION '������.��� ���� <%> �������� <���������� / �������� (�� ���� �������� ���������)> ������ ���� ������.', lfGet_Object_ValueData (inReestrKindId);
     END IF;
*/

     -- ������ ������� ����������
     IF CHAR_LENGTH (inBarCode) >= 13
     THEN -- �� ����� ����, �� ��� "��������" ����������� - 4 MONTH
          vbMovementId_ReturnOut:= (SELECT Movement.Id
                                 FROM (SELECT zfConvert_StringToNumber (SUBSTR (inBarCode, 4, 13-4)) AS MovementId
                                      ) AS tmp
                                      INNER JOIN Movement ON Movement.Id     = tmp.MovementId
                                                         AND Movement.DescId IN (zc_Movement_ReturnOut(), zc_Movement_ReturnOut())
                                                         AND Movement.OperDate >= CURRENT_DATE - INTERVAL '4 MONTH'
                                                         AND Movement.StatusId <> zc_Enum_Status_Erased()
                                );
     ELSE -- �� InvNumber, �� ��� �������� ����������� - 4 MONTH
          vbMovementId_ReturnOut:= (SELECT Movement.Id
                                 FROM Movement
                                 WHERE Movement.InvNumber = TRIM (inBarCode)
                                   AND Movement.DescId    IN (zc_Movement_ReturnOut(), zc_Movement_ReturnOut())
                                   AND Movement.OperDate >= CURRENT_DATE - INTERVAL '4 MONTH'
                                   AND Movement.StatusId <> zc_Enum_Status_Erased()
                                );
     END IF;

     -- ��������
     IF COALESCE (vbMovementId_ReturnOut, 0) = 0
     THEN
         RAISE EXCEPTION '������.�������� <������> � � <%> �� ������.', inBarCode;
     END IF;

     -- ������ �������
     vbId_mi:= (SELECT MF_MovementItemId.ValueData ::Integer AS Id
                FROM MovementFloat AS MF_MovementItemId 
                WHERE MF_MovementItemId.MovementId = vbMovementId_ReturnOut
                  AND MF_MovementItemId.DescId     = zc_MovementFloat_MovementItemId()
               );
     -- ��������
     IF COALESCE (vbId_mi, 0) = 0
     THEN
         -- RAISE EXCEPTION '������.�������� <������> � � <%> �� ��������������� � �������.', inBarCode;
         --
         -- ��������� ����� "��������"
         vbMovementId_ReestrReturnOut:= (SELECT Movement.Id
                                      FROM Movement
                                           LEFT JOIN MovementLinkMovement AS MLM_Transport
                                                                          ON MLM_Transport.MovementId = Movement.Id
                                                                         AND MLM_Transport.DescId = zc_MovementLinkMovement_Transport()
                                      WHERE Movement.OperDate = CURRENT_DATE
                                        AND Movement.DescId = zc_Movement_ReestrReturnOut()
                                        AND Movement.StatusId <> zc_Enum_Status_Erased()
                                        AND MLM_Transport.MovementId IS NULL
                                      LIMIT 1 -- ��������� ��� "�����" ������ ������� ���� ����� ������������ �������� ����� ���.
                                     );

         -- ���� �� ����� "��������"
         IF COALESCE (vbMovementId_ReestrReturnOut, 0) = 0
         THEN
             -- �������
             vbMovementId_ReestrReturnOut:=
                    lpInsertUpdate_Movement_ReestrReturnOut (ioId               := vbMovementId_ReestrReturnOut
                                                        , inInvNumber        := NEXTVAL ('Movement_ReestrReturnOut_seq') :: TVarChar
                                                        , inOperDate         := CURRENT_DATE
                                                        , inCarId            := NULL
                                                        , inPersonalDriverId := NULL
                                                        , inMemberId         := NULL
                                                        , inMovementId_Transport := NULL
                                                        , inUserId           := -1 * vbUserId -- !!! � �������, ������ "��������"!!!
                                                         );
         END IF;

         -- ��������� <������� ���������> - �� "�����" <��� ����������� ���� "�������� �� ������">
         vbId_mi := lpInsertUpdate_MovementItem (vbId_mi, zc_MI_Master(), vbMemberId_user, vbMovementId_ReestrReturnOut, 0, NULL);

         -- ��������� �������� � ��������� ������� <� �������� ����� � ������� ���������>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MovementItemId(), vbMovementId_ReturnOut, vbId_mi);

     END IF; -- if COALESCE (vbId_mi, 0) = 0


    -- <�������� �� �������>
    IF inReestrKindId = zc_Enum_ReestrKind_PartnerIn()
    THEN 
       -- ��������� <����� ������������ ����>
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartnerIn(), vbId_mi, CURRENT_TIMESTAMP);
       -- ��������� ����� � <��� ����������� ����>
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartnerInTo(), vbId_mi, vbMemberId_user);
       -- ��������� ����� � <��� ���� �������� ��� ���� "�������� �� �������">
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartnerInFrom(), vbId_mi, NULL);
    END IF;
 

    -- <"����������(� ������)>
    IF inReestrKindId = zc_Enum_ReestrKind_EconomIn()
    THEN 
       -- ��������� <����� ������������ ����>
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_EconomIn(), vbId_mi, CURRENT_TIMESTAMP);
       -- ��������� ����� � <��� ����������� ����>
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_EconomIn(), vbId_mi, vbMemberId_user);
    END IF;
    

    -- <����������(��� ���������)>
    IF inReestrKindId = zc_Enum_ReestrKind_EconomOut()
    THEN 
       -- ��������� <����� ������������ ����>
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_EconomOut(), vbId_mi, CURRENT_TIMESTAMP);
       -- ��������� ����� � <��� ����������� ����>
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_EconomOut(), vbId_mi, vbMemberId_user);
    END IF;

    -- <�������� ���������>
    IF inReestrKindId = zc_Enum_ReestrKind_Remake()
    THEN 
       -- ��������� <����� ������������ ����>
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Remake(), vbId_mi, CURRENT_TIMESTAMP);
       -- ��������� ����� � <��� ����������� ����>
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Remake(), vbId_mi, vbMemberId_user);
    END IF;

    -- <����������>
    IF inReestrKindId = zc_Enum_ReestrKind_Econom()
    THEN 
       -- ��������� <����� ������������ ����>
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Econom(), vbId_mi, CURRENT_TIMESTAMP);
       -- ��������� ����� � <��� ����������� ����>
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Econom(), vbId_mi, vbMemberId_user);
    END IF;

    -- <�����������>
    IF inReestrKindId = zc_Enum_ReestrKind_Buh()
    THEN 
       -- ��������� <����� ������������ ����>
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Buh(), vbId_mi, CURRENT_TIMESTAMP);
       -- ��������� ����� � <��� ����������� ����>
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Buh(), vbId_mi, vbMemberId_user);
    END IF;

    -- <��������� (� ������)>
    IF inReestrKindId = zc_Enum_ReestrKind_Snab()
    THEN 
       -- ��������� <����� ������������ ����>
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Snab(), vbId_mi, CURRENT_TIMESTAMP);
       -- ��������� ����� � <��� ����������� ����>
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Snab(), vbId_mi, vbMemberId_user);
    END IF;

    -- <��������� (��� ���������)>
    IF inReestrKindId = zc_Enum_ReestrKind_SnabRe()
    THEN 
       -- ��������� <����� ������������ ����>
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_SnabRe(), vbId_mi, CURRENT_TIMESTAMP);
       -- ��������� ����� � <��� ����������� ����>
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_SnabRe(), vbId_mi, vbMemberId_user);
    END IF;


    -- ���������� "���������" �������� ���� - <��������� �� �������>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ReestrKind(), vbMovementId_ReturnOut, inReestrKindId);

    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (vbId_mi, vbUserId, FALSE);

    IF inSession = '5'
    THEN
        RAISE EXCEPTION '��������� ������ :)';
    END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.01.21         *
*/

-- ����
-- 