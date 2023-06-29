-- Function: gpUpdate_MI_Reestr()

DROP FUNCTION IF EXISTS gpUpdate_MI_Reestr (TVarChar, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_Reestr(
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
   DECLARE vbMovementId_sale Integer;
   DECLARE vbMovementId_reestr Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Reestr());
     

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
     IF inMemberId = 0 AND inReestrKindId IN (zc_Enum_ReestrKind_PartnerIn(), zc_Enum_ReestrKind_RemakeIn())
     THEN
         -- ������ ���� ��� ���� �������� ��� ����
         RAISE EXCEPTION '������.��� ���� <%> �� ��������� <���������� / �������� (�� ���� �������� ���������)>.', lfGet_Object_ValueData (inReestrKindId);
     ELSEIF inMemberId <> 0 AND inReestrKindId NOT IN (zc_Enum_ReestrKind_PartnerIn(), zc_Enum_ReestrKind_RemakeIn())
     THEN
         -- �� ������ ���� ��� ���� �������� ��� ����
         RAISE EXCEPTION '������.��� ���� <%> �������� <���������� / �������� (�� ���� �������� ���������)> ������ ���� ������.', lfGet_Object_ValueData (inReestrKindId);
     END IF;


     -- 1. ������ ������� ����������
     IF CHAR_LENGTH (inBarCode) >= 13
     THEN -- �� ����� ����, �� ��� "��������" ����������� - 4 MONTH
          vbMovementId_sale:= (SELECT Movement.Id
                               FROM (SELECT zfConvert_StringToNumber (SUBSTR (inBarCode, 4, 13-4)) AS MovementId
                                    ) AS tmp
                                    INNER JOIN Movement ON Movement.Id     = tmp.MovementId
                                                       AND Movement.DescId IN (zc_Movement_Sale(), zc_Movement_SendOnPrice())
                                                       AND Movement.OperDate >= CURRENT_DATE - INTERVAL '12 MONTH'
                                                       AND Movement.StatusId <> zc_Enum_Status_Erased()
                              );
          -- ���������� ����� - ��� 12 MONTH
          IF COALESCE (vbMovementId_sale, 0) = 0
          THEN -- �� ����� ����, �� ��� "��������" ����������� - 4 MONTH
               vbMovementId_sale:= (SELECT Movement.Id
                                    FROM (SELECT zfConvert_StringToNumber (SUBSTR (inBarCode, 4, 13-4)) AS MovementId
                                         ) AS tmp
                                         INNER JOIN Movement ON Movement.Id     = tmp.MovementId
                                                            AND Movement.DescId IN (zc_Movement_Sale(), zc_Movement_SendOnPrice())
                                                            AND Movement.OperDate BETWEEN CURRENT_DATE - INTERVAL '24 MONTH' AND CURRENT_DATE - INTERVAL '12 MONTH'
                                                            AND Movement.StatusId <> zc_Enum_Status_Erased()
                                   );
          END IF;

     ELSE -- �� InvNumber, �� ��� �������� ����������� - 12 MONTH
          vbMovementId_sale:= (SELECT Movement.Id
                               FROM Movement
                               WHERE Movement.InvNumber = TRIM (inBarCode)
                                 AND Movement.DescId    IN (zc_Movement_Sale(), zc_Movement_SendOnPrice())
                                 AND Movement.OperDate >= CURRENT_DATE - INTERVAL '12 MONTH'
                                 AND Movement.StatusId <> zc_Enum_Status_Erased()
                              );
          -- ���������� ����� - ��� 12 MONTH
          IF COALESCE (vbMovementId_sale, 0) = 0
          THEN -- �� ����� ����, �� ��� "��������" ����������� - 12 MONTH
               vbMovementId_sale:= (SELECT Movement.Id
                                    FROM Movement
                                    WHERE Movement.InvNumber = TRIM (inBarCode)
                                      AND Movement.DescId    IN (zc_Movement_Sale(), zc_Movement_SendOnPrice())
                                      AND Movement.OperDate BETWEEN CURRENT_DATE - INTERVAL '24 MONTH' AND CURRENT_DATE - INTERVAL '12 MONTH'
                                      AND Movement.StatusId <> zc_Enum_Status_Erased()
                                   );
          END IF;
     END IF;

     -- 2. ������ ������� ����������
     IF CHAR_LENGTH (inBarCode) >= 13 AND COALESCE (vbMovementId_sale, 0) = 0
     THEN -- �� ����� ����, �� ��� "��������" ����������� - 4 MONTH
          vbMovementId_sale:= (SELECT Movement.Id
                               FROM (SELECT zfConvert_StringToNumber (SUBSTR (inBarCode, 4, 13-4)) AS MovementId
                                    ) AS tmp
                                    INNER JOIN Movement ON Movement.Id     = tmp.MovementId
                                                       AND Movement.DescId IN (zc_Movement_Sale(), zc_Movement_SendOnPrice())
                                                       AND Movement.OperDate >= CURRENT_DATE - INTERVAL '24 MONTH'
                                                       AND Movement.StatusId <> zc_Enum_Status_Erased()
                              );
     ELSEIF COALESCE (vbMovementId_sale, 0) = 0
     THEN -- �� InvNumber, �� ��� �������� ����������� - 4 MONTH
          vbMovementId_sale:= (SELECT Movement.Id
                               FROM Movement
                               WHERE Movement.InvNumber = TRIM (inBarCode)
                                 AND Movement.DescId    IN (zc_Movement_Sale(), zc_Movement_SendOnPrice())
                                 AND Movement.OperDate >= CURRENT_DATE - INTERVAL '24 MONTH'
                                 AND Movement.StatusId <> zc_Enum_Status_Erased()
                              );
     END IF;


     -- ��������
     IF COALESCE (vbMovementId_sale, 0) = 0
     THEN
         IF CHAR_LENGTH (inBarCode) >= 13 AND EXISTS (SELECT Movement.Id
                                                      FROM (SELECT zfConvert_StringToNumber (SUBSTR (inBarCode, 4, 13-4)) AS MovementId
                                                           ) AS tmp
                                                           INNER JOIN Movement ON Movement.Id     = tmp.MovementId
                                                                              AND Movement.DescId IN (zc_Movement_Sale(), zc_Movement_SendOnPrice())
                                                                              AND Movement.OperDate >= CURRENT_DATE - INTERVAL '24 MONTH'
                                                                              AND Movement.StatusId = zc_Enum_Status_Erased()
                                                     )
         THEN
             RAISE EXCEPTION '������.�������� <������� ����������> � <%> �� <%> ������.(%)'
                           , inBarCode
                           , (SELECT Movement.InvNumber
                              FROM (SELECT zfConvert_StringToNumber (SUBSTR (inBarCode, 4, 13-4)) AS MovementId
                                   ) AS tmp
                                   INNER JOIN Movement ON Movement.Id     = tmp.MovementId
                                                      AND Movement.DescId IN (zc_Movement_Sale(), zc_Movement_SendOnPrice())
                                                      AND Movement.OperDate >= CURRENT_DATE - INTERVAL '24 MONTH'
                                                      AND Movement.StatusId = zc_Enum_Status_Erased()
                              ORDER BY Movement.OperDate DESC
                              LIMIT 1
                             )
                           , (SELECT zfConvert_DateToString (Movement.OperDate)
                              FROM (SELECT zfConvert_StringToNumber (SUBSTR (inBarCode, 4, 13-4)) AS MovementId
                                   ) AS tmp
                                   INNER JOIN Movement ON Movement.Id     = tmp.MovementId
                                                      AND Movement.DescId IN (zc_Movement_Sale(), zc_Movement_SendOnPrice())
                                                      AND Movement.OperDate >= CURRENT_DATE - INTERVAL '24 MONTH'
                                                      AND Movement.StatusId = zc_Enum_Status_Erased()
                              ORDER BY Movement.OperDate DESC
                              LIMIT 1
                             )
                            ;
         ELSE
             RAISE EXCEPTION '������.�������� <������� ����������> � �/� = <%> �� ������.', inBarCode;
         END IF;

     END IF;

     -- ������ �������
     vbId_mi:= (SELECT MF_MovementItemId.ValueData ::Integer AS Id
                FROM MovementFloat AS MF_MovementItemId 
                WHERE MF_MovementItemId.MovementId = vbMovementId_sale
                  AND MF_MovementItemId.DescId     = zc_MovementFloat_MovementItemId()
               );
     -- ��������
     IF COALESCE (vbId_mi, 0) = 0
     THEN
         -- RAISE EXCEPTION '������.�������� <������� ����������> � � <%> �� ��������������� � �������.', inBarCode;
         --
         -- ��������� ����� "��������"
         vbMovementId_reestr:= (SELECT Movement.Id
                                FROM Movement
                                     LEFT JOIN MovementLinkMovement AS MLM_Transport
                                                                    ON MLM_Transport.MovementId = Movement.Id
                                                                   AND MLM_Transport.DescId = zc_MovementLinkMovement_Transport()
                                WHERE Movement.OperDate = CURRENT_DATE
                                  AND Movement.DescId = zc_Movement_Reestr()
                                  AND Movement.StatusId <> zc_Enum_Status_Erased()
                                  AND MLM_Transport.MovementId IS NULL
                                LIMIT 1 -- ��������� ��� "�����" ������ ������� ���� ����� ������������ �������� ����� ���.
                               );

         -- ���� �� ����� "��������"
         IF COALESCE (vbMovementId_reestr, 0) = 0
         THEN
             -- �������
             vbMovementId_reestr:=
                    lpInsertUpdate_Movement_Reestr (ioId               := vbMovementId_reestr
                                                  , inInvNumber        := NEXTVAL ('Movement_Reestr_seq') :: TVarChar
                                                  , inOperDate         := CURRENT_DATE
                                                  , inCarId            := NULL
                                                  , inPersonalDriverId := NULL
                                                  , inMemberId         := NULL
                                                  , inMovementId_Transport := NULL
                                                  , inUserId           := -1 * vbUserId -- !!! � �������, ������ "��������"!!!
                                                   );
         END IF;

         -- ��������� <������� ���������> - �� "�����" <��� ����������� ���� "�������� �� ������">
         vbId_mi := lpInsertUpdate_MovementItem (vbId_mi, zc_MI_Master(), vbMemberId_user, vbMovementId_reestr, 0, NULL);

         -- ��������� �������� � ��������� ������� <� �������� ����� � ������� ���������>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MovementItemId(), vbMovementId_sale, vbId_mi);

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
       -- ��������� ����� � <��� ���� �������� ��� ���� "�������� �� �������">
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartnerInFrom(), vbId_mi, inMemberId);
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

    -- <������� �������>
    IF inReestrKindId = zc_Enum_ReestrKind_TransferIn()
    THEN 
       -- ��������� <����� ������������ ����>
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_TransferIn(), vbId_mi, CURRENT_TIMESTAMP);
       -- ��������� ����� � <��� ����������� ����>
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_TransferIn(), vbId_mi, vbMemberId_user);
    END IF;

    -- <������� ���������>
    IF inReestrKindId = zc_Enum_ReestrKind_TransferOut()
    THEN 
       -- ��������� <����� ������������ ����>
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_TransferOut(), vbId_mi, CURRENT_TIMESTAMP);
       -- ��������� ����� � <��� ����������� ����>
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_TransferOut(), vbId_mi, vbMemberId_user);
    END IF;

    -- <������� ��������>
    IF inReestrKindId = zc_Enum_ReestrKind_Double()
    THEN 
       -- ��������� <����� ������������ ����>
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Double(), vbId_mi, CURRENT_TIMESTAMP);
       -- ��������� ����� � <��� ����������� ����>
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Double(), vbId_mi, vbMemberId_user);
    END IF;

    -- <� ������� ����>
    IF inReestrKindId = zc_Enum_ReestrKind_Scan()
    THEN 
       -- ��������� <����� ������������ ����>
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Scan(), vbId_mi, CURRENT_TIMESTAMP);
       -- ��������� ����� � <��� ����������� ����>
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Scan(), vbId_mi, vbMemberId_user);
    END IF;

    -- ���������� "���������" �������� ���� - <��������� �� �������>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ReestrKind(), vbMovementId_sale, inReestrKindId);

    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (vbId_mi, vbUserId, FALSE);

    IF vbUserId = '5'
    THEN
        RAISE EXCEPTION '��������� ������ :)';
    END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 05.05.22         *
 17.11.20         *
 22.07.20         *
 20.07.17         *
 23.10.16         *
*/

-- ����
-- SELECT * FROM gpUpdate_MI_Reestr (inBarCode:= '4323306', inOperDate:= '23.10.2016', inCarId:= 340655, inPersonalDriverId:= 0, inMemberId:= 0, inDocumentId_Transport:= 2298218, inSession:= '5');
