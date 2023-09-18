-- Function: gpInsertUpdate_Movement_TransportService (Integer, Integer, TVarChar, TDateTime, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer,  Integer, Integer, TVarChar)


DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TransportService (Integer, Integer, TVarChar, TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TransportService (Integer, Integer, TVarChar, TDateTime, TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TransportService (Integer, Integer, TVarChar, TDateTime, TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TransportService (Integer, Integer, TVarChar, TDateTime, TDateTime, TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TransportService (Integer, Integer, TVarChar, TDateTime, TDateTime, TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TransportService (Integer, Integer, TVarChar, TDateTime, TDateTime, TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TransportService (Integer, Integer, TVarChar, TDateTime, TDateTime, TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TransportService (Integer, Integer, TVarChar, TDateTime, TDateTime, TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_TransportService(
 INOUT ioId                       Integer   , -- ���� ������� <��������>
 INOUT ioMIId                     Integer   , -- ���� ������� <�������� ����� ���������>
    IN inInvNumber                TVarChar  , -- ����� ���������
    IN inOperDate                 TDateTime , -- ���� ���������

    IN inStartRunPlan             TDateTime , -- ����/����� ������ ����
    IN inStartRun                 TDateTime , -- ����/����� ������ ����

 INOUT ioAmount                   TFloat    , -- �����
    IN inSummTransport            TFloat    , -- ����� ����, ���
    IN inWeightTransport          TFloat    , -- ����� ����, ��
    IN inDistance                 TFloat    , -- ������ ����, ��
    IN inPrice                    TFloat    , -- ���� (�������)
    IN inCountPoint               TFloat    , -- ���-�� �����
    IN inTrevelTime               TFloat    , -- ����� � ����, �����
    IN inSummAdd                  TFloat    , -- ����� �������, ���

    IN inComment                  TVarChar  , -- ����������

    IN inMemberExternalName       TVarChar  , -- ���������� ����(���������)
    IN inDriverCertificate        TVarChar  , -- ������������ �������������

    IN inJuridicalId              Integer   , -- ����������� ����
    IN inContractId               Integer   , -- �������
    IN inInfoMoneyId              Integer   , -- ������ ����������
    IN inPaidKindId               Integer   , -- ���� ���� ������
    IN inRouteId                  Integer   , -- �������
    IN inCarId                    Integer   , -- ����������
    IN inCarTrailerId             Integer   , -- ������
    IN inContractConditionKindId  Integer   , -- ���� ������� ���������
    IN inUnitForwardingId         Integer   , -- ������������� (����� ��������)

    IN inSession                  TVarChar    -- ������ ������������

)
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyId Integer;
   DECLARE vbValue TFloat;
   DECLARE vbValueAdd TFloat;
   DECLARE vbMemberExternalId Integer;
   DECLARE vbDriverCertificate TVarChar;
   DECLARE vbSummReestr TFloat;
   DECLARE vbisSummReestr Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_TransportService());
     -- ���������� ���� �������
     vbAccessKeyId:= lpGetAccessKey (vbUserId, zc_Enum_Process_InsertUpdate_Movement_TransportService());


     -- ��������
     IF 1 < (SELECT COUNT (*)
             FROM Object_ContractCondition_View
                  LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                        ON ObjectFloat_Value.ObjectId = Object_ContractCondition_View.ContractConditionId
                                       AND ObjectFloat_Value.DescId = zc_ObjectFloat_ContractCondition_Value()
             WHERE Object_ContractCondition_View.ContractId              = inContractId
               AND Object_ContractCondition_View.ContractConditionKindId = inContractConditionKindId
               AND inOperDate BETWEEN Object_ContractCondition_View.StartDate AND Object_ContractCondition_View.EndDate)
     THEN
         RAISE EXCEPTION '������ � �������� � <%>. ������� <%> ������� ����� 1 ����.', lfGet_Object_ValueData (inContractId), lfGet_Object_ValueData_sh (inContractConditionKindId);
     END IF;

     -- ����������� �����
     IF inContractConditionKindId IN (zc_Enum_ContractConditionKind_TransportWeight()) -- ������ �� �����, ���/��
     THEN
         -- �� �������� � �������� "������ �� �����, ���/��"
         vbValue:= COALESCE ((SELECT ObjectFloat_Value.ValueData
                              FROM Object_ContractCondition_View
                                   LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                                         ON ObjectFloat_Value.ObjectId = Object_ContractCondition_View.ContractConditionId
                                                        AND ObjectFloat_Value.DescId = zc_ObjectFloat_ContractCondition_Value()
                              WHERE Object_ContractCondition_View.ContractId              = inContractId
                                AND Object_ContractCondition_View.ContractConditionKindId = inContractConditionKindId
                                AND inOperDate BETWEEN Object_ContractCondition_View.StartDate AND Object_ContractCondition_View.EndDate
                             ), 0);

         ioAmount:= COALESCE (inWeightTransport, 0) * vbValue;

     ELSEIF inContractConditionKindId IN (zc_Enum_ContractConditionKind_TransportSumm()) -- ������ �� �����, ���/�� (% �� �����)
     THEN
         -- �� �������� � �������� "������ �� �����, ���/��"
         vbValue:= COALESCE ((SELECT ObjectFloat_Value.ValueData
                              FROM Object_ContractCondition_View
                                   LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                                         ON ObjectFloat_Value.ObjectId = Object_ContractCondition_View.ContractConditionId
                                                        AND ObjectFloat_Value.DescId = zc_ObjectFloat_ContractCondition_Value()
                              WHERE Object_ContractCondition_View.ContractId              = inContractId
                                AND Object_ContractCondition_View.ContractConditionKindId = inContractConditionKindId
                                AND inOperDate BETWEEN Object_ContractCondition_View.StartDate AND Object_ContractCondition_View.EndDate
                             ), 0);

         ioAmount:= COALESCE (inSummTransport, 0) * vbValue / 100;
     ELSE
     IF inContractConditionKindId IN (zc_Enum_ContractConditionKind_TransportOneTrip()   -- ������ �� ������� � ���� �������, ���
                                    , zc_Enum_ContractConditionKind_TransportOneTrip05() -- ������ �� ������� 5�. � ���� �������, ���
                                    , zc_Enum_ContractConditionKind_TransportOneTrip10() -- ������ �� ������� 10�. � ���� �������, ���
                                    , zc_Enum_ContractConditionKind_TransportOneTrip20() -- ������ �� ������� 20�. � ���� �������, ���
                                    , zc_Enum_ContractConditionKind_TransportRoundTrip() -- ������ �� ������� � ��� �������, ���
                                    --, zc_Enum_ContractConditionKind_TransportPoint()   -- ������ �� �����, ���
                                    , zc_Enum_ContractConditionKind_TransportForward()   -- ������� �� �����������, ���/�����
                                    , zc_Enum_ContractConditionKind_TransportOneDay()    -- ������ �� ������� � ����
                                    , zc_Enum_ContractConditionKind_TransportOneDayCon() -- ������ �� ������� � ���� + �����������
                                     )
     THEN
         -- �� �������� � �������� "������ �� �������..."
         vbValue:= COALESCE ((SELECT ObjectFloat_Value.ValueData
                              FROM Object_ContractCondition_View
                                   LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                                         ON ObjectFloat_Value.ObjectId = Object_ContractCondition_View.ContractConditionId
                                                        AND ObjectFloat_Value.DescId = zc_ObjectFloat_ContractCondition_Value()
                              WHERE Object_ContractCondition_View.ContractId              = inContractId
                                AND Object_ContractCondition_View.ContractConditionKindId = inContractConditionKindId
                                AND inOperDate BETWEEN Object_ContractCondition_View.StartDate AND Object_ContractCondition_View.EndDate
                             ), 0);
         -- �� �������� � �������� "������� �� �����"
         vbValueAdd:= COALESCE ((SELECT ObjectFloat_Value.ValueData
                                 FROM Object_ContractCondition_View
                                      LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                                            ON ObjectFloat_Value.ObjectId = Object_ContractCondition_View.ContractConditionId
                                                           AND ObjectFloat_Value.DescId = zc_ObjectFloat_ContractCondition_Value()
                                 WHERE Object_ContractCondition_View.ContractId              = inContractId
                                   AND Object_ContractCondition_View.ContractConditionKindId = zc_Enum_ContractConditionKind_TransportPoint()
                                   AND inOperDate BETWEEN Object_ContractCondition_View.StartDate AND Object_ContractCondition_View.EndDate
                                ), 0);

         -- �� �������� � �������� "������ �� �������..."
         ioAmount:= vbValue
                    -- ��������� ������� �� �����
                  + vbValueAdd * COALESCE (inCountPoint, 0);
     ELSE
          -- ��������
          IF COALESCE (inDistance, 0) = 0 THEN
             RAISE EXCEPTION '������.�� ������� �������� <������ ����, ��.>';
          END IF;
          -- �� �������� � �������� "������ �� �����..."
          vbValue:= COALESCE ((SELECT ObjectFloat_Value.ValueData
                               FROM Object_ContractCondition_View
                                    LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                                          ON ObjectFloat_Value.ObjectId = Object_ContractCondition_View.ContractConditionId
                                                         AND ObjectFloat_Value.DescId = zc_ObjectFloat_ContractCondition_Value()
                               WHERE Object_ContractCondition_View.ContractId              = inContractId
                                 AND Object_ContractCondition_View.ContractConditionKindId = inContractConditionKindId
                                 AND inContractConditionKindId NOT IN (zc_Enum_ContractConditionKind_TransportDistance()
                                                                     , zc_Enum_ContractConditionKind_TransportDistanceInt()
                                                                     , zc_Enum_ContractConditionKind_TransportDistanceExt()
                                                                      )
                                 AND inOperDate BETWEEN Object_ContractCondition_View.StartDate AND Object_ContractCondition_View.EndDate
                              ), 0);
         -- �� �������� � �������� "������ �� ������..."
         vbValueAdd:= COALESCE ((SELECT ObjectFloat_Value.ValueData
                                 FROM Object_ContractCondition_View
                                      LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                                            ON ObjectFloat_Value.ObjectId = Object_ContractCondition_View.ContractConditionId
                                                           AND ObjectFloat_Value.DescId = zc_ObjectFloat_ContractCondition_Value()
                                 WHERE Object_ContractCondition_View.ContractId              = inContractId
                                   AND Object_ContractCondition_View.ContractConditionKindId = inContractConditionKindId
                                   AND inContractConditionKindId IN (zc_Enum_ContractConditionKind_TransportDistance()
                                                                   , zc_Enum_ContractConditionKind_TransportDistanceInt()
                                                                   , zc_Enum_ContractConditionKind_TransportDistanceExt()
                                                                    )
                                   AND inOperDate BETWEEN Object_ContractCondition_View.StartDate AND Object_ContractCondition_View.EndDate
                                ), 0);

         -- ���������� * ����
         ioAmount:= COALESCE (inDistance * inPrice, 0)
                    -- �� �������� � �������� "������ �� �����..."
                  + vbValue * COALESCE (inTrevelTime, 0)
                    -- �� �������� � �������� "������ �� ������..."
                  + vbValueAdd * COALESCE (inDistance, 0)
         ;
     END IF;
     END IF;


     -- ��������: ���� ���� "������ �� ������...", ����� ������� �� "���� (�������)" �� �����
     IF inPrice <> 0
                   AND EXISTS (SELECT ObjectFloat_Value.ValueData
                               FROM Object_ContractCondition_View
                                    JOIN ObjectFloat AS ObjectFloat_Value
                                                     ON ObjectFloat_Value.ObjectId = Object_ContractCondition_View.ContractConditionId
                                                    AND ObjectFloat_Value.DescId = zc_ObjectFloat_ContractCondition_Value()
                                                    AND ObjectFloat_Value.ValueData > 0
                               WHERE Object_ContractCondition_View.ContractId              = inContractId
                                 AND Object_ContractCondition_View.ContractConditionKindId = inContractConditionKindId
                                 AND inContractConditionKindId IN (zc_Enum_ContractConditionKind_TransportDistance()
                                                                 , zc_Enum_ContractConditionKind_TransportDistanceInt()
                                                                 , zc_Enum_ContractConditionKind_TransportDistanceExt()
                                                                  )
                                 AND inOperDate BETWEEN Object_ContractCondition_View.StartDate AND Object_ContractCondition_View.EndDate
                              )
     THEN
        RAISE EXCEPTION '������.�� �������� �������� �������� <���� (�������)> ������ ����=0.';
     END IF;

     -- ��������
     IF inSummAdd > 50 THEN
        RAISE EXCEPTION '������.����� <�������, ���> �� ����� ���� ������ 50 ���.';
     END IF;

     -- ��������
     IF (COALESCE (ioAmount, 0) = 0) THEN
        RAISE EXCEPTION '������.����� �� ����������.��������� ������� � ��������.';
     END IF;


     -- 1. ����������� ��������
     IF ioId > 0 AND vbUserId = lpCheckRight (inSession, zc_Enum_Process_UnComplete_TransportService())
     THEN
         PERFORM lpUnComplete_Movement (inMovementId := ioId
                                      , inUserId     := vbUserId);
     END IF;

     IF COALESCE (inMemberExternalName, '') <> ''
     THEN
         -- ���� ���������� �� ����� ���������
         vbMemberExternalId := (SELECT Object.Id
                                FROM Object
                                WHERE Object.DescId = zc_Object_MemberExternal()
                                  AND LOWER (Object.ValueData) LIKE '%'|| LOWER (inMemberExternalName) ||'%'
                                LIMIT 1);   -- �� ������ ������

         vbDriverCertificate := (SELECT ObjectString.ValueData
                                 FROM ObjectString
                                 WHERE ObjectString.ObjectId = vbMemberExternalId
                                   AND ObjectString.DescId = zc_ObjectString_MemberExternal_DriverCertificate());

         IF COALESCE (vbMemberExternalId, 0) = 0
         THEN
             -- ��������
             vbMemberExternalId := lpInsertUpdate_Object_MemberExternal (ioId	 := 0
                                                                       , inCode  := lfGet_ObjectCode(0, zc_Object_MemberExternal())
                                                                       , inName  := inMemberExternalName  :: TVarChar
                                                                       , inDriverCertificate := COALESCE (inDriverCertificate,'') :: TVarChar
                                                                       , inINN   := '' ::TVarChar
                                                                       , inUserId:= vbUserId
                                                                        );
         ELSE
             -- ���� ���������� ���.������������� ��������������
             IF COALESCE (inDriverCertificate,'') <> '' AND  COALESCE (vbDriverCertificate,'') <> COALESCE (inDriverCertificate,'')
                THEN
                    -- ���������
                    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_MemberExternal_DriverCertificate(), vbMemberExternalId, inDriverCertificate);
             END IF;

         END IF;
     END IF;

      -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_TransportService(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

     -- ��������� ����� � <����/����� ������ ����>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_StartRunPlan(), ioId, inStartRunPlan);
     -- ��������� ����� � <����/����� ������ ����>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_StartRun(), ioId, inStartRun);


     -- ��������� ����� � <������������� (����� ��������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_UnitForwarding(), ioId, inUnitForwardingId);

     -- ��������� <������� ���������>
     ioMIId := lpInsertUpdate_MovementItem (ioMIId, zc_MI_Master(), inJuridicalId, ioId, ioAmount, NULL);

     -- ��������� �������� <����� ����, ���>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummTransport(), ioMIId, inSummTransport);
     -- ��������� �������� <����� ����, ��>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightTransport(), ioMIId, inWeightTransport);
     -- ��������� �������� <������ ����, ��>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Distance(), ioMIId, inDistance);
     -- ��������� �������� <���� (�������)>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioMIId, inPrice);
     -- ��������� �������� <���-�� �����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountPoint(), ioMIId, inCountPoint);
     -- ��������� �������� <����� � ����, �����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TrevelTime(), ioMIId, inTrevelTime);
     -- ��������� �������� <�������)>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummAdd(), ioMIId, inSummAdd);
     -- ��������� �������� <�������)>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ContractValue(), ioMIId, vbValue);
     -- ��������� �������� <�������������� �������� �� ������� ��������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ContractValueAdd(), ioMIId, COALESCE (vbValueAdd, 0));

     -- ��������� �������� <�����������>
     PERFORM lpInsertUpdate_MovementItemString(zc_MIString_Comment(), ioMIId, inComment);

     -- ��������� ����� � <�������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Contract(), ioMIId, inContractId);
     -- ��������� ����� � <������ ����������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), ioMIId, inInfoMoneyId);
     -- ��������� ����� � <���� ���� ������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PaidKind(), ioMIId, inPaidKindId);
     -- ��������� ����� � <�������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Route(), ioMIId, inRouteId);
     -- ��������� ����� � <����������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Car(), ioMIId, inCarId);
     -- ��������� ����� � <����������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_CarTrailer(), ioMIId, inCarTrailerId);
     -- ��������� ����� � <���� ������� ���������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ContractConditionKind(), ioMIId, inContractConditionKindId);
     -- ��������� ����� � <���������� ����(���������)>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_MemberExternal(), ioMIId, vbMemberExternalId);

     -- ���� ����� ������� ������ zc_MIBoolean_SummReestr = FALSE ������ �� ���������, ����� ������� ������
     vbisSummReestr := COALESCE ( (SELECT MIB.ValueData FROM MovementItemBoolean AS MIB WHERE MIB.MovementItemId = ioMIId AND MIB.DescId = zc_MIBoolean_SummReestr()), TRUE) :: Boolean;
     IF COALESCE (vbisSummReestr, TRUE) = TRUE
     THEN
         -- ������������ � ��������� ��-�� ����� �������� �� ������� ���������
         vbSummReestr := COALESCE ((SELECT SUM (COALESCE (MovementFloat_TotalSumm.ValueData,0)) AS vbSummReestr
                                    FROM MovementLinkMovement
                                         INNER JOIN MovementItem ON MovementItem.MovementId = MovementLinkMovement.MovementId
                                                                AND MovementItem.DescId     = zc_MI_Master()
                                                                AND MovementItem.isErased   = FALSE
                                         JOIN MovementFloat AS MovementFloat_MovementItemId
                                                            ON MovementFloat_MovementItemId.ValueData ::Integer = MovementItem.Id
                                                           AND MovementFloat_MovementItemId.DescId = zc_MovementFloat_MovementItemId()
                                         JOIN MovementFloat AS MovementFloat_TotalSumm
                                                            ON MovementFloat_TotalSumm.MovementId = MovementFloat_MovementItemId.MovementId
                                                           AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
                                    WHERE MovementLinkMovement.MovementChildId = ioId
                                      AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Transport()
                                   ), 0) :: TFloat;

         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummReestr(), ioMIId, vbSummReestr );
     END IF;

     -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     -- 5.3. �������� ��������
     IF vbUserId = lpCheckRight (inSession, zc_Enum_Process_Complete_TransportService())
     THEN
          PERFORM lpComplete_Movement_TransportService (inMovementId := ioId
                                                      , inUserId     := vbUserId);
     END IF;


     -- ��������� ��������
     -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);

IF vbUserId = 5 AND 1=0
THEN
    RAISE EXCEPTION 'OK';
    -- '��������� �������� ����� 3 ���.'
END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 05.10.21         * add inCarTrailerId
 10.12.20         * add inSummTransport
 27.01.20         * add inMemberExternalName
                        inDriverCertificate
 03.07.16         * Add inSummAdd, vbValue, vbValueAdd
 16.12.15         * add WeightTransport
 26.08.15         * add inStartRunPlan
 12.11.14                                        * add lpComplete_Movement_Finance_CreateTemp
 12.09.14                                        * add PositionId and ServiceDateId and BusinessId_... and BranchId_...
 17.08.14                                        * add MovementDescId
 05.04.14                                        * add !!!��� �����������!!! : _tmp1___ and _tmp2___
 25.03.14                                        * ������� - !!!��� �����������!!!
 26.01.14                                        * add inUnitForwardingId
 25.01.14                                        * add lpComplete_Movement_TransportService
 23.12.13         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_TransportService (ioId:= 149691, inInvNumber:= '1', inOperDate:= '01.10.2013 3:00:00',............, inSession:= '2')
