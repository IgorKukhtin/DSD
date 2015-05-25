-- Function: gpInsertUpdate_1CMoneyLoad()

DROP FUNCTION IF EXISTS gpDelete_1CMoney(TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpDelete_1CMoney(
    IN inStartDate           TDateTime  , -- ��������� ���� ��������
    IN inEndDate             TDateTime  , -- �������� ���� ��������
    IN inBranchId            Integer    , -- ������
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbProtocolXML TBlob;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_BankAccount());
     vbUserId := lpGetUserBySession (inSession);

     DELETE FROM Money1C 
            WHERE Money1C.OperDate BETWEEN inStartDate AND inEndDate AND inBranchId = zfGetBranchFromUnitId (Money1C.UnitId);

     -- �������������� XML ��� "������������" ���������
     SELECT '<XML>' || STRING_AGG (D.FieldXML, '') || '</XML>'
            INTO vbProtocolXML
     FROM
          (SELECT D.FieldXML
           FROM 
          (SELECT '<Field FieldName = "��������� ����" FieldValue = "' || DATE (inStartDate) :: TVarChar || '"/>'
               || '<Field FieldName = "�������� ����" FieldValue = "' || DATE (inEndDate) :: TVarChar || '"/>'
               || '<Field FieldName = "������ Id" FieldValue = "' || COALESCE (inBranchId :: TVarChar, 'NULL') :: TVarChar || '"/>'
               || '<Field FieldName = "������" FieldValue = "' || COALESCE ((SELECT Object.ValueData FROM Object WHERE Object.Id = inBranchId), 'NULL') :: TVarChar || '"/>'
                  AS FieldXML
          ) AS D
          ) AS D
         ;

     -- ��������� "�����������" ��������
     INSERT INTO ObjectProtocol (ObjectId, OperDate, UserId, ProtocolData, isInsert)
          SELECT zc_Enum_Process_LoadMoneyFrom1C(), CURRENT_TIMESTAMP, vbUserId, vbProtocolXML, FALSE;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 21.05.15                                        * ��������� "�����������" ��������
 30.01.14                          *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_1CMoneyLoad (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
