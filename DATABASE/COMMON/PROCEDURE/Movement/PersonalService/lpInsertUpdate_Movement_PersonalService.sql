-- Function: lpInsertUpdate_Movement_PersonalService()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_PersonalService (Integer, TVarChar, TDateTime, TDateTime, TVarChar, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_PersonalService (Integer, TVarChar, TDateTime, TDateTime, TVarChar, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_PersonalService(
 INOUT ioId                     Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber              TVarChar  , -- ����� ���������
    IN inOperDate               TDateTime , -- ���� ���������
    IN inServiceDate            TDateTime , -- ����� ����������
    IN inComment                TVarChar  , -- ����������
    IN inPersonalServiceListId  Integer   , -- 
    IN inJuridicalId            Integer   , -- 
    IN inUserId                 Integer     -- ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbMovementId_check Integer;
   DECLARE vbIsAll Boolean;
   DECLARE vbisDetail Boolean;
BEGIN
     -- !!!
     vbIsAll:= EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = inUserId);


     -- ��������
     IF inOperDate <> DATE_TRUNC ('DAY', inOperDate)
     THEN
         RAISE EXCEPTION '������.�������� ������ ����.';
     END IF;
     -- ��������
     IF COALESCE (inPersonalServiceListId, 0) = 0 AND vbIsAll = FALSE
     THEN
         RAISE EXCEPTION '������.�� ����������� �������� <��������� ����������>.';
     END IF;

     -- ������ - 1-�� ����� ������
     inServiceDate:= DATE_TRUNC ('MONTH', inServiceDate);


     -- �������� - ������ ���� �� ������
     vbMovementId_check:= (SELECT MovementDate.MovementId
                           FROM MovementDate
                                INNER JOIN MovementLinkObject ON MovementLinkObject.MovementId = MovementDate.MovementId
                                                             AND MovementLinkObject.DescId = zc_MovementLinkObject_PersonalServiceList()
                                                             AND MovementLinkObject.ObjectId = inPersonalServiceListId
                                INNER JOIN Movement ON Movement.Id = MovementDate.MovementId
                                                   AND Movement.StatusId <> zc_Enum_Status_Erased()
                                                   AND Movement.Id <> COALESCE (ioId, 0)
                           WHERE MovementDate.ValueData = inServiceDate
                             AND MovementDate.DescId = zc_MIDate_ServiceDate()
                           LIMIT 1
                          );
     IF vbMovementId_check <> 0 AND 1=0 -- AND inUserId <> 5
     THEN
         RAISE EXCEPTION '������.������� ������ <��������� ����������> � <%> �� <%> ��� <%> �� <%>.������������ ���������.', (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = vbMovementId_check)
                                                                                                                           , DATE ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = vbMovementId_check))
                                                                                                                           , lfGet_Object_ValueData ((SELECT MovementLinkObject.ObjectId FROM MovementLinkObject WHERE MovementLinkObject.MovementId = vbMovementId_check AND MovementLinkObject.DescId = zc_MovementLinkObject_PersonalServiceList()))
                                                                                                                           , zfCalc_MonthYearName ((SELECT MovementDate.ValueData FROM MovementDate WHERE MovementDate.MovementId = vbMovementId_check AND MovementDate.DescId = zc_MIDate_ServiceDate()));
     END IF;


     /*IF EXISTS (SELECT 1 AS Id FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = inUserId)
     THEN IF COALESCE (ioId, 0) = 0 
          THEN
              RAISE EXCEPTION '������.��� <�����> ��� ���� �������� ���������.';
          END IF;
     ELSE*/


     -- ��������
     IF NOT EXISTS (SELECT ObjectLink_User_Member.ObjectId
                    FROM ObjectLink
                         INNER JOIN ObjectLink AS ObjectLink_User_Member
                                               ON ObjectLink_User_Member.ChildObjectId = ObjectLink.ChildObjectId
                                              AND ObjectLink_User_Member.DescId        = zc_ObjectLink_User_Member()
                                              AND ObjectLink_User_Member.ObjectId      > 0
                    WHERE ObjectLink.DescId   = zc_ObjectLink_PersonalServiceList_Member()
                      AND ObjectLink.ObjectId = inPersonalServiceListId
                   )
      AND 1=0
     THEN
         RAISE EXCEPTION '������.� ����������� <��������� ����������> ��� <%> �� ����������� �������� ���.���� (������������).', lfGet_Object_ValueData_sh (inPersonalServiceListId);
     END IF;

         -- ���������� ���� �������
         -- vbAccessKeyId:= lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_PersonalService());
         vbAccessKeyId:= CASE WHEN vbIsAll = TRUE
                               AND NOT EXISTS (SELECT 1
                                               FROM ObjectLink
                                                    INNER JOIN ObjectLink AS ObjectLink_User_Member ON ObjectLink_User_Member.ChildObjectId = ObjectLink.ChildObjectId
                                                                                                   AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                                               WHERE ObjectLink.DescId   = zc_ObjectLink_PersonalServiceList_Member()
                                                 AND ObjectLink.ObjectId = inPersonalServiceListId
                                              )
                        -- THEN zc_Enum_Process_AccessKey_PersonalServiceAdmin()
                        THEN lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_PersonalService(), inPersonalServiceListId)
                        ELSE
                         lpGetAccessKey (COALESCE ((SELECT ObjectLink_User_Member.ObjectId
                                                    FROM ObjectLink
                                                         INNER JOIN ObjectLink AS ObjectLink_User_Member ON ObjectLink_User_Member.ChildObjectId = ObjectLink.ChildObjectId
                                                                                                        AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                                                    WHERE ObjectLink.DescId   = zc_ObjectLink_PersonalServiceList_Member()
                                                      AND ObjectLink.ObjectId = inPersonalServiceListId
                                                    LIMIT 1
                                                   )
                                                 , (SELECT ObjectLink_User_Member.ObjectId
                                                    FROM ObjectLink AS ObjectLink_User_Member
                                                         INNER JOIN ObjectLink AS MemberPersonalServiceList_Member
                                                                               ON MemberPersonalServiceList_Member.ChildObjectId = ObjectLink_User_Member.ChildObjectId
                                                                              AND MemberPersonalServiceList_Member.DescId        = zc_ObjectLink_MemberPersonalServiceList_Member()
                                                         INNER JOIN Object AS Object_MemberPersonalServiceList
                                                                           ON Object_MemberPersonalServiceList.Id       = MemberPersonalServiceList_Member.ObjectId
                                                                          AND Object_MemberPersonalServiceList.isErased = FALSE
                                                         INNER JOIN ObjectLink AS MemberPersonalServiceList_PersonalServiceList
                                                                               ON MemberPersonalServiceList_PersonalServiceList.ObjectId = MemberPersonalServiceList_Member.ObjectId
                                                                              AND MemberPersonalServiceList_PersonalServiceList.ChildObjectId = inPersonalServiceListId
                                                                              AND MemberPersonalServiceList_PersonalServiceList.DescId        = zc_ObjectLink_MemberPersonalServiceList_PersonalServiceList()

                                                    WHERE ObjectLink_User_Member.DescId   = zc_ObjectLink_User_Member()
                                                    LIMIT 1
                                                   )
                                                  )
                                       , zc_Enum_Process_InsertUpdate_Movement_PersonalService()
                                       , inPersonalServiceListId
                                        )
                        END;
     -- END IF;

     -- �������� �������� PersonalServiceList
     vbisDetail := COALESCE ((SELECT ObjectBoolean.ValueData
                              FROM ObjectBoolean
                              WHERE ObjectBoolean.ObjectId = inPersonalServiceListId 
                                AND ObjectBoolean.DescId = zc_ObjectBoolean_PersonalServiceList_Detail())
                             , FALSE) ::Boolean;

     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_PersonalService(), inInvNumber, inOperDate, NULL, vbAccessKeyId);
     -- !!!�����!!!
     UPDATE Movement SET AccessKeyId = vbAccessKeyId WHERE Id = ioId;

     -- �����������
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);
     -- ��������� �������� <����� ����������>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_ServiceDate(), ioId, inServiceDate);

     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PersonalServiceList(), ioId, inPersonalServiceListId);

     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Juridical(), ioId, inJuridicalId);
   
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Detail(), ioId, vbisDetail);

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 28.04.21         * add vbisDetail
 01.10.14         * add inJuridicalId
 11.09.14         *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_Movement_PersonalService (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
/*
update Movement set AccessKeyId = newId
from (
SELECT Movement.*, lpGetAccessKey (ObjectLink_User_Member.ObjectId , zc_Enum_Process_InsertUpdate_Movement_PersonalService()) as newId
FROM MovementLinkObject 
     INNER JOIN Movement ON Movement.Id = MovementLinkObject .MovementId
                        AND Movement.StatusId <> zc_Enum_Status_Erased()
                        AND Movement.DescId = zc_Movement_PersonalService()
                        AND Movement.OperDate > '01.11.2015'
INNER JOIN ObjectLink on ObjectLink.ObjectId = MovementLinkObject .ObjectId
                     and ObjectLink.DescId = zc_ObjectLink_PersonalServiceList_Member()
INNER JOIN ObjectLink AS ObjectLink_User_Member ON ObjectLink_User_Member.ChildObjectId = ObjectLink.ChildObjectId
                                               AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()


where MovementLinkObject.DescId = zc_MovementLinkObject_PersonalServiceList()
and Movement.AccessKeyId <> lpGetAccessKey (ObjectLink_User_Member.ObjectId , zc_Enum_Process_InsertUpdate_Movement_PersonalService())
) as aaa 
where aaa.Id = Movement .Id
*/