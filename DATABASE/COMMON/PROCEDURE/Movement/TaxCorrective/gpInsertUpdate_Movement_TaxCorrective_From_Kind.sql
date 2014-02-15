-- Function: gpInsertUpdate_Movement_TaxCorrective_From_Kind()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TaxCorrective_From_Kind (Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_TaxCorrective_From_Kind (
    IN inMovementId           Integer  , -- ���� ���������
    IN inDocumentTaxKindId    Integer  , -- ��� ������������ ���������� ���������
   OUT outDocumentTaxKindName TVarChar , --
    IN inSession              TVarChar   -- ������ ������������
)
RETURNS TVarChar
AS
$BODY$
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Tax());

       SELECT Object_TaxKind.ValueData

       INTO outDocumentTaxKindName

       FROM Object AS Object_TaxKind
       WHERE Object_TaxKind.Id = inDocumentTaxKindId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Movement_TaxCorrective_From_Kind (Integer, Integer, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 13.02.14                                                        *
*/

-- ����
--SELECT * FROM gpInsertUpdate_Movement_TaxCorrective_From_Kind(inMovementId := 21838, inDocumentTaxKindId:=80770, inSession := '5'); -- ���
--SELECT gpInsertUpdate_Movement_TaxCorrective_From_Kind FROM gpInsertUpdate_Movement_TaxCorrective_From_Kind(inMovementId := 21838, inDocumentTaxKindId:=80770, inSession := '5'); -- ���