-- Function: gpInsertUpdate_MI_ReestrIncomeStart()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ReestrIncomeStart (Integer, TDateTime, Integer, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ReestrIncomeStart (Integer, TDateTime, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_ReestrIncomeStart(
 INOUT ioMovementId               Integer   , -- ���� ������� <��������>
    IN inOperDate                 TDateTime , -- ���� ���������
    IN inBarCode                  TVarChar  , -- �/� ��������� <������>
    IN inSession                  TVarChar    -- ������ ������������
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbIsFindOnly      Boolean;
   DECLARE vbIsInsert        Boolean;
   DECLARE vbId_mi           Integer;
   DECLARE vbMovementId_Income Integer;
   DECLARE vbMemberId        Integer; -- <���������� ����> - ��� ����������� ���� "�������� �� ������"
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ReestrIncome());
     
     -- ������������ ��� ��� ����� Find ioMovementId, � ���� �� �����, ����� ����� Insert
     vbIsFindOnly:= COALESCE (ioMovementId, 0) = 0 AND TRIM (inBarCode) = '';


     -- ���� �������� ������� ���� - ����� ����� Find !!!������!!! ioMovementId
     IF ioMovementId > 0 AND NOT EXISTS (SELECT 1 FROM MovementLinkObject AS ML� WHERE ML�.MovementId = ioMovementId AND ML�.DescId = zc_MovementLinkObject_Insert())
     THEN
         ioMovementId:= 0;
         vbIsFindOnly:= TRUE;
     END IF;


     -- ������ �������� <������ ���������>
     IF COALESCE (ioMovementId, 0) = 0
     THEN
          ioMovementId:= COALESCE ((SELECT ML�.MovementId
                                    FROM MovementLinkObject AS ML�
                                         INNER JOIN Movement ON Movement.Id       = ML�.MovementId
                                                            AND Movement.DescId   = zc_Movement_ReestrIncome()
                                                            AND Movement.StatusId = zc_Enum_Status_Erased()
                                                            AND Movement.OperDate = inoperdate
                                    WHERE ML�.ObjectId = vbUserId
                                      AND ML�.DescId = zc_MovementLinkObject_Insert()
                                   ), 0);
          -- �����, �� ���� �� ����� - ������� Insert
          IF ioMovementId = 0
          THEN
              vbIsFindOnly:= FALSE;
          END IF;
     END IF;


     -- ������ ������
     IF TRIM (inBarCode) <> ''
     THEN
         IF CHAR_LENGTH (inBarCode) >= 13
         THEN -- �� ����� ����, �� ��� "��������" ����������� - 33 DAY
              vbMovementId_Income:= (SELECT Movement.Id
                                     FROM (SELECT zfConvert_StringToNumber (SUBSTR (inBarCode, 4, 13-4)) AS MovementId
                                          ) AS tmp
                                          INNER JOIN Movement ON Movement.Id = tmp.MovementId
                                                             AND Movement.DescId IN (zc_Movement_Income(), zc_Movement_ReturnOut())
                                                             AND Movement.OperDate BETWEEN CURRENT_DATE - INTERVAL '270 DAY' AND CURRENT_DATE + INTERVAL '8 DAY'
                                                             AND Movement.StatusId <> zc_Enum_Status_Erased()
                                    );
         ELSE -- �� InvNumber, �� ��� �������� ����������� - 8 DAY
              vbMovementId_Income:= (SELECT Movement.Id
                                     FROM Movement
                                     WHERE Movement.InvNumber = TRIM (inBarCode)
                                       AND Movement.DescId    IN (zc_Movement_Income(), zc_Movement_ReturnOut())
                                       AND Movement.OperDate BETWEEN CURRENT_DATE - INTERVAL '70 DAY' AND CURRENT_DATE + INTERVAL '8 DAY'
                                       AND Movement.StatusId <> zc_Enum_Status_Erased()
                                    );
         END IF;

         -- ��������
         IF COALESCE (vbMovementId_Income, 0) = 0
         THEN
             RAISE EXCEPTION '������.�������� <������ �� ����������> � � <%> �� ������.', inBarCode;
         END IF;

         -- ��������
         IF EXISTS (SELECT Object_Route.ValueData
                    FROM MovementLinkMovement AS MLM_Order
                         LEFT JOIN MovementLinkObject AS MLO_Route
                                                      ON MLO_Route.MovementId = MLM_Order.MovementChildId
                                                     AND MLO_Route.DescId     = zc_MovementLinkObject_Route()
                         LEFT JOIN Object AS Object_Route ON Object_Route.Id = MLO_Route.ObjectId
                    WHERE MLM_Order.MovementId = vbMovementId_Income
                      AND MLM_Order.DescId     = zc_MovementLinkMovement_Order()
                      AND Object_Route.ValueData ILIKE '%���������%'
                   )
         THEN
             RAISE EXCEPTION '������.�������� <������ �� ����������> � <%> �� <%> �������� � �������� <%>.���������� � ������ ���������.'
                           , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = vbMovementId_Income)
                           , zfConvert_DateToString ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = vbMovementId_Income))
                           , (SELECT Object_Route.ValueData
                              FROM MovementLinkMovement AS MLM_Order
                                   LEFT JOIN MovementLinkObject AS MLO_Route
                                                                ON MLO_Route.MovementId = MLM_Order.MovementChildId
                                                               AND MLO_Route.DescId     = zc_MovementLinkObject_Route()
                                   LEFT JOIN Object AS Object_Route ON Object_Route.Id = MLO_Route.ObjectId
                              WHERE MLM_Order.MovementId = vbMovementId_Income
                                AND MLM_Order.DescId     = zc_MovementLinkMovement_Order()
                                AND Object_Route.ValueData ILIKE '%���������%'
                             )
                           ;
         END IF;

     END IF;


     -- ������ � ���� ������ - ������ �� ������
     IF vbIsFindOnly                   = TRUE
     THEN
         RETURN; -- !!!�����!!!
     END IF;


     -- ������ - ���������� Movement
     ioMovementId:= lpInsertUpdate_Movement_ReestrIncome (ioId               := ioMovementId
                                                        , inInvNumber        := CASE WHEN ioMovementId <> 0 THEN (SELECT InvNumber FROM Movement WHERE Id = ioMovementId) ELSE CAST (NEXTVAL ('Movement_ReestrIncome_seq') AS TVarChar) END
                                                          -- �������� ���� ��� � Scale ��� BranchCode = 1
                                                        , inOperDate         := -- CASE WHEN ioMovementId <> 0 THEN (SELECT OperDate  FROM Movement WHERE Id = ioMovementId) ELSE CURRENT_DATE :: TDateTime END
                                                                                gpGet_Scale_OperDate (inIsCeh      := FALSE
                                                                                                    , inBranchCode := 1
                                                                                                    , inSession    := inSession
                                                                                                     )
                                                        , inUserId           := vbUserId
                                                         );

      -- ������ ���� ���� ������
      IF vbMovementId_Income <> 0
      THEN
          -- ������������ <���������� ����> - ��� ����������� ���� "�������� �� �������"
          vbMemberId:= CASE WHEN vbUserId = 5 THEN 9457 ELSE
                       (SELECT ObjectLink_User_Member.ChildObjectId
                        FROM ObjectLink AS ObjectLink_User_Member
                        WHERE ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                          AND ObjectLink_User_Member.ObjectId = vbUserId)
                       END
                      ;
          -- ��������
          IF COALESCE (vbMemberId, 0) = 0
          THEN 
              RAISE EXCEPTION '������.� ������������ <%> �� ��������� �������� <���.����>.', lfGet_Object_ValueData (vbUserId);
          END IF;

          -- ����� �������� ��� ��������� <������>
          vbId_mi:= (SELECT MF_MovementItemId.ValueData :: Integer
                     FROM MovementFloat AS MF_MovementItemId
                     WHERE MF_MovementItemId.MovementId = vbMovementId_Income
                       AND MF_MovementItemId.DescId = zc_MovementFloat_MovementItemId()
                    );
       
          -- ���������� ������� ��������/�������������
          vbIsInsert:= COALESCE (vbId_mi, 0) = 0;

          -- ���� ��� ������
          IF EXISTS (SELECT 1 FROM MovementItem WHERE Id = vbId_mi AND isErased = TRUE)
          THEN
              -- ����������� + ��������� !!!�.�. ����� ���������� ObjectId + MovementId!!!
              UPDATE MovementItem SET isErased = FALSE, ObjectId = vbMemberId, MovementId = ioMovementId WHERE Id = vbId_mi;
          ELSE
              -- ������ - ��������� <������� ���������> - <��� ����������� ���� "�������� �� �������">
              vbId_mi := lpInsertUpdate_MovementItem (vbId_mi, zc_MI_Master(), vbMemberId, ioMovementId, 0, NULL);

              -- !!!�.�. ����� ���������� MovementId!!!
              UPDATE MovementItem SET MovementId = ioMovementId WHERE Id = vbId_mi;

          END IF;

          -- ��������� <����� ������������ ���� "�������� �� �������>   
          PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), vbId_mi, CURRENT_TIMESTAMP);


          -- ��������� �������� � ��������� ������� <� �������� ����� � ������� ���������>
          PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MovementItemId(), vbMovementId_Income, vbId_mi);
          -- ��������� � ��������� ������� ����� � <��������� �� �������>
          PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ReestrKind(), vbMovementId_Income, zc_Enum_ReestrKind_PartnerIn());


          -- ��������� ��������
          PERFORM lpInsert_MovementItemProtocol (vbId_mi, vbUserId, vbIsInsert);

      END IF; -- if ������ ���� ���� �������

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 27.12.20         *
 22.10.16         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MI_ReestrIncomeStart (inBarCode:= '4323306', inOperDate:= '23.10.2016', inCarId:= 340655, inPersonalDriverId:= 0, inMemberId:= 0, ioMovementId_TransportTop:= 2298218, inSession:= '5');
