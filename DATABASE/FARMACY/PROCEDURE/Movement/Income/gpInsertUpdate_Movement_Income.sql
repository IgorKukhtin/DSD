-- Function: gpInsertUpdate_Movement_Income()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Income(Integer, TVarChar, TDateTime, Boolean, Integer, Integer, Integer, Integer, TDateTime, TVarChar, TDateTime, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Income(Integer, TVarChar, TDateTime, Boolean, Boolean, Integer, Integer, Integer, Integer, TDateTime, TVarChar, TDateTime, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Income(Integer, TVarChar, TDateTime, Boolean, Boolean, Integer, Integer, Integer, Integer, TDateTime, TVarChar, TDateTime, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Income(
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inPriceWithVAT        Boolean   , -- ���� � ��� (��/���)
    IN inisDifferent         Boolean   , -- ����� ��. ��. ����
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ����
    IN inNDSKindId           Integer   , -- ���� ���
    IN inContractId          Integer   , -- �������
   -- IN inOrderId             Integer   , -- �c���� �� ������ ���������� 
    IN inPaymentDate         TDateTime , -- ���� �������
    IN inInvNumberBranch     TVarChar  , -- ����� ���������
    IN inOperDateBranch      TDateTime , -- ���� ���������
 INOUT ioJuridicalId         Integer   , -- ������ ����������
   OUT outJuridicalName      TVarChar  , -- ������ ����������
    IN inComment             TVarChar  , -- ����������
    IN inisUseNDSKind        Boolean   , -- ������������ ������ ��� �� �������
    IN inSession             TVarChar    -- ������ ������������
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbOldContractId Integer;
   DECLARE vbDeferment Integer;
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Income());
    vbUserId := inSession;
    -- �������� ������ �������. ���� �� ���������� �� ��������, �� ����� ����� ���� �������

    SELECT ContractId INTO vbOldContractId FROM Movement_Income_View WHERE Movement_Income_View.Id = ioId;

    IF COALESCE(vbOldContractId, 0) <> inContractId THEN 
       SELECT Deferment INTO vbDeferment 
         FROM Object_Contract_View WHERE Object_Contract_View.Id = inContractId;
       inPaymentDate := inOperDate + vbDeferment * interval '1 day';  
    END IF;

    --���������� ������
    IF COALESCE(ioJuridicalId,0) = 0
    THEN
        SELECT
            Object.Id,
            Object.ValueData
        INTO
            ioJuridicalId,
            outJuridicalName
        FROM
            ObjectLink
            Inner Join object ON ObjectLink.ChildObjectId = Object.Id
        WHERE
            ObjectLink.ObjectId = inToId
            AND
            ObjectLink.DescId = zc_ObjectLink_Unit_Juridical();
    ELSE
        outJuridicalName = (Select ValueData from Object Where Id = ioJuridicalId);
    END IF;
    
    ioId := lpInsertUpdate_Movement_Income(ioId, inInvNumber, inOperDate, inPriceWithVAT
                                         , inFromId, inToId, inNDSKindId, inContractId--, inOrderId
                                         , inPaymentDate, ioJuridicalId, inisDifferent, inComment
                                         , inisUseNDSKind, vbUserId);

    PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberBranch(), ioId, inInvNumberBranch);

    --���� ������ ��������� ������ ����� ������� ������ ���������� ��������� ���� , ������� ����� �� ���������
    /*IF COALESCE (inInvNumberBranch,'') <> ''
    THEN
        -- 
        PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Branch(), ioId, inOperDateBranch);
    END IF;
    */

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.  ������ �.�.
 14.04.20                                                                                    * UseNDSKind
 06.05.16         * del inOrderId
 22.04.16         *
 21.12.15                                                                       *
 07.12.15                                                                       *
 20.05.15                         *
 24.12.14                         *
 02.12.14                                                        *
 10.07.14                                                        *


*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_Income (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inOperDateMark:= '01.01.2013', inInvNumberPartner:= 'xxx', inFromId:= 1, inPersonalId:= 0, inRouteId:= 0, inRouteSortingId:= 0, inSession:= '2')
