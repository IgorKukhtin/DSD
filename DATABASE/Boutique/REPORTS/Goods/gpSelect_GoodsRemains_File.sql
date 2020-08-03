-- Function: gpSelect_GoodsRemains_File(Integer, tvarchar)

-- DROP FUNCTION gpSelect_GoodsRemains_File (Integer, tvarchar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsRemains_File(
    IN inMovementId           Integer   ,
    IN inSession              TVarChar    -- ������ ������������
)
RETURNS TABLE (RowData TBlob)
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbInvNumber Integer;
   DECLARE vbOperDate  TDateTime;
   DECLARE vbBankAccountName TVarChar;
   DECLARE vbMFO TVarChar;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Email_Send());
     vbUserId := lpGetUserBySession (inSession);

     -- ������� ��� ����������
     CREATE TEMP TABLE _Result (RowData TBlob) ON COMMIT DROP;

     -- ������ ������� XML
     --INSERT INTO _Result(RowData) VALUES ('<?xml version= �1.0� encoding= �win-1251�?>');
     --INSERT INTO _Result(RowData) VALUES ('<?xml version="1.0" encoding="windows-1251"?>');
     INSERT INTO _Result(RowData) VALUES ('<?xml version="1.0" encoding="UTF-16"?>');
     INSERT INTO _Result(RowData) VALUES ('<ROWDATA>');

     -- ������
     INSERT INTO _Result(RowData)
        SELECT '<ROW AMOUNT ="'      || CAST (MovementItem.Amount * 100 AS NUMERIC (16,0)) ||'"'     --����� ������� � ��������
             ||' CORRSNAME ="'       || COALESCE(Object_Juridical.ValueData,'') ||'"'                --������������ ���������� �������
             ||' DETAILSOFPAYMENT ="'|| COALESCE(Object_InfoMoney.ValueData,'') ||'"'                --���������� �������
             ||' CORRACCOUNTNO ="'   || COALESCE(Partner_BankAccount_View.Name,'') ||'"'             --� ����� ���������� �������
             ||' ACCOUNTNO ="'       || COALESCE(vbBankAccountName,'') ||'"'                         --� ����� �����������
             ||' CORRBANKID ="'      || COALESCE(Partner_BankAccount_View.MFO,'') ||'"'              --��� ����� ���������� ������� (���)
             ||' CORRIDENTIFYCODE ="'|| COALESCE(ObjectHistory_JuridicalDetails_View.OKPO,'') ||'"'  --����������������� ��� ���������� �������(������)
             ||' CORRCOUNTRYID ="'   || '804' ||'"'                                                  --��� ������ �������������� (��� ���������� ������������� ���������� ������� (804))
             ||' PRIORITY ="'        || '50' ||'"'                                                   --��������� (�� ��������� 50)
             ||' BANKID ="'          || COALESCE(vbMFO,'') ||'"'                                     --��� ����� ����������� (���)
             --||' DOCUMENTNO       ="' || MovementItem.ObjectId ||'"'     --� ��������� (���� ����� �� ������, ����� �������������� �������������)
             --||' VALUEDATE        ="' || MovementItem.ObjectId ||'"'     --���� �������������
             --||' DOCUMENTDATE     ="' || 'DOCUMENTDATE' ||'"'            --���� ��������� (��������)
             --||' ADDENTRIES       ="' || 'ADDENTRIES' ||'"'              --�������������� ��������� �������
             --||' PURPOSEPAYMENTID ="' || 'PURPOSEPAYMENTID' ||'"'        --��� ���������� ������� (����� 3-������� �����)
             ||'/>' 
        FROM .......;
     
     
     -- �������� ��� ������, ����� ������� ������� � ���������� ���������
     
     -- ��������� ������� XML
     INSERT INTO _Result(RowData) VALUES ('</ROWDATA>');
     
     -- ���������
     RETURN QUERY
        SELECT _Result.RowData FROM _Result;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 31.07.20         *
*/

-- ����
-- SELECT * FROM gpSelect_GoodsRemains_File (inMovementId:= 14022564, inSession:= zfCalc_UserAdmin())