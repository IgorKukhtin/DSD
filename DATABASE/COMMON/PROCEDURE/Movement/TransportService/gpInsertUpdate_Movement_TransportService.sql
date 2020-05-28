-- Function: gpInsertUpdate_Movement_TransportService (Integer, Integer, TVarChar, TDateTime, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer,  Integer, Integer, TVarChar)


DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TransportService (Integer, Integer, TVarChar, TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TransportService (Integer, Integer, TVarChar, TDateTime, TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TransportService (Integer, Integer, TVarChar, TDateTime, TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TransportService (Integer, Integer, TVarChar, TDateTime, TDateTime, TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TransportService (Integer, Integer, TVarChar, TDateTime, TDateTime, TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TransportService (Integer, Integer, TVarChar, TDateTime, TDateTime, TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_TransportService(
 INOUT ioId                       Integer   , -- ���� ������� <��������>
 INOUT ioMIId                     Integer   , -- ���� ������� <�������� ����� ���������>
    IN inInvNumber                TVarChar  , -- ����� ���������
    IN inOperDate                 TDateTime , -- ���� ���������
  
    IN inStartRunPlan             TDateTime , -- ����/����� ������ ����
    IN inStartRun                 TDateTime , -- ����/����� ������ ����

 INOUT ioAmount                   TFloat    , -- �����
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
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_TransportService());
     -- ���������� ���� �������
     vbAccessKeyId:= lpGetAccessKey (vbUserId, zc_Enum_Process_InsertUpdate_Movement_TransportService());
   

     -- ��������
     IF 1 < (SELECT COUNT (*)
             FROM ObjectLink AS ObjectLink_ContractCondition_Contract
                  JOIN ObjectLink AS ObjectLink_ContractCondition_ContractConditionKind
                                  ON ObjectLink_ContractCondition_ContractConditionKind.ObjectId      = ObjectLink_ContractCondition_Contract.ObjectId
                                 AND ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId = inContractConditionKindId
                                 AND ObjectLink_ContractCondition_ContractConditionKind.DescId        = zc_ObjectLink_ContractCondition_ContractConditionKind()
                  LEFT JOIN ObjectFloat AS ObjectFloat_Value 
                                        ON ObjectFloat_Value.ObjectId = ObjectLink_ContractCondition_Contract.ObjectId
                                       AND ObjectFloat_Value.DescId   = zc_ObjectFloat_ContractCondition_Value()
             WHERE ObjectLink_ContractCondition_Contract.DescId       = zc_ObjectLink_ContractCondition_Contract()
               AND ObjectLink_ContractCondition_Contract.ChildObjectId = inContractId)
     THEN
         RAISE EXCEPTION '������ � �������� � <%>. ������� <%> ������� ����� 1 ����.', lfGet_Object_ValueData (inContractId), lfGet_Object_ValueData_sh (inContractConditionKindId);
     END IF;

     -- ����������� �����
     IF inContractConditionKindId IN (zc_Enum_ContractConditionKind_TransportWeight()) -- ������ �� �����, ���/��
     THEN
                   -- �� �������� � �������� "������ �� �����, ���/��"
         vbValue:= COALESCE ((SELECT ObjectFloat_Value.ValueData
                               FROM ObjectLink AS ObjectLink_ContractCondition_Contract
                                    JOIN ObjectLink AS ObjectLink_ContractCondition_ContractConditionKind
                                                    ON ObjectLink_ContractCondition_ContractConditionKind.ObjectId = ObjectLink_ContractCondition_Contract.ObjectId
                                                   AND ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId = inContractConditionKindId
                                                   AND ObjectLink_ContractCondition_ContractConditionKind.DescId = zc_ObjectLink_ContractCondition_ContractConditionKind()
                                    LEFT JOIN ObjectFloat AS ObjectFloat_Value 
                                                          ON ObjectFloat_Value.ObjectId = ObjectLink_ContractCondition_Contract.ObjectId
                                                         AND ObjectFloat_Value.DescId = zc_ObjectFloat_ContractCondition_Value()
                               WHERE ObjectLink_ContractCondition_Contract.DescId = zc_ObjectLink_ContractCondition_Contract()
                                 AND ObjectLink_ContractCondition_Contract.ChildObjectId = inContractId
                              ), 0);

         ioAmount:= COALESCE (inWeightTransport, 0) * vbValue;
     ELSE
     IF inContractConditionKindId IN (zc_Enum_ContractConditionKind_TransportOneTrip()   -- ������ �� ������� � ���� �������, ��� 
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
                               FROM ObjectLink AS ObjectLink_ContractCondition_Contract
                                    JOIN ObjectLink AS ObjectLink_ContractCondition_ContractConditionKind
                                                    ON ObjectLink_ContractCondition_ContractConditionKind.ObjectId = ObjectLink_ContractCondition_Contract.ObjectId
                                                   AND ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId = inContractConditionKindId
                                                   AND ObjectLink_ContractCondition_ContractConditionKind.DescId = zc_ObjectLink_ContractCondition_ContractConditionKind()
                                    LEFT JOIN ObjectFloat AS ObjectFloat_Value 
                                                          ON ObjectFloat_Value.ObjectId = ObjectLink_ContractCondition_Contract.ObjectId
                                                         AND ObjectFloat_Value.DescId = zc_ObjectFloat_ContractCondition_Value()
                               WHERE ObjectLink_ContractCondition_Contract.DescId = zc_ObjectLink_ContractCondition_Contract()
                                 AND ObjectLink_ContractCondition_Contract.ChildObjectId = inContractId), 0);
                    -- �� �������� � �������� "������� �� �����"
         vbValueAdd:= COALESCE ((SELECT ObjectFloat_Value.ValueData
                                 FROM ObjectLink AS ObjectLink_ContractCondition_Contract
                                      JOIN ObjectLink AS ObjectLink_ContractCondition_ContractConditionKind
                                                      ON ObjectLink_ContractCondition_ContractConditionKind.ObjectId = ObjectLink_ContractCondition_Contract.ObjectId
                                                     AND ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId = zc_Enum_ContractConditionKind_TransportPoint()
                                                     AND ObjectLink_ContractCondition_ContractConditionKind.DescId = zc_ObjectLink_ContractCondition_ContractConditionKind()
                                      LEFT JOIN ObjectFloat AS ObjectFloat_Value 
                                                            ON ObjectFloat_Value.ObjectId = ObjectLink_ContractCondition_Contract.ObjectId
                                                           AND ObjectFloat_Value.DescId = zc_ObjectFloat_ContractCondition_Value()
                                 WHERE ObjectLink_ContractCondition_Contract.DescId = zc_ObjectLink_ContractCondition_Contract()
                                   AND ObjectLink_ContractCondition_Contract.ChildObjectId = inContractId), 0);

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
                               FROM ObjectLink AS ObjectLink_ContractCondition_Contract
                                    JOIN ObjectLink AS ObjectLink_ContractCondition_ContractConditionKind
                                                    ON ObjectLink_ContractCondition_ContractConditionKind.ObjectId = ObjectLink_ContractCondition_Contract.ObjectId
                                                   AND ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId = inContractConditionKindId
                                                   AND ObjectLink_ContractCondition_ContractConditionKind.DescId = zc_ObjectLink_ContractCondition_ContractConditionKind()
                                                   AND inContractConditionKindId NOT IN (zc_Enum_ContractConditionKind_TransportDistance()
                                                                                       , zc_Enum_ContractConditionKind_TransportDistanceInt()
                                                                                       , zc_Enum_ContractConditionKind_TransportDistanceExt()
                                                                                        )
                                    LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                                          ON ObjectFloat_Value.ObjectId = ObjectLink_ContractCondition_Contract.ObjectId
                                                         AND ObjectFloat_Value.DescId = zc_ObjectFloat_ContractCondition_Value()
                               WHERE ObjectLink_ContractCondition_Contract.DescId = zc_ObjectLink_ContractCondition_Contract()
                                 AND ObjectLink_ContractCondition_Contract.ChildObjectId = inContractId), 0);
                      -- �� �������� � �������� "������ �� ������..."
         vbValueAdd:= COALESCE ((SELECT ObjectFloat_Value.ValueData
                                 FROM ObjectLink AS ObjectLink_ContractCondition_Contract
                                      JOIN ObjectLink AS ObjectLink_ContractCondition_ContractConditionKind
                                                      ON ObjectLink_ContractCondition_ContractConditionKind.ObjectId = ObjectLink_ContractCondition_Contract.ObjectId
                                                     AND ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId = inContractConditionKindId
                                                     AND ObjectLink_ContractCondition_ContractConditionKind.DescId = zc_ObjectLink_ContractCondition_ContractConditionKind()
                                                     AND inContractConditionKindId IN (zc_Enum_ContractConditionKind_TransportDistance()
                                                                                     , zc_Enum_ContractConditionKind_TransportDistanceInt()
                                                                                     , zc_Enum_ContractConditionKind_TransportDistanceExt()
                                                                                      )
                                      LEFT JOIN ObjectFloat AS ObjectFloat_Value 
                                                            ON ObjectFloat_Value.ObjectId = ObjectLink_ContractCondition_Contract.ObjectId
                                                           AND ObjectFloat_Value.DescId = zc_ObjectFloat_ContractCondition_Value()
                                 WHERE ObjectLink_ContractCondition_Contract.DescId = zc_ObjectLink_ContractCondition_Contract()
                                   AND ObjectLink_ContractCondition_Contract.ChildObjectId = inContractId), 0);

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
                               FROM ObjectLink AS ObjectLink_ContractCondition_Contract
                                    JOIN ObjectLink AS ObjectLink_ContractCondition_ContractConditionKind
                                                    ON ObjectLink_ContractCondition_ContractConditionKind.ObjectId = ObjectLink_ContractCondition_Contract.ObjectId
                                                   AND ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId = inContractConditionKindId
                                                   AND ObjectLink_ContractCondition_ContractConditionKind.DescId = zc_ObjectLink_ContractCondition_ContractConditionKind()
                                                   AND inContractConditionKindId IN (zc_Enum_ContractConditionKind_TransportDistance()
                                                                                   , zc_Enum_ContractConditionKind_TransportDistanceInt()
                                                                                   , zc_Enum_ContractConditionKind_TransportDistanceExt()
                                                                                    )
                                    JOIN ObjectFloat AS ObjectFloat_Value
                                                     ON ObjectFloat_Value.ObjectId = ObjectLink_ContractCondition_Contract.ObjectId
                                                    AND ObjectFloat_Value.DescId = zc_ObjectFloat_ContractCondition_Value()
                                                    AND ObjectFloat_Value.ValueData > 0
                               WHERE ObjectLink_ContractCondition_Contract.DescId = zc_ObjectLink_ContractCondition_Contract()
                                 AND ObjectLink_ContractCondition_Contract.ChildObjectId = inContractId
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
     -- ��������� ����� � <���� ������� ���������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ContractConditionKind(), ioMIId, inContractConditionKindId);
     -- ��������� ����� � <���������� ����(���������)>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_MemberExternal(), ioMIId, vbMemberExternalId);
     
     --������������ � ��������� ��-�� ����� �������� �� ������� ���������
     vbSummReestr := COALESCE ((SELECT SUM (COALESCE (MovementFloat_TotalSumm.ValueData,0)) AS vbSummReestr
                                FROM MovementLinkMovement
                                     INNER JOIN MovementItem ON MovementItem.MovementId = MovementLinkMovement.MovementId
                                     JOIN MovementFloat AS MovementFloat_MovementItemId
                                                        ON MovementFloat_MovementItemId.ValueData ::Integer = MovementItem.Id
                                                       AND MovementFloat_MovementItemId.DescId = zc_MovementFloat_MovementItemId()
                                     JOIN MovementFloat AS MovementFloat_TotalSumm
                                                        ON MovementFloat_TotalSumm.MovementId = MovementFloat_MovementItemId.MovementId
                                                       AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
                                WHERE MovementLinkMovement.MovementChildId = ioId
                                  AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Transport() )
                               ,0) ::TFloat;
     
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummReestr(), ioMIId, vbSummReestr );


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

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
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
