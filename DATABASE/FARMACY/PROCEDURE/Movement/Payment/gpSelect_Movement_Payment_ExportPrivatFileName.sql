-- Function: gpSelect_Movement_Payment_ExportPrivatFileName()

DROP FUNCTION IF EXISTS gpSelect_Movement_Payment_ExportPrivatFileName (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Payment_ExportPrivatFileName(
    IN inMovementId    Integer   , -- ���� ���������
   OUT outFileName     TVarChar  , -- ��� �����
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS TVarChar
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbJuridicalName TVarChar;
    DECLARE vbBankName TVarChar;
    DECLARE vbOperDate TDateTime;

BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Payment());
    vbUserId:= inSession;

    SELECT Movement_Payment.OperDate, Movement_Payment.JuridicalName, Object_Bank.ValueData
      INTO vbOperDate, vbJuridicalName, vbBankName
    FROM Movement_Payment_View AS Movement_Payment
         LEFT JOIN Object AS Object_Bank ON Object_Bank.id = 1020650
    WHERE Movement_Payment.Id = inMovementId;

    outFileName := REPLACE(vbJuridicalName||' '||vbBankName||' '||TO_CHAR (vbOperDate, 'dd.mm.yyyy')||'.xls', '"', '');


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_Payment_ExportPrivatFileName (Integer, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ������ �.�
 08.09.19                                                                       *
*/

-- SELECT * FROM gpSelect_Movement_Payment_ExportPrivatFileName (inMovementId := 15499959 , inSession:= '5');
