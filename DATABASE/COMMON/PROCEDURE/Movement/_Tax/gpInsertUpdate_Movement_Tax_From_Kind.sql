-- Function: gpInsertUpdate_Movement_Tax_From_Kind()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Tax_From_Kind (Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Tax_From_Kind (
    IN inMovementId           Integer  , -- ���� ���������
    IN inDocumentTaxKindId    Integer  , -- ��� ������������ ���������� ���������
   OUT outDocumentChildName   TVarChar , --
   OUT outDocumentTaxKindName TVarChar , --
    IN inSession              TVarChar   -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbDocumentName TVarChar;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Tax());

       SELECT
             '12345/789'
           , Object_TaxKind.ValueData
       INTO outDocumentChildName, outDocumentTaxKindName
       FROM Object AS Object_TaxKind
       WHERE Object_TaxKind.Id = inDocumentTaxKindId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Movement_Tax_From_Kind (Integer, Integer, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 13.02.14                                                        *
*/

-- ����
--SELECT * FROM gpInsertUpdate_Movement_Tax_From_Kind(inMovementId := 21838, inDocumentTaxKindId:=80770, inSession := '5'); -- ���
--SELECT gpInsertUpdate_Movement_Tax_From_Kind FROM gpInsertUpdate_Movement_Tax_From_Kind(inMovementId := 21838, inDocumentTaxKindId:=80770, inSession := '5'); -- ���