-- Function: gpInsertUpdate_Movement_Tax_From_Kind()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Tax_From_Kind (Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Tax_From_Kind (Integer, Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Tax_From_Kind (
    IN inMovementId                 Integer  , -- ���� ���������
    IN inDocumentTaxKindId          Integer  , -- ��� ������������ ���������� ���������
    IN inDocumentTaxKindId_inf      Integer  , -- ��� ������������ ���������� ���������
    IN inStartDateTax               TDateTime, -- 
   OUT outInvNumberPartner_Master   TVarChar , --
   OUT outDocumentTaxKindId         Integer  , --
   OUT outDocumentTaxKindName       TVarChar , --
   OUT outMessageText               Text     ,
    IN inSession                    TVarChar   -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
      -- �������� ���� ������������ �� ����� ���������
      vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Tax_From_Kind());

     -- ��������� � ������� ���������
     SELECT tmp.outInvNumberPartner_Master, tmp.outDocumentTaxKindId, tmp.outDocumentTaxKindName, tmp.outMessageText
            INTO outInvNumberPartner_Master, outDocumentTaxKindId, outDocumentTaxKindName, outMessageText
     FROM lpInsertUpdate_Movement_Tax_From_Kind (inMovementId            := inMovementId
                                               , inDocumentTaxKindId     := inDocumentTaxKindId
                                               , inDocumentTaxKindId_inf := inDocumentTaxKindId_inf
                                               , inStartDateTax          := inStartDateTax
                                               , inUserId                := vbUserId
                                                ) AS tmp;

-- ��� �������
if vbUserId = 5 AND 1=1
then
    RAISE EXCEPTION 'gpInsertUpdate_Movement_Tax_From_Kind - Admin';
    -- '��������� �������� ����� 3 ���.'
end if;

  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpInsertUpdate_Movement_Tax_From_Kind (Integer, Integer, Integer, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 10.05.16         * add inStartDateTax
 16.05.14                                        * add lpInsertUpdate_Movement_Tax_From_Kind
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_Tax_From_Kind (inMovementId:= 21838, inDocumentTaxKindId:= 80770, inSession:= '5');
