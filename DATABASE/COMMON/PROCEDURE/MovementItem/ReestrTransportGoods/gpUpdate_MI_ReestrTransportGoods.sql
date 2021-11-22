-- Function: gpUpdate_MI_ReestrTransportGoods()

DROP FUNCTION IF EXISTS gpUpdate_MI_ReestrTransportGoods (TVarChar, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_ReestrTransportGoods(
    IN inBarCode              TVarChar  , -- �������� ��������� ������� 
    IN inReestrKindId         Integer   , -- ��� ��������� �� �������
    IN inMemberId             Integer   , -- ���������� ����(��������/����������) ��� ���� �������� ��� ����
    IN inSession              TVarChar    -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbMemberId_user Integer;
   DECLARE vbId_mi Integer;
   DECLARE vbId_mi_find Integer;
   DECLARE vbMovementId_TTN Integer;
   DECLARE vbMovementId_reestr Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ReestrTransportGoods());
     

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

     -- ������ ������� �� ����������
     IF CHAR_LENGTH (inBarCode) >= 13
     THEN -- �� ����� ����, �� ��� "��������" ����������� - 4 MONTH
          vbMovementId_TTN:= (SELECT Movement.Id
                                   FROM (SELECT zfConvert_StringToNumber (SUBSTR (inBarCode, 4, 13-4)) AS MovementId
                                         ) AS tmp
                                       INNER JOIN Movement ON Movement.Id = tmp.MovementId
                                                          AND Movement.DescId = zc_Movement_TransportGoods()
                                                          AND Movement.OperDate >= CURRENT_DATE - INTERVAL '4 MONTH'
                                                          AND Movement.StatusId <> zc_Enum_Status_Erased()
                                   );
          -- ���������� ����� - ��� 4 MONTH
          IF COALESCE (vbMovementId_TTN, 0) = 0
          THEN
          vbMovementId_TTN:= (SELECT Movement.Id
                                   FROM (SELECT zfConvert_StringToNumber (SUBSTR (inBarCode, 4, 13-4)) AS MovementId
                                         ) AS tmp
                                       INNER JOIN Movement ON Movement.Id = tmp.MovementId
                                                          AND Movement.DescId = zc_Movement_TransportGoods()
                                                          AND Movement.OperDate BETWEEN CURRENT_DATE - INTERVAL '8 MONTH' AND CURRENT_DATE - INTERVAL '4 MONTH'
                                                          AND Movement.StatusId <> zc_Enum_Status_Erased()
                                   );
          END IF;

          -- ���������� ����� - ��� 4 MONTH
          IF COALESCE (vbMovementId_TTN, 0) = 0
          THEN
          vbMovementId_TTN:= (SELECT Movement.Id
                                   FROM (SELECT zfConvert_StringToNumber (SUBSTR (inBarCode, 4, 13-4)) AS MovementId
                                         ) AS tmp
                                       INNER JOIN Movement ON Movement.Id = tmp.MovementId
                                                          AND Movement.DescId = zc_Movement_TransportGoods()
                                                          AND Movement.OperDate BETWEEN CURRENT_DATE - INTERVAL '12 MONTH' AND CURRENT_DATE - INTERVAL '8 MONTH'
                                                          AND Movement.StatusId <> zc_Enum_Status_Erased()
                                   );
          END IF;

          -- ���������� ����� - ��� 12 MONTH
          IF COALESCE (vbMovementId_TTN, 0) = 0
          THEN
          vbMovementId_TTN:= (SELECT Movement.Id
                                   FROM (SELECT zfConvert_StringToNumber (SUBSTR (inBarCode, 4, 13-4)) AS MovementId
                                         ) AS tmp
                                       INNER JOIN Movement ON Movement.Id = tmp.MovementId
                                                          AND Movement.DescId = zc_Movement_TransportGoods()
                                                          AND Movement.OperDate BETWEEN CURRENT_DATE - INTERVAL '24 MONTH' AND CURRENT_DATE - INTERVAL '12 MONTH'
                                                          AND Movement.StatusId <> zc_Enum_Status_Erased()
                                   );
          END IF;

     ELSE -- �������� - �.�. InvNumber �����������
          IF 1 < (SELECT COUNT(*)
                  FROM Movement
                  WHERE Movement.InvNumber = TRIM (inBarCode)
                    AND Movement.DescId = zc_Movement_TransportGoods()
                    AND Movement.OperDate >= CURRENT_DATE - INTERVAL '4 MONTH'
                    AND Movement.StatusId <> zc_Enum_Status_Erased()
                 )
          THEN
              RAISE EXCEPTION '������.������ ���������� ���������� �� � <%> , �.�. � ����� � ��������� ���������� .', inBarCode;
          END IF;
          -- �� InvNumber, �� ��� �������� ����������� - 4 MONTH
          vbMovementId_TTN:= (SELECT Movement.Id
                                   FROM Movement
                                   WHERE Movement.InvNumber = TRIM (inBarCode)
                                     AND Movement.DescId = zc_Movement_TransportGoods()
                                     AND Movement.OperDate >= CURRENT_DATE - INTERVAL '4 MONTH'
                                     AND Movement.StatusId <> zc_Enum_Status_Erased()
                                  );
     END IF;

     -- ��������
     IF COALESCE (vbMovementId_TTN, 0) = 0
     THEN
         RAISE EXCEPTION '������.�������� <������-������������ ���������> � � <%> �� ������.', inBarCode;
     END IF;

     -- ������ �������
     vbId_mi:= (SELECT MF_MovementItemId.ValueData ::Integer AS Id
                FROM MovementFloat AS MF_MovementItemId 
                WHERE MF_MovementItemId.MovementId = vbMovementId_TTN
                  AND MF_MovementItemId.DescId     = zc_MovementFloat_MovementItemId()
               );

     -- !!!�������!!! ������� - ����� Parent
     IF COALESCE (vbId_mi, 0) = 0
     THEN
         vbId_mi_find:= (SELECT MF_MovementItemId.ValueData :: Integer AS Id
                         FROM MovementFloat AS MF_MovementItemId 
                         WHERE MF_MovementItemId.MovementId = (SELECT Movement.ParentId FROM Movement WHERE Movement.Id = vbMovementId_TTN)
                           AND MF_MovementItemId.DescId     = zc_MovementFloat_MovementItemId()
                        );
         -- ���� Parent ����������
         IF vbId_mi_find > 0
         THEN
              -- ��������� <������� ���������> - <��� ����������� ���� "">
              vbId_mi := lpInsertUpdate_MovementItem (0, zc_MI_Master(), vbMemberId_user, (SELECT MovementItem.MovementId FROM MovementItem WHERE MovementItem.Id = vbId_mi_find), 0, NULL);
              -- ��������� <����� ������������ ���� "">   
              PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), vbId_mi, CURRENT_TIMESTAMP);
              -- ��������� �������� � ��������� �������� <� �������� ����� � ������� ���������>
              PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MovementItemId(), vbMovementId_TTN, vbId_mi);
         END IF;

     END IF;

     -- ��������
     IF COALESCE (vbId_mi, 0) = 0
     THEN
         -- RAISE EXCEPTION '������..', inBarCode;
         --
         -- ��������� ����� "��������"
         vbMovementId_reestr:= (SELECT Movement.Id
                                FROM Movement
                                     LEFT JOIN MovementLinkObject AS ML�
                                                                  ON ML�.MovementId = Movement.Id 
                                                                 AND ML�.DescId = zc_MovementLinkObject_Insert()
                                                                -- AND ML�.ObjectId = vbUserId
                                WHERE Movement.OperDate = CURRENT_DATE
                                  AND Movement.DescId = zc_Movement_ReestrTransportGoods()
                                  AND Movement.StatusId <> zc_Enum_Status_Erased()
                                  AND ML�.MovementId IS NULL
                                LIMIT 1 -- ��������� ��� "�����" ������ ������� ���� ����� ������������ �������� ����� ���.
                               );

         -- ���� �� ����� "��������"
         IF COALESCE (vbMovementId_reestr, 0) = 0
         THEN
             -- �������
             vbMovementId_reestr:=
              lpInsertUpdate_Movement_ReestrTransportGoods (ioId               := COALESCE (vbMovementId_reestr, 0)
                                                  , inInvNumber        := NEXTVAL ('Movement_ReestrTransportGoods_seq') :: TVarChar
                                                  , inOperDate         := CURRENT_DATE
                                                  , inUserId           := -1 * vbUserId -- !!! � �������, ������ "��������"!!!
                                                   );
         END IF;

         -- ��������� <������� ���������> - �� "�����" <��� ����������� ���� "�������� �� ������">
         vbId_mi := lpInsertUpdate_MovementItem (vbId_mi, zc_MI_Master(), vbMemberId_user, vbMovementId_reestr, 0, NULL);

         -- ��������� �������� � ��������� ��� <� �������� ����� � ������� ���������>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MovementItemId(), vbMovementId_TTN, vbId_mi);

     END IF; -- if COALESCE (vbId_mi, 0) = 0

    -- <����� ���������>
    IF inReestrKindId = zc_Enum_ReestrKind_Log()
    THEN 
       -- ��������� <����� ������������ ����>
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Log(), vbId_mi, CURRENT_TIMESTAMP);
       -- ��������� ����� � <��� ����������� ����>
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Log(), vbId_mi, vbMemberId_user);
    END IF;
    
    -- <�������� �� �������>
    IF inReestrKindId = zc_Enum_ReestrKind_PartnerIn()
    THEN 
       -- ��������� <����� ������������ ����>
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartnerIn(), vbId_mi, CURRENT_TIMESTAMP);
       -- ��������� ����� � <��� ����������� ����>
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartnerInTo(), vbId_mi, vbMemberId_user);
    END IF;

    -- <�������� ��� ���������>
    IF inReestrKindId = zc_Enum_ReestrKind_RemakeIn()
    THEN 
       -- ��������� <����� ������������ ����>
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_RemakeIn(), vbId_mi, CURRENT_TIMESTAMP);
       -- ��������� ����� � <��� ����������� ����>
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_RemakeInTo(), vbId_mi, vbMemberId_user);
       -- ��������� ����� � <��� ���� �������� ��� ���� "�������� ��� ���������">
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_RemakeInFrom(), vbId_mi, inMemberId);
    END IF;
    

    -- <����������� ��� �����������>
    IF inReestrKindId = zc_Enum_ReestrKind_RemakeBuh()
    THEN 
       -- ��������� <����� ������������ ����>
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_RemakeBuh(), vbId_mi, CURRENT_TIMESTAMP);
       -- ��������� ����� � <��� ����������� ����>
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_RemakeBuh(), vbId_mi, vbMemberId_user);
    END IF;


    -- <�������� ���������>
    IF inReestrKindId = zc_Enum_ReestrKind_Remake()
    THEN 
       -- ��������� <����� ������������ ����>
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Remake(), vbId_mi, CURRENT_TIMESTAMP);
       -- ��������� ����� � <��� ����������� ����>
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Remake(), vbId_mi, vbMemberId_user);
    END IF;


    -- <�����������>
    IF inReestrKindId = zc_Enum_ReestrKind_Buh()
    THEN 
       -- ��������� <����� ������������ ����>
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Buh(), vbId_mi, CURRENT_TIMESTAMP);
       -- ��������� ����� � <��� ����������� ����>
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Buh(), vbId_mi, vbMemberId_user);
    END IF;

    -- ���������� "���������" �������� ���� - <��������� �� �������>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ReestrKind(), vbMovementId_TTN, inReestrKindId);

    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (vbId_mi, vbUserId, FALSE);

    /*IF vbUserId = 5
    THEN
        RAISE EXCEPTION '��������� ������ :)';
    END IF;
*/

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.07.20         *
 01.02.20         *
*/

-- ����
-- SELECT * FROM gpUpdate_MI_ReestrTransportGoods (inBarCode:= '4323306', inOperDate:= '23.10.2016', inCarId:= 340655, inPersonalDriverId:= 0, inMemberId:= 0, inDocumentId_Transport:= 2298218, inSession:= '5');
